namespace AKSA.BCDataAgent;

page 88143 "BCDA Target Record Lookup"
{
    ApplicationArea = All;
    Caption = 'BCDA Target Record Lookup';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "BCDA Target Record Buffer";
    SourceTableTemporary = true;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(Records)
            {
                field("Display Key"; Rec."Display Key")
                {
                    ApplicationArea = All;
                    Caption = 'Primary Key Values';
                    ToolTip = 'Shows the primary-key field captions and values for the target record. A simple key shows one value; a composite key shows each key part.';
                }
                field("Record ID"; Rec."Record ID")
                {
                    ApplicationArea = All;
                    Caption = 'Target Record Identity';
                    ToolTip = 'Specifies the canonical Business Central target record identity populated after choosing the primary-key values.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        AccessMgt: Codeunit "BCDA Access Mgt.";
    begin
        AccessMgt.EnsureSuperUser();
        LoadTargetRecords();
    end;

    procedure SetTargetTable(TableId: Integer)
    begin
        TargetTableId := TableId;
    end;

    procedure GetSelectedRecordId(): RecordId
    begin
        exit(Rec."Record ID");
    end;

    local procedure LoadTargetRecords()
    var
        TargetRecordRef: RecordRef;
        EntryNo: Integer;
    begin
        if TargetTableId = 0 then
            Error(TableRequiredErr);

        Rec.DeleteAll();
        TargetRecordRef.Open(TargetTableId);
        if TargetRecordRef.FindSet() then
            repeat
                EntryNo += 1;
                Rec.Init();
                Rec."Entry No." := EntryNo;
                Rec."Table ID" := TargetTableId;
                Rec."Record ID" := TargetRecordRef.RecordId();
                Rec."Display Key" := CopyStr(BuildDisplayKey(TargetRecordRef), 1, MaxStrLen(Rec."Display Key"));
                Rec.Insert();
            until (TargetRecordRef.Next() = 0) or (EntryNo >= GetMaxRecordCount());

        TargetRecordRef.Close();
    end;

    local procedure BuildDisplayKey(var TargetRecordRef: RecordRef): Text
    var
        FieldRef: FieldRef;
        KeyRef: KeyRef;
        DisplayKey: Text;
        Index: Integer;
    begin
        KeyRef := TargetRecordRef.KeyIndex(1);
        for Index := 1 to KeyRef.FieldCount() do begin
            FieldRef := KeyRef.FieldIndex(Index);
            if DisplayKey <> '' then
                DisplayKey += ', ';
            DisplayKey += StrSubstNo(DisplayKeyPartTxt, FieldRef.Caption(), Format(FieldRef.Value()));
        end;

        if DisplayKey = '' then
            DisplayKey := Format(TargetRecordRef.RecordId());

        exit(DisplayKey);
    end;

    local procedure GetMaxRecordCount(): Integer
    begin
        exit(200);
    end;

    var
        TargetTableId: Integer;
        DisplayKeyPartTxt: Label '%1: %2', Comment = '%1 = field caption, %2 = field value';
        TableRequiredErr: Label 'Select a table before selecting a record.';
}
