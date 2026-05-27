local sensor_data = get_base_data()

local update_time_step = 0.01
make_default_activity(update_time_step)

local main_arg = 0.0
local tail_arg = 0.0
local rotor_spool = 0.0

local function clamp01(value)
    if type(value) ~= "number" then return 0.0 end
    if value < 0.0 then return 0.0 end
    if value > 1.0 then return 1.0 end
    return value
end

local function read_sensor(method_name)
    if sensor_data == nil then return 0.0 end

    local method = sensor_data[method_name]
    if type(method) ~= "function" then return 0.0 end

    -- Match the UH-1M pattern first: sensor_data:getEngineLeftRPM().
    local ok, value = pcall(function() return method(sensor_data) end)
    if ok and type(value) == "number" then
        return clamp01(value)
    end

    -- Some borrowed AH-1Z scripts call these as sensor_data.getEngineLeftRPM().
    ok, value = pcall(function() return method() end)
    if ok and type(value) == "number" then
        return clamp01(value)
    end

    return 0.0
end

local function read_cockpit_throttle()
    if get_cockpit_draw_argument_value == nil then return 0.0 end
    local ok, value = pcall(function() return get_cockpit_draw_argument_value(4) end)
    if ok and type(value) == "number" then
        return clamp01(value)
    end
    return 0.0
end

local function advance_bipolar_arg(value, rate)
    value = value + rate * update_time_step
    while value > 1.0 do
        value = value - 2.0
    end
    while value < -1.0 do
        value = value + 2.0
    end
    return value
end

function update()
    local throttle = read_sensor("getThrottleLeftPosition")
    if throttle <= 0.001 then
        throttle = read_cockpit_throttle()
    end

    local engine_rpm = read_sensor("getEngineLeftRPM")

    -- UH-1M uses base-data throttle/RPM; keep a small visual floor so the
    -- AH-1Z external rotor draw args do not quantize to a dead zero at spawn.
    local target = math.max(throttle, engine_rpm, 0.12)

    local response = 1.8 * update_time_step
    if response > 1.0 then response = 1.0 end
    rotor_spool = rotor_spool + (target - rotor_spool) * response

    local main_rate = 0.25 + 5.60 * rotor_spool
    local tail_rate = 1.00 + 22.40 * rotor_spool

    main_arg = advance_bipolar_arg(main_arg, main_rate)
    tail_arg = advance_bipolar_arg(tail_arg, tail_rate)

    set_aircraft_draw_argument_value(36, main_arg)
    set_aircraft_draw_argument_value(40, tail_arg)
end

need_to_be_closed = false
