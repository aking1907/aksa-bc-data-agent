namespace AKSA.BCDataAgent;

enum 88146 "BCDA Audit Operation"
{
    Extensible = false;
    Caption = 'BCDA Audit Operation';

    value(0; "Request Created")
    {
        Caption = 'Request Created';
    }
    value(10; Preview)
    {
        Caption = 'Preview';
    }
    value(20; Approval)
    {
        Caption = 'Approval';
    }
    value(30; Execution)
    {
        Caption = 'Execution';
    }
    value(40; Rollback)
    {
        Caption = 'Rollback';
    }
    value(50; "Retention Cleanup")
    {
        Caption = 'Retention Cleanup';
    }
    value(60; "Policy Change")
    {
        Caption = 'Policy Change';
    }
    value(70; "Setup Change")
    {
        Caption = 'Setup Change';
    }
    value(80; "Audit Export")
    {
        Caption = 'Audit Export';
    }
    value(90; "Request Export")
    {
        Caption = 'Request Export';
    }
    value(100; "Request Import")
    {
        Caption = 'Request Import';
    }
}
