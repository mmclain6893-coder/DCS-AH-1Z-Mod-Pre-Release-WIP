
local explosivePercent = 1.0

local M3RocketHE = {
	category			= CAT_ROCKETS,
	name				= "M3Rocket HEI",
	user_name			= _("M3Rocket HEI"),
	wsTypeOfWeapon		= {wsType_Weapon,wsType_NURS,wsType_Rocket,WSTYPE_PLACEHOLDER},
	scheme 				= "nurs-standard",
	model 				= "UH1Cffar",

        fm = 
        {
            mass        = 4.6,   -- start weight, kg
            caliber     = 0.05, -- Caliber, meters 
            cx_coeff    = {1,0.889005,0.67,0.3173064,2.08},  -- Cx
            L           = 0.927, --Length, meters
            I           = 0.3913938, -- moment of inertia
            Ix          = 0.0017991, -- not used
            Ma          = 0.1316980, -- dependence moment coefficient of  by  AoA
            Mw          = 1.4351299, --  dependence moment coefficient by angular speed
            shapeName   = "",
            
            wind_time   = 0.575, -- dispersion coefficient
            wind_sigma  = 4.8, -- dispersion coefficient
            
            wing_unfold_time = 0.02, -- Unfold time, sec
        },

        engine =
        {
            fuel_mass   = 1.1, -- Fuel mass, kg
            impulse     = 180, -- Specific impulse, sec
            boost_time  = 0, -- Time of booster action
            work_time   = 1.15, -- Time of mid-flight engine action
            boost_factor= 1, -- Booster to cruise trust ratio
            nozzle_position =  {{-0.508, 0, 0}}, -- meters
			nozzle_orientationXYZ =  {{0, 0, 0}},
            tail_width  = 0.050, -- contrail thickness 
            boost_tail  = 1,
            work_tail   = 1,

            smoke_color = {0.9, 0.8, 0.7},
	    smoke_transparency = 0.05,
        },

	warhead	=
	{
	mass			= 1.7, --HEI heavy
    	expl_mass        = 0.44, 
    	other_factors    = { 1.0, 0.5, 0.5 },
    	concrete_factors = { 1.0, 0.5, 0.1 },
    	concrete_obj_factor = 0.0,
    	obj_factors      = { 1.0, 1.0 },
    	cumulative_factor= 3.0,
    	cumulative_thickness = 0.2,

	piercing_mass	= 0.34, --HEI [piercing_mass=warhead.mass, ma se (expl_mass/mass)>0.1 allora piercing_mass=mass/5, quindi 0,44/1.7=0,258  --> 1.7/5=0.34]
	},

	shape_table_data =
	{
		{
			file		 = "UH1Cffar",
			life		 = 1,
			fire		 = {0, 1},
			username = "M3RocketHE",
			index = WSTYPE_PLACEHOLDER,
		},
	},

	properties =
	{
    		dist_min = 350, -- min range, meters
    		dist_max = 4500,    -- max range, meters
	}
}

declare_weapon(M3RocketHE)

local UH1CRocketFFAR = {
	category			= CAT_ROCKETS,
	name				= "UH1CRocket FFAR",
	user_name			= _("M2 Rocket HEI"),
	wsTypeOfWeapon		= {wsType_Weapon,wsType_NURS,wsType_Rocket,WSTYPE_PLACEHOLDER},
	scheme 				= "nurs-standard",
	model 				= "UH1CFFar2",

        fm = 
        {
            mass        = 4.6,   -- start weight, kg
            caliber     = 0.05, -- Caliber, meters 
            cx_coeff    = {1,0.889005,0.67,0.3173064,2.08},  -- Cx
            L           = 0.927, --Length, meters
            I           = 0.3913938, -- moment of inertia
            Ix          = 0.0017991, -- not used
            Ma          = 0.1316980, -- dependence moment coefficient of  by  AoA
            Mw          = 1.4351299, --  dependence moment coefficient by angular speed
            shapeName   = "",
            
            wind_time   = 0.575, -- dispersion coefficient
            wind_sigma  = 4.8, -- dispersion coefficient
            
            wing_unfold_time = 0.02, -- Unfold time, sec
        },

        engine =
        {
            fuel_mass   = 1.1, -- Fuel mass, kg
            impulse     = 180, -- Specific impulse, sec
            boost_time  = 0, -- Time of booster action
            work_time   = 1.15, -- Time of mid-flight engine action
            boost_factor= 1, -- Booster to cruise trust ratio
            nozzle_position =  {{-0.508, 0, 0}}, -- meters
			nozzle_orientationXYZ =  {{0, 0, 0}},
            tail_width  = 0.050, -- contrail thickness 
            boost_tail  = 1,
            work_tail   = 1,

            smoke_color = {0.9, 0.8, 0.7},
	    smoke_transparency = 0.05,
        },

	warhead	=
	{
	mass			= 1.7, --HEI heavy
    	expl_mass        = 0.44, 
    	other_factors    = { 1.0, 0.5, 0.5 },
    	concrete_factors = { 1.0, 0.5, 0.1 },
    	concrete_obj_factor = 0.0,
    	obj_factors      = { 1.0, 1.0 },
    	cumulative_factor= 3.0,
    	cumulative_thickness = 0.2,

	piercing_mass	= 0.34, --HEI [piercing_mass=warhead.mass, ma se (expl_mass/mass)>0.1 allora piercing_mass=mass/5, quindi 0,44/1.7=0,258  --> 1.7/5=0.34]
	},

	shape_table_data =
	{
		{
			file		 = "UH1CFFar2",
			life		 = 1,
			fire		 = {0, 1},
			username = "M2 Rocket HEI",
			index = WSTYPE_PLACEHOLDER,
		},
	},

	properties =
	{
    		dist_min = 350, -- min range, meters
    		dist_max = 4500,    -- max range, meters
	}
}

declare_weapon(UH1CRocketFFAR)

declare_loadout(
{
	category 		= CAT_ROCKETS,
	CLSID 			= "{M3RocketPodL}",
	attribute 		= {wsType_Weapon,wsType_NURS,wsType_Container,182}, --182 (lau-3)
	wsTypeOfWeapon	=	M3RocketHE.wsTypeOfWeapon,	
	Picture 		= "M3RocketPod.png",
	displayName		= _("M3 RocketPodL 24 FFAR(HEI)"),
	Weight 			= 46 + 4.6*25, 
	Count			=	24,
	Cx_pil			=	0.00059912109375,
	kind_of_shipping = 2,
	Elements = {
	
		{
			ShapeName	=	"M3RocketPodL", -- pod name
			IsAdapter = true,
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_01",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_02",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_03",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_04",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_05",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_06",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_07",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_08",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_09",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_10",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_11",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_12",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_13",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_14",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_15",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_16",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_17",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_18",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_19",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_20",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_21",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_22",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_23",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_24",
			ShapeName	=	"UH1Cffar",
		},


	},

}
)

declare_loadout(
{
	category 		= CAT_ROCKETS,
	CLSID 			= "{M3RocketPodR}",
	attribute 		= {wsType_Weapon,wsType_NURS,wsType_Container,182}, --182 (lau-3)
	wsTypeOfWeapon	=	M3RocketHE.wsTypeOfWeapon,	
	Picture 		= "M3RocketPod.png",
	displayName		= _("M3 RocketPodR 24 FFAR(HEI)"),
	Weight 			= 46 + 4.6*25, 
	Count			=	24,
	Cx_pil			=	0.00059912109375,
	kind_of_shipping = 2,
	Elements = {
	
		{
			ShapeName	=	"M3RocketPodR", -- pod name
			IsAdapter = true,
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_25",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_26",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_27",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_28",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_29",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_30",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_31",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_32",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_33",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_34",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_35",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_36",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_37",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_38",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_39",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_40",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_41",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_42",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_43",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_44",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_45",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_46",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_47",
			ShapeName	=	"UH1Cffar",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_48",
			ShapeName	=	"UH1Cffar",
		},


	},

}
)


declare_loadout(
{
	category 		= CAT_ROCKETS,
	CLSID 			= "{XM16RocketPodR}",
	attribute 		= {wsType_Weapon,wsType_NURS,wsType_Container,182}, --182 (lau-3)
	wsTypeOfWeapon	=	UH1CRocketFFAR.wsTypeOfWeapon,	
	Picture 		= "M2RocketPod.png",
	displayName		= _("XM16 Weapon System"),
	Weight 			= 46 + 4.6*7, 
	Count			=	7,
	Cx_pil			=	0.00059912109375,
	kind_of_shipping = 2,
	Elements = {
	
		{
			ShapeName	=	"2M60sRockets_R", -- pod name
			IsAdapter = true,
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_01",
			ShapeName	=	"UH1CFFar2",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_02",
			ShapeName	=	"UUH1CFFar2",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_03",
			ShapeName	=	"UH1CFFar2",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_04",
			ShapeName	=	"UH1CFFar2",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_05",
			ShapeName	=	"UH1CFFar2",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_06",
			ShapeName	=	"UH1CFFar2",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_07",
			ShapeName	=	"UH1CFFar2",
		},


	},

}
)


declare_loadout(
{
	category 		= CAT_ROCKETS,
	CLSID 			= "{XM16RocketPodL}",
	attribute 		= {wsType_Weapon,wsType_NURS,wsType_Container,182}, --182 (lau-3)
	wsTypeOfWeapon	=	UH1CRocketFFAR.wsTypeOfWeapon,	
	Picture 		= "M2RocketPod.png",
	displayName		= _("XM16 Weapon System"),
	Weight 			= 46 + 4.6*7, 
	Count			=	7,
	Cx_pil			=	0.00059912109375,
	kind_of_shipping = 2,
	Elements = {
	
		{
			ShapeName	=	"2M60sRockets_L", -- pod name
			IsAdapter = true,
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_08",
			ShapeName	=	"UH1CFFar2",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_09",
			ShapeName	=	"UUH1CFFar2",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_10",
			ShapeName	=	"UH1CFFar2",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_11",
			ShapeName	=	"UH1CFFar2",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_12",
			ShapeName	=	"UH1CFFar2",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_13",
			ShapeName	=	"UH1CFFar2",
		},

		{
			DrawArgs	= defaultArgs,
			connector_name = "Tube_14",
			ShapeName	=	"UH1CFFar2",
		},


	},

}
)