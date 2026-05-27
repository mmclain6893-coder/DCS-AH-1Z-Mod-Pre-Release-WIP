dofile(LockOn_Options.common_script_path.."elements_defs.lua")
dofile(LockOn_Options.script_path.."FMD/Indicator/definitions.lua")

SetScale(METERS) 
local aspect       = GetAspect()


local FONT    = MakeFont({used_DXUnicodeFontData = "font7segment"},{0,255,0,255})
center={0,0,0}  --- {L/R,U/D,forward/back}

mfd_base_vsd            	= CreateElement "ceSimple"
mfd_base_vsd.name			= create_guid_string()
-- mfd_base_vsd.element_params	= {	"VSD_PAGE-MFD-"..MFD, 'MFDSPOWER_STATE'}
-- mfd_base_vsd.controllers	= {{"parameter_in_range" ,0,0.9,1.1}, {"parameter_in_range" ,1,0.9,1.1}} 
AddElement(mfd_base_vsd)	
	
local FMD_NAV_BG2			= create_bg_textured_fmd("FMD", 0, 0, 1024, 702)
FMD_NAV_BG2.name			= create_guid_string()
FMD_NAV_BG2.init_pos		= {0,0,0}
FMD_NAV_BG2.parent_element		= mfd_base_vsd.name
AddElement(FMD_NAV_BG2)
FMD_NAV_BG2.level			= FMD_DEFAULT_LEVEL
FMD_NAV_BG2.h_clip_relation = h_clip_relations.INCREASE_IF_LEVEL   

local FMD_ADI_BG		= create_bg_textured_fmd("ADI",0, 0, 644, 1024)
FMD_ADI_BG.name			= create_guid_string()
FMD_ADI_BG.init_pos		= {0.003,0.04,0}
FMD_ADI_BG.parent_element		= mfd_base_vsd.name
AddElement(FMD_ADI_BG)
FMD_ADI_BG.level		   =  FMD_DEFAULT_LEVEL  + 1

local FMD_NAV_BG1			= create_bg_textured_fmd("FMD", 0, 0, 1024, 702)
FMD_NAV_BG1.name			= create_guid_string()
FMD_NAV_BG1.init_pos		= {0,0,0}
FMD_NAV_BG1.parent_element		= mfd_base_vsd.name
AddElement(FMD_NAV_BG1)
FMD_NAV_BG1.level			= FMD_DEFAULT_LEVEL + 1
FMD_NAV_BG1.h_clip_relation = h_clip_relations.DECREASE_IF_LEVEL    

local FMD_NAV_BG2			= create_bg_textured_fmd("FMD", 0, 0, 1024, 702)
FMD_NAV_BG2.name			= create_guid_string()
FMD_NAV_BG2.init_pos		= {0,0,0}
FMD_NAV_BG2.parent_element	= mfd_base_vsd.name
AddElement(FMD_NAV_BG2)


local GMT_hours           = CreateElement "ceStringPoly"
GMT_hours.name            = create_guid_string()
GMT_hours.material        = FONT
GMT_hours.init_pos        = {center[1]-.01,center[2],center[3]}		
GMT_hours.alignment       = "RightBottom"
GMT_hours.stringdefs      = {0.012,0.75 * 0.012, 0, 0}  -- {size vertical, horizontal, 0, 0}
GMT_hours.formats         = {"%02.0f"} 
GMT_hours.element_params  = {"GMT_HOURS","DC_POWER_AVAIL"}
GMT_hours.controllers     = {{"text_using_parameter",0,0},{"opacity_using_parameter",1}}  
AddElement(GMT_hours)

local GMT_mins           = CreateElement "ceStringPoly"
GMT_mins.name            = create_guid_string()
GMT_mins.material        = FONT
GMT_mins.init_pos        = center 
GMT_mins.alignment       = "CenterBottom"
GMT_mins.stringdefs      = {0.012,0.75 * 0.012, 0, 0}  -- {size vertical, horizontal, 0, 0}
GMT_mins.formats         = {"%02.0f"} 
GMT_mins.element_params  = {"GMT_MINS","DC_POWER_AVAIL"}
GMT_mins.controllers     = {{"text_using_parameter",0,0},{"opacity_using_parameter",1}}  
AddElement(GMT_mins)

local GMT_sec           = CreateElement "ceStringPoly"
GMT_sec.name            = create_guid_string()
GMT_sec.material        = FONT
GMT_sec.init_pos        = {center[1]+.01,center[2],center[3]}
GMT_sec.alignment       = "LeftBottom"
GMT_sec.stringdefs      = {0.012,0.75 * 0.012, 0, 0}  -- {size vertical, horizontal, 0, 0}
GMT_sec.formats         = {"%02.0f"} 
GMT_sec.element_params  = {"GMT_SECS","DC_POWER_AVAIL"}
GMT_sec.controllers     = {{"text_using_parameter",0,0},{"opacity_using_parameter",1}}  
AddElement(GMT_sec)

local LT_hours           = CreateElement "ceStringPoly"
LT_hours.name            = create_guid_string()
LT_hours.material        = FONT
LT_hours.init_pos        = {center[1]-.01,center[2]-0.005,center[3]}		
LT_hours.alignment       = "RightTop"
LT_hours.stringdefs      = {0.012,0.75 * 0.012, 0, 0}  -- {size vertical, horizontal, 0, 0}
LT_hours.formats         = {"%02.0f"} 
LT_hours.element_params  = {"LT_HOURS","DC_POWER_AVAIL"}
LT_hours.controllers     = {{"text_using_parameter",0,0},{"opacity_using_parameter",1}}  
AddElement(LT_hours)

local LT_mins           = CreateElement "ceStringPoly"
LT_mins.name            = create_guid_string()
LT_mins.material        = FONT
LT_mins.init_pos        = {center[1],center[2]-0.005,center[3]}	 
LT_mins.alignment       = "CenterTop"
LT_mins.stringdefs      = {0.012,0.75 * 0.012, 0, 0}  -- {size vertical, horizontal, 0, 0}
LT_mins.formats         = {"%02.0f"} 
LT_mins.element_params  = {"GMT_MINS","DC_POWER_AVAIL"}
LT_mins.controllers     = {{"text_using_parameter",0,0},{"opacity_using_parameter",2}}  
AddElement(LT_mins)	


