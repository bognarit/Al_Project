page 50360 "Desk Dates Status Subpage AGB"
{
    PageType = Listpart;
    SourceTable = "Desk Date Status AGB";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;

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
                field(Status; Rec."Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the Status';
                }
                field("Reserved For"; Rec."Reserved For")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the Reserved For';
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

    actions
    {
        area(Processing)
        {
            action(Log)
            {
                ApplicationArea = All;
                Caption = 'Log';
                Image = Administration;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Desk Dates St. Change LE AGB";
                RunPageLink = "Desk Code" = field("Desk Code"), Date = field(Date);
                ToolTip = 'Shows Log Entries';
                PromotedOnly = true;
            }
            action(CancelRelease)
            {
                ApplicationArea = All;
                Caption = 'Cancel Release';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Cancel selected Released Desk Dates';
                PromotedOnly = true;
                Visible = CancelReleaseVisible;

                trigger OnAction()
                var
                    DeskDateStatus: Record "Desk Date Status AGB";
                begin
                    CurrPage.SetSelectionFilter(DeskDateStatus);
                    Rec.CancelReleasedDesks(DeskDateStatus);
                end;
            }
            action(Reserve)
            {
                ApplicationArea = All;
                Caption = 'Reserve';
                Image = Reserve;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Reserve selected Desk Dates';
                PromotedOnly = true;
                Visible = ReserveVisible;

                trigger OnAction()
                var
                    DeskDateStatus: Record "Desk Date Status AGB";
                begin
                    CurrPage.SetSelectionFilter(DeskDateStatus);
                    Rec.ReserveDesks(DeskDateStatus);
                end;
            }
            action("Cancel Reservation")
            {
                ApplicationArea = All;
                Caption = 'Cancel Reservation';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Cancel selected Reserved Desk Dates';
                PromotedOnly = true;
                Visible = CancelReservationVisible;

                trigger OnAction()
                var
                    DeskDateStatus: Record "Desk Date Status AGB";
                begin
                    CurrPage.SetSelectionFilter(DeskDateStatus);
                    Rec.CancelReservedDesks(DeskDateStatus);
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetFilter(Date, '>= %1', WorkDate());
        SetVisibles();
    end;

    local procedure SetVisibles()
    var
        DeskUser: Record "Desk User AGB";
    begin
        CancelReleaseVisible := true;
        ReserveVisible := true;
        CancelReservationVisible := true;

        if not DeskUser.UserIsFlexDeskAdmin() then
            if DeskUser.UserIsRegularUser() then begin
                ReserveVisible := false;
                CancelReservationVisible := false;
            end else
                CancelReleaseVisible := false;
    end;

    procedure SetRegularDeskUserFilter(DeskUser: Record "Desk User AGB")
    var
    begin
        Rec.SetFilter(Date, '>= %1', WorkDate());
        DeskUser.CalcFields("Regular Desk");
        Rec.SetRange("Desk Code", DeskUser."Regular Desk");
        CurrPage.Update();
    end;

    procedure SetFlexDeskUserFilter(DeskUser: Record "Desk User AGB")
    var
    begin
        Rec.SetFilter(Date, '>= %1', WorkDate());
        Rec.SetRange("Reserved For", DeskUser.code);
        CurrPage.Update();
    end;

    var
        CancelReleaseVisible: boolean;
        ReserveVisible: boolean;
        CancelReservationVisible: boolean;
}