page 50357 "Desk Date Status AGB"
{
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Desk Date Status AGB";
    Caption = 'Desk Dates';
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                caption = 'General';
                group(Dates)
                {
                    ShowCaption = false;
                    field("From Date"; "From Date")
                    {
                        ApplicationArea = All;
                        Caption = 'From Date';
                        Tooltip = 'Shows From Date';
                        Importance = Promoted;

                        trigger OnValidate()
                        begin
                            ErrorIfFromDateBehindToDate();
                            Rec.ReleaseFreeDesks("From Date", "To Date");
                            SetPageFilter();
                        end;
                    }
                    field("To Date"; "To Date")
                    {
                        ApplicationArea = All;
                        Caption = 'To Date';
                        Tooltip = 'Shows To Date';
                        Importance = Promoted;

                        trigger OnValidate()
                        begin
                            ErrorIfFromDateBehindToDate();
                            Rec.ReleaseFreeDesks("From Date", "To Date");
                            SetPageFilter();
                        end;
                    }
                }
                field("Only Reservable Entries"; "Only Reservable Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Only Reservable Entries';
                    Tooltip = 'Click this field if you want to see Reservable Entries only';
                    
                    trigger OnValidate()
                    begin
                        SetPageFilter();
                    end;
                }
            }
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
                    StyleExpr = StyleExprText;
                }
                field(Status; Rec."Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the Status';
                    StyleExpr = StyleExprText;
                }
                field("Reserved For"; Rec."Reserved For")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the Reserved For';
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
                    StyleExpr = StyleExprText;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Reserve)
            {
                ApplicationArea = All;
                Caption = 'Reserve';
                Image = Reserve;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Reserve selected Desk Dates';
                PromotedOnly = true;

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
                ToolTip = 'Cancel Reservation';
                PromotedOnly = true;

                trigger OnAction()
                var
                    DeskDateStatus: Record "Desk Date Status AGB";
                begin
                    CurrPage.SetSelectionFilter(DeskDateStatus);
                    Rec.CancelReservedDesks(DeskDateStatus);
                end;
            }
            action(CancelRelease)
            {
                ApplicationArea = All;
                Caption = 'CancelRelease';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Canceled a Released Desk Date';
                PromotedOnly = true;

                trigger OnAction()
                var
                    DeskDateStatus: Record "Desk Date Status AGB";
                begin
                    CurrPage.SetSelectionFilter(DeskDateStatus);
                    Rec.CancelReleasedDesks(DeskDateStatus);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StyleExprText := 'Standard';
        if (Rec."Regular User" <> '') then
            StyleExprText := 'StandardAccent';

        if (Rec.Status = Rec.Status::Reserved)
        or (Rec.Status = Rec.Status::"Released Cancelled") then
            StyleExprText := 'Attention';
    end;

    procedure SetSelectionDates(FromDate: Date; ToDate: Date)
    begin
        "From Date" := FromDate;
        "To Date" := ToDate;
    end;

    local procedure SetPageFilter()
    begin
        if ("From Date" <> 0D) and ("To Date" = 0D) then
            Rec.SetFilter(Date, '%1..', "From Date");
        If ("From Date" <> 0D) and ("To Date" <> 0D) then
            Rec.SetRange(Date, "From Date", "To Date");
        if ("From Date" = 0D) and ("To Date" <> 0D) then
            Rec.SetFilter(Date, '..%1', "To Date");

        if "Only Reservable Entries" then
            Rec.SetFilter(Status, '%1|%2', Rec.Status::Released, Rec.Status::"Reservation Cancelled")
        else
            Rec.SetRange(Status);

        if DeskCodeFilter <> '' then
            Rec.SetFilter("Desk Code", DeskCodeFilter)
        else
            Rec.SetRange("Desk Code");

        Currpage.Update();
    end;

    local procedure ErrorIfFromDateBehindToDate();
    begin
        if ("From Date" = 0D) and ("To Date" = 0D) then
            Error(Text004Err);
        if "From Date" = 0D then
            "From Date" := "To Date";
        if "To Date" = 0D then
            "To Date" := "From Date";

        if "From Date" > "To Date" then
            Error(Text002Err, "From Date", "To Date");
        if "From Date" < WorkDate() then
            Error(Text003Err);
    end;

    var
        "From Date": Date;
        "To Date": Date;
        "Only Reservable Entries": Boolean;
        StyleExprText: Text;
        DeskCodeFilter: Text;
        Text001Err: Label 'To Date %1 is too far in the future. The Maximum Date is %2.', comment = '%1 = To Date, %2 = Maximum Date';
        Text002Err: Label 'The From Date %1 must not be behind To Date %2', comment = '%1 = FromDate, %2 = ToDate';
        Text003Err: Label 'From Date must be less Days than Work Date';
        Text004Err: Label 'From Date and To Date must not be blank';
}