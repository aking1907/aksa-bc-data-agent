namespace AKSA.BCDataAgent;

table 88103 "BCDA Correction Line"
{
    Caption = 'BCDA Correction Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Request ID"; Code[20])
        {
            Caption = 'Request ID';
            TableRelation = "BCDA Correction Request";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Table ID"; Integer)
        {
            Caption = 'Table ID';
        }
        field(4; "Table Name"; Text[250])
        {
            Caption = 'Table Name';
        }
        field(5; "Record Key"; Text[2048])
        {
            Caption = 'Record Key';
        }
        field(6; "Field ID"; Integer)
        {
            Caption = 'Field ID';
        }
        field(7; "Field Name"; Text[250])
        {
            Caption = 'Field Name';
        }
        field(8; "Proposed New Value"; Text[2048])
        {
            Caption = 'Proposed New Value';
        }
        field(9; "Current Value Preview"; Text[2048])
        {
            Caption = 'Current Value Preview';
            Editable = false;
        }
        field(10; "Old Value Snapshot ID"; Guid)
        {
            Caption = 'Old Value Snapshot ID';
            Editable = false;
        }
        field(11; "New Value Snapshot ID"; Guid)
        {
            Caption = 'New Value Snapshot ID';
            Editable = false;
        }
        field(12; "Rollback Snapshot Mode"; Enum "BCDA Rollback Snapshot Mode")
        {
            Caption = 'Rollback Snapshot Mode';
            InitValue = "Policy Controlled";
        }
        field(13; "Snapshot Expires At"; DateTime)
        {
            Caption = 'Snapshot Expires At';
            Editable = false;
        }
        field(14; "Validation Mode"; Enum "BCDA Validation Mode")
        {
            Caption = 'Validation Mode';
            InitValue = "Policy Controlled";
        }
        field(15; "Line Status"; Enum "BCDA Line Status")
        {
            Caption = 'Line Status';
            InitValue = Open;
        }
        field(16; "Sanitized Error"; Text[2048])
        {
            Caption = 'Sanitized Error';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Request ID", "Line No.")
        {
            Clustered = true;
        }
        key(Target; "Table ID", "Field ID")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Line No." = 0 then
            "Line No." := GetNextLineNo();
    end;

    local procedure GetNextLineNo(): Integer
    var
        CorrectionLine: Record "BCDA Correction Line";
    begin
        CorrectionLine.SetRange("Request ID", "Request ID");
        if CorrectionLine.FindLast() then
            exit(CorrectionLine."Line No." + 10000);

        exit(10000);
    end;
}
