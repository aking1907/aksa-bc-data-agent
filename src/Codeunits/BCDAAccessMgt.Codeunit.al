namespace AKSA.BCDataAgent;

using System.Security.User;

codeunit 88120 "BCDA Access Mgt."
{
    Access = Internal;

    procedure IsSuperUser(): Boolean
    var
        UserPermissions: Codeunit "User Permissions";
    begin
        exit(UserPermissions.IsSuper(UserSecurityId()));
    end;

    procedure EnsureSuperUser()
    begin
        if not IsSuperUser() then
            Error(NotSuperUserErr);
    end;

    var
        NotSuperUserErr: Label 'BC Data Agent is available only to users with the SUPER permission set.';
}
