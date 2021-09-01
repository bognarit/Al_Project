page 50363 "Release Desk Dates AGB"
{
    PageType = Card;
    Caption = 'Release Desk Dates';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                caption = 'General';
                field("Desk Code"; Desk.Code)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Shows the Desk Code';
                    Caption = 'Desk Code';
                }
                field(Room; Desk."Room Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Shows the Room';
                    Caption = 'Room';
                }
                group(Dates)
                {
                    InstructionalText = 'Enter the time period (From/To Date) You want to release your Desk';
                    ShowCaption = false;
                    field("From Date"; FromDate)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Shows the From Date';
                        Caption = 'From Date';
                    }
                    field("To Date"; ToDate)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Shows the To Date';
                        Caption = 'To Date';
                    }
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        FromDate := WorkDate();
        ToDate := WorkDate();
    end;

    procedure GetInformation(Var MyFromDate: Date; Var MyToDate: Date)
    begin
        MyFromDate := FromDate;
        MyToDate := ToDate;
    end;

    procedure SetData(MyDesk: Record "Desk AGB")
    begin
        Desk := MyDesk;
        Desk.CalcFields("Room Description");
    end;

    var
        Desk: Record "Desk AGB";
        FromDate: Date;
        ToDate: Date;
}