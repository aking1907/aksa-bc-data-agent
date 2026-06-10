namespace AKSA.BCDataAgent;

codeunit 88132 "BCDA Rollback Service"
{
    Access = Internal;

    procedure CreateRollbackRequest(var SourceCorrectionRequest: Record "BCDA Correction Request"; var RollbackRequestId: Code[20])
    var
        SourceCorrectionLine: Record "BCDA Correction Line";
        RollbackCorrectionRequest: Record "BCDA Correction Request";
        AccessMgt: Codeunit "BCDA Access Mgt.";
        AuditWriter: Codeunit "BCDA Audit Writer";
        SetupMgt: Codeunit "BCDA Setup Mgt.";
        RollbackLineCount: Integer;
    begin
        AccessMgt.EnsureSuperUser();
        EnsureSourceRequestCanCreateRollback(SourceCorrectionRequest);
        EnsureNoExistingRollbackRequest(SourceCorrectionRequest);

        RollbackCorrectionRequest.Init();
        SetupMgt.ApplyDefaultsToRequest(RollbackCorrectionRequest);
        RollbackCorrectionRequest.Reason := CopyStr(StrSubstNo(RollbackRequestReasonTxt, SourceCorrectionRequest."Request ID", SourceCorrectionRequest.Reason), 1, MaxStrLen(RollbackCorrectionRequest.Reason));
        RollbackCorrectionRequest."Ticket Reference" := SourceCorrectionRequest."Ticket Reference";
        RollbackCorrectionRequest."Risk Level" := SourceCorrectionRequest."Risk Level";
        RollbackCorrectionRequest.Insert(true);
        RollbackRequestId := RollbackCorrectionRequest."Request ID";

        SourceCorrectionLine.SetRange("Request ID", SourceCorrectionRequest."Request ID");
        if not SourceCorrectionLine.FindSet() then
            Error(SourceRequestHasNoLinesErr, SourceCorrectionRequest."Request ID");

        repeat
            EnsureSourceLineCanCreateRollbackRequest(SourceCorrectionLine);
            CreateRollbackCorrectionLine(RollbackCorrectionRequest, SourceCorrectionLine);
            RollbackLineCount += 1;
        until SourceCorrectionLine.Next() = 0;

        if RollbackLineCount = 0 then
            Error(SourceRequestHasNoLinesErr, SourceCorrectionRequest."Request ID");

        CreateRollbackRequestOperation(SourceCorrectionRequest, RollbackCorrectionRequest);
        AuditWriter.WriteRequestAudit(SourceCorrectionRequest, "BCDA Audit Operation"::Rollback, "BCDA Audit Result"::Success, StrSubstNo(RollbackRequestCreatedFromSourceTxt, RollbackCorrectionRequest."Request ID"));
        AuditWriter.WriteRequestAudit(RollbackCorrectionRequest, "BCDA Audit Operation"::"Request Created", "BCDA Audit Result"::Success, StrSubstNo(RollbackRequestCreatedForSourceTxt, SourceCorrectionRequest."Request ID"));
    end;

    procedure RollbackAuditEntry(var SourceAuditEntry: Record "BCDA Audit Entry")
    begin
        Error(AuditEntryRollbackBlockedErr, SourceAuditEntry."Entry No.");
    end;

    local procedure EnsureSourceRequestCanCreateRollback(SourceCorrectionRequest: Record "BCDA Correction Request")
    begin
        if SourceCorrectionRequest."Request ID" = '' then
            Error(SourceRequestRequiredErr);

        if SourceCorrectionRequest.Status <> SourceCorrectionRequest.Status::Completed then
            Error(SourceRequestStatusErr, SourceCorrectionRequest."Request ID", Format(SourceCorrectionRequest.Status));
    end;

    local procedure EnsureNoExistingRollbackRequest(SourceCorrectionRequest: Record "BCDA Correction Request")
    var
        ExistingRollbackRequest: Record "BCDA Correction Request";
        RollbackOperation: Record "BCDA Rollback Operation";
    begin
        RollbackOperation.SetRange("Source Request ID", SourceCorrectionRequest."Request ID");
        RollbackOperation.SetRange("Source Audit Entry No.", 0);
        if not RollbackOperation.FindSet() then
            exit;

        repeat
            if (RollbackOperation."Generated Request ID" <> '') and ExistingRollbackRequest.Get(RollbackOperation."Generated Request ID") then
                if ExistingRollbackRequest.Status in
                   [ExistingRollbackRequest.Status::Open,
                    ExistingRollbackRequest.Status::"Pending Approval",
                    ExistingRollbackRequest.Status::Approved,
                    ExistingRollbackRequest.Status::Previewed,
                    ExistingRollbackRequest.Status::Executing,
                    ExistingRollbackRequest.Status::Completed]
                then
                    Error(ExistingRollbackRequestErr, ExistingRollbackRequest."Request ID", SourceCorrectionRequest."Request ID");
        until RollbackOperation.Next() = 0;
    end;

    local procedure EnsureSourceLineCanCreateRollbackRequest(SourceCorrectionLine: Record "BCDA Correction Line")
    var
        OldValueSnapshot: Record "BCDA Value Snapshot";
    begin
        if SourceCorrectionLine.Type <> SourceCorrectionLine.Type::Update then
            Error(SourceLineTypeForRequestErr, SourceCorrectionLine."Line No.");

        if SourceCorrectionLine."Line Status" <> SourceCorrectionLine."Line Status"::Executed then
            Error(SourceLineStatusForRequestErr, SourceCorrectionLine."Line No.", Format(SourceCorrectionLine."Line Status"));

        if IsNullGuid(SourceCorrectionLine."Old Value Snapshot ID") then
            Error(SourceLineSnapshotMissingForRequestErr, SourceCorrectionLine."Line No.");

        GetUsableRollbackRequestSnapshot(SourceCorrectionLine, OldValueSnapshot);
    end;

    local procedure CreateRollbackCorrectionLine(RollbackCorrectionRequest: Record "BCDA Correction Request"; SourceCorrectionLine: Record "BCDA Correction Line")
    var
        OldValueSnapshot: Record "BCDA Value Snapshot";
        RollbackCorrectionLine: Record "BCDA Correction Line";
    begin
        GetUsableRollbackRequestSnapshot(SourceCorrectionLine, OldValueSnapshot);

        RollbackCorrectionLine.Init();
        RollbackCorrectionLine."Request ID" := RollbackCorrectionRequest."Request ID";
        RollbackCorrectionLine.Validate(Type, RollbackCorrectionLine.Type::Update);
        RollbackCorrectionLine.Validate("Table ID", SourceCorrectionLine."Table ID");
        RollbackCorrectionLine.Validate("Record ID", SourceCorrectionLine."Record ID");
        RollbackCorrectionLine.Validate("Field ID", SourceCorrectionLine."Field ID");
        RollbackCorrectionLine.Validate("Rollback Snapshot Mode", SourceCorrectionLine."Rollback Snapshot Mode");
        RollbackCorrectionLine.Validate("Validation Mode", SourceCorrectionLine."Validation Mode");
        RollbackCorrectionLine.Validate("Proposed New Value", OldValueSnapshot."Serialized Value");
        RollbackCorrectionLine.Insert(true);
    end;

    local procedure GetUsableRollbackRequestSnapshot(SourceCorrectionLine: Record "BCDA Correction Line"; var OldValueSnapshot: Record "BCDA Value Snapshot")
    begin
        if not OldValueSnapshot.Get(SourceCorrectionLine."Old Value Snapshot ID") then
            Error(SourceLineSnapshotNotFoundForRequestErr, SourceCorrectionLine."Line No.");

        if OldValueSnapshot.Purged then
            Error(SourceLineSnapshotPurgedForRequestErr, SourceCorrectionLine."Line No.");

        if (OldValueSnapshot."Expires At" <> 0DT) and (OldValueSnapshot."Expires At" < CurrentDateTime()) then
            Error(SourceLineSnapshotExpiredForRequestErr, SourceCorrectionLine."Line No.");

        if (OldValueSnapshot."Request ID" <> SourceCorrectionLine."Request ID") or
           (OldValueSnapshot."Line No." <> SourceCorrectionLine."Line No.")
        then
            Error(SourceLineSnapshotMismatchForRequestErr, SourceCorrectionLine."Line No.");
    end;

    local procedure CreateRollbackRequestOperation(SourceCorrectionRequest: Record "BCDA Correction Request"; RollbackCorrectionRequest: Record "BCDA Correction Request")
    var
        RollbackOperation: Record "BCDA Rollback Operation";
    begin
        RollbackOperation.Init();
        RollbackOperation."Source Request ID" := SourceCorrectionRequest."Request ID";
        RollbackOperation."Source Audit Entry No." := 0;
        RollbackOperation."Generated Request ID" := RollbackCorrectionRequest."Request ID";
        RollbackOperation.Status := RollbackOperation.Status::Completed;
        RollbackOperation.Result := RollbackOperation.Result::Success;
        RollbackOperation."Completed By" := CopyStr(UserId(), 1, MaxStrLen(RollbackOperation."Completed By"));
        RollbackOperation."Completed At" := CurrentDateTime();
        RollbackOperation.Insert(true);
    end;

    var
        AuditEntryRollbackBlockedErr: Label 'Rollback from audit entry %1 is no longer supported. Open the completed correction request and create a rollback correction request from there.', Comment = '%1 = audit entry number';
        ExistingRollbackRequestErr: Label 'Rollback request %1 already exists for completed request %2.', Comment = '%1 = existing rollback request ID, %2 = source request ID';
        RollbackRequestCreatedForSourceTxt: Label 'Rollback request created from completed request %1.', Comment = '%1 = source request ID';
        RollbackRequestCreatedFromSourceTxt: Label 'Rollback correction request %1 was created for review and execution.', Comment = '%1 = rollback request ID';
        RollbackRequestReasonTxt: Label 'Rollback request for %1. Original reason: %2', Comment = '%1 = source request ID, %2 = source request reason';
        SourceLineSnapshotExpiredForRequestErr: Label 'Line %1 rollback snapshot has expired; a rollback request cannot be created for only part of the completed request.', Comment = '%1 = line number';
        SourceLineSnapshotMissingForRequestErr: Label 'Line %1 has no retained old-value snapshot; rollback request creation is unavailable for this completed request.', Comment = '%1 = line number';
        SourceLineSnapshotMismatchForRequestErr: Label 'Line %1 old-value snapshot does not match the source correction line.', Comment = '%1 = line number';
        SourceLineSnapshotNotFoundForRequestErr: Label 'Line %1 old-value snapshot was not found; rollback request creation is unavailable for this completed request.', Comment = '%1 = line number';
        SourceLineSnapshotPurgedForRequestErr: Label 'Line %1 rollback snapshot has been purged; a rollback request cannot be created for only part of the completed request.', Comment = '%1 = line number';
        SourceLineStatusForRequestErr: Label 'Line %1 must be executed before a request-level rollback can be staged. Current line status is %2.', Comment = '%1 = line number, %2 = line status';
        SourceLineTypeForRequestErr: Label 'Line %1 is not a supported Update line for request-level rollback staging.', Comment = '%1 = line number';
        SourceRequestHasNoLinesErr: Label 'Completed request %1 has no correction lines to stage for rollback.', Comment = '%1 = request ID';
        SourceRequestRequiredErr: Label 'Select a completed correction request before creating a rollback request.';
        SourceRequestStatusErr: Label 'Request %1 must be completed before a rollback request can be created. Current status is %2.', Comment = '%1 = request ID, %2 = request status';
}
