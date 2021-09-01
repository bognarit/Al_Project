codeunit 50353 "Insert Desk Status LE AGB"
{
    procedure InsertNewEntry(DesksDatesStatus: Record "Desk Date Status AGB")
    Var
        StatusChangeLogEntry: Record "Desk Date Status Change LE AGB";
        Handled: Boolean;
    begin
        OnBeforeInsertNewEntry(DesksDatesStatus, Handled);
        if Handled then
            exit;

        StatusChangeLogEntry.Validate("Desk Code", DesksDatesStatus."Desk Code");
        StatusChangeLogEntry.Validate(Date, DesksDatesStatus.Date);
        StatusChangeLogEntry.Validate("New Status", DesksDatesStatus.Status);
        StatusChangeLogEntry.Validate("Status Set At", DesksDatesStatus."Status Set At");
        StatusChangeLogEntry.Validate("Status Set By", DesksDatesStatus."Status Set By");
        StatusChangeLogEntry.Insert(true);

        OnAfterInsertNewEntry(DesksDatesStatus, StatusChangeLogEntry);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertNewEntry(var DesksDatesStatus: Record "Desk Date Status AGB"; var Handled: Boolean);
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertNewEntry(var DesksDatesStatus: Record "Desk Date Status AGB"; StatusChangeLogEntry: Record "Desk Date Status Change LE AGB");
    begin

    end;
}