namespace AKSA.BCDataAgent;

page 88114 "BCDA Correction Request Card"
{
    ApplicationArea = All;
    Caption = 'BCDA Correction Request';
    PageType = Card;
    SourceTable = "BCDA Correction Request";
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Request ID"; Rec."Request ID")
                {
                    ToolTip = 'Specifies the correction request identifier.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the request status.';
                }
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'Specifies the company for the request.';
                }
                field(Reason; Rec.Reason)
                {
                    ToolTip = 'Specifies the business reason for the request.';
                }
                field("Ticket Reference"; Rec."Ticket Reference")
                {
                    ToolTip = 'Specifies the external ticket or reference.';
                }
                field("Risk Level"; Rec."Risk Level")
                {
                    ToolTip = 'Specifies the risk level.';
                }
            }
            group(Approval)
            {
                Caption = 'Approval';

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
                    ToolTip = 'Specifies whether approval is required for this request. If this is off, approval actions are not needed.';

                    trigger OnValidate()
                    begin
                        UpdateApprovalActions();
                        CurrPage.Update(false);
                    end;
                }
                field("Require Separate Approver"; Rec."Require Separate Approver")
                {
                    Enabled = ApprovalActionsEnabled;
                    ToolTip = 'Specifies whether approval must be performed by a different SUPER user. When this is off, the requester can self-approve if approval is required.';
                }
                field("Approved By"; Rec."Approved By")
                {
                    ToolTip = 'Specifies the approving SUPER user.';
                }
                field("Approved At"; Rec."Approved At")
                {
                    ToolTip = 'Specifies when the request was approved.';
                }
            }
            part(Lines; "BCDA Correction Lines")
            {
                SubPageLink = "Request ID" = field("Request ID");
            }
            group(RollbackAndRetention)
            {
                Caption = 'Rollback And Retention';

                field("Preview Required"; Rec."Preview Required")
                {
                    ToolTip = 'Specifies whether preview is required.';
                }
                field("Last Preview At"; Rec."Last Preview At")
                {
                    ToolTip = 'Specifies when the foundation preview marker was last recorded.';
                }
                field("Rollback Availability"; Rec."Rollback Availability")
                {
                    ToolTip = 'Specifies rollback availability.';
                }
                field("Retention Impact"; Rec."Retention Impact")
                {
                    ToolTip = 'Specifies the retention impact summary.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Initialize)
            {
                Caption = 'Initialize';
                Image = Setup;
                ToolTip = 'Applies setup defaults and writes request-created audit evidence.';

                trigger OnAction()
                var
                    Orchestrator: Codeunit "BCDA Correction Orchestrator";
                begin
                    Orchestrator.InitializeRequest(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(MarkPreviewed)
            {
                Caption = 'Mark Previewed';
                Image = View;
                ToolTip = 'Records a foundation preview marker. Target value preview is blocked until the next readiness gate.';

                trigger OnAction()
                var
                    Orchestrator: Codeunit "BCDA Correction Orchestrator";
                begin
                    Orchestrator.MarkPreviewed(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(SubmitForApproval)
            {
                Caption = 'Submit For Approval';
                Enabled = ApprovalActionsEnabled;
                Image = SendApprovalRequest;
                ToolTip = 'Submits the request for approval when approval is required.';

                trigger OnAction()
                var
                    Orchestrator: Codeunit "BCDA Correction Orchestrator";
                begin
                    Orchestrator.SubmitForApproval(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(Approve)
            {
                Caption = 'Approve';
                Enabled = ApprovalActionsEnabled;
                Image = Approve;
                ToolTip = 'Approves the request. A different SUPER user is required only when the request requires separate approval.';

                trigger OnAction()
                var
                    Orchestrator: Codeunit "BCDA Correction Orchestrator";
                begin
                    Orchestrator.Approve(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(Execute)
            {
                Caption = 'Execute';
                Image = ExecuteBatch;
                ToolTip = 'Attempts execution. Foundation code blocks target data execution until mutation readiness is approved.';

                trigger OnAction()
                var
                    Orchestrator: Codeunit "BCDA Correction Orchestrator";
                begin
                    Orchestrator.ExecuteRequest(Rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        AccessMgt: Codeunit "BCDA Access Mgt.";
    begin
        AccessMgt.EnsureSuperUser();
        UpdateApprovalActions();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        SetupMgt: Codeunit "BCDA Setup Mgt.";
    begin
        SetupMgt.ApplyDefaultsToRequest(Rec);
        UpdateApprovalActions();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateApprovalActions();
    end;

    local procedure UpdateApprovalActions()
    begin
        ApprovalActionsEnabled := Rec."Approval Required";
    end;

    var
        ApprovalActionsEnabled: Boolean;
}
