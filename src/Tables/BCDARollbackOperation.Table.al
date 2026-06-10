namespace AKSA.BCDataAgent;

table 88106 "BCDA Rollback Operation"
{
    Caption = 'BCDA Rollback Operation';
    DataClassification = CustomerContent;
    LookupPageId = "BCDA Rollback Operations";
    DrillDownPageId = "BCDA Rollback Operations";

    fields
    {
        field(1; "Rollback ID"; Code[20])
        {
            Caption = 'Rollback ID';
        }
        field(2; "Source Request ID"; Code[20])
        {
            Caption = 'Source Request ID';
            TableRelation = "BCDA Correction Request";
        }
        field(3; "Source Audit Entry No."; Integer)
        {
            Caption = 'Source Audit Entry No.';
            TableRelation = "BCDA Audit Entry";
        }
        field(4; Status; Enum "BCDA Request Status")
        {
            Caption = 'Status';
            InitValue = Open;
        }
        field(5; "Conflict Policy"; Enum "BCDA Conflict Policy")
        {
            Caption = 'Conflict Policy';
            InitValue = "Stop On Conflict";
        }
        field(6; "Requested By"; Code[50])
        {
            Caption = 'Requested By';
            Editable = false;
        }
        field(7; "Requested At"; DateTime)
        {
            Caption = 'Requested At';
            Editable = false;
        }
        field(8; "Completed By"; Code[50])
        {
            Caption = 'Completed By';
            Editable = false;
        }
        field(9; "Completed At"; DateTime)
        {
            Caption = 'Completed At';
            Editable = false;
        }
        field(10; Result; Enum "BCDA Audit Result")
        {
            Caption = 'Result';
        }
        field(11; "Sanitized Error"; Text[2048])
        {
            Caption = 'Sanitized Error';
            Editable = false;
        }
        field(12; "Generated Request ID"; Code[20])
        {
            Caption = 'Generated Request ID';
            TableRelation = "BCDA Correction Request";
        }
    }

    keys
    {
        key(PK; "Rollback ID")
        {
            Clustered = true;
        }
        key(Source; "Source Request ID", "Source Audit Entry No.")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Rollback ID" = '' then
            "Rollback ID" := CopyStr(DelChr(Format(CreateGuid()), '=', '{}-'), 1, MaxStrLen("Rollback ID"));

        if "Requested By" = '' then
            "Requested By" := CopyStr(UserId(), 1, MaxStrLen("Requested By"));

        if "Requested At" = 0DT then
            "Requested At" := CurrentDateTime();
    end;
}
