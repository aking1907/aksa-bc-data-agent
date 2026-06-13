namespace AKSA.BCDataAgent;

page 88115 "BCDA Correction Lines"
{
    ApplicationArea = All;
    Caption = 'BCDA Correction Lines';
    PageType = ListPart;
    SourceTable = "BCDA Correction Line";

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the correction line number.';
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies whether this line stages an update, rename, delete, or insert operation. Rename selects an existing record and stages primary-key fields; Insert uses Insert Group No. instead of an existing target record.';

                    trigger OnValidate()
                    begin
                        UpdateLineContext();
                        CurrPage.Update(false);
                    end;
                }
                field(OperationTarget; OperationTarget)
                {
                    Caption = 'Operation Target';
                    Editable = false;
                    ToolTip = 'Shows whether this line targets an existing record selected by primary-key lookup or a new record grouped by Insert Group No.';
                }
                field("Insert Group No."; Rec."Insert Group No.")
                {
                    Editable = IsInsertLine;
                    ToolTip = 'Specifies which Insert lines create the same new record. Use the same group number for fields on one inserted record, and a different group number for each additional inserted record.';
                }
                field("Table ID"; Rec."Table ID")
                {
                    ToolTip = 'Specifies the target table ID.';
                }
                field("Table Name"; Rec."Table Name")
                {
                    ToolTip = 'Specifies the target table name.';
                }
                field("Record ID"; format(Rec."Record ID"))
                {
                    AssistEdit = true;
                    Caption = 'Target Record Identity';
                    Editable = false;
                    ToolTip = 'Specifies the target record identity selected for existing-record lines. Use the assist edit button or Select Existing Record; the lookup shows simple and composite primary-key values. Insert lines leave this empty while staged and show the created identity after successful execution.';

                    trigger OnAssistEdit()
                    begin
                        SelectTargetRecord();
                    end;
                }
                field("Field ID"; Rec."Field ID")
                {
                    ToolTip = 'Specifies the target field ID. Rename lines must select a primary-key field; Insert and Update lines select the field value to write.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }
                field("Field Name"; Rec."Field Name")
                {
                    ToolTip = 'Specifies the target field name.';
                }
                field("Current Value Preview"; Rec."Current Value Preview")
                {
                    Editable = false;
                    ToolTip = 'Specifies the current value for the selected record and field.';
                }
                field("Proposed New Value"; Rec."Proposed New Value")
                {
                    ToolTip = 'Specifies the proposed new value text. For Rename, this is the new primary-key value for the selected key field.';
                }
                field("Rollback Snapshot Mode"; Rec."Rollback Snapshot Mode")
                {
                    ToolTip = 'Specifies rollback snapshot mode for the line.';
                }
                field("Validation Mode"; Rec."Validation Mode")
                {
                    ToolTip = 'Specifies validation mode for the line.';
                }
                field("Line Status"; Rec."Line Status")
                {
                    ToolTip = 'Specifies the line status.';
                }
                field("Sanitized Error"; Rec."Sanitized Error")
                {
                    ToolTip = 'Specifies sanitized error details.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SelectRecord)
            {
                ApplicationArea = All;
                Caption = 'Select Existing Record';
                Image = View;
                ToolTip = 'Opens target record lookup and fills the target record identity for the selected Update, Rename, or Delete correction line.';

                trigger OnAction()
                begin
                    SelectTargetRecord();
                end;
            }
            action(PreviewDataMatrix)
            {
                ApplicationArea = All;
                Caption = 'Preview Data Matrix';
                Image = ShowMatrix;
                ToolTip = 'Opens a read-only matrix preview for correction lines in the current request.';

                trigger OnAction()
                var
                    PreviewDataMatrix: Page "BCDA Preview Data Matrix";
                begin
                    if Rec."Request ID" = '' then
                        Error(RequestRequiredBeforeMatrixErr);

                    CurrPage.SaveRecord();
                    PreviewDataMatrix.SetData(Rec."Request ID");
                    PreviewDataMatrix.RunModal();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        AccessMgt: Codeunit "BCDA Access Mgt.";
    begin
        AccessMgt.EnsureSuperUser();
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateLineContext();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        UpdateLineContext();
    end;

    local procedure SelectTargetRecord()
    var
        TargetRecordLookup: Page "BCDA Target Record Lookup";
    begin
        if Rec.Type = Rec.Type::Insert then
            Error(RecordIdNotUsedForInsertErr);

        if Rec."Table ID" = 0 then
            Error(TableRequiredBeforeRecordErr);

        TargetRecordLookup.SetTargetTable(Rec."Table ID");
        TargetRecordLookup.LookupMode(true);
        if TargetRecordLookup.RunModal() = Action::LookupOK then begin
            Rec.Validate("Record ID", TargetRecordLookup.GetSelectedRecordId());
            Rec.Modify(true);
            CurrPage.Update();
        end;
    end;

    local procedure UpdateLineContext()
    begin
        IsInsertLine := Rec.Type = Rec.Type::Insert;
        OperationTarget := ResolveOperationTarget();
    end;

    local procedure ResolveOperationTarget(): Text[80]
    begin
        case Rec.Type of
            Rec.Type::Rename:
                exit(RenameOperationTargetTxt);
            Rec.Type::Delete:
                exit(DeleteOperationTargetTxt);
            Rec.Type::Insert:
                exit(InsertOperationTargetTxt);
        end;

        exit(UpdateOperationTargetTxt);
    end;

    var
        DeleteOperationTargetTxt: Label 'Existing record delete';
        IsInsertLine: Boolean;
        InsertOperationTargetTxt: Label 'New record insert group';
        OperationTarget: Text[80];
        RecordIdNotUsedForInsertErr: Label 'Target record identity is not selected for Insert correction lines. Use Insert Group No. to group fields for each new record; execution stores the created identity after a successful insert.';
        RenameOperationTargetTxt: Label 'Existing record primary-key rename';
        RequestRequiredBeforeMatrixErr: Label 'Save the correction request before previewing the data matrix.';
        TableRequiredBeforeRecordErr: Label 'Select a table before selecting a record.';
        UpdateOperationTargetTxt: Label 'Existing record field update';
}
