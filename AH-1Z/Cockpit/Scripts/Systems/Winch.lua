dofile(LockOn_Options.script_path.."command_defs.lua")

local dev = GetSelf()
local update_time_step = 0.01
make_default_activity(update_time_step)

elec_dc_ok  = get_param_handle("DC_POWER_AVAIL")


dev:listen_command(device_commands.WinchSwDown)
dev:listen_command(device_commands.WinchSwUp)
dev:listen_command(device_commands.WinchpowerSw)
dev:listen_command(Keys.WinchUp)
dev:listen_command(Keys.WinchDown)
dev:listen_command(Keys.Winchpower) 

local winchdown = 0
local winchup = 0
local rotatew = 0
local winchon = 0 
local value = 0
local valuew = 0

function post_initialize()
sndhost = create_sound_host("COCKPIT_ARMS","3D",0,0,0)
winchsound = sndhost:create_sound("winch") -- refers to sdef file, and sdef file content refers to sound file, see DCSWorld/Sounds/sdef/_example.sdef
end


function SetCommand(command,value)

		if command == device_commands.WinchpowerSw then
				winchon = value
		elseif command == Keys.Winchpower then
			dev:performClickableAction(device_commands.WinchpowerSw, (1-winchon),true)
		end
				
			if command == device_commands.WinchSwDown then
				winchdown = value
			elseif command == Keys.WinchDown then
			dev:performClickableAction(device_commands.WinchSwDown, (1-winchdown),true)


end

end


	
function anim_winch()

		if  winchdown == 1 then
			rotatew = rotatew + 0.001
			winchsound:play_continue()
			if rotatew >= 1 then 
			rotatew = 1
			winchsound:stop()
		end
		elseif  winchdown == -1 then
			rotatew = rotatew - 0.001
			winchsound:play_continue()
		if rotatew <= 0 then 
		rotatew = 0
		winchsound:stop()
		end
		
		elseif  winchdown == 0 then
			rotatew = rotatew 
			winchsound:stop()

		end
		end



function update() 
	if elec_dc_ok:get()==1 and winchon == 1 then
	anim_winch()
	end
	set_aircraft_draw_argument_value(2004, rotatew) --animation -1 to +1
end


need_to_be_closed = false 