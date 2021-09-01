page 50354 "Desks AGB"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Desk AGB";
    Caption = 'Desks';
    CardPageId = "Desk Card AGB";
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
                field("Room Code"; Rec."Room Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the Room Code';
                }
                field("Room Description"; Rec."Room Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the Room Description';
                    DrillDown = false;
                }
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
                field(Blocked; Rec."Blocked")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select this field if you want to block this desk. Blocked desks can not be released. Only administrators are allowed to change this field.';
                }
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