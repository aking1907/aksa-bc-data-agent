namespace AKSA.BCDataAgent;

using System.Reflection;

table 88108 "BCDA Batch Line Buffer"
{
    Caption = 'BCDA Batch Line Buffer';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(10; Type; Enum "BCDA Correction Type")
        {
            Caption = 'Type';
            InitValue = Update;

            trigger OnValidate()
            begin
                if Type <> Type::Insert then
                    "Insert Group No." := 0;

                case Type of
                    Type::Insert:
                        begin
                            Clear("Record ID");
                            if "Insert Group No." = 0 then
                                "Insert Group No." := 1;
                        end;
                    Type::Delete:
                        begin
                            "Field ID" := 0;
                            Clear("Field Name");
                            Clear("Proposed New Value");
                        end;
                end;
            end;
        }
        field(11; "Insert Group No."; Integer)
        {
            Caption = 'Insert Group No.';

            trigger OnValidate()
            begin
                if "Insert Group No." < 0 then
                    Error(InsertGroupNoMustBePositiveErr);

                if (Type <> Type::Insert) and ("Insert Group No." <> 0) then
                    Error(InsertGroupOnlyForInsertErr);
            end;
        }
        field(2; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            NotBlank = true;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));

            trigger OnValidate()
            var
                MetadataExplorer: Codeunit "BCDA Metadata Explorer";
            begin
                MetadataExplorer.ResolveTableCaption("Table ID", "Table Name");
                if "Table ID" <> xRec."Table ID" then begin
                    Clear("Record ID");
                    "Field ID" := 0;
                    Clear("Field Name");
                end;
            end;
        }
        field(3; "Table Name"; Text[250])
        {
            Caption = 'Table Name';
            Editable = false;
        }
        field(4; "Record ID"; RecordId)
        {
            Caption = 'Record ID';
            Editable = false;

            trigger OnValidate()
            begin
                if Type = Type::Insert then begin
                    if Format("Record ID") <> '' then
                        Error(RecordIdMustBeEmptyForInsertErr);

                    exit;
                end;

                if Format("Record ID") = '' then
                    exit;

                if "Table ID" = 0 then
                    Error(TableRequiredBeforeRecordErr);

                if "Record ID".TableNo() <> "Table ID" then
                    Error(RecordIdTableMismatchErr, "Record ID", "Table ID");
            end;
        }
        field(5; "Field ID"; Integer)
        {
            Caption = 'Field ID';
            TableRelation = "Field"."No." where(TableNo = field("Table ID"), Enabled = const(true), Class = const(Normal));

            trigger OnValidate()
            var
                MetadataExplorer: Codeunit "BCDA Metadata Explorer";
            begin
                if Type = Type::Delete then begin
                    if "Field ID" <> 0 then
                        Error(FieldNotUsedForDeleteErr);

                    Clear("Field Name");
                    exit;
                end;

                MetadataExplorer.ResolveFieldCaption("Table ID", "Field ID", "Table Name", "Field Name");
            end;
        }
        field(6; "Field Name"; Text[250])
        {
            Caption = 'Field Name';
            Editable = false;
        }
        field(7; "Proposed New Value"; Text[2048])
        {
            Caption = 'Proposed New Value';
        }
        field(8; "Rollback Snapshot Mode"; Enum "BCDA Rollback Snapshot Mode")
        {
            Caption = 'Rollback Snapshot Mode';
            InitValue = "Policy Controlled";
        }
        field(9; "Validation Mode"; Enum "BCDA Validation Mode")
        {
            Caption = 'Validation Mode';
            InitValue = "Policy Controlled";
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        FieldNotUsedForDeleteErr: Label 'Field ID is not used for Delete batch entries.';
        InsertGroupNoMustBePositiveErr: Label 'Insert Group No. cannot be negative.';
        InsertGroupOnlyForInsertErr: Label 'Insert Group No. is only used for Insert batch entries.';
        RecordIdMustBeEmptyForInsertErr: Label 'Target record identity must be empty while staging Insert correction lines. Use Insert Group No. to group fields for each new record; execution stores the created identity after a successful insert.';
        RecordIdTableMismatchErr: Label 'Target record identity %1 does not belong to table %2.', Comment = '%1 = record ID, %2 = table ID';
        TableRequiredBeforeRecordErr: Label 'Select a table before selecting a record.';
}
