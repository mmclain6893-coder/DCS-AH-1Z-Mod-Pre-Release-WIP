local dev = GetSelf()

dofile(LockOn_Options.script_path.."command_defs.lua")

local update_time_step = 0.01
make_default_activity(update_time_step)

elec_dc_ok  = get_param_handle("DC_POWER_AVAIL")


local tailopen = 0
local tailopenr = 0

local sensor_data = get_base_data()

dev:listen_command(Keys.Opentail)
dev:listen_command(device_commands.Opentailsw)



function post_initialize()
--sndhost = create_sound_host("COCKPIT_ARMS","3D",0,0,0)
--tailopeningsound = sndhost:create_sound("tailopening") -- refers to sdef file, and sdef file content refers to sound file, see DCSWorld/Sounds/sdef/_example.sdef
end	

function SetCommand(command,value)
			
			if command == device_commands.Opentailsw then
				tailopen = value
			elseif command == Keys.opentail then
					
			dev:performClickableAction(device_commands.Opentailsw, (1-tailopen),true) -- makes the switch inside cockpit move
end
end


function anim_tailopen()

		

	
		if  tailopen == 1 then
			tailopenr = tailopenr + 0.001
			--tailopeningsound:play_continue()
			if tailopenr >= 1 then 
			tailopenr = 1
			--tailopeningsound:stop()
		end
		elseif  tailopen == 0 then
			tailopenr = tailopenr - 0.001
			--tailopeningsound:play_continue()
		if tailopenr <= 0 then 
		tailopenr = 0
		--tailopeningsound:stop()
		end
		
		elseif  tailopen == 0 then
			tailopenr = tailopenr 
			--tailopeningsound:stop()

		end
		end



	
function update()
		if elec_dc_ok:get()==1 then
anim_tailopen()
set_aircraft_draw_argument_value(2009, tailopenr) --animation to external model		 
end
end


	
		

need_to_be_closed = false -- close lua 
