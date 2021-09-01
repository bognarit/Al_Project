table 50350 "Desk User AGB"
{
    DataClassification = CustomerContent;
    caption = 'Desk User';
    LookupPageId = "Desk Users AGB";
    DrillDownPageId = "Desk Users AGB";

    fields
    {
        field(1; "code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Name; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Name';
        }
        field(3; "User Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'User Name';
            TableRelation = User."User Name";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                UserSelection: Codeunit "User Selection";
            begin
                UserNameCanBeAssignedOnlyOnce();
                UserSelection.ValidateUserName("User Name");
            end;
        }
        field(4; "Flex Desk Administrator"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Flex Desk Administrator';
        }
        field(5; "No of Reserved Desk Dates"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count ("Desk Date Status AGB" where("Reserved For" = field(Code)));
            Caption = 'No of Reserved Desk Dates';
        }
        field(6; "Regular Desk"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup ("Desk AGB".Code where("Regular User" = field(code)));
            Caption = 'Regular Desk';
            Editable = false;
        }
        field(7; "No. Of Cancelled Released Info"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count ("Cancelled Release Info AGB" where("Reserved For" = field(Code)));
            Caption = 'No. Of Cancelled Released Info';
            Editable = false;
        }
    }
    keys
    {
        key(PK; code)
        {
            Clustered = true;
        }
        key(Key2; "User Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; code, Name)
        {
        }
    }

    trigger OnDelete()
    var
        DeskDateStatus: Record "Desk Date Status AGB";
        DeskUser: Record "Desk User AGB";
        Desk: Record "Desk AGB";
    begin

        DeskDateStatus.SetRange("Reserved For", Rec.code);
        if not DeskDateStatus.IsEmpty() then
            if Confirm(Text001Msg, false, DeskDateStatus.Count()) then
                DeskDateStatus.CancelReservedDesks(DeskDateStatus)
            else
                Error(Text002Err);

        Desk.SetRange("Regular User", Rec.code);
        if Desk.FindFirst() then begin
            Desk.Validate("Regular User", '');
            Desk.Modify(true)
        end;
    end;

    local procedure UserNameCanBeAssignedOnlyOnce()
    var
        DeskUser: Record "Desk User AGB";
    begin
        if "User Name" = '' then
            exit;
        DeskUser.SetRange("User Name", "User Name");
        DeskUser.SetFilter(code, '<>%1', code);
        if DeskUser.FindFirst() then
            Error(Text001Err, "User Name", DeskUser.code);
    end;

    procedure UserIsRegularUser(): Boolean
    var
        DeskUser: Record "Desk User AGB";
        Desk: Record "Desk AGB";
    begin
        DeskUser.SetRange("User Name", UserId());
        if DeskUser.IsEmpty() then
            exit(false);

        DeskUser.FindFirst();

        Desk.SetRange("Regular User", DeskUser.code);
        if Desk.IsEmpty() then
            exit(false);

        exit(true);
    end;

    procedure UserIsFlexDeskAdmin(): Boolean
    var
        DeskUser: Record "Desk User AGB";
    begin
        DeskUser.SetRange("User Name", UserId());
        if DeskUser.IsEmpty() then
            exit(false);

        DeskUser.FindFirst();

        if DeskUser."Flex Desk Administrator" then
            exit(true);

        exit(false);
    end;

    var
        Text001Msg: Label 'There are still %1 Reservations for this user. Do you want to delete anyway?', comment = '%1 = Number of reservations for this user';
        Text001Err: Label 'The username %1 can be set once only. Username is already set in desk user %2.', comment = ' %1 = user name, %2 = desk user code';
        Text002Err: Label 'User aborted delete procedure';
}