local dev = GetSelf()

dofile(LockOn_Options.script_path.."command_defs.lua")

local update_time_step = 0.01
make_default_activity(update_time_step)

--elec_dc_ok  = get_param_handle("DC_POWER_AVAIL")



local ramp = 0
local rampheight = 0
local Rampcover = 0


dev:listen_command(Keys.Ramp)
dev:listen_command(device_commands.Rampsw)
dev:listen_command(device_commands.RampcoverSw)


function post_initialize()

end	

function SetCommand(command,value)
			if command == device_commands.RampcoverSw then
				Rampcover = value
				end
			if command == device_commands.Rampsw then
				ramp = value
end
end

function anim_ramp()
local Troopwarn = get_cockpit_draw_argument_value(150)
local TroopAlarm = get_cockpit_draw_argument_value(151)

local rampheight = get_cockpit_draw_argument_value(2020)

if TroopAlarm == 0 then
set_aircraft_draw_argument_value(86, rampheight)
elseif  TroopAlarm == 1 then
dev:performClickableAction(device_commands.Rampsw,1,true)
dev:performClickableAction(device_commands.RampcoverSw,1,true)
set_aircraft_draw_argument_value(86, 0.666)
end

				
end	





function update()


	
anim_ramp()  --animation to external model		
 
	
 
end

	
		

need_to_be_closed = false -- close lua 
