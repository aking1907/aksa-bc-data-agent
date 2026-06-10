namespace AKSA.BCDataAgent;

table 88102 "BCDA Correction Request"
{
    Caption = 'BCDA Correction Request';
    DataClassification = CustomerContent;
    LookupPageId = "BCDA Correction Requests";
    DrillDownPageId = "BCDA Correction Requests";
    DataCaptionFields = "Request ID", "Ticket Reference";

    fields
    {
        field(1; "Request ID"; Code[20])
        {
            Caption = 'Request ID';
        }
        field(2; Status; Enum "BCDA Request Status")
        {
            Caption = 'Status';
            InitValue = Open;
        }
        field(3; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
        }
        field(4; Reason; Text[250])
        {
            Caption = 'Reason';
        }
        field(5; "Ticket Reference"; Code[50])
        {
            Caption = 'Ticket/Reference';
        }
        field(6; "Risk Level"; Enum "BCDA Risk Level")
        {
            Caption = 'Risk Level';
            InitValue = Normal;
        }
        field(7; "Requested By"; Code[50])
        {
            Caption = 'Requested By';
            Editable = false;
        }
        field(8; "Requested At"; DateTime)
        {
            Caption = 'Requested At';
            Editable = false;
        }
        field(9; "Approval Required"; Boolean)
        {
            Caption = 'Approval Required';
            InitValue = true;

            trigger OnValidate()
            begin
                if "Approval Required" then
                    exit;

                "Require Separate Approver" := false;
                Clear("Approved By");
                Clear("Approved At");

                if (Status = Status::"Pending Approval") or (Status = Status::Approved) then
                    Status := Status::Open;
            end;
        }
        field(10; "Approved By"; Code[50])
        {
            Caption = 'Approved By';
            Editable = false;
        }
        field(11; "Approved At"; DateTime)
        {
            Caption = 'Approved At';
            Editable = false;
        }
        field(12; "Preview Required"; Boolean)
        {
            Caption = 'Preview Required';
            InitValue = true;
        }
        field(13; "Last Preview At"; DateTime)
        {
            Caption = 'Last Preview At';
            Editable = false;
        }
        field(14; "Rollback Availability"; Text[250])
        {
            Caption = 'Rollback Availability';
            Editable = false;
        }
        field(15; "Retention Impact"; Text[250])
        {
            Caption = 'Retention Impact';
            Editable = false;
        }
        field(16; "Require Separate Approver"; Boolean)
        {
            Caption = 'Require Separate Approver';
            InitValue = true;

            trigger OnValidate()
            begin
                if "Require Separate Approver" and not "Approval Required" then
                    Error(SeparateApproverRequiresApprovalErr);
            end;
        }
        field(17; "Ticket Reference Required"; Boolean)
        {
            Caption = 'Ticket Reference Required';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Request ID")
        {
            Clustered = true;
        }
        key(Status; Status, "Requested At")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Request ID" = '' then
            "Request ID" := CopyStr(DelChr(Format(CreateGuid()), '=', '{}-'), 1, MaxStrLen("Request ID"));

        if "Company Name" = '' then
            "Company Name" := CopyStr(CompanyName(), 1, MaxStrLen("Company Name"));

        if "Requested By" = '' then
            "Requested By" := CopyStr(UserId(), 1, MaxStrLen("Requested By"));

        if "Requested At" = 0DT then
            "Requested At" := CurrentDateTime();
    end;

    procedure HasRequiredMetadata(): Boolean
    begin
        exit((Reason <> '') and ((not "Ticket Reference Required") or ("Ticket Reference" <> '')));
    end;

    var
        SeparateApproverRequiresApprovalErr: Label 'Separate approval can be required only when approval is required for this request.';
}
