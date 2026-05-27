dofile(LockOn_Options.common_script_path.."elements_defs.lua")
CHAFF_COUNT = get_param_handle("CHAFF_COUNT")

SetScale(METERS) 

local font7segment = MakeFont({used_DXUnicodeFontData = "font7segment"},{0,255,0,255}) --(R,G,B,opacity)
local center = {0.1189,-0.2212,1.3665-1}  --- {L/R,U/D,forward/back}

verts = {}
dx=.02
dy=.006
verts [1]= {-dx,-dy}
verts [2]= {-dx,dy}
verts [3]= {dx,dy}
verts [4]= {dx,-dy}
	
local base 			 = CreateElement "ceMeshPoly"
base.name 			 = "base"
base.vertices 		 = verts
base.indices 		 = {0,1,2,2,3,0}
base.init_pos		 = {0.0, 0.0, 0}  
base.material		 = MakeMaterial(nil,{3,3,3,255})
base.h_clip_relation = h_clip_relations.REWRITE_LEVEL 
base.level			 = 5
base.isdraw			 = true
base.change_opacity  = false
base.isvisible		 = false
base.element_params  = {"DC_POWER_AVAIL"}  
base.controllers     = {{"parameter_in_range",0,0.9,1.1}} 
Add(base)


local CHAFF           = CreateElement "ceStringPoly"
CHAFF.name            = create_guid_string()
CHAFF.material        = font7segment	
CHAFF.parent_element  = "base"
CHAFF.alignment       = "CenterCenter"
CHAFF.stringdefs      = {0.007,0.75*0.007, 0, 0}  -- {size vertical, size horizontal, horizontal spacing, 0}
CHAFF.formats         = {"%4.0f"} 
CHAFF.element_params  = {"CHAFF_COUNT"}
CHAFF.controllers     = {{"text_using_parameter",0,0}}
CHAFF.h_clip_relation = h_clip_relations.compare
CHAFF.level			  = 6
Add(CHAFF)




local Xsize = 0.002
local Ysize = Xsize*0.52
function addSegment(element)
	element.vertices	   	= {{-Xsize , Ysize}, 
							   { Xsize , Ysize},
							   { Xsize ,-Ysize},
							   {-Xsize ,-Ysize}}
	element.indices	   		= {0,1,2,2,3,0}
	element.material    	= MakeMaterial(nil,{0,255,0,215})
	element.h_clip_relation = h_clip_relations.REWRITE_LEVEL
	element.level 			= 6
	element.parent_element 	= base.name
	Add(element)
end



local numSegments = 26 
for i = 0,numSegments do
	local CHAFFbar		   = CreateElement "ceMeshPoly"
	CHAFFbar.name		 	   = "segment_"..i
	CHAFFbar.init_pos	 	   = { -0.012, -0.085 + i*0.0029, 0}
	CHAFFbar.controllers 	   = {{"parameter_in_range",0,i*25+300,1200}}
	CHAFFbar.element_params  = {"Chaffs"}	
	addSegment(CHAFFbar)
end
