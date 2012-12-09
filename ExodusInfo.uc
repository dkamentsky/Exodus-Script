class ExodusInfo extends UTGame;

var pawn Spector;






//func to fnind playercontroller and the husk in the vicinity of it
//the reason this is in info is that input functions cann't be called in the player class and its the easiest way to tie the pawn to the controller and its pawn
//HuskCheck is tied to an input command in the defualtinput ini file
Exec Function HuskCheck()
{
local SpectorController PC; //stores local player controller 
local Husk_Base HuskToPossess;  //stores the husk
local vector l; //stores the location of player controller pawn
local Pawn P; //stores the players controller pawn
local float rad;    //radius to check in

    `log ("husk check");

    
    PC = SpectorController(GetALocalPlayerController()); //find the player in the scene
    
    `log (PC @ "PC got");

    //distance to check
    rad = 128.0; //sets the radduies to check for husks in
    
    P = PC.Pawn; //stores the player controllers pawn
    
    l = P.location;
    
    foreach VisibleActors(class'Husk_Base', HuskToPossess, rad ,l){ //itterator function which finds the vissable actors within a sertain raduis called to find husks nerby
        `log (HuskToPossess @ "husk checked");
        `log("iterated");
        HuskToPossess.HuskPossess(); //calls the husk possess function in the nerby husk see husk_base for rest of code
    }
  
}





function Pawn SpawnDefaultPawnFor(Controller NewPlayer, NavigationPoint StartSpot)
{
    local class<Pawn> DefaultPlayerClass;
    local Rotator StartRotation;
    local Pawn ResultPawn;

    DefaultPlayerClass = GetDefaultPlayerClass(NewPlayer);

    // don't allow pawn to be spawned with any pitch or roll
    StartRotation.Yaw = StartSpot.Rotation.Yaw;

    ResultPawn = Spawn(DefaultPlayerClass,,,StartSpot.Location,StartRotation);
    if ( ResultPawn == None )
    {
        `log("Couldn't spawn player of type "$DefaultPlayerClass$" at "$StartSpot);
    }
    Spector = ResultPawn;
    return ResultPawn;
}

//function to leave the curent husk
//The function finds the player determines weather its in a husk then spawns a new husk and tells the player to leave theres and pocess the new one
//HuskCheck is tied to an input command in the defualtinput ini file
Exec Function specjump()
{
local SpectorController   PC;
local pawn                      PlayerPawn;    //holds the player pawn
local vector                    L;  //holds player pawn location
local rotator                   r;  //holds player pawn rotation
local pawn                      p;  //used to spawn new pawn
local vector                    dis;    //distanced used to offset new pawn spawn
local vector                    hitlocation, hitnormal; //used in trace function
local vector                    end;    //end location of pawn to spawn

    PC = SpectorController(GetALocalPlayerController());    //finds the player controller (PC)
    PlayerPawn = PC.pawn;    //stores PC (player controller pawn)
    `log ("pawn got"); //logs the function has been called
    
    If(PlayerPawn != none) //check to make sure the controller is in possesion of a pawn
    {
        `log ("pawn not none");
        If(PlayerPawn != Spector) //checks to see if the player is allready a spector
        {    
        
            `log ("pawn not spec");
            
            //distance pawn spawns away from player
            dis=vect(128,0,0);
            
            r = PlayerPawn.rotation; //store PC.pawn rotation
            
            L = PlayerPawn.Location; //store PC.pawn location
                    
            p = PlayerPawn;     //temporarly stores the playerpawn idk why but it works
            
            TransformVectorByRotation( PlayerPawn.rotation , dis, false ); //rotates the dis world vector according to the pawns local rotation
            
            if(r.yaw >= 0)  // this if statement is just to determine weather we should subtract or add controlling weather the new pawn spawns infront or behind us
            {
                End = L + dis;            
            }
            Else
            {            
                End = L - dis;
            }       
                
            Trace(HitLocation, HitNormal, End, l); //trace from PC.pawn location to the point where we spawn the new pawn
            
            if(Vsize(HitLocation - L) <=128) //if the trace hit something 128 units close don't spawn and cancel function note the units should match the dis variable above
            {    
                return;
            }
            else
            {
                `log ("expel spector");
                
                PC.UnPossess(); //player leaves old pawn
            
                PlayerPawn = none; //again don't know why but it works
                
                p = Spawn(Class'spector',,,End,r); //this command spawns the new pawn and stores it under p

                PC.Possess(p, false); //this causes the player to possess the new pawn

                Spector = p; //this states the new pawn is a spector
            }
        }
        Else
        {
            return;
        }
    }
}



    
defaultproperties
{    
    PlayerControllerClass=class'SpectorController'
    DefaultPawnClass=class'spector'
    Name="Default__ExodusInfo"
}