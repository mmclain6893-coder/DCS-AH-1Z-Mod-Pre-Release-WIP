local dev = GetSelf()

dofile(LockOn_Options.script_path.."command_defs.lua")

local update_time_step = 0.01
make_default_activity(update_time_step)

elec_dc_ok  = get_param_handle("DC_POWER_AVAIL")


local extendprobe = 0
local FuelProbe = 0


dev:listen_command(Keys.RefuelProbe)
dev:listen_command(device_commands.RefuelProbesw)



function post_initialize()

end	

function SetCommand(command,value)
			
			if command == device_commands.RefuelProbesw then
				FuelProbe = value
			elseif command == Keys.RefuelProbe then
					
			dev:performClickableAction(device_commands.RefuelProbesw, (1-FuelProbe),true) -- makes the switch inside cockpit move
end
end


function anim_FuelProbe()
		if  FuelProbe == 1 then 
			extendprobe =  extendprobe + 0.005
		
		if extendprobe >= 1 then
				extendprobe = 1
		
			end
		

		
		elseif FuelProbe == 0 then
				extendprobe = extendprobe - 0.005
			if extendprobe <= 0 then
			extendprobe = 0
		end
		end
		end

	



function update()

if elec_dc_ok:get()==1 then
anim_FuelProbe()
set_aircraft_draw_argument_value(22, extendprobe) --animation to external model		 
end
end
	
		

need_to_be_closed = false -- close lua 
