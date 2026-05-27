dofile(LockOn_Options.script_path.."command_defs.lua")

local ElectricWarnings = GetSelf()
local sensor_data = get_base_data()
local update_rate = 0.01
make_default_activity(update_rate)

elec_dc_ok  = get_param_handle("DC_POWER_AVAIL")


local elecwarn1 = 0 --
local elecwarn1 = get_param_handle("ELECWARN1")



function SetCommand(command,value)  


    local alt_adj = (alt_setting - ALT_PRESSURE_STD)*1000   -- 1000 feet per inHg / 10 feet per .01 inHg -- if we set higher pressure than actual => altimeter reads higher

    alt_10k:set((alt+alt_adj) % 100000)
    alt_1k:set((alt+alt_adj)  % 10000)
    alt_100s:set((alt+alt_adj) % 1000)
	

end






function update_radar_altitude()
	local pitch = (sensor_data.getPitch()*radian_to_degree)
	local roll = (sensor_data.getRoll()*radian_to_degree)
	if (pitch < 35 and pitch > -35) and (roll < 45 and roll > -45) then -- limits radar alt to only work when the radar is pointing the ground
		current_Ralt:set(sensor_data.getRadarAltitude()*meters_to_feet-6)
		Ralt_Off:set(0)	
	else
		current_Ralt:set(0)
		Ralt_Off:set(1)
	end
end


function update()
	update_lowalt()
	update_altimeter()
	update_radar_altitude()

	current_fuelT:set(sensor_data.getTotalFuelWeight()*KG_TO_POUNDS)
	current_hdg:set(360-(sensor_data.getHeading()*radian_to_degree))
	
	
	local tSpeed = sensor_data.getTrueAirSpeed() * 3.6 -- km/h
	local iSpeed = sensor_data.getIndicatedAirSpeed() * 3.6 -- km/h
	current_asi:set(iSpeed)
	current_tas:set(tSpeed)
	
	current_pitch:set(sensor_data.getPitch())
	current_roll:set(sensor_data.getRoll())

	local h = get_aircraft_draw_argument_value(69)-- to see if this affects ground crew
	-- print_message_to_user(" vi="..h)
	set_aircraft_draw_argument_value(69,-1)-- to see if this affects ground crew
	
	LOWALT:set(lowalt)
	
	
end


function update_lowalt()

	local NowRalt = sensor_data.getRadarAltitude()
	
if NowRalt < 30 then
	lowalt = lowalt + 0.1
end

if lowalt >= 1
	then lowalt = 0
end

if NowRalt > 30 then
	lowalt = 0
end

end

 

	
 



need_to_be_closed = false 
