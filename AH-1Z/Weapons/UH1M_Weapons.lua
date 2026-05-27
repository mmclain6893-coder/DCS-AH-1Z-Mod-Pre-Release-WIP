dofile("Scripts/Database/Weapons/warheads.lua")

local GALLON_TO_KG = 3.785 * 0.8
local INCHES_TO_M = 0.0254
local POUNDS_TO_KG = 0.453592

local tracer_on_time = 0.01
local barrel_smoke_level = 1.0
local barrel_smoke_opacity = 0.1



declare_weapon({category = CAT_SHELLS,
		name = "UH1C_40mm_grenade",
		user_name = _("UH1C_40mm_grenade"),
        model_name      = "pula", --pula
       -- projectile      = "HE",
        mass            = 0.649, -- Bullet mass
        round_mass      = 0.14 + 0.009, -- Assembled shell + link
        cartridge_mass  = 0.009, -- Empty shell (+ link if links are stored as well)
        explosive       = 1.20, --0
  v0    = 240.69,
  Dv0   = 0.01,
  Da0     = 0.001,
  Da1     = 0.001,
  life_time     = 35,
  caliber     = 40.0,
  s         = 0.0,
  j         = 0.0,
  l         = 0.0,
  charTime    = 0,
  cx        = {1.0,0.81,0.67,0.154,1.84},
  k1        = 5.3e-08,
  tracer_off    = 35, -- equal to life_time
        tracer_on       = tracer_on_time,
        smoke_tail_life_time = 2,
        scale_tracer    = 1,
        cartridge       = 0,
        scale_smoke     = barrel_smoke_level,
        smoke_opacity   = barrel_smoke_opacity,
    })

function UH1C_40mmLauncher(tbl)

	tbl.category = CAT_GUN_MOUNT 
	tbl.name 	 = "UH1C 40mmLauncher"
	tbl.supply 	 = 
	{
		shells = {"UH1C_40mm_grenade"},
		--mixes  = {{2,1,1,1}},
		count  = 200,
	}
	if tbl.mixes then 
	   tbl.supply.mixes =  tbl.mixes
	   tbl.mixes	    = nil
	end
	tbl.gun = 
	{
		max_burst_length = 3,
		rates 			 = {200},
		recoil_coeff 	 = 0.25*1.3,
		barrels_count 	 = 1,
	}
	if tbl.rates then 
	   tbl.gun.rates    =  tbl.rates
	   tbl.rates	    = nil
	end	
	tbl.ejector_pos 			= {-1.072, -0.05, -0.039} -- position from muzzle connector pos
	tbl.ejector_dir 			= tbl.ejector_dir
	tbl.supply_position  		= tbl.supply_position or {0,  0.3, -0.3}
	tbl.aft_gun_mount 			= false
	tbl.effective_fire_distance = 1500
	tbl.drop_cartridge 			= 204 -- drop shell shape/size from  aircraft_gun_mounts.lua
	tbl.muzzle_pos				= tbl.muzzle_pos or {0,0,0} -- all position from connector
	tbl.muzzle_pos_connector	= tbl.muzzle_pos_connector 	or  "Gun_point" -- all position from connector
	tbl.azimuth_initial 		= tbl.azimuth_initial    or 0   
	tbl.elevation_initial 		= tbl.elevation_initial  or 0   
	if  tbl.effects == nil then
		tbl.effects = {{ name = "FireEffect"     , arg 		 = tbl.effect_arg_number or 436 },
					   { name = "HeatEffectExt"  , shot_heat = 7.823, barrel_k = 0.462 * 2.7, body_k = 0.462 * 14.3 },
					   { name = "SmokeEffect"},
					   }
	end
	return declare_weapon(tbl)
end

declare_loadout({
	category 		=   CAT_PODS,
	CLSID	 		=  "{UH1C40mmLauncher}",
	attribute		=   {wsType_Weapon,wsType_GContainer,wsType_Cannon_Cont,WSTYPE_PLACEHOLDER},
	wsTypeOfWeapon	= 	{wsType_Weapon,wsType_Shell,wsType_Shell,WSTYPE_PLACEHOLDER},
	Picture			=	"ChinGun40mm.png",
	displayName		=	_("XM5 Grenade launcher"),-- loadout editor name
	Weight			=	63, 
	Cx_pil			=	0.00024,
	Elements  		= {{ShapeName = "ChinGun40mm"}},
	kind_of_shipping = 2,--SOLID_MUNITION
	gun_mounts		= {
			UH1C_40mmLauncher({
				ejector_dir = {0,-1,-0.5},
				supply_position = {2, -0.3, -0.4},
				muzzle_pos_connector = "GUN_POINT_C",
				effect_arg_number = 800,
			})			
	},	
	shape_table_data = {{file  	 = 'ChinGun40mm';	username = 'ChinGun 40mm Launcher'; index = WSTYPE_PLACEHOLDER;}}
})


UH1CminigunL = {
    category        = CAT_PODS,
    CLSID           = "{UH1C_minigunL}",
    attribute       = {wsType_Weapon,wsType_GContainer,wsType_Cannon_Cont,WSTYPE_PLACEHOLDER},
    wsTypeOfWeapon  = {wsType_Weapon,wsType_Shell,wsType_Shell,WSTYPE_PLACEHOLDER},
    Picture         = "UH1Cminigun.png",
    displayName     = _("UH1CMinigunL"),
    Weight          = 100,      --loaded	39kg empty gun + 50.72kg ammo
    Cx_pil          = 0.00015,
    Elements        = {{ShapeName = "UH1CMinigunL"}},
    kind_of_shipping = 2,   -- SOLID_MUNITION
    gun_mounts      = {
gun_mount("M_134", { count = 1000 },  {muzzle_pos = {0, 0, 0}, max_burst_length = 5, rates = {1300}, effect_arg_number = 800}), 
    },
    shape_table_data = {{file = 'UH1CMinigunL'; username = 'UH1CminigunL'; index = WSTYPE_PLACEHOLDER;}}
}
declare_loadout(UH1CminigunL)

UH1CminigunR = {
    category        = CAT_PODS,
    CLSID           = "{UH1C_minigunR}",
    attribute       = {wsType_Weapon,wsType_GContainer,wsType_Cannon_Cont,WSTYPE_PLACEHOLDER},
    wsTypeOfWeapon  = {wsType_Weapon,wsType_Shell,wsType_Shell,WSTYPE_PLACEHOLDER},
    Picture         = "UH1Cminigun.png",
    displayName     = _("UH1CMinigunR"),
    Weight          = 100,      --loaded	39kg empty gun + 50.72kg ammo
    Cx_pil          = 0.00015,
    Elements        = {{ShapeName = "UH1CMinigunR"}},
    kind_of_shipping = 2,   -- SOLID_MUNITION
    gun_mounts      = {
gun_mount("M_134", { count = 1000 },  {muzzle_pos = {0, 0, 0}, max_burst_length = 5, rates = {1300}, effect_arg_number = 800}), -- 0.05 (minus goes left)
    },
    shape_table_data = {{file = 'UH1CMinigunR'; username = 'UH1CminigunR'; index = WSTYPE_PLACEHOLDER;}}
}
declare_loadout(UH1CminigunR)


UH1CTwinMGsChin = {
    category        = CAT_PODS,
    CLSID           = "{UH1CTwinMGsChin}",
    attribute       = {wsType_Weapon,wsType_GContainer,wsType_Cannon_Cont,WSTYPE_PLACEHOLDER},
    wsTypeOfWeapon  = {wsType_Weapon,wsType_Shell,wsType_Shell,WSTYPE_PLACEHOLDER},
    Picture         = "ChinGun50cal.png",
    displayName     = _("XM5 2*M2 Browning"),
    Weight          = 100,      --loaded	39kg empty gun + 50.72kg ammo
    Cx_pil          = 0.00015,
    Elements        = {{ShapeName = "ChinGun2xMGs"}},
    kind_of_shipping = 2,   -- SOLID_MUNITION
    gun_mounts      = {
gun_mount("M_2", { count = 1000 },  {muzzle_pos = {4.1, 0.66, 0.125}, max_burst_length    = 2, rates = {800}, azimuth_initial = 120.0,elevation_initial = -20.0, supply_position = {3.90, -0.40, -0.0000},fire_effect(800,7.02,4), effect_arg_number = 800}), -- 0.05 (minus goes left)
gun_mount("M_2", { count = 1000 },  {muzzle_pos = { 4.1, 0.66, -0.02}, max_burst_length    = 2, rates = {800}, azimuth_initial = 120.0,elevation_initial = -20.0, supply_position = {3.90, -0.40, -0.0000},fire_effect(800,7.02,4), effect_arg_number = 800}), -- -0.15
    },
    shape_table_data = {{file = 'ChinGun2xMGs'; username = 'XM5 2*M2 Browning'; index = WSTYPE_PLACEHOLDER;}}
}
declare_loadout(UH1CTwinMGsChin)


XM16TwinM60L = { --(forwards+/back-),(Up+/down-),(left-/right+)
    category        = CAT_PODS,
    CLSID           = "{XM16TwinM60L}",
    attribute       = {wsType_Weapon,wsType_GContainer,wsType_Cannon_Cont,WSTYPE_PLACEHOLDER},
    wsTypeOfWeapon  = {wsType_Weapon,wsType_Shell,wsType_Shell,WSTYPE_PLACEHOLDER},
    Picture         = "UH1C_2xM60.png",
    displayName     = _("XM16 Weapon System"),
    Weight          = 70,      
    Cx_pil          = 0.00015,
    Elements        = {{ShapeName = "UH1CGunnerDummy"}},
    kind_of_shipping = 2,   -- SOLID_MUNITION
    gun_mounts      = {
gun_mount("M_60", { count = 1000 },  {muzzle_pos = {0.3, 0.12, 0.1}, max_burst_length  = 2, rates = {800}, azimuth_initial = 0.0,elevation_initial = 20.0, supply_position = {3.90, -0.40, -0.0000},fire_effect(800,7.02,4), effect_arg_number = 800}), -- 0.05 (minus goes left)
gun_mount("M_60", { count = 1000 },  {muzzle_pos = { 0.3, 0.33, 0.1}, max_burst_length  = 2, rates = {800}, azimuth_initial = 0.0,elevation_initial = 20.0, supply_position = {3.90, -0.40, -0.0000},fire_effect(800,7.02,4), effect_arg_number = 800}), -- -0.15
    },
    shape_table_data = {{file = 'UH1CGunnerDummy'; username = 'XM16 Weapon System'; index = WSTYPE_PLACEHOLDER;}}
}
declare_loadout(XM16TwinM60L)


XM16TwinM60R = { --(forwards+/back-),(Up+/down-),(left-/right+)
    category        = CAT_PODS,
    CLSID           = "{XM16TwinM60R}",
    attribute       = {wsType_Weapon,wsType_GContainer,wsType_Cannon_Cont,WSTYPE_PLACEHOLDER},
    wsTypeOfWeapon  = {wsType_Weapon,wsType_Shell,wsType_Shell,WSTYPE_PLACEHOLDER},
    Picture         = "UH1C_2xM60.png",
    displayName     = _("XM16 Weapon System"),
    Weight          = 70,      
    Cx_pil          = 0.00015,
    Elements        = {{ShapeName = "UH1CGunnerDummy"}},
    kind_of_shipping = 2,   -- SOLID_MUNITION
    gun_mounts      = {
gun_mount("M_60", { count = 1000 },  {muzzle_pos = {0.3, 0.08, -0.1}, max_burst_length  = 2, rates = {800}, azimuth_initial = 0.0, elevation_initial = 20.0, supply_position = {3.90, -0.40, -0.0000},fire_effect(800,7.02,4), effect_arg_number = 800}), -- 0.05 (minus goes left)
gun_mount("M_60", { count = 1000 },  {muzzle_pos = { 0.3, 0.28, -0.1}, max_burst_length  = 2, rates = {800}, azimuth_initial = 0.0, elevation_initial = 20.0, supply_position = {3.90, -0.40, -0.0000},fire_effect(800,7.02,4), effect_arg_number = 800}), -- -0.15
    },
    shape_table_data = {{file = 'UH1CGunnerDummy'; username = 'XM16 Weapon System'; index = WSTYPE_PLACEHOLDER;}}
}
declare_loadout(XM16TwinM60R)

