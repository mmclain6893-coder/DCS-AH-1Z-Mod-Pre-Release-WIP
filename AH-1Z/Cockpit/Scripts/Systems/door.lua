local dev = GetSelf() 							-- naming the device after the file name... ie "door"

dofile(LockOn_Options.script_path.."command_defs.lua") -- making sure DCS has the commands loaded

local update_time_step = 0.01 			-- this means the device will update every 1/100th of a second -ish
make_default_activity(update_time_step)  

--elec_dc_ok  = get_param_handle("DC_POWER_AVAIL") -- this is needed if you need/want to ensure electric system working ...works with EFM only
local opendoor2 = 0
local opendoor1 = 0			-- defining for later
local door = 0				-- defining for later
local door1 = 0

dev:listen_command(Keys.Opendoor)			-- here is the key you defined in the command_defs.lua
dev:listen_command(device_commands.Opendoorsw)  -- -- here is the device command you defined in the command_defs.lua

function post_initialize()			-- not needed in this script

end	

function SetCommand(command,value)
			
			if command == device_commands.Opendoorsw then 	-- when device_doorsw has been called (by mouse click or a keyboard)
				door = value							-- door value is now either 0 or 1
			elseif command == Keys.Opendoor then 			-- listen for the key "door" defined in the "inputs folder" in keyboard default.lua
			dev:performClickableAction(device_commands.Opendoorsw, (1-door),true) -- makes the switch inside the cockpit move
			door = value
			end
			
			if command == device_commands.Opendoorsw1 then 	-- when device_doorsw has been called (by mouse click or a keyboard)
				door1 = value							-- door value is now either 0 or 1
end
end

--The following is a simple animation that increases the number "opendoor1" by 0.005 every 1/100th of a second (i.e. the dev update time). 
--The value "opendoor1" will then tell arg38 where to be in the timeframe. 
--Remember DCS time frame is from -1 to 1, our animation in the model is from 0 to 1, so we have to make "opendoor1"  a value between 0 and 1 to show an animating door open. 
--We have defined "opendoor1" as 0 earlier, so all this does is incrementally add 0.005 to the start value of 0 every 1/100th of a second.


function anim_door()					
		if  door == 1 then 						-- get the value for door from above: if it is 1 (i.e. clicked) then continue
			opendoor1 = opendoor1 + 0.005			-- then increase the value of opendoor1 by 0.005
		
		if opendoor1 >= 1 then					-- once the door is fully open (ie the arg is 1) then stop moving
				opendoor1 = 1
		
			end
		
		elseif door == 0 then
				opendoor1 = opendoor1 - 0.005  	-- same animation decreases the number "opendoor1" by 0.005 every 1/100th of a second
			if opendoor1 <= 0 then   			-- once the door is fully closed (ie the arg is 0) then stop moving at 0
			opendoor1 = 0
		end
end
		
if  door1 == 1 then 						-- get the value for door from above: if it is 1 (i.e. clicked) then continue
			opendoor2 = opendoor2 + 0.005			-- then increase the value of opendoor1 by 0.005
		
	if opendoor2 >= 1 then					-- once the door is fully open (ie the arg is 1) then stop moving
				opendoor2 = 1
		
	end
		
	elseif door1 == 0 then
				opendoor2 = opendoor2 - 0.005  	-- same animation decreases the number "opendoor1" by 0.005 every 1/100th of a second
			if opendoor2 <= 0 then   			-- once the door is fully closed (ie the arg is 0) then stop moving at 0
			opendoor2 = 0
	end
end

end

function update()

--if elec_dc_ok:get()==1 then -- check that the elctric is on before this animation will work
anim_door()
set_aircraft_draw_argument_value(38, opendoor1) -- the value "opendoor1" is used to tell the arg38 where to be in the timeframe		 
set_aircraft_draw_argument_value(39, opendoor2)
end


need_to_be_closed = false -- close lua 
