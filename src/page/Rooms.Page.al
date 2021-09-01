page 50351 "Rooms AGB"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Room AGB";
    Caption = 'Rooms';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the Code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the Description';
                }
            }
        }
    }
}