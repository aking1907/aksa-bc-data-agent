namespace AKSA.BCDataAgent;

using System.Reflection;

codeunit 88132 "BCDA Rollback Service"
{
    Access = Internal;

    procedure RollbackAuditEntry(var SourceAuditEntry: Record "BCDA Audit Entry")
    var
        CorrectionLine: Record "BCDA Correction Line";
        CorrectionRequest: Record "BCDA Correction Request";
        NewValueSnapshot: Record "BCDA Value Snapshot";
        OldValueSnapshot: Record "BCDA Value Snapshot";
        RollbackOperation: Record "BCDA Rollback Operation";
        AccessMgt: Codeunit "BCDA Access Mgt.";
        AuditWriter: Codeunit "BCDA Audit Writer";
        FailureMessage: Text[2048];
    begin
        AccessMgt.EnsureSuperUser();
        EnsureSourceAuditEntrySelected(SourceAuditEntry);
        GetSourceRequestAndLine(SourceAuditEntry, CorrectionRequest, CorrectionLine);

        CreateRollbackOperation(SourceAuditEntry, RollbackOperation);

        if not TryValidateRollbackPrerequisites(SourceAuditEntry, CorrectionRequest, CorrectionLine, OldValueSnapshot, NewValueSnapshot) then begin
            FailureMessage := CopyStr(GetLastErrorText(), 1, MaxStrLen(FailureMessage));
            MarkRollbackFailed(RollbackOperation, CorrectionRequest, CorrectionLine, FailureMessage, "BCDA Audit Result"::Blocked);
            exit;
        end;

        if not TryApplyUpdateRollback(CorrectionLine, OldValueSnapshot."Serialized Value") then begin
            FailureMessage := RollbackPlatformFailureTxt;
            MarkRollbackFailed(RollbackOperation, CorrectionRequest, CorrectionLine, FailureMessage, "BCDA Audit Result"::Failed);
            exit;
        end;

        MarkRollbackSucceeded(RollbackOperation, CorrectionLine, OldValueSnapshot);
        AuditWriter.WriteLineAudit(CorrectionRequest, CorrectionLine, "BCDA Audit Operation"::Rollback, "BCDA Audit Result"::Success, '');
    end;

    local procedure EnsureSourceAuditEntrySelected(SourceAuditEntry: Record "BCDA Audit Entry")
    begin
        if SourceAuditEntry."Entry No." = 0 then
            Error(SourceAuditEntryRequiredErr);
    end;

    local procedure GetSourceRequestAndLine(SourceAuditEntry: Record "BCDA Audit Entry"; var CorrectionRequest: Record "BCDA Correction Request"; var CorrectionLine: Record "BCDA Correction Line")
    begin
        if SourceAuditEntry."Request ID" = '' then
            Error(SourceRequestMissingErr, SourceAuditEntry."Entry No.");

        if SourceAuditEntry."Line No." = 0 then
            Error(SourceLineMissingErr, SourceAuditEntry."Entry No.");

        if not CorrectionRequest.Get(SourceAuditEntry."Request ID") then
            Error(SourceRequestNotFoundErr, SourceAuditEntry."Request ID");

        if not CorrectionLine.Get(SourceAuditEntry."Request ID", SourceAuditEntry."Line No.") then
            Error(SourceLineNotFoundErr, SourceAuditEntry."Request ID", SourceAuditEntry."Line No.");
    end;

    local procedure CreateRollbackOperation(SourceAuditEntry: Record "BCDA Audit Entry"; var RollbackOperation: Record "BCDA Rollback Operation")
    begin
        RollbackOperation.Init();
        RollbackOperation."Source Request ID" := SourceAuditEntry."Request ID";
        RollbackOperation."Source Audit Entry No." := SourceAuditEntry."Entry No.";
        RollbackOperation.Status := RollbackOperation.Status::Executing;
        RollbackOperation."Conflict Policy" := RollbackOperation."Conflict Policy"::"Stop On Conflict";
        RollbackOperation.Insert(true);
    end;

    [TryFunction]
    local procedure TryValidateRollbackPrerequisites(SourceAuditEntry: Record "BCDA Audit Entry"; CorrectionRequest: Record "BCDA Correction Request"; CorrectionLine: Record "BCDA Correction Line"; var OldValueSnapshot: Record "BCDA Value Snapshot"; var NewValueSnapshot: Record "BCDA Value Snapshot")
    var
        FieldMetadata: Record "Field";
    begin
        EnsureSourceAuditEntryCanRollback(SourceAuditEntry);
        EnsureNoCompletedRollbackExists(SourceAuditEntry);
        EnsureSourceLineCanRollback(SourceAuditEntry, CorrectionLine);
        EnsureSourceSnapshotsMatchLine(SourceAuditEntry, CorrectionLine);
        GetRollbackSnapshots(SourceAuditEntry, OldValueSnapshot, NewValueSnapshot);
        EnsureSnapshotUsable(OldValueSnapshot, SourceAuditEntry."Entry No.", OldSnapshotTxt);
        EnsureSnapshotUsable(NewValueSnapshot, SourceAuditEntry."Entry No.", NewSnapshotTxt);
        EnsureSnapshotBelongsToLine(OldValueSnapshot, CorrectionLine, OldSnapshotTxt);
        EnsureSnapshotBelongsToLine(NewValueSnapshot, CorrectionLine, NewSnapshotTxt);
        EnsureRollbackPolicyAllows(CorrectionRequest, CorrectionLine);

        FieldMetadata.Get(CorrectionLine."Table ID", CorrectionLine."Field ID");
        EnsureFieldCanRollback(FieldMetadata);
        EnsureDataValueCompatibleWithFieldType(FieldMetadata, OldValueSnapshot."Serialized Value");
        EnsureCurrentValueMatchesExecutedValue(CorrectionLine, NewValueSnapshot."Serialized Value");
    end;

    local procedure EnsureSourceAuditEntryCanRollback(SourceAuditEntry: Record "BCDA Audit Entry")
    begin
        if SourceAuditEntry.Operation <> SourceAuditEntry.Operation::Execution then
            Error(SourceAuditOperationErr, SourceAuditEntry."Entry No.");

        if SourceAuditEntry.Result <> SourceAuditEntry.Result::Success then
            Error(SourceAuditResultErr, SourceAuditEntry."Entry No.");

        if not SourceAuditEntry."Rollback Available" then
            Error(SourceAuditRollbackUnavailableErr, SourceAuditEntry."Entry No.");

        if IsNullGuid(SourceAuditEntry."Old Snapshot ID") or IsNullGuid(SourceAuditEntry."New Snapshot ID") then
            Error(SourceAuditSnapshotMissingErr, SourceAuditEntry."Entry No.");
    end;

    local procedure EnsureNoCompletedRollbackExists(SourceAuditEntry: Record "BCDA Audit Entry")
    var
        ExistingRollbackOperation: Record "BCDA Rollback Operation";
    begin
        ExistingRollbackOperation.SetRange("Source Request ID", SourceAuditEntry."Request ID");
        ExistingRollbackOperation.SetRange("Source Audit Entry No.", SourceAuditEntry."Entry No.");
        ExistingRollbackOperation.SetRange(Status, ExistingRollbackOperation.Status::Completed);
        if not ExistingRollbackOperation.IsEmpty() then
            Error(SourceAlreadyRolledBackErr, SourceAuditEntry."Entry No.");
    end;

    local procedure EnsureSourceLineCanRollback(SourceAuditEntry: Record "BCDA Audit Entry"; CorrectionLine: Record "BCDA Correction Line")
    begin
        if CorrectionLine.Type <> CorrectionLine.Type::Update then
            Error(SourceLineTypeErr, SourceAuditEntry."Entry No.");

        if CorrectionLine."Line Status" = CorrectionLine."Line Status"::"Rolled Back" then
            Error(SourceAlreadyRolledBackErr, SourceAuditEntry."Entry No.");

        if CorrectionLine."Line Status" <> CorrectionLine."Line Status"::Executed then
            Error(SourceLineStatusErr, CorrectionLine."Line No.", Format(CorrectionLine."Line Status"));
    end;

    local procedure EnsureSourceSnapshotsMatchLine(SourceAuditEntry: Record "BCDA Audit Entry"; CorrectionLine: Record "BCDA Correction Line")
    begin
        if (CorrectionLine."Old Value Snapshot ID" <> SourceAuditEntry."Old Snapshot ID") or
           (CorrectionLine."New Value Snapshot ID" <> SourceAuditEntry."New Snapshot ID")
        then
            Error(SourceSnapshotMismatchErr, SourceAuditEntry."Entry No.");
    end;

    local procedure GetRollbackSnapshots(SourceAuditEntry: Record "BCDA Audit Entry"; var OldValueSnapshot: Record "BCDA Value Snapshot"; var NewValueSnapshot: Record "BCDA Value Snapshot")
    begin
        if not OldValueSnapshot.Get(SourceAuditEntry."Old Snapshot ID") then
            Error(SourceSnapshotNotFoundErr, SourceAuditEntry."Entry No.", OldSnapshotTxt);

        if not NewValueSnapshot.Get(SourceAuditEntry."New Snapshot ID") then
            Error(SourceSnapshotNotFoundErr, SourceAuditEntry."Entry No.", NewSnapshotTxt);
    end;

    local procedure EnsureSnapshotUsable(ValueSnapshot: Record "BCDA Value Snapshot"; SourceAuditEntryNo: Integer; SnapshotName: Text)
    begin
        if ValueSnapshot.Purged then
            Error(SourceSnapshotPurgedErr, SourceAuditEntryNo, SnapshotName);

        if (ValueSnapshot."Expires At" <> 0DT) and (ValueSnapshot."Expires At" < CurrentDateTime()) then
            Error(SourceSnapshotExpiredErr, SourceAuditEntryNo, SnapshotName);
    end;

    local procedure EnsureSnapshotBelongsToLine(ValueSnapshot: Record "BCDA Value Snapshot"; CorrectionLine: Record "BCDA Correction Line"; SnapshotName: Text)
    begin
        if (ValueSnapshot."Request ID" <> CorrectionLine."Request ID") or
           (ValueSnapshot."Line No." <> CorrectionLine."Line No.")
        then
            Error(SourceSnapshotLineMismatchErr, SnapshotName, CorrectionLine."Request ID", CorrectionLine."Line No.");
    end;

    local procedure EnsureRollbackPolicyAllows(CorrectionRequest: Record "BCDA Correction Request"; CorrectionLine: Record "BCDA Correction Line")
    var
        PolicyGuard: Codeunit "BCDA Policy Guard";
        Decision: Enum "BCDA Policy Decision";
        DecisionReason: Text[250];
    begin
        PolicyGuard.EvaluateLine(CorrectionLine, Decision, DecisionReason);
        case Decision of
            Decision::Block:
                Error(RollbackBlockedByPolicyErr, CorrectionLine."Line No.", DecisionReason);
            Decision::"Approval Required":
                if CorrectionRequest."Approved At" = 0DT then
                    Error(RollbackRequiresApprovedRequestErr, CorrectionLine."Line No.", DecisionReason);
        end;
    end;

    local procedure EnsureFieldCanRollback(FieldMetadata: Record "Field")
    begin
        if not FieldMetadata.Enabled then
            Error(FieldDisabledErr, FieldMetadata."No.", FieldMetadata.TableNo);

        if FieldMetadata.Class <> FieldMetadata.Class::Normal then
            Error(FieldNotNormalErr, FieldMetadata."No.", FieldMetadata.TableNo);

        if FieldMetadata.IsPartOfPrimaryKey then
            Error(FieldPrimaryKeyNotRollbackableErr, FieldMetadata."No.", FieldMetadata.TableNo);

        if IsSystemManagedField(FieldMetadata."No.") then
            Error(SystemFieldNotRollbackableErr, FieldMetadata."No.", FieldMetadata.TableNo);

        if FieldMetadata.ObsoleteState = FieldMetadata.ObsoleteState::Removed then
            Error(FieldRemovedErr, FieldMetadata."No.", FieldMetadata.TableNo);
    end;

    local procedure EnsureCurrentValueMatchesExecutedValue(CorrectionLine: Record "BCDA Correction Line"; ExpectedNewValue: Text[2048])
    var
        TargetFieldRef: FieldRef;
        TargetRecordRef: RecordRef;
        CurrentValueText: Text[2048];
    begin
        if not TargetRecordRef.Get(CorrectionLine."Record ID") then
            Error(TargetRecordNotFoundErr, CorrectionLine."Line No.");

        TargetFieldRef := TargetRecordRef.Field(CorrectionLine."Field ID");
        CurrentValueText := CopyStr(Format(TargetFieldRef.Value()), 1, MaxStrLen(CurrentValueText));
        TargetRecordRef.Close();

        if CurrentValueText <> ExpectedNewValue then
            Error(RollbackConflictErr, CorrectionLine."Line No.");
    end;

    [TryFunction]
    local procedure TryApplyUpdateRollback(CorrectionLine: Record "BCDA Correction Line"; OldValue: Text[2048])
    var
        FieldMetadata: Record "Field";
        TargetFieldRef: FieldRef;
        TargetRecordRef: RecordRef;
    begin
        FieldMetadata.Get(CorrectionLine."Table ID", CorrectionLine."Field ID");
        if not TargetRecordRef.Get(CorrectionLine."Record ID") then
            Error(TargetRecordNotFoundErr, CorrectionLine."Line No.");

        TargetFieldRef := TargetRecordRef.Field(CorrectionLine."Field ID");
        SetTargetFieldValue(TargetFieldRef, FieldMetadata, OldValue);
        TargetRecordRef.Modify(true);
        TargetRecordRef.Close();
    end;

    local procedure MarkRollbackSucceeded(var RollbackOperation: Record "BCDA Rollback Operation"; var CorrectionLine: Record "BCDA Correction Line"; OldValueSnapshot: Record "BCDA Value Snapshot")
    begin
        CorrectionLine."Current Value Preview" := CopyStr(OldValueSnapshot."Display Value", 1, MaxStrLen(CorrectionLine."Current Value Preview"));
        CorrectionLine."Line Status" := CorrectionLine."Line Status"::"Rolled Back";
        Clear(CorrectionLine."Sanitized Error");
        CorrectionLine.Modify(true);

        RollbackOperation.Status := RollbackOperation.Status::Completed;
        RollbackOperation.Result := RollbackOperation.Result::Success;
        RollbackOperation."Completed By" := CopyStr(UserId(), 1, MaxStrLen(RollbackOperation."Completed By"));
        RollbackOperation."Completed At" := CurrentDateTime();
        Clear(RollbackOperation."Sanitized Error");
        RollbackOperation.Modify(true);
    end;

    local procedure MarkRollbackFailed(var RollbackOperation: Record "BCDA Rollback Operation"; CorrectionRequest: Record "BCDA Correction Request"; var CorrectionLine: Record "BCDA Correction Line"; FailureMessage: Text[2048]; Result: Enum "BCDA Audit Result")
    var
        AuditWriter: Codeunit "BCDA Audit Writer";
    begin
        CorrectionLine."Sanitized Error" := CopyStr(FailureMessage, 1, MaxStrLen(CorrectionLine."Sanitized Error"));
        CorrectionLine.Modify(true);

        RollbackOperation.Status := RollbackOperation.Status::Failed;
        RollbackOperation.Result := Result;
        RollbackOperation."Completed By" := CopyStr(UserId(), 1, MaxStrLen(RollbackOperation."Completed By"));
        RollbackOperation."Completed At" := CurrentDateTime();
        RollbackOperation."Sanitized Error" := CopyStr(FailureMessage, 1, MaxStrLen(RollbackOperation."Sanitized Error"));
        RollbackOperation.Modify(true);

        AuditWriter.WriteLineAudit(CorrectionRequest, CorrectionLine, "BCDA Audit Operation"::Rollback, Result, FailureMessage);
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
                Error(FieldTypeNotSupportedForRollbackErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
        end;
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
                    Error(FieldValueTypeMismatchErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
            FieldMetadata.Type::Boolean:
                if not Evaluate(BooleanValue, DataValue) then
                    Error(FieldValueTypeMismatchErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
            FieldMetadata.Type::BigInteger:
                if not Evaluate(BigIntegerValue, DataValue) then
                    Error(FieldValueTypeMismatchErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
            FieldMetadata.Type::Integer:
                if not Evaluate(IntegerValue, DataValue) then
                    Error(FieldValueTypeMismatchErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
            FieldMetadata.Type::Decimal:
                if not Evaluate(DecimalValue, DataValue) then
                    Error(FieldValueTypeMismatchErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
            FieldMetadata.Type::Date:
                if DataValue = '' then
                    exit
                else
                if not Evaluate(DateValue, DataValue) then
                    Error(FieldValueTypeMismatchErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
            FieldMetadata.Type::Time:
                if DataValue = '' then
                    exit
                else
                if not Evaluate(TimeValue, DataValue) then
                    Error(FieldValueTypeMismatchErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
            FieldMetadata.Type::DateTime:
                if DataValue = '' then
                    exit
                else
                if not Evaluate(DateTimeValue, DataValue) then
                    Error(FieldValueTypeMismatchErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
            FieldMetadata.Type::GUID:
                if DataValue = '' then
                    exit
                else
                if not Evaluate(GuidValue, DataValue) then
                    Error(FieldValueTypeMismatchErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
            FieldMetadata.Type::Duration:
                if not Evaluate(DurationValue, DataValue) then
                    Error(FieldValueTypeMismatchErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
            FieldMetadata.Type::Option:
                if not IsOptionValueCompatible(FieldMetadata.OptionString, DataValue) then
                    Error(FieldValueTypeMismatchErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
            else
                Error(FieldTypeNotSupportedForRollbackErr, FieldMetadata."No.", FieldMetadata.TableNo, Format(FieldMetadata.Type));
        end;
    end;

    local procedure EnsureTextValueFitsFieldLength(FieldMetadata: Record "Field"; DataValue: Text)
    begin
        if FieldMetadata.Len = 0 then
            exit;

        if StrLen(DataValue) > FieldMetadata.Len then
            Error(FieldValueTooLongErr, FieldMetadata."No.", FieldMetadata.TableNo, FieldMetadata.Len);
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

    local procedure IsSystemManagedField(FieldID: Integer): Boolean
    begin
        exit(FieldID >= 2000000000);
    end;

    var
        OldSnapshotTxt: Label 'old value snapshot';
        NewSnapshotTxt: Label 'new value snapshot';
        SourceAuditEntryRequiredErr: Label 'Select an execution audit entry before requesting rollback.';
        SourceRequestMissingErr: Label 'Audit entry %1 does not reference a correction request.', Comment = '%1 = audit entry number';
        SourceLineMissingErr: Label 'Audit entry %1 does not reference a correction line.', Comment = '%1 = audit entry number';
        SourceRequestNotFoundErr: Label 'Correction request %1 was not found for rollback.', Comment = '%1 = request ID';
        SourceLineNotFoundErr: Label 'Correction line %2 was not found for request %1.', Comment = '%1 = request ID, %2 = line number';
        SourceAuditOperationErr: Label 'Audit entry %1 is not a successful execution entry and cannot be rolled back.', Comment = '%1 = audit entry number';
        SourceAuditResultErr: Label 'Audit entry %1 did not succeed and cannot be rolled back.', Comment = '%1 = audit entry number';
        SourceAuditRollbackUnavailableErr: Label 'Audit entry %1 has no rollback material available.', Comment = '%1 = audit entry number';
        SourceAuditSnapshotMissingErr: Label 'Audit entry %1 is missing rollback snapshot references.', Comment = '%1 = audit entry number';
        SourceAlreadyRolledBackErr: Label 'Audit entry %1 has already been rolled back.', Comment = '%1 = audit entry number';
        SourceLineTypeErr: Label 'Audit entry %1 can roll back only Phase 7 supported Update execution lines.', Comment = '%1 = audit entry number';
        SourceLineStatusErr: Label 'Line %1 must be executed before rollback. Current line status is %2.', Comment = '%1 = line number, %2 = line status';
        SourceSnapshotMismatchErr: Label 'Audit entry %1 no longer matches the correction line rollback snapshot references.', Comment = '%1 = audit entry number';
        SourceSnapshotNotFoundErr: Label 'Audit entry %1 %2 was not found.', Comment = '%1 = audit entry number, %2 = snapshot name';
        SourceSnapshotPurgedErr: Label 'Audit entry %1 %2 has been purged and cannot be used for rollback.', Comment = '%1 = audit entry number, %2 = snapshot name';
        SourceSnapshotExpiredErr: Label 'Audit entry %1 %2 has expired and cannot be used for rollback.', Comment = '%1 = audit entry number, %2 = snapshot name';
        SourceSnapshotLineMismatchErr: Label 'The %1 does not belong to request %2 line %3.', Comment = '%1 = snapshot name, %2 = request ID, %3 = line number';
        RollbackBlockedByPolicyErr: Label 'Rollback for line %1 is blocked by data policy: %2', Comment = '%1 = line number, %2 = policy reason';
        RollbackRequiresApprovedRequestErr: Label 'Rollback for line %1 requires an approved request because policy requires approval: %2', Comment = '%1 = line number, %2 = policy reason';
        RollbackConflictErr: Label 'Rollback conflict on line %1. The current target value no longer matches the executed value.', Comment = '%1 = line number';
        RollbackPlatformFailureTxt: Label 'Rollback failed during Business Central target validation or write. Target values are not logged.';
        TargetRecordNotFoundErr: Label 'Line %1 target record was not found.', Comment = '%1 = line number';
        FieldDisabledErr: Label 'Field %1 on table %2 is disabled and cannot be rolled back.', Comment = '%1 = field ID, %2 = table ID';
        FieldNotNormalErr: Label 'Field %1 on table %2 is not a normal stored field and cannot be rolled back.', Comment = '%1 = field ID, %2 = table ID';
        FieldPrimaryKeyNotRollbackableErr: Label 'Field %1 on table %2 is part of the primary key and cannot be rolled back in Phase 7.', Comment = '%1 = field ID, %2 = table ID';
        FieldRemovedErr: Label 'Field %1 on table %2 is removed and cannot be rolled back.', Comment = '%1 = field ID, %2 = table ID';
        SystemFieldNotRollbackableErr: Label 'Field %1 on table %2 is system-managed and cannot be rolled back.', Comment = '%1 = field ID, %2 = table ID';
        FieldTypeNotSupportedForRollbackErr: Label 'Field %1 on table %2 has unsupported type %3 for rollback.', Comment = '%1 = field ID, %2 = table ID, %3 = field type';
        FieldValueTypeMismatchErr: Label 'Rollback snapshot value is not compatible with field %1 on table %2 type %3.', Comment = '%1 = field ID, %2 = table ID, %3 = field type';
        FieldValueTooLongErr: Label 'Rollback snapshot value for field %1 on table %2 cannot be longer than %3 characters.', Comment = '%1 = field ID, %2 = table ID, %3 = maximum field length';
}
