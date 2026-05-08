namespace AKSA.BCDataAgent;

table 88104 "BCDA Audit Entry"
{
    Caption = 'BCDA Audit Entry';
    DataClassification = CustomerContent;
    LookupPageId = "BCDA Audit Entries";
    DrillDownPageId = "BCDA Audit Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; Operation; Enum "BCDA Audit Operation")
        {
            Caption = 'Operation';
        }
        field(3; Result; Enum "BCDA Audit Result")
        {
            Caption = 'Result';
        }
        field(4; "Request ID"; Code[20])
        {
            Caption = 'Request ID';
            TableRelation = "BCDA Correction Request";
        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(6; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
        }
        field(7; "Occurred At"; DateTime)
        {
            Caption = 'Occurred At';
            Editable = false;
        }
        field(8; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
        }
        field(9; "Target Table ID"; Integer)
        {
            Caption = 'Target Table ID';
        }
        field(10; "Target Table Name"; Text[250])
        {
            Caption = 'Target Table Name';
        }
        field(11; "Target Record ID"; RecordId)
        {
            Caption = 'Target Record ID';
        }
        field(12; "Target Field ID"; Integer)
        {
            Caption = 'Target Field ID';
        }
        field(13; "Target Field Name"; Text[250])
        {
            Caption = 'Target Field Name';
        }
        field(14; Reason; Text[250])
        {
            Caption = 'Reason';
        }
        field(15; "Ticket Reference"; Code[50])
        {
            Caption = 'Ticket/Reference';
        }
        field(16; "Rollback Available"; Boolean)
        {
            Caption = 'Rollback Available';
        }
        field(17; "Rollback Availability"; Text[250])
        {
            Caption = 'Rollback Availability';
        }
        field(18; "Old Snapshot ID"; Guid)
        {
            Caption = 'Old Snapshot ID';
        }
        field(19; "New Snapshot ID"; Guid)
        {
            Caption = 'New Snapshot ID';
        }
        field(20; "Error Code"; Code[50])
        {
            Caption = 'Error Code';
        }
        field(21; "Sanitized Error"; Text[2048])
        {
            Caption = 'Sanitized Error';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Request; "Request ID", "Line No.", "Entry No.")
        {
        }
        key(Target; "Target Table ID", "Target Field ID", "Occurred At")
        {
        }
    }

    trigger OnInsert()
    begin
        if "User ID" = '' then
            "User ID" := CopyStr(UserId(), 1, MaxStrLen("User ID"));

        if "Occurred At" = 0DT then
            "Occurred At" := CurrentDateTime();

        if "Company Name" = '' then
            "Company Name" := CopyStr(CompanyName(), 1, MaxStrLen("Company Name"));
    end;

    trigger OnModify()
    begin
        Error(AuditModifyBlockedErr);
    end;

    var
        AuditModifyBlockedErr: Label 'Audit entries are append-only and cannot be modified.';
}
