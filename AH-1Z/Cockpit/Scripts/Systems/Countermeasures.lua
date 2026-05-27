dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.common_script_path.."../../../Database/wsTypes.lua")

dofile(LockOn_Options.script_path.."utils.lua")


local dev = GetSelf()

local update_rate = 0.01
make_default_activity(update_rate)


local ECM_status = false
local chaff_count = 0
local flare_count = 0

local sensor_data = get_base_data()

elec_dc_ok  = get_param_handle("DC_POWER_AVAIL")

CHAFFS_count = get_param_handle("CHAFF_COUNT")
FLARES_count = get_param_handle("FLARE_COUNT")


local iCommandPlaneDropFlareOnce = 357
local iCommandPlaneDropChaffOnce = 358
local iCommandActiveJamming		 = 359

--dev:listen_command(device_commands.ECM)	
dev:listen_command(device_commands.MasterArmCMs)
dev:listen_command(device_commands.ChaffSelector)
dev:listen_command(device_commands.FlareSelector)
--dev:listen_command(device_commands.FLAREFIRE)
--dev:listen_command(device_commands.CHAFFFIRE)
dev:listen_command(iCommandActiveJamming)
dev:listen_command(iCommandPlaneDropFlareOnce)
dev:listen_command(iCommandPlaneDropChaffOnce)


function post_initialize()

	local birth = LockOn_Options.init_conditions.birth_place	--"GROUND_COLD","GROUND_HOT","AIR_HOT"
    if birth=="GROUND_HOT" or birth=="AIR_HOT" then 	 
        dev:performClickableAction(device_commands.MasterArmCMs,1,true) 
		dispatch_action(nil,device_commands.MasterArmCMs,1)
        dev:performClickableAction(device_commands.ECM,1,true)
		dispatch_action(nil,device_commands.ECM,1) 	
		
    elseif birth=="GROUND_COLD" then
        dev:performClickableAction(device_commands.MasterArmCMs,0,true)
	end
end



function SetCommand(command,value)
ArmCMs = get_cockpit_draw_argument_value(44)
ArmChaff = get_cockpit_draw_argument_value(47)
ArmFlare = get_cockpit_draw_argument_value(48)

if elec_dc_ok:get()== 1 then
	if command == iCommandPlaneDropChaffOnce and ArmCMs == 1 and ArmChaff == 1 then
		--dev:performClickableAction(device_commands.CHAFFFIRE,1,true)
		dev:drop_chaff() -- first param is count, second param is dispenser number (see chaff_flare_dispenser in aircraft definition)
		print_message_to_user("Chaff  ")
	elseif command == device_commands.CHAFFFIRE then
		--dev:performClickableAction(device_commands.CHAFFFIRE,1,true)
		dev:drop_chaff(1,2)

	end

	if command == iCommandPlaneDropFlareOnce and ArmCMs == 1 and ArmFlare == 1 then
		--dev:performClickableAction(device_commands.FLAREFIRE,1,true)
		dev:drop_flare()
		print_message_to_user("Flare  ")
	elseif command == device_commands.FLAREFIRE then
		--dev:performClickableAction(device_commands.FLAREFIRE,1,true)
		dev:drop_flare(1,3)

	end
end
	
	if command == device_commands.MasterArmCMs then
	MasterArmCMs = value
	end
	if command == device_commands.ChaffSelector then
	ChaffSelector = value
	end
	if command == device_commands.FlareSelector then
	FlareSelector = value
	end
	if command == device_commands.ECM then
	ECMVal = value
	end
	if command == iCommandActiveJamming then
	ActiveJam = value
	end
end

function ECM() 
ECMVal1 = get_cockpit_draw_argument_value(45)


if elec_dc_ok:get()== 1 then
if ECMVal1 == 1 then
dev:set_ECM_status(true)
else 
dev:set_ECM_status(false)
end
end
end
 
	
function Countercount() 
    --print_message_to_user("Countermeasures remaining: Flares = "..tostring(dev:get_flare_count()).." Chaff = "..tostring(dev:get_chaff_count()))
 
chaff_count = dev:get_chaff_count()
flare_count = dev:get_flare_count()
 
end
	

function update() 

ECM()
Countercount() 

CHAFFS_count:set(chaff_count)
FLARES_count:set(flare_count)

end


need_to_be_closed = false -- close lua state after initialization


--[[
available functions:
["get_station_info"] 
["set_ECM_status"] 
["get_ECM_status"]  
["launch_station"] 
["select_station"] 
["emergency_jettison"]  
["emergency_jettison_rack"] 
["set_target_range"]  
["set_target_span"]  
["get_target_range"]  
["get_target_span"]  
["get_flare_count"]  
["drop_flare"] 
["get_chaff_count"] 
["drop_chaff"] 

["listen_event"]  
["performClickableAction"] 
["SetDamage"] 
["listen_command"] 
["SetCommand"] 
--]]
