dofile(LockOn_Options.script_path.."clickable_defs.lua")

if log then
    log.write("AH1Z", log.INFO, "clickabledata.lua loading")
end

dofile(LockOn_Options.script_path.."command_defs.lua")

dofile(LockOn_Options.script_path.."devices.lua")

--dofile(LockOn_Options.script_path.."sounds.lua")

cursor_mode = 

{ 

    CUMODE_CLICKABLE = 0,

    CUMODE_CLICKABLE_AND_CAMERA  = 1,

    CUMODE_CAMERA = 2,

};

clickable_mode_initial_status  = cursor_mode.CUMODE_CLICKABLE



local gettext = require("i_18n")

_ = gettext.translate



elements = {}

-- EFM system



--function default_axis_limited(hint_,device_,command_,arg_,default_,gain_,updatable_,relative_,arg_lim_)

elements["PNT-017"]	= default_2_position_tumb(_("Power, BATT OFF/ON"),	devices.EFM_HELPER, EFM_commands.batterySwitch,	17, UH1CCLICK1)

elements["PNT-016"]	= default_2_position_tumb(_("MAIN GEN"), devices.EFM_HELPER, EFM_commands.generatorSwitch,	16,  UH1CAPU_Start_In)

elements["PNT-087"]	= default_2_position_tumb(_("MAIN GEN Cover"),	devices.ENGINE, device_commands.GenCover,	87, UH1CCLICK1)

elements["PNT-015"]	= default_2_position_tumb(_("Inverter"), devices.EFM_HELPER, EFM_commands.inverterSwitch,	15, UH1CAPU_Start_In)

elements["PNT-004"]	= default_axis_limited(_("Pilot Throttle"),	devices.EFM_HELPER, EFM_commands.throttle, 4, 0.0, 0.03, false, false, 1)

elements["PNT-004a"]	= default_axis_limited(_("Co-Pilot Throttle"),	devices.EFM_HELPER, EFM_commands.throttle, 4, 0.0, 0.03, false, false, 1)

elements["PNT-005"]	= default_2_position_tumb(_("Fuel ON/OFF"),	devices.EFM_HELPER, EFM_commands.throttleIdleCutoff, 5, UH1CCLICK1)

elements["PNT-058"]	= springloaded_3_pos_tumb(_("Engine Starter"),	devices.EFM_HELPER, EFM_commands.starterButton,	58, false, UH1CCLICK1, 3)--springloaded_3_pos_tumb



-- Engines

elements["PNT-089"]	= multiposition_switch_limited(_("VM Dial"),	devices.ENGINE, device_commands.GenSelect,	89, 3, 0.5, true, 0, UH1CSLIDE, 0.9)

elements["PNT-020"]	= multiposition_switch_limited(_("Gen Starter, Start/Stby Gen"),	devices.ENGINE, device_commands.APUGEN,	20, 3, 0.5, true, 0, UH1CCLICK1, 0.9)

elements["PNT-058"]	= springloaded_3_pos_tumb(_("Start"),	devices.ENGINE, device_commands.starterfake,	58, false, UH1CCLICK1, 3)--springloaded_3_pos_tumb

elements["PNT-031"]	= default_2_position_tumb(_("Power Xfer Switches"),	devices.ENGINE, device_commands.PowerXfer,	31, UH1CCLICK1, 1)

elements["PNT-081"]	= default_2_position_tumb(_("Reset Low RPM Warning"),	devices.ENGINE, device_commands.LOWRPM,	81, false, UH1CCLICK1)

elements["PNT-083"]	= springloaded_3_pos_tumb(_("TEST Caution Panel"),	devices.ENGINE, device_commands.CautionPanel,	83, false, UH1CCLICK1, 3)

elements["PNT-084"] = default_2_position_tumb(_("Force Trim"), devices.ENGINE, device_commands.Forcetrim, 84, UH1CCLICK1)

elements["PNT-085"] = default_2_position_tumb(_("Hydraulics"), devices.ENGINE, device_commands.Hydraulics, 85, UH1CCLICK1)

elements["PNT-086"]	= default_2_position_tumb(_("Compass"),	devices.ENGINE, device_commands.Compass,	86, UH1CCLICK1)

elements["PNT-096"]	= default_axis_limited(_("Heading Set Pilot"),	devices.ENGINE, device_commands.HeadingSet,	149, -1, 0.1, false, false, 1)

elements["PNT-096a"] = default_axis_limited(_("Heading Set CoPilot"),	devices.ENGINE, device_commands.HeadingSet,	149, -1, 0.1, false, false, 1)

elements["PNT-088"]	= springloaded_3_pos_tumb(_("FIRE warning Test"),	devices.ENGINE, device_commands.Firetest,	88, false, UH1CCLICK1, 3)

--elements["PNT-023"]	= default_2_position_tumb(_("Fuel PUMP ON/OFF"),	devices.ENGINE,	device_commands.FuelPumpSw,	23, UH1CCLICK1)

elements["PNT-051"]	= default_2_position_tumb(_("Fuel ON/OFF Cover"),	devices.ENGINE, 	device_commands.FueloffCover,	51, UH1CCLICK1)

elements["PNT-023"] = default_2_position_tumb(_("Fuel PUMP ON/OFF"), devices.ENGINE, device_commands.FuelPumpSw, 23, UH1CCLICK1, 0.9)

elements["PNT-097"]	= multiposition_switch_limited(_("StartUp Hints"),	devices.ENGINE, device_commands.Hints,	97, 3, 1, true, -1.0, UH1CSLIDE, 0.9)



--function multiposition_switch_limited(hint_, device_, command_, arg_, count_, delta_, inversed_, min_, sound_, animation_speed_)





--cockpit

elements["DoorHandle"] = default_2_position_tumb(_("Open Door"), devices.OPENDOOR, device_commands.Opendoorsw, 38, UH1CHEAVYSWITCH, 0.5)

elements["DoorHandleL"] = default_2_position_tumb(_("Open Door"), devices.OPENDOOR, device_commands.Opendoorsw, 38, UH1CHEAVYSWITCH, 0.5)

elements["PNT-2007"]	= default_2_position_tumb(_("Wipers, OFF/ON"),	devices.WIPERS, 	device_commands.Wipersw, 2007)







-- Counter measures panel

elements["PNT-043"]	= default_2_position_tumb(_("Countermeasures Cover"),	devices.COUNTERMEASURES, 	device_commands.CMsCover,	43, UH1CCLICK1)

elements["PNT-044"]	= default_2_position_tumb(_("Countermeasures, Arm/Safe"),	devices.COUNTERMEASURES, 	device_commands.MasterArmCMs,	44, UH1CCLICK1)

elements["PNT-045"]	= default_2_position_tumb(_("ECM on/off"),	devices.COUNTERMEASURES, 	device_commands.ECM,		45, UH1CCLICK1) --iCommandActiveJamming

elements["PNT-047"]	= default_2_position_tumb(_("Chaff Selector"),	devices.COUNTERMEASURES,	device_commands.ChaffSelector,	47, UH1CCLICK1, 0.9)

elements["PNT-048"]	= default_2_position_tumb(_("Flare Selector"),	devices.COUNTERMEASURES,	device_commands.FlareSelector,	48, UH1CCLICK1, 0.9)

elements["FLAREFIRE"]	= default_button(_("Flare Fire"),	devices.COUNTERMEASURES,	device_commands.FLAREFIRE,	4008)

elements["CHAFFFIRE"]	= default_button(_("Chaff Fire"),	devices.COUNTERMEASURES,	device_commands.CHAFFFIRE,	4007)







-- Weapons panel

elements["PNT-550"]	= default_red_cover(_("MASTER ARM COVER"),	devices.WEAPON_SYSTEM, 	device_commands.MasterArmCover,	550, 0.9)

elements["PNT-551"]	= default_2_position_tumb(_("Weapons ARM on/off"),	devices.WEAPON_SYSTEM, 	device_commands.MasterArm,	551, UH1CCLICK1, 0.9)

elements["PNT-552"]	= multiposition_switch("Weapon Select",	devices.WEAPON_SYSTEM,	device_commands.GunSelector, 552, 5, 0.5, true, -1, UH1CCLICK1, 0.9)

elements["PNT-3010"]	= default_2_position_tumb(_("Weapons Sight Down"),	devices.WEAPON_SYSTEM, 	device_commands.GunSight,	3010, UH1CSLIDE, 0.9)





-- External Lights 

elements["PNT-013"] = default_2_position_tumb(_("Position Light Switch"),	devices.EXTLIGHTS, device_commands.PositionLightSw,	13, UH1CCLICK1)

elements["PNT-027"] = default_2_position_tumb(_("Anti-Collision Light Switch"),	devices.EXTLIGHTS, device_commands.ANTICOLSw, 27, UH1CCLICK1)

elements["PNT-026"]	= default_2_position_tumb(_("Landing Light Switch, ON/OFF"), devices.EXTLIGHTS, device_commands.LandingLightSw,	2026, UH1CCLICK1)



-- Interior lights

elements["PNT-090"]	= multiposition_switch_limited(_("Co-Pilot Lights, ON/OFF"),	devices.EXTLIGHTS, device_commands.CoPilotLightSw,	90, 3, 0.5, true, 0, UH1CSLIDE, 0.9)

elements["PNT-091"]	= multiposition_switch_limited(_("Main Console Lights"),	devices.EXTLIGHTS, device_commands.ConsoleLightSw, 91, 3, 0.5, true, 0, UH1CSLIDE, 0.9)

elements["PNT-092"]	= multiposition_switch_limited(_("Pedestal Lights"),	devices.EXTLIGHTS, device_commands.PedestalLightSw, 92, 3, 0.5, true, 0, UH1CSLIDE, 0.9)

elements["PNT-093"]	= multiposition_switch_limited(_("Pilot Lights, ON/OFF"),	devices.EXTLIGHTS, device_commands.PilotLightsSw,	93, 3, 0.5, true, 0, UH1CSLIDE, 0.9)

elements["PNT-094"]	= multiposition_switch_limited(_("Secondary Lights"),	devices.EXTLIGHTS, device_commands.SecondaryLightSw, 94, 3, 0.5, true, 0, UH1CSLIDE, 0.9)

elements["PNT-095"]	= multiposition_switch_limited(_("Engine Panel Lights"),	devices.EXTLIGHTS, device_commands.EngineLightSw, 95, 3, 0.5, true, 0, UH1CSLIDE, 0.9)







--Autopilot

elements["PNT-431"] = default_2_position_tumb(_("Autopilot Roll/Pitch"),	devices.AUTOPILOT, device_commands.AP_RP,  	431, UH1CCLICK1) --not working

elements["PNT-433"] = default_2_position_tumb(_("Autopilot Altitude"),		devices.AUTOPILOT, device_commands.AP_ALT,  433, UH1CCLICK1) --not working

elements["PNT-438"] = default_2_position_tumb(_("Autopilot"),				devices.AUTOPILOT, device_commands.AP_ON,  	438, UH1CCLICK1) --not working





-- Toys

elements["PNT-061"] = default_2_position_tumb(_("TapePlayer"),	devices.MPEE, device_commands.TapeDrawer, 2061, UH1CSLIDE, 0.9)

elements["BEACHBOYS"]	= default_2_position_tumb(_("Surfin USA"),		devices.MPEE, device_commands.BeachBoys, 2062, UH1CCLICK1)

elements["NOWHERETORUN"]	= default_2_position_tumb(_("Nowhere To Run"),		devices.MPEE, device_commands.Nowheretorun, 2063, UH1CCLICK1)

elements["VALKYRIE"]	= default_2_position_tumb(_("Ride of the Valkyries"),		devices.MPEE, device_commands.Valkyries, 2064, UH1CCLICK1)



-- AH1Z pilot MFCD/DFD animated buttons

local AH1Z_MFD_BUTTON_SPEED = 28

elements["ah_1z_forward_mfd_left_btn_t1"] = default_button(_("MFD LEFT BTN T1"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7101, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_t2"] = default_button(_("MFD LEFT BTN T2"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7102, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_t3"] = default_button(_("MFD LEFT BTN T3"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7103, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_t4"] = default_button(_("MFD LEFT BTN T4"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7104, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_t5"] = default_button(_("MFD LEFT BTN T5"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7105, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_t6"] = default_button(_("MFD LEFT BTN T6"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7106, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_l1"] = default_button(_("MFD LEFT BTN L1"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7107, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_l2"] = default_button(_("MFD LEFT BTN L2"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7108, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_l3"] = default_button(_("MFD LEFT BTN L3"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7109, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_l4"] = default_button(_("MFD LEFT BTN L4"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7110, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_l5"] = default_button(_("MFD LEFT BTN L5"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7111, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_l6"] = default_button(_("MFD LEFT BTN L6"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7112, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_r1"] = default_button(_("MFD LEFT BTN R1"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7113, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_r2"] = default_button(_("MFD LEFT BTN R2"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7114, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_r3"] = default_button(_("MFD LEFT BTN R3"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7115, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_r4"] = default_button(_("MFD LEFT BTN R4"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7116, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_r5"] = default_button(_("MFD LEFT BTN R5"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7117, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_r6"] = default_button(_("MFD LEFT BTN R6"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7118, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_brt"] = default_button(_("MFD LEFT BTN BRT"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7119, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_cont"] = default_button(_("MFD LEFT BTN CONT"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7120, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_flt"] = default_button(_("MFD LEFT BTN FLT"), devices.PILOT_MFD, device_commands.PilotMFDLeftFLT, 7121, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_map"] = default_button(_("MFD LEFT BTN MAP"), devices.PILOT_MFD, device_commands.PilotMFDLeftMAP, 7122, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_wpn"] = default_button(_("MFD LEFT BTN WPN"), devices.PILOT_MFD, device_commands.PilotMFDLeftWPN, 7123, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_com"] = default_button(_("MFD LEFT BTN COM"), devices.PILOT_MFD, device_commands.PilotMFDLeftCOM, 7124, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_sys"] = default_button(_("MFD LEFT BTN SYS"), devices.PILOT_MFD, device_commands.PilotMFDLeftSYS, 7125, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_tdc"] = default_button(_("MFD LEFT BTN TDC"), devices.PILOT_MFD, device_commands.PilotMFDLeftTDC, 7126, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_wca"] = default_button(_("MFD LEFT BTN WCA"), devices.PILOT_MFD, device_commands.PilotMFDLeftWCA, 7127, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_ew"] = default_button(_("MFD LEFT BTN EW"), devices.PILOT_MFD, device_commands.PilotMFDLeftEW, 7128, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_left_btn_tcc"] = default_button(_("MFD LEFT BTN TCC"), devices.PILOT_MFD, device_commands.PilotMFDLeftTCC, 7129, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_t1"] = default_button(_("MFD RIGHT BTN T1"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7130, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_t2"] = default_button(_("MFD RIGHT BTN T2"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7131, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_t3"] = default_button(_("MFD RIGHT BTN T3"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7132, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_t4"] = default_button(_("MFD RIGHT BTN T4"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7133, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_t5"] = default_button(_("MFD RIGHT BTN T5"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7134, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_t6"] = default_button(_("MFD RIGHT BTN T6"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7135, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_l1"] = default_button(_("MFD RIGHT BTN L1"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7136, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_l2"] = default_button(_("MFD RIGHT BTN L2"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7137, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_l3"] = default_button(_("MFD RIGHT BTN L3"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7138, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_l4"] = default_button(_("MFD RIGHT BTN L4"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7139, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_l5"] = default_button(_("MFD RIGHT BTN L5"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7140, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_l6"] = default_button(_("MFD RIGHT BTN L6"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7141, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_r1"] = default_button(_("MFD RIGHT BTN R1"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7142, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_r2"] = default_button(_("MFD RIGHT BTN R2"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7143, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_r3"] = default_button(_("MFD RIGHT BTN R3"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7144, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_r4"] = default_button(_("MFD RIGHT BTN R4"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7145, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_r5"] = default_button(_("MFD RIGHT BTN R5"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7146, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_r6"] = default_button(_("MFD RIGHT BTN R6"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7147, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_brt"] = default_button(_("MFD RIGHT BTN BRT"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7148, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_cont"] = default_button(_("MFD RIGHT BTN CONT"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7149, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_flt"] = default_button(_("MFD RIGHT BTN FLT"), devices.PILOT_MFD, device_commands.PilotMFDRightFLT, 7150, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_map"] = default_button(_("MFD RIGHT BTN MAP"), devices.PILOT_MFD, device_commands.PilotMFDRightMAP, 7151, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_wpn"] = default_button(_("MFD RIGHT BTN WPN"), devices.PILOT_MFD, device_commands.PilotMFDRightWPN, 7152, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_com"] = default_button(_("MFD RIGHT BTN COM"), devices.PILOT_MFD, device_commands.PilotMFDRightCOM, 7153, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_sys"] = default_button(_("MFD RIGHT BTN SYS"), devices.PILOT_MFD, device_commands.PilotMFDRightSYS, 7154, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_tdc"] = default_button(_("MFD RIGHT BTN TDC"), devices.PILOT_MFD, device_commands.PilotMFDRightTDC, 7155, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_wca"] = default_button(_("MFD RIGHT BTN WCA"), devices.PILOT_MFD, device_commands.PilotMFDRightWCA, 7156, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_mfd_right_btn_tss"] = default_button(_("MFD RIGHT BTN TSS"), devices.PILOT_MFD, device_commands.PilotMFDRightTSS, 7157, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_dfd_btn_l1"] = default_button(_("DFD BTN L1"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7158, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_dfd_btn_l2"] = default_button(_("DFD BTN L2"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7159, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_dfd_btn_l3"] = default_button(_("DFD BTN L3"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7160, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_dfd_btn_l4"] = default_button(_("DFD BTN L4"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7161, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_dfd_btn_r1"] = default_button(_("DFD BTN R1"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7162, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_dfd_btn_r2"] = default_button(_("DFD BTN R2"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7163, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_dfd_btn_r3"] = default_button(_("DFD BTN R3"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7164, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_dfd_btn_r4"] = default_button(_("DFD BTN R4"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7165, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_dfd_0_btn"] = default_button(_("DFD 0 BTN"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7166, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_dfd_1_btn"] = default_button(_("DFD 1 BTN"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7167, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_dfd_2_btn"] = default_button(_("DFD 2 BTN"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7168, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_dfd_3_btn"] = default_button(_("DFD 3 BTN"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7169, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_dfd_4_btn"] = default_button(_("DFD 4 BTN"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7170, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_dfd_5_btn"] = default_button(_("DFD 5 BTN"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7171, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_dfd_6_btn"] = default_button(_("DFD 6 BTN"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7172, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_dfd_7_btn"] = default_button(_("DFD 7 BTN"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7173, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_dfd_8_btn"] = default_button(_("DFD 8 BTN"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7174, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_dfd_9_btn"] = default_button(_("DFD 9 BTN"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7175, AH1Z_MFD_BUTTON_SPEED)

elements["ah_1z_forward_dfd_flt_btn"] = default_button(_("DFD FLT BTN"), devices.PILOT_MFD, device_commands.PilotDFDFLT, 7176, AH1Z_MFD_BUTTON_SPEED)

-- AH1Z pilot MFCD/DFD static-node aliases
elements["ah_1z_forward_mfd_left_btn_t1_static"] = default_button(_("MFD LEFT BTN T1"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7101, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_t2_static"] = default_button(_("MFD LEFT BTN T2"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7102, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_t3_static"] = default_button(_("MFD LEFT BTN T3"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7103, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_t4_static"] = default_button(_("MFD LEFT BTN T4"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7104, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_t5_static"] = default_button(_("MFD LEFT BTN T5"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7105, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_t6_static"] = default_button(_("MFD LEFT BTN T6"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7106, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_l1_static"] = default_button(_("MFD LEFT BTN L1"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7107, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_l2_static"] = default_button(_("MFD LEFT BTN L2"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7108, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_l3_static"] = default_button(_("MFD LEFT BTN L3"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7109, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_l4_static"] = default_button(_("MFD LEFT BTN L4"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7110, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_l5_static"] = default_button(_("MFD LEFT BTN L5"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7111, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_l6_static"] = default_button(_("MFD LEFT BTN L6"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7112, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_r1_static"] = default_button(_("MFD LEFT BTN R1"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7113, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_r2_static"] = default_button(_("MFD LEFT BTN R2"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7114, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_r3_static"] = default_button(_("MFD LEFT BTN R3"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7115, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_r4_static"] = default_button(_("MFD LEFT BTN R4"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7116, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_r5_static"] = default_button(_("MFD LEFT BTN R5"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7117, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_r6_static"] = default_button(_("MFD LEFT BTN R6"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7118, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_brt_static"] = default_button(_("MFD LEFT BTN BRT"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7119, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_cont_static"] = default_button(_("MFD LEFT BTN CONT"), devices.PILOT_MFD, device_commands.PilotMFDLeftButton, 7120, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_flt_static"] = default_button(_("MFD LEFT BTN FLT"), devices.PILOT_MFD, device_commands.PilotMFDLeftFLT, 7121, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_map_static"] = default_button(_("MFD LEFT BTN MAP"), devices.PILOT_MFD, device_commands.PilotMFDLeftMAP, 7122, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_wpn_static"] = default_button(_("MFD LEFT BTN WPN"), devices.PILOT_MFD, device_commands.PilotMFDLeftWPN, 7123, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_com_static"] = default_button(_("MFD LEFT BTN COM"), devices.PILOT_MFD, device_commands.PilotMFDLeftCOM, 7124, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_sys_static"] = default_button(_("MFD LEFT BTN SYS"), devices.PILOT_MFD, device_commands.PilotMFDLeftSYS, 7125, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_tdc_static"] = default_button(_("MFD LEFT BTN TDC"), devices.PILOT_MFD, device_commands.PilotMFDLeftTDC, 7126, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_wca_static"] = default_button(_("MFD LEFT BTN WCA"), devices.PILOT_MFD, device_commands.PilotMFDLeftWCA, 7127, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_ew_static"] = default_button(_("MFD LEFT BTN EW"), devices.PILOT_MFD, device_commands.PilotMFDLeftEW, 7128, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_left_btn_tcc_static"] = default_button(_("MFD LEFT BTN TCC"), devices.PILOT_MFD, device_commands.PilotMFDLeftTCC, 7129, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_t1_static"] = default_button(_("MFD RIGHT BTN T1"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7130, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_t2_static"] = default_button(_("MFD RIGHT BTN T2"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7131, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_t3_static"] = default_button(_("MFD RIGHT BTN T3"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7132, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_t4_static"] = default_button(_("MFD RIGHT BTN T4"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7133, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_t5_static"] = default_button(_("MFD RIGHT BTN T5"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7134, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_t6_static"] = default_button(_("MFD RIGHT BTN T6"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7135, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_l1_static"] = default_button(_("MFD RIGHT BTN L1"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7136, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_l2_static"] = default_button(_("MFD RIGHT BTN L2"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7137, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_l3_static"] = default_button(_("MFD RIGHT BTN L3"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7138, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_l4_static"] = default_button(_("MFD RIGHT BTN L4"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7139, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_l5_static"] = default_button(_("MFD RIGHT BTN L5"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7140, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_l6_static"] = default_button(_("MFD RIGHT BTN L6"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7141, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_r1_static"] = default_button(_("MFD RIGHT BTN R1"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7142, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_r2_static"] = default_button(_("MFD RIGHT BTN R2"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7143, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_r3_static"] = default_button(_("MFD RIGHT BTN R3"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7144, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_r4_static"] = default_button(_("MFD RIGHT BTN R4"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7145, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_r5_static"] = default_button(_("MFD RIGHT BTN R5"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7146, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_r6_static"] = default_button(_("MFD RIGHT BTN R6"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7147, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_brt_static"] = default_button(_("MFD RIGHT BTN BRT"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7148, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_cont_static"] = default_button(_("MFD RIGHT BTN CONT"), devices.PILOT_MFD, device_commands.PilotMFDRightButton, 7149, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_flt_static"] = default_button(_("MFD RIGHT BTN FLT"), devices.PILOT_MFD, device_commands.PilotMFDRightFLT, 7150, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_map_static"] = default_button(_("MFD RIGHT BTN MAP"), devices.PILOT_MFD, device_commands.PilotMFDRightMAP, 7151, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_wpn_static"] = default_button(_("MFD RIGHT BTN WPN"), devices.PILOT_MFD, device_commands.PilotMFDRightWPN, 7152, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_com_static"] = default_button(_("MFD RIGHT BTN COM"), devices.PILOT_MFD, device_commands.PilotMFDRightCOM, 7153, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_sys_static"] = default_button(_("MFD RIGHT BTN SYS"), devices.PILOT_MFD, device_commands.PilotMFDRightSYS, 7154, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_tdc_static"] = default_button(_("MFD RIGHT BTN TDC"), devices.PILOT_MFD, device_commands.PilotMFDRightTDC, 7155, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_wca_static"] = default_button(_("MFD RIGHT BTN WCA"), devices.PILOT_MFD, device_commands.PilotMFDRightWCA, 7156, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_mfd_right_btn_tss_static"] = default_button(_("MFD RIGHT BTN TSS"), devices.PILOT_MFD, device_commands.PilotMFDRightTSS, 7157, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_dfd_btn_l1_static"] = default_button(_("DFD BTN L1"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7158, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_dfd_btn_l2_static"] = default_button(_("DFD BTN L2"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7159, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_dfd_btn_l3_static"] = default_button(_("DFD BTN L3"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7160, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_dfd_btn_l4_static"] = default_button(_("DFD BTN L4"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7161, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_dfd_btn_r1_static"] = default_button(_("DFD BTN R1"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7162, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_dfd_btn_r2_static"] = default_button(_("DFD BTN R2"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7163, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_dfd_btn_r3_static"] = default_button(_("DFD BTN R3"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7164, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_dfd_btn_r4_static"] = default_button(_("DFD BTN R4"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7165, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_dfd_0_btn_static"] = default_button(_("DFD 0 BTN"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7166, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_dfd_1_btn_static"] = default_button(_("DFD 1 BTN"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7167, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_dfd_2_btn_static"] = default_button(_("DFD 2 BTN"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7168, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_dfd_3_btn_static"] = default_button(_("DFD 3 BTN"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7169, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_dfd_4_btn_static"] = default_button(_("DFD 4 BTN"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7170, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_dfd_5_btn_static"] = default_button(_("DFD 5 BTN"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7171, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_dfd_6_btn_static"] = default_button(_("DFD 6 BTN"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7172, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_dfd_7_btn_static"] = default_button(_("DFD 7 BTN"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7173, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_dfd_8_btn_static"] = default_button(_("DFD 8 BTN"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7174, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_dfd_9_btn_static"] = default_button(_("DFD 9 BTN"), devices.PILOT_MFD, device_commands.PilotDFDButton, 7175, AH1Z_MFD_BUTTON_SPEED)
elements["ah_1z_forward_dfd_flt_btn_static"] = default_button(_("DFD FLT BTN"), devices.PILOT_MFD, device_commands.PilotDFDFLT, 7176, AH1Z_MFD_BUTTON_SPEED)

-- The current cockpit EDM exports pilot MFD/DFD click connectors as
-- al_ah_1z_forward_*_static. Keep the commands above readable, then bind the
-- final element table to the connector names DCS can actually find.
for connector, element in pairs(elements) do
    if string.match(connector, "^ah_1z_forward_mfd_") or string.match(connector, "^ah_1z_forward_dfd_") then
        local edm_connector = connector
        if not string.match(edm_connector, "_static$") then
            edm_connector = edm_connector .. "_static"
        end
        edm_connector = "al_" .. edm_connector
        elements[edm_connector] = element
        elements[connector] = nil
    end
end
