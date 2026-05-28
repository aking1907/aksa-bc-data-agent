namespace AKSA.BCDataAgent;

using System.DataAdministration;

codeunit 88126 "BCDA Retention Manager"
{
    Access = Internal;

    procedure RegisterRetentionTables()
    var
        AuditEntry: Record "BCDA Audit Entry";
        RetentionLog: Record "BCDA Retention Log";
        RollbackOperation: Record "BCDA Rollback Operation";
        ValueSnapshot: Record "BCDA Value Snapshot";
        AccessMgt: Codeunit "BCDA Access Mgt.";
        RetenPolAllowedTables: Codeunit "Reten. Pol. Allowed Tables";
    begin
        AccessMgt.EnsureSuperUser();

        RetenPolAllowedTables.AddAllowedTable(Database::"BCDA Audit Entry", AuditEntry.FieldNo("Occurred At"));
        RetenPolAllowedTables.AddAllowedTable(Database::"BCDA Value Snapshot", ValueSnapshot.FieldNo("Expires At"));
        RetenPolAllowedTables.AddAllowedTable(Database::"BCDA Rollback Operation", RollbackOperation.FieldNo("Requested At"));
        RetenPolAllowedTables.AddAllowedTable(Database::"BCDA Retention Log", RetentionLog.FieldNo("Created At"));
    end;

    procedure RunRetentionCleanup()
    var
        Setup: Record "BCDA Setup";
        AccessMgt: Codeunit "BCDA Access Mgt.";
        SetupMgt: Codeunit "BCDA Setup Mgt.";
        RunStartedAt: DateTime;
    begin
        AccessMgt.EnsureSuperUser();
        SetupMgt.GetSetup(Setup);

        RunStartedAt := CurrentDateTime();
        RunSnapshotCleanup();
        RunAuditCleanup(Setup);
        RunRollbackOperationCleanup(Setup);
        RunRetentionLogCleanup(Setup, RunStartedAt);
    end;

    local procedure RunSnapshotCleanup()
    var
        CutoffDateTime: DateTime;
        DeletedCount: Integer;
        ExpiredCount: Integer;
    begin
        CutoffDateTime := CurrentDateTime();
        if TryPurgeExpiredSnapshots(CutoffDateTime, ExpiredCount, DeletedCount) then
            WriteRetentionLog("BCDA Retention Category"::"Rollback Snapshot", Database::"BCDA Value Snapshot", CutoffDateTime, ExpiredCount, DeletedCount, "BCDA Audit Result"::Success, '')
        else
            WriteRetentionLog("BCDA Retention Category"::"Rollback Snapshot", Database::"BCDA Value Snapshot", CutoffDateTime, ExpiredCount, DeletedCount, "BCDA Audit Result"::Failed, GetLastErrorText());
    end;

    local procedure RunAuditCleanup(Setup: Record "BCDA Setup")
    var
        CutoffDateTime: DateTime;
        DeletedCount: Integer;
        ExpiredCount: Integer;
    begin
        CutoffDateTime := GetCutoffDateTime(Setup."Audit Retention Days");
        if TryDeleteExpiredAuditEntries(CutoffDateTime, ExpiredCount, DeletedCount) then
            WriteRetentionLog("BCDA Retention Category"::"Audit Metadata", Database::"BCDA Audit Entry", CutoffDateTime, ExpiredCount, DeletedCount, "BCDA Audit Result"::Success, '')
        else
            WriteRetentionLog("BCDA Retention Category"::"Audit Metadata", Database::"BCDA Audit Entry", CutoffDateTime, ExpiredCount, DeletedCount, "BCDA Audit Result"::Failed, GetLastErrorText());
    end;

    local procedure RunRollbackOperationCleanup(Setup: Record "BCDA Setup")
    var
        CutoffDateTime: DateTime;
        DeletedCount: Integer;
        ExpiredCount: Integer;
    begin
        CutoffDateTime := GetCutoffDateTime(Setup."Audit Retention Days");
        if TryDeleteExpiredRollbackOperations(CutoffDateTime, ExpiredCount, DeletedCount) then
            WriteRetentionLog("BCDA Retention Category"::"Audit Metadata", Database::"BCDA Rollback Operation", CutoffDateTime, ExpiredCount, DeletedCount, "BCDA Audit Result"::Success, '')
        else
            WriteRetentionLog("BCDA Retention Category"::"Audit Metadata", Database::"BCDA Rollback Operation", CutoffDateTime, ExpiredCount, DeletedCount, "BCDA Audit Result"::Failed, GetLastErrorText());
    end;

    local procedure RunRetentionLogCleanup(Setup: Record "BCDA Setup"; RunStartedAt: DateTime)
    var
        CutoffDateTime: DateTime;
        DeletedCount: Integer;
        ExpiredCount: Integer;
    begin
        CutoffDateTime := GetCutoffDateTime(Setup."Technical Log Retention Days");
        if TryDeleteExpiredRetentionLogs(CutoffDateTime, RunStartedAt, ExpiredCount, DeletedCount) then
            WriteRetentionLog("BCDA Retention Category"::"Technical Log", Database::"BCDA Retention Log", CutoffDateTime, ExpiredCount, DeletedCount, "BCDA Audit Result"::Success, '')
        else
            WriteRetentionLog("BCDA Retention Category"::"Technical Log", Database::"BCDA Retention Log", CutoffDateTime, ExpiredCount, DeletedCount, "BCDA Audit Result"::Failed, GetLastErrorText());
    end;

    [TryFunction]
    local procedure TryPurgeExpiredSnapshots(CutoffDateTime: DateTime; var ExpiredCount: Integer; var PurgedCount: Integer)
    var
        ValueSnapshot: Record "BCDA Value Snapshot";
    begin
        ValueSnapshot.SetCurrentKey("Retention Category", "Expires At", Purged);
        ValueSnapshot.SetRange("Retention Category", ValueSnapshot."Retention Category"::"Rollback Snapshot");
        ValueSnapshot.SetRange(Purged, false);
        ValueSnapshot.SetFilter("Expires At", '..%1', CutoffDateTime);
        if not ValueSnapshot.FindSet(true) then
            exit;

        repeat
            if ValueSnapshot."Expires At" <> 0DT then begin
                ExpiredCount += 1;
                ValueSnapshot.Purged := true;
                Clear(ValueSnapshot."Serialized Value");
                Clear(ValueSnapshot."Display Value");
                Clear(ValueSnapshot."Value Hash");
                ValueSnapshot.Modify(true);
                PurgedCount += 1;
            end;
        until ValueSnapshot.Next() = 0;
    end;

    [TryFunction]
    local procedure TryDeleteExpiredAuditEntries(CutoffDateTime: DateTime; var ExpiredCount: Integer; var DeletedCount: Integer)
    var
        AuditEntry: Record "BCDA Audit Entry";
    begin
        AuditEntry.SetCurrentKey("Target Table ID", "Target Field ID", "Occurred At");
        AuditEntry.SetFilter("Occurred At", '..%1', CutoffDateTime);
        if not AuditEntry.FindSet(true) then
            exit;

        repeat
            ExpiredCount += 1;
            if CanDeleteAuditEntry(AuditEntry) then begin
                AuditEntry.Delete();
                DeletedCount += 1;
            end;
        until AuditEntry.Next() = 0;
    end;

    [TryFunction]
    local procedure TryDeleteExpiredRollbackOperations(CutoffDateTime: DateTime; var ExpiredCount: Integer; var DeletedCount: Integer)
    var
        RollbackOperation: Record "BCDA Rollback Operation";
    begin
        RollbackOperation.SetFilter("Requested At", '..%1', CutoffDateTime);
        if not RollbackOperation.FindSet(true) then
            exit;

        repeat
            ExpiredCount += 1;
            if CanDeleteRollbackOperation(RollbackOperation) then begin
                RollbackOperation.Delete();
                DeletedCount += 1;
            end;
        until RollbackOperation.Next() = 0;
    end;

    [TryFunction]
    local procedure TryDeleteExpiredRetentionLogs(CutoffDateTime: DateTime; RunStartedAt: DateTime; var ExpiredCount: Integer; var DeletedCount: Integer)
    var
        RetentionLog: Record "BCDA Retention Log";
    begin
        RetentionLog.SetCurrentKey("Retention Category", "Created At");
        RetentionLog.SetFilter("Created At", '..%1', CutoffDateTime);
        if not RetentionLog.FindSet(true) then
            exit;

        repeat
            if RetentionLog."Created At" < RunStartedAt then begin
                ExpiredCount += 1;
                RetentionLog.Delete();
                DeletedCount += 1;
            end;
        until RetentionLog.Next() = 0;
    end;

    local procedure CanDeleteAuditEntry(AuditEntry: Record "BCDA Audit Entry"): Boolean
    var
        CorrectionRequest: Record "BCDA Correction Request";
        RollbackOperation: Record "BCDA Rollback Operation";
    begin
        if (AuditEntry."Request ID" <> '') and CorrectionRequest.Get(AuditEntry."Request ID") then
            if IsActiveStatus(CorrectionRequest.Status) then
                exit(false);

        if AuditEntry."Rollback Available" then
            if HasRetainedSnapshot(AuditEntry."Old Snapshot ID") or HasRetainedSnapshot(AuditEntry."New Snapshot ID") then
                exit(false);

        RollbackOperation.SetRange("Source Request ID", AuditEntry."Request ID");
        RollbackOperation.SetRange("Source Audit Entry No.", AuditEntry."Entry No.");
        if RollbackOperation.FindSet() then
            repeat
                if IsActiveStatus(RollbackOperation.Status) then
                    exit(false);
            until RollbackOperation.Next() = 0;

        exit(true);
    end;

    local procedure CanDeleteRollbackOperation(RollbackOperation: Record "BCDA Rollback Operation"): Boolean
    var
        AuditEntry: Record "BCDA Audit Entry";
    begin
        if IsActiveStatus(RollbackOperation.Status) then
            exit(false);

        if AuditEntry.Get(RollbackOperation."Source Audit Entry No.") then
            exit(false);

        exit(true);
    end;

    local procedure HasRetainedSnapshot(SnapshotID: Guid): Boolean
    var
        ValueSnapshot: Record "BCDA Value Snapshot";
    begin
        if IsNullGuid(SnapshotID) then
            exit(false);

        if not ValueSnapshot.Get(SnapshotID) then
            exit(false);

        if ValueSnapshot.Purged then
            exit(false);

        if ValueSnapshot."Expires At" = 0DT then
            exit(true);

        exit(ValueSnapshot."Expires At" > CurrentDateTime());
    end;

    local procedure IsActiveStatus(RequestStatus: Enum "BCDA Request Status"): Boolean
    begin
        case RequestStatus of
            RequestStatus::Open,
            RequestStatus::"Pending Approval",
            RequestStatus::Approved,
            RequestStatus::Previewed,
            RequestStatus::Executing:
                exit(true);
        end;

        exit(false);
    end;

    local procedure GetCutoffDateTime(RetentionDays: Integer): DateTime
    begin
        if RetentionDays < 0 then
            RetentionDays := 0;

        exit(CreateDateTime(Today() - RetentionDays, Time()));
    end;

    local procedure WriteRetentionLog(RetentionCategory: Enum "BCDA Retention Category"; TableId: Integer; CutoffDateTime: DateTime; ExpiredCount: Integer; DeletedCount: Integer; Result: Enum "BCDA Audit Result"; SanitizedError: Text)
    var
        RetentionLog: Record "BCDA Retention Log";
    begin
        RetentionLog.Init();
        RetentionLog."Retention Category" := RetentionCategory;
        RetentionLog."Table ID" := TableId;
        RetentionLog."Cutoff Date" := DT2Date(CutoffDateTime);
        RetentionLog."Expired Count" := ExpiredCount;
        RetentionLog."Deleted Count" := DeletedCount;
        RetentionLog.Result := Result;
        RetentionLog."Sanitized Error" := CopyStr(SanitizedError, 1, MaxStrLen(RetentionLog."Sanitized Error"));
        RetentionLog.Insert(true);
    end;
}
