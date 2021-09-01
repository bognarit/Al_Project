table 50356 "Cancelled Release Info AGB"
{
    DataClassification = CustomerContent;
    Caption = 'Cancelled Release Info';
    DrillDownPageId = "Cancelled Release Info AGB";

    fields
    {
        field(1; "Reserved For"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Desk User AGB";
            Caption = 'Reserved for';
        }
        field(2; "Desk Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Desk AGB";
            Caption = 'Desk Code';
        }
        field(3; "Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date';
        }
        field(4; Status; enum "Status Desk AGB")
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
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
        }
        field(7; "Regular User"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup ("Desk AGB"."Regular User" where(code = field("Desk Code")));
            Caption = 'Regular User';
        }
    }

    keys
    {
        key(PK; "Reserved For", "Desk Code", Date)
        {
            Clustered = true;
        }
    }

    procedure InsertNewEntry(NewDesksDatesStatus: Record "Desk Date Status AGB"; OldDesksDatesStatus: Record "Desk Date Status AGB")
    var
        InsertCancelledReleaseInfo: Codeunit "InsertCancelledReleaseInfoAGB";
    begin
        InsertCancelledReleaseInfo.InsertNewEntry(NewDesksDatesStatus, OldDesksDatesStatus);
    end;
}