
dofile(LockOn_Options.script_path.."PilotMFD/indicator/common_page.lua")
base_screen()
draw_adi(0, 0.03, 0.95, true)
text(nil, "STBY", 0.0, 0.36, 0.020, font_green)
param_text(nil, "PILOT_HEADING", "%03.0f", 0.0, -0.30, 0.020, font_green)
