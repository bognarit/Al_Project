table 50351 "Room AGB"
{
    DataClassification = CustomerContent;
    Caption = 'Room';
    LookupPageId = "Rooms AGB";
    DrillDownPageId = "Rooms AGB";

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
    }
    
    keys
    {
        key(PK; code)
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        Desk: Record "Desk AGB";
    begin
        Desk.SetRange("Room Code", Code);
        If not Desk.IsEmpty then
            If Desk.FindSet() then
                repeat
                    Desk.Delete(true);
                until Desk.Next() = 0;
    end;
}