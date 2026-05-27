-- this file needed to animate the dev and sounds.... does NOT work in the weaponsystem.lua 
local GUNNERS = GetSelf()
dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."utils.lua")



local update_rate = 1/30
make_default_activity(update_rate)
local sensor_data = get_base_data()

local gunfire = false
local rotate = 0

GUNNERS:listen_command(Keys.TriggerFireOn)
GUNNERS:listen_command(Keys.TriggerFireOff)



function post_initialize()



end	


function update()

anim_fire()
set_aircraft_draw_argument_value(20, rotate) --animation -1 to +1
		 
end


function SetCommand(command,value)
			
			if command == Keys.TriggerFireOn  then
			gunfire = true

	elseif 	command == Keys.TriggerFireOff  then
			gunfire = false
end
end



function anim_fire()


		if  gunfire == true and (count <2.2) then 
	
				count = count + 0.019	
				rotate =  rotate + count
			if rotate >= 1 then
				rotate = -0.9
			end
			
		elseif count >= 1 then 

				rotate = -1
		end
	
		
		if gunfire == false then

				count = 0
				rotate = -1
		end
		end

	
		

need_to_be_closed = false -- close lua 
