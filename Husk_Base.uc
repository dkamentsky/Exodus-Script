class Husk_Base extends Spector
placeable; //allows it to be placeable in editor







//this function triggers the husk possession
//its called in exodus info check there for rest of code
Exec Function HuskPossess()
{
local SpectorController PC; //stores player controller
local Pawn OldPawn; //stores the current pawn possed by player controller
local float HuskHealth; //stores the husks health

    `log ("Old Pawn PC got");
    
    PC = SpectorController(GetALocalPlayerController()); //finds the player in the scene and stores it
    

        `log ("distance check pass");
        
        HuskHealth = self.health; //finds the health of current pawn and stores it this is to make sure the pawn keeps its health
    
        OldPawn = PC.Pawn;  //gets the players pawn and stores it

        `log ("final possess");
        
        if(Husk_Base(OldPawn) == none)  //checks to see that player currently is not in a husk
        {
            
            PC.UnPossess(); //Command to get player to unpossess there current pawn
                
            OldPawn.Destroy();  //destroys the pawn player was possessing
                
            PC.Possess(Self, false); //player possess this pawn
                
            Self.Health = HuskHealth; //sets the husks health so it doesn't change durring possession
                
            `log ("func fin");
        }
        Else
        {
            `log ("Husk Possess fail");
        }
        
}





// this is simply to overid spec burn function called in spector class
function specburn()
{
return;
}

    
    
defaultproperties
{
    Begin Object Name=WPawnSkeletalMeshComponent
        bOwnerNoSee=false
        AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
        SkeletalMesh=SkeletalMesh'SK_CH_LIAM_Cathode'
        AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
        PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
    End Object
    Name="Default__Husk_Base"
}