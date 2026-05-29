local ft_to_m = 0.3048
local knot_to_kmh = 1.852
local nm_to_km = 1.852
local sq_ft_to_sq_m = 0.092903
local slug_ft2_to_kg_m2 = 1.35581795
local shp_to_kw = 0.7457

AH1Z =
{
    Name = "AH-1Z",
    DisplayName = _("AH-1Z"),
    Picture = "AH-1Z.png",
    ViewSettings = ViewSettings,

    HumanCockpit = true,
    HumanCockpitPath = current_mod_path .. "/Cockpit/",
    Shape = "AH-1Z",

    shape_table_data =
    {
        {
            file = "AH-1Z",
            username = "AH-1Z",
            index = WSTYPE_PLACEHOLDER,
            life = 18,
            vis = 3,
            fire = {300, 2},
            classname = "lLandPlane",
            positioning = "BYNORMAL",
            drawonmap = true,
        },
    },

    mapclasskey = "P0091000021",
    attribute = {wsType_Air, wsType_Helicopter, wsType_Battleplane, WSTYPE_PLACEHOLDER, "Attack helicopters",},

    Categories = {"{828CEADE-3F1D-40aa-93CE-8CDB73FE2710}", "Helicopter"},
    Rate = 40,
    Countries = {"USA"},
    date_of_introduction = 2010.0,
    country_of_origin = "USA",

    length = 17.75,
    height = 4.37,
    rotor_RPM = 324,
    tail_rotor_RPM = 1403,
    M_empty = 5579,
    M_nominal = 6875,
    M_max = 8391,
    M_fuel_max = 1254,
    M_payload_max = 2614,
    -- First-pass inertia estimate from AH-1Z mass and dimensions.
    -- Axes are DCS body axes: X roll, Y yaw, Z pitch.
    MOI = {65000, 230000, 210000},
    RCS = 7,
    IR_emission_coeff = 0.35,

    -- Skid contact points tuned for the restored EDM visual origin. Negative Y raises the visual so it rests on the skids.
    nose_gear_pos = {2.85, -2.449, 0.0},
    nose_gear_wheel_diameter = 0.72,
    main_gear_pos = {-0.80, -2.449, 1.35},
    main_gear_wheel_diameter = 0.77,
    lead_stock_main = 0.0,
    lead_stock_support = 0.0,

    engines_count = 2,
    engines_nozzles =
    {
        { engine_number = 1, pos = {-1.0, 1.7, -0.55}, diameter = 0.45, smokiness_level = 0.05 },
        { engine_number = 2, pos = {-1.0, 1.7,  0.55}, diameter = 0.45, smokiness_level = 0.05 },
    },

    V_max = 222 * knot_to_kmh,
    V_max_cruise = 160 * knot_to_kmh,
    V_sideward_rearward = 45 * knot_to_kmh,
    Vy_max = 14.2,
    H_stat_max = 914,
    H_stat_max_L = 2150,
    H_din_two_eng = 3840,
    H_din_one_eng = 1900,
    range = 370 * nm_to_km,
    combat_radius = 125 * nm_to_km,
    flight_time_typical = 150,
    flight_time_maximum = 180,
    Vy_land_max = 12.8,
    Ny_max = 2.5,
    Ny_min = -0.5,
    scheme = 0,

    rotor_height = 2.091,
    rotor_diameter = 15.0,
    blade_chord = 0.534,
    blade_area = 6.2,
    blades_number = 4,
    rotor_MOI = 3000,
    thrust_correction = 0.85,
    fuselage_Cxa0 = 0.47,
    fuselage_Cxa90 = 5.9,
    fuselage_area = 5,
    centering = 0.0,
    tail_pos = {-7.896, 3.254, 0},
    tail_fin_area = 1.2,
    tail_stab_area = 1.7,
    rotor_pos = {0.0234, 3.514, 0},
    wing_span = 4.39,
    stores_number = 6,

    engine_data =
    {
        power_take_off = 1800 * shp_to_kw,
        power_max = 1800 * shp_to_kw,
        power_WEP = 1800 * shp_to_kw,
        power_TH_k =
        {
            [1] = {-1.8859, 17.806, 1030},
            [2] = {-2.2584, 20.573, 1030},
            [3] = {-0.9078, -3.1185, 1051.6},
            [4] = {-0.2853, -0.614, 786.19},
        },
        SFC_k = {0, -0.000312128, 0.63},
        power_RPM_k = {-0.0778, 0.2506, 0.8099},
        power_RPM_min = 9.1384,
    },

    Sensors =
    {
        OPTIC = {"TADS DVO"},
        RWR = "Abstract RWR",
    },

    CanopyGeometry =
    {
        azimuth = {-120.0, 120.0},
        elevation = {-55.0, 90.0},
    },

    Crew = 2,
    crew_size = 2,
    crew_members =
    {
        [1] = { ejection_seat_name = 0, drop_canopy_name = 0, pos = {2.25, 0.78, 0.0}, can_be_playable = true, role = "pilot", role_display_name = _("Pilot") },
        [2] = { ejection_seat_name = 0, drop_canopy_name = 0, pos = {2.25, 0.78, 0.0}, can_be_playable = true, role = "pilot", role_display_name = _("Gunner") },
    },

    Damage = verbose_to_dmg_properties(
    {
        -- Standard DCS cells the engine expects property records for.
        ["NOSE_CENTER"] = {critical_damage = 5},
        ["FUSELAGE_LEFT_SIDE"] = {critical_damage = 10},
        ["FUSELAGE_RIGHT_SIDE"] = {critical_damage = 10},
        ["ENGINE"] = {critical_damage = 6},
        ["WING_L_IN"] = {critical_damage = 5},
        ["WING_R_IN"] = {critical_damage = 5},
        ["TAIL"] = {critical_damage = 12},

        -- Collision shell cells exported in AH-1Z_collision.edm.
        ["WHEEL_F"] = {critical_damage = 3},
        ["WHEEL_L"] = {critical_damage = 3},
        ["WHEEL_R"] = {critical_damage = 3},
        ["WHEEL_L_F"] = {critical_damage = 3},
        ["WHEEL_R_F"] = {critical_damage = 3},
        ["WHEEL_L_R"] = {critical_damage = 3},
        ["WHEEL_R_R"] = {critical_damage = 3},
        ["FUSELAGE"] = {critical_damage = 10},
        ["COCKPIT"] = {critical_damage = 8},
        ["NOSE"] = {critical_damage = 5},
        ["TAILBOOM"] = {critical_damage = 12},
        ["STUB_WING_L"] = {critical_damage = 5},
        ["STUB_WING_R"] = {critical_damage = 5},

        -- Collision line segments exported in AH-1Z_collision.edm.
        ["FRONT_GEAR"] = {critical_damage = 3},
        ["LEFT_GEAR"] = {critical_damage = 3},
        ["RIGHT_GEAR"] = {critical_damage = 3},
        ["LEFT_GEAR_F"] = {critical_damage = 3},
        ["RIGHT_GEAR_F"] = {critical_damage = 3},
        ["LEFT_GEAR_R"] = {critical_damage = 3},
        ["RIGHT_GEAR_R"] = {critical_damage = 3},
    }),
    DamageParts = {},
    -- Rotor, chin turret, sensor ball, and wind sensor draw args.
    net_animation = {20, 21, 22, 24, 25, 26, 27, 36, 37, 40},
    mechanimations = {},
    cannon_sight_type = 2,
    turret_data =
    {
        H_Min = -110.0,
        H_Max = 110.0,
        V_Min = -50.0,
        V_Max = 25.0,
        H_Vel = 90.0,
        V_Vel = 90.0,
    },
    Guns =
    {
        -- M197 is a 20 mm Vulcan-family cannon; DCS exposes the M_61 template.
        gun_mount("M_61",
            { count = 750 },
            {
                muzzle_pos = {0.0, 0.0, 0.0},
                muzzle_pos_connector = "Gun_point_00",
                supply_position = {2.10, -0.25, 0.0},
                azimuth_initial = 0.0,
                elevation_initial = 0.0,
                max_burst_length = 750,
                rates = {730},
                barrel_circular_error = 0.006,
                effects = {fire_effect(20), smoke_effect()},
            }
        )
    },
    Pylons =
    {
        pylon(1, 0, -2.60, 2.25, 1.36,
            {arg = 421, arg_value = 0.0, use_full_connector_position = false, DisplayName = "R TIP", FiY = -90.0},
            {
                {CLSID = "{AIM-9M}", arg_value = 1.0},
                {CLSID = "{AIM-9L}", arg_value = 1.0},
            }
        ),
        pylon(2, 0, -2.39, 1.72, 1.36,
            {arg = 422, arg_value = 0.0, use_full_connector_position = false, DisplayName = "R OUT", FiY = -90.0},
            {
                {CLSID = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}", arg_value = 1.0}, -- DCS M299 4x AGM-114K
                {CLSID = "{M299_4xAGM_114L}", arg_value = 1.0}, -- DCS M299 4x AGM-114L
                {CLSID = "M261_MK151", arg_value = 1.0}, -- DCS M261 19x Hydra M151
                {CLSID = "{M261_M257}", arg_value = 1.0}, -- DCS M261 19x Hydra M257
                {CLSID = "{M261_M274}", arg_value = 1.0}, -- DCS M261 19x Hydra M274
            }
        ),
        pylon(3, 0, -1.59, 1.77, 1.41,
            {arg = 423, arg_value = 0.0, use_full_connector_position = false, DisplayName = "R IN", FiY = -90.0},
            {
                {CLSID = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}", arg_value = 1.0},
                {CLSID = "{M299_4xAGM_114L}", arg_value = 1.0},
                {CLSID = "M261_MK151", arg_value = 1.0},
                {CLSID = "{M261_M257}", arg_value = 1.0},
                {CLSID = "{M261_M274}", arg_value = 1.0},
            }
        ),
        pylon(4, 0, 1.60, 1.74, 1.41,
            {arg = 424, arg_value = 0.0, use_full_connector_position = false, DisplayName = "L IN", FiY = -90.0},
            {
                {CLSID = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}", arg_value = 1.0},
                {CLSID = "{M299_4xAGM_114L}", arg_value = 1.0},
                {CLSID = "M261_MK151", arg_value = 1.0},
                {CLSID = "{M261_M257}", arg_value = 1.0},
                {CLSID = "{M261_M274}", arg_value = 1.0},
            }
        ),
        pylon(5, 0, 2.40, 1.69, 1.36,
            {arg = 425, arg_value = 0.0, use_full_connector_position = false, DisplayName = "L OUT", FiY = -90.0},
            {
                {CLSID = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}", arg_value = 1.0},
                {CLSID = "{M299_4xAGM_114L}", arg_value = 1.0},
                {CLSID = "M261_MK151", arg_value = 1.0},
                {CLSID = "{M261_M257}", arg_value = 1.0},
                {CLSID = "{M261_M274}", arg_value = 1.0},
            }
        ),
        pylon(6, 0, 2.61, 2.22, 1.36,
            {arg = 426, arg_value = 0.0, use_full_connector_position = false, DisplayName = "L TIP", FiY = -90.0},
            {
                {CLSID = "{AIM-9M}", arg_value = 1.0},
                {CLSID = "{AIM-9L}", arg_value = 1.0},
            }
        ),
    },
    Tasks = { aircraft_task(CAS), aircraft_task(GroundAttack), aircraft_task(AFAC), aircraft_task(Reconnaissance) },
    DefaultTask = aircraft_task(CAS),
    input_profile_entry = "AH-1Z",
}

add_aircraft(AH1Z)






















