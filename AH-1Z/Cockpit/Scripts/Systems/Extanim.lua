local dev = GetSelf()

local update_time_step = 0.02
make_default_activity(update_time_step) -- enables call to update


local sensor_data = get_base_data()


function post_initialize()

end


function SetCommand(command,value)

end

local pedals = get_param_handle("PEDAL_INPUT")



function update()

	local ROLL_STATE = sensor_data:getStickRollPosition() / 100
	set_aircraft_draw_argument_value(11, ROLL_STATE) -- right aileron
	set_aircraft_draw_argument_value(12, -ROLL_STATE) -- left aileron
	

	local PITCH_STATE = sensor_data:getStickPitchPosition() / 100
	set_aircraft_draw_argument_value(15, PITCH_STATE) -- right elevator
	set_aircraft_draw_argument_value(16, PITCH_STATE) -- left elevator

	local RUDDER_STATE = sensor_data:getRudderPosition() / 100
	--set_aircraft_draw_argument_value(202, pedals)


    local pitch_trim_handle = get_param_handle("PITCH_TRIM")
    local pitch_trim = pitch_trim_handle:get() -- from -0.24 (1deg down) to 1.0 (13 deg up)
    if pitch_trim>=0 then
        set_aircraft_draw_argument_value(117, pitch_trim)
    elseif pitch_trim<0 then
        set_aircraft_draw_argument_value(117, (1.0/0.24)*pitch_trim)
    end

    -- Gun elevation (arg 21): driven by pitch of gun system
    local gun_elev = get_param_handle("GUN_ELEVATION")
    if gun_elev then
        set_aircraft_draw_argument_value(21, gun_elev:get())
    end

    -- Wind direction pointer (arg 24): 0..1 = 0..360 deg
    local wind_dir = get_param_handle("WIND_DIRECTION")
    if wind_dir then
        set_aircraft_draw_argument_value(24, wind_dir:get())
    end

    -- Wind prop spin (arg 25): 0..1 = calm..max speed
    local wind_spd = get_param_handle("WIND_SPEED")
    if wind_spd then
        set_aircraft_draw_argument_value(25, wind_spd:get())
    end

	--set_aircraft_draw_argument_value(38, opendoor)
end
    


need_to_be_closed = false -- close lua state after initialization

