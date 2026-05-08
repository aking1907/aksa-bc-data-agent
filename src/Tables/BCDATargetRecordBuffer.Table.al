namespace AKSA.BCDataAgent;

table 88109 "BCDA Target Record Buffer"
{
    Caption = 'BCDA Target Record Buffer';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(2; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            Editable = false;
        }
        field(3; "Record ID"; RecordId)
        {
            Caption = 'Record ID';
            Editable = false;
        }
        field(4; "Display Key"; Text[2048])
        {
            Caption = 'Display Key';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
