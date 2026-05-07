namespace AKSA.BCDataAgent;

page 88117 "BCDA Retention Logs"
{
    ApplicationArea = All;
    Caption = 'BCDA Retention Logs';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "BCDA Retention Log";
    SourceTableView = sorting("Entry No.") order(descending);
    UsageCategory = History;

    layout
    {
        area(Content)
        {
            repeater(Logs)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the retention log entry number.';
                }
                field("Retention Category"; Rec."Retention Category")
                {
                    ToolTip = 'Specifies the retention category.';
                }
                field("Table ID"; Rec."Table ID")
                {
                    ToolTip = 'Specifies the table ID.';
                }
                field("Cutoff Date"; Rec."Cutoff Date")
                {
                    ToolTip = 'Specifies the cutoff date.';
                }
                field("Expired Count"; Rec."Expired Count")
                {
                    ToolTip = 'Specifies the number of expired records.';
                }
                field("Deleted Count"; Rec."Deleted Count")
                {
                    ToolTip = 'Specifies the number of deleted records.';
                }
                field(Result; Rec.Result)
                {
                    ToolTip = 'Specifies the retention result.';
                }
                field("Sanitized Error"; Rec."Sanitized Error")
                {
                    ToolTip = 'Specifies sanitized error details.';
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the user who created the retention log entry.';
                }
                field("Created At"; Rec."Created At")
                {
                    ToolTip = 'Specifies when the retention log entry was created.';
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
