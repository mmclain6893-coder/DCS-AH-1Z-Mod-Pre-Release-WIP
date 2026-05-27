local function counter()
	count = count + 1
	return count
end

count = 10000

Keys =
{
	BattSwitch	 	 = counter(),
	ExtPwrSwitch	 = counter(),
	ThrottleCutoff 	 = counter(),
	ThrottleIncrease = counter(),
	ThrottleDecrease = counter(),
	ThrottleStop 	 = counter(),
	LandingLight	 = counter(),
	PositionLights	= counter(),
	TriggerFireOn	= counter(),
	TriggerFireOff 	= counter(),
	PickleOn		= counter(),
	PickleOff		= counter(),
	MasterArm		= counter(),
	showControlInd 	= counter(),
	WinchDown		= counter(),	
	WinchUp		    = counter(),	
	Winchpower      = counter(),
	RWR       		= counter(),
	RWRknob       	= counter(),
	Wipersonoff		= counter(),
	Opentail		= counter(),
	RefuelProbe		= counter(),
	Ramp			= counter(),
	ANTICOLOnOff	= counter(),
	GunSelector		= counter(),
	Opendoor		= counter(),
	brakesonoff		= counter(),
	BrakesOn		= counter(),
	BrakesOff		= counter(),
	radioonoff		= counter(),
	steeringwheel1	= counter(),
	steerlock		= counter(),
	

	
	PlaneDropFlareOnce 			= 357,
	PlaneDropChaffOnce 			= 358,
	iCommandActiveJamming		= 359,

	PlaneGear                       = 68,						
	PlaneGearUp	                    = 430,
	PlaneGearDown                   = 431,
	
	
	PlaneTrimCancel = 97,
	
	PlanePilotDoor = 10071,
	PlanePilotGunner = 10072,
	
	PlaneModeCannon = 113,
	
	PlaneLightsOnOff	= 10016,
	ChangeWeapon = 1620,
	
	Plane_SpotLight_left  = 511,
	Plane_SpotLight_right = 512,
	Plane_SpotLight_up	= 513,
	Plane_SpotLight_down = 514,
	Plane_SpotLight_stop = 515,

	PlaneRotorTipLights = 516,
	Plane_SpotSelect_switch = 517,
	PlaneAntiCollisionLights = 518,
	PlaneNavLights_CodeModeOn = 519,
	PlaneNavLights_CodeModeOff = 520,
	PlaneFormationLights = 521,

	
	-- Gunturret axis commands
	SelectCannon    = 1500,
	GunturretUp     = 1501,
	GunturretDown   = 1502,
	GunturretLeft   = 1503,
	GunturretRight  = 1504,
	GunturretReset  = 1505,
	GunturretUncage = 1506,
}


count = 3200
device_commands = { -- commands for lua

	AuxPowerSw  	= counter();
	FuelShutoffSw	= counter();
	FuelPumpSw 		= counter();
	MasterArm		= counter();
	SalvoSw			= counter();
	JettSw			= counter();
	JettSwCover		= counter();
	RocketSelector	= counter();
	GunSelector		= counter();
	PositionLightSw	= counter();
	CovertLight		= counter();
	AntiCollision	= counter();
	LandingLightSw	= counter();
	Wipersw			= counter();	
	Opentailsw		= counter();	
	RWRpower		= counter();
	RWRBrightness	= counter();
	RefuelProbesw	= counter();
	Rampsw			= counter();	
	ANTICOLSw		= counter();
	AltimeterSet	= counter();
	ADIadjust		= counter();
	LOset			= counter();
	HIset			= counter();
	WinchSwUp      	= counter();
	WinchSwDown     = counter();
	WinchpowerSw	= counter();
	PilotLightsSw 	= counter();
	CoPilotLightSw	= counter();
	PlaneGearsw     = counter();
	ChangeWeapon	= counter();
	Opendoorsw		= counter();
	Opendoorsw1		= counter();
	parkbrake		= counter();
	Radiosw			= counter();
	TapeDrawer		= counter();
	MasterArmCMs	= counter();
	ChaffSelector	= counter(); 	
	FlareSelector	= counter();
	ECM				= counter();
	starterfake		= counter(); 
	GenSelect		= counter(); 
	APUGEN			= counter();
	MasterArmCover	= counter();
	FormationLights = counter();
	ConsoleLightSw 	= counter();
	PedestalLightSw = counter();
	GunSight		= counter();
	BeachBoys		= counter();
    AP_RP           = counter();
    AP_ALT          = counter();
    AP_ON           = counter();
    StartupManual   = counter();	
	CMsCover		= counter();
	FueloffCover	= counter();
	Nowheretorun	= counter();
	Valkyries		= counter();
	LOWRPM			= counter();	
	CautionPanel	= counter();	
	Forcetrim		= counter();
	SecondaryLightSw = counter();
	EngineLightSw	= counter();
	Hydraulics		= counter();
	Compass			= counter();
	Firetest		= counter();
	GenCover		= counter();
	HeadingSet		= counter();
	Hints			= counter();
	PilotMFDLeftButton	= counter();
	PilotMFDRightButton	= counter();
	PilotDFDButton		= counter();
	--CHAFFFIRE		= counter();
	--FLAREFIRE		= counter();
}

EFM_commands = 	-- commands for use in EFM (make sure to copy to inputs.h)
{
	starterButton 		= 3000,
	throttleIdleCutoff	= 3001,
	throttle			= 3002,
	batterySwitch 		= 3003,
	generatorSwitch 	= 3004,
	inverterSwitch 		= 3005,
	throttleAxis		= 3006,
	trimUp				= 3007,
	trimDown			= 3008,
	trimLeft			= 3009,
	trimRight			= 3010,
	trimReset			= 3011,
	trimSave			= 3012,

	LeftThrottleAxis		= 3013,
	RightThrottleAxis		= 3014,
	JoystickThrottle	= 2004,  --collective

}

