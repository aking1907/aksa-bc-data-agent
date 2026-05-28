namespace AKSA.BCDataAgent;

using System.Reflection;

page 88142 "BCDA Batch Line Builder"
{
    ApplicationArea = All;
    Caption = 'BCDA Batch Line Builder';
    DeleteAllowed = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = Worksheet;
    SourceTable = "BCDA Batch Line Buffer";
    SourceTableTemporary = true;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(BatchTarget)
            {
                Caption = 'Batch Target';

                field(BatchTableId; BatchTableId)
                {
                    ApplicationArea = All;
                    Caption = 'Table ID';
                    ToolTip = 'Specifies the target table used for all batch entries.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        TableMetadata: Record AllObjWithCaption;
                        TableLookup: Page "BCDA Table Lookup";
                    begin
                        TableMetadata.SetRange("Object Type", TableMetadata."Object Type"::Table);
                        TableLookup.SetTableView(TableMetadata);
                        TableLookup.LookupMode(true);
                        if TableLookup.RunModal() = Action::LookupOK then begin
                            TableLookup.GetRecord(TableMetadata);
                            SetBatchTable(TableMetadata."Object ID");
                            CurrPage.Update(false);
                        end;

                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        SetBatchTable(BatchTableId);
                    end;
                }
                field(BatchTableName; BatchTableName)
                {
                    ApplicationArea = All;
                    Caption = 'Table Name';
                    Editable = false;
                    ToolTip = 'Specifies the selected target table name.';
                }
            }
            repeater(BatchLines)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the batch entry number.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Editable = BatchTableSelected;
                    ToolTip = 'Specifies whether this batch entry stages an update, rename, delete, or insert operation.';
                }
                field("Record ID"; Rec."Record ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the target record identity for this batch entry.';
                }
                field("Field ID"; Rec."Field ID")
                {
                    ApplicationArea = All;
                    Editable = BatchTableSelected;
                    ToolTip = 'Specifies the target field ID for this batch entry.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldMetadata: Record "Field";
                        FieldLookup: Page "BCDA Field Lookup";
                    begin
                        EnsureBatchTableSelected();
                        FieldMetadata.SetRange(TableNo, BatchTableId);
                        FieldMetadata.SetRange(Enabled, true);
                        FieldMetadata.SetRange(Class, FieldMetadata.Class::Normal);
                        FieldLookup.SetTableView(FieldMetadata);
                        FieldLookup.LookupMode(true);
                        if FieldLookup.RunModal() = Action::LookupOK then begin
                            FieldLookup.GetRecord(FieldMetadata);
                            ApplyBatchTableToLine();
                            Rec.Validate("Field ID", FieldMetadata."No.");
                            CurrPage.Update(false);
                        end;

                        exit(true);
                    end;
                }
                field("Field Name"; Rec."Field Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the target field name.';
                }
                field("Proposed New Value"; Rec."Proposed New Value")
                {
                    ApplicationArea = All;
                    Editable = BatchTableSelected;
                    ToolTip = 'Specifies the proposed new value text for this batch entry.';
                }
                field("Rollback Snapshot Mode"; Rec."Rollback Snapshot Mode")
                {
                    ApplicationArea = All;
                    Editable = BatchTableSelected;
                    ToolTip = 'Specifies rollback snapshot mode for request lines created from this batch entry.';
                }
                field("Validation Mode"; Rec."Validation Mode")
                {
                    ApplicationArea = All;
                    Editable = BatchTableSelected;
                    ToolTip = 'Specifies validation mode for request lines created from this batch entry.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateRequestLines)
            {
                ApplicationArea = All;
                Caption = 'Create Request Lines';
                Enabled = false;
                Image = CreateLinesFromJob;
                ToolTip = 'Blocked until batch RecordId selection or target matrix entry is implemented.';

                trigger OnAction()
                var
                    CorrectionRequest: Record "BCDA Correction Request";
                    BatchLineMgt: Codeunit "BCDA Batch Line Mgt.";
                    CreatedCount: Integer;
                begin
                    EnsureBatchTableSelected();
                    CorrectionRequest.Get(RequestId);
                    CreatedCount := BatchLineMgt.CreateCorrectionLines(CorrectionRequest, BatchTableId, BatchTableName, Rec);
                    Message(RequestLinesCreatedMsg, CreatedCount);
                    CurrPage.Close();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        AccessMgt: Codeunit "BCDA Access Mgt.";
    begin
        AccessMgt.EnsureSuperUser();
        UpdateBatchTableSelected();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        NextEntryNo += 10000;
        Rec."Entry No." := NextEntryNo;
        if BatchTableSelected then
            ApplyBatchTableToLine();
    end;

    procedure SetRequest(CorrectionRequest: Record "BCDA Correction Request")
    begin
        RequestId := CorrectionRequest."Request ID";
        if RequestId = '' then
            Error(RequestRequiredErr);
    end;

    local procedure ApplyBatchTableToLine()
    begin
        Rec.Validate("Table ID", BatchTableId);
        Rec."Table Name" := BatchTableName;
    end;

    local procedure EnsureBatchTableSelected()
    begin
        if BatchTableId = 0 then
            Error(TableRequiredErr);
    end;

    local procedure SetBatchTable(NewTableId: Integer)
    var
        MetadataExplorer: Codeunit "BCDA Metadata Explorer";
    begin
        if (BatchTableId <> 0) and (NewTableId <> BatchTableId) and (Rec.Count() <> 0) then
            Error(ClearLinesBeforeTableChangeErr);

        BatchTableId := NewTableId;
        Clear(BatchTableName);
        if BatchTableId <> 0 then
            MetadataExplorer.ResolveTableCaption(BatchTableId, BatchTableName);

        UpdateBatchTableSelected();
        if BatchTableSelected and (Rec."Entry No." <> 0) then
            ApplyBatchTableToLine();
    end;

    local procedure UpdateBatchTableSelected()
    begin
        BatchTableSelected := BatchTableId <> 0;
    end;

    var
        BatchTableId: Integer;
        BatchTableName: Text[250];
        BatchTableSelected: Boolean;
        ClearLinesBeforeTableChangeErr: Label 'Delete the current batch entries before changing the batch table.';
        NextEntryNo: Integer;
        RequestId: Code[20];
        RequestLinesCreatedMsg: Label '%1 request line(s) were created from the batch.', Comment = '%1 = number of created request lines';
        RequestRequiredErr: Label 'Create or save the correction request before adding batch lines.';
        TableRequiredErr: Label 'Select a table before adding batch lines.';
}
