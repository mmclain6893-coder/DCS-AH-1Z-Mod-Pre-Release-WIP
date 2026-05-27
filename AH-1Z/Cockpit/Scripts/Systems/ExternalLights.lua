dofile(LockOn_Options.script_path.."command_defs.lua")

local dev = GetSelf()
local update_time_step = 0.01 --update will be called 10 times per second
make_default_activity(update_time_step)
local sensor_data = get_base_data()
elec_dc_ok  = get_param_handle("DC_POWER_AVAIL")

local  ANTICOL2 = 0

function post_initialize()

end


dev:listen_command(Keys.LandingLight)
dev:listen_command(Keys.PositionLights)
dev:listen_command(Keys.PlaneLightsOnOff)
dev:listen_command(Keys.ANTICOLOnOff)
dev:listen_command(device_commands.LandingLightSw)
dev:listen_command(device_commands.PositionLightSw)
dev:listen_command(device_commands.ANTICOLSw)
dev:listen_command(device_commands.PlaneLightsOnOffSw)
dev:listen_command(device_commands.FormationLights)
dev:listen_command(device_commands.Beacon)
dev:listen_command(device_commands.PanelLightsw)

local extLDG = 0  		
local ANTICOL = 0
local formationBrightness = 0
local PosLts = 0
local PlaneLights = 0 
local PanelLightsOn = 0




function post_initialize()
    local abstime = get_absolute_model_time()
    local hours = abstime / 3600.0


    local birth = LockOn_Options.init_conditions.birth_place
    if birth=="AIR_HOT"  then
	    if hours <= 6 or hours >= 17 then
        dev:performClickableAction(device_commands.PanelLightsw, 0.5, false)
        dev:performClickableAction(device_commands.PlaneLightsOnOffSw, 0, false)
   	end
	elseif birth=="GROUND_HOT" then
	    if hours <= 6 or hours >= 17 then
        dev:performClickableAction(device_commands.PanelLightsw, 1.0, false)
        dev:performClickableAction(device_commands.PlaneLightsOnOffSw, 1.0, false)
    end
	elseif birth=="GROUND_COLD" then
			    if hours <= 6 or hours >= 17 then
        dev:performClickableAction(device_commands.PanelLightsw, 1.0, false)
        dev:performClickableAction(device_commands.PlaneLightsOnOffSw, 1.0, false)           
    end
end
end



function SetCommand(command,value)
PanelLights = get_cockpit_draw_argument_value(10)

    if command == device_commands.LandingLightSw then
        extLDG = value
	elseif command == device_commands.PlaneLightsOnOffSw then
        PlaneLights = value
    elseif command == device_commands.PositionLightSw then
		PosLts = value
	elseif command == device_commands.ANTICOLSw then
		ANTICOL = value	
	elseif command == Keys.LandingLight then
		dev:performClickableAction(device_commands.LandingLightSw, (1-extLDG),true)
	elseif command == Keys.PositionLights then
		dev:performClickableAction(device_commands.PositionLightSw, (1-PosLts),true)
	elseif command == Keys.PlaneLightsOnOff then
		dev:performClickableAction(device_commands.PlaneLightsOnOffSw, (1-PlaneLights),true)
	elseif command == Keys.ANTICOLOnOff then
		dev:performClickableAction(device_commands.ANTICOLSw, (1-ANTICOL),true)
	end
	
	
	if command == device_commands.PanelLightsw then
	PanelLightsOn = value
	dev:performClickableAction(device_commands.PanelLightsw, PanelLightsOn, true)
	end

end

function flashlight()
if ANTICOL == 1 then
		ANTICOL2 =  ANTICOL2 + 0.0055
		
if ANTICOL2 >= 1 then
		ANTICOL2 = 0
end
end

	
if ANTICOL == 0 then
		ANTICOL2 = ANTICOL2 - 0.01
		
if ANTICOL2 <= 0 then
		ANTICOL2 = 0
			
end
end
end



function update()
flashlight()
	if elec_dc_ok:get()==1 then
	
		set_aircraft_draw_argument_value(2026,extLDG) --landing lights
		set_aircraft_draw_argument_value(13,PosLts) -- position lights
		set_aircraft_draw_argument_value(27,ANTICOL2) --ANTICOL lights

	else		-- no electrical power, turn lights off
		set_aircraft_draw_argument_value(2026,0)
		set_aircraft_draw_argument_value(13,0)		
		set_aircraft_draw_argument_value(27,0)

	end
end

need_to_be_closed = false 