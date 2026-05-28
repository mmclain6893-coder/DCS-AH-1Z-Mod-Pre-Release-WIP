dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.common_script_path.."devices_defs.lua")

local dev = GetSelf()
local update_rate = 0.02
make_default_activity(update_rate)

local slave_param = get_param_handle("AH1Z_CHIN_RETICLE_SLAVE")
local turret_yaw_param = get_param_handle("AH1Z_CHIN_TURRET_YAW")
local turret_pitch_param = get_param_handle("AH1Z_CHIN_TURRET_PITCH")
local hmd_state_param = get_param_handle("HMD_STATE")
local reticle_visible_param = get_param_handle("AH1Z_EYE_RETICLE_VISIBLE")
local reticle_yaw_param = get_param_handle("AH1Z_EYE_RETICLE_YAW")
local reticle_pitch_param = get_param_handle("AH1Z_EYE_RETICLE_PITCH")

local turret_yaw = 0.0
local turret_pitch = 0.0
local manual_yaw = 0.0
local manual_pitch = 0.0
local manual_step = 0.012
local slew_rate = 0.95

local turret_arg_pairs = {
    {19, 20},
    {24, 25},
    {26, 27},
}

dev:listen_command(Keys.GunturretUp)
dev:listen_command(Keys.GunturretDown)
dev:listen_command(Keys.GunturretLeft)
dev:listen_command(Keys.GunturretRight)
dev:listen_command(Keys.GunturretReset)
dev:listen_command(Keys.GunturretUncage)

local function clamp(value, low, high)
    if value < low then return low end
    if value > high then return high end
    return value
end

local function move_towards(current, target, max_delta)
    local delta = target - current
    if delta > max_delta then return current + max_delta end
    if delta < -max_delta then return current - max_delta end
    return target
end

local function get_arg(arg)
    if get_cockpit_draw_argument_value then
        return get_cockpit_draw_argument_value(arg) or 0.0
    end
    return 0.0
end

local function get_eye_reticle_target()
    local plt_yaw = get_arg(890)
    local plt_pitch = get_arg(891)
    local cpg_yaw = get_arg(892)
    local cpg_pitch = get_arg(893)

    if math.abs(cpg_yaw) + math.abs(cpg_pitch) > math.abs(plt_yaw) + math.abs(plt_pitch) + 0.01 then
        return clamp(cpg_yaw, -1.0, 1.0), clamp(cpg_pitch, -0.8, 0.4)
    end

    return clamp(plt_yaw, -1.0, 1.0), clamp(plt_pitch, -0.8, 0.4)
end

local function publish()
    hmd_state_param:set(1)
    reticle_visible_param:set(1)
    turret_yaw_param:set(turret_yaw)
    turret_pitch_param:set(turret_pitch)
    reticle_yaw_param:set(manual_yaw)
    reticle_pitch_param:set(manual_pitch)

    if set_aircraft_draw_argument_value then
        for i = 1, #turret_arg_pairs do
            set_aircraft_draw_argument_value(turret_arg_pairs[i][1], turret_yaw)
            set_aircraft_draw_argument_value(turret_arg_pairs[i][2], turret_pitch)
        end
    end
end

local function drive_chin_turret()
    local target_yaw = manual_yaw
    local target_pitch = manual_pitch

    if slave_param:get() == 1 then
        target_yaw, target_pitch = get_eye_reticle_target()
        manual_yaw = target_yaw
        manual_pitch = target_pitch
    end

    turret_yaw = move_towards(turret_yaw, target_yaw, slew_rate * update_rate)
    turret_pitch = move_towards(turret_pitch, target_pitch, slew_rate * update_rate)
    publish()
end

function post_initialize()
    slave_param:set(1)
    drive_chin_turret()
end

function SetCommand(command, value)
    if command == Keys.GunturretUncage then
        slave_param:set(slave_param:get() == 1 and 0 or 1)
    elseif command == Keys.GunturretReset then
        manual_yaw = 0.0
        manual_pitch = 0.0
        slave_param:set(1)
    elseif command == Keys.GunturretUp then
        manual_pitch = clamp(manual_pitch + manual_step, -0.8, 0.4)
        slave_param:set(0)
    elseif command == Keys.GunturretDown then
        manual_pitch = clamp(manual_pitch - manual_step, -0.8, 0.4)
        slave_param:set(0)
    elseif command == Keys.GunturretLeft then
        manual_yaw = clamp(manual_yaw - manual_step, -1.0, 1.0)
        slave_param:set(0)
    elseif command == Keys.GunturretRight then
        manual_yaw = clamp(manual_yaw + manual_step, -1.0, 1.0)
        slave_param:set(0)
    end

    publish()
end

function update()
    drive_chin_turret()
end

need_to_be_closed = false
