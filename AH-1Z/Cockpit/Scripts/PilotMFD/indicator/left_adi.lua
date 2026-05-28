dofile(LockOn_Options.script_path.."PilotMFD/indicator/common_page.lua")

base_screen("LEFT MFCD")

local flt = visible_root(nil, "PLT_MFD_LEFT_PAGE", PAGE_FLT, true)
draw_flight_page(flt)

local wpn = visible_root(nil, "PLT_MFD_LEFT_PAGE", PAGE_WPN, true)
draw_weapon_page(wpn)

local tsd = visible_root(nil, "PLT_MFD_LEFT_PAGE", PAGE_TSD, true)
draw_tsd_page(tsd)

local sys = visible_root(nil, "PLT_MFD_LEFT_PAGE", PAGE_SYS, true)
draw_sys_page(sys)

local com = visible_root(nil, "PLT_MFD_LEFT_PAGE", PAGE_COM, true)
draw_com_page(com)

local tss = visible_root(nil, "PLT_MFD_LEFT_PAGE", PAGE_TSS, true)
draw_tss_page(tss)

local wca = visible_root(nil, "PLT_MFD_LEFT_PAGE", PAGE_WCA, true)
draw_wca_page(wca)

local ew = visible_root(nil, "PLT_MFD_LEFT_PAGE", PAGE_EW, true)
draw_ew_page(ew)
