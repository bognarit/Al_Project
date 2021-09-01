page 50350 "Desk Users AGB"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Desk User AGB";
    Caption = 'Desk User';
    CardPageId = "Desk User Card AGB";
    Editable = false;

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
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the Name';
                }
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the User Name';
                }
                field("Flex Desk Administrator"; Rec."Flex Desk Administrator")
                {
                    ApplicationArea = All;
                    ToolTip = 'Flex Desk Administrator is allowed to release Desks of other Users and to delete Desk Date Statses.';
                }
                field("Regular Desk"; Rec."Regular Desk")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the regular desk of the user';
                }
                field("No. Of Cancelled Released Info"; Rec."No. Of Cancelled Released Info")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the No. Of Cancelled Released Info';
                }
            }
        }
    }
}