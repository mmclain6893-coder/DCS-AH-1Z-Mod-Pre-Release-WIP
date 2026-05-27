dofile(LockOn_Options.common_script_path.."devices_defs.lua")
indicator_type       = indicator_types.COMMON
init_pageID     = 2
-- purposes 	   = {render_purpose.GENERAL}
purposes 	   = {render_purpose.GENERAL,render_purpose.HUD_ONLY_VIEW}

-- dy
--subset ids
-- BASE    = 1

-- page_subsets  = {[BASE]    		= LockOn_Options.script_path.."FMD/Indicator/indication_page.lua",}
-- pages = {{BASE,},}


--subset ids
BASE   = 1
page_1 = 2
page_2 = 3
page_3 = 4

id_Page =
{
	mfd_off = 1,
	page_1  = 2,
	page_2  = 3,
	page_3  = 4,
}

page_subsets  = {
[BASE]    	= LockOn_Options.script_path.."FMD/Indicator/base_page.lua",
[page_1]    = LockOn_Options.script_path.."FMD/Indicator/indication_page.lua",
-- [page_2]    = LockOn_Options.script_path.."avRadar_example/Indicator/base_page.lua",
-- [page_2]    = LockOn_Options.script_path.."MFD/Indicator/indication_page.lua",
-- [page_3]    = LockOn_Options.script_path.."MFD/Indicator/NAV.lua",
}

pages = 
{
	{ BASE, mfd_off},
	{ BASE, page_1},
	-- { BASE, page_2},
	-- { BASE, page_1},
}

-- update_screenspace_diplacement(SelfWidth/SelfHeight,false)
-- dedicated_viewport_arcade = dedicated_viewport
