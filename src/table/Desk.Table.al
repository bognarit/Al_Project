table 50353 "Desk AGB"
{
    DataClassification = CustomerContent;
    Caption = 'Desk';
    LookupPageId = "Desks AGB";
    DrillDownPageId = "Desks AGB";

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; "Room Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Room Code';
            TableRelation = "Room AGB";
            NotBlank = true;

            trigger OnValidate()
            begin
                CalcFields("Room Description");
            end;
        }
        field(3; "Room Description"; Text[100])
        {
            Caption = 'Room Description';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup("Room AGB".Description where(code = field("Room Code")));
        }
        field(4; "Regular User"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Regular User';
            TableRelation = "Desk User AGB";

            trigger OnValidate()
            begin
                ErrorIfRegularUserIsExistOnOtherDesk();
                ErrorIfDeskUserhasFutureReservations();
                ErrorIfDeskhasFutureReservations();
                CalcFields("Regular User Name");
            end;
        }
        field(5; "Regular User Name"; Text[100])
        {
            Caption = 'Regular User Name';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup ("Desk User AGB"."Name" where(Code = field("Regular User")));
        }

        field(6; Blocked; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Blocked';

            trigger OnValidate()
            begin
                ErrorIfUserIsNotAdministrator();
                ErrorIfFutureReleasedDeskDatesExist();
            end;
        }
    }
    keys
    {
        key(Pk; Code)
        {
            Clustered = true;
        }
        key(key2; "Regular User")
        {
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; code, "Room Code")
        {
        }
        fieldgroup(Brick; code, "Room Description", "Regular User Name")
        {
        }
    }
    
    trigger OnDelete()
    var
        DeskDateStatus: Record "Desk Date Status AGB";
    begin
        DeskDateStatus.SetRange("Desk Code", Code);
        If DeskDateStatus.FindSet() then
            repeat
                DeskDateStatus.Delete(true);
            until DeskDateStatus.Next() = 0;
    end;

    local procedure ErrorIfRegularUserIsExistOnOtherDesk()
    var
        Desk: Record "Desk AGB";
    begin
        if "Regular User" = '' then
            exit;

        Desk.SetRange("Regular User", "Regular User");
        Desk.SetFilter("Code", '<>%1', "Code");
        if Desk.FindFirst() then
            Error(Text001Err, Desk."Code");
    end;

    local procedure ErrorIfDeskUserhasFutureReservations()
    Var
        DeskDateStatus: Record "Desk Date Status AGB";
    begin
        if "Regular User" = '' then
            exit;
            
        DeskDateStatus.SetRange("Reserved For", "Regular User");
        DeskDateStatus.SetRange(Status, DeskDateStatus.Status::Reserved);
        DeskDateStatus.SetFilter(Date, '>= %1', WorkDate());
        if DeskDateStatus.IsEmpty then
            exit;
        Error(Text004Err);
    end;

    local procedure ErrorIfDeskhasFutureReservations()
    Var
        DeskDateStatus: Record "Desk Date Status AGB";
    begin
        if "Regular User" = '' then
            exit;
        DeskDateStatus.SetRange("Desk Code", Code);
        DeskDateStatus.SetRange(Status, DeskDateStatus.Status::Reserved);
        DeskDateStatus.SetFilter(Date, '>= %1', WorkDate());
        if DeskDateStatus.IsEmpty then
            exit;
        Error(Text005Err);
    end;

    local procedure ErrorIfUserIsNotAdministrator()
    var
        DeskUser: Record "Desk User AGB";
    begin
        if not DeskUser.UserIsFlexDeskAdmin() then
            Error(Text002Err, UserId());
    end;

    local procedure ErrorIfFutureReleasedDeskDatesexist()
    var
        DeskDateStatus: Record "Desk Date Status AGB";
        Status: Enum "Status Desk AGB";
    begin
        if not Blocked then
            exit;
        DeskDateStatus.SetRange("Desk Code", Code);
        DeskDateStatus.SetFilter(Date, '>= %1', WorkDate());
        DeskDateStatus.SetFilter(Status, '%1|%2', Status::Released, Status::Reserved);

        if not DeskDateStatus.IsEmpty then
            Error(Text003Err);
    end;

    var
        Text001Err: Label 'You can not insert the same User on multible desks. User is already inserted on desk %1.', comment = '%1 = Desk Code';
        Text002Err: Label 'You %1 are not an administrator, therefore you can not block or unblock desks.', comment = '%1 = Username';
        Text003Err: Label 'You cannot block this Desk because future reservations and/or releases have been made for this Desk. You will have to cancel them first.';
        Text004Err: Label 'Desk User with future reserves can not set as Regular User. Please cancel reservation first.';
        Text005Err: Label 'On a Desk with future reserves you can not set Regular User. Please cancel reservation first.';
}