dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.common_script_path.."../../../Database/wsTypes.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."AI/AI_Gunners.lua")
local dev = GetSelf()
local update_rate = 0.01
make_default_activity(update_rate)

local StationSelect = 0
local pickle_engaged = false
local Selectweapon = 0
local GunSelect = 0
local ArmMaster =0



local sensor_data = get_base_data()


elec_dc_ok  = get_param_handle("DC_POWER_AVAIL")

dev:listen_command(Keys.GunSelector)
dev:listen_command(Keys.MasterArm)
dev:listen_command(Keys.ChangeWeapon)
dev:listen_command(device_commands.MasterArm)
dev:listen_command(device_commands.SalvoSw)
dev:listen_command(device_commands.GunSelector)
dev:listen_command(Keys.TriggerFireOn)
dev:listen_command(Keys.TriggerFireOff)
dev:listen_command(device_commands.MasterArm)
dev:listen_command(device_commands.TroopAlarm)
dev:listen_command(device_commands.TroopWarn)

local iCommandPlaneDropFlareOnce = 357
local iCommandPlaneDropChaffOnce = 358



function post_initialize()

    local birth = LockOn_Options.init_conditions.birth_place	--"GROUND_COLD","GROUND_HOT","AIR_HOT"
    if birth=="GROUND_HOT" or birth=="AIR_HOT" then 	 
        dev:performClickableAction(device_commands.MasterArm,1,true) 
		
    elseif birth=="GROUND_COLD" then
        dev:performClickableAction(device_commands.MasterArm,0,true)

    end

end



local release_timer = 0
local release_timer2 = 0
local release_timer3 = 0
local release_interval = 0.10 -- time between each shot rockets
local release_interval2 = 0.30 -- time between each shot marines
local release_interval3 = 2.0 -- time between each shot marine supplys
local singleFired = 0
local count = 0
local count1 = 0

function SetCommand(command,value)

	local DOORGUNNERL = dev:get_station_info(5)
	local DOORGUNNERR = dev:get_station_info(6)

	ArmMaster = get_cockpit_draw_argument_value(551)
	Selectweapon = get_cockpit_draw_argument_value(552)

			
	if command == device_commands.GunSelector then			
		GunSelect = Selectweapon + 0.5
	elseif command == Keys.GunSelector then
		GunSelect = Selectweapon + 0.5
		dev:performClickableAction(device_commands.GunSelector, (GunSelect),true)
	end
	
	if Selectweapon == 1 and (command == Keys.GunSelector or command == device_commands.GunSelector) then 
	GunSelect = -1
	dev:performClickableAction(device_commands.GunSelector, (GunSelect),true)
	end		
	

		
    if command == Keys.TriggerFireOn and elec_dc_ok:get() == 1 and ArmMaster == 1 and Selectweapon == -1.0 then -- rockets
			release_timer = release_timer + update_rate	
		if release_timer >= release_interval then
			dev:launch_station(2)
			dev:launch_station(3)
			release_timer = 0
		end
	end
	
   if 		command == Keys.TriggerFireOn and elec_dc_ok:get() == 1  and ArmMaster == 1 and Selectweapon == -0.5 then -- guns
			dev:launch_station(0)
			dev:launch_station(1)

	end

			if command == Keys.TriggerFireOn and elec_dc_ok:get() == 1  and ArmMaster == 1 and Selectweapon == 0.5 then -- grenade launcher / 2xM2s
			dev:launch_station(4)

	end
	
			if command == Keys.TriggerFireOn and elec_dc_ok:get() == 1 and ArmMaster == 1 and Selectweapon == 1.0 then -- Door guns
	
			dev:launch_station(5)
			dev:launch_station(6)

	end

			if command == Keys.TriggerFireOn and elec_dc_ok:get() == 1 	and ArmMaster == 1 and Selectweapon == 0.0 then -- nothing

	end
	



end




	

--[[ bollox
 print_message_to_user("Chaff  "..Chaffcount)
dev:drop_flare(1,1)
dev:listen_command(Keys.CH47DropFlareOnce)
dev:listen_command(Keys.CH47DropChaffOnce)		
dev:listen_command(device_commands.MasterArmCMs)
dev:listen_command(device_commands.ChaffSelector)
dev:listen_command(device_commands.FlareSelector)
	PlaneDropFlareOnce = 3571,
	PlaneDropChaffOnce = 3581,
	dev:set_ECM_status(true)
	local Flarecount = dev:get_flare_count() --?????????????     
local Chaffcount = dev:get_chaff_count()
ECM_status = dev:get_ECM_status()
 print_message_to_user("Flares  "..Flarecount)
 print_message_to_user("Chaff  "..Chaffcount)
 
 if ECM_status == true then
 
 print_message_to_user("ECM_status  on")
]]


function update() 



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
