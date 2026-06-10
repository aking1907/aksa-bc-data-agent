namespace AKSA.BCDataAgent;

page 88113 "BCDA Correction Requests"
{
    ApplicationArea = All;
    Caption = 'BCDA Correction Requests';
    CardPageId = "BCDA Correction Request Card";
    PageType = List;
    SourceTable = "BCDA Correction Request";
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            repeater(Requests)
            {
                field("Request ID"; Rec."Request ID")
                {
                    ToolTip = 'Specifies the correction request identifier.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the request status.';
                }
                field("Ticket Reference"; Rec."Ticket Reference")
                {
                    ToolTip = 'Specifies the external ticket or reference when one exists or is required.';
                }
                field("Ticket Reference Required"; Rec."Ticket Reference Required")
                {
                    ToolTip = 'Specifies whether this request requires a ticket/reference before preview, approval, or execution.';
                }
                field(Reason; Rec.Reason)
                {
                    ToolTip = 'Specifies the business reason for the request.';
                }
                field("Risk Level"; Rec."Risk Level")
                {
                    ToolTip = 'Specifies the risk level.';
                }
                field("Requested By"; Rec."Requested By")
                {
                    ToolTip = 'Specifies the user who created the request.';
                }
                field("Requested At"; Rec."Requested At")
                {
                    ToolTip = 'Specifies when the request was created.';
                }
                field("Approval Required"; Rec."Approval Required")
                {
                    ToolTip = 'Specifies whether this request requires approval.';
                }
                field("Require Separate Approver"; Rec."Require Separate Approver")
                {
                    ToolTip = 'Specifies whether approval must be performed by a different SUPER user.';
                }
                field("Approved By"; Rec."Approved By")
                {
                    ToolTip = 'Specifies the approving SUPER user.';
                }
                field("Rollback Availability"; Rec."Rollback Availability")
                {
                    ToolTip = 'Specifies the current rollback availability message.';
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
