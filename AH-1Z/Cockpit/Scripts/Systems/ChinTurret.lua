dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.common_script_path.."devices_defs.lua")

local dev = GetSelf()
local update_rate = 0.02
make_default_activity(update_rate)

local slave_param          = get_param_handle("AH1Z_CHIN_RETICLE_SLAVE")
local turret_yaw_param     = get_param_handle("AH1Z_CHIN_TURRET_YAW")
local turret_pitch_param   = get_param_handle("AH1Z_CHIN_TURRET_PITCH")
local hmd_state_param      = get_param_handle("HMD_STATE")
local reticle_visible_param= get_param_handle("AH1Z_EYE_RETICLE_VISIBLE")
local reticle_yaw_param    = get_param_handle("AH1Z_EYE_RETICLE_YAW")
local reticle_pitch_param  = get_param_handle("AH1Z_EYE_RETICLE_PITCH")

local turret_yaw   = 0.0
local turret_pitch = 0.0
local manual_yaw   = 0.0
local manual_pitch = 0.0

-- Keyboard/hat step per press
local manual_step = 0.012

-- Maximum turret travel per second (mechanical slew rate, normalised 0-1 range)
-- 1.0 = full travel in 1 s; 0.95 gives ~2.1 s for end-to-end, feel natural
local slew_rate = 0.95

-- Axis slew: fraction of full travel per second at full deflection
-- 0.5 = 2 s to sweep full range on a pushed stick
local axis_slew_rate = 0.50

-- Stored axis deflections (-1..1); applied as rate in update()
local yaw_axis   = 0.0
local pitch_axis = 0.0

-- Direct DCS cockpit view command mirror. TrackIR/VR view axes are not guaranteed
-- to appear as cockpit draw args, so listen to the actual absolute view commands too.
local view_yaw   = 0.0
local view_pitch = 0.0
local view_seen  = false

-- Arg numbers for chin gun on the AH-1Z EDM
-- Arg 20 = azimuth, Arg 21 = elevation
local ARG_YAW   = 20
local ARG_PITCH = 21

dev:listen_command(Keys.GunturretUp)
dev:listen_command(Keys.GunturretDown)
dev:listen_command(Keys.GunturretLeft)
dev:listen_command(Keys.GunturretRight)
dev:listen_command(Keys.GunturretReset)
dev:listen_command(Keys.GunturretUncage)
dev:listen_command(Keys.GunturretYawAxis)
dev:listen_command(Keys.GunturretPitchAxis)
if iCommandViewHorizontalAbs ~= nil then dev:listen_command(iCommandViewHorizontalAbs) end
if iCommandViewVerticalAbs ~= nil then dev:listen_command(iCommandViewVerticalAbs) end

local function clamp(v, lo, hi)
    if v < lo then return lo end
    if v > hi then return hi end
    return v
end

local function move_towards(current, target, max_delta)
    local d = target - current
    if d >  max_delta then return current + max_delta end
    if d < -max_delta then return current - max_delta end
    return target
end

local function get_arg(arg)
    if get_cockpit_draw_argument_value then
        return get_cockpit_draw_argument_value(arg) or 0.0
    end
    return 0.0
end

local function set_model_arg(arg, value)
    if set_aircraft_draw_argument_value  then set_aircraft_draw_argument_value(arg, value)  end
    if set_cockpit_draw_argument_value   then set_cockpit_draw_argument_value(arg, value)   end
end

-- Read pilot or copilot head direction from DCS head-tracking draw args.
-- DCS populates args 890/891 with pilot yaw/pitch and 892/893 with copilot.
local function get_eye_target()
    if view_seen then
        return clamp(-view_yaw, -1.0, 1.0), clamp(view_pitch, -0.8, 0.4)
    end

    local plt_yaw   = get_arg(890)
    local plt_pitch = get_arg(891)
    local cpg_yaw   = get_arg(892)
    local cpg_pitch = get_arg(893)
    -- Use copilot if their head is more off-centre (they own the sensor)
    if math.abs(cpg_yaw) + math.abs(cpg_pitch) > math.abs(plt_yaw) + math.abs(plt_pitch) + 0.01 then
        return clamp(-cpg_yaw, -1.0, 1.0), clamp(cpg_pitch, -0.8, 0.4)
    end
    return clamp(-plt_yaw, -1.0, 1.0), clamp(plt_pitch, -0.8, 0.4)
end

local function publish()
    hmd_state_param:set(1)
    reticle_visible_param:set(1)
    turret_yaw_param:set(turret_yaw)
    turret_pitch_param:set(turret_pitch)
    reticle_yaw_param:set(manual_yaw)
    reticle_pitch_param:set(manual_pitch)
    set_model_arg(ARG_YAW,   turret_yaw)
    set_model_arg(ARG_PITCH, turret_pitch)
end

local function drive()
    -- Apply HOTAS axis slew (rate-based, only when uncaged)
    if slave_param:get() == 0 then
        local dy = yaw_axis
        local dp = pitch_axis
        if math.abs(dy) > 0.05 then
            manual_yaw   = clamp(manual_yaw   + dy * axis_slew_rate * update_rate, -1.0, 1.0)
        end
        if math.abs(dp) > 0.05 then
            manual_pitch = clamp(manual_pitch + dp * axis_slew_rate * update_rate, -0.8, 0.4)
        end
    end

    local target_yaw   = manual_yaw
    local target_pitch = manual_pitch

    -- Eye/IHADSS slave mode: follow head but limit to manual range
    if slave_param:get() == 1 then
        target_yaw, target_pitch = get_eye_target()
        -- Keep manual position in sync so uncage is seamless
        manual_yaw   = target_yaw
        manual_pitch = target_pitch
    end

    -- Mechanically slew toward target (no instant jumps)
    local max_step = slew_rate * update_rate
    turret_yaw   = move_towards(turret_yaw,   target_yaw,   max_step)
    turret_pitch = move_towards(turret_pitch, target_pitch, max_step)

    publish()
end

function post_initialize()
    slave_param:set(1)  -- start slaved to eye
    drive()
end

function SetCommand(command, value)
    if iCommandViewHorizontalAbs ~= nil and command == iCommandViewHorizontalAbs then
        view_yaw = clamp(value or 0.0, -1.0, 1.0)
        view_seen = true
    elseif iCommandViewVerticalAbs ~= nil and command == iCommandViewVerticalAbs then
        view_pitch = clamp(value or 0.0, -1.0, 1.0)
        view_seen = true

    elseif command == Keys.GunturretUncage then
        slave_param:set(slave_param:get() == 1 and 0 or 1)

    elseif command == Keys.GunturretReset then
        manual_yaw   = 0.0
        manual_pitch = 0.0
        yaw_axis     = 0.0
        pitch_axis   = 0.0
        slave_param:set(1)

    elseif command == Keys.GunturretUp then
        manual_pitch = clamp(manual_pitch + manual_step, -0.8, 0.4)
        slave_param:set(0)
    elseif command == Keys.GunturretDown then
        manual_pitch = clamp(manual_pitch - manual_step, -0.8, 0.4)
        slave_param:set(0)
    elseif command == Keys.GunturretLeft then
        manual_yaw   = clamp(manual_yaw - manual_step, -1.0, 1.0)
        slave_param:set(0)
    elseif command == Keys.GunturretRight then
        manual_yaw   = clamp(manual_yaw + manual_step, -1.0, 1.0)
        slave_param:set(0)

    -- HOTAS axis: store deflection; rate applied in drive()
    elseif command == Keys.GunturretYawAxis then
        yaw_axis = clamp(value, -1.0, 1.0)
        if math.abs(value) > 0.05 then slave_param:set(0) end
    elseif command == Keys.GunturretPitchAxis then
        pitch_axis = clamp(value, -1.0, 1.0)
        if math.abs(value) > 0.05 then slave_param:set(0) end
    end

    publish()
end

function update()
    drive()
end

need_to_be_closed = false
