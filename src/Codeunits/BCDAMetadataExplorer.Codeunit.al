namespace AKSA.BCDataAgent;

codeunit 88127 "BCDA Metadata Explorer"
{
    Access = Internal;

    procedure IsFoundationObjectId(ObjectId: Integer): Boolean
    begin
        exit((ObjectId >= 88100) and (ObjectId <= 88149));
    end;

    procedure EnsureTargetDiscoveryReady()
    begin
        Error(TargetDiscoveryBlockedErr);
    end;

    var
        TargetDiscoveryBlockedErr: Label 'Target metadata discovery is blocked until sandbox behavior is verified for the next readiness gate.';
}
