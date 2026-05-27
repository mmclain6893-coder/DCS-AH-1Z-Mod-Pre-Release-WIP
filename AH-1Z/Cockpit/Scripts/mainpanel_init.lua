shape_name = "AH-1Z_Cockpit"

is_EDM = true
new_shape = true 
new_model_format = true
cockpit_local_point = {5.70, 1.20, 0.00}
new_infrared_debug = true

draw_old_cockpit = false
draw_pilot = false
use_external_views = false

day_texture_set_value   = 0.0
night_texture_set_value = 0.1
dusk_border					 = 0.4
external_model_canopy_arg	 = 38
--render_debug_info = false


plafon =
{
	lighttype 		= "omni",
	position  		= {-0.32,0.048,-0.314},
	attenuation 	= {1,2,3,2.5},
}

-- main panel shaking
shake_filter_Y_Left_ = {IsHPF = false, B = 1/6.0, C = 1.0, Freq0 = 7.7, K = 0.02}
shake_filter_Y_Right_ = {IsHPF = false, B = 1/6.2, C = 1.0, Freq0 = 8.0, K = 0.023}
shake_filter_Z_ = {IsHPF = false, B = 1/4.0, C = 1.0, Freq0 = 7.5, K = 0.02}
		
rot_x_k = 1.0
cross_accel = 0.5

shaking_dt 			= 0.01


--[[
seat_points = 
{
[1] = {point = {0.0, 0.07, -0.59}},
[2] = {point = {0.0, 0.04,  0.60}},
[3] = {point = {-0.2, 0.15, 0.0}},
[4] = {point = {0.0, 0.0, 0.0 ,absolute_position = true }},
}
]]


local controllers = LoRegisterPanelControls()

--collision shake
Panel_Shake_Z  				= CreateGauge()
Panel_Shake_Z.arg_number	= 264
Panel_Shake_Z.input			= {-1,1}
Panel_Shake_Z.output		= {-1,1}
Panel_Shake_Z.controller	= controllers.Panel_Shake_Z

Panel_Shake_Y  				= CreateGauge()
Panel_Shake_Y.arg_number	= 265
Panel_Shake_Y.input			= {-1,1}
Panel_Shake_Y.output		= {-0.8,0.8}
Panel_Shake_Y.controller	= controllers.Panel_Shake_Y

Panel_Rot_X  				= CreateGauge()
Panel_Rot_X.arg_number		= 282
Panel_Rot_X.input			= {-1,1}
Panel_Rot_X.output			= {-0.5,0.5}
Panel_Rot_X.controller		= controllers.Panel_Rot_X


--bad air shake
PanelShakeZ1  				= CreateGauge("parameter")
PanelShakeZ1.arg_number		= 307
PanelShakeZ1.input			= {-1,1}
PanelShakeZ1.output			= {-0.5,0.5}
PanelShakeZ1.parameter_name   = "PANELSHAKEZ"

PanelShakeY1  				= CreateGauge("parameter")
PanelShakeY1.arg_number		= 308
PanelShakeY1.input			= {-1,1}
PanelShakeY1.output			= {-0.5,0.5}
PanelShakeY1.parameter_name   = "PANELSHAKEY"

PanelShakeX1  				= CreateGauge("parameter")
PanelShakeX1.arg_number		= 309
PanelShakeX1.input			= {-1,1}
PanelShakeX1.output			= {-0.5,0.5}
PanelShakeX1.parameter_name   = "PANELSHAKEX"


--engine vibration
PanelShakeZ2  				= CreateGauge("parameter")
PanelShakeZ2.arg_number		= 304
PanelShakeZ2.input			= {-1,1}
PanelShakeZ2.output			= {-0.02,0.02}
PanelShakeZ2.parameter_name   = "PANELSHAKEZ1"

PanelShakeY2  				= CreateGauge("parameter")
PanelShakeY2.arg_number		= 305
PanelShakeY2.input			= {-1,1}
PanelShakeY2.output			= {-0.02,0.02}
PanelShakeY2.parameter_name   = "PANELSHAKEY1"

PanelShakeX2  				= CreateGauge("parameter")
PanelShakeX2.arg_number		= 306
PanelShakeX2.input			= {-1,1}
PanelShakeX2.output			= {-0.02,0.02}
PanelShakeX2.parameter_name   = "PANELSHAKEX1"


Winch  						= CreateGauge("external_arg")
Winch.external_arg			= 2004
Winch.arg_number			= 2004
Winch.input					= {0,1}
Winch.output				= {-1,1}


CurrTime_hours                     = CreateGauge("parameter")
CurrTime_hours.parameter_name      = "CURRTIME_HOURS"
CurrTime_hours.arg_number          = 440
CurrTime_hours.input               = {0.0, 12.0}
CurrTime_hours.output              = {-1.0, 1.0}

CurrTime_mins                     = CreateGauge("parameter")
CurrTime_mins.parameter_name      = "CURRTIME_MINS"
CurrTime_mins.arg_number          = 441
CurrTime_mins.input               = {0.0, 60.0}
CurrTime_mins.output              = {-1.0, 1.0}

CurrTime_secs                     = CreateGauge("parameter")
CurrTime_secs.parameter_name      = "CURRTIME_SECS"
CurrTime_secs.arg_number          = 442
CurrTime_secs.input               = {0.0, 60.0}
CurrTime_secs.output              = {-1.0, 1.0}

GMTTime_hours                     = CreateGauge("parameter")
GMTTime_hours.parameter_name      = "GMT_HOURS"
GMTTime_hours.arg_number          = 443
GMTTime_hours.input               = {0.0, 12.0}
GMTTime_hours.output              = {-1.0, 1.0}


GMTTime_mins                     = CreateGauge("parameter")
GMTTime_mins.parameter_name      = "CURRTIME_MINS"
GMTTime_mins.arg_number          = 444
GMTTime_mins.input               = {0.0, 60.0}
GMTTime_mins.output              = {-1.0, 1.0}


IASneedle							= CreateGauge()
IASneedle.arg_number				= 100
IASneedle.input						= {0,80} 
IASneedle.output					= {-1,1}
IASneedle.controller				= controllers.base_gauge_IndicatedAirSpeed --m/s

AltNeedle							= CreateGauge("parameter")
AltNeedle.arg_number				= 101
AltNeedle.input						= {0,1000}
AltNeedle.output					= {-1,1}
AltNeedle.parameter_name			= "ALT_100"

AltWarning							= CreateGauge("parameter")
AltWarning.arg_number				= 119
AltWarning.input					= {0,1}
AltWarning.output					= {0,1}
AltWarning.parameter_name			= "LOWALT"

FIRE_LIGHT							= CreateGauge("parameter")
FIRE_LIGHT.arg_number				= 309
FIRE_LIGHT.input					= {0,1}
FIRE_LIGHT.output					= {0,1}
FIRE_LIGHT.parameter_name			= "FIRE_LIGHT"

TAPETURN						= CreateGauge("parameter")
TAPETURN.arg_number				= 666
TAPETURN.input					= {-1,1}
TAPETURN.output					= {-1,1}
TAPETURN.parameter_name			= "TAPETURN"


Elecwarning1						= CreateGauge("parameter")
Elecwarning1.arg_number				= 302
Elecwarning1.input					= {0,1}
Elecwarning1.output					= {0,1}
Elecwarning1.parameter_name			= "ELECWARN1"

Elecwarning2						= CreateGauge("parameter")
Elecwarning2.arg_number				= 301
Elecwarning2.input					= {0,1}
Elecwarning2.output					= {0,1}
Elecwarning2.parameter_name			= "ELECWARN2"

Voltage								= CreateGauge("parameter")
Voltage.arg_number					= 303
Voltage.input						= {0,3000}
Voltage.output						= {-1,1}
Voltage.parameter_name				= "VOLTAGE1"


RadarAltNeedle						= CreateGauge("parameter")
RadarAltNeedle.arg_number			= 102
RadarAltNeedle.input				= {0, 100, 500, 1000, 5000}
RadarAltNeedle.output				= {-1,-0.5,	0,  0.5, 1}
RadarAltNeedle.parameter_name		= "CURRENT_RALT"

OilPressure							= CreateGauge("parameter")
OilPressure.arg_number				= 222
OilPressure.input					= {0,100}
OilPressure.output					= {-1,1}
OilPressure.parameter_name			= "OIL_PRESSURE"

HydPressure							= CreateGauge("parameter")
HydPressure.arg_number				= 212
HydPressure.input					= {0,100}
HydPressure.output					= {-1,1}
HydPressure.parameter_name			= "HYDRAULICS"




RPM								= CreateGauge("parameter")
RPM.arg_number					= 118
RPM.input						= {0, 100}
RPM.output						= {-1, 1}
RPM.parameter_name				= "RPM"

FUEL							= CreateGauge("parameter")
FUEL.arg_number					= 580
FUEL.input						= {0, 538}
FUEL.output						= {-1, 1}
FUEL.parameter_name				= "CURRENT_FUELT"

FUELFLOW							= CreateGauge("parameter")
FUELFLOW.arg_number					= 581
FUELFLOW.input						= {-10, 10}
FUELFLOW.output						= {-1, 1}
FUELFLOW.parameter_name				= "FUEL_FLOW"


Wipers								= CreateGauge("parameter")
Wipers.arg_number					= 2006
Wipers.input						= {0, 1}
Wipers.output						= {-1, 1}
Wipers.parameter_name				= "WIPERS"

EngineTemp							= CreateGauge("parameter")
EngineTemp.arg_number				= 121
EngineTemp.input					= {0, 1000}
EngineTemp.output					= {-1, 1}
EngineTemp.parameter_name			= "TOT"

EngineTemp2							= CreateGauge("parameter")
EngineTemp2.arg_number				= 125
EngineTemp2.input					= {0, 1000}
EngineTemp2.output					= {-1, 1}
EngineTemp2.parameter_name			= "TOT"

AirTemp							= CreateGauge()
AirTemp.arg_number				= 122
AirTemp.input					= {0, 400}
AirTemp.output					= {-1, 1}
AirTemp.controller				= controllers.base_gauge_EngineLeftTemperatureBeforeTurbine


RadarAltOff							= CreateGauge("parameter")
RadarAltOff.arg_number				= 117
RadarAltOff.input					= {0,10000}
RadarAltOff.output					= {-1,1}
RadarAltOff.parameter_name			= "RALT_OFF"


StickPitch							= CreateGauge("parameter")
StickPitch.arg_number				= 1
StickPitch.input					= {-1, 1}
StickPitch.output					= {-1, 1}
StickPitch.parameter_name			= "PITCH_INPUT"


StickBank							= CreateGauge("parameter")
StickBank.arg_number				= 2
StickBank.input						= {-1,1}
StickBank.output					= {-1, 1}
StickBank.parameter_name			= "ROLL_INPUT"


Collective							= CreateGauge("parameter")
Collective.arg_number				= 3
Collective.input					= {-1, 1}
Collective.output					= {0, 1}
Collective.parameter_name			= "COLLECTIVE_INPUT"

Pedals                                = CreateGauge("parameter")
Pedals.arg_number                    = 6
Pedals.input                        = {-1, 1} 
Pedals.output                        = {1,-1}
Pedals.parameter_name                = "PEDAL_INPUT"


VVneedle							= CreateGauge()
VVneedle.arg_number					= 103
VVneedle.input						= {-30.48,-20.32,-10.16,-5.08,0,5.08,10.16,20.32,30.48} --1000,2000,4000,6000 ft/min converted to m/s
VVneedle.output						= {-1,-0.75,-0.5,-0.25,0,0.25,0.5,0.75,1}
VVneedle.controller					= controllers.base_gauge_VerticalVelocity --m/s

ADIPitch							= CreateGauge()
ADIPitch.arg_number					= 104
ADIPitch.input						= {-math.rad(90),0, math.rad(90)}
ADIPitch.output						= {-1,0, 1}
ADIPitch.controller					= controllers.base_gauge_Pitch

ADIBank								= CreateGauge()
ADIBank.arg_number					= 105
ADIBank.input						= {-math.pi, math.pi}
ADIBank.output						= {1, -1}
ADIBank.controller					= controllers.base_gauge_Roll

ADIslip								= CreateGauge()
ADIslip.arg_number					= 123
ADIslip.input						= {-1, 1}
ADIslip.output						= {-1, 1}
ADIslip.controller					= controllers.base_gauge_AngleOfSlide

AOA									= CreateGauge()
AOA.arg_number						= 124
AOA.input							= {-1, 1}
AOA.output							= {-1, 1}
AOA.controller						= controllers.base_gauge_AngleOfAttack


Compass								= CreateGauge("parameter")
Compass.arg_number					= 1006
Compass.input						= {0,360}
Compass.output						= {-1,1}
Compass.parameter_name				= "CURRENT_HDG"

Heading								= CreateGauge("parameter")
Heading.arg_number					= 148
Heading.input						= {0,360}
Heading.output						= {-1,1}
Heading.parameter_name				= "OFFONCOMPASS"



Torque								= CreateGauge("parameter")
Torque.arg_number					= 422
Torque.input						= {0,100}
Torque.output						= {-1,1}
Torque.parameter_name				= "TRQ"

Alt1k								= CreateGauge("parameter")
Alt1k.arg_number					= 108
Alt1k.input							= {0,10000}
Alt1k.output						= {-1,1}
Alt1k.parameter_name				= "ALT_1000"

Alt10k								= CreateGauge("parameter")
Alt10k.arg_number					= 107
Alt10k.input						= {0.0, 9900, 10000, 19900, 20000, 29900, 30000, 39900, 40000, 49900, 50000, 59900, 60000, 69900, 70000, 79900, 80000, 89900, 90000, 99900, 100000.0}--{0,100000}
Alt10k.output						= {0.0, 0.09, 0.1, 0.19, 0.2, 0.29, 0.3, 0.39, 0.4, 0.49, 0.5, 0.59, 0.6, 0.69, 0.7, 0.79, 0.8, 0.89, 0.9, 0.99, 1.0}--{0,1}
Alt10k.parameter_name				= "ALT_10000"

AltAdjINHG1							= CreateGauge("parameter")
AltAdjINHG1.arg_number				= 109
AltAdjINHG1.input					= {0,10}
AltAdjINHG1.output					= {0,1}
AltAdjINHG1.parameter_name			= "ALT_ADJ_Nxxx"

AltAdjINHG2							= CreateGauge("parameter")
AltAdjINHG2.arg_number				= 110
AltAdjINHG2.input					= {0,10}
AltAdjINHG2.output					= {0,1}
AltAdjINHG2.parameter_name			= "ALT_ADJ_xNxx"

AltAdjINHG3							= CreateGauge("parameter")
AltAdjINHG3.arg_number				= 111
AltAdjINHG3.input					= {0,10}
AltAdjINHG3.output					= {0,1}
AltAdjINHG3.parameter_name			= "ALT_ADJ_xxNx"

AltAdjINHG4							= CreateGauge("parameter")
AltAdjINHG4.arg_number				= 112
AltAdjINHG4.input					= {0,10}
AltAdjINHG4.output					= {0,1}
AltAdjINHG4.parameter_name			= "ALT_ADJ_xxxN"

AltAdjMB1							= CreateGauge("parameter")
AltAdjMB1.arg_number				= 113
AltAdjMB1.input						= {0,10}
AltAdjMB1.output					= {0,1}
AltAdjMB1.parameter_name			= "ALT_ADJ_MBNxxx"

AltAdjMB2							= CreateGauge("parameter")
AltAdjMB2.arg_number				= 114
AltAdjMB2.input						= {0,10}
AltAdjMB2.output					= {0,1}
AltAdjMB2.parameter_name			= "ALT_ADJ_MBxNxx"

AltAdjMB3							= CreateGauge("parameter")
AltAdjMB3.arg_number				= 115
AltAdjMB3.input						= {0,10}
AltAdjMB3.output					= {0,1}
AltAdjMB3.parameter_name			= "ALT_ADJ_MBxxNx"

AltAdjMB4							= CreateGauge("parameter")
AltAdjMB4.arg_number				= 116
AltAdjMB4.input						= {0,10}
AltAdjMB4.output					= {0,1}
AltAdjMB4.parameter_name			= "ALT_ADJ_MBxxxN"


--[[Autopilot ripped from A-29b

local object = CreateGauge("parameter")
object.arg_number 	 	= 213
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_RP"

object = CreateGauge("parameter")
object.arg_number 	 	= 214
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_HDG"

object = CreateGauge("parameter")
object.arg_number 	 	= 215
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_ALT"

object = CreateGauge("parameter")
object.arg_number 	 	= 216
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_TEST"

object = CreateGauge("parameter")
object.arg_number 	 	= 217
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_TEST_ERROR"

object = CreateGauge("parameter")
object.arg_number 	 	= 218
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_NAV"

object = CreateGauge("parameter")
object.arg_number 	 	= 219
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_NAV_ERROR"

object = CreateGauge("parameter")
object.arg_number 	 	= 220
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_APR"

object = CreateGauge("parameter")
object.arg_number 	 	= 221
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_APR_ERROR"


object = CreateGauge("parameter")
object.arg_number 	 	= 222
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_GS"

object = CreateGauge("parameter")
object.arg_number 	 	= 223
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_GS_ERROR"

object = CreateGauge("parameter")
object.arg_number 	 	= 224
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_ON"

object = CreateGauge("parameter")
object.arg_number 	 	= 225
object.input      	 	= {0,1}
object.output     	 	= {0,1}
object.parameter_name	= "AP_ERROR"
]]



need_to_be_closed = true -- close lua state after initialization 

--dofile(LockOn_Options.common_script_path.."tools.lua")

--[[ available functions 

 --base_gauge_RadarAltitude
 --base_gauge_BarometricAltitude
 --base_gauge_AngleOfAttack
 --base_gauge_AngleOfSlide
 --base_gauge_VerticalVelocity
 --base_gauge_TrueAirSpeed
 --base_gauge_IndicatedAirSpeed
 --base_gauge_MachNumber
 --base_gauge_VerticalAcceleration --Ny
 --base_gauge_HorizontalAcceleration --Nx
 --base_gauge_LateralAcceleration --Nz
 --base_gauge_RateOfRoll
 --base_gauge_RateOfYaw
 --base_gauge_RateOfPitch
 --base_gauge_Roll
 --base_gauge_MagneticHeading
 --base_gauge_Pitch
 --base_gauge_Heading
 --base_gauge_EngineLeftFuelConsumption
 --base_gauge_EngineRightFuelConsumption
 --base_gauge_EngineLeftTemperatureBeforeTurbine
 --base_gauge_EngineRightTemperatureBeforeTurbine
 --base_gauge_EngineLeftRPM
 --base_gauge_EngineRightRPM
 --base_gauge_WOW_RightMainLandingGear
 --base_gauge_WOW_LeftMainLandingGear
 --base_gauge_WOW_NoseLandingGear
 --base_gauge_RightMainLandingGearDown
 --base_gauge_LeftMainLandingGearDown
 --base_gauge_NoseLandingGearDown
 --base_gauge_RightMainLandingGearUp
 --base_gauge_LeftMainLandingGearUp
 --base_gauge_NoseLandingGearUp
 --base_gauge_LandingGearHandlePos
 --base_gauge_StickRollPosition
 --base_gauge_StickPitchPosition
 --base_gauge_RudderPosition
 --base_gauge_ThrottleLeftPosition
 --base_gauge_ThrottleRightPosition
 --base_gauge_HelicopterCollective
 --base_gauge_HelicopterCorrection
 --base_gauge_CanopyPos
 --base_gauge_CanopyState
 --base_gauge_FlapsRetracted
 --base_gauge_SpeedBrakePos
 --base_gauge_FlapsPos
 --base_gauge_TotalFuelWeight


available functions



getAngleOfAttack
getAngleOfSlide
getBarometricAltitude
getCanopyPos
getCanopyState
getEngineLeftFuelConsumption
getEngineLeftRPM
getEngineLeftTemperatureBeforeTurbine
getEngineRightFuelConsumption
getEngineRightRPM
getEngineRightTemperatureBeforeTurbine
getFlapsPos
getFlapsRetracted
getHeading
getHelicopterCollective
getHelicopterCorrection
getHorizontalAcceleration
getIndicatedAirSpeed
getLandingGearHandlePos
getLateralAcceleration
getLeftMainLandingGearDown
getLeftMainLandingGearUp
getMachNumber
getMagneticHeading
getNoseLandingGearDown
getNoseLandingGearUp
getPitch
getRadarAltitude
getRateOfPitch
getRateOfRoll
getRateOfYaw
getRightMainLandingGearDown
getRightMainLandingGearUp
getRoll
getRudderPosition
getSelfAirspeed
getSelfCoordinates
getSelfVelocity
getSpeedBrakePos
getStickPitchPosition
getStickRollPosition
getThrottleLeftPosition
getThrottleRightPosition
getTotalFuelWeight
getTrueAirSpeed
getVerticalAcceleration
getVerticalVelocity
getWOW_LeftMainLandingGear
getWOW_NoseLandingGear
getWOW_RightMainLandingGear


--]]




