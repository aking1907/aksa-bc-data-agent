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
                    ToolTip = 'Specifies the external ticket or reference when one exists or is required.';
                }
                field("Ticket Reference Required"; Rec."Ticket Reference Required")
                {
                    ToolTip = 'Specifies whether this request requires a ticket/reference before preview, approval, or execution.';
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
                    Enabled = SeparateApproverEnabled;
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
                    ToolTip = 'Specifies when non-mutating request preview was last completed.';
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
                Caption = 'Preview Request';
                Enabled = PreviewEnabled;
                Image = View;
                ToolTip = 'Runs non-mutating request preview, refreshes line preview status, and records preview audit evidence. Target mutation remains blocked.';

                trigger OnAction()
                var
                    Orchestrator: Codeunit "BCDA Correction Orchestrator";
                begin
                    Orchestrator.MarkPreviewed(Rec);
                    Message(PreviewCompletedMsg);
                    CurrPage.Update(false);
                end;
            }
            action(BatchAddLines)
            {
                Caption = 'Batch Add Lines';
                Enabled = BatchAddLinesEnabled;
                Image = CreateLinesFromJob;
                ToolTip = 'Opens same-table batch entry for creating correction lines from selected target records and fields.';

                trigger OnAction()
                var
                    BatchLineBuilder: Page "BCDA Batch Line Builder";
                begin
                    CurrPage.SaveRecord();
                    BatchLineBuilder.SetRequest(Rec);
                    BatchLineBuilder.RunModal();
                    CurrPage.Update(false);
                end;
            }
            action(SubmitForApproval)
            {
                Caption = 'Submit For Approval';
                Enabled = SubmitApprovalEnabled;
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
                Enabled = ApproveEnabled;
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
                Enabled = ExecuteEnabled;
                Image = ExecuteBatch;
                ToolTip = 'Executes supported update correction groups after metadata, preview, approval, policy, audit, and rollback snapshot checks pass.';

                trigger OnAction()
                var
                    Orchestrator: Codeunit "BCDA Correction Orchestrator";
                begin
                    Orchestrator.ExecuteRequest(Rec);
                    Message(ExecutionCompletedMsg);
                    CurrPage.Update(false);
                end;
            }
            action(Rollback)
            {
                Caption = 'Rollback';
                Enabled = RollbackEnabled;
                Image = Undo;
                ToolTip = 'Creates a new correction request with suggested update lines that revert this completed request. No target data is changed until the new request is previewed, approved if required, and executed.';

                trigger OnAction()
                var
                    RollbackRequest: Record "BCDA Correction Request";
                    RollbackService: Codeunit "BCDA Rollback Service";
                    RollbackRequestId: Code[20];
                begin
                    if not Confirm(RollbackConfirmQst, false, Rec."Request ID") then
                        exit;

                    RollbackService.CreateRollbackRequest(Rec, RollbackRequestId);
                    CurrPage.Update(false);

                    if RollbackRequest.Get(RollbackRequestId) then
                        Page.Run(Page::"BCDA Correction Request Card", RollbackRequest);
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
        SeparateApproverEnabled := Rec."Approval Required";
        PreviewEnabled := (Rec.Status = Rec.Status::Open) or (Rec.Status = Rec.Status::Previewed);
        BatchAddLinesEnabled := PreviewEnabled;
        SubmitApprovalEnabled := Rec."Approval Required" and
            ((Rec.Status = Rec.Status::Open) or (Rec.Status = Rec.Status::Previewed));
        ApproveEnabled := Rec."Approval Required" and (Rec.Status = Rec.Status::"Pending Approval");
        ExecuteEnabled := (Rec.Status = Rec.Status::Approved) or
            ((not Rec."Approval Required") and
             ((Rec.Status = Rec.Status::Previewed) or ((not Rec."Preview Required") and (Rec.Status = Rec.Status::Open))));
        RollbackEnabled := Rec.Status = Rec.Status::Completed;
    end;

    var
        ApproveEnabled: Boolean;
        BatchAddLinesEnabled: Boolean;
        ExecuteEnabled: Boolean;
        ExecutionCompletedMsg: Label 'Execution finished. Review correction line statuses and audit entries for the final result.';
        PreviewEnabled: Boolean;
        PreviewCompletedMsg: Label 'Preview completed. Review correction line statuses and sanitized messages before approval.';
        RollbackConfirmQst: Label 'Create a new rollback correction request for completed request %1? No target data will be changed until the new request is previewed, approved if required, and executed.', Comment = '%1 = source request ID';
        RollbackEnabled: Boolean;
        SeparateApproverEnabled: Boolean;
        SubmitApprovalEnabled: Boolean;
}
