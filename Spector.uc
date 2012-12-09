class Spector extends UTPawn;

var int INTspecburn;
var Pawn Host; 

//function called to start spec burn once possessed
event PossessedBy(Controller C, bool bVehicleTransition)
{
    super.PossessedBy(C, bVehicleTransition);   //this is simply made so that it doesn't overide the prevously defined function
    specburn(); //calls the specburn function

}

//function called to simulate spector disapating into environment
//does a set amount of damage defined in default properties as Intspecburn
function specburn()
{    

        self.TakeDamage(INTspecburn, none, self.Location, vect(0,0,1) ,class'DamageType', , );  //deals damage to self defined in spec burn and pushes the player bake and does damagetype
        SetTimer (1, true,'SpecBurn'); //after 1 second repeat specburn
}

defaultproperties
{
    Begin Object Name=WPawnSkeletalMeshComponent
        bOwnerNoSee=false
        AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
        SkeletalMesh=SkeletalMesh'SK_CH_LIAM_Cathode'
        AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
        PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
        LightEnvironment=MyLightEnvironment
    End Object
    Mesh=WPawnSkeletalMeshComponent
    Components.Add(WPawnSkeletalMeshComponent)
    Intspecburn=5


    Name="Default__Spector"
}