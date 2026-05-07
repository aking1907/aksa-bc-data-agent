namespace AKSA.BCDataAgent;

codeunit 88123 "BCDA Audit Writer"
{
    Access = Internal;

    procedure WriteRequestAudit(CorrectionRequest: Record "BCDA Correction Request"; Operation: Enum "BCDA Audit Operation"; Result: Enum "BCDA Audit Result"; SanitizedError: Text[2048]): Integer
    var
        EmptyLine: Record "BCDA Correction Line";
    begin
        exit(WriteAudit(CorrectionRequest, EmptyLine, Operation, Result, SanitizedError));
    end;

    procedure WriteLineAudit(CorrectionRequest: Record "BCDA Correction Request"; CorrectionLine: Record "BCDA Correction Line"; Operation: Enum "BCDA Audit Operation"; Result: Enum "BCDA Audit Result"; SanitizedError: Text[2048]): Integer
    begin
        exit(WriteAudit(CorrectionRequest, CorrectionLine, Operation, Result, SanitizedError));
    end;

    local procedure WriteAudit(CorrectionRequest: Record "BCDA Correction Request"; CorrectionLine: Record "BCDA Correction Line"; Operation: Enum "BCDA Audit Operation"; Result: Enum "BCDA Audit Result"; SanitizedError: Text[2048]): Integer
    var
        AuditEntry: Record "BCDA Audit Entry";
    begin
        AuditEntry.Init();
        AuditEntry.Operation := Operation;
        AuditEntry.Result := Result;
        AuditEntry."Request ID" := CorrectionRequest."Request ID";
        AuditEntry."Line No." := CorrectionLine."Line No.";
        AuditEntry."Company Name" := CorrectionRequest."Company Name";
        AuditEntry."Target Table ID" := CorrectionLine."Table ID";
        AuditEntry."Target Table Name" := CorrectionLine."Table Name";
        AuditEntry."Target Record Key" := CorrectionLine."Record Key";
        AuditEntry."Target Field ID" := CorrectionLine."Field ID";
        AuditEntry."Target Field Name" := CorrectionLine."Field Name";
        AuditEntry.Reason := CorrectionRequest.Reason;
        AuditEntry."Ticket Reference" := CorrectionRequest."Ticket Reference";
        AuditEntry."Old Snapshot ID" := CorrectionLine."Old Value Snapshot ID";
        AuditEntry."New Snapshot ID" := CorrectionLine."New Value Snapshot ID";
        AuditEntry."Rollback Available" := not IsNullGuid(CorrectionLine."Old Value Snapshot ID");
        AuditEntry."Rollback Availability" := CorrectionRequest."Rollback Availability";
        AuditEntry."Sanitized Error" := SanitizedError;
        AuditEntry.Insert(true);

        exit(AuditEntry."Entry No.");
    end;
}
