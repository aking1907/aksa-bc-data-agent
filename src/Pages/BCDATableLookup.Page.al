namespace AKSA.BCDataAgent;

using System.Reflection;

page 88140 "BCDA Table Lookup"
{
    ApplicationArea = All;
    Caption = 'BCDA Table Lookup';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = AllObjWithCaption;
    SourceTableView = sorting("Object Type", "Object ID") where("Object Type" = const(Table));
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(Tables)
            {
                field("Object ID"; Rec."Object ID")
                {
                    ToolTip = 'Specifies the table ID.';
                }
                field("Object Caption"; Rec."Object Caption")
                {
                    ToolTip = 'Specifies the table caption.';
                }
                field("Object Name"; Rec."Object Name")
                {
                    ToolTip = 'Specifies the table object name.';
                }
                field("AL Namespace"; Rec."AL Namespace")
                {
                    ToolTip = 'Specifies the table AL namespace.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        AccessMgt: Codeunit "BCDA Access Mgt.";
    begin
        AccessMgt.EnsureSuperUser();
        Rec.SetFilter("Object ID", '<%1|>%2', 88100, 88149);
    end;
}
