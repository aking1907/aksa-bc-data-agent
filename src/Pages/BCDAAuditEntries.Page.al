namespace AKSA.BCDataAgent;

page 88116 "BCDA Audit Entries"
{
    ApplicationArea = All;
    Caption = 'BCDA Audit Entries';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "BCDA Audit Entry";
    SourceTableView = sorting("Entry No.") order(descending);
    UsageCategory = History;

    layout
    {
        area(Content)
        {
            repeater(Entries)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the audit entry number.';
                }
                field(Operation; Rec.Operation)
                {
                    ToolTip = 'Specifies the audited operation.';
                }
                field(Result; Rec.Result)
                {
                    ToolTip = 'Specifies the operation result.';
                }
                field("Request ID"; Rec."Request ID")
                {
                    ToolTip = 'Specifies the related request ID.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the related line number.';
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the user who caused the audit entry.';
                }
                field("Occurred At"; Rec."Occurred At")
                {
                    ToolTip = 'Specifies when the audited event occurred.';
                }
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'Specifies the company context.';
                }
                field("Target Table ID"; Rec."Target Table ID")
                {
                    ToolTip = 'Specifies the target table ID.';
                }
                field("Target Record ID"; Rec."Target Record ID")
                {
                    ToolTip = 'Specifies the target record identity.';
                }
                field("Target Field ID"; Rec."Target Field ID")
                {
                    ToolTip = 'Specifies the target field ID.';
                }
                field("Rollback Available"; Rec."Rollback Available")
                {
                    ToolTip = 'Specifies whether rollback material is linked.';
                }
                field("Sanitized Error"; Rec."Sanitized Error")
                {
                    ToolTip = 'Specifies sanitized error details.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ExportFilteredAuditMetadata)
            {
                Caption = 'Export Filtered Metadata';
                Image = Export;
                ToolTip = 'Exports the filtered audit metadata to CSV. Target values and rollback snapshot payloads are omitted.';

                trigger OnAction()
                var
                    AuditExportMgt: Codeunit "BCDA Audit Export Mgt.";
                begin
                    AuditExportMgt.ExportFilteredAuditMetadata(Rec);
                end;
            }
            action(Rollback)
            {
                Caption = 'Rollback';
                Enabled = RollbackEnabled;
                Image = Undo;
                ToolTip = 'Rolls back the selected successful execution audit entry when retained rollback snapshots are available and conflict checks pass.';

                trigger OnAction()
                var
                    RollbackService: Codeunit "BCDA Rollback Service";
                begin
                    if not Confirm(RollbackConfirmQst, false, Rec."Entry No.") then
                        exit;

                    RollbackService.RollbackAuditEntry(Rec);
                    Message(RollbackFinishedMsg);
                    CurrPage.Update(false);
                end;
            }
        }
        area(Promoted)
        {
            actionref(ExportFilteredAuditMetadata_Promoted; ExportFilteredAuditMetadata)
            {
            }
            actionref(Rollback_Promoted; Rollback)
            {
            }
        }
    }

    trigger OnOpenPage()
    var
        AccessMgt: Codeunit "BCDA Access Mgt.";
    begin
        AccessMgt.EnsureSuperUser();
        UpdateRollbackAction();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateRollbackAction();
    end;

    local procedure UpdateRollbackAction()
    var
        CorrectionLine: Record "BCDA Correction Line";
        RollbackOperation: Record "BCDA Rollback Operation";
    begin
        RollbackEnabled := (Rec.Operation = Rec.Operation::Execution) and
            (Rec.Result = Rec.Result::Success) and Rec."Rollback Available";

        if not RollbackEnabled then
            exit;

        if not CorrectionLine.Get(Rec."Request ID", Rec."Line No.") then begin
            RollbackEnabled := false;
            exit;
        end;

        RollbackEnabled := CorrectionLine."Line Status" = CorrectionLine."Line Status"::Executed;
        if not RollbackEnabled then
            exit;

        RollbackOperation.SetRange("Source Request ID", Rec."Request ID");
        RollbackOperation.SetRange("Source Audit Entry No.", Rec."Entry No.");
        RollbackOperation.SetRange(Status, RollbackOperation.Status::Completed);
        RollbackEnabled := RollbackOperation.IsEmpty();
    end;

    var
        RollbackEnabled: Boolean;
        RollbackConfirmQst: Label 'Roll back execution audit entry %1? The current target value must still match the executed value, and a rollback audit entry will be written.', Comment = '%1 = audit entry number';
        RollbackFinishedMsg: Label 'Rollback finished. Review audit entries and rollback operations for the final result.';
}
