namespace AKSA.BCDataAgent;

codeunit 88125 "BCDA Correction Orchestrator"
{
    Access = Internal;

    procedure InitializeRequest(var CorrectionRequest: Record "BCDA Correction Request")
    var
        AccessMgt: Codeunit "BCDA Access Mgt.";
        AuditWriter: Codeunit "BCDA Audit Writer";
        SetupMgt: Codeunit "BCDA Setup Mgt.";
    begin
        AccessMgt.EnsureSuperUser();
        SetupMgt.ApplyDefaultsToRequest(CorrectionRequest);
        SaveRequest(CorrectionRequest);
        AuditWriter.WriteRequestAudit(CorrectionRequest, "BCDA Audit Operation"::"Request Created", "BCDA Audit Result"::Success, '');
    end;

    procedure SubmitForApproval(var CorrectionRequest: Record "BCDA Correction Request")
    var
        AccessMgt: Codeunit "BCDA Access Mgt.";
        AuditWriter: Codeunit "BCDA Audit Writer";
    begin
        AccessMgt.EnsureSuperUser();
        EnsureExistingRequest(CorrectionRequest);
        EnsureRequestMetadata(CorrectionRequest);
        EnsureApprovalRequired(CorrectionRequest);

        CorrectionRequest.Status := CorrectionRequest.Status::"Pending Approval";
        CorrectionRequest.Modify(true);
        AuditWriter.WriteRequestAudit(CorrectionRequest, "BCDA Audit Operation"::Approval, "BCDA Audit Result"::Success, '');
    end;

    procedure Approve(var CorrectionRequest: Record "BCDA Correction Request")
    var
        AccessMgt: Codeunit "BCDA Access Mgt.";
        AuditWriter: Codeunit "BCDA Audit Writer";
    begin
        AccessMgt.EnsureSuperUser();
        EnsureExistingRequest(CorrectionRequest);
        EnsureRequestMetadata(CorrectionRequest);
        EnsureApprovalRequired(CorrectionRequest);
        EnsurePendingApproval(CorrectionRequest);
        EnsureApproverAllowed(CorrectionRequest);

        CorrectionRequest.Status := CorrectionRequest.Status::Approved;
        CorrectionRequest."Approved By" := CopyStr(UserId(), 1, MaxStrLen(CorrectionRequest."Approved By"));
        CorrectionRequest."Approved At" := CurrentDateTime();
        CorrectionRequest.Modify(true);
        AuditWriter.WriteRequestAudit(CorrectionRequest, "BCDA Audit Operation"::Approval, "BCDA Audit Result"::Success, '');
    end;

    procedure MarkPreviewed(var CorrectionRequest: Record "BCDA Correction Request")
    var
        AccessMgt: Codeunit "BCDA Access Mgt.";
        AuditWriter: Codeunit "BCDA Audit Writer";
    begin
        AccessMgt.EnsureSuperUser();
        EnsureExistingRequest(CorrectionRequest);
        EnsurePreviewAllowed(CorrectionRequest);
        EnsureRequestMetadata(CorrectionRequest);

        CorrectionRequest.Status := CorrectionRequest.Status::Previewed;
        CorrectionRequest."Last Preview At" := CurrentDateTime();
        CorrectionRequest.Modify(true);
        AuditWriter.WriteRequestAudit(CorrectionRequest, "BCDA Audit Operation"::Preview, "BCDA Audit Result"::Warning, FoundationPreviewOnlyTxt);
    end;

    procedure ExecuteRequest(var CorrectionRequest: Record "BCDA Correction Request")
    var
        AccessMgt: Codeunit "BCDA Access Mgt.";
        AuditWriter: Codeunit "BCDA Audit Writer";
    begin
        AccessMgt.EnsureSuperUser();
        EnsureExistingRequest(CorrectionRequest);
        EnsureRequestMetadata(CorrectionRequest);
        AuditWriter.WriteRequestAudit(CorrectionRequest, "BCDA Audit Operation"::Execution, "BCDA Audit Result"::Blocked, ExecutionBlockedTxt);
        Commit();
        Error(ExecutionBlockedTxt);
    end;

    local procedure EnsureExistingRequest(CorrectionRequest: Record "BCDA Correction Request")
    begin
        if CorrectionRequest."Request ID" = '' then
            Error(RequestRequiredErr);
    end;

    local procedure EnsureRequestMetadata(CorrectionRequest: Record "BCDA Correction Request")
    begin
        if not CorrectionRequest.HasRequiredMetadata() then
            Error(MissingMetadataErr);
    end;

    local procedure EnsureApproverAllowed(CorrectionRequest: Record "BCDA Correction Request")
    begin
        if not CorrectionRequest."Require Separate Approver" then
            exit;

        if CorrectionRequest."Requested By" = CopyStr(UserId(), 1, MaxStrLen(CorrectionRequest."Requested By")) then
            Error(SecondSuperApprovalErr);
    end;

    local procedure EnsureApprovalRequired(CorrectionRequest: Record "BCDA Correction Request")
    begin
        if not CorrectionRequest."Approval Required" then
            Error(ApprovalNotRequiredErr);
    end;

    local procedure EnsurePendingApproval(CorrectionRequest: Record "BCDA Correction Request")
    begin
        if CorrectionRequest.Status <> CorrectionRequest.Status::"Pending Approval" then
            Error(PendingApprovalRequiredErr);
    end;

    local procedure EnsurePreviewAllowed(CorrectionRequest: Record "BCDA Correction Request")
    begin
        if (CorrectionRequest.Status <> CorrectionRequest.Status::Open) and
           (CorrectionRequest.Status <> CorrectionRequest.Status::Previewed)
        then
            Error(PreviewStatusErr);
    end;

    local procedure SaveRequest(var CorrectionRequest: Record "BCDA Correction Request")
    begin
        if CorrectionRequest."Request ID" = '' then
            CorrectionRequest.Insert(true)
        else
            CorrectionRequest.Modify(true);
    end;

    var
        MissingMetadataErr: Label 'Reason and ticket/reference are required before this action.';
        RequestRequiredErr: Label 'Initialize or save the correction request before this action.';
        ApprovalNotRequiredErr: Label 'This BC Data Agent request does not require approval. Review the approval setup if approval should be required.';
        PendingApprovalRequiredErr: Label 'Submit the request for approval before approving it.';
        PreviewStatusErr: Label 'Preview can be marked only while the request is open.';
        SecondSuperApprovalErr: Label 'A different SUPER user must approve this BC Data Agent request because separate approval is required.';
        FoundationPreviewOnlyTxt: Label 'Foundation preview marker only. Target record value preview is blocked until the next readiness gate.';
        ExecutionBlockedTxt: Label 'Target data execution is blocked until mutation readiness is approved.';
}
