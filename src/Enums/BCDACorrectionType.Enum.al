namespace AKSA.BCDataAgent;

enum 88131 "BCDA Correction Type"
{
    Extensible = false;
    Caption = 'BCDA Correction Type';

    value(0; Update)
    {
        Caption = 'Update';
    }
    value(10; Rename)
    {
        Caption = 'Rename';
    }
    value(20; Delete)
    {
        Caption = 'Delete';
    }
    value(30; Insert)
    {
        Caption = 'Insert';
    }
}
