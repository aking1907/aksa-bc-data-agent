namespace AKSA.BCDataAgent;

codeunit 88129 "BCDA Current Value Mgt."
{
    Access = Internal;

    procedure UpdateCurrentValuePreview(var CorrectionLine: Record "BCDA Correction Line")
    var
        AccessMgt: Codeunit "BCDA Access Mgt.";
        TargetFieldRef: FieldRef;
        TargetRecordRef: RecordRef;
    begin
        Clear(CorrectionLine."Current Value Preview");
        if Format(CorrectionLine."Record ID") = '' then
            exit;

        if CorrectionLine."Field ID" = 0 then
            exit;

        AccessMgt.EnsureSuperUser();
        if CorrectionLine."Record ID".TableNo() <> CorrectionLine."Table ID" then
            Error(RecordIdTableMismatchErr, CorrectionLine."Record ID", CorrectionLine."Table ID");

        if not TargetRecordRef.Get(CorrectionLine."Record ID") then
            Error(TargetRecordNotFoundErr, CorrectionLine."Record ID");

        TargetFieldRef := TargetRecordRef.Field(CorrectionLine."Field ID");
        CorrectionLine."Current Value Preview" := CopyStr(Format(TargetFieldRef.Value()), 1, MaxStrLen(CorrectionLine."Current Value Preview"));
        TargetRecordRef.Close();
    end;

    var
        RecordIdTableMismatchErr: Label 'Record ID %1 does not belong to table %2.', Comment = '%1 = record ID, %2 = table ID';
        TargetRecordNotFoundErr: Label 'Target record %1 was not found.', Comment = '%1 = record ID';
}
