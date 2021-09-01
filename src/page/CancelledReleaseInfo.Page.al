page 50362 "Cancelled Release Info AGB"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cancelled Release Info AGB";
    Editable = false;
    Caption = 'Cancelled Release Info';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Reserved For"; Rec."Reserved For")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the Reserved For';
                }
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
                field(Status; Rec."Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the Status';
                }
                field("Status Set At"; Rec."Status Set At")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Shows the Status Set At';
                }
                field("Status Set By"; Rec."Status Set By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the Status Set By';
                }
                field("Regular User"; Rec."Regular User")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the Regular User';
                    DrillDown = false;
                }
            }
        }
        area(Factboxes)
        {
        }
    }

    actions
    {
        area(Processing)
        {
            action("Find DesksAGB")
            {
                ApplicationArea = All;
                Caption = 'Find Desks';
                ToolTip = 'Click to find a free desk';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Image = Find;

                trigger OnAction()
                var
                    DeskDateStatus: Page "Desk Date Status AGB";
                begin
                    DeskDateStatus.SetSelectionDates(Rec.Date, Rec.Date);
                    DeskDateStatus.Run();
                end;
            }
        }
    }
}