page 50358 "Desk Details Factbox AGB"
{
    PageType = ListPart;
    Caption = 'Desk Details';
    Editable = false;

    layout
    {
        area(Content)
        {
            group(Groupname)
            {
                ShowCaption = false;

                field("Desk Code"; Desk.Code)
                {
                    ApplicationArea = All;
                    Caption = 'Desk Code';
                    Tooltip = 'Shows the Desk Code';

                    trigger OnDrillDown()
                    begin
                        ShowDetailsDesk();
                    end;
                }
                field("Room Code"; Desk."Room Code")
                {
                    ApplicationArea = All;
                    Caption = 'Room Code';
                    Tooltip = 'Shows the Room Code';

                    trigger OnDrillDown()
                    begin
                        ShowDetailsRoom();
                    end;
                }
                field("Room Description"; Desk."Room Description")
                {
                    ApplicationArea = All;
                    Caption = 'Room Description';
                    ToolTip = 'Shows the Room Description';
                }
                field("Regular User"; Desk."Regular User")
                {
                    ApplicationArea = All;
                    Caption = 'Regular User';
                    Tooltip = 'Shows the Regular User';
                }
                field(Blocked; Desk."Blocked")
                {
                    ApplicationArea = All;
                    Caption = 'Blocked';
                    Tooltip = 'Shows the Blocked';
                }
            }
        }
    }

    local procedure ShowDetailsDesk()
    begin
        // Desk.Get("Desk Code");
        PAGE.Run(Page::"Desk Card AGB", Desk);
    end;

    local procedure ShowDetailsRoom()
    var
        Room: Record "Room AGB";
    begin
        Room.Get(Desk."Room Code");
        PAGE.Run(Page::"Rooms AGB", Room);
    end;

    var
        Desk: record "Desk AGB";
}