namespace AKSA.BCDataAgent;

using System.Utilities;

codeunit 88133 "BCDA Audit Export Mgt."
{
    Access = Internal;

    procedure ExportFilteredAuditMetadata(var SourceAuditEntry: Record "BCDA Audit Entry")
    var
        AuditEntry: Record "BCDA Audit Entry";
        Setup: Record "BCDA Setup";
        AccessMgt: Codeunit "BCDA Access Mgt.";
        SetupMgt: Codeunit "BCDA Setup Mgt.";
        TempBlob: Codeunit "Temp Blob";
        AuditInStream: InStream;
        AuditOutStream: OutStream;
        FileName: Text;
        ExportedCount: Integer;
    begin
        AccessMgt.EnsureSuperUser();
        SetupMgt.GetSetup(Setup);

        if not Setup."Export Enabled" then begin
            WriteExportAudit("BCDA Audit Result"::Blocked, ExportNotEnabledErr);
            Error(ExportNotEnabledErr);
        end;

        AuditEntry.CopyFilters(SourceAuditEntry);
        if not HasRequiredFilter(AuditEntry) then begin
            WriteExportAudit("BCDA Audit Result"::Blocked, ExportRequiresFilterErr);
            Error(ExportRequiresFilterErr);
        end;

        TempBlob.CreateOutStream(AuditOutStream, TextEncoding::UTF8);
        WriteHeader(AuditOutStream);

        if AuditEntry.FindSet() then
            repeat
                WriteAuditEntry(AuditOutStream, AuditEntry);
                ExportedCount += 1;
            until AuditEntry.Next() = 0;

        if ExportedCount = 0 then begin
            WriteExportAudit("BCDA Audit Result"::Warning, NoAuditEntriesToExportErr);
            Error(NoAuditEntriesToExportErr);
        end;

        TempBlob.CreateInStream(AuditInStream, TextEncoding::UTF8);
        FileName := StrSubstNo(AuditExportFileNameTxt, Format(Today(), 0, '<Year4><Month,2><Day,2>'));
        WriteExportAudit("BCDA Audit Result"::Success, CopyStr(StrSubstNo(AuditExportedMsg, ExportedCount), 1, 2048));
        DownloadFromStream(AuditInStream, AuditExportDialogTitleTxt, '', CsvFileFilterTxt, FileName);
    end;

    local procedure HasRequiredFilter(var AuditEntry: Record "BCDA Audit Entry"): Boolean
    begin
        exit(
            (AuditEntry.GetFilter("Request ID") <> '') or
            (AuditEntry.GetFilter("Company Name") <> '') or
            (AuditEntry.GetFilter("Occurred At") <> '') or
            (AuditEntry.GetFilter(Operation) <> '') or
            (AuditEntry.GetFilter(Result) <> ''));
    end;

    local procedure WriteHeader(var AuditOutStream: OutStream)
    begin
        WriteCsvLine(AuditOutStream,
            'Entry No.,Operation,Result,Request ID,Line No.,User ID,Occurred At,Company Name,Target Table ID,Target Table Name,Target Record Available,Target Field ID,Target Field Name,Reason,Ticket Reference,Rollback Available,Rollback Availability,Old Snapshot ID,New Snapshot ID,Error Code,Sanitized Error');
    end;

    local procedure WriteAuditEntry(var AuditOutStream: OutStream; AuditEntry: Record "BCDA Audit Entry")
    begin
        WriteCsvLine(AuditOutStream,
            CsvValue(Format(AuditEntry."Entry No.")) + ',' +
            CsvValue(Format(AuditEntry.Operation)) + ',' +
            CsvValue(Format(AuditEntry.Result)) + ',' +
            CsvValue(AuditEntry."Request ID") + ',' +
            CsvValue(Format(AuditEntry."Line No.")) + ',' +
            CsvValue(AuditEntry."User ID") + ',' +
            CsvValue(Format(AuditEntry."Occurred At")) + ',' +
            CsvValue(AuditEntry."Company Name") + ',' +
            CsvValue(Format(AuditEntry."Target Table ID")) + ',' +
            CsvValue(AuditEntry."Target Table Name") + ',' +
            CsvValue(Format(Format(AuditEntry."Target Record ID") <> '')) + ',' +
            CsvValue(Format(AuditEntry."Target Field ID")) + ',' +
            CsvValue(AuditEntry."Target Field Name") + ',' +
            CsvValue(AuditEntry.Reason) + ',' +
            CsvValue(AuditEntry."Ticket Reference") + ',' +
            CsvValue(Format(AuditEntry."Rollback Available")) + ',' +
            CsvValue(AuditEntry."Rollback Availability") + ',' +
            CsvValue(Format(AuditEntry."Old Snapshot ID")) + ',' +
            CsvValue(Format(AuditEntry."New Snapshot ID")) + ',' +
            CsvValue(AuditEntry."Error Code") + ',' +
            CsvValue(AuditEntry."Sanitized Error"));
    end;

    local procedure WriteCsvLine(var AuditOutStream: OutStream; CsvLine: Text)
    begin
        AuditOutStream.WriteText(CsvLine);
        AuditOutStream.WriteText();
    end;

    local procedure CsvValue(Value: Text): Text
    var
        Index: Integer;
        Result: Text;
    begin
        for Index := 1 to StrLen(Value) do
            if CopyStr(Value, Index, 1) = '"' then
                Result += '""'
            else
                Result += CopyStr(Value, Index, 1);

        exit('"' + Result + '"');
    end;

    local procedure WriteExportAudit(Result: Enum "BCDA Audit Result"; SanitizedMessage: Text[2048])
    var
        AuditEntry: Record "BCDA Audit Entry";
    begin
        AuditEntry.Init();
        AuditEntry.Operation := AuditEntry.Operation::"Audit Export";
        AuditEntry.Result := Result;
        AuditEntry."Sanitized Error" := SanitizedMessage;
        AuditEntry.Insert(true);
    end;

    var
        ExportNotEnabledErr: Label 'Audit export is disabled in BCDA Setup.';
        ExportRequiresFilterErr: Label 'Apply at least one filter before export: Request ID, Company Name, Occurred At, Operation, or Result.';
        NoAuditEntriesToExportErr: Label 'No audit entries match the current export filters.';
        AuditExportedMsg: Label 'Filtered audit metadata export completed for %1 entries.', Comment = '%1 = exported audit entry count';
        AuditExportDialogTitleTxt: Label 'Export BCDA Audit Metadata';
        AuditExportFileNameTxt: Label 'BCDA-Audit-%1.csv', Comment = '%1 = export date';
        CsvFileFilterTxt: Label 'CSV files (*.csv)|*.csv';
}
