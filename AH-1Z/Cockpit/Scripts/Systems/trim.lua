dofile(LockOn_Options.script_path.."command_defs.lua")

local dev = GetSelf()
local update_rate = 0.05
make_default_activity(update_rate)

local pitchTrim = 0.0
local rollTrim = 0.0

dev:listen_command(EFM_commands.trimUp)
dev:listen_command(EFM_commands.trimDown)
dev:listen_command(EFM_commands.trimLeft)
dev:listen_command(EFM_commands.trimRight)
dev:listen_command(EFM_commands.trimReset)
dev:listen_command(EFM_commands.trimSave)

local function clamp(v, lo, hi)
    if v < lo then return lo end
    if v > hi then return hi end
    return v
end

function SetCommand(command, value)
    if value == nil or value <= 0 then
        return
    end

    if command == EFM_commands.trimUp then
        pitchTrim = clamp(pitchTrim + 0.003, -1.0, 1.0)
    elseif command == EFM_commands.trimDown then
        pitchTrim = clamp(pitchTrim - 0.003, -1.0, 1.0)
    elseif command == EFM_commands.trimLeft then
        rollTrim = clamp(rollTrim - 0.003, -1.0, 1.0)
    elseif command == EFM_commands.trimRight then
        rollTrim = clamp(rollTrim + 0.003, -1.0, 1.0)
    elseif command == EFM_commands.trimReset then
        pitchTrim = 0.0
        rollTrim = 0.0
    elseif command == EFM_commands.trimSave then
        -- Force trim is owned by the EFM. This Lua device only mirrors trim switch animation.
    end
end

function update()
    set_aircraft_draw_argument_value(601, pitchTrim)
    set_aircraft_draw_argument_value(602, rollTrim)
end

need_to_be_closed = false
