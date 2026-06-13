namespace AKSA.BCDataAgent;
using System.Reflection;

page 88119 "BCDA Preview Data Matrix"
{
    ApplicationArea = All;
    Caption = 'BCDA Preview Data Matrix';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "BCDA Preview Data Matrix";
    SourceTableTemporary = true;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(Matrix)
            {
                field(Type; Rec.Type) { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies whether the row is a heading, current value, or new value row.'; }
                field("Correction Type"; Rec."Correction Type") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the staged correction operation type.'; }
                field("Table ID"; Rec."Table ID") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target table ID.'; Visible = false; }
                field("Record ID"; Format(Rec."Record ID")) { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target record identity.'; Caption = 'Record ID'; }
                field("Insert Group No."; Rec."Insert Group No.") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the Insert group used to create one new record from staged fields.'; Visible = InsertGroupNoVisible; }
                field("Field 1 Id"; Rec."Field 1 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 1 Value"; Rec."Field 1 Value") { ApplicationArea = All; Editable = Field1Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field1Visible; }
                field("Field 2 Id"; Rec."Field 2 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 2 Value"; Rec."Field 2 Value") { ApplicationArea = All; Editable = Field2Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field2Visible; }
                field("Field 3 Id"; Rec."Field 3 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 3 Value"; Rec."Field 3 Value") { ApplicationArea = All; Editable = Field3Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field3Visible; }
                field("Field 4 Id"; Rec."Field 4 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 4 Value"; Rec."Field 4 Value") { ApplicationArea = All; Editable = Field4Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field4Visible; }
                field("Field 5 Id"; Rec."Field 5 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 5 Value"; Rec."Field 5 Value") { ApplicationArea = All; Editable = Field5Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field5Visible; }
                field("Field 6 Id"; Rec."Field 6 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 6 Value"; Rec."Field 6 Value") { ApplicationArea = All; Editable = Field6Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field6Visible; }
                field("Field 7 Id"; Rec."Field 7 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 7 Value"; Rec."Field 7 Value") { ApplicationArea = All; Editable = Field7Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field7Visible; }
                field("Field 8 Id"; Rec."Field 8 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 8 Value"; Rec."Field 8 Value") { ApplicationArea = All; Editable = Field8Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field8Visible; }
                field("Field 9 Id"; Rec."Field 9 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 9 Value"; Rec."Field 9 Value") { ApplicationArea = All; Editable = Field9Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field9Visible; }
                field("Field 10 Id"; Rec."Field 10 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 10 Value"; Rec."Field 10 Value") { ApplicationArea = All; Editable = Field10Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field10Visible; }
                field("Field 11 Id"; Rec."Field 11 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 11 Value"; Rec."Field 11 Value") { ApplicationArea = All; Editable = Field11Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field11Visible; }
                field("Field 12 Id"; Rec."Field 12 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 12 Value"; Rec."Field 12 Value") { ApplicationArea = All; Editable = Field12Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field12Visible; }
                field("Field 13 Id"; Rec."Field 13 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 13 Value"; Rec."Field 13 Value") { ApplicationArea = All; Editable = Field13Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field13Visible; }
                field("Field 14 Id"; Rec."Field 14 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 14 Value"; Rec."Field 14 Value") { ApplicationArea = All; Editable = Field14Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field14Visible; }
                field("Field 15 Id"; Rec."Field 15 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 15 Value"; Rec."Field 15 Value") { ApplicationArea = All; Editable = Field15Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field15Visible; }
                field("Field 16 Id"; Rec."Field 16 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 16 Value"; Rec."Field 16 Value") { ApplicationArea = All; Editable = Field16Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field16Visible; }
                field("Field 17 Id"; Rec."Field 17 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 17 Value"; Rec."Field 17 Value") { ApplicationArea = All; Editable = Field17Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field17Visible; }
                field("Field 18 Id"; Rec."Field 18 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 18 Value"; Rec."Field 18 Value") { ApplicationArea = All; Editable = Field18Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field18Visible; }
                field("Field 19 Id"; Rec."Field 19 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 19 Value"; Rec."Field 19 Value") { ApplicationArea = All; Editable = Field19Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field19Visible; }
                field("Field 20 Id"; Rec."Field 20 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 20 Value"; Rec."Field 20 Value") { ApplicationArea = All; Editable = Field20Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field20Visible; }
                field("Field 21 Id"; Rec."Field 21 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 21 Value"; Rec."Field 21 Value") { ApplicationArea = All; Editable = Field21Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field21Visible; }
                field("Field 22 Id"; Rec."Field 22 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 22 Value"; Rec."Field 22 Value") { ApplicationArea = All; Editable = Field22Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field22Visible; }
                field("Field 23 Id"; Rec."Field 23 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 23 Value"; Rec."Field 23 Value") { ApplicationArea = All; Editable = Field23Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field23Visible; }
                field("Field 24 Id"; Rec."Field 24 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 24 Value"; Rec."Field 24 Value") { ApplicationArea = All; Editable = Field24Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field24Visible; }
                field("Field 25 Id"; Rec."Field 25 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 25 Value"; Rec."Field 25 Value") { ApplicationArea = All; Editable = Field25Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field25Visible; }
                field("Field 26 Id"; Rec."Field 26 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 26 Value"; Rec."Field 26 Value") { ApplicationArea = All; Editable = Field26Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field26Visible; }
                field("Field 27 Id"; Rec."Field 27 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 27 Value"; Rec."Field 27 Value") { ApplicationArea = All; Editable = Field27Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field27Visible; }
                field("Field 28 Id"; Rec."Field 28 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 28 Value"; Rec."Field 28 Value") { ApplicationArea = All; Editable = Field28Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field28Visible; }
                field("Field 29 Id"; Rec."Field 29 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 29 Value"; Rec."Field 29 Value") { ApplicationArea = All; Editable = Field29Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field29Visible; }
                field("Field 30 Id"; Rec."Field 30 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 30 Value"; Rec."Field 30 Value") { ApplicationArea = All; Editable = Field30Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field30Visible; }
                field("Field 31 Id"; Rec."Field 31 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 31 Value"; Rec."Field 31 Value") { ApplicationArea = All; Editable = Field31Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field31Visible; }
                field("Field 32 Id"; Rec."Field 32 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 32 Value"; Rec."Field 32 Value") { ApplicationArea = All; Editable = Field32Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field32Visible; }
                field("Field 33 Id"; Rec."Field 33 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 33 Value"; Rec."Field 33 Value") { ApplicationArea = All; Editable = Field33Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field33Visible; }
                field("Field 34 Id"; Rec."Field 34 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 34 Value"; Rec."Field 34 Value") { ApplicationArea = All; Editable = Field34Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field34Visible; }
                field("Field 35 Id"; Rec."Field 35 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 35 Value"; Rec."Field 35 Value") { ApplicationArea = All; Editable = Field35Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field35Visible; }
                field("Field 36 Id"; Rec."Field 36 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 36 Value"; Rec."Field 36 Value") { ApplicationArea = All; Editable = Field36Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field36Visible; }
                field("Field 37 Id"; Rec."Field 37 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 37 Value"; Rec."Field 37 Value") { ApplicationArea = All; Editable = Field37Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field37Visible; }
                field("Field 38 Id"; Rec."Field 38 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 38 Value"; Rec."Field 38 Value") { ApplicationArea = All; Editable = Field38Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field38Visible; }
                field("Field 39 Id"; Rec."Field 39 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 39 Value"; Rec."Field 39 Value") { ApplicationArea = All; Editable = Field39Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field39Visible; }
                field("Field 40 Id"; Rec."Field 40 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 40 Value"; Rec."Field 40 Value") { ApplicationArea = All; Editable = Field40Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field40Visible; }
                field("Field 41 Id"; Rec."Field 41 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 41 Value"; Rec."Field 41 Value") { ApplicationArea = All; Editable = Field41Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field41Visible; }
                field("Field 42 Id"; Rec."Field 42 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 42 Value"; Rec."Field 42 Value") { ApplicationArea = All; Editable = Field42Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field42Visible; }
                field("Field 43 Id"; Rec."Field 43 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 43 Value"; Rec."Field 43 Value") { ApplicationArea = All; Editable = Field43Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field43Visible; }
                field("Field 44 Id"; Rec."Field 44 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 44 Value"; Rec."Field 44 Value") { ApplicationArea = All; Editable = Field44Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field44Visible; }
                field("Field 45 Id"; Rec."Field 45 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 45 Value"; Rec."Field 45 Value") { ApplicationArea = All; Editable = Field45Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field45Visible; }
                field("Field 46 Id"; Rec."Field 46 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 46 Value"; Rec."Field 46 Value") { ApplicationArea = All; Editable = Field46Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field46Visible; }
                field("Field 47 Id"; Rec."Field 47 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 47 Value"; Rec."Field 47 Value") { ApplicationArea = All; Editable = Field47Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field47Visible; }
                field("Field 48 Id"; Rec."Field 48 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 48 Value"; Rec."Field 48 Value") { ApplicationArea = All; Editable = Field48Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field48Visible; }
                field("Field 49 Id"; Rec."Field 49 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 49 Value"; Rec."Field 49 Value") { ApplicationArea = All; Editable = Field49Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field49Visible; }
                field("Field 50 Id"; Rec."Field 50 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 50 Value"; Rec."Field 50 Value") { ApplicationArea = All; Editable = Field50Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field50Visible; }
                field("Field 51 Id"; Rec."Field 51 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 51 Value"; Rec."Field 51 Value") { ApplicationArea = All; Editable = Field51Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field51Visible; }
                field("Field 52 Id"; Rec."Field 52 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 52 Value"; Rec."Field 52 Value") { ApplicationArea = All; Editable = Field52Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field52Visible; }
                field("Field 53 Id"; Rec."Field 53 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 53 Value"; Rec."Field 53 Value") { ApplicationArea = All; Editable = Field53Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field53Visible; }
                field("Field 54 Id"; Rec."Field 54 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 54 Value"; Rec."Field 54 Value") { ApplicationArea = All; Editable = Field54Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field54Visible; }
                field("Field 55 Id"; Rec."Field 55 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 55 Value"; Rec."Field 55 Value") { ApplicationArea = All; Editable = Field55Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field55Visible; }
                field("Field 56 Id"; Rec."Field 56 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 56 Value"; Rec."Field 56 Value") { ApplicationArea = All; Editable = Field56Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field56Visible; }
                field("Field 57 Id"; Rec."Field 57 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 57 Value"; Rec."Field 57 Value") { ApplicationArea = All; Editable = Field57Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field57Visible; }
                field("Field 58 Id"; Rec."Field 58 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 58 Value"; Rec."Field 58 Value") { ApplicationArea = All; Editable = Field58Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field58Visible; }
                field("Field 59 Id"; Rec."Field 59 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 59 Value"; Rec."Field 59 Value") { ApplicationArea = All; Editable = Field59Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field59Visible; }
                field("Field 60 Id"; Rec."Field 60 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 60 Value"; Rec."Field 60 Value") { ApplicationArea = All; Editable = Field60Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field60Visible; }
                field("Field 61 Id"; Rec."Field 61 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 61 Value"; Rec."Field 61 Value") { ApplicationArea = All; Editable = Field61Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field61Visible; }
                field("Field 62 Id"; Rec."Field 62 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 62 Value"; Rec."Field 62 Value") { ApplicationArea = All; Editable = Field62Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field62Visible; }
                field("Field 63 Id"; Rec."Field 63 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 63 Value"; Rec."Field 63 Value") { ApplicationArea = All; Editable = Field63Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field63Visible; }
                field("Field 64 Id"; Rec."Field 64 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 64 Value"; Rec."Field 64 Value") { ApplicationArea = All; Editable = Field64Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field64Visible; }
                field("Field 65 Id"; Rec."Field 65 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 65 Value"; Rec."Field 65 Value") { ApplicationArea = All; Editable = Field65Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field65Visible; }
                field("Field 66 Id"; Rec."Field 66 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 66 Value"; Rec."Field 66 Value") { ApplicationArea = All; Editable = Field66Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field66Visible; }
                field("Field 67 Id"; Rec."Field 67 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 67 Value"; Rec."Field 67 Value") { ApplicationArea = All; Editable = Field67Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field67Visible; }
                field("Field 68 Id"; Rec."Field 68 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 68 Value"; Rec."Field 68 Value") { ApplicationArea = All; Editable = Field68Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field68Visible; }
                field("Field 69 Id"; Rec."Field 69 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 69 Value"; Rec."Field 69 Value") { ApplicationArea = All; Editable = Field69Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field69Visible; }
                field("Field 70 Id"; Rec."Field 70 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 70 Value"; Rec."Field 70 Value") { ApplicationArea = All; Editable = Field70Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field70Visible; }
                field("Field 71 Id"; Rec."Field 71 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 71 Value"; Rec."Field 71 Value") { ApplicationArea = All; Editable = Field71Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field71Visible; }
                field("Field 72 Id"; Rec."Field 72 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 72 Value"; Rec."Field 72 Value") { ApplicationArea = All; Editable = Field72Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field72Visible; }
                field("Field 73 Id"; Rec."Field 73 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 73 Value"; Rec."Field 73 Value") { ApplicationArea = All; Editable = Field73Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field73Visible; }
                field("Field 74 Id"; Rec."Field 74 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 74 Value"; Rec."Field 74 Value") { ApplicationArea = All; Editable = Field74Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field74Visible; }
                field("Field 75 Id"; Rec."Field 75 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 75 Value"; Rec."Field 75 Value") { ApplicationArea = All; Editable = Field75Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field75Visible; }
                field("Field 76 Id"; Rec."Field 76 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 76 Value"; Rec."Field 76 Value") { ApplicationArea = All; Editable = Field76Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field76Visible; }
                field("Field 77 Id"; Rec."Field 77 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 77 Value"; Rec."Field 77 Value") { ApplicationArea = All; Editable = Field77Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field77Visible; }
                field("Field 78 Id"; Rec."Field 78 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 78 Value"; Rec."Field 78 Value") { ApplicationArea = All; Editable = Field78Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field78Visible; }
                field("Field 79 Id"; Rec."Field 79 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 79 Value"; Rec."Field 79 Value") { ApplicationArea = All; Editable = Field79Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field79Visible; }
                field("Field 80 Id"; Rec."Field 80 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 80 Value"; Rec."Field 80 Value") { ApplicationArea = All; Editable = Field80Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field80Visible; }
                field("Field 81 Id"; Rec."Field 81 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 81 Value"; Rec."Field 81 Value") { ApplicationArea = All; Editable = Field81Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field81Visible; }
                field("Field 82 Id"; Rec."Field 82 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 82 Value"; Rec."Field 82 Value") { ApplicationArea = All; Editable = Field82Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field82Visible; }
                field("Field 83 Id"; Rec."Field 83 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 83 Value"; Rec."Field 83 Value") { ApplicationArea = All; Editable = Field83Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field83Visible; }
                field("Field 84 Id"; Rec."Field 84 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 84 Value"; Rec."Field 84 Value") { ApplicationArea = All; Editable = Field84Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field84Visible; }
                field("Field 85 Id"; Rec."Field 85 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 85 Value"; Rec."Field 85 Value") { ApplicationArea = All; Editable = Field85Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field85Visible; }
                field("Field 86 Id"; Rec."Field 86 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 86 Value"; Rec."Field 86 Value") { ApplicationArea = All; Editable = Field86Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field86Visible; }
                field("Field 87 Id"; Rec."Field 87 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 87 Value"; Rec."Field 87 Value") { ApplicationArea = All; Editable = Field87Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field87Visible; }
                field("Field 88 Id"; Rec."Field 88 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 88 Value"; Rec."Field 88 Value") { ApplicationArea = All; Editable = Field88Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field88Visible; }
                field("Field 89 Id"; Rec."Field 89 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 89 Value"; Rec."Field 89 Value") { ApplicationArea = All; Editable = Field89Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field89Visible; }
                field("Field 90 Id"; Rec."Field 90 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 90 Value"; Rec."Field 90 Value") { ApplicationArea = All; Editable = Field90Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field90Visible; }
                field("Field 91 Id"; Rec."Field 91 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 91 Value"; Rec."Field 91 Value") { ApplicationArea = All; Editable = Field91Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field91Visible; }
                field("Field 92 Id"; Rec."Field 92 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 92 Value"; Rec."Field 92 Value") { ApplicationArea = All; Editable = Field92Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field92Visible; }
                field("Field 93 Id"; Rec."Field 93 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 93 Value"; Rec."Field 93 Value") { ApplicationArea = All; Editable = Field93Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field93Visible; }
                field("Field 94 Id"; Rec."Field 94 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 94 Value"; Rec."Field 94 Value") { ApplicationArea = All; Editable = Field94Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field94Visible; }
                field("Field 95 Id"; Rec."Field 95 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 95 Value"; Rec."Field 95 Value") { ApplicationArea = All; Editable = Field95Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field95Visible; }
                field("Field 96 Id"; Rec."Field 96 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 96 Value"; Rec."Field 96 Value") { ApplicationArea = All; Editable = Field96Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field96Visible; }
                field("Field 97 Id"; Rec."Field 97 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 97 Value"; Rec."Field 97 Value") { ApplicationArea = All; Editable = Field97Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field97Visible; }
                field("Field 98 Id"; Rec."Field 98 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 98 Value"; Rec."Field 98 Value") { ApplicationArea = All; Editable = Field98Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field98Visible; }
                field("Field 99 Id"; Rec."Field 99 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 99 Value"; Rec."Field 99 Value") { ApplicationArea = All; Editable = Field99Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field99Visible; }
                field("Field 100 Id"; Rec."Field 100 Id") { ApplicationArea = All; Editable = false; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies the target field ID for this preview matrix column.'; Visible = false; }
                field("Field 100 Value"; Rec."Field 100 Value") { ApplicationArea = All; Editable = Field100Editable; Style = Strong; StyleExpr = IsInitialRow; ToolTip = 'Specifies preview matrix data.'; Visible = Field100Visible; }
            }
        }
    }

    trigger OnOpenPage()
    var
        AccessMgt: Codeunit "BCDA Access Mgt.";
    begin
        AccessMgt.EnsureSuperUser();

        Rec.SetCurrentKey("Correction Type", "Table ID", "Record ID", "Insert Group No.");
    end;

    trigger OnAfterGetRecord()
    begin
        IsInitialRow := Rec.Type = Rec.Type::Initial;
    end;

    procedure SetData(RequestID: Code[20])
    var
        CorrectionLine: Record "BCDA Correction Line";
        TempFieldTableMapping: Record Field temporary;
        Field: Record Field;
        AccessMgt: Codeunit "BCDA Access Mgt.";
        InitialRecordId: RecordId;
        TempRecordRef: RecordRef;
        TableNo: Integer;
        FieldCounter: Integer;
        FieldIndex: Integer;
        MaxFieldCount: Integer;
        i: Integer;
    begin
        AccessMgt.EnsureSuperUser();
        if RequestID = '' then
            Error(RequestIdRequiredErr);

        MaxFieldCount := 0;
        Rec.DeleteAll();
        ResetVisibleColumns();
        InsertGroupNoVisible := false;

        CorrectionLine.SetRange("Request ID", RequestID);
        if not CorrectionLine.FindSet() then
            Error(NoCorrectionLinesErr, RequestID);

        //build field table mapping
        repeat
            if CorrectionLine.Type = CorrectionLine.Type::Insert then
                InsertGroupNoVisible := true;

            if CorrectionLine."Field ID" = 0 then
                continue;

            if TempFieldTableMapping.Get(CorrectionLine."Table ID", CorrectionLine."Field ID") then
                continue;

            TempFieldTableMapping.Init();
            TempFieldTableMapping.TableNo := CorrectionLine."Table ID";
            TempFieldTableMapping."No." := CorrectionLine."Field ID";
            TempFieldTableMapping.Insert();
        until CorrectionLine.Next() = 0;

        //create initial matrix lines
        TableNo := 0;
        if TempFieldTableMapping.FindSet() then
            repeat
                if TableNo <> TempFieldTableMapping.TableNo then
                    FieldCounter := 0;

                FieldIndex := 101010 + FieldCounter * 10;
                TempFieldTableMapping.RelationFieldNo := FieldIndex;
                TempFieldTableMapping.Modify();

                TableNo := TempFieldTableMapping.TableNo;
                FieldCounter += 1;
            until TempFieldTableMapping.Next() = 0;


        TempRecordRef.Open(Database::"BCDA Preview Data Matrix");
        if CorrectionLine.FindSet() then
            repeat
                if CorrectionLine."Field ID" = 0 then
                    continue;

                if not Rec.Get(Rec.Type::Current, CorrectionLine."Request ID", CorrectionLine.Type, CorrectionLine."Table ID", CorrectionLine."Record ID", CorrectionLine."Insert Group No.") then begin
                    if not Rec.Get(Rec.Type::Initial, CorrectionLine."Request ID", CorrectionLine.Type, CorrectionLine."Table ID", InitialRecordId, CorrectionLine."Insert Group No.") then begin
                        Rec.Init();
                        Rec.Type := Rec.Type::Initial;
                        Rec."Request ID" := CorrectionLine."Request ID";
                        Rec."Correction Type" := CorrectionLine.Type;
                        Rec."Table ID" := CorrectionLine."Table ID";
                        Rec."Record ID" := InitialRecordId;
                        Rec."Insert Group No." := CorrectionLine."Insert Group No.";
                        Rec.Insert();

                        FieldCounter := 0;
                        TempRecordRef := Rec;
                        TempFieldTableMapping.Reset();
                        TempFieldTableMapping.SetRange(TableNo, CorrectionLine."Table ID");
                        if TempFieldTableMapping.FindSet() then
                            repeat
                                Field.Get(TempFieldTableMapping.TableNo, TempFieldTableMapping."No.");
                                TempRecordRef.Field(TempFieldTableMapping.RelationFieldNo).Value(TempFieldTableMapping."No.");
                                TempRecordRef.Field(TempFieldTableMapping.RelationFieldNo + 1).Value(Field."Field Caption");

                                FieldCounter += 1;
                                if FieldCounter > MaxFieldCount then
                                    MaxFieldCount := FieldCounter;
                            until TempFieldTableMapping.Next() = 0;
                        Rec := TempRecordRef;
                        Rec.Modify();
                    end;

                    TempFieldTableMapping.Reset();
                    TempFieldTableMapping.Get(CorrectionLine."Table ID", CorrectionLine."Field ID");
                    Rec.Type := Rec.Type::Current;
                    Rec."Correction Type" := CorrectionLine.Type;
                    Rec."Record ID" := CorrectionLine."Record ID";
                    Rec."Insert Group No." := CorrectionLine."Insert Group No.";

                    TempRecordRef := Rec;
                    for i := 101011 to 102001 do begin
                        TempRecordRef.Field(i).Value('');
                        i += 9;
                    end;
                    Rec := TempRecordRef;
                    Rec.Insert();
                end;

                TempFieldTableMapping.Reset();
                TempFieldTableMapping.Get(CorrectionLine."Table ID", CorrectionLine."Field ID");

                TempRecordRef := Rec;
                TempRecordRef.Field(TempFieldTableMapping.RelationFieldNo + 1).Value := CorrectionLine."Current Value Preview";
                Rec := TempRecordRef;
                Rec.Modify();

                if not Rec.Get(Rec.Type::New, CorrectionLine."Request ID", CorrectionLine.Type, CorrectionLine."Table ID", CorrectionLine."Record ID", CorrectionLine."Insert Group No.") then begin
                    Rec.Get(Rec.Type::Initial, CorrectionLine."Request ID", CorrectionLine.Type, CorrectionLine."Table ID", InitialRecordId, CorrectionLine."Insert Group No.");
                    Rec.Type := Rec.Type::New;
                    Rec."Correction Type" := CorrectionLine.Type;
                    Rec."Record ID" := CorrectionLine."Record ID";
                    Rec."Insert Group No." := CorrectionLine."Insert Group No.";
                    TempRecordRef := Rec;
                    for i := 101011 to 102001 do begin
                        TempRecordRef.Field(i).Value('');
                        i += 9;
                    end;
                    Rec := TempRecordRef;
                    Rec.Insert();
                end;

                TempRecordRef := Rec;
                TempRecordRef.Field(TempFieldTableMapping.RelationFieldNo + 1).Value := CorrectionLine."Proposed New Value";
                Rec := TempRecordRef;
                Rec.Modify();
                SetFieldEditableByIndex(TempFieldTableMapping.RelationFieldNo, false);
            until CorrectionLine.Next() = 0;
        TempRecordRef.Close();

        SetVisibleColumnCount(MaxFieldCount);
    end;

    local procedure ResetVisibleColumns()
    var
        ColumnNo: Integer;
    begin
        for ColumnNo := 1 to 100 do
            SetColumnVisible(ColumnNo, false);
    end;

    local procedure SetVisibleColumnCount(ColumnCount: Integer)
    var
        ColumnNo: Integer;
    begin
        for ColumnNo := 1 to ColumnCount do
            SetColumnVisible(ColumnNo, true);
    end;

    local procedure SetFieldEditableByIndex(FieldIndex: Integer; IsEditable: Boolean)
    var
        ColumnNo: Integer;
    begin
        if (FieldIndex < 101011) or (FieldIndex > 102001) then
            exit;

        ColumnNo := (FieldIndex - 101001) div 10;
        SetFieldEditable(ColumnNo, IsEditable);
    end;

    local procedure SetFieldEditable(ColumnNo: Integer; IsEditable: Boolean)
    begin
        case ColumnNo of
            1:
                Field1Editable := IsEditable;
            2:
                Field2Editable := IsEditable;
            3:
                Field3Editable := IsEditable;
            4:
                Field4Editable := IsEditable;
            5:
                Field5Editable := IsEditable;
            6:
                Field6Editable := IsEditable;
            7:
                Field7Editable := IsEditable;
            8:
                Field8Editable := IsEditable;
            9:
                Field9Editable := IsEditable;
            10:
                Field10Editable := IsEditable;
            11:
                Field11Editable := IsEditable;
            12:
                Field12Editable := IsEditable;
            13:
                Field13Editable := IsEditable;
            14:
                Field14Editable := IsEditable;
            15:
                Field15Editable := IsEditable;
            16:
                Field16Editable := IsEditable;
            17:
                Field17Editable := IsEditable;
            18:
                Field18Editable := IsEditable;
            19:
                Field19Editable := IsEditable;
            20:
                Field20Editable := IsEditable;
            21:
                Field21Editable := IsEditable;
            22:
                Field22Editable := IsEditable;
            23:
                Field23Editable := IsEditable;
            24:
                Field24Editable := IsEditable;
            25:
                Field25Editable := IsEditable;
            26:
                Field26Editable := IsEditable;
            27:
                Field27Editable := IsEditable;
            28:
                Field28Editable := IsEditable;
            29:
                Field29Editable := IsEditable;
            30:
                Field30Editable := IsEditable;
            31:
                Field31Editable := IsEditable;
            32:
                Field32Editable := IsEditable;
            33:
                Field33Editable := IsEditable;
            34:
                Field34Editable := IsEditable;
            35:
                Field35Editable := IsEditable;
            36:
                Field36Editable := IsEditable;
            37:
                Field37Editable := IsEditable;
            38:
                Field38Editable := IsEditable;
            39:
                Field39Editable := IsEditable;
            40:
                Field40Editable := IsEditable;
            41:
                Field41Editable := IsEditable;
            42:
                Field42Editable := IsEditable;
            43:
                Field43Editable := IsEditable;
            44:
                Field44Editable := IsEditable;
            45:
                Field45Editable := IsEditable;
            46:
                Field46Editable := IsEditable;
            47:
                Field47Editable := IsEditable;
            48:
                Field48Editable := IsEditable;
            49:
                Field49Editable := IsEditable;
            50:
                Field50Editable := IsEditable;
            51:
                Field51Editable := IsEditable;
            52:
                Field52Editable := IsEditable;
            53:
                Field53Editable := IsEditable;
            54:
                Field54Editable := IsEditable;
            55:
                Field55Editable := IsEditable;
            56:
                Field56Editable := IsEditable;
            57:
                Field57Editable := IsEditable;
            58:
                Field58Editable := IsEditable;
            59:
                Field59Editable := IsEditable;
            60:
                Field60Editable := IsEditable;
            61:
                Field61Editable := IsEditable;
            62:
                Field62Editable := IsEditable;
            63:
                Field63Editable := IsEditable;
            64:
                Field64Editable := IsEditable;
            65:
                Field65Editable := IsEditable;
            66:
                Field66Editable := IsEditable;
            67:
                Field67Editable := IsEditable;
            68:
                Field68Editable := IsEditable;
            69:
                Field69Editable := IsEditable;
            70:
                Field70Editable := IsEditable;
            71:
                Field71Editable := IsEditable;
            72:
                Field72Editable := IsEditable;
            73:
                Field73Editable := IsEditable;
            74:
                Field74Editable := IsEditable;
            75:
                Field75Editable := IsEditable;
            76:
                Field76Editable := IsEditable;
            77:
                Field77Editable := IsEditable;
            78:
                Field78Editable := IsEditable;
            79:
                Field79Editable := IsEditable;
            80:
                Field80Editable := IsEditable;
            81:
                Field81Editable := IsEditable;
            82:
                Field82Editable := IsEditable;
            83:
                Field83Editable := IsEditable;
            84:
                Field84Editable := IsEditable;
            85:
                Field85Editable := IsEditable;
            86:
                Field86Editable := IsEditable;
            87:
                Field87Editable := IsEditable;
            88:
                Field88Editable := IsEditable;
            89:
                Field89Editable := IsEditable;
            90:
                Field90Editable := IsEditable;
            91:
                Field91Editable := IsEditable;
            92:
                Field92Editable := IsEditable;
            93:
                Field93Editable := IsEditable;
            94:
                Field94Editable := IsEditable;
            95:
                Field95Editable := IsEditable;
            96:
                Field96Editable := IsEditable;
            97:
                Field97Editable := IsEditable;
            98:
                Field98Editable := IsEditable;
            99:
                Field99Editable := IsEditable;
            100:
                Field100Editable := IsEditable;
        end;
    end;

    local procedure SetColumnVisible(ColumnNo: Integer; IsVisible: Boolean)
    begin
        case ColumnNo of
            1:
                Field1Visible := IsVisible;
            2:
                Field2Visible := IsVisible;
            3:
                Field3Visible := IsVisible;
            4:
                Field4Visible := IsVisible;
            5:
                Field5Visible := IsVisible;
            6:
                Field6Visible := IsVisible;
            7:
                Field7Visible := IsVisible;
            8:
                Field8Visible := IsVisible;
            9:
                Field9Visible := IsVisible;
            10:
                Field10Visible := IsVisible;
            11:
                Field11Visible := IsVisible;
            12:
                Field12Visible := IsVisible;
            13:
                Field13Visible := IsVisible;
            14:
                Field14Visible := IsVisible;
            15:
                Field15Visible := IsVisible;
            16:
                Field16Visible := IsVisible;
            17:
                Field17Visible := IsVisible;
            18:
                Field18Visible := IsVisible;
            19:
                Field19Visible := IsVisible;
            20:
                Field20Visible := IsVisible;
            21:
                Field21Visible := IsVisible;
            22:
                Field22Visible := IsVisible;
            23:
                Field23Visible := IsVisible;
            24:
                Field24Visible := IsVisible;
            25:
                Field25Visible := IsVisible;
            26:
                Field26Visible := IsVisible;
            27:
                Field27Visible := IsVisible;
            28:
                Field28Visible := IsVisible;
            29:
                Field29Visible := IsVisible;
            30:
                Field30Visible := IsVisible;
            31:
                Field31Visible := IsVisible;
            32:
                Field32Visible := IsVisible;
            33:
                Field33Visible := IsVisible;
            34:
                Field34Visible := IsVisible;
            35:
                Field35Visible := IsVisible;
            36:
                Field36Visible := IsVisible;
            37:
                Field37Visible := IsVisible;
            38:
                Field38Visible := IsVisible;
            39:
                Field39Visible := IsVisible;
            40:
                Field40Visible := IsVisible;
            41:
                Field41Visible := IsVisible;
            42:
                Field42Visible := IsVisible;
            43:
                Field43Visible := IsVisible;
            44:
                Field44Visible := IsVisible;
            45:
                Field45Visible := IsVisible;
            46:
                Field46Visible := IsVisible;
            47:
                Field47Visible := IsVisible;
            48:
                Field48Visible := IsVisible;
            49:
                Field49Visible := IsVisible;
            50:
                Field50Visible := IsVisible;
            51:
                Field51Visible := IsVisible;
            52:
                Field52Visible := IsVisible;
            53:
                Field53Visible := IsVisible;
            54:
                Field54Visible := IsVisible;
            55:
                Field55Visible := IsVisible;
            56:
                Field56Visible := IsVisible;
            57:
                Field57Visible := IsVisible;
            58:
                Field58Visible := IsVisible;
            59:
                Field59Visible := IsVisible;
            60:
                Field60Visible := IsVisible;
            61:
                Field61Visible := IsVisible;
            62:
                Field62Visible := IsVisible;
            63:
                Field63Visible := IsVisible;
            64:
                Field64Visible := IsVisible;
            65:
                Field65Visible := IsVisible;
            66:
                Field66Visible := IsVisible;
            67:
                Field67Visible := IsVisible;
            68:
                Field68Visible := IsVisible;
            69:
                Field69Visible := IsVisible;
            70:
                Field70Visible := IsVisible;
            71:
                Field71Visible := IsVisible;
            72:
                Field72Visible := IsVisible;
            73:
                Field73Visible := IsVisible;
            74:
                Field74Visible := IsVisible;
            75:
                Field75Visible := IsVisible;
            76:
                Field76Visible := IsVisible;
            77:
                Field77Visible := IsVisible;
            78:
                Field78Visible := IsVisible;
            79:
                Field79Visible := IsVisible;
            80:
                Field80Visible := IsVisible;
            81:
                Field81Visible := IsVisible;
            82:
                Field82Visible := IsVisible;
            83:
                Field83Visible := IsVisible;
            84:
                Field84Visible := IsVisible;
            85:
                Field85Visible := IsVisible;
            86:
                Field86Visible := IsVisible;
            87:
                Field87Visible := IsVisible;
            88:
                Field88Visible := IsVisible;
            89:
                Field89Visible := IsVisible;
            90:
                Field90Visible := IsVisible;
            91:
                Field91Visible := IsVisible;
            92:
                Field92Visible := IsVisible;
            93:
                Field93Visible := IsVisible;
            94:
                Field94Visible := IsVisible;
            95:
                Field95Visible := IsVisible;
            96:
                Field96Visible := IsVisible;
            97:
                Field97Visible := IsVisible;
            98:
                Field98Visible := IsVisible;
            99:
                Field99Visible := IsVisible;
            100:
                Field100Visible := IsVisible;
        end;
    end;

    var
        IsInitialRow: Boolean;
        InsertGroupNoVisible: Boolean;
        Field1Visible: Boolean;
        Field2Visible: Boolean;
        Field3Visible: Boolean;
        Field4Visible: Boolean;
        Field5Visible: Boolean;
        Field6Visible: Boolean;
        Field7Visible: Boolean;
        Field8Visible: Boolean;
        Field9Visible: Boolean;
        Field10Visible: Boolean;
        Field11Visible: Boolean;
        Field12Visible: Boolean;
        Field13Visible: Boolean;
        Field14Visible: Boolean;
        Field15Visible: Boolean;
        Field16Visible: Boolean;
        Field17Visible: Boolean;
        Field18Visible: Boolean;
        Field19Visible: Boolean;
        Field20Visible: Boolean;
        Field21Visible: Boolean;
        Field22Visible: Boolean;
        Field23Visible: Boolean;
        Field24Visible: Boolean;
        Field25Visible: Boolean;
        Field26Visible: Boolean;
        Field27Visible: Boolean;
        Field28Visible: Boolean;
        Field29Visible: Boolean;
        Field30Visible: Boolean;
        Field31Visible: Boolean;
        Field32Visible: Boolean;
        Field33Visible: Boolean;
        Field34Visible: Boolean;
        Field35Visible: Boolean;
        Field36Visible: Boolean;
        Field37Visible: Boolean;
        Field38Visible: Boolean;
        Field39Visible: Boolean;
        Field40Visible: Boolean;
        Field41Visible: Boolean;
        Field42Visible: Boolean;
        Field43Visible: Boolean;
        Field44Visible: Boolean;
        Field45Visible: Boolean;
        Field46Visible: Boolean;
        Field47Visible: Boolean;
        Field48Visible: Boolean;
        Field49Visible: Boolean;
        Field50Visible: Boolean;
        Field51Visible: Boolean;
        Field52Visible: Boolean;
        Field53Visible: Boolean;
        Field54Visible: Boolean;
        Field55Visible: Boolean;
        Field56Visible: Boolean;
        Field57Visible: Boolean;
        Field58Visible: Boolean;
        Field59Visible: Boolean;
        Field60Visible: Boolean;
        Field61Visible: Boolean;
        Field62Visible: Boolean;
        Field63Visible: Boolean;
        Field64Visible: Boolean;
        Field65Visible: Boolean;
        Field66Visible: Boolean;
        Field67Visible: Boolean;
        Field68Visible: Boolean;
        Field69Visible: Boolean;
        Field70Visible: Boolean;
        Field71Visible: Boolean;
        Field72Visible: Boolean;
        Field73Visible: Boolean;
        Field74Visible: Boolean;
        Field75Visible: Boolean;
        Field76Visible: Boolean;
        Field77Visible: Boolean;
        Field78Visible: Boolean;
        Field79Visible: Boolean;
        Field80Visible: Boolean;
        Field81Visible: Boolean;
        Field82Visible: Boolean;
        Field83Visible: Boolean;
        Field84Visible: Boolean;
        Field85Visible: Boolean;
        Field86Visible: Boolean;
        Field87Visible: Boolean;
        Field88Visible: Boolean;
        Field89Visible: Boolean;
        Field90Visible: Boolean;
        Field91Visible: Boolean;
        Field92Visible: Boolean;
        Field93Visible: Boolean;
        Field94Visible: Boolean;
        Field95Visible: Boolean;
        Field96Visible: Boolean;
        Field97Visible: Boolean;
        Field98Visible: Boolean;
        Field99Visible: Boolean;
        Field100Visible: Boolean;
        Field1Editable: Boolean;
        Field2Editable: Boolean;
        Field3Editable: Boolean;
        Field4Editable: Boolean;
        Field5Editable: Boolean;
        Field6Editable: Boolean;
        Field7Editable: Boolean;
        Field8Editable: Boolean;
        Field9Editable: Boolean;
        Field10Editable: Boolean;
        Field11Editable: Boolean;
        Field12Editable: Boolean;
        Field13Editable: Boolean;
        Field14Editable: Boolean;
        Field15Editable: Boolean;
        Field16Editable: Boolean;
        Field17Editable: Boolean;
        Field18Editable: Boolean;
        Field19Editable: Boolean;
        Field20Editable: Boolean;
        Field21Editable: Boolean;
        Field22Editable: Boolean;
        Field23Editable: Boolean;
        Field24Editable: Boolean;
        Field25Editable: Boolean;
        Field26Editable: Boolean;
        Field27Editable: Boolean;
        Field28Editable: Boolean;
        Field29Editable: Boolean;
        Field30Editable: Boolean;
        Field31Editable: Boolean;
        Field32Editable: Boolean;
        Field33Editable: Boolean;
        Field34Editable: Boolean;
        Field35Editable: Boolean;
        Field36Editable: Boolean;
        Field37Editable: Boolean;
        Field38Editable: Boolean;
        Field39Editable: Boolean;
        Field40Editable: Boolean;
        Field41Editable: Boolean;
        Field42Editable: Boolean;
        Field43Editable: Boolean;
        Field44Editable: Boolean;
        Field45Editable: Boolean;
        Field46Editable: Boolean;
        Field47Editable: Boolean;
        Field48Editable: Boolean;
        Field49Editable: Boolean;
        Field50Editable: Boolean;
        Field51Editable: Boolean;
        Field52Editable: Boolean;
        Field53Editable: Boolean;
        Field54Editable: Boolean;
        Field55Editable: Boolean;
        Field56Editable: Boolean;
        Field57Editable: Boolean;
        Field58Editable: Boolean;
        Field59Editable: Boolean;
        Field60Editable: Boolean;
        Field61Editable: Boolean;
        Field62Editable: Boolean;
        Field63Editable: Boolean;
        Field64Editable: Boolean;
        Field65Editable: Boolean;
        Field66Editable: Boolean;
        Field67Editable: Boolean;
        Field68Editable: Boolean;
        Field69Editable: Boolean;
        Field70Editable: Boolean;
        Field71Editable: Boolean;
        Field72Editable: Boolean;
        Field73Editable: Boolean;
        Field74Editable: Boolean;
        Field75Editable: Boolean;
        Field76Editable: Boolean;
        Field77Editable: Boolean;
        Field78Editable: Boolean;
        Field79Editable: Boolean;
        Field80Editable: Boolean;
        Field81Editable: Boolean;
        Field82Editable: Boolean;
        Field83Editable: Boolean;
        Field84Editable: Boolean;
        Field85Editable: Boolean;
        Field86Editable: Boolean;
        Field87Editable: Boolean;
        Field88Editable: Boolean;
        Field89Editable: Boolean;
        Field90Editable: Boolean;
        Field91Editable: Boolean;
        Field92Editable: Boolean;
        Field93Editable: Boolean;
        Field94Editable: Boolean;
        Field95Editable: Boolean;
        Field96Editable: Boolean;
        Field97Editable: Boolean;
        Field98Editable: Boolean;
        Field99Editable: Boolean;
        Field100Editable: Boolean;
        NoCorrectionLinesErr: Label 'Request %1 has no correction lines to preview.', Comment = '%1 = request ID';
        RequestIdRequiredErr: Label 'A request ID is required before previewing the data matrix.';
}
