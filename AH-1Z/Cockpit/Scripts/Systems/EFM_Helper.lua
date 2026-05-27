dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.common_script_path.."devices_defs.lua")
--dofile(LockOn_Options.script_path.."Systems/Engine.lua")
-- This device is used to help initialize clickable switches and to interface keyboard bindings with clickables
-- performClickableAction doesn't seem to send the command to the EFM, so dispatch_action is used for that

local update_rate = 0.5
make_default_activity(update_rate)
local dev = GetSelf()
local sensor_data = get_base_data()
local enginestage_param2 = get_param_handle("ENGINESTAGE")

local SHOW_CONTROLS  = get_param_handle("SHOW_CONTROLS")
local enginedisplay = 0
local Rotorbrake = true

function post_initialize()
	sndhost = create_sound_host("COCKPIT_ARMS","HEADPHONES",-1.0,1.0,0)   
	UH1MStarter = sndhost:create_sound("Aircrafts/UH1M/Cockpit/UH1CStarter")

	SHOW_CONTROLS:set(1)
    local birth = LockOn_Options.init_conditions.birth_place
    if birth=="AIR_HOT"  then
		dev:performClickableAction(EFM_commands.throttleIdleCutoff, 0, true)
		dispatch_action(nil,EFM_commands.throttleIdleCutoff,0)
		dev:performClickableAction(EFM_commands.generatorSwitch, 1, true)
		dispatch_action(nil,EFM_commands.generatorSwitch,0)
		dev:performClickableAction(EFM_commands.batterySwitch,1,true) 
		dispatch_action(nil,EFM_commands.batterySwitch,1)
		dev:performClickableAction(EFM_commands.generatorSwitch,1,true)
		dispatch_action(nil,EFM_commands.generatorSwitch,1)
		dev:performClickableAction(EFM_commands.inverterSwitch,0,true)
		dispatch_action(nil,EFM_commands.inverterSwitch,0)
		dev:performClickableAction(EFM_commands.throttle,1,true)
		dispatch_action(nil,EFM_commands.throttle,1)
		enginedisplay = 10
		
	
		
	elseif birth=="GROUND_HOT" then
		dev:performClickableAction(EFM_commands.throttleIdleCutoff, 0, true)
		dev:performClickableAction(EFM_commands.generatorSwitch, 1, true)
		dev:performClickableAction(EFM_commands.batterySwitch,1,true) 
		dev:performClickableAction(EFM_commands.generatorSwitch,1,true)
		dev:performClickableAction(EFM_commands.inverterSwitch,0,true)
		dev:performClickableAction(EFM_commands.throttle, 0,true)
		dispatch_action(nil,EFM_commands.throttle,0)

		
    elseif birth=="GROUND_COLD" then
		dev:performClickableAction(EFM_commands.throttleIdleCutoff, 1, true)
		dev:performClickableAction(EFM_commands.generatorSwitch, 0, true)
		dev:performClickableAction(EFM_commands.batterySwitch,0,true) 
		dev:performClickableAction(EFM_commands.generatorSwitch,0,true)
		dev:performClickableAction(EFM_commands.inverterSwitch,0,true)
		dev:performClickableAction(EFM_commands.throttle, 0,true)
		
	print_message_to_user("for Start Up Procedure read 'Bell UH-1M Startup.txt'")

end
end
local JoystickThrottle	= 2004



dev:listen_command(Keys.BattSwitch)
dev:listen_command(Keys.ExtPwrSwitch)
dev:listen_command(Keys.ThrottleIncrease)
dev:listen_command(Keys.ThrottleDecrease)
dev:listen_command(Keys.ThrottleCutoff)
dev:listen_command(Keys.showControlInd)
dev:listen_command(EFM_commands.JoystickThrottle)


collective = get_param_handle("COLLECTIVE_INPUT")

function SetCommand(command,value)

Starterpos = get_cockpit_draw_argument_value(58)	
Emergencyfuelcut = get_cockpit_draw_argument_value(18)	
PwrSwpos = get_cockpit_draw_argument_value(17)
Throtpos = get_cockpit_draw_argument_value(4)

	if command == Keys.BattSwitch then
		if PwrSwpos == 1 then
			dev:performClickableAction(EFM_commands.batterySwitch,0,true)
			dispatch_action(nil,EFM_commands.batterySwitch,0)
		elseif PwrSwpos < 1 then
			dev:performClickableAction(EFM_commands.batterySwitch,1,true)
			dispatch_action(nil,EFM_commands.batterySwitch,1)
		end
	elseif command == Keys.ExtPwrSwitch then
		if PwrSwpos == -1 then
			dev:performClickableAction(EFM_commands.batterySwitch,0,true)
			dispatch_action(nil,EFM_commands.batterySwitch,0)
		elseif PwrSwpos > -1 then
			dev:performClickableAction(EFM_commands.batterySwitch,-1,true)
			dispatch_action(nil,EFM_commands.batterySwitch,-1)
		end
	elseif command==Keys.ThrottleIncrease then
		local amount = Throtpos + 0.002
			if amount > 0.998 then		--if amount > 0.998 then
			amount = 0.998					--amount = 0.998
		end
		dev:performClickableAction(EFM_commands.throttle,amount,true)
		dispatch_action(nil,EFM_commands.throttle,amount)
	elseif command==Keys.ThrottleDecrease then
		dev:performClickableAction(EFM_commands.throttle,Throtpos - 0.002,true)
		dispatch_action(nil,EFM_commands.throttle,Throtpos - 0.002)
	elseif command==Keys.ThrottleCutoff then
		ICpos = get_cockpit_draw_argument_value(5)
		dev:performClickableAction(EFM_commands.throttleIdleCutoff,1-ICpos,true)
		dispatch_action(nil,EFM_commands.throttleIdleCutoff,1-ICpos)
	elseif command==EFM_commands.starterButton then
		Starterpos = get_cockpit_draw_argument_value(58)
		dev:performClickableAction(EFM_commands.starterButton, (1-Starterpos),true)
		dispatch_action(nil,EFM_commands.starterButton,1-Starterpos)
	elseif command == Keys.showControlInd then
		SHOW_CONTROLS:set(1-SHOW_CONTROLS:get())
		end	


if command==device_commands.Hints then
Hintsw = value
end

	
	Collective2 = JoystickThrottle
	
end



external_power = get_param_handle("EXTERNAL_POWER")
external_power:set(0)



dev:listen_event("GroundPowerOn")
dev:listen_event("GroundPowerOff")

function CockpitEvent(event,val)
    if event == "GroundPowerOn" then
        external_power:set(1)
    elseif event == "GroundPowerOff" then
        external_power:set(0)
    end
	
	
end




function RotorDip()
    -- UH-1M uses arg 36 for rotor dip/RPM visuals while arg 37 carries
    -- rotation. AH-1Z's current EDM uses arg 36 for main-rotor rotation, so
    -- do not write it from the cockpit helper. The FM owns args 36/37/40.
end

function reset()
local HINTSW1 = get_cockpit_draw_argument_value(97)
if HINTSW1 == -1 then
		dev:performClickableAction(EFM_commands.batterySwitch,0,true) 
				dispatch_action(nil,EFM_commands.batterySwitch,0)
		dev:performClickableAction(EFM_commands.generatorSwitch, 0)
			dispatch_action(nil,EFM_commands.generatorSwitch,0)
		dev:performClickableAction(EFM_commands.inverterSwitch, 0)	
			dispatch_action(nil,EFM_commands.inverterSwitch,0)		
		dev:performClickableAction(EFM_commands.throttle, 0)
			dispatch_action(nil,EFM_commands.throttle,0)		
		dev:performClickableAction(EFM_commands.throttleIdleCutoff, 1)
			dispatch_action(nil,EFM_commands.throttleIdleCutoff,1)


end
end


function update()

reset()
RotorDip()

enginedisplay = enginestage_param2:get()

end


need_to_be_closed = false -- close lua state after initialization
