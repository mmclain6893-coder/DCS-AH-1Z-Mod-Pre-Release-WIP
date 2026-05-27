dofile(LockOn_Options.script_path .. "command_defs.lua")

local dev = GetSelf()
local sensor_data = get_base_data()
local update_time_step = 0.02
make_default_activity(update_time_step)

local birth_place = "GROUND_COLD"
local startup_ticks = 0
local startup_tick_limit = 24
local main_phase = 0.0
local tail_phase = 0.0
local spool = 0.0

local function clamp01(value)
    if type(value) ~= "number" then return 0.0 end
    if value < 0.0 then return 0.0 end
    if value > 1.0 then return 1.0 end
    return value
end

local function send(command, value)
    dispatch_action(nil, command, value)
end

local function configure_hot()
    send(EFM_commands.throttleIdleCutoff, 0.0)
    send(EFM_commands.batterySwitch, 1.0)
    send(EFM_commands.generatorSwitch, 1.0)
    send(EFM_commands.inverterSwitch, 0.0)
    send(EFM_commands.throttle, 1.0)
end

local function configure_cold()
    send(EFM_commands.throttleIdleCutoff, 1.0)
    send(EFM_commands.batterySwitch, 0.0)
    send(EFM_commands.generatorSwitch, 0.0)
    send(EFM_commands.inverterSwitch, 0.0)
    send(EFM_commands.throttle, 0.0)
end

local function read_sensor(method_name)
    if sensor_data == nil then return 0.0 end
    local method = sensor_data[method_name]
    if type(method) ~= "function" then return 0.0 end

    local ok, value = pcall(function() return method(sensor_data) end)
    if ok and type(value) == "number" then return clamp01(value) end

    ok, value = pcall(function() return method() end)
    if ok and type(value) == "number" then return clamp01(value) end

    return 0.0
end

local function read_arg(arg)
    if get_cockpit_draw_argument_value == nil then return 0.0 end
    local ok, value = pcall(function() return get_cockpit_draw_argument_value(arg) end)
    if ok and type(value) == "number" then return clamp01(value) end
    return 0.0
end

local function set_arg(arg, value)
    set_aircraft_draw_argument_value(arg, value)
    if set_cockpit_draw_argument_value ~= nil then
        set_cockpit_draw_argument_value(arg, value)
    end
end

local function advance01(value, rate)
    value = value + rate * update_time_step
    while value > 1.0 do value = value - 1.0 end
    while value < 0.0 do value = value + 1.0 end
    return value
end

local function bipolar_phase(v)
    local p = v % 1.0
    if p < 0.5 then
        return p * 2.0
    end
    return (p - 1.0) * 2.0
end
function post_initialize()
    birth_place = LockOn_Options.init_conditions.birth_place or "GROUND_COLD"
    startup_ticks = 0
end

function update()
    if startup_ticks < startup_tick_limit then
        if birth_place == "GROUND_HOT" or birth_place == "AIR_HOT" then
            configure_hot()
        elseif startup_ticks == 0 then
            configure_cold()
        end
        startup_ticks = startup_ticks + 1
    end

    local throttle = read_sensor("getThrottleLeftPosition")
    if throttle <= 0.001 then throttle = read_arg(4) end

    local rpm = read_sensor("getEngineLeftRPM")
    if rpm <= 0.001 then rpm = read_arg(118) end

    local target = math.max(throttle, rpm, 0.12)
    local response = 2.5 * update_time_step
    if response > 1.0 then response = 1.0 end
    spool = spool + (target - spool) * response

    if spool <= 0.005 then
        set_arg(36, 0.0)
        set_arg(37, 0.0)
        set_arg(40, 0.0)
        return
    end

    main_phase = advance01(main_phase, 5.40 * spool)
    tail_phase = advance01(tail_phase, 21.60 * spool)

    set_arg(36, bipolar_phase(main_phase))
    set_arg(37, bipolar_phase(main_phase))
    set_arg(40, bipolar_phase(tail_phase))
end

need_to_be_closed = false


