namespace AKSA.BCDataAgent;

enum 88145 "BCDA Retention Category"
{
    Extensible = false;
    Caption = 'BCDA Retention Category';

    value(0; "Audit Metadata")
    {
        Caption = 'Audit Metadata';
    }
    value(10; "Rollback Snapshot")
    {
        Caption = 'Rollback Snapshot';
    }
    value(20; "Technical Log")
    {
        Caption = 'Technical Log';
    }
}
