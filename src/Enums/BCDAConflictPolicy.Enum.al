namespace AKSA.BCDataAgent;

enum 88148 "BCDA Conflict Policy"
{
    Extensible = false;
    Caption = 'BCDA Conflict Policy';

    value(0; "Stop On Conflict")
    {
        Caption = 'Stop On Conflict';
    }
    value(10; "Allow Override")
    {
        Caption = 'Allow Override';
    }
}
