dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

render_debug_info = true

FMD_Power = get_param_handle("FMD_POWER")
FMD_Brightness = get_param_handle("FMD_BRIGHTNESS")
FMD_NAV_PAGE_VIS = get_param_handle("FMD_NAV_PAGE_VIS")

elec_dc_ok  = get_param_handle("DC_POWER_AVAIL")

FMD_Power:set(1)
FMD_Brightness:set(1)
FMD_NAV_PAGE_VIS:set(1)

local gettext = require("i_18n")
_ = gettext.translate

update_time_step = 0.025
make_default_activity(update_time_step) 
local FMD_dev 	    = GetSelf()

function post_initialize()
	--GetDevice(devices.FMD_):set_power(true)	
	-- FMD_dev:performClickableAction(device_commands.FMD_Brightness,1,true)
	-- local birth = LockOn_Options.init_conditions.birth_place	--"GROUND_COLD","GROUND_HOT","AIR_HOT"
    -- if birth=="GROUND_HOT" or birth=="AIR_HOT" then 	-- set battery and generator on when starting hot   
        -- FMD_dev:performClickableAction(device_commands.FMD_power,1,true) --true or false do action	 	
    -- elseif birth=="GROUND_COLD" then
        -- FMD_dev:performClickableAction(device_commands.FMD_power,0,true)	
    -- end
end

FMD_dev:listen_command(device_commands.FMD_power)
FMD_dev:listen_command(device_commands.FMD_Brightness)

FMD_dev:listen_command(1005)

function SetCommand(command,value)
    if command == device_commands.FMD_power then
		FMD_Power = (value==1) and true or false
		GetDevice(devices.FMD_):set_power(FMD_Power) -- actives the FMD_ script internally
	elseif command == device_commands.FMD_Brightness then
		FMD_Brightness:set(value)	
	elseif command == 1005 then
		 print_message_to_user("clicked 1005") 
	end
end

function update()
	
end

