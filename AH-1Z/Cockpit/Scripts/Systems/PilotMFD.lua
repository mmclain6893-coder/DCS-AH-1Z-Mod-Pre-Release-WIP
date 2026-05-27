
dofile(LockOn_Options.script_path.."command_defs.lua")

local dev = GetSelf()
local sensor_data = get_base_data()
local update_time_step = 0.03
make_default_activity(update_time_step)

local power = get_param_handle("PLT_MFD_POWER")
local brightness = get_param_handle("PLT_MFD_BRIGHTNESS")
local roll = get_param_handle("PILOT_ROLL")
local pitch = get_param_handle("PILOT_PITCH")
local heading = get_param_handle("PILOT_HEADING")
local alt = get_param_handle("PILOT_ALT")
local ias = get_param_handle("PILOT_IAS")
local vvi = get_param_handle("PILOT_VVI")
local button_flash = get_param_handle("PILOT_MFD_BUTTON_FLASH")

power:set(1.0)
brightness:set(1.0)
button_flash:set(0.0)

if device_commands.PilotMFDLeftButton then dev:listen_command(device_commands.PilotMFDLeftButton) end
if device_commands.PilotMFDRightButton then dev:listen_command(device_commands.PilotMFDRightButton) end
if device_commands.PilotDFDButton then dev:listen_command(device_commands.PilotDFDButton) end

local flash = 0.0

local function safe_value(fn, default)
    if sensor_data == nil or sensor_data[fn] == nil then return default end
    local ok, value = pcall(function() return sensor_data[fn](sensor_data) end)
    if ok and value ~= nil then return value end
    return default
end

function SetCommand(command, value)
    if value and value > 0 then
        flash = 1.0
    end
end

function update()
    roll:set(safe_value("getRoll", 0.0))
    pitch:set(safe_value("getPitch", 0.0))
    heading:set(math.deg(safe_value("getHeading", 0.0)) % 360.0)
    alt:set(safe_value("getBarometricAltitude", 0.0) * 3.28084)
    ias:set(safe_value("getIndicatedAirSpeed", 0.0) * 1.94384)
    vvi:set(safe_value("getVerticalVelocity", 0.0) * 196.8504)
    flash = flash * 0.82
    button_flash:set(flash)
end

need_to_be_closed = false
