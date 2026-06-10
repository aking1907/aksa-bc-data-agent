namespace AKSA.BCDataAgent;

using System.Reflection;

codeunit 88127 "BCDA Metadata Explorer"
{
    Access = Internal;

    procedure IsFoundationObjectId(ObjectId: Integer): Boolean
    begin
        exit((ObjectId >= 88100) and (ObjectId <= 88149));
    end;

    procedure EnsureTargetTableAllowed(TableId: Integer)
    begin
        if TableId = 0 then
            exit;

        if IsFoundationObjectId(TableId) then
            Error(AppOwnedTableBlockedErr, TableId);
    end;

    procedure ResolveTableCaption(TableId: Integer; var TableName: Text[250])
    var
        AllObjWithCaption: Record AllObjWithCaption;
        ResolvedName: Text;
    begin
        Clear(TableName);
        if TableId = 0 then
            exit;

        EnsureTargetTableAllowed(TableId);

        AllObjWithCaption.SetRange("Object Type", AllObjWithCaption."Object Type"::Table);
        AllObjWithCaption.SetRange("Object ID", TableId);
        if not AllObjWithCaption.FindFirst() then
            Error(TableNotFoundErr, TableId);

        ResolvedName := AllObjWithCaption."Object Caption";
        if ResolvedName = '' then
            ResolvedName := AllObjWithCaption."Object Name";

        TableName := CopyStr(ResolvedName, 1, MaxStrLen(TableName));
    end;

    procedure ResolveFieldCaption(TableId: Integer; FieldId: Integer; var TableName: Text[250]; var FieldName: Text[250])
    var
        FieldMetadata: Record "Field";
        ResolvedName: Text;
    begin
        Clear(FieldName);
        if FieldId = 0 then
            exit;

        if TableId = 0 then
            Error(TableRequiredBeforeFieldErr);

        ResolveTableCaption(TableId, TableName);
        if not FieldMetadata.Get(TableId, FieldId) then
            Error(FieldNotFoundErr, FieldId, TableId);

        if not FieldMetadata.Enabled then
            Error(FieldDisabledErr, FieldId, TableId);

        if FieldMetadata.Class <> FieldMetadata.Class::Normal then
            Error(FieldNotNormalErr, FieldId, TableId);

        ResolvedName := FieldMetadata."Field Caption";
        if ResolvedName = '' then
            ResolvedName := FieldMetadata.FieldName;

        FieldName := CopyStr(ResolvedName, 1, MaxStrLen(FieldName));
    end;

    procedure EnsureTargetDiscoveryReady()
    begin
        Error(TargetDiscoveryBlockedErr);
    end;

    var
        FieldDisabledErr: Label 'Field %1 on table %2 is disabled and cannot be selected for a correction line.', Comment = '%1 = field ID, %2 = table ID';
        FieldNotFoundErr: Label 'Field %1 was not found for table %2.', Comment = '%1 = field ID, %2 = table ID';
        FieldNotNormalErr: Label 'Field %1 on table %2 is not a normal stored field and cannot be selected for a correction line.', Comment = '%1 = field ID, %2 = table ID';
        AppOwnedTableBlockedErr: Label 'Table %1 is owned by BC Data Agent and cannot be selected as a correction target or policy target.', Comment = '%1 = table ID';
        TableNotFoundErr: Label 'Table %1 was not found in Business Central metadata.', Comment = '%1 = table ID';
        TableRequiredBeforeFieldErr: Label 'Select a table before selecting a field.';
        TargetDiscoveryBlockedErr: Label 'Target metadata discovery is not available for this action yet. Use the supported table, field, and record lookup actions.';
}
