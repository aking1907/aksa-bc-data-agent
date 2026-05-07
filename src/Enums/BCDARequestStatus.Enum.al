namespace AKSA.BCDataAgent;

enum 88140 "BCDA Request Status"
{
    Extensible = false;
    Caption = 'BCDA Request Status';

    value(0; Open)
    {
        Caption = 'Open';
    }
    value(10; "Pending Approval")
    {
        Caption = 'Pending Approval';
    }
    value(20; Approved)
    {
        Caption = 'Approved';
    }
    value(30; Rejected)
    {
        Caption = 'Rejected';
    }
    value(40; Previewed)
    {
        Caption = 'Previewed';
    }
    value(50; Executing)
    {
        Caption = 'Executing';
    }
    value(60; Completed)
    {
        Caption = 'Completed';
    }
    value(70; Failed)
    {
        Caption = 'Failed';
    }
    value(80; Cancelled)
    {
        Caption = 'Cancelled';
    }
}
