namespace AKSA.BCDataAgent;

using System.Reflection;

table 88101 "BCDA Data Policy"
{
    Caption = 'BCDA Data Policy';
    DataClassification = CustomerContent;
    LookupPageId = "BCDA Data Policies";
    DrillDownPageId = "BCDA Data Policies";

    fields
    {
        field(1; "Policy ID"; Code[20])
        {
            Caption = 'Policy ID';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; Enabled; Boolean)
        {
            Caption = 'Enabled';
            InitValue = true;
        }
        field(4; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            NotBlank = true;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));

            trigger OnValidate()
            var
                MetadataExplorer: Codeunit "BCDA Metadata Explorer";
            begin
                MetadataExplorer.ResolveTableCaption("Table ID", "Table Name");
                if "Table ID" <> xRec."Table ID" then begin
                    "Field ID" := 0;
                    Clear("Field Name");
                end;
            end;
        }
        field(5; "Table Name"; Text[250])
        {
            Caption = 'Table Name';
            Editable = false;
        }
        field(6; "Field ID"; Integer)
        {
            Caption = 'Field ID';
            TableRelation = "Field"."No." where(TableNo = field("Table ID"), Enabled = const(true), Class = const(Normal));

            trigger OnValidate()
            var
                MetadataExplorer: Codeunit "BCDA Metadata Explorer";
            begin
                MetadataExplorer.ResolveFieldCaption("Table ID", "Field ID", "Table Name", "Field Name");
            end;
        }
        field(7; "Field Name"; Text[250])
        {
            Caption = 'Field Name';
            Editable = false;
        }
        field(8; Operation; Code[20])
        {
            Caption = 'Operation';
            InitValue = 'MODIFY';
        }
        field(9; "Risk Level"; Enum "BCDA Risk Level")
        {
            Caption = 'Risk Level';
            InitValue = Normal;
        }
        field(10; Decision; Enum "BCDA Policy Decision")
        {
            Caption = 'Decision';
            InitValue = Block;
        }
        field(11; "Requires Approval"; Boolean)
        {
            Caption = 'Requires Approval';
            InitValue = true;
        }
        field(12; "Validation Mode"; Enum "BCDA Validation Mode")
        {
            Caption = 'Validation Mode';
            InitValue = "Validate Trigger";
        }
        field(13; "Rollback Snapshot Mode"; Enum "BCDA Rollback Snapshot Mode")
        {
            Caption = 'Rollback Snapshot Mode';
            InitValue = "Policy Controlled";
        }
        field(14; "Retention Override Days"; Integer)
        {
            Caption = 'Retention Override Days';
            MinValue = 0;
        }
        field(15; "Blocked Reason"; Text[250])
        {
            Caption = 'Blocked Reason';
        }
        field(16; "Last Reviewed At"; DateTime)
        {
            Caption = 'Last Reviewed At';
            Editable = false;
        }
        field(17; "Last Reviewed By"; Code[50])
        {
            Caption = 'Last Reviewed By';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Policy ID")
        {
            Clustered = true;
        }
        key(Target; "Table ID", "Field ID", Enabled)
        {
        }
    }

    trigger OnInsert()
    begin
        if "Policy ID" = '' then
            "Policy ID" := CopyStr(DelChr(Format(CreateGuid()), '=', '{}-'), 1, MaxStrLen("Policy ID"));
        StampReview();
    end;

    trigger OnModify()
    begin
        StampReview();
    end;

    local procedure StampReview()
    begin
        "Last Reviewed At" := CurrentDateTime();
        "Last Reviewed By" := CopyStr(UserId(), 1, MaxStrLen("Last Reviewed By"));
    end;
}
