dofile(current_mod_path.."/FM/FMOptions.lua")

local function skid_post(pos, shell, damage_element, arg_amortizer, mass, static_force)
    return {
        mass = mass,
        pos = pos,
        damage_element = damage_element,
        self_attitude = false,
        wheel_axle_offset = 0.0,
        yaw_limit = 0.0,
        damper_coeff = 260.0,

        amortizer_max_length = 0.42,
        amortizer_basic_length = 0.42,
        amortizer_spring_force_factor = 900000.0,
        amortizer_spring_force_factor_rate = 1,
        amortizer_static_force = static_force,
        amortizer_reduce_length = 0.26,
        amortizer_direct_damper_force_factor = 110000.0,
        amortizer_back_damper_force_factor = 135000.0,

        allowable_hard_contact_length = 0.46,
        anti_skid_installed = false,
        wheel_radius = 0.09,
        wheel_static_friction_factor = 1.65,
        wheel_side_friction_factor = 2.10,
        wheel_roll_friction_factor = 0.60,
        wheel_glide_friction_factor = 1.35,
        wheel_damage_force_factor = 1450.0,
        wheel_damage_speed = 180,
        wheel_moment_of_inertia = 0.25,
        wheel_brake_moment_max = 0.0,

        arg_amortizer = arg_amortizer,
        arg_wheel_rotation = -1,
        arg_wheel_yaw = -1,
        collision_shell_name = shell,
    }
end

SH3SeaKing = {
    -- AH-1Z/Viper baseline from the supplied MSFS flight_model.cfg.
    -- Source values:
    --   empty 12,300 lb, max 18,500 lb
    --   empty CG -7, 0, 0 ft from datum
    --   MOI pitch/roll/yaw 20938/38638/59573 slug-ft^2
    --
    -- DCS body axes are X forward, Y up, Z right. The EFM receives these
    -- values through make_flyable() and ed_fm_set_current_mass_state().
    center_of_mass = {-2.13, -0.08, 0.00},
    moment_of_inertia = {52394, 80765, 28386},

    -- Supplied skid geometry mapped from feet to DCS meters.
    -- DCS body axes: X fore/aft, Y vertical, Z lateral.
    suspension = {
        skid_post({-0.37, -2.402,  1.10}, "WHEEL_L_F", 3, 6, 80, 18500.0),
        skid_post({-0.37, -2.402, -1.10}, "WHEEL_R_F", 3, 4, 80, 18500.0),
        skid_post({-3.05, -2.402,  1.10}, "WHEEL_L_R", 3, 6, 110, 25500.0),
        skid_post({-3.05, -2.402, -1.10}, "WHEEL_R_R", 3, 4, 110, 25500.0),
        skid_post({-10.97, -1.433, 0.00}, "TAILBOOM", 2, -1, 50, 5000.0),
    },

    disable_built_in_oxygen_system = false,
    minor_shake_ampl = 0.21,
    major_shake_ampl = 0.5,
    debugLine = "{M}:%1.3f {IAS}:%4.1f {AoA}:%2.1f {ny}:%2.1f {nx}:%1.2f {AoS}:%2.1f {mass}:%2.1f {Fy}:%2.1f {Fx}:%2.1f {wx}:%.1f {wy}:%.1f {wz}:%.1f {Vy}:%2.1f {dPsi}:%2.1f",
    record_enabled = false,
}

AH1Z_FM = SH3SeaKing

