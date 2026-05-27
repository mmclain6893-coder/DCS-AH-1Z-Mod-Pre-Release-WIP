
local dev = GetSelf()
dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."utils.lua")



local update_rate = 1/30
make_default_activity(update_rate)
local sensor_data = get_base_data()





function post_initialize()



end	


function update()

PilotAnim()
set_aircraft_draw_argument_value(1011, rotate) --animation -1 to +1
		 
end


function SetCommand(command,value)

end



function PilotAnim()


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
