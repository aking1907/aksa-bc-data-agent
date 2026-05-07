namespace AKSA.BCDataAgent;

page 88111 "BCDA Data Policies"
{
    ApplicationArea = All;
    Caption = 'BCDA Data Policies';
    CardPageId = "BCDA Data Policy Card";
    PageType = List;
    SourceTable = "BCDA Data Policy";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Policies)
            {
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
                field("Risk Level"; Rec."Risk Level")
                {
                    ToolTip = 'Specifies the risk level for this target.';
                }
                field(Decision; Rec.Decision)
                {
                    ToolTip = 'Specifies whether the policy blocks, allows, or requires approval.';
                }
                field("Rollback Snapshot Mode"; Rec."Rollback Snapshot Mode")
                {
                    ToolTip = 'Specifies how rollback snapshots are handled for this target.';
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
