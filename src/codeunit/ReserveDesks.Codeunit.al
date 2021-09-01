codeunit 50351 "Reserve Desks AGB"
{
    procedure Process(Var DeskDateStatus: Record "Desk Date Status AGB")
    var
        DeskUserCode: Code[20];
        NoOfNotReservedDeskDates: Integer;
        NoOfNotReservedDeskDatesWrongStatus: Integer;
        NoOfUpdatedRecord: Integer;
        Handled: Boolean;
    begin
        OnBeforeProcess(DeskDateStatus, Handled);
        if Handled then
            exit;

        DeskUserCode := FindDeskUser();
        ErrorIfUserIsNotAllowedToReserve(DeskUserCode);

        If DeskDateStatus.FindSet() then
            repeat
                if RecordIsValid(DeskDateStatus, DeskUserCode, NoOfNotReservedDeskDates, NoOfNotReservedDeskDatesWrongStatus) then
                    ReserveDeskDate(DeskDateStatus, NoOfUpdatedRecord, DeskUserCode);
            until DeskDateStatus.Next() = 0;

        Message(Text001Msg, NoOfUpdatedRecord);
        if NoOfNotReservedDeskDates > 0 then
            Message(Text002Msg, NoOfNotReservedDeskDates);
        if NoOfNotReservedDeskDatesWrongStatus > 0 then
            Message(Text003Msg, NoOfNotReservedDeskDatesWrongStatus);

        OnAfterProcess(DeskDateStatus);
    end;

    procedure FindDeskUser(): Code[20]
    var
        DeskUser: Record "Desk User AGB";
    begin
        DeskUser.SetRange("User Name", UserId());
        if DeskUser.FindFirst() then
            exit(DeskUser.code);

        exit('');
    end;

    local procedure ErrorIfUserIsNotAllowedToReserve(DeskUserCode: Code[20])
    var
        Desk: Record "Desk AGB";
    begin
        if DeskUserCode = '' then
            Error(Text002Err, UserId());

        Desk.SetRange("Regular User", DeskUserCode);
        if Desk.FindFirst() then begin
            Desk.CalcFields("Regular User Name");
            Error(Text001Err, Desk."Regular User Name", Desk.Code);
        end;
    end;

    local procedure RecordIsValid(DeskDateStatus: Record "Desk Date Status AGB"; DeskUserCode: Code[20]; Var NoOfNotReservedDeskDates: Integer; Var NoOfNotReservedDeskDatesWrongStatus: Integer): Boolean
    var
        DeskDateStatus2: Record "Desk Date Status AGB";
    begin
        if (DeskDateStatus.Status = DeskDateStatus.Status::"Reserved")
         or (DeskDateStatus.Status = DeskDateStatus.Status::"Released Cancelled") then begin
            NoOfNotReservedDeskDatesWrongStatus += 1;
            exit(false);
        end;

        DeskDateStatus2.SetRange(Date, DeskDateStatus.Date);
        DeskDateStatus2.SetRange("Reserved For", DeskUserCode);
        if not DeskDateStatus2.IsEmpty then begin
            NoOfNotReservedDeskDates += 1;
            exit(false);
        end;
        exit(true);
    end;

    local procedure ReserveDeskDate(DeskDateStatus: Record "Desk Date Status AGB"; var NoOfUpdatedRecord: Integer; DeskUserCode: Code[20])
    var
        DeskDateStatusChangeLE: Record "Desk Date Status Change LE AGB";
        CancelledReleaseInfo: Record "Cancelled Release Info AGB";
    begin
        NoOfUpdatedRecord += 1;
        DeskDateStatus.Validate("Status", DeskDateStatus.Status::Reserved);
        DeskDateStatus.Validate("Reserved For", DeskUserCode);
        DeskDateStatus.Validate("Status Set At", CreateDateTime(WorkDate(), Time));
        DeskDateStatus.Validate("Status Set By", UserId());
        DeskDateStatus.Modify(true);
        DeskDateStatusChangeLE.InsertNewEntry(DeskDateStatus);

        CancelledReleaseInfo.SetRange("Reserved For", DeskUserCode);
        CancelledReleaseInfo.SetRange(Date, DeskDateStatus.Date);
        if not CancelledReleaseInfo.IsEmpty then
            CancelledReleaseInfo.DeleteAll(true);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeProcess(var DeskDateStatus: Record "Desk Date Status AGB"; var Handled: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterProcess(var DeskDateStatus: Record "Desk Date Status AGB")
    begin

    end;

    var
        Text001Err: Label 'You %1 are Regular User of Desk %2 and not allowed to reserve other Desks', comment = '%1 = User Name, %2 Desk Code';
        Text002Err: Label 'The User ID %1 is not assigned to a Desk User. You are not allowed to reserve Desks.', comment = '%1 = User ID';
        Text001Msg: Label 'Desk is reserved for %1 new days.', comment = '%1 = number of reserved days';
        Text002Msg: Label '%1 Desk Dates have not been reserved, because you alreadey reserved other desks', comment = '%1 = No Of Not Reserved Desk Dates';
        Text003Msg: Label '%1 Desk Dates have not been reserved, because of wrong status', comment = '%1 = No Of Not Reserved Desk Dates';
}