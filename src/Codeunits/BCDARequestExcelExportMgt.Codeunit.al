namespace AKSA.BCDataAgent;

using Microsoft.Utilities;
using System.IO;
using System.Reflection;
using System.Utilities;

codeunit 88134 "BCDA Request Excel Export Mgt."
{
    Access = Internal;

    procedure ExportRequest(var CorrectionRequest: Record "BCDA Correction Request")
    var
        Setup: Record "BCDA Setup";
        TempExcelBuffer: Record "Excel Buffer" temporary;
        TempTableLine: Record "BCDA Correction Line" temporary;
        AccessMgt: Codeunit "BCDA Access Mgt.";
        AuditWriter: Codeunit "BCDA Audit Writer";
        SetupMgt: Codeunit "BCDA Setup Mgt.";
        SheetNames: List of [Text];
        SheetName: Text[31];
        SheetNo: Integer;
    begin
        AccessMgt.EnsureSuperUser();

        if CorrectionRequest."Request ID" = '' then
            Error(RequestIdRequiredErr);

        SetupMgt.GetSetup(Setup);
        if not Setup."Export Enabled" then begin
            AuditWriter.WriteRequestAudit(CorrectionRequest, "BCDA Audit Operation"::"Request Export", "BCDA Audit Result"::Blocked, ExportNotEnabledErr);
            Error(ExportNotEnabledErr);
        end;

        BuildTableList(CorrectionRequest."Request ID", TempTableLine);

        if not TempTableLine.FindSet() then begin
            AuditWriter.WriteRequestAudit(CorrectionRequest, "BCDA Audit Operation"::"Request Export", "BCDA Audit Result"::Warning, NoCorrectionLinesErr);
            Error(NoCorrectionLinesErr);
        end;

        repeat
            SheetNo += 1;
            SheetName := GetUniqueSheetName(GetTableCaption(TempTableLine."Table ID", TempTableLine."Table Name"), TempTableLine."Table ID", SheetNames);

            TempExcelBuffer.DeleteAll();
            WriteTableSheet(TempExcelBuffer, CorrectionRequest, TempTableLine."Table ID", GetTableCaption(TempTableLine."Table ID", TempTableLine."Table Name"));

            if SheetNo = 1 then
                TempExcelBuffer.CreateNewBook(SheetName)
            else
                TempExcelBuffer.SelectOrAddSheet(SheetName);

            TempExcelBuffer.WriteSheet(SheetName, CompanyName(), UserId());
        until TempTableLine.Next() = 0;

        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(StrSubstNo(RequestExportFileNameTxt, CorrectionRequest."Request ID"));
        AuditWriter.WriteRequestAudit(CorrectionRequest, "BCDA Audit Operation"::"Request Export", "BCDA Audit Result"::Success, RequestExportedMsg);
        TempExcelBuffer.OpenExcel();
    end;

    procedure ImportRequest(var CorrectionRequest: Record "BCDA Correction Request"): Integer
    var
        TempImportedLine: Record "BCDA Correction Line" temporary;
        AccessMgt: Codeunit "BCDA Access Mgt.";
        AuditWriter: Codeunit "BCDA Audit Writer";
        TempBlob: Codeunit "Temp Blob";
        FileInStream: InStream;
        BlobOutStream: OutStream;
        FileName: Text;
        ImportedCount: Integer;
    begin
        AccessMgt.EnsureSuperUser();

        if CorrectionRequest."Request ID" = '' then
            Error(RequestIdRequiredBeforeImportErr);

        if CorrectionRequest.Status <> CorrectionRequest.Status::Open then begin
            AuditWriter.WriteRequestAudit(CorrectionRequest, "BCDA Audit Operation"::"Request Import", "BCDA Audit Result"::Blocked, ImportOpenOnlyErr);
            Error(ImportOpenOnlyErr);
        end;

        if not UploadIntoStream(ImportExcelDialogTitleTxt, '', ExcelFileFilterTxt, FileName, FileInStream) then
            exit(0);

        TempBlob.CreateOutStream(BlobOutStream);
        CopyStream(BlobOutStream, FileInStream);

        ImportWorkbook(CorrectionRequest, TempBlob, TempImportedLine);
        ImportedCount := ReplaceRequestLines(CorrectionRequest."Request ID", TempImportedLine);

        AuditWriter.WriteRequestAudit(CorrectionRequest, "BCDA Audit Operation"::"Request Import", "BCDA Audit Result"::Success, CopyStr(StrSubstNo(RequestImportedMsg, ImportedCount), 1, 2048));
        exit(ImportedCount);
    end;

    local procedure ImportWorkbook(CorrectionRequest: Record "BCDA Correction Request"; var TempBlob: Codeunit "Temp Blob"; var TempImportedLine: Record "BCDA Correction Line" temporary)
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        TempSheetName: Record "Name/Value Buffer" temporary;
        WorkbookInStream: InStream;
        ImportedLineCount: Integer;
    begin
        TempImportedLine.Reset();
        TempImportedLine.DeleteAll();

        TempBlob.CreateInStream(WorkbookInStream);
        TempExcelBuffer.GetSheetsNameListFromStream(WorkbookInStream, TempSheetName);
        if TempSheetName.IsEmpty() then
            Error(NoWorksheetsErr);

        TempSheetName.FindSet();
        repeat
            TempBlob.CreateInStream(WorkbookInStream);
            TempExcelBuffer.Reset();
            TempExcelBuffer.DeleteAll();
            TempExcelBuffer.OpenBookStream(WorkbookInStream, TempSheetName.Value);
            TempExcelBuffer.ReadSheet();
            ImportWorksheet(CorrectionRequest, TempExcelBuffer, TempImportedLine);
        until TempSheetName.Next() = 0;

        TempImportedLine.Reset();
        ImportedLineCount := TempImportedLine.Count();
        if ImportedLineCount = 0 then
            Error(NoImportLinesErr);
    end;

    local procedure ImportWorksheet(CorrectionRequest: Record "BCDA Correction Request"; var TempExcelBuffer: Record "Excel Buffer" temporary; var TempImportedLine: Record "BCDA Correction Line" temporary)
    var
        TempFieldMapping: Record Field temporary;
        TempCurrentLine: Record "BCDA Correction Line" temporary;
        TableID: Integer;
        RequestID: Code[20];
        MaxRowNo: Integer;
        RowNo: Integer;
    begin
        TableID := GetImportTableID(TempExcelBuffer);
        if TableID = 0 then
            exit;

        RequestID := CopyStr(GetCellText(TempExcelBuffer, 1, 2), 1, MaxStrLen(RequestID));
        if (RequestID <> '') and (RequestID <> CorrectionRequest."Request ID") then
            Error(ImportRequestIdMismatchErr, RequestID, CorrectionRequest."Request ID");

        BuildImportFieldMapping(TempExcelBuffer, TableID, TempFieldMapping);
        MaxRowNo := GetMaxRowNo(TempExcelBuffer);

        for RowNo := 4 to MaxRowNo do
            ImportMatrixRow(CorrectionRequest."Request ID", TableID, RowNo, TempExcelBuffer, TempFieldMapping, TempCurrentLine, TempImportedLine);
    end;

    local procedure BuildImportFieldMapping(var TempExcelBuffer: Record "Excel Buffer" temporary; TableID: Integer; var TempFieldMapping: Record Field temporary)
    var
        ColumnNo: Integer;
        FieldID: Integer;
    begin
        TempFieldMapping.Reset();
        TempFieldMapping.DeleteAll();

        for ColumnNo := 5 to GetMaxColumnNo(TempExcelBuffer, 3) do begin
            FieldID := ParseFieldID(GetCellText(TempExcelBuffer, 3, ColumnNo));
            if FieldID <> 0 then begin
                EnsureFieldExists(TableID, FieldID);

                if not TempFieldMapping.Get(TableID, FieldID) then begin
                    TempFieldMapping.Init();
                    TempFieldMapping.TableNo := TableID;
                    TempFieldMapping."No." := FieldID;
                    TempFieldMapping.RelationFieldNo := ColumnNo;
                    TempFieldMapping.Insert();
                end;
            end;
        end;

        TempFieldMapping.Reset();
        TempFieldMapping.SetCurrentKey(RelationFieldNo);
    end;

    local procedure ImportMatrixRow(RequestID: Code[20]; TableID: Integer; RowNo: Integer; var TempExcelBuffer: Record "Excel Buffer" temporary; var TempFieldMapping: Record Field temporary; var TempCurrentLine: Record "BCDA Correction Line" temporary; var TempImportedLine: Record "BCDA Correction Line" temporary)
    var
        RecordID: RecordId;
        CorrectionType: Enum "BCDA Correction Type";
        InsertGroupNo: Integer;
        ValueType: Text;
    begin
        ValueType := NormalizeText(GetCellText(TempExcelBuffer, RowNo, 1));
        if ValueType = '' then
            exit;

        CorrectionType := ParseCorrectionType(GetCellText(TempExcelBuffer, RowNo, 2), RowNo);
        RecordID := ParseRecordID(CorrectionType, TableID, GetCellText(TempExcelBuffer, RowNo, 3), RowNo);
        InsertGroupNo := ParseInsertGroupNo(CorrectionType, GetCellText(TempExcelBuffer, RowNo, 4), RowNo);

        if ValueType = NormalizeText(CurrentValueTypeTxt) then begin
            if CorrectionType = CorrectionType::Delete then begin
                AddImportedDeleteLine(RequestID, TableID, CorrectionType, RecordID, TempImportedLine);
                exit;
            end;

            if CorrectionType = CorrectionType::Insert then
                Error(ImportInsertCurrentRowErr, RowNo);

            CacheCurrentValues(RequestID, TableID, CorrectionType, RecordID, InsertGroupNo, RowNo, TempExcelBuffer, TempFieldMapping, TempCurrentLine);
            exit;
        end;

        if ValueType = NormalizeText(NewValueTypeTxt) then begin
            ImportNewValues(RequestID, TableID, CorrectionType, RecordID, InsertGroupNo, RowNo, TempExcelBuffer, TempFieldMapping, TempCurrentLine, TempImportedLine);
            exit;
        end;

        Error(ImportValueTypeErr, RowNo, GetCellText(TempExcelBuffer, RowNo, 1));
    end;

    local procedure CacheCurrentValues(RequestID: Code[20]; TableID: Integer; CorrectionType: Enum "BCDA Correction Type"; RecordID: RecordId; InsertGroupNo: Integer; RowNo: Integer; var TempExcelBuffer: Record "Excel Buffer" temporary; var TempFieldMapping: Record Field temporary; var TempCurrentLine: Record "BCDA Correction Line" temporary)
    var
        CurrentValue: Text;
    begin
        TempFieldMapping.Reset();
        TempFieldMapping.SetCurrentKey(RelationFieldNo);
        if not TempFieldMapping.FindSet() then
            exit;

        repeat
            CurrentValue := GetCellText(TempExcelBuffer, RowNo, TempFieldMapping.RelationFieldNo);
            if CurrentValue <> '' then
                AddCurrentValueLine(RequestID, TableID, CorrectionType, RecordID, InsertGroupNo, TempFieldMapping."No.", CurrentValue, TempCurrentLine);
        until TempFieldMapping.Next() = 0;
    end;

    local procedure ImportNewValues(RequestID: Code[20]; TableID: Integer; CorrectionType: Enum "BCDA Correction Type"; RecordID: RecordId; InsertGroupNo: Integer; RowNo: Integer; var TempExcelBuffer: Record "Excel Buffer" temporary; var TempFieldMapping: Record Field temporary; var TempCurrentLine: Record "BCDA Correction Line" temporary; var TempImportedLine: Record "BCDA Correction Line" temporary)
    var
        CurrentValue: Text;
        ProposedValue: Text;
    begin
        if CorrectionType = CorrectionType::Delete then
            Error(ImportDeleteNewRowErr, RowNo);

        TempFieldMapping.Reset();
        TempFieldMapping.SetCurrentKey(RelationFieldNo);
        if not TempFieldMapping.FindSet() then
            Error(ImportNoFieldHeadersErr, RowNo);

        repeat
            ProposedValue := GetCellText(TempExcelBuffer, RowNo, TempFieldMapping.RelationFieldNo);
            CurrentValue := GetCurrentValue(TempCurrentLine, CorrectionType, RecordID, InsertGroupNo, TempFieldMapping."No.");
            if ShouldImportValueLine(CorrectionType, CurrentValue, ProposedValue) then
                AddImportedValueLine(RequestID, TableID, CorrectionType, RecordID, InsertGroupNo, TempFieldMapping."No.", CurrentValue, ProposedValue, TempImportedLine);
        until TempFieldMapping.Next() = 0;
    end;

    local procedure AddCurrentValueLine(RequestID: Code[20]; TableID: Integer; CorrectionType: Enum "BCDA Correction Type"; RecordID: RecordId; InsertGroupNo: Integer; FieldID: Integer; CurrentValue: Text; var TempCurrentLine: Record "BCDA Correction Line" temporary)
    begin
        TempCurrentLine.Init();
        TempCurrentLine."Request ID" := RequestID;
        TempCurrentLine.Type := CorrectionType;
        TempCurrentLine."Line No." := GetNextTempLineNo(TempCurrentLine);
        TempCurrentLine."Table ID" := TableID;
        TempCurrentLine."Record ID" := RecordID;
        TempCurrentLine."Insert Group No." := InsertGroupNo;
        TempCurrentLine."Field ID" := FieldID;
        TempCurrentLine."Current Value Preview" := CopyStr(CurrentValue, 1, MaxStrLen(TempCurrentLine."Current Value Preview"));
        TempCurrentLine.Insert();
    end;

    local procedure AddImportedDeleteLine(RequestID: Code[20]; TableID: Integer; CorrectionType: Enum "BCDA Correction Type"; RecordID: RecordId; var TempImportedLine: Record "BCDA Correction Line" temporary)
    var
        ImportedLine: Record "BCDA Correction Line";
    begin
        ImportedLine.Init();
        ImportedLine."Request ID" := RequestID;
        ImportedLine."Line No." := GetNextTempLineNo(TempImportedLine);
        ImportedLine.Validate(Type, CorrectionType);
        ImportedLine.Validate("Table ID", TableID);
        ImportedLine.Validate("Record ID", RecordID);
        TempImportedLine := ImportedLine;
        TempImportedLine.Insert();
    end;

    local procedure AddImportedValueLine(RequestID: Code[20]; TableID: Integer; CorrectionType: Enum "BCDA Correction Type"; RecordID: RecordId; InsertGroupNo: Integer; FieldID: Integer; CurrentValue: Text; ProposedValue: Text; var TempImportedLine: Record "BCDA Correction Line" temporary)
    var
        ImportedLine: Record "BCDA Correction Line";
    begin
        ImportedLine.Init();
        ImportedLine."Request ID" := RequestID;
        ImportedLine."Line No." := GetNextTempLineNo(TempImportedLine);
        ImportedLine.Validate(Type, CorrectionType);
        ImportedLine.Validate("Table ID", TableID);
        if CorrectionType = CorrectionType::Insert then
            ImportedLine.Validate("Insert Group No.", InsertGroupNo)
        else
            ImportedLine.Validate("Record ID", RecordID);
        ImportedLine.Validate("Field ID", FieldID);
        ImportedLine.Validate("Proposed New Value", CopyStr(ProposedValue, 1, MaxStrLen(ImportedLine."Proposed New Value")));
        if CurrentValue <> '' then
            ImportedLine."Current Value Preview" := CopyStr(CurrentValue, 1, MaxStrLen(ImportedLine."Current Value Preview"));
        TempImportedLine := ImportedLine;
        TempImportedLine.Insert();
    end;

    local procedure ReplaceRequestLines(RequestID: Code[20]; var TempImportedLine: Record "BCDA Correction Line" temporary): Integer
    var
        CorrectionLine: Record "BCDA Correction Line";
        ImportedCount: Integer;
    begin
        CorrectionLine.SetRange("Request ID", RequestID);
        CorrectionLine.DeleteAll(true);

        TempImportedLine.Reset();
        TempImportedLine.SetCurrentKey("Request ID", "Line No.");
        TempImportedLine.FindSet();
        repeat
            CorrectionLine := TempImportedLine;
            CorrectionLine.Insert(true);
            ImportedCount += 1;
        until TempImportedLine.Next() = 0;

        exit(ImportedCount);
    end;

    local procedure BuildTableList(RequestID: Code[20]; var TempTableLine: Record "BCDA Correction Line" temporary)
    var
        CorrectionLine: Record "BCDA Correction Line";
    begin
        TempTableLine.Reset();
        TempTableLine.DeleteAll();

        CorrectionLine.SetCurrentKey("Table ID", "Field ID");
        CorrectionLine.SetRange("Request ID", RequestID);
        if not CorrectionLine.FindSet() then
            exit;

        repeat
            TempTableLine.Reset();
            TempTableLine.SetRange("Table ID", CorrectionLine."Table ID");
            if TempTableLine.IsEmpty() then begin
                TempTableLine := CorrectionLine;
                TempTableLine.Insert();
            end;
        until CorrectionLine.Next() = 0;

        TempTableLine.Reset();
        TempTableLine.SetCurrentKey("Table ID", "Field ID");
    end;

    local procedure WriteTableSheet(var TempExcelBuffer: Record "Excel Buffer" temporary; CorrectionRequest: Record "BCDA Correction Request"; TableID: Integer; TableCaption: Text)
    var
        TempFieldMapping: Record Field temporary;
        TempGroupLine: Record "BCDA Correction Line" temporary;
    begin
        BuildFieldMapping(CorrectionRequest."Request ID", TableID, TempFieldMapping);
        BuildGroupList(CorrectionRequest."Request ID", TableID, TempGroupLine);

        WriteSheetIdentityRow(TempExcelBuffer, CorrectionRequest, TableID, TableCaption);
        TempExcelBuffer.NewRow();
        WriteMatrixHeaderRow(TempExcelBuffer, TempFieldMapping);
        WriteMatrixRows(TempExcelBuffer, CorrectionRequest."Request ID", TableID, TempFieldMapping, TempGroupLine);
    end;

    local procedure BuildFieldMapping(RequestID: Code[20]; TableID: Integer; var TempFieldMapping: Record Field temporary)
    var
        CorrectionLine: Record "BCDA Correction Line";
        ColumnNo: Integer;
    begin
        TempFieldMapping.Reset();
        TempFieldMapping.DeleteAll();

        CorrectionLine.SetCurrentKey("Request ID", Type, "Table ID", "Record ID", "Insert Group No.");
        CorrectionLine.SetRange("Request ID", RequestID);
        CorrectionLine.SetRange("Table ID", TableID);
        CorrectionLine.SetFilter("Field ID", '<>%1', 0);
        if not CorrectionLine.FindSet() then
            exit;

        repeat
            if not TempFieldMapping.Get(CorrectionLine."Table ID", CorrectionLine."Field ID") then begin
                ColumnNo += 1;
                TempFieldMapping.Init();
                TempFieldMapping.TableNo := CorrectionLine."Table ID";
                TempFieldMapping."No." := CorrectionLine."Field ID";
                TempFieldMapping.RelationFieldNo := ColumnNo;
                TempFieldMapping.Insert();
            end;
        until CorrectionLine.Next() = 0;

        TempFieldMapping.Reset();
        TempFieldMapping.SetCurrentKey(RelationFieldNo);
    end;

    local procedure BuildGroupList(RequestID: Code[20]; TableID: Integer; var TempGroupLine: Record "BCDA Correction Line" temporary)
    var
        CorrectionLine: Record "BCDA Correction Line";
    begin
        TempGroupLine.Reset();
        TempGroupLine.DeleteAll();

        CorrectionLine.SetCurrentKey("Request ID", Type, "Table ID", "Record ID", "Insert Group No.");
        CorrectionLine.SetRange("Request ID", RequestID);
        CorrectionLine.SetRange("Table ID", TableID);
        if not CorrectionLine.FindSet() then
            exit;

        repeat
            TempGroupLine.Reset();
            TempGroupLine.SetRange(Type, CorrectionLine.Type);
            TempGroupLine.SetRange("Record ID", CorrectionLine."Record ID");
            TempGroupLine.SetRange("Insert Group No.", CorrectionLine."Insert Group No.");
            if TempGroupLine.IsEmpty() then begin
                TempGroupLine := CorrectionLine;
                TempGroupLine.Insert();
            end;
        until CorrectionLine.Next() = 0;

        TempGroupLine.Reset();
        TempGroupLine.SetCurrentKey("Request ID", Type, "Table ID", "Record ID", "Insert Group No.");
    end;

    local procedure WriteSheetIdentityRow(var TempExcelBuffer: Record "Excel Buffer" temporary; CorrectionRequest: Record "BCDA Correction Request"; TableID: Integer; TableCaption: Text)
    begin
        TempExcelBuffer.NewRow();
        AddHeaderCell(TempExcelBuffer, CorrectionRequestNoTxt);
        AddTextCell(TempExcelBuffer, CorrectionRequest."Request ID");
        AddHeaderCell(TempExcelBuffer, TableNameTxt);
        AddTextCell(TempExcelBuffer, TableCaption);
        AddHeaderCell(TempExcelBuffer, TableIDTxt);
        AddTextCell(TempExcelBuffer, Format(TableID));
    end;

    local procedure WriteMatrixHeaderRow(var TempExcelBuffer: Record "Excel Buffer" temporary; var TempFieldMapping: Record Field temporary)
    begin
        TempExcelBuffer.NewRow();
        AddHeaderCell(TempExcelBuffer, ValueTypeTxt);
        AddHeaderCell(TempExcelBuffer, ModificationTypeTxt);
        AddHeaderCell(TempExcelBuffer, TargetRecordIdentityTxt);
        AddHeaderCell(TempExcelBuffer, InsertGroupNoTxt);

        TempFieldMapping.Reset();
        TempFieldMapping.SetCurrentKey(RelationFieldNo);
        if TempFieldMapping.FindSet() then
            repeat
                AddHeaderCell(TempExcelBuffer, GetFieldCaption(TempFieldMapping.TableNo, TempFieldMapping."No."));
            until TempFieldMapping.Next() = 0;
    end;

    local procedure WriteMatrixRows(var TempExcelBuffer: Record "Excel Buffer" temporary; RequestID: Code[20]; TableID: Integer; var TempFieldMapping: Record Field temporary; var TempGroupLine: Record "BCDA Correction Line" temporary)
    var
        TempLine: Record "BCDA Correction Line" temporary;
    begin
        TempGroupLine.Reset();
        if not TempGroupLine.FindSet() then
            exit;

        repeat
            LoadGroupLines(RequestID, TableID, TempGroupLine, TempLine);

            if TempGroupLine.Type <> TempGroupLine.Type::Insert then
                WriteMatrixRow(TempExcelBuffer, TempGroupLine, CurrentValueTypeTxt, TempFieldMapping, TempLine, false);

            if TempGroupLine.Type <> TempGroupLine.Type::Delete then
                WriteMatrixRow(TempExcelBuffer, TempGroupLine, NewValueTypeTxt, TempFieldMapping, TempLine, true);
        until TempGroupLine.Next() = 0;
    end;

    local procedure LoadGroupLines(RequestID: Code[20]; TableID: Integer; GroupLine: Record "BCDA Correction Line"; var TempLine: Record "BCDA Correction Line" temporary)
    var
        CorrectionLine: Record "BCDA Correction Line";
    begin
        TempLine.Reset();
        TempLine.DeleteAll();

        CorrectionLine.SetCurrentKey("Request ID", Type, "Table ID", "Record ID", "Insert Group No.");
        CorrectionLine.SetRange("Request ID", RequestID);
        CorrectionLine.SetRange("Table ID", TableID);
        CorrectionLine.SetRange(Type, GroupLine.Type);
        CorrectionLine.SetRange("Record ID", GroupLine."Record ID");
        CorrectionLine.SetRange("Insert Group No.", GroupLine."Insert Group No.");
        if not CorrectionLine.FindSet() then
            exit;

        repeat
            TempLine := CorrectionLine;
            TempLine.Insert();
        until CorrectionLine.Next() = 0;
    end;

    local procedure WriteMatrixRow(var TempExcelBuffer: Record "Excel Buffer" temporary; GroupLine: Record "BCDA Correction Line"; ValueType: Text; var TempFieldMapping: Record Field temporary; var TempLine: Record "BCDA Correction Line" temporary; UseProposedValue: Boolean)
    begin
        TempExcelBuffer.NewRow();
        AddTextCell(TempExcelBuffer, ValueType);
        AddTextCell(TempExcelBuffer, Format(GroupLine.Type));
        AddTextCell(TempExcelBuffer, Format(GroupLine."Record ID"));
        AddTextCell(TempExcelBuffer, FormatInsertGroupNo(GroupLine));

        TempFieldMapping.Reset();
        TempFieldMapping.SetCurrentKey(RelationFieldNo);
        if TempFieldMapping.FindSet() then
            repeat
                AddTextCell(TempExcelBuffer, GetLineValue(TempLine, TempFieldMapping."No.", UseProposedValue));
            until TempFieldMapping.Next() = 0;
    end;

    local procedure GetLineValue(var TempLine: Record "BCDA Correction Line" temporary; FieldID: Integer; UseProposedValue: Boolean): Text
    begin
        TempLine.Reset();
        TempLine.SetRange("Field ID", FieldID);
        if not TempLine.FindFirst() then
            exit('');

        if UseProposedValue then
            exit(TempLine."Proposed New Value");

        exit(TempLine."Current Value Preview");
    end;

    local procedure FormatInsertGroupNo(CorrectionLine: Record "BCDA Correction Line"): Text
    begin
        if CorrectionLine."Insert Group No." = 0 then
            exit('');

        exit(Format(CorrectionLine."Insert Group No."));
    end;

    local procedure GetTableCaption(TableID: Integer; FallbackName: Text): Text
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        if AllObjWithCaption.Get(AllObjWithCaption."Object Type"::Table, TableID) then
            if AllObjWithCaption."Object Caption" <> '' then
                exit(AllObjWithCaption."Object Caption");

        if FallbackName <> '' then
            exit(FallbackName);

        exit(StrSubstNo(TableFallbackNameTxt, TableID));
    end;

    local procedure GetFieldCaption(TableID: Integer; FieldID: Integer): Text
    var
        FieldMetadata: Record Field;
        FieldCaption: Text;
    begin
        if FieldMetadata.Get(TableID, FieldID) then begin
            FieldCaption := FieldMetadata."Field Caption";
            if FieldCaption = '' then
                FieldCaption := FieldMetadata.FieldName;

            exit(StrSubstNo(FieldCaptionWithIdTxt, FieldCaption, FieldID));
        end;

        exit(StrSubstNo(FieldFallbackNameTxt, FieldID));
    end;

    local procedure GetUniqueSheetName(TableCaption: Text; TableID: Integer; var SheetNames: List of [Text]) SheetName: Text[31]
    var
        BaseName: Text;
        CandidateName: Text;
        Suffix: Text;
        SuffixNo: Integer;
    begin
        BaseName := SanitizeSheetName(TableCaption);
        if BaseName = '' then
            BaseName := StrSubstNo(TableFallbackNameTxt, TableID);

        CandidateName := CopyStr(BaseName, 1, MaxSheetNameLength());
        if not SheetNames.Contains(CandidateName) then begin
            SheetNames.Add(CandidateName);
            exit(CopyStr(CandidateName, 1, MaxStrLen(SheetName)));
        end;

        SuffixNo := 2;
        repeat
            Suffix := StrSubstNo(SheetSuffixTxt, SuffixNo);
            CandidateName := CopyStr(BaseName, 1, MaxSheetNameLength() - StrLen(Suffix)) + Suffix;
            SuffixNo += 1;
        until not SheetNames.Contains(CandidateName);

        SheetNames.Add(CandidateName);
        exit(CopyStr(CandidateName, 1, MaxStrLen(SheetName)));
    end;

    local procedure SanitizeSheetName(SourceName: Text): Text
    var
        Character: Text[1];
        Index: Integer;
        SheetName: Text;
    begin
        for Index := 1 to StrLen(SourceName) do begin
            Character := CopyStr(SourceName, Index, 1);
            if StrPos(InvalidSheetNameCharsTxt, Character) = 0 then
                SheetName += Character
            else
                SheetName += ' ';
        end;

        exit(DelChr(SheetName, '<>', ' '));
    end;

    local procedure AddHeaderCell(var TempExcelBuffer: Record "Excel Buffer" temporary; Value: Text)
    begin
        TempExcelBuffer.AddColumn(Value, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure AddTextCell(var TempExcelBuffer: Record "Excel Buffer" temporary; Value: Text)
    begin
        TempExcelBuffer.AddColumn(Value, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure MaxSheetNameLength(): Integer
    begin
        exit(31);
    end;

    local procedure GetImportTableID(var TempExcelBuffer: Record "Excel Buffer" temporary): Integer
    var
        TableID: Integer;
        TableIDText: Text;
    begin
        TableIDText := GetCellText(TempExcelBuffer, 1, 6);
        if TableIDText = '' then
            exit(0);

        if not Evaluate(TableID, TableIDText) then
            Error(ImportTableIdErr, TableIDText);

        exit(TableID);
    end;

    local procedure GetMaxRowNo(var TempExcelBuffer: Record "Excel Buffer" temporary): Integer
    var
        MaxRowNo: Integer;
    begin
        MaxRowNo := 0;
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindSet() then
            repeat
                if TempExcelBuffer."Row No." > MaxRowNo then
                    MaxRowNo := TempExcelBuffer."Row No.";
            until TempExcelBuffer.Next() = 0;

        exit(MaxRowNo);
    end;

    local procedure GetMaxColumnNo(var TempExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer): Integer
    var
        MaxColumnNo: Integer;
    begin
        MaxColumnNo := 0;
        TempExcelBuffer.Reset();
        TempExcelBuffer.SetRange("Row No.", RowNo);
        if TempExcelBuffer.FindSet() then
            repeat
                if TempExcelBuffer."Column No." > MaxColumnNo then
                    MaxColumnNo := TempExcelBuffer."Column No.";
            until TempExcelBuffer.Next() = 0;

        exit(MaxColumnNo);
    end;

    local procedure GetCellText(var TempExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; ColumnNo: Integer): Text
    begin
        TempExcelBuffer.Reset();
        if TempExcelBuffer.Get(RowNo, ColumnNo) then
            exit(TempExcelBuffer."Cell Value as Text");

        exit('');
    end;

    local procedure ParseFieldID(HeaderText: Text): Integer
    var
        FieldID: Integer;
        Index: Integer;
        LastClosePosition: Integer;
        LastOpenPosition: Integer;
    begin
        if HeaderText = '' then
            exit(0);

        for Index := 1 to StrLen(HeaderText) do
            case CopyStr(HeaderText, Index, 1) of
                '(':
                    LastOpenPosition := Index;
                ')':
                    LastClosePosition := Index;
            end;

        if (LastOpenPosition = 0) or (LastClosePosition <= LastOpenPosition) then
            exit(0);

        if not Evaluate(FieldID, CopyStr(HeaderText, LastOpenPosition + 1, LastClosePosition - LastOpenPosition - 1)) then
            Error(ImportFieldHeaderErr, HeaderText);

        exit(FieldID);
    end;

    local procedure EnsureFieldExists(TableID: Integer; FieldID: Integer)
    var
        FieldMetadata: Record Field;
    begin
        if not FieldMetadata.Get(TableID, FieldID) then
            Error(ImportFieldNotFoundErr, FieldID, TableID);
    end;

    local procedure NormalizeText(Value: Text): Text
    begin
        exit(UpperCase(DelChr(Value, '<>', ' ')));
    end;

    local procedure ParseCorrectionType(TypeText: Text; RowNo: Integer): Enum "BCDA Correction Type"
    var
        CorrectionType: Enum "BCDA Correction Type";
    begin
        if not Evaluate(CorrectionType, TypeText) then
            Error(ImportCorrectionTypeErr, RowNo, TypeText);

        exit(CorrectionType);
    end;

    local procedure ParseRecordID(CorrectionType: Enum "BCDA Correction Type"; TableID: Integer; RecordIDText: Text; RowNo: Integer): RecordId
    var
        EmptyRecordID: RecordId;
        RecordID: RecordId;
    begin
        RecordIDText := DelChr(RecordIDText, '<>', ' ');

        if CorrectionType = CorrectionType::Insert then begin
            if RecordIDText <> '' then
                Error(ImportInsertRecordIdErr, RowNo);

            exit(EmptyRecordID);
        end;

        if RecordIDText = '' then
            Error(ImportRecordIdRequiredErr, RowNo);

        if not Evaluate(RecordID, RecordIDText) then
            Error(ImportRecordIdErr, RowNo, RecordIDText);

        if RecordID.TableNo() <> TableID then
            Error(ImportRecordIdTableMismatchErr, RowNo, RecordID, TableID);

        exit(RecordID);
    end;

    local procedure ParseInsertGroupNo(CorrectionType: Enum "BCDA Correction Type"; InsertGroupNoText: Text; RowNo: Integer): Integer
    var
        InsertGroupNo: Integer;
    begin
        InsertGroupNoText := DelChr(InsertGroupNoText, '<>', ' ');

        if CorrectionType <> CorrectionType::Insert then begin
            if InsertGroupNoText <> '' then
                Error(ImportInsertGroupOnlyForInsertErr, RowNo);

            exit(0);
        end;

        if InsertGroupNoText = '' then
            Error(ImportInsertGroupRequiredErr, RowNo);

        if not Evaluate(InsertGroupNo, InsertGroupNoText) then
            Error(ImportInsertGroupNoErr, RowNo, InsertGroupNoText);

        if InsertGroupNo <= 0 then
            Error(ImportInsertGroupNoErr, RowNo, InsertGroupNoText);

        exit(InsertGroupNo);
    end;

    local procedure GetCurrentValue(var TempCurrentLine: Record "BCDA Correction Line" temporary; CorrectionType: Enum "BCDA Correction Type"; RecordID: RecordId; InsertGroupNo: Integer; FieldID: Integer): Text
    begin
        TempCurrentLine.Reset();
        TempCurrentLine.SetRange(Type, CorrectionType);
        TempCurrentLine.SetRange("Record ID", RecordID);
        TempCurrentLine.SetRange("Insert Group No.", InsertGroupNo);
        TempCurrentLine.SetRange("Field ID", FieldID);
        if TempCurrentLine.FindFirst() then
            exit(TempCurrentLine."Current Value Preview");

        exit('');
    end;

    local procedure ShouldImportValueLine(CorrectionType: Enum "BCDA Correction Type"; CurrentValue: Text; ProposedValue: Text): Boolean
    begin
        if CorrectionType = CorrectionType::Insert then
            exit(ProposedValue <> '');

        if ProposedValue <> '' then
            exit(true);

        exit(CurrentValue <> '');
    end;

    local procedure GetNextTempLineNo(var TempLine: Record "BCDA Correction Line" temporary): Integer
    begin
        TempLine.Reset();
        if TempLine.FindLast() then
            exit(TempLine."Line No." + 10000);

        exit(10000);
    end;

    var
        CorrectionRequestNoTxt: Label 'Correction Request No.';
        CurrentValueTypeTxt: Label 'Current';
        ExportNotEnabledErr: Label 'Export is disabled in BCDA Setup.';
        ExcelFileFilterTxt: Label 'Excel Workbook (*.xlsx)|*.xlsx';
        FieldCaptionWithIdTxt: Label '%1 (%2)', Comment = '%1 = field caption, %2 = field ID';
        FieldFallbackNameTxt: Label 'Field %1', Comment = '%1 = field ID';
        ImportCorrectionTypeErr: Label 'Excel row %1 has unsupported modification type %2.', Comment = '%1 = Excel row number, %2 = modification type';
        ImportDeleteNewRowErr: Label 'Excel row %1 is a Delete new-value row. Delete imports must use only a Current row for each target record.', Comment = '%1 = Excel row number';
        ImportExcelDialogTitleTxt: Label 'Import BCDA correction request workbook';
        ImportFieldHeaderErr: Label 'Excel field header %1 must include a numeric field ID in parentheses.', Comment = '%1 = field header text';
        ImportFieldNotFoundErr: Label 'Field %1 was not found for table %2 in the Excel workbook.', Comment = '%1 = field ID, %2 = table ID';
        ImportInsertCurrentRowErr: Label 'Excel row %1 is an Insert current-value row. Insert imports must use only a New row for each insert group.', Comment = '%1 = Excel row number';
        ImportInsertGroupNoErr: Label 'Excel row %1 has invalid Insert Group No. %2. Insert group numbers must be positive integers.', Comment = '%1 = Excel row number, %2 = insert group no.';
        ImportInsertGroupOnlyForInsertErr: Label 'Excel row %1 has an Insert Group No. but is not an Insert row.', Comment = '%1 = Excel row number';
        ImportInsertGroupRequiredErr: Label 'Excel row %1 is an Insert row and must include an Insert Group No.', Comment = '%1 = Excel row number';
        ImportInsertRecordIdErr: Label 'Excel row %1 is an Insert row and must leave Target Record Identity blank.', Comment = '%1 = Excel row number';
        ImportNoFieldHeadersErr: Label 'Excel row %1 cannot be imported because the worksheet has no requested field headers on row 3.', Comment = '%1 = Excel row number';
        ImportOpenOnlyErr: Label 'Import from Excel is available only while the correction request status is Open.';
        ImportRecordIdErr: Label 'Excel row %1 has invalid target record identity %2.', Comment = '%1 = Excel row number, %2 = target record identity';
        ImportRecordIdRequiredErr: Label 'Excel row %1 must include Target Record Identity for Update, Rename, and Delete rows.', Comment = '%1 = Excel row number';
        ImportRecordIdTableMismatchErr: Label 'Excel row %1 target record identity %2 does not belong to table %3.', Comment = '%1 = Excel row number, %2 = target record identity, %3 = table ID';
        ImportRequestIdMismatchErr: Label 'The Excel workbook belongs to correction request %1, but the current request is %2.', Comment = '%1 = workbook request ID, %2 = current request ID';
        ImportTableIdErr: Label 'Excel worksheet table ID %1 is not valid.', Comment = '%1 = table ID text';
        ImportValueTypeErr: Label 'Excel row %1 has unsupported value type %2. Use Current or New.', Comment = '%1 = Excel row number, %2 = value type';
        InsertGroupNoTxt: Label 'Insert Group No.';
        InvalidSheetNameCharsTxt: Label ':/\?*[]';
        ModificationTypeTxt: Label 'Modification Type';
        NewValueTypeTxt: Label 'New';
        NoCorrectionLinesErr: Label 'No correction lines are available to export.';
        NoImportLinesErr: Label 'The selected Excel workbook did not contain any correction request lines to import.';
        NoWorksheetsErr: Label 'The selected Excel workbook does not contain any worksheets.';
        RequestExportedMsg: Label 'Correction request Excel export completed.';
        RequestExportFileNameTxt: Label 'BCDA-Request-%1', Comment = '%1 = request ID';
        RequestIdRequiredBeforeImportErr: Label 'Save the correction request before importing correction lines from Excel.';
        RequestIdRequiredErr: Label 'Save the correction request before exporting it to Excel.';
        RequestImportedMsg: Label '%1 correction request lines were imported from Excel.', Comment = '%1 = imported line count';
        SheetSuffixTxt: Label ' (%1)', Comment = '%1 = duplicate sheet counter';
        TableFallbackNameTxt: Label 'Table %1', Comment = '%1 = table ID';
        TableIDTxt: Label 'Table ID';
        TableNameTxt: Label 'Table Name';
        TargetRecordIdentityTxt: Label 'Target Record Identity';
        ValueTypeTxt: Label 'Value Type';
}
