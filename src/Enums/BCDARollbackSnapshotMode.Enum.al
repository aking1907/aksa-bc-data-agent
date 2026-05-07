namespace AKSA.BCDataAgent;

enum 88144 "BCDA Rollback Snapshot Mode"
{
    Extensible = false;
    Caption = 'BCDA Rollback Snapshot Mode';

    value(0; "Policy Controlled")
    {
        Caption = 'Policy Controlled';
    }
    value(10; Enabled)
    {
        Caption = 'Enabled';
    }
    value(20; Disabled)
    {
        Caption = 'Disabled';
    }
    value(30; Required)
    {
        Caption = 'Required';
    }
}
