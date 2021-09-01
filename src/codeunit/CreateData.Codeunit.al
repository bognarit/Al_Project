codeunit 50350 "Create Data AGB"
{
    trigger OnRun()
    var
        Handled: Boolean;
    begin
        OnBeforeCreateData(Handled);
        if Handled then
            exit;

        CreateRooms();
        CreateDeskUsers();
        CreateDesks();

        OnAfterCreateData();
    end;

    local procedure CreateRooms()
    begin
        CreateRoom('HAM', 'Hamburg');
        CreateRoom('BUD', 'Budapest');
        CreateRoom('ROM', 'Rom');
    end;

    local procedure CreateRoom(MyCode: Code[20]; MyDescription: Text[100])
    var
        Room: Record "Room AGB";
    begin
        if not Room.Get(MyCode) then begin
            Room.Validate(Code, MyCode);
            Room.Insert(true);
        end;
        Room.Validate(Description, MyDescription);
        Room.Modify(true);
    end;

    local procedure CreateDeskUsers()
    begin
        CreateDeskUser('ABO', 'Akos Bognar');
        CreateDeskUser('HZI', 'Hans Zimmer');
        CreateDeskUser('EMI', 'Ewelina Miller');
        CreateDeskUser('CSC', 'Christian Schmidt');
        CreateDeskUser('SHE', 'Stefan Herrmann');
        CreateDeskUser('MWA', 'Michael Wagner');
        CreateDeskUser('KKL', 'Kristina Klein');
        CreateDeskUser('SSC', 'Stefan Schutz');
    end;
    local procedure CreateDeskUser(MyCode: Code[20]; MyName: Text[100])
    Var
        DeskUser: Record "Desk User AGB";
        User: Record User;
        UserName: Text[50];
        PosOfFirstSpace: Integer;
    begin
        if not DeskUser.Get(MyCode) then begin
            DeskUser.Validate(Code, MyCode);
            DeskUser.Insert(true);
        end;
        DeskUser.Validate(Name, MyName);
        DeskUser.Modify(true);

        PosOfFirstSpace := StrPos(DeskUser.Name, ' ');
        if PosOfFirstSpace <> 0 then begin
            UserName := 'AGILES\';
            UserName += CopyStr(DeskUser.Name, 1, PosOfFirstSpace - 1);
            UserName += '.';
            UserName += CopyStr(DeskUser.Name, PosOfFirstSpace + 1);

            User.SetRange("User Name", UserName);
            if not User.IsEmpty() then begin
                DeskUser.Validate("User Name", UserName);
                DeskUser.Modify(true);
            end;
        end;
    end;

    local procedure CreateDesks()
    begin
        CreateDesk('H01', 'HAM', 'ABO');
        CreateDesk('H02', 'HAM', '');
        CreateDesk('B01', 'BUD', 'SHE');
        CreateDesk('B02', 'BUD', '');
        CreateDesk('B03', 'BUD', 'KKL');
        CreateDesk('R01', 'ROM', 'HZI');
        CreateDesk('R02', 'ROM', '');
        CreateDesk('R03', 'ROM', 'SSC');
    End;

    local procedure CreateDesk(MyCode: Code[20]; MyRoomCode: Code[20]; MyRegularUser: Code[20])
    var
        Desk: Record "Desk AGB";
    begin
        if not Desk.Get(MyCode) then begin
            Desk.Validate(Code, MyCode);
            Desk.Insert(true);
        end;
        Desk.Validate("Room Code", MyRoomCode);
        Desk.Validate("Regular User", MyRegularUser);
        Desk.modify(true);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateData(var Handled: Boolean);
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateData();
    begin

    end;
}