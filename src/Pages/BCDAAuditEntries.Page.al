namespace AKSA.BCDataAgent;

page 88116 "BCDA Audit Entries"
{
    ApplicationArea = All;
    Caption = 'BCDA Audit Entries';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "BCDA Audit Entry";
    SourceTableView = sorting("Entry No.") order(descending);
    UsageCategory = History;

    layout
    {
        area(Content)
        {
            repeater(Entries)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the audit entry number.';
                }
                field(Operation; Rec.Operation)
                {
                    ToolTip = 'Specifies the audited operation.';
                }
                field(Result; Rec.Result)
                {
                    ToolTip = 'Specifies the operation result.';
                }
                field("Request ID"; Rec."Request ID")
                {
                    ToolTip = 'Specifies the related request ID.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the related line number.';
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the user who caused the audit entry.';
                }
                field("Occurred At"; Rec."Occurred At")
                {
                    ToolTip = 'Specifies when the audited event occurred.';
                }
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'Specifies the company context.';
                }
                field("Target Table ID"; Rec."Target Table ID")
                {
                    ToolTip = 'Specifies the target table ID.';
                }
                field("Target Record ID"; Rec."Target Record ID")
                {
                    ToolTip = 'Specifies the target record identity.';
                }
                field("Target Field ID"; Rec."Target Field ID")
                {
                    ToolTip = 'Specifies the target field ID.';
                }
                field("Rollback Available"; Rec."Rollback Available")
                {
                    ToolTip = 'Specifies whether rollback material is linked.';
                }
                field("Sanitized Error"; Rec."Sanitized Error")
                {
                    ToolTip = 'Specifies sanitized error details.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        AccessMgt: Codeunit "BCDA Access Mgt.";
    begin
        AccessMgt.EnsureSuperUser();
    end;
}
