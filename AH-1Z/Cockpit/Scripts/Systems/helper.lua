dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

local dev = GetSelf()  -- gives you a handle for calling built-in handler functions

debug_mode = true

local update_time_step = 0.02
make_default_activity(update_time_step)

for i=1,800000 do
dev:listen_command(i)
end

function post_initialize()
end

function SetCommand(command,value)
print_message_to_user("command="..tostring(command)..",value="..tostring(value) )
	if command == 10009 then 
			dev:launch_station(0)
			dev:launch_station(2)
		end
	end
	


function update()

end

need_to_be_closed = false