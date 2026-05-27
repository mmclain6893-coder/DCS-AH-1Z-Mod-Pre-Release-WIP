dofile(LockOn_Options.script_path.."command_defs.lua")

local dev = GetSelf()
local sensor_data = get_base_data()

local update_time_step = 0.05  
make_default_activity(update_time_step)


local meters_to_feet = 3.2808399
local feet_per_meter_per_minute = meters_to_feet * 60
local radian_to_degree = 57.2957795
local KG_TO_POUNDS = 2.20462

local current_pitch = get_param_handle("CURRENT_PITCH")
local current_roll = get_param_handle("CURRENT_ROLL")

local RATE_YAW = get_param_handle("RATE_YAW")
local RATE_ROLL = get_param_handle("RATE_ROLL")
local RATE_PITCH = get_param_handle("RATE_PITCH")


function post_initialize()
    local birth = LockOn_Options.init_conditions.birth_place	
    if birth=="GROUND_HOT" or birth=="AIR_HOT" then 			  
        		
    elseif birth=="GROUND_COLD" then
        		
    end
end

vs= 350
angle = 60
h0 = 20
g=9.80665

for i=1,8000 do
dev:listen_command(i)
end

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
 end


function update()
	local pitch = (sensor_data.getPitch()*radian_to_degree)
	local roll = (sensor_data.getRoll()*radian_to_degree)
	local getSelfVelocity = (sensor_data.getSelfVelocity())
	
	RATE_YAW:set(math.abs(math.deg(sensor_data:getRateOfYaw())))     -- Yaw
    RATE_ROLL:set(math.abs(math.deg(sensor_data:getRateOfRoll())))   -- Roll
    RATE_PITCH:set(math.abs(math.deg(sensor_data:getRateOfPitch()))) -- Pitch
	
	-- print_message_to_user("RATE_YAW="..tostring(getSelfVelocity) )
	
	-- if RATE_YAW:get() > 0.1 then 
		-- dispatch_action(nil, 3009, (-RATE_YAW:get() / 10) + 0.2)
	-- end
	
end

need_to_be_closed = false 





