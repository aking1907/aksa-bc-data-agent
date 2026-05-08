namespace AKSA.BCDataAgent;

codeunit 88128 "BCDA Batch Line Mgt."
{
    Access = Internal;

    procedure CreateCorrectionLines(CorrectionRequest: Record "BCDA Correction Request"; TableId: Integer; TableName: Text[250]; var TempBatchLine: Record "BCDA Batch Line Buffer" temporary): Integer
    var
        CorrectionLine: Record "BCDA Correction Line";
        AccessMgt: Codeunit "BCDA Access Mgt.";
        CreatedCount: Integer;
    begin
        AccessMgt.EnsureSuperUser();

        if CorrectionRequest."Request ID" = '' then
            Error(RequestRequiredErr);

        if TableId = 0 then
            Error(TableRequiredErr);

        TempBatchLine.Reset();
        if not TempBatchLine.FindSet() then
            Error(NoBatchLinesErr);

        repeat
            ValidateBatchLine(TempBatchLine, TableId);

            CorrectionLine.Init();
            CorrectionLine.Validate("Request ID", CorrectionRequest."Request ID");
            CorrectionLine.Validate("Table ID", TableId);
            CorrectionLine.Validate("Record ID", TempBatchLine."Record ID");
            CorrectionLine.Validate("Field ID", TempBatchLine."Field ID");
            CorrectionLine.Validate("Proposed New Value", TempBatchLine."Proposed New Value");
            CorrectionLine.Validate("Rollback Snapshot Mode", TempBatchLine."Rollback Snapshot Mode");
            CorrectionLine.Validate("Validation Mode", TempBatchLine."Validation Mode");
            CorrectionLine.Insert(true);
            CreatedCount += 1;
        until TempBatchLine.Next() = 0;

        exit(CreatedCount);
    end;

    local procedure ValidateBatchLine(TempBatchLine: Record "BCDA Batch Line Buffer" temporary; TableId: Integer)
    begin
        if TempBatchLine."Table ID" <> TableId then
            Error(MixedTableErr, TempBatchLine."Entry No.");

        if Format(TempBatchLine."Record ID") = '' then
            Error(RecordIdRequiredErr, TempBatchLine."Entry No.");

        if TempBatchLine."Field ID" = 0 then
            Error(FieldRequiredErr, TempBatchLine."Entry No.");
    end;

    var
        FieldRequiredErr: Label 'Batch entry %1 must have a field ID before request lines can be created.', Comment = '%1 = batch entry number';
        MixedTableErr: Label 'Batch entry %1 does not match the selected batch table.', Comment = '%1 = batch entry number';
        NoBatchLinesErr: Label 'Enter at least one batch line before creating request lines.';
        RecordIdRequiredErr: Label 'Batch entry %1 must have a record ID before request lines can be created.', Comment = '%1 = batch entry number';
        RequestRequiredErr: Label 'Create or save the correction request before adding batch lines.';
        TableRequiredErr: Label 'Select a table before creating request lines from the batch.';
}
