dofile(current_mod_path.."/FM/FMOptions.lua")

local function skid_contact(pos, shell, arg, damage_element)
    return {
        -- Skid helicopters in DCS still use the suspension table, but the
        -- entries act like skid pads, not rolling landing gear.
        mass = 0,
        pos = pos,
        moment_of_inertia = {0, 0, 0},

        damage_element = damage_element,
        damage_omega = 180,
        state_angle_0 = 0,
        state_angle_1 = 0,
        mount_pivot_x = 0,
        mount_pivot_y = 0,
        mount_post_radius = 0,
        mount_length = 0,
        mount_angle_1 = 0,
        post_length = 0,
        wheel_axle_offset = 0,

        self_attitude = false,
        yaw_limit = math.rad(0.0),
        damper_coeff = 0.0,

        amortizer_min_length = 0,
        amortizer_max_length = 0.42,
        amortizer_basic_length = 0.42,
        amortizer_spring_force_factor = 210000,
        amortizer_spring_force_factor_rate = 1.0,
        amortizer_static_force = 18500,
        amortizer_reduce_length = 0.34,
        amortizer_direct_damper_force_factor = 125000,
        amortizer_back_damper_force_factor = 54000,

        -- SA342 uses a large virtual wheel radius for skid contact. This is
        -- intentional: it acts as a skid pad radius, not a visible wheel.
        anti_skid_installed = false,
        wheel_radius = 0.38,
        wheel_static_friction_factor = 3.0,
        wheel_side_friction_factor = 2.8,
        wheel_roll_friction_factor = 0.03,
        wheel_glide_friction_factor = 2.4,
        wheel_damage_force_factor = 850.0,
        wheel_damage_speed = 180.0,
        wheel_moment_of_inertia = 0.0,
        wheel_brake_moment_max = 80000.0,

        arg_post = -1,
        arg_amortizer = arg,
        arg_wheel_rotation = -1,
        arg_wheel_yaw = -1,
        collision_shell_name = shell,
    }
end

SH3SeaKing = {
    center_of_mass = {0.05, -0.20, 0.0},
    moment_of_inertia = {245000, 90000, 105000},

    -- AH-1W has skids, but the stock collision model exposes body cells, not
    -- skid cells. Build a wide virtual belly/skid sled so the fuselage contact
    -- footprint reaches the visible skids and tail side cells instead of letting the belly settle.
    suspension = {
        skid_contact({ 3.15, -2.00,  1.24}, "CABIN_LEFT_SIDE",      1, 4),
        skid_contact({ 3.15, -2.00, -1.24}, "CABIN_RIGHT_SIDE",     9, 5),
        skid_contact({ 0.85, -2.00,  1.24}, "FUSELAGE_LEFT_SIDE",   6, 9),
        skid_contact({ 0.85, -2.00, -1.24}, "FUSELAGE_RIGHT_SIDE",  4, 10),
        skid_contact({-1.55, -2.00,  1.24}, "FUSELAGE_LEFT_SIDE",   7, 9),
        skid_contact({-1.55, -2.00, -1.24}, "FUSELAGE_RIGHT_SIDE",  8, 10),
        skid_contact({-5.20, -2.00,  0.38}, "TAIL_LEFT_SIDE",       9, 56),
        skid_contact({-5.20, -2.00, -0.38}, "TAIL_RIGHT_SIDE",      10, 57),
    },

    disable_built_in_oxygen_system = false,
    minor_shake_ampl = 0.21,
    major_shake_ampl = 0.5,
    debugLine = "{M}:%1.3f {IAS}:%4.1f {AoA}:%2.1f {ny}:%2.1f {nx}:%1.2f {mass}:%2.1f {Fy}:%2.1f {Fx}:%2.1f {wx}:%.1f {wy}:%.1f {wz}:%.1f {Vy}:%2.1f {dPsi}:%2.1f",
    record_enabled = false,
}

AH1Z_FM = SH3SeaKing

