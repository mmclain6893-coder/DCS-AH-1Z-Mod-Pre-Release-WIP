dofile(LockOn_Options.common_script_path.."devices_defs.lua")

indicator_type = indicator_types.HELMET
purposes = {render_purpose.GENERAL, render_purpose.HUD_ONLY_VIEW}
additive_alpha = true
collimated = true
use_parser = false
dynamically_update_geometry = false

local BASE = 1

page_subsets = {
    [BASE] = LockOn_Options.script_path.."HMD/indicator/HMD_page.lua",
}

pages = {{BASE}}
init_pageID = BASE
