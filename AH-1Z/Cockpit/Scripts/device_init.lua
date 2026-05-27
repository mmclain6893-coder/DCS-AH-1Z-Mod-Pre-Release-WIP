dofile(LockOn_Options.script_path.."devices.lua")

if log then
    log.write("AH1Z", log.INFO, "device_init.lua loading")
end



dofile(LockOn_Options.common_script_path.."tools.lua")



	



MainPanel = {"ccMainPanel",LockOn_Options.script_path.."mainpanel_init.lua"}



	



creators = {}



creators[devices.ELECTRIC_SYSTEM]	= {"avSimpleElectricSystem"} -- needed for simpleRWR to work



creators[devices.WEAPON_SYSTEM]		= {"avSimpleWeaponSystem"	,LockOn_Options.script_path.."Systems/weapon_system.lua"} --{"avSimpleWeaponSystem"	}



creators[devices.RWR]	 			= {"avSimpleRWR"			,LockOn_Options.script_path.."RWR/device/RWR_device.lua"}	



creators[devices.EXTLIGHTS]			= {"avLuaDevice"			,LockOn_Options.script_path.."Systems/ExternalLights.lua"}



--creators[devices.EXTANIM]			= {"avLuaDevice"			,LockOn_Options.script_path.."Systems/Extanim.lua"}



creators[devices.AVIONICS]    		= {"avLuaDevice"            ,LockOn_Options.script_path.."Systems/Avionics.lua"}



creators[devices.DIGITAL_CLOCK]    	= {"avLuaDevice"            ,LockOn_Options.script_path.."M880A_digitalClock/M880A_device.lua"}



creators[devices.EFM_HELPER]    	= {"avLuaDevice"            ,LockOn_Options.script_path.."Systems/EFM_Helper.lua"} 



creators[devices.FCS]    			= {"avLuaDevice"            ,LockOn_Options.script_path.."Systems/FCS.lua"} 



creators[devices.HELMET_DEVICE] 	= {"avNightVisionGoggles"}



creators[devices.OILPRESSURE] 		= {"avLuaDevice"			,LockOn_Options.script_path.."Systems/oilpressure.lua"}



creators[devices.CLOCK]			 	= {"avLuaDevice"			 ,LockOn_Options.script_path.."clock.lua"}



creators[devices.WINCH] 			= {"avLuaDevice"			,LockOn_Options.script_path.."Systems/winch.lua"}



creators[devices.SYSTEM]			= {"avLuaDevice"			,LockOn_Options.script_path.."Systems/init.lua"}



--creators[devices.GEAR]				= {"avLuaDevice"			,LockOn_Options.script_path.."Systems/gear.lua"}



creators[devices.WIPERS]			= {"avLuaDevice"			,LockOn_Options.script_path.."Systems/Wipers.lua"}



creators[devices.GUNNERS]			= {"avLuaDevice"			,LockOn_Options.script_path.."Systems/Gunners.lua"}



creators[devices.OPENTAIL]			= {"avLuaDevice"			,LockOn_Options.script_path.."Systems/Opentail.lua"}



creators[devices.REFUELPROBE]		= {"avLuaDevice"			,LockOn_Options.script_path.."Systems/Refuelprobe.lua"}



creators[devices.RAMP]				= {"avLuaDevice"			,LockOn_Options.script_path.."Systems/Ramp.lua"}



creators[devices.ELECWARN]			= {"avLuaDevice"			,LockOn_Options.script_path.."Systems/ElectricWarnings.lua"}



creators[devices.COCKSHAKE]			= {"avLuaDevice"			,LockOn_Options.script_path.."Systems/Cockshake.lua"}



creators[devices.OPENDOOR]			= {"avLuaDevice" 			,LockOn_Options.script_path.."Systems/door.lua"}



creators[devices.TRIM]				= {"avLuaDevice" 			,LockOn_Options.script_path.."Systems/trim.lua"}



--creators[devices.BRAKES]			= {"avLuaDevice" 			,LockOn_Options.script_path.."Systems/brakes.lua"}



--creators[devices.STEERING]			= {"avLuaDevice" 			,LockOn_Options.script_path.."Systems/Steering.lua"}



creators[devices.AUTOPILOT]      	= {"avLuaDevice"           	,LockOn_Options.script_path.."Systems/autopilot.lua"}



creators[devices.ENGINE]        	= {"avLuaDevice"            ,LockOn_Options.script_path.."Systems/Engine.lua"}



creators[devices.MPEE]              = {"avLuaDevice"            ,LockOn_Options.script_path.."Systems/MPEE.lua"}



creators[devices.INTERCOM]     		= {"avIntercom"             ,LockOn_Options.script_path.."Systems/Intercom.lua", {devices.UHF_RADIO} }



creators[devices.UHF_RADIO]     	= {"avUHF_ARC_164"          ,LockOn_Options.script_path.."Systems/UHF_radio.lua", {devices.INTERCOM} } 



creators[devices.COUNTERMEASURES]	= {"avSimpleWeaponSystem" 	,LockOn_Options.script_path.."Systems/Countermeasures.lua"}



creators[devices.FUEL]        		= {"avLuaDevice"            ,LockOn_Options.script_path.."Systems/fuel.lua"}



--creators[devices.HELPER]			= {"avLuaDevice"  			,LockOn_Options.script_path.."Systems/helper.lua"}







-- Temporary visual-alignment mode: the borrowed UH-1M cockpit Lua systems



-- assume the original UH-1M cockpit EDM connector/argument table. The current



-- AH-1Z cockpit EDM can crash CockpitBase when the full stack is enabled.



-- Normal DCS protocol: F1/VR uses Cockpit/Shape/AH-1Z_Cockpit.edm with the cockpit device stack active.
AH1Z_VISUAL_ALIGN_MODE = true



if AH1Z_VISUAL_ALIGN_MODE then



    creators[devices.WEAPON_SYSTEM] = nil



    creators[devices.RWR] = nil



    creators[devices.EXTLIGHTS] = nil



    creators[devices.AVIONICS] = nil



    creators[devices.DIGITAL_CLOCK] = nil



    creators[devices.EFM_HELPER] = nil



    creators[devices.FCS] = nil



    creators[devices.OILPRESSURE] = nil



    creators[devices.CLOCK] = nil



    creators[devices.WINCH] = nil



    creators[devices.SYSTEM] = nil



    creators[devices.WIPERS] = nil



    creators[devices.GUNNERS] = nil



    creators[devices.OPENTAIL] = nil



    creators[devices.REFUELPROBE] = nil



    creators[devices.RAMP] = nil



    creators[devices.ELECWARN] = nil



    creators[devices.COCKSHAKE] = nil



    creators[devices.OPENDOOR] = nil



    creators[devices.TRIM] = nil



    creators[devices.AUTOPILOT] = nil



    creators[devices.ENGINE] = nil



    creators[devices.MPEE] = nil



    creators[devices.INTERCOM] = nil



    creators[devices.UHF_RADIO] = nil



    creators[devices.COUNTERMEASURES] = nil



    creators[devices.FUEL] = nil



end



-- Rotor args 36/40 are driven by AH1Z_FM.dll, same pattern as UH-1M's EFM



-- driven rotor argument. The AH-1Z bridge is kept on disk for diagnostics but



-- is only enabled while visual-alignment mode suppresses the full UH-1M stack.



-- AH1Z_EFM_BRIDGE disabled while isolating CockpitBase get_argument CTD



-- creators[devices.WINDVANE] disabled while isolating CockpitBase get_argument CTD



-- Re-enable only the AH-1Z pilot MFCD Lua device while the borrowed UH-1M
-- cockpit systems remain isolated. This device feeds the three PilotMFD
-- ccIndicator pages and receives the clickable bezel/DFD button commands.
creators[devices.PILOT_MFD] = {"avLuaDevice", LockOn_Options.script_path.."Systems/PilotMFD.lua"}







indicators = {}



-- AH-1Z pilot cockpit live display overlays.



indicators[#indicators + 1] = {"ccIndicator", LockOn_Options.script_path.."PilotMFD/indicator/plt_left_init.lua", nil, {{"PLT_MFD_PORT_CENTER", "PLT_MFD_PORT_DOWN", "PLT_MFD_PORT_RIGHT"}, {rz = 0}, 1}, 1}



indicators[#indicators + 1] = {"ccIndicator", LockOn_Options.script_path.."PilotMFD/indicator/plt_right_init.lua", nil, {{"PLT_MFD_STBD_CENTER", "PLT_MFD_STBD_DOWN", "PLT_MFD_STBD_RIGHT"}, {rz = 0}, 1}, 1}



indicators[#indicators + 1] = {"ccIndicator", LockOn_Options.script_path.."PilotMFD/indicator/plt_dfd_init.lua", nil, {{"PLT_DFD_CENTER", "PLT_DFD_DOWN", "PLT_DFD_RIGHT"}, {rz = 0}, 1}, 1}



--[[



indicators[#indicators + 1] = {"ccControlsIndicatorBase", LockOn_Options.script_path.."ControlsIndicator/ControlsIndicator.lua", nil}



indicators[#indicators + 1] = {"ccIndicator", LockOn_Options.script_path.."RPM_Display/init.lua", nil,{{"PNT1",nil,nil}, {rz=-14},2},2} 



indicators[#indicators + 1] = {"ccIndicator", LockOn_Options.script_path.."tempTorqDisplay/init.lua", nil,{{"PNT2",nil,nil}, {rz=-14},2},2}



indicators[#indicators + 1] = {"ccIndicator" ,LockOn_Options.script_path.."M880A_digitalClock/init.lua",nil,{{"PNT3",nil,nil}, {rz=-14},2},2}



indicators[#indicators + 1] = {"ccIndicator" ,LockOn_Options.script_path.."RadarAltitude/init.lua",nil, {{"RADALT",nil,nil}, {rz=-14},2},2}



indicators[#indicators + 1] = {"ccIndicator" ,LockOn_Options.script_path.."RadarAltitude/init.lua",nil, {{"RADALT1",nil,nil}, {rz=-14},2},2}



indicators[#indicators + 1] = {"ccIndicator" ,LockOn_Options.script_path.."RWR/Indicator/init.lua",nil,{{"RWR001",nil,nil}, {rz=-14},2},2}



indicators[#indicators + 1] = {"ccIndicator" ,LockOn_Options.script_path.."BearingIndicator/init.lua",nil,{{"BEARING1",nil,nil}, {rz=-14},2},2}



indicators[#indicators + 1] = {"ccIndicator" ,LockOn_Options.script_path.."FuelIndicator/init.lua",nil,{{"FUELDIG",nil,nil}, {rz=-14},2},2}



indicators[#indicators + 1] = {"ccIndicator", LockOn_Options.script_path.."RPM_Display/init.lua", nil,{{"PNT1.001",nil,nil}, {rz=-14},2},2} 



indicators[#indicators + 1] = {"ccIndicator", LockOn_Options.script_path.."tempTorqDisplay/init.lua", nil,{{"PNT2.001",nil,nil}, {rz=-14},2},2}



indicators[#indicators + 1] = {"ccIndicator" ,LockOn_Options.script_path.."M880A_digitalClock/init.lua",nil,{{"PNT3.001",nil,nil}, {rz=-14},2},2}



indicators[#indicators + 1] = {"ccIndicator" ,LockOn_Options.script_path.."BearingIndicator/init.lua",nil,{{"BEARING2",nil,nil}, {rz=-14},2},2}



indicators[#indicators + 1] = {"ccIndicator" ,LockOn_Options.script_path.."BearingIndicator/init.lua",nil,{{"BEARING3",nil,nil}, {rz=-14},2},2}



indicators[#indicators + 1] = {"ccIndicator" ,LockOn_Options.script_path.."BearingIndicator/init.lua",nil,{{"BEARING4",nil,nil}, {rz=-14},2},2}



indicators[#indicators + 1] = {"ccIndicator" ,LockOn_Options.script_path.."FuelIndicator/init.lua",nil,{{"FUELDIG.1",nil,nil}, {rz=-14},2},2}



indicators[#indicators + 1] = {"ccIndicator" ,LockOn_Options.script_path.."RadarAltitude/init.lua",nil, {{"RADALT2",nil,nil}, {rz=-14},2},2}



indicators[#indicators + 1] = {"ccIndicator" ,LockOn_Options.script_path.."RadarAltitude/init.lua",nil, {{"RADALT3",nil,nil}, {rz=-14},2},2}



indicators[#indicators + 1] = {"ccIndicator" ,LockOn_Options.script_path.."CHAFFS/init.lua",nil, {{"CHAFF",nil,nil}, {rz=-85},2},2}



indicators[#indicators + 1] = {"ccIndicator" ,LockOn_Options.script_path.."FLARES/init.lua",nil, {{"FLARES",nil,nil}, {rz=-85},2},2}







indicators[#indicators + 1] = {"UH1C::ccGunnersCPanel", LockOn_Options.script_path.."AI/ControlPanel/g_panel.lua",devices.WEAPON_SYSTEM}



]]











dofile(LockOn_Options.common_script_path.."KNEEBOARD/declare_kneeboard_device.lua")


































-- CTD isolation: keep the inherited Lua cockpit devices off, but allow the
-- purpose-built AH-1Z pilot MFCD device to drive live display parameters and
-- receive clickable bezel/DFD button commands.
if AH1Z_VISUAL_ALIGN_MODE then
    local ah1z_safe_creators = {}
    ah1z_safe_creators[devices.PILOT_MFD] = creators[devices.PILOT_MFD]
    creators = ah1z_safe_creators
end




