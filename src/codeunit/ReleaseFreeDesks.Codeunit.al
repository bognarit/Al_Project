codeunit 50352 "ReleaseFreeDesksAGB"
{
    procedure Process(FromDate: Date; ToDate: Date)
    var
        NoOfInsertedRecords: Integer;
        Handled: Boolean;
    begin
        OnBeforeProcess(FromDate, ToDate, Handled);
        if Handled then
            exit;
        ReleaseFreeDesks(FromDate, ToDate);
        OnAfterProcess(FromDate, ToDate);
    end;

    local procedure ReleaseFreeDesks(FromDate: Date; ToDate: Date)
    var
        Desk: Record "Desk AGB";
    begin
        Desk.SetRange(Blocked, false);
        Desk.SetRange("Regular User", '');
        if Desk.FindSet() then
            repeat
                ReleaseFreeDesk(Desk, FromDate, ToDate);
            until Desk.Next() = 0;
    end;

    local procedure ReleaseFreeDesk(Desk: Record "Desk AGB"; FromDate: Date; ToDate: Date)
    var
        DeskDateStatus: Record "Desk Date Status AGB";
    begin
        DeskDateStatus.ReleaseDeskDates(Desk, FromDate, ToDate, true, true);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeProcess(FromDate: Date; ToDate: Date; Var Handled: Boolean);
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterProcess(FromDate: Date; ToDate: Date);
    begin

    end;
}