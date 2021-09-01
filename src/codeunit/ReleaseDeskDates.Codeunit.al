Codeunit 50354 "Release Desk Dates AGB"
{
    procedure Process(Desk: Record "Desk AGB"; FromDate: Date; ToDate: Date; SuspendUserCheck: Boolean; HideDialog: Boolean)
    var
        NoOfInsertedRecords: Integer;
        Handeled: Boolean;
    begin
        OnBeforeProcess(Desk, FromDate, ToDate, SuspendUserCheck, HideDialog, Handeled);
        if Handeled then
            exit;

        if not SuspendUserCheck then
            ErrorIfUserIsNotAllowedToRelease(Desk);

        ErrorIfFromDateBehindToDate(FromDate, ToDate);
        ErrorIfDeskIsBlocked(Desk);

        ReleaseDeskDates(Desk, FromDate, ToDate, NoOfInsertedRecords);

        if not HideDialog then
            Message(Text0003Msg, NoOfInsertedRecords);

        OnAfterProcess(Desk, FromDate, ToDate, SuspendUserCheck, HideDialog);
    end;

    local procedure ErrorIfUserIsNotAllowedToRelease(Desk: Record "Desk AGB")
    var
        DeskUser: Record "Desk User AGB";
    begin
        DeskUser.SetRange("User Name", UserId());
        DeskUser.SetRange("Flex Desk Administrator", true);
        If not DeskUser.IsEmpty then
            exit;

        If Desk."Regular User" <> '' then begin
            DeskUser.Get(Desk."Regular User");
            If (DeskUser."User Name" = UserId()) then
                exit;
        end;

        If Desk."Regular User" <> '' then
            Error(Text0001Err, Desk.Code, Desk."Regular User")
        else
            Error(Text0002Err, Desk.Code);

    end;

    local procedure ErrorIfFromDateBehindToDate(FromDate: Date; ToDate: Date);
    begin
        if (FromDate = 0D) and (ToDate = 0D) then
            Error(Text005Err);
        if FromDate = 0D then
            FromDate := ToDate;
        if ToDate = 0D then
            ToDate := FromDate;

        if FromDate > ToDate then
            Error(Text003Err, FromDate, ToDate);
        if FromDate < WorkDate() then
            Error(Text004Err);
    end;

    local procedure ErrorIfDeskIsBlocked(Desk: Record "Desk AGB")
    begin
        if Desk.Blocked then
            Error(Text006Err);
    end;

    local procedure ReleaseDeskDates(Desk: Record "Desk AGB"; FromDate: Date; ToDate: Date; var NoOfInsertedRecords: Integer)
    var
        Dates: Record Date;
    begin
        Dates.SetRange("Period Type", Dates."Period Type"::Date);
        Dates.SetRange("Period Start", FromDate, ToDate);
        Dates.SetRange("Period No.", 1, 5);
        If Dates.FindSet() then
            repeat
                ReleaseDeskDate(Desk, Dates."Period Start", NoOfInsertedRecords);
            until Dates.Next() = 0;
    end;

    local procedure ReleaseDeskDate(Desk: Record "Desk AGB"; MyDate: Date; var NoOfInsertedRecords: Integer)
    var
        DeskDateStatus: Record "Desk Date Status AGB";
        DeskDateStatusChangeLE: Record "Desk Date Status Change LE AGB";
    begin
        If not DeskDateStatus.Get(Desk."Code", MyDate) then begin
            DeskDateStatus.Validate("Desk Code", Desk.Code);
            DeskDateStatus.Validate(Date, MyDate);
            DeskDateStatus.Insert(true);
            NoOfInsertedRecords += 1;
        end;

        If DeskDateStatus.Status <> DeskDateStatus.Status::Reserved then begin
            DeskDateStatus.Validate("Status", DeskDateStatus.Status::Released);
            DeskDateStatus.Validate("Status Set At", CreateDateTime(WorkDate(), Time));
            DeskDateStatus.Validate("Status Set By", UserId());
            DeskDateStatus.Modify(true);
            DeskDateStatusChangeLE.InsertNewEntry(DeskDateStatus);
        end
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeProcess(Desk: Record "Desk AGB"; FromDate: Date; ToDate: Date; SuspendUserCheck: Boolean; HideDialog: Boolean; var Handled: Boolean);
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterProcess(Desk: Record "Desk AGB"; FromDate: Date; ToDate: Date; SuspendUserCheck: Boolean; HideDialog: Boolean);
    begin

    end;

    var
        Text0001Err: Label 'You are not allowed to release Desk %1. Only the Regular User %2 and the FlexDesk administrator are allowed.', comment = '%1 = Desk Code, %2 = Regular User Code';
        Text0002Err: Label 'You are not allowed to release Desk %1. Only the FlexDesk administrator is allowed.', comment = '%1 = Desk Code';
        Text003Err: Label 'The From Date %1 must not be behind To Date %2', comment = '%1 = FromDate, %2 = ToDate';
        Text004Err: Label 'From Date must be less Days than Work Date';
        Text005Err: Label 'From Date and To Date must not be blank';
        Text006Err: Label 'It is not allowed to release blocked Desks.';
        Text0003Msg: Label 'Desk is free for %1 new days.', comment = '%1 = number of released days';
}