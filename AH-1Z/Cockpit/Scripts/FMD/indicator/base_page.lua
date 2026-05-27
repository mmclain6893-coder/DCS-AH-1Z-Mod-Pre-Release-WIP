dofile(LockOn_Options.script_path.."FMD/Indicator/definitions.lua")
local TST  		 = MakeMaterial(nil,{0,0,255,255})

local SHOW_MASKS = false		 
center = {0,0,0}
			 
local aspect       = 1

nav_total_field_of_view 				= CreateElement "ceMeshPoly"
nav_total_field_of_view.name 			= create_guid_string()
nav_total_field_of_view.primitivetype 	= "triangles"
nav_total_field_of_view.vertices	    = { {-aspect , aspect }, { aspect,aspect}, { aspect,-aspect}, {-aspect,-aspect}, }
nav_total_field_of_view.indices			= {0, 1, 2, 0, 2, 3}
nav_total_field_of_view.init_pos		= {0, 0, 0}
nav_total_field_of_view.material		= TST
nav_total_field_of_view.h_clip_relation = h_clip_relations.REWRITE_LEVEL
nav_total_field_of_view.level			= FMD_DEFAULT_LEVEL
nav_total_field_of_view.change_opacity	= false
nav_total_field_of_view.collimated 		= false
nav_total_field_of_view.isvisible		= false
-- Add(nav_total_field_of_view)


local 	black_background     	= CreateElement "ceTexPoly"
black_background.primitivetype 	= "triangles"
black_background.name			= create_guid_string()
black_background.init_pos		= {0,0,0}
black_background.material      	= TST
black_background.vertices	    = { {-aspect, aspect}, { aspect,aspect}, { aspect,-aspect}, {-aspect,-aspect}, }
black_background.indices			= {0,1,2,0,2,3}
black_background.parent_element = nav_total_field_of_view.name
black_background.h_clip_relation= h_clip_relations.REWRITE_LEVEL
black_background.level	  		= FMD_DEFAULT_LEVEL
-- black_background.element_params = {'MFDSPOWER_STATE'}
-- black_background.controllers	= {{"parameter_in_range" ,0,0.9,1.1}}		
-- Add(black_background)
	
-- dofile(LockOn_Options.script_path.."HMD/definitions.lua")

-- local MIR			= create_bg_textured_hud("MIR", 0, 0, 128, 128)
-- MIR.name			= create_guid_string()
-- MIR.init_pos		= {0,0,0}
-- MIR.parent_element	= "FMD_base"
-- AddElement(MIR)



verts = {}
dx=.037
dy=.0147
verts [1]= {-dx,-dy}
verts [2]= {-dx,dy}
verts [3]= {dx,dy}
verts [4]= {dx,-dy}

base 			 	 = CreateElement "ceMeshPoly"
base.name 			 = "base"
base.vertices 		 = verts
base.indices 		 = {0,1,2,2,3,0}
base.init_pos		 = center   
base.material		 = MakeMaterial(nil,{30,3,3,255})
base.h_clip_relation = h_clip_relations.REWRITE_LEVEL 
base.level			 = FMD_DEFAULT_NOCLIP_LEVEL
base.isdraw			 = true
base.change_opacity  = false
base.isvisible		 = false
-- base.element_params  = {"DC_POWER_AVAIL"}  
-- base.controllers     = {{"opacity_using_parameter",0}} 
Add(base)

