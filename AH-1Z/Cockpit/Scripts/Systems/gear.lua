local dev = GetSelf()

dofile(LockOn_Options.script_path.."command_defs.lua")

local update_time_step = 0.01
make_default_activity(update_time_step)

elec_dc_ok  = get_param_handle("DC_POWER_AVAIL")



local movegear = 1
local gearhandlepos = 0


dev:listen_command(Keys.PlaneGear)
dev:listen_command(Keys.PlaneGearUp)
dev:listen_command(Keys.PlaneGearDown)

dev:listen_command(device_commands.PlaneGearsw)



function post_initialize()
    local birth = LockOn_Options.init_conditions.birth_place
	if birth=="AIR_HOT" then
		--movegear = 0
		--gearhandlepos = 0
		dev:performClickableAction(device_commands.PlaneGearsw,0,true)
		--set_cockpit_draw_argument_value(5000,1)
	set_aircraft_draw_argument_value(5000,0)     -- nose gear draw angle
    set_aircraft_draw_argument_value(5003,0)    -- right gear draw angle
    set_aircraft_draw_argument_value(5005,0)
	
    elseif birth=="GROUND_HOT" then
	--movegear = 1
	--gearhandlepos = 1
		dev:performClickableAction(device_commands.PlaneGearsw,1,true)
				--set_cockpit_draw_argument_value(5000,1)
	set_aircraft_draw_argument_value(5000,1)     -- nose gear draw angle
    set_aircraft_draw_argument_value(5003,1)    -- right gear draw angle
    set_aircraft_draw_argument_value(5005,1)
	
    elseif birth=="GROUND_COLD" then
	--movegear = 1
	--gearhandlepos = 1
		dev:performClickableAction(device_commands.PlaneGearsw,1,true)
	--set_cockpit_draw_argument_value(5000,0)
	set_aircraft_draw_argument_value(5000,1)     -- nose gear draw angle
    set_aircraft_draw_argument_value(5003,1)    -- right gear draw angle
    set_aircraft_draw_argument_value(5005,1)
    end
end	


function SetCommand(command,value)

--local gearhandlepos = get_cockpit_draw_argument_value(8) -- 1=down 0=up

			if command == device_commands.PlaneGearsw then
				gearhandlepos = value
				
			elseif command == Keys.PlaneGear then
			dev:performClickableAction(device_commands.PlaneGearsw, (1-gearhandlepos),true) -- makes the switch inside cockpit move
			

end
end


function anim_gear()

local gearhandlepos = get_cockpit_draw_argument_value(5000) -- 1=down 0=up
		if  gearhandlepos == 1 then 
			movegear =  movegear + 0.003
			if movegear>=1 then movegear = 1
			end
		elseif gearhandlepos == 0 then
				movegear = movegear - 0.003
			if movegear<=0 then movegear = 0
			end
		end
		end


function update()

if elec_dc_ok:get()==1 then
	anim_gear()

    set_aircraft_draw_argument_value(5000,movegear)     -- nose gear draw angle
    set_aircraft_draw_argument_value(5003,movegear)    -- right gear draw angle
    set_aircraft_draw_argument_value(5005,movegear)     -- left gear draw angle	 
end
end
	
		

need_to_be_closed = false -- close lua 
