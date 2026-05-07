namespace AKSA.BCDataAgent;

enum 88142 "BCDA Risk Level"
{
    Extensible = false;
    Caption = 'BCDA Risk Level';

    value(0; Low)
    {
        Caption = 'Low';
    }
    value(10; Normal)
    {
        Caption = 'Normal';
    }
    value(20; High)
    {
        Caption = 'High';
    }
    value(30; Posted)
    {
        Caption = 'Posted';
    }
}
