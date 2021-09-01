table 50355 "Desk Date Status AGB"
{
    DataClassification = CustomerContent;
    Caption = 'Desk Date Status';
    DrillDownPageId = "Desk Date Status AGB";
    LookupPageId = "Desk Date Status AGB";

    fields
    {
        field(1; "Desk Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Desk AGB";
            Caption = 'Desk Code';
            NotBlank = true;
            Editable = false;
        }
        field(2; "Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date';
            Editable = false;
        }
        field(3; Status; enum "Status Desk AGB")
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
            Editable = false;
        }
        field(4; "Reserved For"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Desk User AGB";
            Caption = 'Reserved for';
            Editable = false;
        }
        field(5; "Status Set At"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Status Set At';
            Editable = false;
        }
        field(6; "Status Set By"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Status Set By';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
            Editable = false;

            trigger OnValidate()
            var
                UserSelection: Codeunit "User Selection";
            begin
                UserSelection.ValidateUserName("Status Set By");
            end;
        }
        field(7; "Regular User"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup ("Desk AGB"."Regular User" where(code = field("Desk Code")));
            Caption = 'Regular User';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Desk Code", Date)
        {
            Clustered = true;
        }
        key(Key02; Date)
        {
        }
    }

    trigger OnDelete()
    var
        DeskDateStatusChangeLE: Record "Desk Date Status Change LE AGB";
        CancelledReleaseInfo: Record "Cancelled Release Info AGB";
    begin
        DeskDateStatusChangeLE.SetRange("Desk Code", "Desk Code");
        DeskDateStatusChangeLE.SetRange(Date, Date);
        If DeskDateStatusChangeLE.FindSet() then
            repeat
                DeskDateStatusChangeLE.Delete(true);
            until DeskDateStatusChangeLE.Next() = 0;

        CancelledReleaseInfo.SetRange("Desk Code", "Desk Code");
        CancelledReleaseInfo.SetRange(Date, Date);
        If CancelledReleaseInfo.FindSet() then
            repeat
                CancelledReleaseInfo.Delete(true);
            until CancelledReleaseInfo.Next() = 0;
    end;

    procedure GetTimePeriodAndReleaseDeskDates(Desk: Record "Desk AGB")
    var
        FromDate: Date;
        ToDate: Date;
    begin
        if not GetTimePeriod(Desk, FromDate, ToDate) then
            exit;
        ReleaseDeskDates(Desk, FromDate, ToDate, false, false);
    end;

    procedure ReleaseFreeDesks(FromDate: Date; ToDate: Date)
    var
        MyReleaseFreeDesks: Codeunit ReleaseFreeDesksAGB;
    begin
        MyReleaseFreeDesks.Process(FromDate, ToDate);
    end;

    procedure GetTimePeriod(Desk: Record "Desk AGB"; var FromDate: Date; var ToDate: Date): Boolean;
    var
        MyGetTimePeriod: Codeunit GetTimePeriodAGB;
    begin
        exit(MyGetTimePeriod.Process(Desk, FromDate, ToDate));
    end;

    procedure ReleaseDeskDates(Desk: Record "Desk AGB"; FromDate: Date; ToDate: Date; SuspendUserCheck: Boolean; HideDialog: Boolean)
    var
        MyReleaseDeskDates: Codeunit "Release Desk Dates AGB";
    begin
        MyReleaseDeskDates.Process(Desk, FromDate, ToDate, SuspendUserCheck, HideDialog);
    end;

    procedure CancelReleasedDesks(var DeskDateStatus: Record "Desk Date Status AGB")
    var
        MyCancelReleasedDesks: Codeunit "Cancel Released Desks AGB";
    begin
        MyCancelReleasedDesks.Process(DeskDateStatus);
    end;

    procedure ReserveDesks(var DeskDateStatus: Record "Desk Date Status AGB")
    var
        MyReserveDesks: Codeunit "Reserve Desks AGB";
    begin
        MyReserveDesks.Process(DeskDateStatus);
    end;

    procedure CancelReservedDesks(var DeskDateStatus: Record "Desk Date Status AGB")
    var
        MyCancelReservedDesks: Codeunit "Cancel Reserved Desks AGB";
    begin
        MyCancelReservedDesks.Process(DeskDateStatus);
    end;
}