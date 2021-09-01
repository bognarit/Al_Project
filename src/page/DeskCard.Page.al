page 50355 "Desk Card AGB"
{
    PageType = Card;
    SourceTable = "Desk AGB";
    Caption = 'Desk Card';

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
                field("Room Code"; Rec."Room Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the Room Code';
                    Importance = Promoted;
                }
                field("Room Description"; Rec."Room Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the Room Description';
                    Importance = Additional;
                    DrillDown = false;
                }
                group(name)
                {
                    ShowCaption = false;
                    field("Regular User"; Rec."Regular User")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Shows the Regular User';
                    }
                    field("Regular User Name"; Rec."Regular User Name")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Shows the Regular User Name';
                        DrillDown = false;
                    }
                }
                field(Blocked; Rec."Blocked")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select this field if you want to block this desk. Blocked desks can not be released. Only administrators are allowed to change this field.';
                    Importance = Additional;
                }
            }
            part("Desk Dates Status"; "Desk Dates Status Subpage AGB")
            {
                Caption = 'Desk Dates';
                SubPageLink = "Desk Code" = field(code);
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Release)
            {
                ApplicationArea = All;
                Caption = 'Release';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Release Desk';
                PromotedOnly = true;

                trigger OnAction()
                var
                    DeskDateStatus: Record "Desk Date Status AGB";
                begin
                    DeskDateStatus.GetTimePeriodAndReleaseDeskDates(Rec);
                end;
            }
        }
    }
}