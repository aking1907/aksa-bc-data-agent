namespace AKSA.BCDataAgent;

using System.Reflection;

page 88141 "BCDA Field Lookup"
{
    ApplicationArea = All;
    Caption = 'BCDA Field Lookup';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Field";
    SourceTableView = sorting(TableNo, "No.") where(Enabled = const(true), Class = const(Normal));
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(Fields)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the field ID.';
                }
                field("Field Caption"; Rec."Field Caption")
                {
                    ToolTip = 'Specifies the field caption.';
                }
                field(FieldName; Rec.FieldName)
                {
                    ToolTip = 'Specifies the field name.';
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the field data type.';
                }
                field(TableNo; Rec.TableNo)
                {
                    ToolTip = 'Specifies the table ID that contains this field.';
                }
                field(TableName; Rec.TableName)
                {
                    ToolTip = 'Specifies the table name that contains this field.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        AccessMgt: Codeunit "BCDA Access Mgt.";
    begin
        AccessMgt.EnsureSuperUser();
    end;
}
