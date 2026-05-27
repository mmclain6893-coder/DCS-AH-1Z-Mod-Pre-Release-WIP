dofile(LockOn_Options.script_path.."command_defs.lua")

local dev = GetSelf()
local BeachBoysFLASH2 = 0
local update_rate = 0.01
make_default_activity(update_rate)

local TAPETURN1 = -1
elec_dc_ok  = get_param_handle("DC_POWER_AVAIL")
TAPETURN2  = get_param_handle("TAPETURN")



function post_initialize()

sndhost = create_sound_host("COCKPIT_ARMS","HEADPHONES",0,0,0)

BeachBoysSND = sndhost:create_sound("Aircrafts/UH1M/Cockpit/TheBeachBoys")
NowheretorunSND = sndhost:create_sound("Aircrafts/UH1M/Cockpit/Nowheretorun")
ValkyriesSND = sndhost:create_sound("Aircrafts/UH1M/Cockpit/RideofValkyries")
end


function SetCommand(command,value)
	if command == device_commands.BeachBoys then 	
				BeachBoys1 = value
				end
	if command == device_commands.Nowheretorun then 	
				Nowheretorun1 = value
				end
	if command == device_commands.Valkyries then 	
				Valkyries1 = value				
end
end



function play_BeachBoys()

if elec_dc_ok:get()==1 then
if  BeachBoys1 == 1 then 
	dev:performClickableAction(device_commands.Nowheretorun,0, true)	
	dev:performClickableAction(device_commands.Valkyries,0, true)
	TAPETURN1 = TAPETURN1 + 0.00495				
	BeachBoysSND:play_continue() 
end

if TAPETURN1 >= 1 then
TAPETURN1 = -1
end
end

if BeachBoys1 == 0 then
			BeachBoysSND:stop()
end
end


function play_Nowheretorun()
	
if elec_dc_ok:get()==1 then
if  Nowheretorun1 == 1 then 
	dev:performClickableAction(device_commands.BeachBoys,0, true)	
	dev:performClickableAction(device_commands.Valkyries,0, true)
	TAPETURN1 = TAPETURN1 + 0.00495
	NowheretorunSND:play_continue() 
end

if TAPETURN1 >= 1 then
TAPETURN1 = -1
end
end

if Nowheretorun1 == 0 then
			NowheretorunSND:stop()
end
end


function play_RideofValkyries()	
if elec_dc_ok:get()==1 then
if  Valkyries1 == 1 then 
	dev:performClickableAction(device_commands.BeachBoys,0, true)	
	dev:performClickableAction(device_commands.Nowheretorun,0, true)	
	TAPETURN1 = TAPETURN1 + 0.00495					
	ValkyriesSND:play_continue() 
end
if TAPETURN1 >= 1 then
TAPETURN1 = -1
end
end
	
if Valkyries1 == 0 then
			ValkyriesSND:stop()
end
end


--[[
function TAPETURN()

if elec_dc_ok:get()==1 then
if BeachBoys1 == 1 or Nowheretorun1 == 1 or Valkyries1 == 1 then
	TAPETURN1 = TAPETURN1 + 0.00495
end

if TAPETURN1 >= 1
	then TAPETURN1 = 0
end
end

	TAPETURN2:set(TAPETURN1)
end

]]


		
function update()

TAPETURN2:set(TAPETURN1)

play_BeachBoys()
play_Nowheretorun()
play_RideofValkyries()
 
end