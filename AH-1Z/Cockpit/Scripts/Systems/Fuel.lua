local dev = GetSelf()

dofile(LockOn_Options.script_path.."command_defs.lua")

local update_time_step = 0.01
make_default_activity(update_time_step)

elec_dc_ok  = get_param_handle("DC_POWER_AVAIL")
local sensor_data = get_base_data()
local fuelflow = get_param_handle("FUEL_FLOW")


function post_initialize()

end	

function SetCommand(command,value)
			
			
end


function FuelPower()

FuelPump = get_cockpit_draw_argument_value(23)
local RPM = sensor_data.getEngineLeftRPM()
local speed = sensor_data.getSelfVelocity()
local alt = sensor_data.getRadarAltitude()
local climb = sensor_data.getVerticalVelocity()


fueluse = (((RPM*3)+(climb/2)-((alt/100) + speed)))


if FuelPump == 1 then
fuelflow:set(fueluse)
end
--print_message_to_user("FuelFlow  "..fuelflow:get())

end



function update()
FuelPower()

if elec_dc_ok:get()==1 then

end
end
	
		

need_to_be_closed = false -- close lua 
