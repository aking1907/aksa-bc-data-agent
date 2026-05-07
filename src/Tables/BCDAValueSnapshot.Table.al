namespace AKSA.BCDataAgent;

table 88105 "BCDA Value Snapshot"
{
    Caption = 'BCDA Value Snapshot';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Snapshot ID"; Guid)
        {
            Caption = 'Snapshot ID';
        }
        field(2; "Request ID"; Code[20])
        {
            Caption = 'Request ID';
            TableRelation = "BCDA Correction Request";
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Retention Category"; Enum "BCDA Retention Category")
        {
            Caption = 'Retention Category';
            InitValue = "Rollback Snapshot";
        }
        field(5; "Value Type"; Text[50])
        {
            Caption = 'Value Type';
        }
        field(6; "Serialized Value"; Text[2048])
        {
            Caption = 'Serialized Value';
        }
        field(7; "Display Value"; Text[2048])
        {
            Caption = 'Display Value';
        }
        field(8; "Value Hash"; Text[100])
        {
            Caption = 'Value Hash';
        }
        field(9; "Redaction Level"; Text[30])
        {
            Caption = 'Redaction Level';
        }
        field(10; "Expires At"; DateTime)
        {
            Caption = 'Expires At';
        }
        field(11; Purged; Boolean)
        {
            Caption = 'Purged';
            Editable = false;
        }
        field(12; "Serialization Version"; Integer)
        {
            Caption = 'Serialization Version';
            InitValue = 1;
        }
        field(13; "Created By"; Code[50])
        {
            Caption = 'Created By';
            Editable = false;
        }
        field(14; "Created At"; DateTime)
        {
            Caption = 'Created At';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Snapshot ID")
        {
            Clustered = true;
        }
        key(Request; "Request ID", "Line No.")
        {
        }
        key(Expiration; "Retention Category", "Expires At", Purged)
        {
        }
    }

    trigger OnInsert()
    begin
        if IsNullGuid("Snapshot ID") then
            "Snapshot ID" := CreateGuid();

        if "Created By" = '' then
            "Created By" := CopyStr(UserId(), 1, MaxStrLen("Created By"));

        if "Created At" = 0DT then
            "Created At" := CurrentDateTime();
    end;
}
