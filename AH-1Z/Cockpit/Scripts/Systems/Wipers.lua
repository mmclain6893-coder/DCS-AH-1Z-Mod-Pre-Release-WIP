local dev = GetSelf()

dofile(LockOn_Options.script_path.."command_defs.lua")
local wipers_param  = get_param_handle("WIPERS")
local update_time_step = 0.01
make_default_activity(update_time_step)

elec_dc_ok  = get_param_handle("DC_POWER_AVAIL")


local rotatewiper = 0
local wipers = 0


dev:listen_command(Keys.Wipersonoff)
dev:listen_command(device_commands.Wipersw)



function post_initialize()

end	

function SetCommand(command,value)
			
			if command == device_commands.Wipersw then
				wipers = value
			elseif command == Keys.Wipersonoff then
					
			dev:performClickableAction(device_commands.Wipersw, (1-wipers),true) -- makes the switch inside cockpit move
end
end


function anim_wipers()
		if  wipers == 1 then 
			rotatewiper =  rotatewiper + 0.0105
		
		if rotatewiper >= 1 then
				rotatewiper = -1
			end
			
		elseif rotatewiper >= 1 then 
				rotatewiper = -1
		end
		
		if wipers == 0 then
				rotatewiper = rotatewiper - 0.01
			if rotatewiper <= -1 then
			rotatewiper = -1
		end
		end
		end

function update()

if elec_dc_ok:get()==1 then
anim_wipers()
set_aircraft_draw_argument_value(2006, rotatewiper) --animation to external model
wipers_param:set(rotatewiper)		 
end
end
	
		

need_to_be_closed = false -- close lua 
