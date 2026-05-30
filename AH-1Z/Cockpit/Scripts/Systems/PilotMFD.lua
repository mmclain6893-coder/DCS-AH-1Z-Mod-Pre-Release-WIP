dofile(LockOn_Options.script_path.."command_defs.lua")

local dev = GetSelf()
local sensor_data = get_base_data()
local update_time_step = 0.03
make_default_activity(update_time_step)

local PAGE_FLT = 1
local PAGE_WPN = 2
local PAGE_TSD = 3
local PAGE_SYS = 4
local PAGE_COM = 5
local PAGE_TSS = 6
local PAGE_WCA = 7
local PAGE_EW  = 8

local power = get_param_handle("PLT_MFD_POWER")
local brightness = get_param_handle("PLT_MFD_BRIGHTNESS")
local left_page = get_param_handle("PLT_MFD_LEFT_PAGE")
local right_page = get_param_handle("PLT_MFD_RIGHT_PAGE")
local dfd_page = get_param_handle("PLT_DFD_PAGE")
local button_flash = get_param_handle("PILOT_MFD_BUTTON_FLASH")

local roll = get_param_handle("PILOT_ROLL")
local pitch = get_param_handle("PILOT_PITCH")
local heading = get_param_handle("PILOT_HEADING")
local alt = get_param_handle("PILOT_ALT")
local ias = get_param_handle("PILOT_IAS")
local vvi = get_param_handle("PILOT_VVI")
local radar_alt = get_param_handle("PILOT_RADALT")
local aoa = get_param_handle("PILOT_AOA")

local master_arm = get_param_handle("AH1Z_MASTER_ARM")
local weapon_mode = get_param_handle("AH1Z_WEAPON_MODE")
local trigger_held = get_param_handle("AH1Z_TRIGGER_HELD")
local turret_yaw = get_param_handle("AH1Z_CHIN_TURRET_YAW")
local turret_pitch = get_param_handle("AH1Z_CHIN_TURRET_PITCH")
local reticle_yaw = get_param_handle("AH1Z_EYE_RETICLE_YAW")
local reticle_pitch = get_param_handle("AH1Z_EYE_RETICLE_PITCH")

power:set(1.0)
brightness:set(1.0)
left_page:set(PAGE_FLT)
right_page:set(PAGE_TSS)
dfd_page:set(1)
button_flash:set(0.0)

local commands_to_listen = {
    device_commands.PilotMFDLeftButton,
    device_commands.PilotMFDRightButton,
    device_commands.PilotDFDButton,
    device_commands.PilotMFDLeftFLT,
    device_commands.PilotMFDLeftMAP,
    device_commands.PilotMFDLeftWPN,
    device_commands.PilotMFDLeftCOM,
    device_commands.PilotMFDLeftSYS,
    device_commands.PilotMFDLeftTDC,
    device_commands.PilotMFDLeftWCA,
    device_commands.PilotMFDLeftEW,
    device_commands.PilotMFDLeftTCC,
    device_commands.PilotMFDRightFLT,
    device_commands.PilotMFDRightMAP,
    device_commands.PilotMFDRightWPN,
    device_commands.PilotMFDRightCOM,
    device_commands.PilotMFDRightSYS,
    device_commands.PilotMFDRightTDC,
    device_commands.PilotMFDRightWCA,
    device_commands.PilotMFDRightTSS,
    device_commands.PilotDFDFLT,
}

for _, command in ipairs(commands_to_listen) do
    if command then dev:listen_command(command) end
end

local left_page_commands = {
    [device_commands.PilotMFDLeftFLT] = PAGE_FLT,
    [device_commands.PilotMFDLeftMAP] = PAGE_TSD,
    [device_commands.PilotMFDLeftWPN] = PAGE_WPN,
    [device_commands.PilotMFDLeftCOM] = PAGE_COM,
    [device_commands.PilotMFDLeftSYS] = PAGE_SYS,
    [device_commands.PilotMFDLeftTDC] = PAGE_TSS,
    [device_commands.PilotMFDLeftWCA] = PAGE_WCA,
    [device_commands.PilotMFDLeftEW] = PAGE_EW,
    [device_commands.PilotMFDLeftTCC] = PAGE_TSS,
}

local right_page_commands = {
    [device_commands.PilotMFDRightFLT] = PAGE_FLT,
    [device_commands.PilotMFDRightMAP] = PAGE_TSD,
    [device_commands.PilotMFDRightWPN] = PAGE_WPN,
    [device_commands.PilotMFDRightCOM] = PAGE_COM,
    [device_commands.PilotMFDRightSYS] = PAGE_SYS,
    [device_commands.PilotMFDRightTDC] = PAGE_TSS,
    [device_commands.PilotMFDRightWCA] = PAGE_WCA,
    [device_commands.PilotMFDRightTSS] = PAGE_TSS,
}

local flash = 0.0

local function safe_value(fn, default)
    if sensor_data == nil or sensor_data[fn] == nil then return default end
    local ok, value = pcall(function() return sensor_data[fn](sensor_data) end)
    if ok and value ~= nil then return value end
    return default
end

local function cycle_page(param)
    local value = math.floor(param:get() + 0.5) + 1
    if value > PAGE_EW then value = PAGE_FLT end
    param:set(value)
end

function post_initialize()
    power:set(1.0)
    brightness:set(1.0)
    left_page:set(PAGE_FLT)
    right_page:set(PAGE_TSS)
    dfd_page:set(1)
end

function SetCommand(command, value)
    if value ~= nil and value <= 0 then return end

    if left_page_commands[command] then
        left_page:set(left_page_commands[command])
    elseif right_page_commands[command] then
        right_page:set(right_page_commands[command])
    elseif command == device_commands.PilotMFDLeftButton then
        cycle_page(left_page)
    elseif command == device_commands.PilotMFDRightButton then
        cycle_page(right_page)
    elseif command == device_commands.PilotDFDButton or command == device_commands.PilotDFDFLT then
        dfd_page:set(1)
    end

    flash = 1.0
end

function update()
    roll:set(safe_value("getRoll", 0.0))
    pitch:set(safe_value("getPitch", 0.0))
    heading:set(math.deg(safe_value("getHeading", 0.0)) % 360.0)
    alt:set(safe_value("getBarometricAltitude", 0.0) * 3.28084)
    ias:set(safe_value("getIndicatedAirSpeed", 0.0) * 1.94384)
    vvi:set(safe_value("getVerticalVelocity", 0.0) * 196.8504)
    radar_alt:set(safe_value("getRadarAltitude", 0.0) * 3.28084)
    aoa:set(math.deg(safe_value("getAngleOfAttack", 0.0)))

    -- Touch shared params so cold-start/default cases draw deterministic values.
    master_arm:set(master_arm:get())
    weapon_mode:set(weapon_mode:get())
    trigger_held:set(trigger_held:get())
    turret_yaw:set(turret_yaw:get())
    turret_pitch:set(turret_pitch:get())
    reticle_yaw:set(reticle_yaw:get())
    reticle_pitch:set(reticle_pitch:get())

    flash = flash * 0.82
    button_flash:set(flash)
end

need_to_be_closed = false
