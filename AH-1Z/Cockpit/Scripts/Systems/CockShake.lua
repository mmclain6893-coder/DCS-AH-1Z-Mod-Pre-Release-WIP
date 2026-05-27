dofile(LockOn_Options.script_path.."command_defs.lua")

local dev = GetSelf()
local sensor_data = get_base_data()
local update_time_step = 0.03  
make_default_activity(update_time_step)

local current_hdg = get_param_handle("CURRENT_HDG")
local current_Ralt = get_param_handle("CURRENT_RALT")
local alt_1k = get_param_handle("ALT_1000")
local MySpeed = sensor_data.getTrueAirSpeed() 
local pitch = sensor_data.getPitch()
local roll = sensor_data.getRoll()
local VV = sensor_data.getVerticalVelocity()


local panelshakez = 0
local panelshakey = 0
local panelshakex = 0
local panelshakez1 = 0
local panelshakey1 = 0
local panelshakex1 = 0

PANELSHAKEZ = get_param_handle("PANELSHAKEZ")
PANELSHAKEY = get_param_handle("PANELSHAKEY")
PANELSHAKEX = get_param_handle("PANELSHAKEX")

PANELSHAKEZ1 = get_param_handle("PANELSHAKEZ1")
PANELSHAKEY1 = get_param_handle("PANELSHAKEY1")
PANELSHAKEX1 = get_param_handle("PANELSHAKEX1")
RPM4 = get_param_handle("RPM")

function SetCommand(command,value)

	end




function badair_shake()
local MySpeed = sensor_data.getTrueAirSpeed()
local VV = sensor_data.getVerticalVelocity()

if MySpeed < 10 and VV < -1.5 then 
	panelshakez = panelshakez + 0.35
	panelshakex = panelshakex + 0.1
	panelshakey = panelshakey + 0.45

end
if panelshakez >= 10 then 
panelshakez = -1
end

if panelshakex >= 10 then 
panelshakex = -10
end

if panelshakey >= 1 then 
panelshakey = -1
end
end

function Vibrate()
local RPM4 = (sensor_data.getEngineLeftRPM()*100)
if RPM4*100 >= 30 then
panelshakez1 = panelshakez1 + RPM4 
panelshakex1 = panelshakex1 + RPM4 
panelshakey1 = panelshakey1 + RPM4

end

if panelshakez1 >= 100 then
panelshakez1 = -1
end
if panelshakey1 >= 100 then
panelshakey1 = -1
end
if panelshakex1 >= 100 then
panelshakex1 = -1
end

end

function update()
Vibrate()
badair_shake()
--print_message_to_user("Speed  "..sensor_data.getTrueAirSpeed())
--print_message_to_user("RPM  "..sensor_data.getEngineLeftRPM())
--print_message_to_user("VV  "..sensor_data.getVerticalVelocity())

PANELSHAKEZ:set(panelshakez)
PANELSHAKEX:set(panelshakex)
PANELSHAKEY:set(panelshakey)

PANELSHAKEZ1:set(panelshakez1)
PANELSHAKEX1:set(panelshakex1)
PANELSHAKEY1:set(panelshakey1)
end

need_to_be_closed = false -- close lua state after initialization