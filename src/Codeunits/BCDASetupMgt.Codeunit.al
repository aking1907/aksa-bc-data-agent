namespace AKSA.BCDataAgent;

codeunit 88121 "BCDA Setup Mgt."
{
    Access = Internal;

    procedure EnsureSetup()
    var
        Setup: Record "BCDA Setup";
    begin
        if Setup.Get(Setup.GetPrimaryKey()) then begin
            UpgradeSetupDefaults(Setup);
            exit;
        end;

        Setup.Init();
        Setup."Primary Key" := Setup.GetPrimaryKey();
        Setup."Require Separate Approver" := true;
        Setup.Insert(true);
    end;

    procedure GetSetup(var Setup: Record "BCDA Setup")
    var
        SetupTemplate: Record "BCDA Setup";
    begin
        EnsureSetup();
        Setup.Get(SetupTemplate.GetPrimaryKey());
    end;

    procedure ApplyDefaultsToRequest(var CorrectionRequest: Record "BCDA Correction Request")
    var
        Setup: Record "BCDA Setup";
    begin
        GetSetup(Setup);
        CorrectionRequest."Approval Required" := Setup."Approval Required Default";
        CorrectionRequest."Require Separate Approver" := CorrectionRequest."Approval Required" and Setup."Require Separate Approver";
        CorrectionRequest."Preview Required" := Setup."Require Preview";
        CorrectionRequest."Rollback Availability" := Format(Setup."Rollback Snapshot Default");
        CorrectionRequest."Retention Impact" := StrSubstNo(RetentionImpactTxt, Setup."Audit Retention Days", Setup."Snapshot Retention Days", Setup."Technical Log Retention Days");
    end;

    local procedure UpgradeSetupDefaults(var Setup: Record "BCDA Setup")
    begin
        if Setup."Foundation Version" = '1.2' then
            exit;

        if (Setup."Foundation Version" = '') or (Setup."Foundation Version" = '1.0') then
            Setup."Require Separate Approver" := Setup."Approval Required Default";

        Setup."Allow Data Policies" := true;
        Setup."Foundation Version" := '1.2';
        Setup.Modify(true);
    end;

    var
        RetentionImpactTxt: Label 'Audit: %1 days; rollback snapshots: %2 days; technical logs: %3 days.', Comment = '%1 = audit retention days, %2 = rollback snapshot retention days, %3 = technical log retention days';
}
