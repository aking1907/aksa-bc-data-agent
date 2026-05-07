namespace AKSA.BCDataAgent;

enum 88143 "BCDA Validation Mode"
{
    Extensible = false;
    Caption = 'BCDA Validation Mode';

    value(0; "Policy Controlled")
    {
        Caption = 'Policy Controlled';
    }
    value(10; "Validate Trigger")
    {
        Caption = 'Validate Trigger';
    }
    value(20; "Raw Assign Blocked")
    {
        Caption = 'Raw Assign Blocked';
    }
}
