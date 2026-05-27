dofile(LockOn_Options.script_path.."command_defs.lua")

local dev = GetSelf()
local sensor_data = get_base_data()
local update_time_step = 0.05  
make_default_activity(update_time_step)

local meters_to_feet = 3.2808399
local feet_per_meter_per_minute = meters_to_feet * 60
local radian_to_degree = 57.2957795

local KG_TO_POUNDS = 2.20462
elec_dc_ok  = get_param_handle("DC_POWER_AVAIL")

local ALT_PRESSURE_MAX = 30.99 -- in Hg
local ALT_PRESSURE_MIN = 29.10 -- in Hg
local ALT_PRESSURE_STD = 29.92 -- in Hg

local alt_10k = get_param_handle("ALT_10000") -- 0 to 100,000
local alt_1k = get_param_handle("ALT_1000") -- 0 to 10,000
local alt_100s = get_param_handle("ALT_100") -- 0 to 1000
local alt_adj_Nxxx = get_param_handle("ALT_ADJ_Nxxx") -- 1st digit, 0-10 is input
local alt_adj_xNxx = get_param_handle("ALT_ADJ_xNxx") -- 2nd digit, 0-10 input
local alt_adj_xxNx = get_param_handle("ALT_ADJ_xxNx") -- 3rd digit, 0-10 input
local alt_adj_xxxN = get_param_handle("ALT_ADJ_xxxN") -- 4th digit, 0-10 input
local alt_adj_MBNxxx = get_param_handle("ALT_ADJ_MBNxxx") -- 
local alt_adj_MBxNxx = get_param_handle("ALT_ADJ_MBxNxx") -- 
local alt_adj_MBxxNx = get_param_handle("ALT_ADJ_MBxxNx") -- 
local alt_adj_MBxxxN = get_param_handle("ALT_ADJ_MBxxxN") -- 
local current_Ralt = get_param_handle("CURRENT_RALT")
local Ralt_Off = get_param_handle("RALT_OFF")
local current_hdg = get_param_handle("CURRENT_HDG")
local magheading = get_param_handle("MAGHEADING")
local offoncompass = get_param_handle("OFFONCOMPASS")
local current_fuelT  = get_param_handle("CURRENT_FUELT")

local current_tas = get_param_handle("CURRENT_TAS")
local current_asi = get_param_handle("CURRENT_ASI")

local current_pitch = get_param_handle("CURRENT_PITCH")
local current_roll = get_param_handle("CURRENT_ROLL")

local test = get_param_handle("TEST_PARAM")

local ROLL_F = get_param_handle("ROLL_F")
local YAM_F = get_param_handle("YAM_F")


local alt_setting = ALT_PRESSURE_STD
local HMD_STATE = get_param_handle("HMD_STATE")

local lowalt = -0.1
local LOWALT = get_param_handle("LOWALT")




alt_10k:set(0.0)
alt_1k:set(0.0)
alt_100s:set(0.0)
current_Ralt:set(0)
Ralt_Off:set(0)
current_hdg:set(0)
current_fuelT:set(0)
offoncompass:set(0)
magheading:set(0)

HMD_STATE:set(0)




function post_initialize()
    magheading:set(sensor_data.getMagneticHeading()*radian_to_degree)
	current_fuelT:set(sensor_data.getTotalFuelWeight()*KG_TO_POUNDS)
	current_hdg:set(360-(sensor_data.getHeading()*radian_to_degree))
	update_altimeter()
	local dev = GetSelf()
    local birth = LockOn_Options.init_conditions.birth_place	
    if birth=="GROUND_HOT" or birth=="AIR_HOT" then 			  
        		
    elseif birth=="GROUND_COLD" then
        		
    end
end

dev:listen_command(device_commands.AltimeterSet)

dev:listen_command(3571)
dev:listen_command(3581)
dev:listen_command(1507)


vs= 350
angle = 60
h0 = 20
g=9.80665


function SetCommand(command,value)  


-- print_message_to_user("command,value="..command) 
   if command == 1501 then
	h  = h0 + ( math.pow(vs * math.sin(math.rad(angle)), 2) / (2 * g))
	ve = math.sqrt(math.pow(vs * math.cos(math.rad(angle)),2) + (2 * g * h))
	
	ab =  math.atan( math.sqrt(2 * g * h) / (vs * math.cos(math.rad(angle))) ) 
	
	l = ((math.pow(vs, 2) *  math.sin( math.rad(2 * angle))) + (math.pow(ve, 2) * math.sin( math.rad(2 * ab)))) / ( 2 * g)
	print_message_to_user("ve="..ve)
	print_message_to_user("ab="..ab)
	print_message_to_user("l="..l)
	print_message_to_user("h="..h)
   end
   -- if command == 2142 then
		-- print_message_to_user("Horizontal="..value)
		-- set_aircraft_draw_argument_value(19, value / -100)   
		-- ROLL_F:set( value / -100)
	-- end
	
	if command == 1507 then
		if HMD_STATE:get() == 0 then
			HMD_STATE:set(1)
		else
			HMD_STATE:set(0)
		end
   end
   
	if command == 2143 then
		distance = 1 / math.sin( math.rad((value + 15)) )
		print_message_to_user("distance="..(distance).."/anlge="..(value + 15))
		-- set_aircraft_draw_argument_value(20, (value + 15) / 100)
		YAM_F:set( distance)
    end
	
	if command == device_commands.AltimeterSet then
		alt_setting = alt_setting + value/10
		if alt_setting > ALT_PRESSURE_MAX then
			alt_setting = ALT_PRESSURE_MAX
		elseif alt_setting < ALT_PRESSURE_MIN then
			alt_setting = ALT_PRESSURE_MIN
		end
	end
end


function update_altimeter()
    local alt = sensor_data.getBarometricAltitude()*meters_to_feet
	 -- first update the selected setting value displayed
    local altNxxx = math.floor(alt_setting/10)         
	local altxNxx = math.floor(alt_setting) % 10         
    local altxxNx = math.floor(alt_setting*10) % 10
    local altxxxN = math.floor(alt_setting*100) % 10
    alt_adj_Nxxx:set(altNxxx)
	alt_adj_xNxx:set(altxNxx)
    alt_adj_xxNx:set(altxxNx)
    alt_adj_xxxN:set(altxxxN)

	local settingMB = alt_setting * 33.8638867 -- convert inches of mercury to millibars
    local MBNxxx = math.floor(settingMB/1000)         
	local MBxNxx = math.floor(settingMB/100) % 10         
    local MBxxNx = math.floor(settingMB/10) % 10
    local MBxxxN = math.floor(settingMB) % 10
    alt_adj_MBNxxx:set(MBNxxx)
	alt_adj_MBxNxx:set(MBxNxx)
    alt_adj_MBxxNx:set(MBxxNx)
    alt_adj_MBxxxN:set(MBxxxN)
	
    -- based on setting, adjust displayed altitude
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

function compass()
compasson = get_cockpit_draw_argument_value(86)
if compasson == 1 then
offoncompass:set(360-(sensor_data.getHeading()*radian_to_degree))
elseif compasson == 0 then 
offoncompass:set(0)
end
end


function update_lowalt()

	local NowRalt = sensor_data.getRadarAltitude()

if elec_dc_ok:get()==1 then
if NowRalt < 30 then
	lowalt = lowalt + 0.01
end

if lowalt >= 1
	then lowalt = 0
end

if NowRalt > 30 then
	lowalt = 0
end
end
end






function update()

	compass()
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


 

	
 



need_to_be_closed = false 