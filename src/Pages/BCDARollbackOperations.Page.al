namespace AKSA.BCDataAgent;

page 88120 "BCDA Rollback Operations"
{
    ApplicationArea = All;
    Caption = 'BCDA Rollback Operations';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "BCDA Rollback Operation";
    SourceTableView = sorting("Rollback ID") order(descending);
    UsageCategory = History;

    layout
    {
        area(Content)
        {
            repeater(Operations)
            {
                field("Rollback ID"; Rec."Rollback ID")
                {
                    ToolTip = 'Specifies the rollback operation identifier.';
                }
                field("Source Request ID"; Rec."Source Request ID")
                {
                    ToolTip = 'Specifies the completed correction request used as the rollback source.';
                }
                field("Source Audit Entry No."; Rec."Source Audit Entry No.")
                {
                    ToolTip = 'Specifies the execution audit entry used by legacy rollback records. Request-level rollback staging leaves this blank.';
                }
                field("Generated Request ID"; Rec."Generated Request ID")
                {
                    ToolTip = 'Specifies the rollback correction request created from the completed source request.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the rollback operation status.';
                }
                field("Conflict Policy"; Rec."Conflict Policy")
                {
                    ToolTip = 'Specifies the conflict policy used by the rollback operation.';
                }
                field(Result; Rec.Result)
                {
                    ToolTip = 'Specifies the rollback result.';
                }
                field("Requested By"; Rec."Requested By")
                {
                    ToolTip = 'Specifies the user who requested rollback.';
                }
                field("Requested At"; Rec."Requested At")
                {
                    ToolTip = 'Specifies when rollback was requested.';
                }
                field("Completed By"; Rec."Completed By")
                {
                    ToolTip = 'Specifies the user who completed rollback request creation or legacy rollback processing.';
                }
                field("Completed At"; Rec."Completed At")
                {
                    ToolTip = 'Specifies when rollback request creation or legacy rollback processing completed.';
                }
                field("Sanitized Error"; Rec."Sanitized Error")
                {
                    ToolTip = 'Specifies sanitized rollback request creation or legacy rollback error details.';
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
