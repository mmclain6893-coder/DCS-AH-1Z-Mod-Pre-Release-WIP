dofile(LockOn_Options.common_script_path.."elements_defs.lua")

SetCustomScale(1.0)

function AddElement(object)
	object.screenspace = ScreenType.SCREENSPACE_TRUE
    object.use_mipfilter = true
    Add(object)
end

local aspect        = LockOn_Options.screen.aspect
local size          = 0.15
local tex_scale     = 0.25/size
local line_width    = (4.5/512)/tex_scale
local box_height					= 0.2
local ds           = 0.05 * size
local collec_shift = 0.3*size
local rud_shift    = 0.1*size

base       			= CreateElement "ceMeshPoly"
base.name		    = "base"
base.primitivetype  = "triangles"
base.material       = MakeMaterial(nil,{255, 0, 0, 100})
base.vertices       = {{-(size + collec_shift + rud_shift + 3.0*line_width + ds), -(box_height )},
                       {-(size + collec_shift + rud_shift + 3.0*line_width + ds),  box_height  }, 
                       { size  + ds                            ,  box_height  },
                       { size  + ds                            , -(box_height )}}        
base.indices        = default_box_indices
base.init_pos       = {(-1*aspect + 1.7*size),(1 - 1.5*size) * -1}
base.element_params = {"SHOW_CONTROLS"} 
base.controllers    = {{"parameter_in_range", 0, 1}}
base.h_clip_relation = h_clip_relations.REWRITE_LEVEL
base.level		     = 8
AddElement(base)

pitch_scale                = CreateElement "ceTexPoly"
pitch_scale.name		   = "pitch_scale"
pitch_scale.vertices       = {{-size   , -line_width},
                              {-size   ,  line_width},
                              { size   ,  line_width},
                              { size   , -line_width}}
pitch_scale.indices		   = default_box_indices
pitch_scale.material	   = MakeMaterial("arcade.tga",{255, 0, 0, 255})
pitch_scale.init_rot       = {90,0,0}
pitch_scale.tex_params	   = {256/512,176.5/512,0.5*tex_scale,2*tex_scale}
pitch_scale.parent_element = base.name
AddElement(pitch_scale)

roll_scale                = CreateElement "ceTexPoly"
roll_scale.name		      = "roll_scale"
roll_scale.vertices       = {{-size   , -line_width},
                             {-size   ,  line_width},
                             { size   ,  line_width},
                             { size   , -line_width}}
roll_scale.indices		  = default_box_indices
roll_scale.material	      = MakeMaterial("arcade.tga",{255, 0, 0, 255})
roll_scale.tex_params	  = {256/512,176.5/512,tex_scale,2*tex_scale}
roll_scale.parent_element = base.name
AddElement(roll_scale)

local stick_index_sz           = 0.1 * size
stick_position					= CreateElement "ceTexPoly"
stick_position.name             = "stick_position"
stick_position.vertices         = {{-stick_index_sz, -stick_index_sz},
                                   {-stick_index_sz,  stick_index_sz},
                                   { stick_index_sz,  stick_index_sz},
                                   { stick_index_sz, -stick_index_sz}}
stick_position.indices          = default_box_indices
stick_position.material	       = MakeMaterial("arcade.tga",{255, 0, 0, 255})
stick_position.tex_params	   = {330/512,365.5 / 512,2*tex_scale,2*tex_scale/0.8}
stick_position.element_params  = {"PITCH_INPUT","ROLL_INPUT"} 
stick_position.controllers    = {{"move_left_right_using_parameter",1, size},
								 {"move_up_down_using_parameter",0, size}}
stick_position.parent_element = base.name
AddElement(stick_position)


rudder_scale                = Copy(roll_scale)
rudder_scale.init_pos       = {0,-(size + rud_shift)}
AddElement(rudder_scale)

rudder_index             = Copy(roll_scale)
rudder_index.vertices    = {{-2.0*line_width , -line_width},
                            {-2.0*line_width ,  line_width},
                            { 2.0*line_width ,  line_width},
                            { 2.0*line_width , -line_width}}
rudder_index.element_params  = {"PEDAL_INPUT"}  
rudder_index.controllers 	 = {{"move_up_down_using_parameter",0, size}}
rudder_index.init_rot       = {90,0}
rudder_index.parent_element = rudder_scale.name
rudder_index.tex_params	   = {256/512,176.5/512,0.5*tex_scale/3,2*tex_scale/3}
rudder_index.material	       = MakeMaterial("arcade.tga",{255, 0, 0, 255})
AddElement(rudder_index)

collective_scale             = Copy(pitch_scale)
collective_scale.vertices    = {{0, -line_width},
                                {0,  line_width},
                                {size  ,  line_width},
                                {size, -line_width}}
collective_scale.init_pos    = {-(size + collec_shift),-size*0.5}
AddElement(collective_scale)


collective_index             = Copy(roll_scale)
collective_index.vertices    = {{-2.0*line_width , -line_width},
                                {-2.0*line_width ,  line_width},
                                { 2.0*line_width ,  line_width},
                                { 2.0*line_width , -line_width}}
collective_index.element_params  = {"COLLECTIVE_INPUT"}  
collective_index.controllers = {{"move_up_down_using_parameter",0, size}}
collective_index.tex_params	   = {256/512,176.5/512,0.5*tex_scale/3,2*tex_scale/3}
collective_index.init_rot    = {-90,0,0}
collective_index.material=MakeMaterial("arcade.tga",{255, 0, 0, 255})
collective_index.parent_element  = collective_scale.name
AddElement(collective_index)

local font7segment = MakeFont({used_DXUnicodeFontData = "font7segment"},{0,255,0,255}) --(R,G,B,opacity)
local font7segment = MakeFont({used_DXUnicodeFontData = "FUI/Fonts/font_arial_17"},{0,255,0,255})

local bearing           = CreateElement "ceStringPoly"
bearing.name            = create_guid_string()
bearing.material        = font7segment	
bearing.init_pos    	= {0,1}
bearing.alignment       = "LeftCenter"
bearing.stringdefs      = {0.0032,0.003, 0, 0}  -- {size vertical, horizontal, 0, 0}
bearing.formats         = {"%.5f\n"} 
bearing.element_params  = {"RATE_PITCH", "RATE_ROLL","RATE_YAW","PITCH_INPUT","ROLL_INPUT","PEDAL_INPUT"}
bearing.controllers     = {	 {"text_using_parameter",0,0}
							,{"text_using_parameter",1,0}
							,{"text_using_parameter",2,0}
							,{"text_using_parameter",3,0}
							,{"text_using_parameter",4,0}
							,{"text_using_parameter",5,0}
							,{"text_using_parameter",6,0}
							}
bearing.h_clip_relation = h_clip_relations.compare
bearing.level			= 6
bearing.parent_element  = base.name
-- AddElement(bearing)
