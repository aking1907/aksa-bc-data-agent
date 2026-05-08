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
                    Caption = 'Record ID';
                    Editable = false;
                    ToolTip = 'Specifies the target record identity selected for this correction line. Use assist edit or Select Record to choose it.';

                    trigger OnAssistEdit()
                    begin
                        SelectTargetRecord();
                    end;
                }
                field("Field ID"; Rec."Field ID")
                {
                    ToolTip = 'Specifies the target field ID.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }
                field("Field Name"; Rec."Field Name")
                {
                    ToolTip = 'Specifies the target field name.';
                }
                field("Proposed New Value"; Rec."Proposed New Value")
                {
                    ToolTip = 'Specifies the proposed new value text.';
                }
                field("Current Value Preview"; Rec."Current Value Preview")
                {
                    ToolTip = 'Specifies the current value for the selected record and field.';
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
                Caption = 'Select Record';
                Image = View;
                ToolTip = 'Opens target record lookup and fills Record ID for the selected correction line.';

                trigger OnAction()
                begin
                    SelectTargetRecord();
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

    local procedure SelectTargetRecord()
    var
        TargetRecordLookup: Page "BCDA Target Record Lookup";
    begin
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

    var
        TableRequiredBeforeRecordErr: Label 'Select a table before selecting a record.';
}
