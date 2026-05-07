namespace AKSA.BCDataAgent;

enum 88141 "BCDA Line Status"
{
    Extensible = false;
    Caption = 'BCDA Line Status';

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(10; Previewed)
    {
        Caption = 'Previewed';
    }
    value(20; Approved)
    {
        Caption = 'Approved';
    }
    value(30; Executed)
    {
        Caption = 'Executed';
    }
    value(40; Failed)
    {
        Caption = 'Failed';
    }
    value(50; "Rollback Pending")
    {
        Caption = 'Rollback Pending';
    }
    value(60; "Rolled Back")
    {
        Caption = 'Rolled Back';
    }
}
