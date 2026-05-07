namespace AKSA.BCDataAgent;

enum 88149 "BCDA Policy Decision"
{
    Extensible = false;
    Caption = 'BCDA Policy Decision';

    value(0; Block)
    {
        Caption = 'Block';
    }
    value(10; Allow)
    {
        Caption = 'Allow';
    }
    value(20; "Approval Required")
    {
        Caption = 'Approval Required';
    }
}
