namespace AKSA.BCDataAgent;

using System.DataAdministration;

codeunit 88126 "BCDA Retention Manager"
{
    Access = Internal;

    procedure RegisterRetentionTables()
    var
        AuditEntry: Record "BCDA Audit Entry";
        RetentionLog: Record "BCDA Retention Log";
        ValueSnapshot: Record "BCDA Value Snapshot";
        AccessMgt: Codeunit "BCDA Access Mgt.";
        RetenPolAllowedTables: Codeunit "Reten. Pol. Allowed Tables";
    begin
        AccessMgt.EnsureSuperUser();

        RetenPolAllowedTables.AddAllowedTable(Database::"BCDA Audit Entry", AuditEntry.FieldNo("Occurred At"));
        RetenPolAllowedTables.AddAllowedTable(Database::"BCDA Value Snapshot", ValueSnapshot.FieldNo("Expires At"));
        RetenPolAllowedTables.AddAllowedTable(Database::"BCDA Retention Log", RetentionLog.FieldNo("Created At"));
    end;
}
