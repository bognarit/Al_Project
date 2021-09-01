page 50352 "Desk User Card AGB"
{
    PageType = Card;
    SourceTable = "Desk User AGB";
    Caption = 'Desk User Card';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the Code';
                    Importance = Promoted;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the Name';
                    Importance = Promoted;
                }
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the User Name';
                }
                field("Flex Desk Administrator"; Rec."Flex Desk Administrator")
                {
                    ApplicationArea = All;
                    ToolTip = 'Flex Desk Administrator is allowed to release Desks of other Users';
                }
                field("No of Reserved Desk Dates"; Rec."No of Reserved Desk Dates")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Shows the No of Reserved Desk Dates';
                }
                field("Regular Desk"; Rec."Regular Desk")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Desk Card AGB";
                    ToolTip = 'Shows the regular desk of the user';
                }
                field("No. Of Cancelled Released Info"; Rec."No. Of Cancelled Released Info")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the No. Of Cancelled Released Info';
                    Importance = Additional;
                }
            }
            part(DeskDatesStatus; "Desk Dates Status Subpage AGB")
            {
                Caption = 'Desk Dates';
                ApplicationArea = All;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        if Rec."Regular Desk" = '' then
            CurrPage.DeskDatesStatus.Page.SetFlexDeskUserFilter(Rec)
        else
            CurrPage.DeskDatesStatus.Page.SetRegularDeskUserFilter(Rec);
    end;
}