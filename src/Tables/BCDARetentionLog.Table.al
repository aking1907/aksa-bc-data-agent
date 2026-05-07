namespace AKSA.BCDataAgent;

table 88107 "BCDA Retention Log"
{
    Caption = 'BCDA Retention Log';
    DataClassification = CustomerContent;
    LookupPageId = "BCDA Retention Logs";
    DrillDownPageId = "BCDA Retention Logs";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Retention Category"; Enum "BCDA Retention Category")
        {
            Caption = 'Retention Category';
        }
        field(3; "Table ID"; Integer)
        {
            Caption = 'Table ID';
        }
        field(4; "Cutoff Date"; Date)
        {
            Caption = 'Cutoff Date';
        }
        field(5; "Expired Count"; Integer)
        {
            Caption = 'Expired Count';
            MinValue = 0;
        }
        field(6; "Deleted Count"; Integer)
        {
            Caption = 'Deleted Count';
            MinValue = 0;
        }
        field(7; Result; Enum "BCDA Audit Result")
        {
            Caption = 'Result';
        }
        field(8; "Sanitized Error"; Text[2048])
        {
            Caption = 'Sanitized Error';
        }
        field(9; "Created By"; Code[50])
        {
            Caption = 'Created By';
            Editable = false;
        }
        field(10; "Created At"; DateTime)
        {
            Caption = 'Created At';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Category; "Retention Category", "Created At")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Created By" = '' then
            "Created By" := CopyStr(UserId(), 1, MaxStrLen("Created By"));

        if "Created At" = 0DT then
            "Created At" := CurrentDateTime();
    end;
}
