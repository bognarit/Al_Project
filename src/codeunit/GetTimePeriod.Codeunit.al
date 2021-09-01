codeunit 50357 "GetTimePeriodAGB"
{
    procedure Process(Desk: Record "Desk AGB"; var FromDate: Date; var ToDate: Date): Boolean;
    var
        ReleaseDeskDatesPage: Page "Release Desk Dates AGB";
        Handled: Boolean;
    begin
        OnBeforeProcess(Desk, FromDate, ToDate, Handled);
        if Handled then
            exit(true);
        ReleaseDeskDatesPage.SetData(Desk);
        ReleaseDeskDatesPage.LookupMode(true);
        if ReleaseDeskDatesPage.RunModal() <> Action::LookupOK then
            exit(false);
        ReleaseDeskDatesPage.GetInformation(FromDate, ToDate);
        ErrorIfFromDateBehindToDate(FromDate, ToDate);
        OnAfterprocess(Desk, FromDate, ToDate);
        exit(true);
    end;

    local procedure ErrorIfFromDateBehindToDate(FromDate: Date; ToDate: Date);
    begin
        if (FromDate = 0D) and (ToDate = 0D) then
            Error(Text003Err);
        if FromDate = 0D then
            FromDate := ToDate;
        if ToDate = 0D then
            ToDate := FromDate;

        if FromDate > ToDate then
            Error(Text001Err, FromDate, ToDate);
        if FromDate < WorkDate() then
            Error(Text002Err);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeProcess(Desk: Record "Desk AGB"; var FromDate: Date; var ToDate: Date; var Handled: Boolean);
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterprocess(Desk: Record "Desk AGB"; var FromDate: Date; var ToDate: Date);
    begin

    end;

    var
        Text001Err: Label 'The From Date %1 must not be behind To Date %2', comment = '%1 = FromDate, %2 = ToDate';
        Text002Err: Label 'From Date must be less Days than Work Date';
        Text003Err: Label 'From Date and To Date must not be blank';
}