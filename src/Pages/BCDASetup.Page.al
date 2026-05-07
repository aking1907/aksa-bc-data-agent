namespace AKSA.BCDataAgent;

page 88110 "BCDA Setup"
{
    ApplicationArea = All;
    Caption = 'BCDA Setup';
    PageType = Card;
    SourceTable = "BCDA Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Environment Label"; Rec."Environment Label")
                {
                    ToolTip = 'Specifies the environment label shown to SUPER users when they review correction impact.';
                }
                field("Default Policy Decision"; Rec."Default Policy Decision")
                {
                    ToolTip = 'Specifies the default decision when no table or field policy exists.';
                }
                field("Approval Required Default"; Rec."Approval Required Default")
                {
                    ToolTip = 'Specifies whether requests require approval by default. Turn this off only when the company accepts no separate approval step for standard requests.';

                    trigger OnValidate()
                    begin
                        UpdateApprovalSettings();
                        CurrPage.Update(false);
                    end;
                }
                field("Require Separate Approver"; Rec."Require Separate Approver")
                {
                    Enabled = SeparateApproverEnabled;
                    ToolTip = 'Specifies whether approval must be performed by a different SUPER user. Turn this off for one-person companies that accept self-approval.';
                }
                field("Require Preview"; Rec."Require Preview")
                {
                    ToolTip = 'Specifies whether requests require a preview step before execution.';
                }
            }
            group(Rollback)
            {
                Caption = 'Rollback';

                field("Rollback Snapshot Default"; Rec."Rollback Snapshot Default")
                {
                    ToolTip = 'Specifies the default rollback snapshot logging mode.';
                }
            }
            group(Retention)
            {
                Caption = 'Retention';

                field("Audit Retention Days"; Rec."Audit Retention Days")
                {
                    ToolTip = 'Specifies how many days audit metadata is retained by default.';
                }
                field("Snapshot Retention Days"; Rec."Snapshot Retention Days")
                {
                    ToolTip = 'Specifies how many days rollback snapshots are retained by default.';
                }
                field("Technical Log Retention Days"; Rec."Technical Log Retention Days")
                {
                    ToolTip = 'Specifies how many days technical logs are retained by default.';
                }
                field("Export Enabled"; Rec."Export Enabled")
                {
                    ToolTip = 'Specifies whether audit export is enabled. Export generation is not part of the foundation slice.';
                }
            }
            group(System)
            {
                Caption = 'System';

                field("Foundation Version"; Rec."Foundation Version")
                {
                    ToolTip = 'Specifies the foundation schema version.';
                }
                field("Last Initialized At"; Rec."Last Initialized At")
                {
                    ToolTip = 'Specifies when setup defaults were initialized.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RegisterRetentionTables)
            {
                Caption = 'Register Retention Tables';
                Image = Setup;
                ToolTip = 'Registers BC Data Agent operation tables with Business Central retention policy allowed-table support.';

                trigger OnAction()
                var
                    RetentionManager: Codeunit "BCDA Retention Manager";
                begin
                    RetentionManager.RegisterRetentionTables();
                    Message(RetentionTablesRegisteredMsg);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        AccessMgt: Codeunit "BCDA Access Mgt.";
        SetupMgt: Codeunit "BCDA Setup Mgt.";
    begin
        AccessMgt.EnsureSuperUser();
        SetupMgt.EnsureSetup();
        if not Rec.Get(Rec.GetPrimaryKey()) then
            exit;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateApprovalSettings();
    end;

    local procedure UpdateApprovalSettings()
    begin
        SeparateApproverEnabled := Rec."Approval Required Default";
    end;

    var
        SeparateApproverEnabled: Boolean;
        RetentionTablesRegisteredMsg: Label 'BC Data Agent retention tables were registered.';
}
