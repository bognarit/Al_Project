pageextension 50350 "Order Processor RC AGB" extends "Order Processor Role Center"
{
    actions
    {
        addlast(sections)
        {

            group("Flex Desk AGB")
            {
                Caption = 'Flex Desk';

                group(SetupAGB)
                {
                    Caption = 'Setup';

                    action("Create Data AGB")
                    {
                        RunObject = codeunit "Create Data AGB";                        
                        ApplicationArea = All;
                        Caption = 'Create Data';
                        ToolTip = 'Click to create Data';
                    }

                    action("Desk AGB")
                    {
                        RunObject = Page "Desks AGB";
                        ApplicationArea = All;
                        Caption = 'Desks';
                        ToolTip = 'Show Desks';
                    }

                    action("Desk User AGB")
                    {
                        RunObject = Page "Desk Users AGB";
                        ApplicationArea = All;
                        Caption = 'Desk Users';
                        ToolTip = 'Show Desk Users';
                    }
                    
                    action("Room AGB")
                    {
                        RunObject = Page "Rooms AGB";
                        ApplicationArea = All;
                        Caption = 'Rooms';
                        ToolTip = 'Show Rooms';
                    }
                }
                
                action("Find DesksAGB")
                {
                    RunObject = Page "Desk Date Status AGB";
                    ApplicationArea = All;
                    Caption = 'Find Desks';
                    ToolTip = 'Click to find a free desk';
                }                
            }
        }
    }
}