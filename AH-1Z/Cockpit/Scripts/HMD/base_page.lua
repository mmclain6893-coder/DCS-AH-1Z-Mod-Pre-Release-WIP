dofile(LockOn_Options.script_path.."HMD/definitions.lua")

strdefsDigits = {0.004,0.003, 0, 0} 

NOCLIP_LEVEL = HMD_DEFAULT_LEVEL - 1
CLIP_LEVEL = HMD_DEFAULT_LEVEL + 1

local TST  		 = MakeMaterial(nil,{0,100,0,255})

-- SetCustomScale(0)

dl=LockOn_Options.screen.aspect -- demi-largeur
dh=LockOn_Options.screen.width/LockOn_Options.screen.height

base					= CreateElement "ceMeshPoly"
base.name				= create_guid_string()
base.primitivetype		= "triangles"
base.material			= TST
base.vertices			= {{-dl, dh},{-dl,  -dh}, { dl,  -dh},{ dl, dh}}        
base.indices			= default_box_indices
base.init_pos			= {0,0} -- centre ecran si ScreenType.SCREENSPACE_TRUE
base.h_clip_relation	= h_clip_relations.REWRITE_LEVEL
base.level				= NOCLIP_LEVEL
base.isvisible		= false

if not LockOn_Options.screen.oculus_rift then
	base.screenspace = ScreenType.SCREENSPACE_TRUE
end

Add(base)

total_field_of_view 				= CreateElement "ceMeshPoly"
total_field_of_view.name 			= create_guid_string()
total_field_of_view.primitivetype 	= "triangles"
total_field_of_view.vertices		= {{-dl, dh},{-dl,  -dh}, { dl,  -dh},{ dl, dh}}   
total_field_of_view.indices		 	= default_box_indices
total_field_of_view.material		= TST
total_field_of_view.h_clip_relation = h_clip_relations.INCREASE_IF_LEVEL
total_field_of_view.level			= NOCLIP_LEVEL
total_field_of_view.isvisible		= false
total_field_of_view.parent_element	= base.name

if not LockOn_Options.screen.oculus_rift then
	total_field_of_view.screenspace = ScreenType.SCREENSPACE_TRUE
end

Add(total_field_of_view)

texture_size= 2048 -- 2048x2048
-- pour remplir tout l'écran
-- fonctionne jusqu'à 1920
coeff=2
if LockOn_Options.screen.width > 1920 then
	coeff=2*LockOn_Options.screen.width/1920
end
tex_scale = LockOn_Options.screen.height/(coeff*texture_size)

dlpix=1 /tex_scale
dhpix=1 /tex_scale

HMD					= CreateElement "ceTexPoly"
HMD.name			= create_guid_string()
HMD.vertices		= {{-dlpix, dhpix}, {-dlpix, -dhpix},{dlpix, -dhpix}, {dlpix, dhpix}}
HMD.indices			= default_box_indices
HMD.tex_params 		= {1, 1, tex_scale, tex_scale} -- pos x centre, pos y centre texture
HMD.init_pos		= {0, 0, 0}
HMD.material		= MakeMaterial(LockOn_Options.script_path.."../Textures/hmd.dds", {255,255,255, 255} )
HMD.use_mipfilter	= true
HMD.isvisible		= true
HMD.h_clip_relation	= h_clip_relations.COMPARE
-- HMD.element_params	= {"SUNGLASS"}
-- HMD.controllers		= {{"move_up_down_using_parameter",0,(-1/tex_scale)}}
HMD.level			= HMD_DEFAULT_LEVEL
HMD.parent_element	= base.name

if not LockOn_Options.screen.oculus_rift then
	HMD.screenspace = ScreenType.SCREENSPACE_TRUE
end
-- Add(HMD)

local horizon_line			= create_bg_textured_hud("HMD", 15, 15, 873, 61, nil, 18)
horizon_line.name			= create_guid_string()
horizon_line.init_pos		= {0,0,0}
horizon_line.parent_element	= base.name
horizon_line.element_params  	= {"CURRENT_ROLL", "CURRENT_PITCH" , "HMD_STATE" }
horizon_line.controllers     	= {{"rotate_using_parameter" ,0,  1}, {"move_up_down_using_parameter", 1, -0.60 }, {"opacity_using_parameter" ,2,1}} 		
AddElement(horizon_line)

local pitch_indc			= create_bg_textured_hud("HMD", 947, 4, 1015, 272)
pitch_indc.name				= create_guid_string()
pitch_indc.init_pos			= {0.8,0,0}
pitch_indc.parent_element	= base.name
pitch_indc.element_params  = {"HMD_STATE" }
pitch_indc.controllers     = {{"opacity_using_parameter" ,0,1}} 
AddElement(pitch_indc)

local cross			= create_bg_textured_hud("HMD", 9, 62, 69, 121)
cross.name			= create_guid_string()
cross.init_pos		= {0,0,0}
cross.parent_element  = base.name
cross.element_params  = {"HMD_STATE" }
cross.controllers     = {{"opacity_using_parameter" ,0,1}} 
AddElement(cross)

local bearing           = CreateElement "ceStringPoly"
bearing.name            = create_guid_string()
bearing.material        = fonts["FONT_HUD"]
bearing.alignment       = "CenterCenter"
bearing.stringdefs      = strdefsDigits
bearing.formats         = {"%.0f"} 
bearing.element_params  = {"CURRENT_HDG", "HMD_STATE" }
bearing.controllers     = {{"text_using_parameter",0}, {"opacity_using_parameter" ,1,1}} 
bearing.init_pos		= {-0.6,-0.5}
bearing.parent_element  = base.name
AddElement(bearing)

local RALT           = CreateElement "ceStringPoly"
RALT.name            = create_guid_string()
RALT.material        = fonts["FONT_HUD"]
RALT.alignment       = "CenterCenter"
RALT.stringdefs      = strdefsDigits
RALT.formats         = {"%.0f"} 
RALT.element_params  = {"CURRENT_RALT", "HMD_STATE" }
RALT.controllers     = {{"text_using_parameter",0}, {"opacity_using_parameter" ,1,1}} 
RALT.init_pos		 = {0.6,-0.5}
RALT.parent_element  = base.name
AddElement(RALT)

local TAS           = CreateElement "ceStringPoly"
TAS.name            = create_guid_string()
TAS.material        = fonts["FONT_HUD"]
TAS.alignment       = "CenterCenter"
TAS.stringdefs      = strdefsDigits
TAS.formats         = {"%.0f"} 
TAS.element_params  = {"CURRENT_TAS", "HMD_STATE" }
TAS.controllers     = {{"text_using_parameter",0}, {"opacity_using_parameter" ,1,1}} 
TAS.init_pos		 = {0,0.6}
TAS.parent_element  = base.name
AddElement(TAS)

local symbol_TASpeed           = CreateElement "ceStringPoly"
symbol_TASpeed.name            = create_guid_string()
symbol_TASpeed.material        = fonts["FONT_HUD"]
symbol_TASpeed.init_pos        = {0.2,0}
symbol_TASpeed.stringdefs      = strdefsDigits
symbol_TASpeed.alignment	   = "RightBottom"
symbol_TASpeed.value  		   = "T"
symbol_TASpeed.parent_element  = base.name
symbol_TASpeed.element_params  = {"HMD_STATE" }
symbol_TASpeed.controllers     = {{"opacity_using_parameter" ,0,1}} 
AddElement(symbol_TASpeed)

Rectangle(0.004, TAS, 0.11, 0.04)
Rectangle(0.004, RALT, 0.15, 0.04)
Rectangle(0.004, bearing, 0.11, 0.04)


