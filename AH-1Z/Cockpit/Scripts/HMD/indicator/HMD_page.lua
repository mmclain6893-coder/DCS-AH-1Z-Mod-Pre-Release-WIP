dofile(LockOn_Options.common_script_path.."elements_defs.lua")

SetScale(FOV)

local hmd_green = MakeMaterial(nil, {0, 255, 80, 255})
local hmd_dim = MakeMaterial(nil, {0, 105, 40, 210})
local font_hmd = MakeFont({used_DXUnicodeFontData = "font_dejavu_lgc_sans_22"}, {0, 255, 80, 255})
local font_dim = MakeFont({used_DXUnicodeFontData = "font_dejavu_lgc_sans_22"}, {0, 140, 55, 230})
local font_warn = MakeFont({used_DXUnicodeFontData = "font_dejavu_lgc_sans_22"}, {255, 45, 30, 255})
local cue_outer = 0.095
local cue_inner = 0.032

local function add_line(name, parent, verts, thickness)
    local line = CreateElement "ceSMultiLine"
    line.name = name
    line.parent_element = parent
    line.material = hmd_green
    line.vertices = verts
    line.indices = {}
    for i = 0, #verts - 1 do
        line.indices[#line.indices + 1] = i
    end
    line.thickness = thickness or 1.8
    line.additive_alpha = true
    line.collimated = true
    line.isdraw = true
    line.isvisible = true
    Add(line)
    return line
end

local function add_text(name, value, parent, x, y, size, material, align)
    local text = CreateElement "ceStringPoly"
    text.name = name
    text.parent_element = parent
    text.value = value
    text.material = material or font_hmd
    text.alignment = align or "CenterCenter"
    text.stringdefs = {size, size * 0.72, 0, 0}
    text.init_pos = {x, y, 0}
    text.additive_alpha = true
    text.collimated = true
    text.isdraw = true
    text.isvisible = true
    Add(text)
    return text
end

local function add_param_text(name, parent, param, fmt, x, y, size, material, align)
    local text = add_text(name, "", parent, x, y, size, material, align)
    text.element_params = {param}
    text.formats = {fmt}
    text.controllers = {{"text_using_parameter", 0, 0}}
    return text
end

local function add_circle(name, parent, radius, segments, material, thickness)
    local verts = {}
    for i = 0, segments do
        local a = (math.pi * 2.0) * (i / segments)
        verts[#verts + 1] = {math.cos(a) * radius, math.sin(a) * radius}
    end

    local line = CreateElement "ceSMultiLine"
    line.name = name
    line.parent_element = parent
    line.material = material or hmd_dim
    line.vertices = verts
    line.indices = {}
    for i = 0, #verts - 1 do
        line.indices[#line.indices + 1] = i
    end
    line.thickness = thickness or 1.0
    line.additive_alpha = true
    line.collimated = true
    line.isdraw = true
    line.isvisible = true
    Add(line)
    return line
end

local function add_box(name, parent, x, y, w, h, material, thickness)
    local t = thickness or 1.8
    add_line(name.."_TOP", parent, {{x - w / 2, y + h / 2}, {x + w / 2, y + h / 2}}, t).material = material or hmd_green
    add_line(name.."_BOTTOM", parent, {{x - w / 2, y - h / 2}, {x + w / 2, y - h / 2}}, t).material = material or hmd_green
    add_line(name.."_LEFT", parent, {{x - w / 2, y + h / 2}, {x - w / 2, y - h / 2}}, t).material = material or hmd_green
    add_line(name.."_RIGHT", parent, {{x + w / 2, y + h / 2}, {x + w / 2, y - h / 2}}, t).material = material or hmd_green
end

local function visible_root(name, param, low, high, parent)
    local root = CreateElement "ceSimple"
    root.name = name
    root.parent_element = parent
    root.element_params = {param}
    root.controllers = {{"parameter_in_range", 0, low, high}}
    root.additive_alpha = true
    root.collimated = true
    Add(root)
    return root.name
end

local fixed = CreateElement "ceSimple"
fixed.name = "AH1Z_HMD_FIXED_ROOT"
fixed.init_pos = {0.0, 0.0, 0.0}
fixed.element_params = {"AH1Z_EYE_RETICLE_VISIBLE"}
fixed.controllers = {{"opacity_using_parameter", 0}}
fixed.additive_alpha = true
fixed.collimated = true
Add(fixed)

local cue = CreateElement "ceSimple"
cue.name = "AH1Z_HMD_MOVING_LOS"
cue.parent_element = fixed.name
cue.init_pos = {0.0, 0.0, 0.0}
cue.element_params = {
    "AH1Z_EYE_RETICLE_YAW",
    "AH1Z_EYE_RETICLE_PITCH",
}
cue.controllers = {
    {"move_left_right_using_parameter", 0, 0.28},
    {"move_up_down_using_parameter", 1, 0.22},
}
cue.additive_alpha = true
cue.collimated = true
Add(cue)

add_circle("AH1Z_HMD_VISOR_FOV", fixed.name, 0.245, 72, hmd_dim, 0.8)
add_line("AH1Z_HMD_HORIZON", fixed.name, {{-0.22, 0.0}, {-0.12, 0.0}, {0.12, 0.0}, {0.22, 0.0}}, 0.9).material = hmd_dim
add_line("AH1Z_HMD_CENTER_TICK", fixed.name, {{0.0, -0.014}, {0.0, 0.014}}, 1.0).material = hmd_dim
add_box("AH1Z_HMD_WEAPON_BOX", cue.name, 0.0, 0.0, 0.125, 0.125, hmd_green, 1.6)

add_line("AH1Z_HMD_EYE_CUE_LEFT", cue.name, {
    {-cue_outer, 0.0},
    {-cue_inner, 0.0},
}, 2.4)

add_line("AH1Z_HMD_EYE_CUE_RIGHT", cue.name, {
    {cue_inner, 0.0},
    {cue_outer, 0.0},
}, 2.4)

add_line("AH1Z_HMD_EYE_CUE_TOP", cue.name, {
    {0.0, cue_inner},
    {0.0, cue_outer},
}, 2.4)

add_line("AH1Z_HMD_EYE_CUE_BOTTOM", cue.name, {
    {0.0, -cue_inner},
    {0.0, -cue_outer},
}, 2.4)

add_text("AH1Z_HMD_LOS_LABEL", "LOS", fixed.name, -0.09, -0.185, 0.010, font_dim)
add_param_text("AH1Z_HMD_AZ", fixed.name, "AH1Z_CHIN_TURRET_YAW", "AZ %+.2f", -0.12, -0.215, 0.010, font_hmd)
add_param_text("AH1Z_HMD_EL", fixed.name, "AH1Z_CHIN_TURRET_PITCH", "EL %+.2f", 0.12, -0.215, 0.010, font_hmd)

local arm = visible_root("AH1Z_HMD_ARMED_ROOT", "AH1Z_MASTER_ARM", 0.9, 1.1, fixed.name)
add_text("AH1Z_HMD_ARMED", "ARM", arm, 0.0, 0.205, 0.012, font_warn)

local safe = visible_root("AH1Z_HMD_SAFE_ROOT", "AH1Z_MASTER_ARM", -0.1, 0.1, fixed.name)
add_text("AH1Z_HMD_SAFE", "SAFE", safe, 0.0, 0.205, 0.012, font_dim)
