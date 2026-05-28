dofile(current_mod_path.."/FM/FMOptions.lua")

local function skid_post(pos, shell, damage_element, arg_amortizer, mass, static_force)
    return {
        mass = mass,
        pos = pos,
        damage_element = damage_element,
        self_attitude = false,
        wheel_axle_offset = 0.0,
        yaw_limit = 0.0,
        damper_coeff = 320.0,

        amortizer_max_length = 0.30,
        amortizer_basic_length = 0.30,
        amortizer_spring_force_factor = 1250000.0,
        amortizer_spring_force_factor_rate = 1,
        amortizer_static_force = static_force,
        amortizer_reduce_length = 0.20,
        amortizer_direct_damper_force_factor = 125000.0,
        amortizer_back_damper_force_factor = 145000.0,

        allowable_hard_contact_length = 0.35,
        anti_skid_installed = false,
        wheel_radius = 0.10,
        wheel_static_friction_factor = 1.20,
        wheel_side_friction_factor = 1.60,
        wheel_roll_friction_factor = 0.45,
        wheel_glide_friction_factor = 1.05,
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
    -- Slightly below the previous UH value to resist skid roll-over while we
    -- are using DCS wheel-style contact for skid rails.
    center_of_mass = {0.20, -0.35, 0.0},
    -- AH-1Z first-pass inertia estimate, kg*m^2. DCS body axes:
    -- X roll, Y yaw, Z pitch. This replaces the borrowed heavy-helo values.
    moment_of_inertia = {65000, 230000, 210000},

    -- Reference layout: wheel shells plus gear collision lines.
    -- DCS body axes: X fore/aft, Y vertical, Z lateral.
    suspension = {
        skid_post({ 2.85, -2.449,  0.00}, "WHEEL_F", 0, 2, 60, 16000.0),
        skid_post({-0.80, -2.449,  1.35}, "WHEEL_L", 3, 6, 120, 25700.0),
        skid_post({-0.80, -2.449, -1.35}, "WHEEL_R", 3, 4, 120, 25700.0),
    },

    disable_built_in_oxygen_system = false,
    minor_shake_ampl = 0.21,
    major_shake_ampl = 0.5,
    debugLine = "{M}:%1.3f {IAS}:%4.1f {AoA}:%2.1f {ny}:%2.1f {nx}:%1.2f {AoS}:%2.1f {mass}:%2.1f {Fy}:%2.1f {Fx}:%2.1f {wx}:%.1f {wy}:%.1f {wz}:%.1f {Vy}:%2.1f {dPsi}:%2.1f",
    record_enabled = false,
}

AH1Z_FM = SH3SeaKing

