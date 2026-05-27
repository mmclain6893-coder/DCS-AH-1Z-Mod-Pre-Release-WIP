
dofile(LockOn_Options.script_path .. "command_defs.lua")
local dev = GetSelf()
local update_time_step = 0.02
make_default_activity(update_time_step)
local sensor_data = get_base_data()
update = function()
-- upvalues: sensor_data
local aoa = sensor_data:getAngleOfAttack()
local speed = sensor_data:getSelfVelocity()
local sas = sensor_data:getSelfAirspeed()
local tas = sensor_data:getTrueAirSpeed()
local ias = sensor_data:getIndicatedAirSpeed()
local mach = sensor_data:getMachNumber()
local vv = sensor_data:getVerticalVelocity()
local gforce = sensor_data:getVerticalAcceleration()
local balt = sensor_data:getBarometricAltitude()
local ralt = sensor_data:getRadarAltitude()
local pitch = sensor_data:getStickRollPosition() / 100--Parkposition
local roll = sensor_data:getStickPitchPosition() / 100--Parkposition
local rudder = sensor_data:getRudderPosition()  / 100--Parkposition
local throttle = sensor_data:getThrottleLeftPosition()
local gear = sensor_data:getLandingGearHandlePos()
local speedbrake = sensor_data:getSpeedBrakePos()
local rpm = sensor_data:getEngineLeftRPM()
local flaps = sensor_data:getFlapsPos()
local cpy_state = sensor_data:getCanopyState()
local cpy_pos = sensor_data:getCanopyPos()
local wown = sensor_data:getWOW_NoseLandingGear()
local wowl = sensor_data:getWOW_LeftMainLandingGear()
local wowr = sensor_data:getWOW_RightMainLandingGear()


local GUNNER = get_aircraft_draw_argument_value(39)
local ROTOR = get_aircraft_draw_argument_value(40)
local WINCH = get_aircraft_draw_argument_value(2004)

--local wheel_chock = get_aircraft_draw_argument_value(23)


end



need_to_be_closed = false

