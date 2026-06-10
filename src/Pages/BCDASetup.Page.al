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
                field("Allow Data Policies"; Rec."Allow Data Policies")
                {
                    ToolTip = 'Specifies whether BCDA data policy records are enforced. When this is off, policies are bypassed, but BCDA app-owned tables, unsupported fields, SUPER access, request metadata, and audit controls still apply.';
                }
                field("Require Ticket Reference"; Rec."Require Ticket Reference")
                {
                    ToolTip = 'Specifies whether new requests require a ticket/reference before preview, approval, or execution.';
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
                    ToolTip = 'Specifies whether filtered audit metadata export is enabled.';
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
            action(RunRetentionCleanup)
            {
                Caption = 'Run Retention Cleanup';
                Image = Delete;
                ToolTip = 'Purges expired rollback snapshot payloads and deletes expired eligible BC Data Agent operation records while protecting active requests and retained rollback dependencies.';

                trigger OnAction()
                var
                    RetentionManager: Codeunit "BCDA Retention Manager";
                begin
                    if not Confirm(RetentionCleanupConfirmQst, false) then
                        exit;

                    RetentionManager.RunRetentionCleanup();
                    Message(RetentionCleanupFinishedMsg);
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
        RetentionCleanupConfirmQst: Label 'Run BC Data Agent retention cleanup now? Expired rollback snapshot payloads can be purged and expired eligible operation records can be deleted.';
        RetentionCleanupFinishedMsg: Label 'Retention cleanup finished. Review BCDA Retention Logs for results.';
}
