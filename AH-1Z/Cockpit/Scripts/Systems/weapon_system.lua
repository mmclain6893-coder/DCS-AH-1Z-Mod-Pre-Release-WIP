dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.common_script_path.."../../../Database/wsTypes.lua")

local dev = GetSelf()
local update_rate = 0.02
make_default_activity(update_rate)

local iCommandPlaneModeCannon = 113
local iCommandPlaneFire = 84
local iCommandPlaneFireOff = 85
local iCommandPlanePickle = 350
local iCommandPlanePickleOff = 351

local WEAPON_CHIN = 0
local WEAPON_ROCKETS = 1
local WEAPON_MISSILES = 2
local weapon_mode = WEAPON_CHIN
local master_arm = 1
local trigger_held = false
local fire_timer = 0.0
local fire_interval = 0.10
local barrel_spin = 0.0
local barrel_spin_arg = 22
local barrel_spin_rate = 4.0
local external_station_cursor = 0
local external_station_order = {0, 1, 2, 3, 4, 5}
local master_arm_param = get_param_handle("AH1Z_MASTER_ARM")
local weapon_mode_param = get_param_handle("AH1Z_WEAPON_MODE")
local trigger_param = get_param_handle("AH1Z_TRIGGER_HELD")

dev:listen_command(Keys.MasterArm)
dev:listen_command(Keys.GunSelector)
dev:listen_command(Keys.ChangeWeapon)
dev:listen_command(Keys.SelectCannon)
dev:listen_command(Keys.SelectTOW)
dev:listen_command(Keys.TriggerFireOn)
dev:listen_command(Keys.TriggerFireOff)
dev:listen_command(Keys.PickleOn)
dev:listen_command(Keys.PickleOff)

local function set_arg(arg, value)
    if set_cockpit_draw_argument_value then
        set_cockpit_draw_argument_value(arg, value)
    end
end

local function set_aircraft_arg(arg, value)
    if set_aircraft_draw_argument_value then
        set_aircraft_draw_argument_value(arg, value)
    end
end

local function publish()
    master_arm_param:set(master_arm)
    weapon_mode_param:set(weapon_mode)
    trigger_param:set(trigger_held and 1 or 0)
    set_arg(551, master_arm)
    if weapon_mode == WEAPON_CHIN then
        set_arg(552, -0.5)
    elseif weapon_mode == WEAPON_ROCKETS then
        set_arg(552, -1.0)
    else
        set_arg(552, 0.0)
    end
    set_aircraft_arg(barrel_spin_arg, barrel_spin)
end

local function station_has_weapon(idx)
    if dev.get_station_info then
        local ok, station = pcall(function() return dev:get_station_info(idx) end)
        if ok and station and station.count and station.count > 0 then
            return true
        end
    end
    return false
end

local function fire_internal_gun()
    if dispatch_action then
        dispatch_action(nil, iCommandPlaneModeCannon)
        dispatch_action(nil, iCommandPlaneFire)
    end
end

local function launch_external_store()
    for _ = 1, #external_station_order do
        local idx = external_station_order[external_station_cursor + 1]
        external_station_cursor = (external_station_cursor + 1) % #external_station_order

        if station_has_weapon(idx) then
            if dev.select_station then
                pcall(function() dev:select_station(idx) end)
            end
            dev:launch_station(idx, 1)
            if dispatch_action then
                dispatch_action(nil, iCommandPlanePickle)
            end
            return
        end
    end

    if dispatch_action then
        dispatch_action(nil, iCommandPlanePickle)
    end
end

local function fire_selected_weapon()
    if master_arm ~= 1 then
        return
    end

    if weapon_mode == WEAPON_CHIN then
        fire_internal_gun()
    else
        launch_external_store()
    end
end

function post_initialize()
    local birth = LockOn_Options.init_conditions.birth_place
    master_arm = (birth == "GROUND_COLD") and 0 or 1
    weapon_mode = WEAPON_CHIN
    publish()
end

function SetCommand(command, value)
    if command == Keys.MasterArm then
        master_arm = (master_arm == 1) and 0 or 1
    elseif command == Keys.GunSelector or command == Keys.ChangeWeapon then
        weapon_mode = (weapon_mode + 1) % 3
    elseif command == Keys.SelectCannon then
        weapon_mode = WEAPON_CHIN
    elseif command == Keys.SelectTOW then
        weapon_mode = WEAPON_MISSILES
    elseif command == Keys.TriggerFireOn or command == Keys.PickleOn then
        trigger_held = true
        fire_timer = fire_interval
        if command == Keys.PickleOn and weapon_mode == WEAPON_CHIN then
            weapon_mode = WEAPON_ROCKETS
        end
    elseif command == Keys.TriggerFireOff or command == Keys.PickleOff then
        trigger_held = false
        if dispatch_action then
            dispatch_action(nil, iCommandPlaneFireOff)
            dispatch_action(nil, iCommandPlanePickleOff)
        end
    end

    publish()
end

function update()
    if trigger_held and master_arm == 1 and weapon_mode == WEAPON_CHIN then
        barrel_spin = barrel_spin + barrel_spin_rate * update_rate
        if barrel_spin > 1.0 then
            barrel_spin = barrel_spin - 2.0
        end
    end
    publish()
    if trigger_held then
        fire_timer = fire_timer + update_rate
        if fire_timer >= fire_interval then
            fire_selected_weapon()
            fire_timer = 0.0
        end
    end
end

need_to_be_closed = false
