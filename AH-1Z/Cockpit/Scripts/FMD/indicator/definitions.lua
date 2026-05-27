dofile(LockOn_Options.common_script_path.."elements_defs.lua")
dofile(LockOn_Options.script_path.."materials.lua")

max_pixels_count = 569
max_pixels_count = 10
 
FMD_DEFAULT_LEVEL = 6
FMD_DEFAULT_NOCLIP_LEVEL  = FMD_DEFAULT_LEVEL - 1
FMD_SCALE = 1

SetScale(FOV)
vth_ind_color = {20,255,20,255}

function geotoxy(geopos)
	w = 1024 
	h = 1024
	x =  ((w/360) * (180 + geopos.lon)) - 9
	y =  ((h/180) * (90 - geopos.lat)) - 18
	return {x = x, y = y}
end	

local xpos_label = -0.931
local ypos_label = -0.719

function AddElement(object)
    object.use_mipfilter    = true
	object.additive_alpha   = false	
	-- if not LockOn_Options.screen.oculus_rift then
		-- object.screenspace = ScreenType.SCREENSPACE_TRUE
	-- end
	object.h_clip_relation  = h_clip_relations.COMPARE
	object.level			= FMD_DEFAULT_LEVEL
    Add(object)
end

local hdg_text_size_x = 3721
local hdg_text_size_y = 80

function texture_box (UL_X,UL_Y,W,H)
local ux = UL_X / texture_size_x
local uy = UL_Y / texture_size_y
local w  = W / texture_size_x
local h  = H / texture_size_y
return {{ux	    ,uy},
		{ux + w ,uy},
		{ux + w ,uy + h},
		{ux	 	,uy + h}}
end

function hdg_texture_box (UL_X,UL_Y,W,H)
local ux = UL_X / hdg_text_size_x
local uy = UL_Y / hdg_text_size_y
local w  = W / hdg_text_size_x
local h  = H / hdg_text_size_y
return {{ux	    ,uy},
		{ux + w ,uy},
		{ux + w ,uy + h},
		{ux	 	,uy + h}}
end

function AddCircle(xpos, ypos, radius, border, parent_element, color)
	if border <=0 then
		border = 1
	end
	if color == nil then
		color =  materials["DGREEN"]
	end
	for i=1, border do
		    RWR_circle_i 			= CreateElement "ceMeshPoly"
			RWR_circle_i.name 			= create_guid_string()
			RWR_circle_i.primitivetype 	= "triangles"
			RWR_circle_i.init_pos       = {xpos , ypos}
			set_circle	(RWR_circle_i, radius + 0.0020, radius - 0.0020, 360, 36)
			RWR_circle_i.material 		= color
			RWR_circle_i.h_clip_relation= h_clip_relations.COMPARE
			RWR_circle_i.level			= FMD_DEFAULT_LEVEL
			RWR_circle_i.isdraw		 	= true
			RWR_circle_i.parent_element = parent_element
		AddElement(RWR_circle_i)
		radius = radius + 0.001
	end
	return RWR_circle_i
end

function AddMenuOption(number, value, parent_element, element_params)
	local label_text			= CreateElement "ceStringPoly"
	label_text.name				= create_guid_string()
	vstringdefs					= {0.0060,0.0013,0.0,0}
	if number >= 0 and number <= 4 then
		label_text.init_pos	= {-0.67 + (number * 0.32), 0.94}
	elseif number >= 5 and number <= 9 then
		label_text.init_pos	= {0.95, 0.63 - ((number - 5) * 0.32)}
	elseif number >= 10 and number <= 14 then
		label_text.init_pos	= {0.63 - ((number - 10) * 0.32), -0.93}
	elseif number >= 15 and number <= 20 then
		label_text.init_pos	= {-0.94, -0.73 + ((number - 15) * 0.32)}
	end
	label_text.alignment		= "CenterCenter"
	label_text.material       	= fonts["GREEN_MENU"]
	label_text.value			= value
	label_text.stringdefs		= vstringdefs
	label_text.parent_element   = parent_element
	if element_params ~= nil then
		label_text.element_params = {element_params}
		label_text.controllers	  = {{"parameter_in_range" ,0,0.9,1.1},} 
	end
	Add(label_text)
end

function MenuSelectOption(number, parent_element, element_params)
	scale = 2
	if number >= 5 and number <= 9 or number >= 15 and number <= 20 then
		scale = 2.5
	end
	
	local MenuSelectItem			= create_bg_textured_box("VSD_ELEMENTS", 212, 975, 345, 1022,nil,nil,scale)
	MenuSelectItem.name				= create_guid_string()
	MenuSelectItem.parent_element   = parent_element
	
	if number >= 0 and number <= 4 then
		MenuSelectItem.init_pos	= {-0.67 + (number * 0.32), 0.94}
	elseif number >= 5 and number <= 9 then
		MenuSelectItem.init_rot = {90, 0, 0}
		MenuSelectItem.init_pos	= {0.95, 0.63 - ((number - 5) * 0.32)}
	elseif number >= 10 and number <= 14 then
		MenuSelectItem.init_pos	= {0.63 - ((number - 10) * 0.32), -0.93}
	elseif number >= 15 and number <= 20 then
		MenuSelectItem.init_rot		= {90, 0}
		MenuSelectItem.init_pos	= {-0.94, -0.73 + ((number - 15) * 0.32)}
	end
	
	if element_params ~= nil then
		MenuSelectItem.element_params = {element_params}
		MenuSelectItem.controllers	  = {{"parameter_in_range" ,0,0.9,1.1},} 
	end
	AddElement(MenuSelectItem)
end


function Add_FMD_VIDEO_Element(object)
	object.use_mipfilter      = true
	object.h_clip_relation    = h_clip_relations.COMPARE
	object.level			  = FMD_DEFAULT_LEVEL
	object.additive_alpha     = false --additive blending
	object.collimated 		  = false
	Add(object)
end

local texture_size_x = 1024
local texture_size_y = 1024

local hdg_text_size_x = 40
local hdg_text_size_y = 40

function texture_box (UL_X,UL_Y,W,H)
local ux = UL_X / texture_size_x
local uy = UL_Y / texture_size_y
local w  = W / texture_size_x
local h  = H / texture_size_y
return {{ux	    ,uy},
		{ux + w ,uy},
		{ux + w ,uy + h},
		{ux	 	,uy + h}}
end


function create_bg_textured_box(ind_material,UL_X,UL_Y,DR_X,DR_Y,CENTER_X,CENTER_Y, scale, tex_size)

if scale == nil then
	scale = 2
end
if tex_size == nil then
	tex_size = 1024
end
local mils_per_pixel = scale/tex_size
local W 	   		 = DR_X - UL_X
local H 	   		 = DR_Y - UL_Y
local cx		     = (UL_X + 0.5 * W)
local cy		     = (UL_Y + 0.5 * H)

local CENTER_X 		 = CENTER_X or cx
local CENTER_Y 		 = CENTER_Y or cy
local dcx 		 	 = mils_per_pixel * (CENTER_X - cx)
local dcy 		     = mils_per_pixel * (CENTER_Y - cy)

local half_x 		 = 0.5 * W * mils_per_pixel
local half_y 		 = 0.5 * H * mils_per_pixel

local object = CreateElement "ceTexPoly"
	  object.material =  textures[ind_material]
 	  object.vertices =  {{-half_x - dcx, half_y + dcy},
						  { half_x - dcx, half_y + dcy},
						  { half_x - dcx,-half_y + dcy},
						  {-half_x - dcx,-half_y + dcy}}
	  object.tex_coords = texture_box(UL_X,UL_Y,W,H)
	  object.indices	  = default_box_indices
	  return object
end

function create_bg_textured_fmd(ind_material,UL_X,UL_Y,DR_X,DR_Y,CENTER_X,CENTER_Y, scale, tex_size)

if scale == nil then
	scale = 0.121
end
if tex_size == nil then
	tex_size = 1024
end
local mils_per_pixel = scale/tex_size
local W 	   		 = DR_X - UL_X
local H 	   		 = DR_Y - UL_Y
local cx		     = (UL_X + 1 * W)
local cy		     = (UL_Y + 1 * H)

local CENTER_X 		 = CENTER_X or cx
local CENTER_Y 		 = CENTER_Y or cy
local dcx 		 	 = mils_per_pixel * (CENTER_X - cx)
local dcy 		     = mils_per_pixel * (CENTER_Y - cy)

local half_x 		 = 1 * W * mils_per_pixel
local half_y 		 = 1 * H * mils_per_pixel

local object = CreateElement "ceTexPoly"
	  object.material =  textures[ind_material]
 	  object.vertices =  {{-half_x - dcx, half_y + dcy},
						  { half_x - dcx, half_y + dcy},
						  { half_x - dcx,-half_y + dcy},
						  {-half_x - dcx,-half_y + dcy}}
	  object.tex_coords = texture_box(UL_X,UL_Y,W,H)
	  object.indices	  = default_box_indices
	  return object
end

function create_line(PosX, PosY, SizeX, SizeY, material, parent, clipRelation, clipLevel, showbox)
	local box = CreateElement "ceMeshPoly"
	box.name = create_guid_string()
	box.primitivetype = "triangles"

	box.vertices	= { {-SizeX,-SizeY},
						{-SizeX,SizeY},
						{ SizeX,SizeY},
						 {SizeX,-SizeY}}

	box.indices		 = default_default_box_indices
	box.init_pos		 = {PosX, PosY, 0}
	box.material		 = material

	if parent ~= nil then
		box.parent_element = parent.name
	end

	box.use_mipfilter = true
	box.additive_alpha = false
	box.h_clip_relation = h_clip_relations.COMPARE
	box.level			= FMD_DEFAULT_LEVEL
    if showbox ~= nil then
    		box.isvisible		 = showbox
    end

	if clipRelation ~= nil then
		box.h_clip_relation = clipRelation
		box.level			 = clipLevel
		box.isdraw			 = true
		box.change_opacity	 = false
	else
		if clipLevel ~= nil then
			box.h_clip_relation = h_clip_relations.DECREASE_IF_LEVEL
			box.clipLevel = clipLevel
		end
	end
	return box
end

function Rectangle(width, parent_element, h, w)
	local rightBoxLine			= CreateElement "ceSimpleLineObject"
	rightBoxLine.name			= create_guid_string()
	rightBoxLine.material		= materials["MHUD"]
	rightBoxLine.width			= width
	rightBoxLine.vertices		= {{h, w}, {h, -w}}
	rightBoxLine.parent_element	= parent_element.name
	rightBoxLine.element_params  = {"FMD_STATE" }
	rightBoxLine.controllers     = {{"opacity_using_parameter" ,0,1}} 
	AddElement(rightBoxLine)

	local leftBoxLine				= Copy(rightBoxLine)
	leftBoxLine.vertices	= {{-h, w}, {-h, -w}}
	AddElement(leftBoxLine)

	local topBoxLine				= Copy(rightBoxLine)
	topBoxLine.vertices	= {{-h,w}, {h, w}}
	AddElement(topBoxLine)

	local botomBoxLine				= Copy(rightBoxLine)
	botomBoxLine.vertices	= {{-h, -w}, {h, -w}}
	AddElement(botomBoxLine)
end

function create_rect_text(text, posx, posy, bw, bh, Border, material, pparent, stringdefs)
	
	local parent          = CreateElement "ceStringPoly"
	parent.name           = create_guid_string()
	parent.material       = fonts["FONT_GREEN"]
	parent.init_pos       = {posx, posy}
	parent.stringdefs     = stringdefs
	parent.alignment	  = "CenterCenter"
	parent.value  	      = text
	parent.parent_element = pparent.name
	AddElement(parent)

	local  rect_top_line 		= create_line(0 ,0 , bw, Border, material, parent)
	rect_top_line.init_pos 		= {0,-bh}
	AddElement(rect_top_line)

	local  rect_bottom_line = Copy(rect_top_line)
	rect_bottom_line.init_pos 	= {0, bh}
	AddElement(rect_bottom_line)

	local  rect_left_line 		= create_line(0 ,0 , Border, bh ,material, parent)
	rect_left_line.init_pos 	= {-bw,0}
	AddElement(rect_left_line)

	local  rect_right_line = Copy(rect_left_line)
	rect_right_line.init_pos 	= { bw, 0}
	AddElement(rect_right_line)

end

function create_rect(bw, bh, Border, material, parent)

	local  rect_top_line 		= create_line(0 ,0 , bw, Border ,material, parent)
	rect_top_line.init_pos 		= {0,-bh}
	AddElement(rect_top_line)

	local  rect_bottom_line = Copy(rect_top_line)
	rect_bottom_line.init_pos 	= {0, bh}
	AddElement(rect_bottom_line)

	local  rect_left_line 		= create_line(Border ,0 , Border, bh ,material, parent)
	rect_left_line.init_pos 	= {-bw +(Border ), 0}
	AddElement(rect_left_line)

	local  rect_right_line = Copy(rect_left_line)
	rect_right_line.init_pos 	= { bw -(Border ) , 0}
	AddElement(rect_right_line)

end

