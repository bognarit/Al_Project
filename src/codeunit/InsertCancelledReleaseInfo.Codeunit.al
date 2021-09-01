codeunit 50356 "InsertCancelledReleaseInfoAGB"
{
    procedure InsertNewEntry(NewDesksDatesStatus: Record "Desk Date Status AGB"; OldDesksDatesStatus: Record "Desk Date Status AGB")
    Var
        CancelledReleaseInfo: Record "Cancelled Release Info AGB";
        Handled: Boolean;
    begin

        OnBeforeInsertNewEntry(NewDesksDatesStatus, OldDesksDatesStatus, Handled);
        if Handled then
            exit;

        if not CancelledReleaseInfo.Get(OldDesksDatesStatus."Reserved For", NewDesksDatesStatus."Desk Code", NewDesksDatesStatus.Date) then begin
            CancelledReleaseInfo.Validate("Reserved For", OldDesksDatesStatus."Reserved For");
            CancelledReleaseInfo.Validate("Desk Code", NewDesksDatesStatus."Desk Code");
            CancelledReleaseInfo.Validate(Date, NewDesksDatesStatus.Date);
            CancelledReleaseInfo.Insert(true);
        end;

        CancelledReleaseInfo.Validate(Status, NewDesksDatesStatus.Status);
        CancelledReleaseInfo.Validate("Status Set At", NewDesksDatesStatus."Status Set At");
        CancelledReleaseInfo.Validate("Status Set By", NewDesksDatesStatus."Status Set By");
        CancelledReleaseInfo.Modify(true);

        OnAfterInsertNewEntry(NewDesksDatesStatus, OldDesksDatesStatus, CancelledReleaseInfo);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertNewEntry(NewDesksDatesStatus: Record "Desk Date Status AGB"; OldDesksDatesStatus: Record "Desk Date Status AGB"; var Handled: Boolean);
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertNewEntry(NewDesksDatesStatus: Record "Desk Date Status AGB"; OldDesksDatesStatus: Record "Desk Date Status AGB"; CancelledReleaseInfo: Record "Cancelled Release Info AGB");
    begin

    end;
}