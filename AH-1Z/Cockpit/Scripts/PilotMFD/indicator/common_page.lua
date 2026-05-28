dofile(LockOn_Options.common_script_path.."elements_defs.lua")

SetScale(FOV)

IND_LEVEL = 6

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
font_red = MakeFont({used_DXUnicodeFontData = "font_dejavu_lgc_sans_22"}, {255, 55, 45, 255})

PAGE_FLT = 1
PAGE_WPN = 2
PAGE_TSD = 3
PAGE_SYS = 4
PAGE_COM = 5
PAGE_TSS = 6
PAGE_WCA = 7
PAGE_EW = 8

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

function param_bar(name, param, x, y, w, h, scale, mat, parent)
    local e = rect(name, x, y, w, h, mat or mat_green, parent)
    e.element_params = {param}
    e.controllers = {{"move_up_down_using_parameter", 0, scale or 1.0}}
    return e
end

function visible_root(name, page_param, page, power_required)
    local root = CreateElement "ceSimple"
    root.name = name or create_guid_string()
    root.element_params = {page_param}
    root.controllers = {{"parameter_in_range", 0, page - 0.1, page + 0.1}}
    if power_required then
        root.element_params = {page_param, "PLT_MFD_POWER"}
        root.controllers = {{"parameter_in_range", 0, page - 0.1, page + 0.1}, {"parameter_in_range", 1, 0.5, 1.1}}
    end
    Add(root)
    return root.name
end

function param_visible_root(name, param, low, high, parent)
    local root = CreateElement "ceSimple"
    root.name = name or create_guid_string()
    root.element_params = {param}
    root.controllers = {{"parameter_in_range", 0, low, high}}
    if parent then root.parent_element = parent end
    Add(root)
    return root.name
end

function base_screen(title)
    rect("screen_black", 0, 0, 1.0, 1.0, mat_black)
    rect("inner_glow", 0, 0, 0.92, 0.88, mat_panel)
    rect("active_area", 0, 0, 0.84, 0.78, mat_black)
    if title then text(nil, title, 0.0, 0.41, 0.024, font_green) end
end

function page_tabs(parent, active_label)
    local labels = {"FLT", "WPN", "TSD", "SYS", "COM"}
    local xs = {-0.32, -0.16, 0.0, 0.16, 0.32}
    for i = 1, #labels do
        local mat = labels[i] == active_label and font_white or font_dim
        text(nil, labels[i], xs[i], -0.405, 0.015, mat, parent)
    end
end

function draw_box(parent, x, y, w, h, mat)
    line(nil, x - w / 2, y + h / 2, x + w / 2, y + h / 2, 0.0025, mat or mat_green, parent)
    line(nil, x - w / 2, y - h / 2, x + w / 2, y - h / 2, 0.0025, mat or mat_green, parent)
    line(nil, x - w / 2, y + h / 2, x - w / 2, y - h / 2, 0.0025, mat or mat_green, parent)
    line(nil, x + w / 2, y + h / 2, x + w / 2, y - h / 2, 0.0025, mat or mat_green, parent)
end

function draw_cross(parent, x, y, size, mat)
    line(nil, x - size, y, x + size, y, 0.003, mat or mat_green, parent)
    line(nil, x, y - size, x, y + size, 0.003, mat or mat_green, parent)
end

function draw_adi(parent, cx, cy, scale, compact)
    local root = CreateElement "ceSimple"
    root.name = create_guid_string()
    root.parent_element = parent
    root.init_pos = {cx, cy, 0}
    root.element_params = {"PILOT_ROLL"}
    root.controllers = {{"rotate_using_parameter", 0, -1.0}}
    Add(root)

    rect(nil, 0, 0.09 * scale, 0.44 * scale, 0.22 * scale, mat_blue, root.name)
    rect(nil, 0, -0.09 * scale, 0.44 * scale, 0.22 * scale, mat_brown, root.name)
    line(nil, -0.24 * scale, 0, 0.24 * scale, 0, 0.004 * scale, mat_white, root.name)

    local ladder = CreateElement "ceSimple"
    ladder.name = create_guid_string()
    ladder.parent_element = root.name
    ladder.element_params = {"PILOT_PITCH"}
    ladder.controllers = {{"move_up_down_using_parameter", 0, 0.24 * scale}}
    Add(ladder)

    for i = -4, 4 do
        if i ~= 0 then
            local y = i * 0.045 * scale
            local w = (i % 2 == 0) and 0.13 * scale or 0.085 * scale
            line(nil, -w, y, w, y, 0.0022 * scale, mat_white, ladder.name)
        end
    end

    line(nil, cx - 0.08 * scale, cy, cx - 0.025 * scale, cy, 0.004 * scale, mat_green, parent)
    line(nil, cx + 0.025 * scale, cy, cx + 0.08 * scale, cy, 0.004 * scale, mat_green, parent)
    line(nil, cx, cy - 0.028 * scale, cx, cy + 0.028 * scale, 0.003 * scale, mat_green, parent)

    if not compact then
        param_text(nil, "PILOT_IAS", "%03.0f", -0.32, -0.02, 0.024, font_white, parent)
        param_text(nil, "PILOT_ALT", "%05.0f", 0.32, -0.02, 0.024, font_white, parent)
        param_text(nil, "PILOT_HEADING", "%03.0f", 0.0, -0.31, 0.024, font_green, parent)
        text(nil, "IAS", -0.32, 0.04, 0.014, font_dim, parent)
        text(nil, "ALT", 0.32, 0.04, 0.014, font_dim, parent)
        text(nil, "HDG", 0.0, -0.36, 0.014, font_dim, parent)
    end
end

function draw_flight_page(parent)
    page_tabs(parent, "FLT")
    text(nil, "FLT", 0.0, 0.35, 0.022, font_green, parent)
    draw_adi(parent, 0.0, 0.02, 1.25, false)
    text(nil, "VS", -0.36, 0.25, 0.015, font_dim, parent)
    param_text(nil, "PILOT_VVI", "%+.0f", -0.31, 0.20, 0.018, font_green, parent)
    text(nil, "RALT", 0.30, 0.25, 0.015, font_dim, parent)
    param_text(nil, "PILOT_RADALT", "%04.0f", 0.32, 0.20, 0.018, font_green, parent)
    text(nil, "AOA", -0.35, -0.22, 0.015, font_dim, parent)
    param_text(nil, "PILOT_AOA", "%02.1f", -0.31, -0.27, 0.018, font_green, parent)
end

function draw_weapon_page(parent)
    page_tabs(parent, "WPN")
    text(nil, "WPN", 0.0, 0.35, 0.022, font_green, parent)
    local arm = param_visible_root(nil, "AH1Z_MASTER_ARM", 0.9, 1.1, parent)
    local safe = param_visible_root(nil, "AH1Z_MASTER_ARM", -0.1, 0.1, parent)
    text(nil, "ARM", 0.0, 0.285, 0.024, font_red, arm)
    text(nil, "SAFE", 0.0, 0.285, 0.024, font_green, safe)

    local gun = param_visible_root(nil, "AH1Z_WEAPON_MODE", -0.1, 0.1, parent)
    local rkt = param_visible_root(nil, "AH1Z_WEAPON_MODE", 0.9, 1.1, parent)
    local msl = param_visible_root(nil, "AH1Z_WEAPON_MODE", 1.9, 2.1, parent)
    text(nil, "GUN", -0.24, 0.21, 0.02, font_white, gun)
    text(nil, "RKT", 0.0, 0.21, 0.02, font_white, rkt)
    text(nil, "MSL", 0.24, 0.21, 0.02, font_white, msl)

    line(nil, -0.32, 0.13, 0.32, 0.13, 0.003, mat_green, parent)
    for i = -3, 3 do
        local x = i * 0.08
        draw_box(parent, x, 0.02, 0.045, 0.075, mat_green)
        text(nil, tostring(math.abs(i) + 1), x, -0.04, 0.014, font_dim, parent)
    end

    text(nil, "TURRET", -0.24, -0.14, 0.016, font_dim, parent)
    text(nil, "AZ", -0.34, -0.20, 0.014, font_dim, parent)
    param_text(nil, "AH1Z_CHIN_TURRET_YAW", "%+.2f", -0.25, -0.20, 0.017, font_green, parent)
    text(nil, "EL", -0.05, -0.20, 0.014, font_dim, parent)
    param_text(nil, "AH1Z_CHIN_TURRET_PITCH", "%+.2f", 0.05, -0.20, 0.017, font_green, parent)

    local trig = param_visible_root(nil, "AH1Z_TRIGGER_HELD", 0.9, 1.1, parent)
    text(nil, "TRIG", 0.28, -0.16, 0.018, font_red, trig)
end

function draw_tsd_page(parent)
    page_tabs(parent, "TSD")
    text(nil, "TSD", 0.0, 0.35, 0.022, font_green, parent)
    draw_box(parent, 0, 0, 0.62, 0.56, mat_green_dim)
    for i = -2, 2 do
        line(nil, i * 0.12, -0.28, i * 0.12, 0.28, 0.0015, mat_green_dim, parent)
        line(nil, -0.31, i * 0.11, 0.31, i * 0.11, 0.0015, mat_green_dim, parent)
    end
    line(nil, 0, -0.06, -0.045, -0.13, 0.003, mat_green, parent)
    line(nil, 0, -0.06, 0.045, -0.13, 0.003, mat_green, parent)
    line(nil, 0, -0.06, 0, 0.09, 0.003, mat_green, parent)
    param_text(nil, "PILOT_HEADING", "%03.0f", 0.0, 0.25, 0.022, font_white, parent)
    text(nil, "WPT 01", -0.26, -0.34, 0.016, font_dim, parent)
    text(nil, "RNG 5", 0.26, -0.34, 0.016, font_dim, parent)
end

function draw_sys_page(parent)
    page_tabs(parent, "SYS")
    text(nil, "SYS", 0.0, 0.35, 0.022, font_green, parent)
    local rows = {"ENG 1", "ENG 2", "GEN", "HYD", "FUEL", "XMSN"}
    for i = 1, #rows do
        local y = 0.22 - (i - 1) * 0.075
        text(nil, rows[i], -0.22, y, 0.018, font_green, parent, "LeftCenter")
        text(nil, "OK", 0.21, y, 0.018, font_white, parent)
        line(nil, -0.31, y - 0.035, 0.31, y - 0.035, 0.0018, mat_green_dim, parent)
    end
end

function draw_com_page(parent)
    page_tabs(parent, "COM")
    text(nil, "COM", 0.0, 0.35, 0.022, font_green, parent)
    text(nil, "UHF", -0.23, 0.18, 0.02, font_green, parent)
    text(nil, "305.000", 0.12, 0.18, 0.022, font_white, parent)
    text(nil, "VHF", -0.23, 0.07, 0.02, font_green, parent)
    text(nil, "127.500", 0.12, 0.07, 0.022, font_white, parent)
    text(nil, "ICS", -0.23, -0.04, 0.02, font_green, parent)
    text(nil, "HOT", 0.12, -0.04, 0.022, font_white, parent)
    text(nil, "DATA LINK", -0.23, -0.18, 0.018, font_dim, parent)
    text(nil, "STBY", 0.12, -0.18, 0.018, font_dim, parent)
end

function draw_tss_page(parent)
    page_tabs(parent, "TSS")
    text(nil, "TSS", 0.0, 0.35, 0.022, font_green, parent)
    draw_box(parent, 0, 0.02, 0.58, 0.52, mat_green_dim)
    draw_cross(parent, 0, 0.02, 0.06, mat_green_dim)
    local aim = CreateElement "ceSimple"
    aim.name = create_guid_string()
    aim.parent_element = parent
    aim.element_params = {"AH1Z_EYE_RETICLE_YAW", "AH1Z_EYE_RETICLE_PITCH"}
    aim.controllers = {{"move_left_right_using_parameter", 0, 0.22}, {"move_up_down_using_parameter", 1, 0.22}}
    Add(aim)
    draw_box(aim.name, 0, 0, 0.15, 0.15, mat_green)
    draw_cross(aim.name, 0, 0, 0.04, mat_green)
    text(nil, "LOS", -0.28, -0.30, 0.016, font_dim, parent)
    param_text(nil, "AH1Z_CHIN_TURRET_YAW", "AZ %+.2f", -0.12, -0.30, 0.016, font_green, parent)
    param_text(nil, "AH1Z_CHIN_TURRET_PITCH", "EL %+.2f", 0.16, -0.30, 0.016, font_green, parent)
end

function draw_wca_page(parent)
    page_tabs(parent, "WCA")
    text(nil, "WCA", 0.0, 0.35, 0.022, font_green, parent)
    text(nil, "NO ACTIVE CAUTIONS", 0.0, 0.08, 0.022, font_white, parent)
    text(nil, "ADVISORY CLEAR", 0.0, -0.05, 0.018, font_dim, parent)
end

function draw_ew_page(parent)
    page_tabs(parent, "EW")
    text(nil, "EW", 0.0, 0.35, 0.022, font_green, parent)
    draw_box(parent, 0, 0, 0.5, 0.5, mat_green_dim)
    line(nil, -0.25, 0, 0.25, 0, 0.0018, mat_green_dim, parent)
    line(nil, 0, -0.25, 0, 0.25, 0.0018, mat_green_dim, parent)
    draw_cross(parent, 0, 0, 0.035, mat_green)
    text(nil, "RWR", -0.25, -0.32, 0.017, font_dim, parent)
    text(nil, "QUIET", 0.23, -0.32, 0.017, font_white, parent)
end
