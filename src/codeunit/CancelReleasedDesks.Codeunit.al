codeunit 50359 "Cancel Released Desks AGB"
{
    procedure Process(Var DeskDateStatus: Record "Desk Date Status AGB")
    var
        NoOfUpdatedRecord: Integer;
        NoOfNotCancelled: Integer;
        NoOfNotCancelledWrongUser: Integer;
        Handled: Boolean;
    begin
        OnBeforeProcess(DeskDateStatus, Handled);
        if Handled then
            exit;
        If DeskDateStatus.FindSet() then
            repeat
                if RecordIsValid(DeskDateStatus, NoOfnotCancelled, NoOfNotCancelledWrongUser) then
                    CancelRelease(DeskDateStatus, NoOfUpdatedRecord);
            until DeskDateStatus.Next() = 0;

        Message(Text001Msg, NoOfUpdatedRecord);
        if NoOfnotCancelled > 0 then
            Message(Text002Msg, NoOfNotCancelled);

        if NoOfNotCancelledWrongUser > 0 then
            Message(Text003Msg, NoOfNotCancelledWrongUser);
        OnAfterProcess(DeskDateStatus);
    end;

    local procedure RecordIsValid(DeskDateStatus: Record "Desk Date Status AGB"; Var NoOfNotCancelled: Integer; Var NoOfNotCancelledWrongUser: Integer): Boolean
    var
        DeskUser: Record "Desk User AGB";
        Desk: Record "Desk AGB";
    begin
        if DeskDateStatus.Status = DeskDateStatus.Status::"Released Cancelled" then begin
            NoOfNotCancelled += 1;
            exit(false);
        end;

        DeskUser.SetRange("User Name", UserId());
        DeskUser.SetRange("Flex Desk Administrator", true);
        If not DeskUser.IsEmpty then
            exit(true);

        Desk.Get(DeskDateStatus."Desk Code");
        If Desk."Regular User" <> '' then begin
            DeskUser.Get(Desk."Regular User");
            If (DeskUser."User Name" = UserId()) then
                exit(true);
        end;

        NoOfNotCancelledWrongUser += 1;
        exit(false);
    end;

    local procedure CancelRelease(DeskDateStatus: Record "Desk Date Status AGB"; var NoOfUpdatedRecord: Integer)
    Var
        DeskDateStatusChangeLE: Record "Desk Date Status Change LE AGB";
        CancelledReleaseInfo: Record "Cancelled Release Info AGB";
        OldDeskDateStatus: Record "Desk Date Status AGB";
    begin
        OldDeskDateStatus := DeskDateStatus;

        DeskDateStatus.Validate(Status, DeskDateStatus.Status::"Released Cancelled");
        DeskDateStatus.Validate("Reserved For", '');
        DeskDateStatus.Validate("Status Set At", CreateDateTime(WorkDate(), Time));
        DeskDateStatus.Validate("Status Set By", UserId());
        DeskDateStatus.Modify(true);
        DeskDateStatusChangeLE.InsertNewEntry(DeskDateStatus);
        NoOfUpdatedRecord += 1;

        if OldDeskDateStatus.Status = OldDeskDateStatus.Status::Reserved then 
            CancelledReleaseInfo.InsertNewEntry(DeskDateStatus, OldDeskDateStatus);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeProcess(Var DeskDateStatus: Record "Desk Date Status AGB"; Var Handled: Boolean);
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterProcess(Var DeskDateStatus: Record "Desk Date Status AGB");
    begin

    end;

    var
        Text001Msg: Label '%1 Released Dates have been cancelled', comment = '%1 = Number of released cancellation days';    
        Text002Msg: Label '%1 Dates have not been Cancelled, because of wrong Status', comment = '%1 = Dates';
        Text003Msg: Label '%1 Dates have not been cancelled because You are not allowed', comment = '%1 = No of Not released Cancellation Days';
}