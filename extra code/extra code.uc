local float         pit;
local float         endX;
local float         endY;
local float            endZ;
local vector        end;    
            

            pit = r.Pitch;

            endZ = l.Z;
            
            endX = (sin(pit) * dis) + l.X;
            
            endY = (cos(pit) * dis) + l.Y;
            
            end.X=endX;
            
            end.Y=endY;
            
            end.Z=endZ;
            
            /** variable code for camera found at http://allarsblog.com/2010/03/creating-a-third-person-camera/
*/
var vector CameraTranslateScale; //Used to Offset our Camera;
var bool bThirdPerson; //Used to toggle our third person camera;


event PossessedBy(Controller C, bool bVehicleTransition)
{
    super.PossessedBy(C, bVehicleTransition);
    specburn();
}

//code by allar's awsome blog at ---> http://allarsblog.com/2010/03/creating-a-third-person-camera/

simulated event BecomeViewTarget(PlayerController PC)
{
   local UTPlayerController UTPC;

   Super.BecomeViewTarget(PC);

   if (LocalPlayer(PC.Player) != None)
   {
      UTPC = UTPlayerController(PC);
      if (UTPC != None)
      {
         //set player controller to behind view and make mesh visible
         UTPC.SetBehindView(true);
         SetMeshVisibility(UTPC.bBehindView);
      }
    }
    HideMesh(!bThirdPerson);
}
 
exec function CycleCamera()
{
    bThirdPerson = !bThirdPerson;
    HideMesh(!bThirdPerson);
}
 
simulated function HideMesh(bool Invisible)
{
    if ( LocalPlayer(PlayerController(Controller).Player) != None )
    mesh.SetHidden(Invisible);
}
 
simulated function bool CalcCamera(float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV)
{
// Reference from http://forums.epicgames.com/showthread.php?t=709356
// And CalcThirdPersonCamera in UTPawn.uc
local vector CamStart, HitLocation, HitNormal, CamDir, X, Y, Z;
local vector tempCamStart, tempCamEnd;
 
local bool bObstructed;
local float CollisionRadius;
 
    if (!bThirdPerson)
        return false;
     
    bObstructed = false;
    CollisionRadius = GetCollisionRadius();
     
    CamStart = Location;
    CamStart.Z += CameraZOffset;
     
    GetAxes(out_CamRot, X, Y, Z);
    X *= CollisionRadius * CameraTranslateScale.X;
    Y *= CollisionRadius * CameraTranslateScale.Y;
    Z *= CollisionRadius * -1.0f;
    CamDir = X + Y + Z;
     
    out_CamLoc = CamStart - CamDir;
     
    if (Controller != None)
        out_CamRot = Controller.Rotation;
        else
        out_CamRot = Rotation;
     
    if (Trace(HitLocation, HitNormal, out_CamLoc, CamStart, false, vect(12,12,12),,TRACEFLAG_Blocking) != None)
    {
        out_CamLoc = HitLocation;
        bObstructed = true;
    }
     
    if (bObstructed)
    {
        /*Again thanks for fall, for this. It just inside character collision detection*/
        /*I don't know who you are fall, but ^_^ */
        tempCamStart = CamStart;
        tempCamStart.Z = 0;
        tempCamEnd = out_CamLoc;
        tempCamEnd.Z = 0;
         
        if((VSize(tempCamEnd - tempCamStart) < CollisionRadius*1.5) && (out_CamLoc.Z<Location.Z+CylinderComponent.CollisionHeight) && (out_CamLoc.Z>Location.Z-CylinderComponent.CollisionHeight))
        HideMesh(true);
        else
        HideMesh(false);
    }
     
    return true;
 
}


class ExodusCamera extends Camera;

var vector          ExCameraLocOffset;
var rotator         ExCameraRotOffset;

//force camera into a third person perspective
function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
{
local vector    ExLoc;
local rotator   ExRot;

    if(PCOwner  != None)
    {
        ExLoc = OutVT.Target.Location; //store target loc to var
        ExRot = OutVt.Target.Rotation; //store target rot to var
        
        ExLoc += ExCameraLocOffset >> ExRot; //adds the camera offset uses actors local space to inform camera world position
        
        OutVT.POV.Location = ExLoc; //sets the cameras location
        OutVt.POV.Rotation = ExRot + ExCameraRotOffset; //sets the camera rotation adding the camera offset
            `log ("camera works");
    }
    else
    Super.UpdateViewTarget (OutVT, DeltaTime);
    
}
        

defaultproperties
{
    ExCameraLocOffset=(X=-130,y=10,z=50) //define offset loc
    ExCameraRotOffset=(Pitch=-3500,Yaw=0,Roll=0) //define offset rot
    DefaultFOV=80.0f //field of view
}