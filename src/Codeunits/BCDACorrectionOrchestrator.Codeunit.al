namespace AKSA.BCDataAgent;

using System.Reflection;

codeunit 88125 "BCDA Correction Orchestrator"
{
    Access = Internal;

    procedure InitializeRequest(var CorrectionRequest: Record "BCDA Correction Request")
    var
        AccessMgt: Codeunit "BCDA Access Mgt.";
        AuditWriter: Codeunit "BCDA Audit Writer";
        SetupMgt: Codeunit "BCDA Setup Mgt.";
    begin
        AccessMgt.EnsureSuperUser();
        SetupMgt.ApplyDefaultsToRequest(CorrectionRequest);
        SaveRequest(CorrectionRequest);
        AuditWriter.WriteRequestAudit(CorrectionRequest, "BCDA Audit Operation"::"Request Created", "BCDA Audit Result"::Success, '');
    end;

    procedure SubmitForApproval(var CorrectionRequest: Record "BCDA Correction Request")
    var
        AccessMgt: Codeunit "BCDA Access Mgt.";
        AuditWriter: Codeunit "BCDA Audit Writer";
    begin
        AccessMgt.EnsureSuperUser();
        EnsureExistingRequest(CorrectionRequest);
        EnsureRequestMetadata(CorrectionRequest);
        EnsureApprovalRequired(CorrectionRequest);
        EnsureRequiredPreviewCompleted(CorrectionRequest);

        CorrectionRequest.Status := CorrectionRequest.Status::"Pending Approval";
        CorrectionRequest.Modify(true);
        AuditWriter.WriteRequestAudit(CorrectionRequest, "BCDA Audit Operation"::Approval, "BCDA Audit Result"::Success, '');
    end;

    procedure Approve(var CorrectionRequest: Record "BCDA Correction Request")
    var
        AccessMgt: Codeunit "BCDA Access Mgt.";
        AuditWriter: Codeunit "BCDA Audit Writer";
    begin
        AccessMgt.EnsureSuperUser();
        EnsureExistingRequest(CorrectionRequest);
        EnsureRequestMetadata(CorrectionRequest);
        EnsureApprovalRequired(CorrectionRequest);
        EnsurePendingApproval(CorrectionRequest);
        EnsureRequiredPreviewCompleted(CorrectionRequest);
        EnsureApproverAllowed(CorrectionRequest);

        CorrectionRequest.Status := CorrectionRequest.Status::Approved;
        CorrectionRequest."Approved By" := CopyStr(UserId(), 1, MaxStrLen(CorrectionRequest."Approved By"));
        CorrectionRequest."Approved At" := CurrentDateTime();
        CorrectionRequest.Modify(true);
        AuditWriter.WriteRequestAudit(CorrectionRequest, "BCDA Audit Operation"::Approval, "BCDA Audit Result"::Success, '');
    end;

    procedure MarkPreviewed(var CorrectionRequest: Record "BCDA Correction Request")
    var
        AccessMgt: Codeunit "BCDA Access Mgt.";
        AuditWriter: Codeunit "BCDA Audit Writer";
        PreviewResult: Enum "BCDA Audit Result";
        PreviewMessage: Text[2048];
    begin
        AccessMgt.EnsureSuperUser();
        EnsureExistingRequest(CorrectionRequest);
        EnsurePreviewAllowed(CorrectionRequest);
        EnsureRequestMetadata(CorrectionRequest);
        BuildRequestPreview(CorrectionRequest, PreviewResult, PreviewMessage);

        CorrectionRequest.Status := CorrectionRequest.Status::Previewed;
        CorrectionRequest."Last Preview At" := CurrentDateTime();
        CorrectionRequest.Modify(true);
        AuditWriter.WriteRequestAudit(CorrectionRequest, "BCDA Audit Operation"::Preview, PreviewResult, PreviewMessage);
    end;

    procedure ExecuteRequest(var CorrectionRequest: Record "BCDA Correction Request")
    var
        AccessMgt: Codeunit "BCDA Access Mgt.";
        AuditWriter: Codeunit "BCDA Audit Writer";
        SetupMgt: Codeunit "BCDA Setup Mgt.";
        ExecutionMessage: Text[2048];
        SuccessCount: Integer;
        RequestApproved: Boolean;
    begin
        AccessMgt.EnsureSuperUser();
        SetupMgt.EnsureSetup();
        EnsureExistingRequest(CorrectionRequest);
        EnsureRequestMetadata(CorrectionRequest);
        EnsureExecutionAllowed(CorrectionRequest);
        EnsureRequiredPreviewCompleted(CorrectionRequest);

        RequestApproved := CorrectionRequest.Status = CorrectionRequest.Status::Approved;
        if not TryValidateExecutionRequest(CorrectionRequest, RequestApproved) then begin
            ExecutionMessage := CopyStr(GetLastErrorText(), 1, MaxStrLen(ExecutionMessage));
            MarkExecutionRequestPreflightFailed(CorrectionRequest, ExecutionMessage);
            exit;
        end;

        CorrectionRequest.Status := CorrectionRequest.Status::Executing;
        CorrectionRequest."Rollback Availability" := ResolveExecutionRollbackAvailability(CorrectionRequest);
        CorrectionRequest.Modify(true);

        ProcessExecutionGroups(CorrectionRequest, SuccessCount);

        ExecutionMessage := CopyStr(StrSubstNo(ExecutionSummaryTxt, SuccessCount), 1, MaxStrLen(ExecutionMessage));
        CorrectionRequest.Status := CorrectionRequest.Status::Completed;
        CorrectionRequest.Modify(true);
        AuditWriter.WriteRequestAudit(CorrectionRequest, "BCDA Audit Operation"::Execution, "BCDA Audit Result"::Success, ExecutionMessage);
    end;

    local procedure EnsureExistingRequest(CorrectionRequest: Record "BCDA Correction Request")
    begin
        if CorrectionRequest."Request ID" = '' then
            Error(RequestRequiredErr);
    end;

    local procedure EnsureRequestMetadata(CorrectionRequest: Record "BCDA Correction Request")
    begin
        if not CorrectionRequest.HasRequiredMetadata() then
            Error(MissingMetadataErr);
    end;

    local procedure EnsureApproverAllowed(CorrectionRequest: Record "BCDA Correction Request")
    begin
        if not CorrectionRequest."Require Separate Approver" then
            exit;

        if CorrectionRequest."Requested By" = CopyStr(UserId(), 1, MaxStrLen(CorrectionRequest."Requested By")) then
            Error(SecondSuperApprovalErr);
    end;

    local procedure EnsureApprovalRequired(CorrectionRequest: Record "BCDA Correction Request")
    begin
        if not CorrectionRequest."Approval Required" then
            Error(ApprovalNotRequiredErr);
    end;

    local procedure EnsurePendingApproval(CorrectionRequest: Record "BCDA Correction Request")
    begin
        if CorrectionRequest.Status <> CorrectionRequest.Status::"Pending Approval" then
            Error(PendingApprovalRequiredErr);
    end;

    local procedure EnsurePreviewAllowed(CorrectionRequest: Record "BCDA Correction Request")
    begin
        if (CorrectionRequest.Status <> CorrectionRequest.Status::Open) and
           (CorrectionRequest.Status <> CorrectionRequest.Status::Previewed)
        then
            Error(PreviewStatusErr);
    end;

    local procedure EnsureExecutionAllowed(CorrectionRequest: Record "BCDA Correction Request")
    begin
        if CorrectionRequest."Approval Required" then begin
            if CorrectionRequest.Status <> CorrectionRequest.Status::Approved then
                Error(ExecutionApprovalRequiredErr);

            exit;
        end;

        if (CorrectionRequest.Status <> CorrectionRequest.Status::Open) and
           (CorrectionRequest.Status <> CorrectionRequest.Status::Previewed)
        then
            Error(ExecutionStatusErr);
    end;

    local procedure EnsureRequiredPreviewCompleted(CorrectionRequest: Record "BCDA Correction Request")
    var
        CorrectionLine: Record "BCDA Correction Line";
    begin
        if not CorrectionRequest."Preview Required" then
            exit;

        if CorrectionRequest."Last Preview At" = 0DT then
            Error(PreviewRequiredBeforeApprovalErr);

        CorrectionLine.SetRange("Request ID", CorrectionRequest."Request ID");
        if not CorrectionLine.FindSet() then
            Error(NoLinesForPreviewErr, CorrectionRequest."Request ID");

        repeat
            if CorrectionLine."Line Status" <> CorrectionLine."Line Status"::Previewed then
                Error(PreviewLineNotReadyErr, CorrectionLine."Line No.", Format(CorrectionLine."Line Status"));
        until CorrectionLine.Next() = 0;
    end;

    local procedure SaveRequest(var CorrectionRequest: Record "BCDA Correction Request")
    begin
        if CorrectionRequest."Request ID" = '' then
            CorrectionRequest.Insert(true)
        else
            CorrectionRequest.Modify(true);
    end;

    local procedure BuildRequestPreview(var CorrectionRequest: Record "BCDA Correction Request"; var PreviewResult: Enum "BCDA Audit Result"; var PreviewMessage: Text[2048])
    var
        CorrectionLine: Record "BCDA Correction Line";
        Setup: Record "BCDA Setup";
        SetupMgt: Codeunit "BCDA Setup Mgt.";
        Decision: Enum "BCDA Policy Decision";
        DecisionReason: Text[250];
        BlockedCount: Integer;
        FailedCount: Integer;
        LineCount: Integer;
        ApprovalRequiredCount: Integer;
    begin
        SetupMgt.GetSetup(Setup);
        CorrectionRequest."Rollback Availability" := ResolvePreviewRollbackAvailability(CorrectionRequest, Setup."Rollback Snapshot Default");
        CorrectionRequest."Retention Impact" := StrSubstNo(RetentionImpactTxt, Setup."Audit Retention Days", Setup."Snapshot Retention Days", Setup."Technical Log Retention Days");

        CorrectionLine.SetRange("Request ID", CorrectionRequest."Request ID");
        if not CorrectionLine.FindSet() then
            Error(NoLinesForPreviewErr, CorrectionRequest."Request ID");

        repeat
            LineCount += 1;
            Clear(DecisionReason);
            Decision := Decision::Block;

            if not TryPreviewLine(CorrectionLine, Decision, DecisionReason) then begin
                FailedCount += 1;
                CorrectionLine."Line Status" := CorrectionLine."Line Status"::Failed;
                CorrectionLine."Sanitized Error" := CopyStr(GetLastErrorText(), 1, MaxStrLen(CorrectionLine."Sanitized Error"));
            end else
                case Decision of
                    Decision::Block:
                        begin
                            BlockedCount += 1;
                            CorrectionLine."Line Status" := CorrectionLine."Line Status"::Failed;
                            CorrectionLine."Sanitized Error" := CopyStr(DecisionReason, 1, MaxStrLen(CorrectionLine."Sanitized Error"));
                        end;
                    Decision::"Approval Required":
                        begin
                            ApprovalRequiredCount += 1;
                            CorrectionLine."Line Status" := CorrectionLine."Line Status"::Previewed;
                            CorrectionLine."Sanitized Error" := CopyStr(DecisionReason, 1, MaxStrLen(CorrectionLine."Sanitized Error"));
                        end;
                    else begin
                        CorrectionLine."Line Status" := CorrectionLine."Line Status"::Previewed;
                        Clear(CorrectionLine."Sanitized Error");
                    end;
                end;

            CorrectionLine.Modify(true);
        until CorrectionLine.Next() = 0;

        if (FailedCount <> 0) or (BlockedCount <> 0) or (ApprovalRequiredCount <> 0) then
            PreviewResult := PreviewResult::Warning
        else
            PreviewResult := PreviewResult::Success;

        PreviewMessage := CopyStr(StrSubstNo(PreviewSummaryTxt, LineCount, FailedCount, BlockedCount, ApprovalRequiredCount), 1, MaxStrLen(PreviewMessage));
    end;

    [TryFunction]
    local procedure TryPreviewLine(var CorrectionLine: Record "BCDA Correction Line"; var Decision: Enum "BCDA Policy Decision"; var DecisionReason: Text[250])
    var
        CurrentValueMgt: Codeunit "BCDA Current Value Mgt.";
        PolicyGuard: Codeunit "BCDA Policy Guard";
    begin
        ValidateLinePreviewShape(CorrectionLine);
        CurrentValueMgt.UpdateCurrentValuePreview(CorrectionLine);
        CorrectionLine.ValidateDataValue();
        PolicyGuard.EvaluateLine(CorrectionLine, Decision, DecisionReason);
    end;

    local procedure ValidateLinePreviewShape(CorrectionLine: Record "BCDA Correction Line")
    begin
        if CorrectionLine."Table ID" = 0 then
            Error(LineTableRequiredErr, CorrectionLine."Line No.");

        case CorrectionLine.Type of
            CorrectionLine.Type::Update,
            CorrectionLine.Type::Rename:
                begin
                    EnsureLineHasRecordId(CorrectionLine);
                    if CorrectionLine."Field ID" = 0 then
                        Error(LineFieldRequiredErr, CorrectionLine."Line No.");
                end;
            CorrectionLine.Type::Delete:
                begin
                    EnsureLineHasRecordId(CorrectionLine);
                    EnsureLineRecordExists(CorrectionLine);
                    if CorrectionLine."Field ID" <> 0 then
                        Error(LineFieldNotAllowedForDeleteErr, CorrectionLine."Line No.");
                    if CorrectionLine."Proposed New Value" <> '' then
                        Error(LineProposedValueNotAllowedForDeleteErr, CorrectionLine."Line No.");
                end;
            CorrectionLine.Type::Insert:
                begin
                    EnsureLineRecordIdEmpty(CorrectionLine);
                    EnsureLineHasInsertGroupNo(CorrectionLine);
                    if CorrectionLine."Field ID" = 0 then
                        Error(LineFieldRequiredErr, CorrectionLine."Line No.");
                end;
        end;
    end;

    local procedure EnsureLineHasRecordId(CorrectionLine: Record "BCDA Correction Line")
    var
        EmptyRecordId: RecordId;
    begin
        if CorrectionLine."Record ID" = EmptyRecordId then
            Error(LineRecordRequiredErr, CorrectionLine."Line No.");

        if CorrectionLine."Record ID".TableNo() <> CorrectionLine."Table ID" then
            Error(LineRecordTableMismatchErr, CorrectionLine."Line No.", CorrectionLine."Record ID", CorrectionLine."Table ID");
    end;

    local procedure EnsureLineRecordExists(CorrectionLine: Record "BCDA Correction Line")
    var
        TargetRecordRef: RecordRef;
    begin
        if not TargetRecordRef.Get(CorrectionLine."Record ID") then
            Error(LineRecordNotFoundErr, CorrectionLine."Line No.");

        TargetRecordRef.Close();
    end;

    local procedure EnsureLineRecordIdEmpty(CorrectionLine: Record "BCDA Correction Line")
    var
        EmptyRecordId: RecordId;
    begin
        if CorrectionLine."Record ID" <> EmptyRecordId then
            Error(LineRecordMustBeEmptyForInsertErr, CorrectionLine."Line No.");
    end;

    local procedure EnsureLineHasInsertGroupNo(CorrectionLine: Record "BCDA Correction Line")
    begin
        if CorrectionLine."Insert Group No." <= 0 then
            Error(LineInsertGroupRequiredErr, CorrectionLine."Line No.");
    end;

    [TryFunction]
    local procedure TryValidateExecutionRequest(CorrectionRequest: Record "BCDA Correction Request"; RequestApproved: Boolean)
    begin
        ValidateExecutionGroups(CorrectionRequest, RequestApproved);
    end;

    local procedure ValidateExecutionGroups(CorrectionRequest: Record "BCDA Correction Request"; RequestApproved: Boolean)
    var
        TempExecutionGroup: Record "BCDA Correction Line" temporary;
    begin
        BuildExecutionGroups(CorrectionRequest, TempExecutionGroup);

        ValidateExecutionGroupsByType(RequestApproved, TempExecutionGroup, "BCDA Correction Type"::Update);
        ValidateExecutionGroupsByType(RequestApproved, TempExecutionGroup, "BCDA Correction Type"::Rename);
        ValidateExecutionGroupsByType(RequestApproved, TempExecutionGroup, "BCDA Correction Type"::Delete);
        ValidateExecutionGroupsByType(RequestApproved, TempExecutionGroup, "BCDA Correction Type"::Insert);
    end;

    local procedure ValidateExecutionGroupsByType(RequestApproved: Boolean; var TempExecutionGroup: Record "BCDA Correction Line" temporary; CurrentType: Enum "BCDA Correction Type")
    var
        TempGroupLine: Record "BCDA Correction Line" temporary;
    begin
        TempExecutionGroup.Reset();
        TempExecutionGroup.SetRange(Type, CurrentType);
        if TempExecutionGroup.FindSet() then
            repeat
                LoadExecutionGroupLines(TempExecutionGroup, TempGroupLine);
                ValidateExecutionGroup(RequestApproved, TempGroupLine, CurrentType);
            until TempExecutionGroup.Next() = 0;
        TempExecutionGroup.Reset();
    end;

    local procedure ValidateExecutionGroup(RequestApproved: Boolean; var TempGroupLine: Record "BCDA Correction Line" temporary; CurrentType: Enum "BCDA Correction Type")
    begin
        case CurrentType of
            CurrentType::Update:
                ValidateUpdateExecutionGroup(RequestApproved, TempGroupLine);
            CurrentType::Rename:
                ValidateRenameExecutionGroup(RequestApproved, TempGroupLine);
            CurrentType::Delete:
                ValidateDeleteExecutionGroup(RequestApproved, TempGroupLine);
            CurrentType::Insert:
                ValidateInsertExecutionGroup(RequestApproved, TempGroupLine);
            else
                Error(UnsupportedExecutionTypeErr, Format(CurrentType));
        end;
    end;

    local procedure ProcessExecutionGroups(var CorrectionRequest: Record "BCDA Correction Request"; var SuccessCount: Integer)
    var
        TempExecutionGroup: Record "BCDA Correction Line" temporary;
    begin
        BuildExecutionGroups(CorrectionRequest, TempExecutionGroup);

        ProcessExecutionGroupsByType(CorrectionRequest, TempExecutionGroup, "BCDA Correction Type"::Update, SuccessCount);
        ProcessExecutionGroupsByType(CorrectionRequest, TempExecutionGroup, "BCDA Correction Type"::Rename, SuccessCount);
        ProcessExecutionGroupsByType(CorrectionRequest, TempExecutionGroup, "BCDA Correction Type"::Delete, SuccessCount);
        ProcessExecutionGroupsByType(CorrectionRequest, TempExecutionGroup, "BCDA Correction Type"::Insert, SuccessCount);
    end;

    local procedure ProcessExecutionGroupsByType(var CorrectionRequest: Record "BCDA Correction Request"; var TempExecutionGroup: Record "BCDA Correction Line" temporary; CurrentType: Enum "BCDA Correction Type"; var SuccessCount: Integer)
    var
        TempGroupLine: Record "BCDA Correction Line" temporary;
    begin
        TempExecutionGroup.Reset();
        TempExecutionGroup.SetRange(Type, CurrentType);
        if TempExecutionGroup.FindSet() then
            repeat
                LoadExecutionGroupLines(TempExecutionGroup, TempGroupLine);
                ProcessExecutionGroup(CorrectionRequest, TempGroupLine, CurrentType, SuccessCount);
            until TempExecutionGroup.Next() = 0;
        TempExecutionGroup.Reset();
    end;

    local procedure BuildExecutionGroups(CorrectionRequest: Record "BCDA Correction Request"; var TempExecutionGroup: Record "BCDA Correction Line" temporary)
    var
        CorrectionLine: Record "BCDA Correction Line";
    begin
        TempExecutionGroup.Reset();
        TempExecutionGroup.DeleteAll();

        CorrectionLine.SetCurrentKey("Request ID", Type, "Table ID", "Record ID", "Insert Group No.");
        CorrectionLine.SetRange("Request ID", CorrectionRequest."Request ID");
        if not CorrectionLine.FindSet() then
            Error(NoLinesForExecutionErr, CorrectionRequest."Request ID");

        repeat
            AddExecutionGroupIfMissing(TempExecutionGroup, CorrectionLine);
        until CorrectionLine.Next() = 0;
    end;

    local procedure AddExecutionGroupIfMissing(var TempExecutionGroup: Record "BCDA Correction Line" temporary; CorrectionLine: Record "BCDA Correction Line")
    begin
        TempExecutionGroup.Reset();
        TempExecutionGroup.SetRange("Request ID", CorrectionLine."Request ID");
        TempExecutionGroup.SetRange(Type, CorrectionLine.Type);
        TempExecutionGroup.SetRange("Table ID", CorrectionLine."Table ID");
        TempExecutionGroup.SetRange("Record ID", CorrectionLine."Record ID");
        TempExecutionGroup.SetRange("Insert Group No.", CorrectionLine."Insert Group No.");
        if not TempExecutionGroup.IsEmpty() then begin
            TempExecutionGroup.Reset();
            exit;
        end;

        TempExecutionGroup.Reset();
        TempExecutionGroup := CorrectionLine;
        TempExecutionGroup.Insert();
    end;

    local procedure LoadExecutionGroupLines(GroupLine: Record "BCDA Correction Line"; var TempGroupLine: Record "BCDA Correction Line" temporary)
    var
        CorrectionLine: Record "BCDA Correction Line";
    begin
        ClearExecutionGroup(TempGroupLine);

        CorrectionLine.SetCurrentKey("Request ID", Type, "Table ID", "Record ID", "Insert Group No.");
        CorrectionLine.SetRange("Request ID", GroupLine."Request ID");
        CorrectionLine.SetRange(Type, GroupLine.Type);
        CorrectionLine.SetRange("Table ID", GroupLine."Table ID");
        CorrectionLine.SetRange("Record ID", GroupLine."Record ID");
        CorrectionLine.SetRange("Insert Group No.", GroupLine."Insert Group No.");
        if not CorrectionLine.FindSet() then
            Error(NoLinesForExecutionErr, GroupLine."Request ID");

        repeat
            AddLineToExecutionGroup(TempGroupLine, CorrectionLine);
        until CorrectionLine.Next() = 0;
    end;

    local procedure ClearExecutionGroup(var TempGroupLine: Record "BCDA Correction Line" temporary)
    begin
        TempGroupLine.Reset();
        TempGroupLine.DeleteAll();
    end;

    local procedure AddLineToExecutionGroup(var TempGroupLine: Record "BCDA Correction Line" temporary; CorrectionLine: Record "BCDA Correction Line")
    begin
        TempGroupLine := CorrectionLine;
        TempGroupLine.Insert();
    end;

    local procedure ProcessExecutionGroup(var CorrectionRequest: Record "BCDA Correction Request"; var TempGroupLine: Record "BCDA Correction Line" temporary; CurrentType: Enum "BCDA Correction Type"; var SuccessCount: Integer)
    begin
        case CurrentType of
            CurrentType::Update:
                begin
                    ApplyUpdateExecutionGroup(TempGroupLine);
                    MarkExecutionGroupSucceeded(CorrectionRequest, TempGroupLine, SuccessCount);
                end;
            CurrentType::Rename:
                begin
                    ApplyRenameExecutionGroup(TempGroupLine);
                    MarkExecutionGroupSucceeded(CorrectionRequest, TempGroupLine, SuccessCount);
                end;
            CurrentType::Delete:
                begin
                    ApplyDeleteExecutionGroup(TempGroupLine);
                    MarkExecutionGroupSucceeded(CorrectionRequest, TempGroupLine, SuccessCount);
                end;
            CurrentType::Insert:
                begin
                    ApplyInsertExecutionGroup(TempGroupLine);
                    MarkExecutionGroupSucceeded(CorrectionRequest, TempGroupLine, SuccessCount);
                end;
            else
                Error(UnsupportedExecutionTypeErr, Format(CurrentType));
        end;
    end;

    local procedure ApplyUpdateExecutionGroup(var TempGroupLine: Record "BCDA Correction Line" temporary)
    var
        FieldMetadata: Record "Field";
        TargetFieldRef: FieldRef;
        TargetRecordRef: RecordRef;
    begin
        TempGroupLine.Reset();
        TempGroupLine.FindFirst();
        if not TargetRecordRef.Get(TempGroupLine."Record ID") then
            Error(LineRecordNotFoundErr, TempGroupLine."Line No.");

        TempGroupLine.Reset();
        if TempGroupLine.FindSet() then
            repeat
                FieldMetadata.Get(TempGroupLine."Table ID", TempGroupLine."Field ID");
                TargetFieldRef := TargetRecordRef.Field(TempGroupLine."Field ID");
                TempGroupLine."Current Value Preview" := CopyStr(Format(TargetFieldRef.Value()), 1, MaxStrLen(TempGroupLine."Current Value Preview"));
                SetTargetFieldValue(TargetFieldRef, FieldMetadata, TempGroupLine."Proposed New Value");
                TempGroupLine."Sanitized Error" := CopyStr(Format(TargetFieldRef.Value()), 1, MaxStrLen(TempGroupLine."Sanitized Error"));
                TempGroupLine.Modify();
            until TempGroupLine.Next() = 0;

        TargetRecordRef.Modify(true);
        TargetRecordRef.Close();
    end;

    local procedure ApplyRenameExecutionGroup(var TempGroupLine: Record "BCDA Correction Line" temporary)
    var
        RenamedRecordId: RecordId;
        TargetRecordRef: RecordRef;
        RenameKeyValue: array[20] of Variant;
        RenameKeyValueCount: Integer;
    begin
        TempGroupLine.Reset();
        TempGroupLine.FindFirst();
        if not TargetRecordRef.Get(TempGroupLine."Record ID") then
            Error(LineRecordNotFoundErr, TempGroupLine."Line No.");

        BuildRenameKeyValues(TempGroupLine, TargetRecordRef, RenameKeyValue, RenameKeyValueCount);
        if not RenameTargetRecord(TargetRecordRef, RenameKeyValue, RenameKeyValueCount) then
            Error(RenameFailedErr, TempGroupLine."Table ID", TempGroupLine."Record ID");

        RenamedRecordId := TargetRecordRef.RecordId();
        TargetRecordRef.Close();

        TempGroupLine.Reset();
        if TempGroupLine.FindSet() then
            repeat
                TempGroupLine."Record ID" := RenamedRecordId;
                TempGroupLine.Modify();
            until TempGroupLine.Next() = 0;
    end;

    local procedure BuildRenameKeyValues(var TempGroupLine: Record "BCDA Correction Line" temporary; var TargetRecordRef: RecordRef; var RenameKeyValue: array[20] of Variant; var RenameKeyValueCount: Integer)
    var
        FieldMetadata: Record "Field";
        CurrentRecordId: RecordId;
        ConversionRecordRef: RecordRef;
        ConversionFieldRef: FieldRef;
        CurrentFieldRef: FieldRef;
        KeyFieldRef: FieldRef;
        KeyRef: KeyRef;
        KeyValue: Variant;
        Index: Integer;
    begin
        Clear(RenameKeyValue);
        RenameKeyValueCount := 0;
        TempGroupLine.Reset();
        TempGroupLine.FindFirst();
        CurrentRecordId := TempGroupLine."Record ID";

        ConversionRecordRef.Get(CurrentRecordId);
        KeyRef := TargetRecordRef.KeyIndex(1);
        for Index := 1 to KeyRef.FieldCount() do begin
            if Index > 20 then
                Error(RenamePrimaryKeyFieldLimitErr, KeyRef.FieldCount());

            KeyFieldRef := KeyRef.FieldIndex(Index);
            CurrentFieldRef := TargetRecordRef.Field(KeyFieldRef.Number());
            KeyValue := CurrentFieldRef.Value();

            TempGroupLine.Reset();
            TempGroupLine.SetRange("Field ID", KeyFieldRef.Number());
            if TempGroupLine.FindFirst() then begin
                FieldMetadata.Get(TempGroupLine."Table ID", TempGroupLine."Field ID");
                ConversionFieldRef := ConversionRecordRef.Field(TempGroupLine."Field ID");
                TempGroupLine."Current Value Preview" := CopyStr(Format(CurrentFieldRef.Value()), 1, MaxStrLen(TempGroupLine."Current Value Preview"));
                SetTargetFieldValue(ConversionFieldRef, FieldMetadata, TempGroupLine."Proposed New Value");
                KeyValue := ConversionFieldRef.Value();
                TempGroupLine."Sanitized Error" := CopyStr(Format(KeyValue), 1, MaxStrLen(TempGroupLine."Sanitized Error"));
                TempGroupLine.Modify();
            end;

            RenameKeyValue[Index] := KeyValue;
            RenameKeyValueCount += 1;
        end;

        TempGroupLine.Reset();
        ConversionRecordRef.Close();
    end;

    local procedure RenameTargetRecord(var TargetRecordRef: RecordRef; RenameKeyValue: array[20] of Variant; RenameKeyValueCount: Integer): Boolean
    begin
        case RenameKeyValueCount of
            1:
                exit(TargetRecordRef.Rename(RenameKeyValue[1]));
            2:
                exit(TargetRecordRef.Rename(RenameKeyValue[1], RenameKeyValue[2]));
            3:
                exit(TargetRecordRef.Rename(RenameKeyValue[1], RenameKeyValue[2], RenameKeyValue[3]));
            4:
                exit(TargetRecordRef.Rename(RenameKeyValue[1], RenameKeyValue[2], RenameKeyValue[3], RenameKeyValue[4]));
            5:
                exit(TargetRecordRef.Rename(RenameKeyValue[1], RenameKeyValue[2], RenameKeyValue[3], RenameKeyValue[4], RenameKeyValue[5]));
            6:
                exit(TargetRecordRef.Rename(RenameKeyValue[1], RenameKeyValue[2], RenameKeyValue[3], RenameKeyValue[4], RenameKeyValue[5], RenameKeyValue[6]));
            7:
                exit(TargetRecordRef.Rename(RenameKeyValue[1], RenameKeyValue[2], RenameKeyValue[3], RenameKeyValue[4], RenameKeyValue[5], RenameKeyValue[6], RenameKeyValue[7]));
            8:
                exit(TargetRecordRef.Rename(RenameKeyValue[1], RenameKeyValue[2], RenameKeyValue[3], RenameKeyValue[4], RenameKeyValue[5], RenameKeyValue[6], RenameKeyValue[7], RenameKeyValue[8]));
            9:
                exit(TargetRecordRef.Rename(RenameKeyValue[1], RenameKeyValue[2], RenameKeyValue[3], RenameKeyValue[4], RenameKeyValue[5], RenameKeyValue[6], RenameKeyValue[7], RenameKeyValue[8], RenameKeyValue[9]));
            10:
                exit(TargetRecordRef.Rename(RenameKeyValue[1], RenameKeyValue[2], RenameKeyValue[3], RenameKeyValue[4], RenameKeyValue[5], RenameKeyValue[6], RenameKeyValue[7], RenameKeyValue[8], RenameKeyValue[9], RenameKeyValue[10]));
            11:
                exit(TargetRecordRef.Rename(RenameKeyValue[1], RenameKeyValue[2], RenameKeyValue[3], RenameKeyValue[4], RenameKeyValue[5], RenameKeyValue[6], RenameKeyValue[7], RenameKeyValue[8], RenameKeyValue[9], RenameKeyValue[10], RenameKeyValue[11]));
            12:
                exit(TargetRecordRef.Rename(RenameKeyValue[1], RenameKeyValue[2], RenameKeyValue[3], RenameKeyValue[4], RenameKeyValue[5], RenameKeyValue[6], RenameKeyValue[7], RenameKeyValue[8], RenameKeyValue[9], RenameKeyValue[10], RenameKeyValue[11], RenameKeyValue[12]));
            13:
                exit(TargetRecordRef.Rename(RenameKeyValue[1], RenameKeyValue[2], RenameKeyValue[3], RenameKeyValue[4], RenameKeyValue[5], RenameKeyValue[6], RenameKeyValue[7], RenameKeyValue[8], RenameKeyValue[9], RenameKeyValue[10], RenameKeyValue[11], RenameKeyValue[12], RenameKeyValue[13]));
            14:
                exit(TargetRecordRef.Rename(RenameKeyValue[1], RenameKeyValue[2], RenameKeyValue[3], RenameKeyValue[4], RenameKeyValue[5], RenameKeyValue[6], RenameKeyValue[7], RenameKeyValue[8], RenameKeyValue[9], RenameKeyValue[10], RenameKeyValue[11], RenameKeyValue[12], RenameKeyValue[13], RenameKeyValue[14]));
            15:
                exit(TargetRecordRef.Rename(RenameKeyValue[1], RenameKeyValue[2], RenameKeyValue[3], RenameKeyValue[4], RenameKeyValue[5], RenameKeyValue[6], RenameKeyValue[7], RenameKeyValue[8], RenameKeyValue[9], RenameKeyValue[10], RenameKeyValue[11], RenameKeyValue[12], RenameKeyValue[13], RenameKeyValue[14], RenameKeyValue[15]));
            16:
                exit(TargetRecordRef.Rename(RenameKeyValue[1], RenameKeyValue[2], RenameKeyValue[3], RenameKeyValue[4], RenameKeyValue[5], RenameKeyValue[6], RenameKeyValue[7], RenameKeyValue[8], RenameKeyValue[9], RenameKeyValue[10], RenameKeyValue[11], RenameKeyValue[12], RenameKeyValue[13], RenameKeyValue[14], RenameKeyValue[15], RenameKeyValue[16]));
            17:
                exit(TargetRecordRef.Rename(RenameKeyValue[1], RenameKeyValue[2], RenameKeyValue[3], RenameKeyValue[4], RenameKeyValue[5], RenameKeyValue[6], RenameKeyValue[7], RenameKeyValue[8], RenameKeyValue[9], RenameKeyValue[10], RenameKeyValue[11], RenameKeyValue[12], RenameKeyValue[13], RenameKeyValue[14], RenameKeyValue[15], RenameKeyValue[16], RenameKeyValue[17]));
            18:
                exit(TargetRecordRef.Rename(RenameKeyValue[1], RenameKeyValue[2], RenameKeyValue[3], RenameKeyValue[4], RenameKeyValue[5], RenameKeyValue[6], RenameKeyValue[7], RenameKeyValue[8], RenameKeyValue[9], RenameKeyValue[10], RenameKeyValue[11], RenameKeyValue[12], RenameKeyValue[13], RenameKeyValue[14], RenameKeyValue[15], RenameKeyValue[16], RenameKeyValue[17], RenameKeyValue[18]));
            19:
                exit(TargetRecordRef.Rename(RenameKeyValue[1], RenameKeyValue[2], RenameKeyValue[3], RenameKeyValue[4], RenameKeyValue[5], RenameKeyValue[6], RenameKeyValue[7], RenameKeyValue[8], RenameKeyValue[9], RenameKeyValue[10], RenameKeyValue[11], RenameKeyValue[12], RenameKeyValue[13], RenameKeyValue[14], RenameKeyValue[15], RenameKeyValue[16], RenameKeyValue[17], RenameKeyValue[18], RenameKeyValue[19]));
            20:
                exit(TargetRecordRef.Rename(RenameKeyValue[1], RenameKeyValue[2], RenameKeyValue[3], RenameKeyValue[4], RenameKeyValue[5], RenameKeyValue[6], RenameKeyValue[7], RenameKeyValue[8], RenameKeyValue[9], RenameKeyValue[10], RenameKeyValue[11], RenameKeyValue[12], RenameKeyValue[13], RenameKeyValue[14], RenameKeyValue[15], RenameKeyValue[16], RenameKeyValue[17], RenameKeyValue[18], RenameKeyValue[19], RenameKeyValue[20]));
        end;

        Error(RenamePrimaryKeyFieldLimitErr, RenameKeyValueCount);
    end;

    local procedure ApplyDeleteExecutionGroup(var TempGroupLine: Record "BCDA Correction Line" temporary)
    var
        TargetRecordRef: RecordRef;
    begin
        TempGroupLine.Reset();
        TempGroupLine.FindFirst();
        if not TargetRecordRef.Get(TempGroupLine."Record ID") then
            Error(LineRecordNotFoundErr, TempGroupLine."Line No.");

        TempGroupLine."Current Value Preview" := CopyStr(Format(TempGroupLine."Record ID"), 1, MaxStrLen(TempGroupLine."Current Value Preview"));
        TempGroupLine."Sanitized Error" := DeleteExecutedValueTxt;
        TempGroupLine.Modify();

        TargetRecordRef.Delete(true);
        TargetRecordRef.Close();
    end;

    local procedure ApplyInsertExecutionGroup(var TempGroupLine: Record "BCDA Correction Line" temporary)
    var
        CreatedRecordId: RecordId;
        TargetRecordRef: RecordRef;
    begin
        TempGroupLine.Reset();
        TempGroupLine.FindFirst();

        TargetRecordRef.Open(TempGroupLine."Table ID");
        TargetRecordRef.Init();

        ApplyInsertExecutionGroupFields(TempGroupLine, TargetRecordRef, true);
        ApplyInsertExecutionGroupFields(TempGroupLine, TargetRecordRef, false);

        TargetRecordRef.Insert(true);
        CreatedRecordId := TargetRecordRef.RecordId();
        TargetRecordRef.Close();

        TempGroupLine.Reset();
        if TempGroupLine.FindSet() then
            repeat
                TempGroupLine."Record ID" := CreatedRecordId;
                TempGroupLine.Modify();
            until TempGroupLine.Next() = 0;
    end;

    local procedure ApplyInsertExecutionGroupFields(var TempGroupLine: Record "BCDA Correction Line" temporary; var TargetRecordRef: RecordRef; ApplyPrimaryKeyFields: Boolean)
    var
        FieldMetadata: Record "Field";
        TargetFieldRef: FieldRef;
    begin
        TempGroupLine.Reset();
        if TempGroupLine.FindSet() then
            repeat
                FieldMetadata.Get(TempGroupLine."Table ID", TempGroupLine."Field ID");
                if FieldMetadata.IsPartOfPrimaryKey = ApplyPrimaryKeyFields then begin
                    TargetFieldRef := TargetRecordRef.Field(TempGroupLine."Field ID");
                    Clear(TempGroupLine."Current Value Preview");
                    SetTargetFieldValue(TargetFieldRef, FieldMetadata, TempGroupLine."Proposed New Value");
                    TempGroupLine."Sanitized Error" := CopyStr(Format(TargetFieldRef.Value()), 1, MaxStrLen(TempGroupLine."Sanitized Error"));
                    TempGroupLine.Modify();
                end;
            until TempGroupLine.Next() = 0;
    end;

    local procedure ValidateRenameExecutionGroup(RequestApproved: Boolean; var TempGroupLine: Record "BCDA Correction Line" temporary)
    begin
        TempGroupLine.Reset();
        if TempGroupLine.FindSet() then
            repeat
                ValidateLinePreviewShape(TempGroupLine);
                EnsureNoDuplicateFieldInExecutionGroup(TempGroupLine);
                TempGroupLine.ValidateDataValue();
                EnsureLinePolicyAllowsExecution(TempGroupLine, RequestApproved);
            until TempGroupLine.Next() = 0;
    end;

    local procedure ValidateUpdateExecutionGroup(RequestApproved: Boolean; var TempGroupLine: Record "BCDA Correction Line" temporary)
    begin
        TempGroupLine.Reset();
        if TempGroupLine.FindSet() then
            repeat
                ValidateLinePreviewShape(TempGroupLine);
                EnsureNoDuplicateFieldInExecutionGroup(TempGroupLine);
                TempGroupLine.ValidateDataValue();
                EnsureLinePolicyAllowsExecution(TempGroupLine, RequestApproved);
            until TempGroupLine.Next() = 0;
    end;

    local procedure ValidateDeleteExecutionGroup(RequestApproved: Boolean; var TempGroupLine: Record "BCDA Correction Line" temporary)
    begin
        TempGroupLine.Reset();
        if TempGroupLine.Count() <> 1 then begin
            TempGroupLine.FindFirst();
            Error(DuplicateDeleteInGroupErr, TempGroupLine."Table ID", TempGroupLine."Record ID");
        end;

        TempGroupLine.FindFirst();
        ValidateLinePreviewShape(TempGroupLine);
        TempGroupLine.ValidateDataValue();
        EnsureLinePolicyAllowsExecution(TempGroupLine, RequestApproved);
    end;

    local procedure ValidateInsertExecutionGroup(RequestApproved: Boolean; var TempGroupLine: Record "BCDA Correction Line" temporary)
    begin
        TempGroupLine.Reset();
        if TempGroupLine.FindSet() then
            repeat
                ValidateLinePreviewShape(TempGroupLine);
                EnsureNoDuplicateFieldInExecutionGroup(TempGroupLine);
                TempGroupLine.ValidateDataValue();
                EnsureLinePolicyAllowsExecution(TempGroupLine, RequestApproved);
            until TempGroupLine.Next() = 0;

        EnsureInsertPrimaryKeyFieldsStaged(TempGroupLine);
    end;

    local procedure EnsureNoDuplicateFieldInExecutionGroup(CorrectionLine: Record "BCDA Correction Line")
    var
        DuplicateLine: Record "BCDA Correction Line";
    begin
        DuplicateLine.SetRange("Request ID", CorrectionLine."Request ID");
        DuplicateLine.SetRange(Type, CorrectionLine.Type);
        DuplicateLine.SetRange("Table ID", CorrectionLine."Table ID");
        DuplicateLine.SetRange("Record ID", CorrectionLine."Record ID");
        DuplicateLine.SetRange("Insert Group No.", CorrectionLine."Insert Group No.");
        DuplicateLine.SetRange("Field ID", CorrectionLine."Field ID");
        if DuplicateLine.Count() > 1 then begin
            if CorrectionLine.Type = CorrectionLine.Type::Insert then
                Error(DuplicateInsertFieldInGroupErr, CorrectionLine."Field ID", CorrectionLine."Table ID", CorrectionLine."Insert Group No.");

            Error(DuplicateFieldInGroupErr, CorrectionLine."Field ID", CorrectionLine."Table ID", CorrectionLine."Record ID");
        end;
    end;

    local procedure EnsureInsertPrimaryKeyFieldsStaged(var TempGroupLine: Record "BCDA Correction Line" temporary)
    var
        FieldMetadata: Record "Field";
        InsertGroupNo: Integer;
        TableId: Integer;
    begin
        TempGroupLine.Reset();
        TempGroupLine.FindFirst();
        TableId := TempGroupLine."Table ID";
        InsertGroupNo := TempGroupLine."Insert Group No.";

        FieldMetadata.SetRange(TableNo, TableId);
        FieldMetadata.SetRange(IsPartOfPrimaryKey, true);
        if not FieldMetadata.FindSet() then
            Error(InsertPrimaryKeyMetadataMissingErr, TableId, InsertGroupNo);

        repeat
            TempGroupLine.Reset();
            TempGroupLine.SetRange("Field ID", FieldMetadata."No.");
            if not TempGroupLine.FindFirst() then
                Error(InsertPrimaryKeyFieldMissingErr, TableId, InsertGroupNo, FieldMetadata."No.");

            if TempGroupLine."Proposed New Value" = '' then
                Error(InsertPrimaryKeyValueMissingErr, TableId, InsertGroupNo, FieldMetadata."No.");
        until FieldMetadata.Next() = 0;

        TempGroupLine.Reset();
    end;

    local procedure EnsureLinePolicyAllowsExecution(CorrectionLine: Record "BCDA Correction Line"; RequestApproved: Boolean)
    var
        PolicyGuard: Codeunit "BCDA Policy Guard";
        Decision: Enum "BCDA Policy Decision";
        DecisionReason: Text[250];
    begin
        PolicyGuard.EvaluateLine(CorrectionLine, Decision, DecisionReason);
        case Decision of
            Decision::Block:
                Error(LineBlockedByPolicyErr, CorrectionLine."Line No.", DecisionReason);
            Decision::"Approval Required":
                if not RequestApproved then
                    Error(LineRequiresApprovalErr, CorrectionLine."Line No.", DecisionReason);
        end;
    end;

    local procedure SetTargetFieldValue(var TargetFieldRef: FieldRef; FieldMetadata: Record "Field"; DataValue: Text)
    var
        DateFormulaValue: DateFormula;
        BigIntegerValue: BigInteger;
        BooleanValue: Boolean;
        DateTimeValue: DateTime;
        DateValue: Date;
        DecimalValue: Decimal;
        DurationValue: Duration;
        GuidValue: Guid;
        IntegerValue: Integer;
        TimeValue: Time;
    begin
        case FieldMetadata.Type of
            FieldMetadata.Type::Text,
            FieldMetadata.Type::OemText,
            FieldMetadata.Type::Code,
            FieldMetadata.Type::OemCode:
                TargetFieldRef.Validate(DataValue);
            FieldMetadata.Type::DateFormula:
                begin
                    if DataValue = '' then begin
                        Clear(DateFormulaValue);
                        TargetFieldRef.Validate(DateFormulaValue);
                        exit;
                    end;

                    Evaluate(DateFormulaValue, DataValue);
                    TargetFieldRef.Validate(DateFormulaValue);
                end;
            FieldMetadata.Type::Boolean:
                begin
                    Evaluate(BooleanValue, DataValue);
                    TargetFieldRef.Validate(BooleanValue);
                end;
            FieldMetadata.Type::BigInteger:
                begin
                    Evaluate(BigIntegerValue, DataValue);
                    TargetFieldRef.Validate(BigIntegerValue);
                end;
            FieldMetadata.Type::Integer:
                begin
                    Evaluate(IntegerValue, DataValue);
                    TargetFieldRef.Validate(IntegerValue);
                end;
            FieldMetadata.Type::Decimal:
                begin
                    Evaluate(DecimalValue, DataValue);
                    TargetFieldRef.Validate(DecimalValue);
                end;
            FieldMetadata.Type::Date:
                begin
                    if DataValue = '' then begin
                        Clear(DateValue);
                        TargetFieldRef.Validate(DateValue);
                        exit;
                    end;

                    Evaluate(DateValue, DataValue);
                    TargetFieldRef.Validate(DateValue);
                end;
            FieldMetadata.Type::Time:
                begin
                    if DataValue = '' then begin
                        Clear(TimeValue);
                        TargetFieldRef.Validate(TimeValue);
                        exit;
                    end;

                    Evaluate(TimeValue, DataValue);
                    TargetFieldRef.Validate(TimeValue);
                end;
            FieldMetadata.Type::DateTime:
                begin
                    if DataValue = '' then begin
                        Clear(DateTimeValue);
                        TargetFieldRef.Validate(DateTimeValue);
                        exit;
                    end;

                    Evaluate(DateTimeValue, DataValue);
                    TargetFieldRef.Validate(DateTimeValue);
                end;
            FieldMetadata.Type::GUID:
                begin
                    if DataValue = '' then begin
                        Clear(GuidValue);
                        TargetFieldRef.Validate(GuidValue);
                        exit;
                    end;

                    Evaluate(GuidValue, DataValue);
                    TargetFieldRef.Validate(GuidValue);
                end;
            FieldMetadata.Type::Duration:
                begin
                    Evaluate(DurationValue, DataValue);
                    TargetFieldRef.Validate(DurationValue);
                end;
            FieldMetadata.Type::Option:
                if Evaluate(IntegerValue, DataValue) then
                    TargetFieldRef.Validate(IntegerValue)
                else
                    TargetFieldRef.Validate(DataValue);
            else
                Error(FieldTypeNotSupportedForExecutionErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
        end;
    end;

    local procedure MarkExecutionGroupSucceeded(var CorrectionRequest: Record "BCDA Correction Request"; var TempGroupLine: Record "BCDA Correction Line" temporary; var SuccessCount: Integer)
    var
        CorrectionLine: Record "BCDA Correction Line";
        AuditWriter: Codeunit "BCDA Audit Writer";
        ValueSerializer: Codeunit "BCDA Value Serializer";
        EmptyRecordId: RecordId;
        ExpiresAt: DateTime;
        NewValueText: Text[2048];
        OldValueText: Text[2048];
        ValueType: Text[50];
    begin
        TempGroupLine.Reset();
        if TempGroupLine.FindSet() then
            repeat
                CorrectionLine.Get(TempGroupLine."Request ID", TempGroupLine."Line No.");
                OldValueText := CopyStr(TempGroupLine."Current Value Preview", 1, MaxStrLen(OldValueText));
                NewValueText := CopyStr(TempGroupLine."Sanitized Error", 1, MaxStrLen(NewValueText));
                ValueType := ResolveValueType(TempGroupLine);
                if (TempGroupLine.Type in [TempGroupLine.Type::Rename, TempGroupLine.Type::Insert]) and (TempGroupLine."Record ID" <> EmptyRecordId) then
                    CorrectionLine."Record ID" := TempGroupLine."Record ID";

                if ShouldCaptureRollbackSnapshot(TempGroupLine) then begin
                    ExpiresAt := CalculateSnapshotExpiresAt();
                    CorrectionLine."Old Value Snapshot ID" := ValueSerializer.CreateTextSnapshot(CorrectionLine."Request ID", CorrectionLine."Line No.", OldValueText, ValueType, ExpiresAt);
                    CorrectionLine."New Value Snapshot ID" := ValueSerializer.CreateTextSnapshot(CorrectionLine."Request ID", CorrectionLine."Line No.", NewValueText, ValueType, ExpiresAt);
                    CorrectionLine."Snapshot Expires At" := ExpiresAt;
                end else begin
                    Clear(CorrectionLine."Old Value Snapshot ID");
                    Clear(CorrectionLine."New Value Snapshot ID");
                    Clear(CorrectionLine."Snapshot Expires At");
                end;

                CorrectionLine."Current Value Preview" := NewValueText;
                CorrectionLine."Line Status" := CorrectionLine."Line Status"::Executed;
                Clear(CorrectionLine."Sanitized Error");
                CorrectionLine.Modify(true);
                AuditWriter.WriteLineAudit(CorrectionRequest, CorrectionLine, "BCDA Audit Operation"::Execution, "BCDA Audit Result"::Success, '');
                SuccessCount += 1;
            until TempGroupLine.Next() = 0;
    end;

    local procedure MarkExecutionRequestPreflightFailed(var CorrectionRequest: Record "BCDA Correction Request"; FailureMessage: Text[2048])
    var
        CorrectionLine: Record "BCDA Correction Line";
        AuditWriter: Codeunit "BCDA Audit Writer";
    begin
        CorrectionRequest.Status := CorrectionRequest.Status::Failed;
        CorrectionRequest."Rollback Availability" := ExecutionPreflightFailedRollbackAvailabilityTxt;
        CorrectionRequest.Modify(true);

        CorrectionLine.SetRange("Request ID", CorrectionRequest."Request ID");
        if CorrectionLine.FindSet(true) then
            repeat
                CorrectionLine."Line Status" := CorrectionLine."Line Status"::Failed;
                CorrectionLine."Sanitized Error" := CopyStr(FailureMessage, 1, MaxStrLen(CorrectionLine."Sanitized Error"));
                Clear(CorrectionLine."Old Value Snapshot ID");
                Clear(CorrectionLine."New Value Snapshot ID");
                Clear(CorrectionLine."Snapshot Expires At");
                CorrectionLine.Modify(true);
                AuditWriter.WriteLineAudit(CorrectionRequest, CorrectionLine, "BCDA Audit Operation"::Execution, "BCDA Audit Result"::Failed, CorrectionLine."Sanitized Error");
            until CorrectionLine.Next() = 0;

        AuditWriter.WriteRequestAudit(CorrectionRequest, "BCDA Audit Operation"::Execution, "BCDA Audit Result"::Failed, FailureMessage);
    end;

    local procedure ShouldCaptureRollbackSnapshot(CorrectionLine: Record "BCDA Correction Line"): Boolean
    var
        RollbackSnapshotMode: Enum "BCDA Rollback Snapshot Mode";
    begin
        if CorrectionLine.Type <> CorrectionLine.Type::Update then
            exit(false);

        RollbackSnapshotMode := ResolveRollbackSnapshotMode(CorrectionLine);
        exit(RollbackSnapshotMode in [RollbackSnapshotMode::Enabled, RollbackSnapshotMode::Required]);
    end;

    local procedure ResolveRollbackSnapshotMode(CorrectionLine: Record "BCDA Correction Line"): Enum "BCDA Rollback Snapshot Mode"
    var
        DataPolicy: Record "BCDA Data Policy";
        Setup: Record "BCDA Setup";
        SetupMgt: Codeunit "BCDA Setup Mgt.";
    begin
        if CorrectionLine."Rollback Snapshot Mode" <> CorrectionLine."Rollback Snapshot Mode"::"Policy Controlled" then
            exit(CorrectionLine."Rollback Snapshot Mode");

        SetupMgt.GetSetup(Setup);
        if Setup."Allow Data Policies" and FindExecutionPolicy(CorrectionLine."Table ID", CorrectionLine."Field ID", DataPolicy) then
            if DataPolicy."Rollback Snapshot Mode" <> DataPolicy."Rollback Snapshot Mode"::"Policy Controlled" then
                exit(DataPolicy."Rollback Snapshot Mode");

        exit(Setup."Rollback Snapshot Default");
    end;

    local procedure FindExecutionPolicy(TableId: Integer; FieldId: Integer; var DataPolicy: Record "BCDA Data Policy"): Boolean
    begin
        DataPolicy.Reset();
        DataPolicy.SetRange("Table ID", TableId);
        DataPolicy.SetRange("Field ID", FieldId);
        DataPolicy.SetRange(Operation, 'MODIFY');
        if DataPolicy.FindFirst() then
            exit(true);

        DataPolicy.Reset();
        DataPolicy.SetRange("Table ID", TableId);
        DataPolicy.SetRange("Field ID", 0);
        DataPolicy.SetRange(Operation, 'MODIFY');
        exit(DataPolicy.FindFirst());
    end;

    local procedure ResolvePreviewRollbackAvailability(CorrectionRequest: Record "BCDA Correction Request"; RollbackSnapshotMode: Enum "BCDA Rollback Snapshot Mode"): Text[250]
    begin
        if RequestContainsType(CorrectionRequest, "BCDA Correction Type"::Rename) then
            if RequestContainsType(CorrectionRequest, "BCDA Correction Type"::Delete) or RequestContainsType(CorrectionRequest, "BCDA Correction Type"::Insert) then
                exit(CopyStr(NonUpdateRollbackUnavailableTxt, 1, 250));

        if RequestContainsType(CorrectionRequest, "BCDA Correction Type"::Delete) then begin
            if RequestContainsType(CorrectionRequest, "BCDA Correction Type"::Insert) then
                exit(CopyStr(DeleteInsertRollbackUnavailableTxt, 1, 250));

            exit(CopyStr(DeleteRollbackUnavailableTxt, 1, 250));
        end;

        if RequestContainsType(CorrectionRequest, "BCDA Correction Type"::Insert) then
            exit(CopyStr(InsertRollbackUnavailableTxt, 1, 250));

        if RequestContainsType(CorrectionRequest, "BCDA Correction Type"::Rename) then
            exit(CopyStr(RenameRollbackUnavailableTxt, 1, 250));

        exit(CopyStr(StrSubstNo(PreviewRollbackAvailabilityTxt, RollbackSnapshotMode), 1, 250));
    end;

    local procedure ResolveExecutionRollbackAvailability(CorrectionRequest: Record "BCDA Correction Request"): Text[250]
    begin
        if RequestContainsType(CorrectionRequest, "BCDA Correction Type"::Rename) then
            if RequestContainsType(CorrectionRequest, "BCDA Correction Type"::Delete) or RequestContainsType(CorrectionRequest, "BCDA Correction Type"::Insert) then
                exit(CopyStr(NonUpdateRollbackUnavailableTxt, 1, 250));

        if RequestContainsType(CorrectionRequest, "BCDA Correction Type"::Delete) then begin
            if RequestContainsType(CorrectionRequest, "BCDA Correction Type"::Insert) then
                exit(CopyStr(DeleteInsertRollbackUnavailableTxt, 1, 250));

            exit(CopyStr(DeleteRollbackUnavailableTxt, 1, 250));
        end;

        if RequestContainsType(CorrectionRequest, "BCDA Correction Type"::Insert) then
            exit(CopyStr(InsertRollbackUnavailableTxt, 1, 250));

        if RequestContainsType(CorrectionRequest, "BCDA Correction Type"::Rename) then
            exit(CopyStr(RenameRollbackUnavailableTxt, 1, 250));

        exit(CopyStr(ExecutionRollbackAvailabilityTxt, 1, 250));
    end;

    local procedure RequestContainsType(CorrectionRequest: Record "BCDA Correction Request"; CorrectionType: Enum "BCDA Correction Type"): Boolean
    var
        CorrectionLine: Record "BCDA Correction Line";
    begin
        CorrectionLine.SetRange("Request ID", CorrectionRequest."Request ID");
        CorrectionLine.SetRange(Type, CorrectionType);
        exit(not CorrectionLine.IsEmpty());
    end;

    local procedure CalculateSnapshotExpiresAt(): DateTime
    var
        Setup: Record "BCDA Setup";
        SetupMgt: Codeunit "BCDA Setup Mgt.";
    begin
        SetupMgt.GetSetup(Setup);
        exit(CreateDateTime(Today() + Setup."Snapshot Retention Days", Time()));
    end;

    local procedure ResolveValueType(CorrectionLine: Record "BCDA Correction Line"): Text[50]
    var
        FieldMetadata: Record "Field";
    begin
        if FieldMetadata.Get(CorrectionLine."Table ID", CorrectionLine."Field ID") then
            exit(CopyStr(Format(FieldMetadata.Type), 1, 50));

        exit('');
    end;

    var
        MissingMetadataErr: Label 'Reason is required before this action. Ticket/reference is required only when the request requires it.';
        RequestRequiredErr: Label 'Initialize or save the correction request before this action.';
        ApprovalNotRequiredErr: Label 'This BC Data Agent request does not require approval. Review the approval setup if approval should be required.';
        ExecutionApprovalRequiredErr: Label 'Approve this BC Data Agent request before execution.';
        ExecutionStatusErr: Label 'Execution can start only from an open or previewed request when approval is not required.';
        PendingApprovalRequiredErr: Label 'Submit the request for approval before approving it.';
        PreviewLineNotReadyErr: Label 'Line %1 must be previewed before approval. Current line status is %2.', Comment = '%1 = line number, %2 = line status';
        PreviewRequiredBeforeApprovalErr: Label 'Preview this request before submitting or approving it.';
        PreviewStatusErr: Label 'Preview can run only while the request is open or already previewed.';
        SecondSuperApprovalErr: Label 'A different SUPER user must approve this BC Data Agent request because separate approval is required.';
        NoLinesForPreviewErr: Label 'Request %1 must have at least one correction line before preview.', Comment = '%1 = request ID';
        NoLinesForExecutionErr: Label 'Request %1 must have at least one correction line before execution.', Comment = '%1 = request ID';
        PreviewRollbackAvailabilityTxt: Label 'Preview only. Rollback snapshot mode is %1; execution can capture snapshots when enabled or required.', Comment = '%1 = rollback snapshot mode';
        ExecutionRollbackAvailabilityTxt: Label 'Execution captures rollback snapshots for supported update lines when rollback snapshot mode is enabled or required. The request is applied as one transaction.';
        DeleteRollbackUnavailableTxt: Label 'Delete execution is supported for governed requests, but request-level rollback staging is unavailable for Delete lines. Restore deleted records through a separately reviewed correction or backup process.';
        DeleteInsertRollbackUnavailableTxt: Label 'Delete and Insert execution are supported for governed requests, but request-level rollback staging is unavailable for Delete or Insert lines. Use separately reviewed corrections or backup processes to restore or remove records.';
        InsertRollbackUnavailableTxt: Label 'Insert execution is supported for governed requests, but request-level rollback staging is unavailable for Insert lines. Remove created records through a separately reviewed Delete correction or backup process.';
        RenameRollbackUnavailableTxt: Label 'Rename execution is supported for governed requests, but request-level rollback staging is unavailable for Rename lines. Restore primary-key identity through a separately reviewed Rename correction or backup process.';
        NonUpdateRollbackUnavailableTxt: Label 'Rename, Delete, and Insert execution are supported for governed requests, but request-level rollback staging is unavailable for non-update operation lines. Use separately reviewed corrections or backup processes to restore records.';
        ExecutionPreflightFailedRollbackAvailabilityTxt: Label 'Execution did not change target data because the request failed validation before mutation.';
        RetentionImpactTxt: Label 'Audit: %1 days; rollback snapshots: %2 days; technical logs: %3 days.', Comment = '%1 = audit retention days, %2 = snapshot retention days, %3 = technical log retention days';
        PreviewSummaryTxt: Label 'Preview checked %1 line(s): %2 failed validation, %3 blocked by policy, %4 require approval. No target data was changed.', Comment = '%1 = line count, %2 = failed count, %3 = blocked count, %4 = approval-required count';
        ExecutionSummaryTxt: Label 'Execution finished: %1 line(s) executed. The correction request was applied as one transaction.', Comment = '%1 = executed line count';
        LineTableRequiredErr: Label 'Line %1 must have a target table before preview.', Comment = '%1 = line number';
        LineFieldRequiredErr: Label 'Line %1 must have a field before preview.', Comment = '%1 = line number';
        LineFieldNotAllowedForDeleteErr: Label 'Line %1 must not have a field for Delete preview.', Comment = '%1 = line number';
        LineProposedValueNotAllowedForDeleteErr: Label 'Line %1 must not have a proposed value for Delete preview.', Comment = '%1 = line number';
        LineRecordNotFoundErr: Label 'Line %1 target record was not found.', Comment = '%1 = line number';
        LineRecordRequiredErr: Label 'Line %1 must have a target Record ID before preview.', Comment = '%1 = line number';
        LineRecordTableMismatchErr: Label 'Line %1 Record ID %2 does not belong to table %3.', Comment = '%1 = line number, %2 = record ID, %3 = table ID';
        LineRecordMustBeEmptyForInsertErr: Label 'Line %1 must keep Record ID empty for Insert preview.', Comment = '%1 = line number';
        LineInsertGroupRequiredErr: Label 'Line %1 must have an Insert Group No. greater than zero for Insert preview.', Comment = '%1 = line number';
        DuplicateFieldInGroupErr: Label 'Field %1 on table %2 is staged more than once for record %3. Keep one proposed value per field in an execution group.', Comment = '%1 = field ID, %2 = table ID, %3 = record ID';
        DuplicateDeleteInGroupErr: Label 'Delete is staged more than once for table %1 record %2. Keep one Delete line per target record.', Comment = '%1 = table ID, %2 = record ID';
        DuplicateInsertFieldInGroupErr: Label 'Field %1 on table %2 is staged more than once for Insert group %3. Keep one proposed value per field in each Insert group.', Comment = '%1 = field ID, %2 = table ID, %3 = insert group number';
        InsertPrimaryKeyFieldMissingErr: Label 'Insert execution for table %1 group %2 must stage primary-key field %3 before mutation.', Comment = '%1 = table ID, %2 = insert group number, %3 = field ID';
        InsertPrimaryKeyMetadataMissingErr: Label 'Insert execution for table %1 group %2 could not find primary-key metadata.', Comment = '%1 = table ID, %2 = insert group number';
        InsertPrimaryKeyValueMissingErr: Label 'Insert execution for table %1 group %2 field %3 must stage a nonblank primary-key value before mutation.', Comment = '%1 = table ID, %2 = insert group number, %3 = field ID';
        RenameFailedErr: Label 'Rename execution for table %1 record %2 did not complete. Verify the proposed primary-key value is unique and valid for the target table.', Comment = '%1 = table ID, %2 = record ID';
        RenamePrimaryKeyFieldLimitErr: Label 'Rename execution supports primary keys with up to 20 fields. The target primary key has %1 fields.', Comment = '%1 = primary-key field count';
        DeleteExecutedValueTxt: Label 'Deleted';
        FieldTypeNotSupportedForExecutionErr: Label 'Field %1 on table %2 has unsupported type %3 for execution.', Comment = '%1 = field ID, %2 = table ID, %3 = field type';
        LineBlockedByPolicyErr: Label 'Line %1 is blocked by data policy: %2', Comment = '%1 = line number, %2 = policy reason';
        LineRequiresApprovalErr: Label 'Line %1 requires an approved request before execution: %2', Comment = '%1 = line number, %2 = policy reason';
        UnsupportedExecutionTypeErr: Label '%1 execution is not enabled yet. Stage it for preview only until operation-specific execution and rollback controls are implemented and validated.', Comment = '%1 = correction type';
}
