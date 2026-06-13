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
            CorrectionLine.Validate(Type, TempBatchLine.Type);
            if TempBatchLine.Type = TempBatchLine.Type::Insert then
                CorrectionLine.Validate("Insert Group No.", TempBatchLine."Insert Group No.");
            CorrectionLine.Validate("Table ID", TableId);
            if TempBatchLine.Type <> TempBatchLine.Type::Insert then
                CorrectionLine.Validate("Record ID", TempBatchLine."Record ID");
            if TempBatchLine.Type <> TempBatchLine.Type::Delete then begin
                CorrectionLine.Validate("Field ID", TempBatchLine."Field ID");
                CorrectionLine.Validate("Proposed New Value", TempBatchLine."Proposed New Value");
            end else
                if TempBatchLine."Proposed New Value" <> '' then
                    Error(ProposedValueNotAllowedForDeleteErr, TempBatchLine."Entry No.");
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

        if (TempBatchLine.Type <> TempBatchLine.Type::Insert) and (Format(TempBatchLine."Record ID") = '') then
            Error(RecordIdRequiredErr, TempBatchLine."Entry No.");

        if (TempBatchLine.Type = TempBatchLine.Type::Insert) and (Format(TempBatchLine."Record ID") <> '') then
            Error(RecordIdMustBeEmptyForInsertErr, TempBatchLine."Entry No.");

        if (TempBatchLine.Type = TempBatchLine.Type::Insert) and (TempBatchLine."Insert Group No." <= 0) then
            Error(InsertGroupRequiredErr, TempBatchLine."Entry No.");

        if (TempBatchLine.Type <> TempBatchLine.Type::Insert) and (TempBatchLine."Insert Group No." <> 0) then
            Error(InsertGroupOnlyForInsertErr, TempBatchLine."Entry No.");

        if (TempBatchLine.Type <> TempBatchLine.Type::Delete) and (TempBatchLine."Field ID" = 0) then
            Error(FieldRequiredErr, TempBatchLine."Entry No.");

        if (TempBatchLine.Type = TempBatchLine.Type::Delete) and (TempBatchLine."Field ID" <> 0) then
            Error(FieldNotAllowedForDeleteErr, TempBatchLine."Entry No.");
    end;

    var
        FieldNotAllowedForDeleteErr: Label 'Batch entry %1 must not have a field ID for Delete correction lines.', Comment = '%1 = batch entry number';
        FieldRequiredErr: Label 'Batch entry %1 must have a field ID before request lines can be created. Rename entries must select a primary-key field; Insert and Update entries select the field to write.', Comment = '%1 = batch entry number';
        InsertGroupOnlyForInsertErr: Label 'Batch entry %1 must not have an Insert Group No. unless it is an Insert correction line.', Comment = '%1 = batch entry number';
        InsertGroupRequiredErr: Label 'Batch entry %1 must have an Insert Group No. greater than zero for Insert correction lines. Use one group per new record.', Comment = '%1 = batch entry number';
        MixedTableErr: Label 'Batch entry %1 does not match the selected batch table.', Comment = '%1 = batch entry number';
        NoBatchLinesErr: Label 'Enter at least one batch line before creating request lines.';
        ProposedValueNotAllowedForDeleteErr: Label 'Batch entry %1 must not have a proposed value for Delete correction lines.', Comment = '%1 = batch entry number';
        RecordIdMustBeEmptyForInsertErr: Label 'Batch entry %1 must not have a target record identity for Insert correction lines. Use Insert Group No. to group fields for each new record.', Comment = '%1 = batch entry number';
        RecordIdRequiredErr: Label 'Batch entry %1 must select an existing target record before request lines can be created. Use Select Existing Record; the lookup shows simple and composite primary-key values.', Comment = '%1 = batch entry number';
        RequestRequiredErr: Label 'Create or save the correction request before adding batch lines.';
        TableRequiredErr: Label 'Select a table before creating request lines from the batch.';
}
