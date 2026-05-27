dofile(LockOn_Options.common_script_path.."devices_defs.lua")

indicator_type       = indicator_types.COMMON

if LockOn_Options.screen.oculus_rift == true then
	indicator_type = indicator_types.HELMET
end

purposes			= {render_purpose.SCREENSPACE_INSIDE_COCKPIT, render_purpose.HUD_ONLY_VIEW}
screenspace_scale    = 4;

-------PAGE IDs-------
id_Page =
{
	MAIN = 1,
}

id_pagesubset =
{
	BASE	= 1,
}

page_subsets = {}
page_subsets[id_pagesubset.BASE]	= LockOn_Options.script_path.."HMD/base_page.lua"
  	
----------------------
pages = {}
pages[id_Page.MAIN] = { id_pagesubset.BASE}
init_pageID     = id_Page.MAIN
