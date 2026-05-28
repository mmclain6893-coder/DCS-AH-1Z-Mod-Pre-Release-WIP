dofile(LockOn_Options.common_script_path.."elements_defs.lua")

SetScale(FOV)

local hmd_green = MakeMaterial(nil, {0, 255, 80, 255})
local cue_outer = 0.145
local cue_inner = 0.030

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

local cue = CreateElement "ceSimple"
cue.name = "AH1Z_HMD_EYE_CUE"
cue.init_pos = {0.0, 0.0, 0.0}
cue.element_params = {
    "AH1Z_EYE_RETICLE_VISIBLE",
    "AH1Z_EYE_RETICLE_YAW",
    "AH1Z_EYE_RETICLE_PITCH",
}
cue.controllers = {
    {"opacity_using_parameter", 0},
    {"move_left_right_using_parameter", 1, 0.28},
    {"move_up_down_using_parameter", 2, 0.22},
}
cue.additive_alpha = true
cue.collimated = true
Add(cue)

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
