namespace AKSA.BCDataAgent;

codeunit 88122 "BCDA Policy Guard"
{
    Access = Internal;

    procedure EvaluateLine(CorrectionLine: Record "BCDA Correction Line"; var Decision: Enum "BCDA Policy Decision"; var DecisionReason: Text[250]): Boolean
    var
        DataPolicy: Record "BCDA Data Policy";
        Setup: Record "BCDA Setup";
        MetadataExplorer: Codeunit "BCDA Metadata Explorer";
        SetupMgt: Codeunit "BCDA Setup Mgt.";
    begin
        SetupMgt.GetSetup(Setup);

        if MetadataExplorer.IsFoundationObjectId(CorrectionLine."Table ID") then begin
            Decision := Decision::Block;
            DecisionReason := AppOwnedTableBlockedReasonTxt;
            exit(false);
        end;

        if not Setup."Allow Data Policies" then begin
            Decision := Decision::Allow;
            DecisionReason := DataPoliciesBypassedReasonTxt;
            exit(true);
        end;

        if not FindPolicy(CorrectionLine."Table ID", CorrectionLine."Field ID", DataPolicy) then begin
            Decision := Setup."Default Policy Decision";
            DecisionReason := NoPolicyReasonTxt;
            exit(Decision <> Decision::Block);
        end;

        if not DataPolicy.Enabled then begin
            Decision := Decision::Block;
            DecisionReason := DisabledPolicyReasonTxt;
            exit(false);
        end;

        Decision := DataPolicy.Decision;
        DecisionReason := DataPolicy."Blocked Reason";
        if DecisionReason = '' then
            DecisionReason := StrSubstNo(PolicyDecisionReasonTxt, DataPolicy."Policy ID", Format(Decision));

        exit(Decision <> Decision::Block);
    end;

    local procedure FindPolicy(TableId: Integer; FieldId: Integer; var DataPolicy: Record "BCDA Data Policy"): Boolean
    begin
        DataPolicy.Reset();
        DataPolicy.SetRange("Table ID", TableId);
        DataPolicy.SetRange("Field ID", FieldId);
        DataPolicy.SetRange(Operation, 'MODIFY');
        if DataPolicy.FindFirst() then
            exit(true);

        DataPolicy.Reset();
        DataPolicy.SetRange("Table ID", TableId);
        DataPolicy.SetRange("Field ID", 0);
        DataPolicy.SetRange(Operation, 'MODIFY');
        exit(DataPolicy.FindFirst());
    end;

    var
        NoPolicyReasonTxt: Label 'No explicit policy exists for this table and field; the default setup decision applies.';
        DataPoliciesBypassedReasonTxt: Label 'Data policy records are bypassed by BCDA setup; permanent runtime blocks still apply.';
        DisabledPolicyReasonTxt: Label 'The matching data policy is disabled.';
        AppOwnedTableBlockedReasonTxt: Label 'BC Data Agent app-owned tables are permanently blocked correction targets.';
        PolicyDecisionReasonTxt: Label 'Policy %1 returned decision %2.', Comment = '%1 = policy ID, %2 = policy decision';
}
