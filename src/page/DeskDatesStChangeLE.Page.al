page 50361 "Desk Dates St. Change LE AGB"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Desk Date Status Change LE AGB";
    Editable = false;
    Caption = 'Desk Dates Status Change Log Entries';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Desk Code"; Rec."Desk Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the Desk Code';
                }
                field("Date"; Rec."Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the Date';
                }
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the Entry No';
                }
                field("New Status"; Rec."New Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the New Status';
                }
                field("Status Set At"; Rec."Status Set At")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the Status Set At';
                }
                field("Status Set By"; Rec."Status Set By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the Status Set By';
                }
            }
        }
    }
}