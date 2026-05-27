local dev = GetSelf() 							

dofile(LockOn_Options.script_path.."command_defs.lua") -- making sure DCS has the commands loaded

local update_time_step = 0.01 			-- this means the device will update every 1/100th of a second -ish
make_default_activity(update_time_step)  

local steering1 = 0			-- defining for later
local steerlock = 0				-- defining for later
local pedals = 0
local pedals1 = get_param_handle("PEDAL_INPUT")

dev:listen_command(device_commands.SteerlockSw)	


function post_initialize()			-- not needed in this script

end	

function SetCommand(command,value)

			if command == device_commands.SteerlockSw then 
				steerlock = value
				--print_message_to_user("steerlock "..steerlock)
			
end			
			--if steerlock == 1 then
			if command == device_commands.steeringwheel then 	
				steering1 = value	
				--print_message_to_user("steering1 "..steering1)
				
end		
end
			



function anim_steering()
	local pedals = get_cockpit_draw_argument_value(6) --pedals arg
	
	if steerlock == 1 then
	dev:performClickableAction(device_commands.SteerlockSw,1,true)
	dev:performClickableAction(device_commands.steeringwheel,pedals,true)
	set_aircraft_draw_argument_value(500, pedals)-- set_aircraft_draw_argument_value(202, steering1)
	elseif steerlock == 0 then
	dev:performClickableAction(device_commands.SteerlockSw,0,true)
	dev:performClickableAction(device_commands.steeringwheel,steering1,true)
	set_aircraft_draw_argument_value(500, steering1)
	
end
end


function update()

--pedals:set(pedals1)

	--print_message_to_user("Pedal Power "..pedals)

anim_steering()
 
end

need_to_be_closed = false -- close lua 
