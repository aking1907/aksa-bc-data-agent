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
                field("Record Key"; Rec."Record Key")
                {
                    ToolTip = 'Specifies the target record key text.';
                }
                field("Field ID"; Rec."Field ID")
                {
                    ToolTip = 'Specifies the target field ID.';
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
                    ToolTip = 'Specifies the current value preview when preview is implemented.';
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
}
