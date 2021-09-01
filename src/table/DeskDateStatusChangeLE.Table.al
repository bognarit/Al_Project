table 50357 "Desk Date Status Change LE AGB"
{
    DataClassification = CustomerContent;
    Caption = 'Desk Date Status Change Log Entry';
    DrillDownPageId = "Desk Dates St. Change LE AGB";

    fields
    {
        field(1; "Desk Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Desk AGB";
            Caption = 'Desk Code';
            NotBlank = true;
        }
        field(2; "Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date';
        }
        field(3; "Entry No"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No';
            AutoIncrement = true;
        }
        field(4; "New Status"; enum "Status Desk AGB")
        {
            DataClassification = CustomerContent;
            Caption = 'New Status';
        }
        field(5; "Status Set At"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Status Set At';
        }
        field(6; "Status Set By"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Status Set By';
            TableRelation = User."User Name";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                UserSelection: Codeunit "User Selection";
            begin
                UserSelection.ValidateUserName("Status Set By");
            end;
        }
    }

    keys
    {
        key(PK; "Desk Code", Date, "Entry No")
        {
            Clustered = true;
        }
    }

    procedure InsertNewEntry(DeskDateStatus: Record "Desk Date Status AGB")
    Var
        InsertDeskStatusLogEntry: Codeunit "Insert Desk Status LE AGB";
    begin
        InsertDeskStatusLogEntry.InsertNewEntry(DeskDateStatus);
    end;
}