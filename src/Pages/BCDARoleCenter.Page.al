namespace AKSA.BCDataAgent;

page 88118 "BCDA Role Center"
{
    ApplicationArea = All;
    Caption = 'BC Data Agent';
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
        }
    }

    actions
    {
        area(Embedding)
        {
            action(BCDARequests)
            {
                ApplicationArea = All;
                Caption = 'Correction Requests';
                RunObject = page "BCDA Correction Requests";
                ToolTip = 'Opens the BC Data Agent correction request work queue.';
            }
            action(BCDAPolicies)
            {
                ApplicationArea = All;
                Caption = 'Data Policies';
                RunObject = page "BCDA Data Policies";
                ToolTip = 'Opens the BC Data Agent data policy list.';
            }
            action(BCDAAudit)
            {
                ApplicationArea = All;
                Caption = 'Audit Entries';
                RunObject = page "BCDA Audit Entries";
                ToolTip = 'Opens BC Data Agent audit evidence.';
            }
            action(BCDARetentionLogs)
            {
                ApplicationArea = All;
                Caption = 'Retention Logs';
                RunObject = page "BCDA Retention Logs";
                ToolTip = 'Opens BC Data Agent retention and cleanup evidence.';
            }
        }
        area(Sections)
        {
            group(BCDataAgent)
            {
                Caption = 'BC Data Agent';

                action(BCDASetupSection)
                {
                    ApplicationArea = All;
                    Caption = 'Setup';
                    RunObject = page "BCDA Setup";
                    ToolTip = 'Opens global BC Data Agent setup, rollback, approval, and retention defaults.';
                }
                action(BCDAPoliciesSection)
                {
                    ApplicationArea = All;
                    Caption = 'Data Policies';
                    RunObject = page "BCDA Data Policies";
                    ToolTip = 'Opens table and field policies for governed correction work.';
                }
                action(BCDARequestsSection)
                {
                    ApplicationArea = All;
                    Caption = 'Correction Requests';
                    RunObject = page "BCDA Correction Requests";
                    ToolTip = 'Opens correction requests for foundation workflow validation.';
                }
                action(BCDAAuditSection)
                {
                    ApplicationArea = All;
                    Caption = 'Audit Entries';
                    RunObject = page "BCDA Audit Entries";
                    ToolTip = 'Opens append-only audit evidence for BC Data Agent activity.';
                }
                action(BCDARetentionSection)
                {
                    ApplicationArea = All;
                    Caption = 'Retention Logs';
                    RunObject = page "BCDA Retention Logs";
                    ToolTip = 'Opens retention registration and cleanup evidence.';
                }
            }
        }
        area(Creation)
        {
            action(BCDANewRequest)
            {
                ApplicationArea = All;
                Caption = 'New Correction Request';
                RunObject = page "BCDA Correction Request Card";
                RunPageMode = Create;
                ToolTip = 'Creates a new BC Data Agent correction request. Target execution remains blocked in the foundation build.';
            }
        }
        area(Processing)
        {
            action(BCDASetup)
            {
                ApplicationArea = All;
                Caption = 'Setup';
                RunObject = page "BCDA Setup";
                ToolTip = 'Opens BC Data Agent setup and retention registration actions.';
            }
        }
    }
}
