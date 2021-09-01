codeunit 50358 "Cancel Reserved Desks AGB"
{
    procedure Process(Var DeskDateStatus: Record "Desk Date Status AGB")
    var
        NoOfUpdatedRecord: Integer;
        NoOfNotCancelled: Integer;
        NoOfNotCancelledWrongUser: Integer;
        DeskUserCode: Code[20];
        Handled: Boolean;
    begin
        OnBeforeProcess(DeskDateStatus, Handled);
        if Handled then
            exit;

        DeskUserCode := FindDeskUser();
        If DeskDateStatus.FindSet() then
            repeat
                if RecordIsValid(DeskDateStatus, NoOfnotCancelled, NoOfNotCancelledWrongUser, DeskUserCode) then
                    CancelReservedDeskDate(DeskDateStatus, NoOfUpdatedRecord);
            until DeskDateStatus.Next() = 0;

        Message(Text001Msg, NoOfUpdatedRecord);
        if NoOfnotCancelled > 0 then
            Message(Text002Msg, NoOfNotCancelled);

        if NoOfNotCancelledWrongUser > 0 then
            Message(Text003Msg, NoOfNotCancelledWrongUser);

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

    local procedure RecordIsValid(DeskDateStatus: Record "Desk Date Status AGB"; Var NoOfNotCancelled: Integer; Var NoOfNotCancelledWrongUser: Integer; DeskUserCode: Code[20]): Boolean
    var
        DeskUser: Record "Desk User AGB";
    begin
        if (DeskDateStatus.Status <> DeskDateStatus.Status::"Reserved") then begin
            NoOfNotCancelled += 1;
            exit(false);
        end;

        DeskUser.SetRange("User Name", UserId());
        DeskUser.SetRange("Flex Desk Administrator", true);
        if DeskUser.IsEmpty then
            if DeskUserCode <> DeskDateStatus."Reserved For" then begin
                NoOfNotCancelledWrongUser += 1;
                exit(false);
            end;

        exit(true);
    end;

    local procedure CancelReservedDeskDate(DeskDateStatus: Record "Desk Date Status AGB"; var NoOfUpdatedRecord: Integer)
    var
        DeskDateStatusChangeLE: Record "Desk Date Status Change LE AGB";
    begin
        NoOfUpdatedRecord += 1;
        DeskDateStatus.Validate("Status", DeskDateStatus.Status::"Reservation Cancelled");
        DeskDateStatus.Validate("Reserved For", '');
        DeskDateStatus.Validate("Status Set At", CreateDateTime(WorkDate(), Time));
        DeskDateStatus.Validate("Status Set By", UserId());
        DeskDateStatus.Modify(true);
        DeskDateStatusChangeLE.InsertNewEntry(DeskDateStatus);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeProcess(Var DeskDateStatus: Record "Desk Date Status AGB"; var Handled: Boolean);
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterProcess(Var DeskDateStatus: Record "Desk Date Status AGB");
    begin

    end;

    var
        Text001Msg: Label '%1 Dates have been cancelled', comment = '%1 = Dates';    
        Text002Msg: Label '%1 Dates have not been Cancelled, because of wrong Status', comment = '%1 Dates';
        Text003Msg: Label '%1 Dates have not been cancelled because You are not allowed', comment = '%1 =Dates';
}