
dofile(LockOn_Options.common_script_path.."elements_defs.lua")

SetScale(FOV)

local IND_LEVEL = 6
local NOCLIP_LEVEL = IND_LEVEL - 1

mat_black = MakeMaterial(nil, {1, 3, 2, 255})
mat_panel = MakeMaterial(nil, {8, 10, 9, 255})
mat_green = MakeMaterial(nil, {40, 255, 90, 255})
mat_green_dim = MakeMaterial(nil, {10, 125, 45, 220})
mat_white = MakeMaterial(nil, {220, 240, 230, 255})
mat_blue = MakeMaterial(nil, {68, 139, 213, 255})
mat_brown = MakeMaterial(nil, {190, 108, 62, 255})
mat_grey = MakeMaterial(nil, {60, 68, 66, 255})
mat_red = MakeMaterial(nil, {255, 55, 45, 255})

font_green = MakeFont({used_DXUnicodeFontData = "font_dejavu_lgc_sans_22"}, {40, 255, 90, 255})
font_white = MakeFont({used_DXUnicodeFontData = "font_dejavu_lgc_sans_22"}, {235, 245, 235, 255})
font_dim = MakeFont({used_DXUnicodeFontData = "font_dejavu_lgc_sans_22"}, {10, 135, 45, 255})

function add_poly(name, verts, mat, parent)
    local e = CreateElement "ceMeshPoly"
    e.name = name or create_guid_string()
    e.primitivetype = "triangles"
    e.vertices = verts
    e.indices = {0, 1, 2, 0, 2, 3}
    e.material = mat
    e.h_clip_relation = h_clip_relations.COMPARE
    e.level = IND_LEVEL
    if parent then e.parent_element = parent end
    Add(e)
    return e
end

function rect(name, x, y, w, h, mat, parent)
    return add_poly(name, {{x - w / 2, y + h / 2}, {x + w / 2, y + h / 2}, {x + w / 2, y - h / 2}, {x - w / 2, y - h / 2}}, mat, parent)
end

function line(name, x1, y1, x2, y2, thickness, mat, parent)
    local dx = x2 - x1
    local dy = y2 - y1
    local len = math.sqrt(dx * dx + dy * dy)
    if len < 0.0001 then len = 0.0001 end
    local nx = -dy / len * thickness
    local ny = dx / len * thickness
    return add_poly(name, {{x1 + nx, y1 + ny}, {x2 + nx, y2 + ny}, {x2 - nx, y2 - ny}, {x1 - nx, y1 - ny}}, mat, parent)
end

function text(name, value, x, y, size, mat, parent, align)
    local e = CreateElement "ceStringPoly"
    e.name = name or create_guid_string()
    e.value = value
    e.material = mat or font_green
    e.alignment = align or "CenterCenter"
    e.stringdefs = {size, size * 0.72, 0, 0}
    e.init_pos = {x, y, 0}
    e.h_clip_relation = h_clip_relations.COMPARE
    e.level = IND_LEVEL
    if parent then e.parent_element = parent end
    Add(e)
    return e
end

function param_text(name, param, fmt, x, y, size, mat, parent, align)
    local e = text(name, "", x, y, size, mat, parent, align)
    e.formats = {fmt}
    e.element_params = {param}
    e.controllers = {{"text_using_parameter", 0, 0}}
    return e
end

function base_screen()
    rect("screen_black", 0, 0, 1.0, 1.0, mat_black, nil)
    rect("inner_glow", 0, 0, 0.92, 0.88, mat_panel, nil)
    rect("active_area", 0, 0, 0.84, 0.78, mat_black, nil)
end

function draw_bezel_labels(page_title)
    text(nil, page_title, 0.0, 0.41, 0.026, font_green)
    text(nil, "BRT", -0.37, -0.41, 0.018, font_dim)
    text(nil, "MENU", 0.0, -0.41, 0.018, font_dim)
    text(nil, "MODE", 0.34, -0.41, 0.018, font_dim)
end

function draw_adi(cx, cy, scale, small)
    local root = CreateElement "ceSimple"
    root.name = create_guid_string()
    root.init_pos = {cx, cy, 0}
    root.element_params = {"PILOT_ROLL"}
    root.controllers = {{"rotate_using_parameter", 0, -1.0}}
    Add(root)

    local sky = rect(nil, 0, 0.09 * scale, 0.42 * scale, 0.22 * scale, mat_blue, root.name)
    local ground = rect(nil, 0, -0.09 * scale, 0.42 * scale, 0.22 * scale, mat_brown, root.name)
    local horizon = line(nil, -0.22 * scale, 0, 0.22 * scale, 0, 0.004 * scale, mat_white, root.name)
    local ladder = CreateElement "ceSimple"
    ladder.name = create_guid_string()
    ladder.parent_element = root.name
    ladder.element_params = {"PILOT_PITCH"}
    ladder.controllers = {{"move_up_down_using_parameter", 0, 0.25 * scale}}
    Add(ladder)

    for i = -3, 3 do
        if i ~= 0 then
            local y = i * 0.045 * scale
            local w = (i % 2 == 0) and 0.12 * scale or 0.075 * scale
            line(nil, -w, y, w, y, 0.0022 * scale, mat_white, ladder.name)
        end
    end

    line(nil, -0.07 * scale, 0, -0.02 * scale, 0, 0.004 * scale, mat_green)
    line(nil, 0.02 * scale, 0, 0.07 * scale, 0, 0.004 * scale, mat_green)
    line(nil, 0, -0.025 * scale, 0, 0.025 * scale, 0.003 * scale, mat_green)

    if not small then
        text(nil, "ADI", -0.34, 0.30, 0.018, font_green)
        param_text(nil, "PILOT_IAS", "%03.0f", -0.31, -0.02, 0.024, font_white)
        param_text(nil, "PILOT_ALT", "%05.0f", 0.31, -0.02, 0.024, font_white)
        param_text(nil, "PILOT_HEADING", "%03.0f", 0.0, -0.32, 0.024, font_green)
        line(nil, -0.36, -0.10, -0.25, -0.10, 0.002, mat_green)
        line(nil, 0.25, -0.10, 0.36, -0.10, 0.002, mat_green)
    end
end
