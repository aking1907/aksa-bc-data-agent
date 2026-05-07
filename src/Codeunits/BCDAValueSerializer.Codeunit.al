namespace AKSA.BCDataAgent;

codeunit 88124 "BCDA Value Serializer"
{
    Access = Internal;

    procedure CreateTextSnapshot(RequestId: Code[20]; LineNo: Integer; ValueText: Text[2048]; ValueType: Text[50]; ExpiresAt: DateTime): Guid
    var
        ValueSnapshot: Record "BCDA Value Snapshot";
    begin
        ValueSnapshot.Init();
        ValueSnapshot."Request ID" := RequestId;
        ValueSnapshot."Line No." := LineNo;
        ValueSnapshot."Value Type" := ValueType;
        ValueSnapshot."Serialized Value" := ValueText;
        ValueSnapshot."Display Value" := ValueText;
        ValueSnapshot."Redaction Level" := 'SUPER';
        ValueSnapshot."Expires At" := ExpiresAt;
        ValueSnapshot.Insert(true);

        exit(ValueSnapshot."Snapshot ID");
    end;

    procedure GetRedactedDisplayValue(ValueText: Text): Text
    begin
        if ValueText = '' then
            exit('');

        exit(RedactedValueTxt);
    end;

    var
        RedactedValueTxt: Label '[redacted]';
}
