
dofile(LockOn_Options.common_script_path.."devices_defs.lua")
indicator_type = indicator_types.COMMON
purposes = {render_purpose.GENERAL, render_purpose.HUD_ONLY_VIEW}
init_pageID = 1
page_subsets = {
    [1] = LockOn_Options.script_path.."PilotMFD/indicator/right_stores.lua",
}
pages = {{1}}
