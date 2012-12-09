class SpectorController extends UTPlayerController;



simulated function PostBeginPlay()
{

Super.PostBeginPlay();

}

simulated function name GetDefaultCameraMode(PlayerController RequestedBy)
{
    return 'ThirdPerson';
}

defaultproperties
{    
    Name="Default__SpectorController"
    CameraClass=class'ExodusCamera'
    DefaultFOV=80.0f //field of view
}