local sensor_data = get_base_data()

local update_time_step = 0.02
make_default_activity(update_time_step)

local ARG_WIND_DIRECTION = 24
local ARG_WIND_PROP = 25

local direction_arg = 0.0
local prop_arg = 0.0

local function clamp(value, min_value, max_value)
    if type(value) ~= "number" then return min_value end
    if value < min_value then return min_value end
    if value > max_value then return max_value end
    return value
end

local function read_sensor(method_name)
    if sensor_data == nil then return 0.0 end

    local method = sensor_data[method_name]
    if type(method) ~= "function" then return 0.0 end

    local ok, value = pcall(function() return method(sensor_data) end)
    if ok and type(value) == "number" then return value end

    ok, value = pcall(function() return method() end)
    if ok and type(value) == "number" then return value end

    return 0.0
end

local function wrap_bipolar(value)
    while value > 1.0 do
        value = value - 2.0
    end
    while value < -1.0 do
        value = value + 2.0
    end
    return value
end

function post_initialize()
    set_aircraft_draw_argument_value(ARG_WIND_DIRECTION, 0.0)
    set_aircraft_draw_argument_value(ARG_WIND_PROP, 0.0)
end

function SetCommand(command, value)
end

function update()
    local tas = math.max(0.0, read_sensor("getTrueAirSpeed"))
    local aos = read_sensor("getAngleOfSlide")

    -- Arg 24 is keyed as -1..+1 over a full rotation. Angle of slide is
    -- relative airflow yaw in radians, so it gives the vane its weathercock.
    local target_direction = clamp(aos / math.pi, -1.0, 1.0)
    local response = clamp(5.0 * update_time_step, 0.0, 1.0)
    direction_arg = direction_arg + (target_direction - direction_arg) * response

    if tas > 1.0 then
        local spin_rate = 0.20 + clamp(tas / 70.0, 0.0, 1.0) * 2.80
        prop_arg = wrap_bipolar(prop_arg + spin_rate * update_time_step)
    end

    set_aircraft_draw_argument_value(ARG_WIND_DIRECTION, direction_arg)
    set_aircraft_draw_argument_value(ARG_WIND_PROP, prop_arg)
end

need_to_be_closed = false
