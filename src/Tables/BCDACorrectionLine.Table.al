namespace AKSA.BCDataAgent;

using System.Reflection;

table 88103 "BCDA Correction Line"
{
    Caption = 'BCDA Correction Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Request ID"; Code[20])
        {
            Caption = 'Request ID';
            TableRelation = "BCDA Correction Request";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(17; Type; Enum "BCDA Correction Type")
        {
            Caption = 'Type';
            InitValue = Update;

            trigger OnValidate()
            begin
                ApplyTypeDefaults();
                ResetPreviewState();
                if "Proposed New Value" <> '' then
                    ValidateDataValue();
            end;
        }
        field(3; "Table ID"; Integer)
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
                    Clear("Current Value Preview");
                    Clear("Proposed New Value");
                    ResetPreviewState();
                end;
            end;
        }
        field(4; "Table Name"; Text[250])
        {
            Caption = 'Table Name';
            Editable = false;
        }
        field(5; "Record ID"; RecordId)
        {
            Caption = 'Record ID';
            Editable = false;

            trigger OnValidate()
            var
                CurrentValueMgt: Codeunit "BCDA Current Value Mgt.";
            begin
                if Type = Type::Insert then begin
                    if Format("Record ID") <> '' then
                        Error(RecordIdMustBeEmptyForInsertErr);

                    Clear("Current Value Preview");
                    ResetPreviewState();
                    exit;
                end;

                if Format("Record ID") = '' then begin
                    Clear("Current Value Preview");
                    ResetPreviewState();
                    exit;
                end;

                if "Table ID" = 0 then
                    Error(TableRequiredBeforeRecordErr);

                if "Record ID".TableNo() <> "Table ID" then
                    Error(RecordIdTableMismatchErr, "Record ID", "Table ID");

                CurrentValueMgt.UpdateCurrentValuePreview(Rec);
                if "Proposed New Value" <> '' then
                    ValidateDataValue();
                ResetPreviewState();
            end;
        }
        field(6; "Field ID"; Integer)
        {
            Caption = 'Field ID';
            TableRelation = "Field"."No." where(TableNo = field("Table ID"), Enabled = const(true), Class = const(Normal));

            trigger OnValidate()
            var
                CurrentValueMgt: Codeunit "BCDA Current Value Mgt.";
                MetadataExplorer: Codeunit "BCDA Metadata Explorer";
            begin
                if Type = Type::Delete then begin
                    if "Field ID" <> 0 then
                        Error(FieldNotUsedForDeleteErr);

                    Clear("Field Name");
                    Clear("Current Value Preview");
                    ResetPreviewState();
                    exit;
                end;

                MetadataExplorer.ResolveFieldCaption("Table ID", "Field ID", "Table Name", "Field Name");
                CurrentValueMgt.UpdateCurrentValuePreview(Rec);
                if "Proposed New Value" <> '' then
                    ValidateDataValue();
                ResetPreviewState();
            end;
        }
        field(7; "Field Name"; Text[250])
        {
            Caption = 'Field Name';
            Editable = false;
        }
        field(8; "Proposed New Value"; Text[2048])
        {
            Caption = 'Proposed New Value';
            trigger OnValidate()
            begin
                ValidateDataValue();
                ResetPreviewState();
            end;
        }
        field(9; "Current Value Preview"; Text[2048])
        {
            Caption = 'Current Value Preview';
            Editable = false;
        }
        field(10; "Old Value Snapshot ID"; Guid)
        {
            Caption = 'Old Value Snapshot ID';
            Editable = false;
        }
        field(11; "New Value Snapshot ID"; Guid)
        {
            Caption = 'New Value Snapshot ID';
            Editable = false;
        }
        field(12; "Rollback Snapshot Mode"; Enum "BCDA Rollback Snapshot Mode")
        {
            Caption = 'Rollback Snapshot Mode';
            InitValue = "Policy Controlled";

            trigger OnValidate()
            begin
                ResetPreviewState();
            end;
        }
        field(13; "Snapshot Expires At"; DateTime)
        {
            Caption = 'Snapshot Expires At';
            Editable = false;
        }
        field(14; "Validation Mode"; Enum "BCDA Validation Mode")
        {
            Caption = 'Validation Mode';
            InitValue = "Policy Controlled";

            trigger OnValidate()
            begin
                ResetPreviewState();
            end;
        }
        field(15; "Line Status"; Enum "BCDA Line Status")
        {
            Caption = 'Line Status';
            // Editable = false;
            InitValue = Open;
        }
        field(16; "Sanitized Error"; Text[2048])
        {
            Caption = 'Sanitized Error';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Request ID", "Line No.")
        {
            Clustered = true;
        }
        key(Target; "Table ID", "Field ID")
        {
        }
        key(TargetChange; "Request ID", Type, "Table ID", "Record ID")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Request ID" = '' then
            Error(RequestRequiredErr);

        if "Line No." = 0 then
            "Line No." := GetNextLineNo();
    end;

    local procedure GetNextLineNo(): Integer
    var
        CorrectionLine: Record "BCDA Correction Line";
    begin
        CorrectionLine.SetRange("Request ID", "Request ID");
        if CorrectionLine.FindLast() then
            exit(CorrectionLine."Line No." + 10000);

        exit(10000);
    end;

    local procedure ApplyTypeDefaults()
    begin
        case Type of
            Type::Insert:
                begin
                    Clear("Record ID");
                    Clear("Current Value Preview");
                end;
            Type::Delete:
                begin
                    "Field ID" := 0;
                    Clear("Field Name");
                    Clear("Current Value Preview");
                    Clear("Proposed New Value");
                end;
        end;
    end;

    local procedure ResetPreviewState()
    begin
        "Line Status" := "Line Status"::Open;
        Clear("Sanitized Error");
    end;

    procedure ValidateDataValue()
    var
        FieldMetadata: Record "Field";
        TargetRecordRef: RecordRef;
        TargetFieldRef: FieldRef;
    begin
        if Type = Type::Delete then begin
            if "Proposed New Value" <> '' then
                Error(ProposedValueNotAllowedForDeleteErr);

            exit;
        end;

        if "Table ID" = 0 then
            Error(TableRequiredBeforeFieldErr);

        if "Field ID" = 0 then
            Error(FieldIdNotInitializedErr);

        if not FieldMetadata.Get("Table ID", "Field ID") then
            Error(FieldNotFoundErr, "Field ID", "Table ID");

        if not FieldMetadata.Enabled then
            Error(FieldDisabledErr, "Field ID", "Table ID");

        EnsureFieldClassCanBeCorrected(FieldMetadata);

        if FieldMetadata.IsPartOfPrimaryKey and not AllowsPrimaryKeyValueStaging() then
            Error(FieldPrimaryKeyNotModifiableErr, "Field ID", "Table ID");

        if IsSystemManagedField(FieldMetadata."No.") then
            Error(SystemFieldNotModifiableErr, "Field ID", "Table ID");

        if FieldMetadata.ObsoleteState = FieldMetadata.ObsoleteState::Removed then
            Error(FieldRemovedErr, "Field ID", "Table ID");

        EnsureDataValueCompatibleWithFieldType(FieldMetadata, "Proposed New Value");

        if Type = Type::Insert then
            exit;

        EnsureExistingRecordId();

        if not TargetRecordRef.Get("Record ID") then
            Error(TargetRecordNotFoundErr, "Record ID");

        TargetFieldRef := TargetRecordRef.Field("Field ID");
        if TargetFieldRef.Number() <> "Field ID" then
            Error(FieldNotFoundErr, "Field ID", "Table ID");

        TargetRecordRef.Close();
    end;

    local procedure AllowsPrimaryKeyValueStaging(): Boolean
    begin
        case Type of
            Type::Rename,
            Type::Insert:
                exit(true);
        end;

        exit(false);
    end;

    local procedure EnsureExistingRecordId()
    var
        EmptyRecordId: RecordId;
    begin
        if "Record ID" = EmptyRecordId then
            Error(RecordIdNotInitializedErr);

        if "Record ID".TableNo() <> "Table ID" then
            Error(RecordIdTableMismatchErr, "Record ID", "Table ID");
    end;

    local procedure IsSystemManagedField(FieldID: Integer): Boolean
    begin
        exit(FieldID >= 2000000000);
    end;

    local procedure EnsureFieldClassCanBeCorrected(FieldMetadata: Record "Field")
    begin
        case FieldMetadata.Class of
            FieldMetadata.Class::Normal:
                exit;
            FieldMetadata.Class::FlowField:
                Error(FlowFieldNotSupportedErr, FieldMetadata."No.", FieldMetadata.TableNo);
            FieldMetadata.Class::FlowFilter:
                Error(FlowFilterNotSupportedErr, FieldMetadata."No.", FieldMetadata.TableNo);
        end;

        Error(FieldNotNormalErr, FieldMetadata."No.", FieldMetadata.TableNo);
    end;

    local procedure EnsureDataValueCompatibleWithFieldType(FieldMetadata: Record "Field"; DataValue: Text)
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
                EnsureTextValueFitsFieldLength(FieldMetadata, DataValue);
            FieldMetadata.Type::DateFormula:
                if DataValue = '' then
                    exit
                else
                    if not Evaluate(DateFormulaValue, DataValue) then
                        Error(ProposedValueTypeMismatchErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
            FieldMetadata.Type::Boolean:
                if not Evaluate(BooleanValue, DataValue) then
                    Error(ProposedValueTypeMismatchErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
            FieldMetadata.Type::BigInteger:
                if not Evaluate(BigIntegerValue, DataValue) then
                    Error(ProposedValueTypeMismatchErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
            FieldMetadata.Type::Integer:
                if not Evaluate(IntegerValue, DataValue) then
                    Error(ProposedValueTypeMismatchErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
            FieldMetadata.Type::Decimal:
                if not Evaluate(DecimalValue, DataValue) then
                    Error(ProposedValueTypeMismatchErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
            FieldMetadata.Type::Date:
                if DataValue = '' then
                    exit
                else
                    if not Evaluate(DateValue, DataValue) then
                        Error(ProposedValueTypeMismatchErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
            FieldMetadata.Type::Time:
                if DataValue = '' then
                    exit
                else
                    if not Evaluate(TimeValue, DataValue) then
                        Error(ProposedValueTypeMismatchErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
            FieldMetadata.Type::DateTime:
                if DataValue = '' then
                    exit
                else
                    if not Evaluate(DateTimeValue, DataValue) then
                        Error(ProposedValueTypeMismatchErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
            FieldMetadata.Type::GUID:
                if DataValue = '' then
                    exit
                else
                    if not Evaluate(GuidValue, DataValue) then
                        Error(ProposedValueTypeMismatchErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
            FieldMetadata.Type::Duration:
                if not Evaluate(DurationValue, DataValue) then
                    Error(ProposedValueTypeMismatchErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
            FieldMetadata.Type::Option:
                if not IsOptionValueCompatible(FieldMetadata.OptionString, DataValue) then
                    Error(ProposedValueTypeMismatchErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
            else
                Error(FieldTypeNotSupportedErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
        end;
    end;

    local procedure EnsureTextValueFitsFieldLength(FieldMetadata: Record "Field"; DataValue: Text)
    begin
        if FieldMetadata.Len = 0 then
            exit;

        if StrLen(DataValue) > FieldMetadata.Len then
            Error(ProposedValueFieldTooLongErr, FieldMetadata."No.", FieldMetadata.TableNo, FieldMetadata.Len);
    end;

    local procedure IsOptionValueCompatible(OptionString: Text[2047]; DataValue: Text): Boolean
    var
        OptionIndex: Integer;
    begin
        if Evaluate(OptionIndex, DataValue) then
            exit((OptionIndex >= 0) and (OptionIndex < GetOptionCount(OptionString)));

        exit(OptionStringContainsValue(OptionString, DataValue));
    end;

    local procedure GetOptionCount(OptionString: Text[2047]): Integer
    var
        CommaPosition: Integer;
        OptionCount: Integer;
        RemainingOptions: Text;
    begin
        OptionCount := 1;
        RemainingOptions := OptionString;
        CommaPosition := StrPos(RemainingOptions, ',');
        while CommaPosition > 0 do begin
            OptionCount += 1;
            RemainingOptions := CopyStr(RemainingOptions, CommaPosition + 1);
            CommaPosition := StrPos(RemainingOptions, ',');
        end;

        exit(OptionCount);
    end;

    local procedure OptionStringContainsValue(OptionString: Text[2047]; DataValue: Text): Boolean
    var
        CommaPosition: Integer;
        CurrentOption: Text;
        RemainingOptions: Text;
    begin
        if OptionString = '' then
            exit(DataValue = '');

        RemainingOptions := OptionString;
        repeat
            CommaPosition := StrPos(RemainingOptions, ',');
            if CommaPosition = 0 then begin
                CurrentOption := RemainingOptions;
                RemainingOptions := '';
            end else begin
                CurrentOption := CopyStr(RemainingOptions, 1, CommaPosition - 1);
                RemainingOptions := CopyStr(RemainingOptions, CommaPosition + 1);
            end;

            if UpperCase(CurrentOption) = UpperCase(DataValue) then
                exit(true);
        until RemainingOptions = '';

        exit(false);
    end;

    var
        FieldDisabledErr: Label 'Field %1 on table %2 is disabled and cannot be selected for a correction line.', Comment = '%1 = field ID, %2 = table ID';
        FieldIdNotInitializedErr: Label 'Field ID is not initialized.';
        FieldNotUsedForDeleteErr: Label 'Field ID is not used for Delete correction lines.';
        FieldNotFoundErr: Label 'Field %1 was not found for table %2.', Comment = '%1 = field ID, %2 = table ID';
        FieldNotNormalErr: Label 'Field %1 on table %2 is not a normal stored field and cannot be selected for a correction line.', Comment = '%1 = field ID, %2 = table ID';
        FieldPrimaryKeyNotModifiableErr: Label 'Field %1 on table %2 is part of the primary key and cannot be modified by BC Data Agent.', Comment = '%1 = field ID, %2 = table ID';
        FieldRemovedErr: Label 'Field %1 on table %2 is removed and cannot be selected for a correction line.', Comment = '%1 = field ID, %2 = table ID';
        FieldTypeNotSupportedErr: Label 'Field %1 on table %2 has unsupported type %3 for foundation correction value staging.', Comment = '%1 = field ID, %2 = table ID, %3 = field type';
        FlowFieldNotSupportedErr: Label 'Field %1 on table %2 is a FlowField, such as a lookup or calculated field, and cannot be selected for a correction line.', Comment = '%1 = field ID, %2 = table ID';
        FlowFilterNotSupportedErr: Label 'Field %1 on table %2 is a FlowFilter and cannot be selected for a correction line.', Comment = '%1 = field ID, %2 = table ID';
        ProposedValueNotAllowedForDeleteErr: Label 'Proposed new value is not used for Delete correction lines.';
        ProposedValueFieldTooLongErr: Label 'Proposed new value for field %1 on table %2 cannot be longer than %3 characters.', Comment = '%1 = field ID, %2 = table ID, %3 = maximum field length';
        RecordIdTableMismatchErr: Label 'Record ID %1 does not belong to table %2.', Comment = '%1 = record ID, %2 = table ID';
        RecordIdMustBeEmptyForInsertErr: Label 'Record ID must be empty for Insert correction lines.';
        RecordIdNotInitializedErr: Label 'Record ID is not initialized.';
        ProposedValueTypeMismatchErr: Label 'Proposed new value is not compatible with field %1 on table %2 type %3.', Comment = '%1 = field ID, %2 = table ID, %3 = field type';
        RequestRequiredErr: Label 'A correction line must belong to a saved correction request.';
        SystemFieldNotModifiableErr: Label 'Field %1 on table %2 is system-managed and cannot be modified by BC Data Agent.', Comment = '%1 = field ID, %2 = table ID';
        TableRequiredBeforeFieldErr: Label 'Select a table before selecting a field.';
        TableRequiredBeforeRecordErr: Label 'Select a table before selecting a record.';
        TargetRecordNotFoundErr: Label 'Target record %1 was not found.', Comment = '%1 = record ID';
}
