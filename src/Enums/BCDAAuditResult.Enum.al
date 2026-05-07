namespace AKSA.BCDataAgent;

enum 88147 "BCDA Audit Result"
{
    Extensible = false;
    Caption = 'BCDA Audit Result';

    value(0; Success)
    {
        Caption = 'Success';
    }
    value(10; Failed)
    {
        Caption = 'Failed';
    }
    value(20; Blocked)
    {
        Caption = 'Blocked';
    }
    value(30; Warning)
    {
        Caption = 'Warning';
    }
}
