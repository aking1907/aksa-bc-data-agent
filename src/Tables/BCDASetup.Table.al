namespace AKSA.BCDataAgent;

table 88100 "BCDA Setup"
{
    Caption = 'BCDA Setup';
    DataClassification = CustomerContent;
    LookupPageId = "BCDA Setup";
    DrillDownPageId = "BCDA Setup";

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Environment Label"; Text[100])
        {
            Caption = 'Environment Label';
        }
        field(3; "Default Policy Decision"; Enum "BCDA Policy Decision")
        {
            Caption = 'Default Policy Decision';
            InitValue = Block;
        }
        field(4; "Approval Required Default"; Boolean)
        {
            Caption = 'Approval Required Default';
            InitValue = true;

            trigger OnValidate()
            begin
                if not "Approval Required Default" then
                    "Require Separate Approver" := false;
            end;
        }
        field(5; "Rollback Snapshot Default"; Enum "BCDA Rollback Snapshot Mode")
        {
            Caption = 'Rollback Snapshot Default';
            InitValue = Required;
        }
        field(6; "Audit Retention Days"; Integer)
        {
            Caption = 'Audit Retention Days';
            InitValue = 3650;
            MinValue = 0;
        }
        field(7; "Snapshot Retention Days"; Integer)
        {
            Caption = 'Snapshot Retention Days';
            InitValue = 90;
            MinValue = 0;
        }
        field(8; "Technical Log Retention Days"; Integer)
        {
            Caption = 'Technical Log Retention Days';
            InitValue = 30;
            MinValue = 0;
        }
        field(9; "Export Enabled"; Boolean)
        {
            Caption = 'Export Enabled';
        }
        field(10; "Require Preview"; Boolean)
        {
            Caption = 'Require Preview';
            InitValue = true;
        }
        field(11; "Foundation Version"; Code[20])
        {
            Caption = 'Foundation Version';
            Editable = false;
        }
        field(12; "Last Initialized At"; DateTime)
        {
            Caption = 'Last Initialized At';
            Editable = false;
        }
        field(13; "Require Separate Approver"; Boolean)
        {
            Caption = 'Require Separate Approver';
            InitValue = true;

            trigger OnValidate()
            begin
                if "Require Separate Approver" and not "Approval Required Default" then
                    Error(SeparateApproverRequiresApprovalErr);
            end;
        }
        field(14; "Allow Data Policies"; Boolean)
        {
            Caption = 'Allow Data Policies';
            InitValue = true;
        }
        field(15; "Require Ticket Reference"; Boolean)
        {
            Caption = 'Require Ticket Reference';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if "Primary Key" = '' then
            "Primary Key" := GetPrimaryKey();

        if "Foundation Version" = '' then
            "Foundation Version" := '1.3';

        if "Last Initialized At" = 0DT then
            "Last Initialized At" := CurrentDateTime();
    end;

    procedure GetPrimaryKey(): Code[10]
    begin
        exit('SETUP');
    end;

    var
        SeparateApproverRequiresApprovalErr: Label 'Separate approval can be required only when approval is required by default.';
}
