local dev 	    = GetSelf()

local update_time_step = 0.1
make_default_activity(update_time_step) --update will be called 10 times per second

local sensor_data = get_base_data()

dev:listen_command(Gear)
dev:listen_command(GearUp)
dev:listen_command(GearDown)
dev:listen_command(GearHandle)


-- Variables
local P_HYD1 = get_param_handle("P_HYD1")
local P_HYD2 = get_param_handle("P_HYD2")
local L_HYD1 = get_param_handle("L_HYD1")
local L_HYD2 = get_param_handle("L_HYD2")
local rudder = get_param_handle("rudder")
local gear_conso = get_param_handle("gear_conso")
local flaps_conso = get_param_handle("flaps_conso")
local airbrake_conso = get_param_handle("airbrake_conso")

-- Initialisation
P_HYD1:set(0)
P_HYD2:set(0)
L_HYD1:set(0)
L_HYD2:set(0)
P_HYD1_L = 0
P_HYD2_L = 0
-- rudder:set(0)
gear_conso_L=0
airbrake_conso_L=0

make_default_activity(update_time_step)

local sensor_data = get_base_data()

function post_initialize()
	electric_system = GetDevice(3) 
end

function update_landinggearlight()


    local gear_handle_pos = get_cockpit_draw_argument_value(8)  -- 1==down, 0==up

    if command == Gear then
        if gear_handle_pos==1 then -- 1 = if down already
                dev:performClickableAction(GearHandle, 0, false) --now gear goes up

            end
        elseif gear_handle_pos==0 then -- 0 = if up already
            dev:performClickableAction(GearHandle, 1, false) --now gear goes down
      
		
elseif command == GearUp then
            dev:performClickableAction(GearHandle, 0, false)       -- gear handle animation:  0 = retracted, 1 = extended

    elseif command == GearDown then
        dev:performClickableAction(GearHandle, 1, false) 

    elseif command == GearHandle then
                  dispatch_action(nil,iCommandPlaneGear)
				
            end
			
		end
	



function update()

update_landinggearlight()

	local RPM1 = sensor_data.getEngineLeftRPM()
	local RPM2 = sensor_data.getEngineRightRPM()
	local aileron_command = sensor_data.getStickPitchPosition()/100
	local stablisator_command = sensor_data.getStickRollPosition()/100
	local rudder_command = -1*sensor_data.getRudderPosition()/100
	local Servo1 = 0
	local Servo2 = 0
		
	local Roll_conso  = 30 * math.abs(aileron_command)
	local Pitch_conso = 30 * math.abs(stablisator_command)
	local Rudder_conso = 20 * math.abs(rudder_command)

	-- local flaps_conso = 100
	-- local airbrake_conso = 100
	-- rudder:set(sensor_data.getRudderPosition())
	local gear_conso_L = gear_conso:get()
	local flaps_conso_L = flaps_conso:get()
	local airbrake_conso_L = airbrake_conso:get()
	
	-- Share of command actuators for ailerons, stab and rudder
	if RPM1 > 20 and RPM2 > 20 then
		Servo1 = Roll_conso/2 + Pitch_conso/2 + Rudder_conso/2
		Servo2 = Roll_conso/2 + Pitch_conso/2 + Rudder_conso/2
	end
	
	-- HYD1 only active
	if RPM1 > 20 and RPM2 < 20 then
		Servo1 = Roll_conso + Pitch_conso + Rudder_conso
		Servo2 = 0
	end
	
	-- HYD2 only active
	if RPM1 < 20 and RPM2 > 20 then
		Servo1 = 0
		Servo2 = Roll_conso + Pitch_conso + Rudder_conso
	end
	
	-- Hydraulic system 1 tied to Left Engine 
	if RPM1 > 20 then
		P_HYD1_L = 206 - Servo1 - gear_conso_L - airbrake_conso_L
		L_HYD1:set(0)
		else
		P_HYD1_L = 0
	end
	P_HYD1:set(P_HYD1_L/10)
	
	-- Hydraulic system 2 tied to Right Engine
	if RPM2 > 20 then
		P_HYD2_L = 206 - Servo2 - flaps_conso_L -- train secours
		L_HYD2:set(0)		
		else
		P_HYD2_L = 0
	end
	P_HYD2:set(P_HYD2_L/10)
	


end

need_to_be_closed = false -- close lua state after initialization


