namespace AKSA.BCDataAgent;

page 88112 "BCDA Data Policy Card"
{
    ApplicationArea = All;
    Caption = 'BCDA Data Policy';
    PageType = Card;
    SourceTable = "BCDA Data Policy";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Policy ID"; Rec."Policy ID")
                {
                    ToolTip = 'Specifies the policy identifier.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a short policy description.';
                }
                field(Enabled; Rec.Enabled)
                {
                    ToolTip = 'Specifies whether this policy participates in policy evaluation.';
                }
            }
            group(Target)
            {
                Caption = 'Target';

                field("Table ID"; Rec."Table ID")
                {
                    ToolTip = 'Specifies the target table ID.';
                }
                field("Table Name"; Rec."Table Name")
                {
                    ToolTip = 'Specifies the target table name.';
                }
                field("Field ID"; Rec."Field ID")
                {
                    ToolTip = 'Specifies the target field ID. Use 0 for a table-level policy.';
                }
                field("Field Name"; Rec."Field Name")
                {
                    ToolTip = 'Specifies the target field name.';
                }
                field(Operation; Rec.Operation)
                {
                    ToolTip = 'Specifies the governed operation. Foundation code supports the MODIFY operation policy shape only.';
                }
            }
            group(Policy)
            {
                Caption = 'Policy';

                field("Risk Level"; Rec."Risk Level")
                {
                    ToolTip = 'Specifies the risk level for this target.';
                }
                field(Decision; Rec.Decision)
                {
                    ToolTip = 'Specifies whether the policy blocks, allows, or requires approval.';
                }
                field("Requires Approval"; Rec."Requires Approval")
                {
                    ToolTip = 'Specifies whether the policy requires approval.';
                }
                field("Validation Mode"; Rec."Validation Mode")
                {
                    ToolTip = 'Specifies the validation mode to use when execution is later enabled.';
                }
                field("Rollback Snapshot Mode"; Rec."Rollback Snapshot Mode")
                {
                    ToolTip = 'Specifies how rollback snapshots are handled for this target.';
                }
                field("Retention Override Days"; Rec."Retention Override Days")
                {
                    ToolTip = 'Specifies an optional retention override in days.';
                }
                field("Blocked Reason"; Rec."Blocked Reason")
                {
                    ToolTip = 'Specifies the reason shown when this policy blocks a request.';
                }
            }
            group(Review)
            {
                Caption = 'Review';

                field("Last Reviewed At"; Rec."Last Reviewed At")
                {
                    ToolTip = 'Specifies when this policy was last reviewed.';
                }
                field("Last Reviewed By"; Rec."Last Reviewed By")
                {
                    ToolTip = 'Specifies who last reviewed this policy.';
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
