local dev = GetSelf()
dofile(LockOn_Options.script_path.."Systems/Avionics.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
--dofile(LockOn_Options.script_path.."Systems/EFM_Helper.lua")

local sensor_data = get_base_data()

local update_time_step = 0.2
make_default_activity(update_time_step)

elec_dc_ok  = get_param_handle("DC_POWER_AVAIL")

local enginestage_param  = get_param_handle("ENGINESTAGE")
local enginestage = 0
local NowRalt = 0
local ticker = 0

local starterButton1 = 3000
dev:listen_command(device_commands.APUGEN)
dev:listen_command(device_commands.GenSelect)
dev:listen_command(device_commands.FuelShutoffSw)
dev:listen_command(device_commands.starterfake)
dev:listen_command(device_commands.LOWRPM)
dev:listen_command(Keys.BattSwitch)
dev:listen_command(Keys.ExtPwrSwitch)
dev:listen_command(Keys.ThrottleIncrease)
dev:listen_command(Keys.ThrottleDecrease)
dev:listen_command(Keys.ThrottleCutoff)
dev:listen_command(Keys.showControlInd)
dev:listen_command(EFM_commands.starterButton)
dev:listen_command(EFM_commands.JoystickThrottle)


function post_initialize()

    local birth = LockOn_Options.init_conditions.birth_place
    if birth=="AIR_HOT" then
	
		dev:performClickableAction(device_commands.GenSelect, 1, true)
		dev:performClickableAction(device_commands.FuelPumpSw, 1, true)
		dev:performClickableAction(device_commands.Hydraulics, 1, true)
 		dev:performClickableAction(device_commands.Forcetrim, 1, true)
 		dev:performClickableAction(device_commands.APUGEN, 1, true)
 		dev:performClickableAction(device_commands.APUGEN, 1, true)
		enginestage = 8
		--print_message_to_user("AirHot")
		
	elseif birth=="GROUND_HOT" then
		dev:performClickableAction(device_commands.GenSelect, 1, true)
		dev:performClickableAction(device_commands.FuelPumpSw, 1, true)
		dev:performClickableAction(device_commands.Hydraulics, 1, true)
 		dev:performClickableAction(device_commands.Forcetrim, 1, true)
 		dev:performClickableAction(device_commands.APUGEN, 1, true)
 		dev:performClickableAction(device_commands.APUGEN, 1, true)
		--print_message_to_user("GroundHot")
		enginestage = 8
		
    elseif birth=="GROUND_COLD" then
		dev:performClickableAction(device_commands.GenSelect, 0, true)
		dev:performClickableAction(device_commands.FuelPumpSw, 0, true)
		dev:performClickableAction(device_commands.Hydraulics, 0, true)
 		dev:performClickableAction(device_commands.Forcetrim, 0, true)
 		dev:performClickableAction(device_commands.APUGEN, 0, true)
 		dev:performClickableAction(device_commands.APUGEN, 0, true)
		--print_message_to_user("GroundCold")
		enginestage = 0
		
    end
	
sndhost = create_sound_host("COCKPIT_ARMS","HEADPHONES",0,0,0)   
APUGENSND = sndhost:create_sound("Aircrafts/UH1M/Cockpit/APU_noise_In") 
ALARM4 = sndhost:create_sound("Aircrafts/UH1M/Cockpit/ALARM4") 
ALARM = sndhost:create_sound("Aircrafts/UH1M/Cockpit/ALARM") 
ELECTRICON = sndhost:create_sound("Aircrafts/UH1M/Cockpit/ELECTRICON") 
LOWRPMALARM = sndhost:create_sound("Aircrafts/UH1M/Cockpit/LOWRPMALARM")
UH1MStarter = sndhost:create_sound("Aircrafts/UH1M/Cockpit/UH1CStarter")
-- refers to sdef file, and sdef file content refers to sound file, see DCSWorld/Sounds/sdef/_example.sdef
end


function SetCommand(command,value)

if command==device_commands.LOWRPM then
LOWRPMsw = value
end

if command==EFM_commands.generatorSwitch then
MainGenSW = value
end

if command==EFM_commands.starterButton then
startersw = value
		dev:performClickableAction(EFM_commands.starterButton, startersw,true)
		dispatch_action(nil,EFM_commands.starterButton, startersw) 

end

if command==device_commands.Hints then
Hintsw = value
end


end

function starterbutton()
Starterpos = get_cockpit_draw_argument_value(58)
	if enginestage >= 4 and Starterpos == 1 then
		UH1MStarter:play_continue()
		dev:performClickableAction(EFM_commands.starterButton, 1)
		dispatch_action(nil,starterButton1,1) 
		end
		--print_message_to_user("Hold Starter until RPM > 2800 ")
		if Starterpos == 0 then
		dev:performClickableAction(EFM_commands.starterButton, 0)
		dispatch_action(nil,starterButton1,0)
		UH1MStarter:stop()
	end
end


function startup() --ENGINE startup procedure

		GenSelect = get_cockpit_draw_argument_value(89)
		APUgen = get_cockpit_draw_argument_value(20)
		MainGen = get_cockpit_draw_argument_value(16)	
		FuelPump = get_cockpit_draw_argument_value(23)	
		Fuel = get_cockpit_draw_argument_value(5)	
		Hydraulics = get_cockpit_draw_argument_value(85)	
		ForceTrim = get_cockpit_draw_argument_value(84)		
		Starterpos = get_cockpit_draw_argument_value(58)
		Inverter = get_cockpit_draw_argument_value(15)
		Climbrate = get_cockpit_draw_argument_value(103)	
		PowerSelect = get_cockpit_draw_argument_value(89)		
		PwrSwpos = get_cockpit_draw_argument_value(17)
		Throtpos = get_cockpit_draw_argument_value(4)
		RPM = get_cockpit_draw_argument_value(118)
		Collective = get_cockpit_draw_argument_value(3)


	if elec_dc_ok:get()== 0 and GenSelect == 10 and MainGen == 0 and FuelPump == 0 and Fuel == 1 and Hydraulics == 0 and ForceTrim == 0 and Throtpos <= 0 and  RPM >= 0  and APUgen == 0 and Inverter == 0 then
	enginestage = 0
	end
	if enginestage == 0 then
	if elec_dc_ok:get()== 1 and GenSelect == 0.5 and MainGen == 1 then
	enginestage = 1
	end
	end
	if enginestage == 1 then
	if elec_dc_ok:get()== 1 and GenSelect == 0.5 and MainGen == 1 and FuelPump == 1 and Fuel == 0 then
	enginestage = 2
	end
	end
	if enginestage == 2 then
	if elec_dc_ok:get()== 1 and GenSelect == 0.5 and MainGen == 1 and FuelPump == 1 and Fuel == 0 and Hydraulics == 1 and ForceTrim == 1  then
	enginestage = 3
	end
	end
	if enginestage == 3 then
	if elec_dc_ok:get() == 1 and GenSelect == 0.5 and MainGen == 1 and FuelPump == 1 and Fuel == 0 and Hydraulics == 1 and ForceTrim == 1 and Throtpos >= 0.9 then
	enginestage = 4
	end
	end
	if enginestage == 4 then
	if elec_dc_ok:get()== 1 and GenSelect == 0.5 and MainGen == 1 and FuelPump == 1 and Fuel == 0 and Hydraulics == 1 and ForceTrim == 1 and Throtpos <= 0.55 and APUgen == 0.5 then
	enginestage = 5
	end
	end
	if enginestage == 5 then
	if elec_dc_ok:get()== 1 and GenSelect == 0.5 and MainGen == 1 and FuelPump == 1 and Fuel == 0 and Hydraulics == 1 and ForceTrim == 1 and Throtpos <= 0.55 and APUgen == 0.5  and RPM >= 0 then
	enginestage = 6
	end
	end
	if enginestage == 6 then
	if elec_dc_ok:get()== 1 and GenSelect == 1 and MainGen == 1 and FuelPump == 1 and Fuel == 0 and Hydraulics == 1 and ForceTrim == 1 and Throtpos <= 0.55 and RPM >= 0 and APUgen == 1 then
	enginestage = 7
	end
	end
	if enginestage == 7 then
	if elec_dc_ok:get()== 1 and GenSelect == 1 and MainGen == 1 and FuelPump == 1 and Fuel == 0 and Hydraulics == 1 and ForceTrim == 1 and Throtpos <= 0.55 and  RPM >= 0  and APUgen == 1 and Inverter == 1 then
	enginestage = 8
	print_message_to_user("Engine Started")
	end
	end
	end
	






function sounds()
MainGen = get_cockpit_draw_argument_value(16)
APUgen = get_cockpit_draw_argument_value(20)
local NowRalt = sensor_data.getRadarAltitude()


if elec_dc_ok:get()== 1 then
	ELECTRICON:play_continue()
	else 
	ELECTRICON:stop()
end


if APUgen == 0.5 then
	APUGENSND:play_continue()
	else
	APUGENSND:stop()
end

if Emergencyfuelcut == 1 then
	ALARM4:play_continue()
	else
	ALARM4:stop()
end

if elec_dc_ok:get()== 1 then
if NowRalt < 30 and Climbrate <= -0.1 then
	ALARM:play_continue()
	else 
	ALARM:stop()
end
end

if elec_dc_ok:get()==0 then
	ALARM:stop()
	ALARM4:stop()
	APUGENSND:stop()
end



end



function LowRPM()
    local RPM1 = (sensor_data.getEngineLeftRPM()*100)
	--print_message_to_user("RPM  "..sensor_data.getEngineLeftRPM())
	if elec_dc_ok:get()== 1 then
	if RPM1 <= 60 then
	LOWRPMALARM:play_continue()
	end
	if RPM1 > 60 then
	LOWRPMALARM:stop()
	dev:performClickableAction(device_commands.LOWRPM,0, true)
	end
	if LOWRPMsw == 1 then
	LOWRPMALARM:stop()
	end
	end
	end
	
function Hints()
		GenSelect = get_cockpit_draw_argument_value(89)
		APUgen = get_cockpit_draw_argument_value(20)
		MainGen = get_cockpit_draw_argument_value(16)	
		FuelPump = get_cockpit_draw_argument_value(23)	
		Fuel = get_cockpit_draw_argument_value(5)	
		Hydraulics = get_cockpit_draw_argument_value(85)	
		ForceTrim = get_cockpit_draw_argument_value(84)		
		Starterpos = get_cockpit_draw_argument_value(58)
		Inverter = get_cockpit_draw_argument_value(15)
		Climbrate = get_cockpit_draw_argument_value(103)	
		PowerSelect = get_cockpit_draw_argument_value(89)		
		PwrSwpos = get_cockpit_draw_argument_value(17)
		Throtpos = get_cockpit_draw_argument_value(4)
		RPM = get_cockpit_draw_argument_value(118)
		Collective = get_cockpit_draw_argument_value(3)
		Compass = get_cockpit_draw_argument_value(86)

    local RPM1 = (sensor_data.getEngineLeftRPM()*100)
if Hintsw == 1 then
if  elec_dc_ok:get()==0 and GenSelect == 0 and MainGen ==0 and Fuel == 1 and FuelPump ==0  and Hydraulics == 0 and ForceTrim == 0 and Throtpos <= 0 and APUgen == 0 and RPM <= -0.5 and Inverter == 0 and Compass == 0 then
print_message_to_user("1. Turn on Battery ")
end
if  elec_dc_ok:get()==1 and GenSelect == 0 and MainGen ==0 and Fuel == 1 and FuelPump ==0  and Hydraulics == 0 and ForceTrim == 0 and Throtpos <= 0 and APUgen == 0 and RPM <= -0.5 and Inverter == 0 and Compass == 0 then
print_message_to_user("2. Turn VM dial to 'MAIN GEN' (top panel) ")
end
if  elec_dc_ok:get()==1 and GenSelect == 0.5 and MainGen == 0 and Fuel == 1 and FuelPump ==0  and Hydraulics == 0 and ForceTrim == 0 and Throtpos <= 0 and APUgen == 0 and RPM <= -0.5 and Inverter == 0 and Compass == 0 then
print_message_to_user("3. Switch on 'MAIN GEN' switch and put on red cover (top panel). ")
end
if  elec_dc_ok:get()==1 and GenSelect == 0.5 and MainGen == 1 and Fuel == 1 and FuelPump ==0  and Hydraulics == 0 and ForceTrim == 0 and Throtpos <= 0 and APUgen == 0 and RPM <= -0.5 and Inverter == 0 and Compass == 0 then
print_message_to_user("4. Switch on 'Fuel ON/OFF' (centre panel). ")
end
if  elec_dc_ok:get()==1 and GenSelect == 0.5 and MainGen == 1 and Fuel == 0 and FuelPump ==0  and Hydraulics == 0 and ForceTrim == 0 and Throtpos <= 0 and APUgen == 0 and RPM <= -0.5 and Inverter == 0 and Compass == 0 then
print_message_to_user("5. Switch on the 'Fuel PUMP ON/OFF' (centre panel). ")
end
if  elec_dc_ok:get()==1 and GenSelect == 0.5 and MainGen == 1 and Fuel == 0 and FuelPump == 1  and Hydraulics == 0 and ForceTrim == 0 and Throtpos <= 0 and APUgen == 0 and RPM <= -0.5 and Inverter == 0 and Compass == 0 then
print_message_to_user("6. Switch on 'Hydraulics' (centre panel). ")
end
if  elec_dc_ok:get()==1 and GenSelect == 0.5 and MainGen == 1 and Fuel == 0 and FuelPump == 1  and Hydraulics == 1 and ForceTrim == 0 and Throtpos <= 0 and APUgen == 0 and RPM <= -0.5 and Inverter == 0 and Compass == 0 then
print_message_to_user("7. Switch on 'Force trim' (centre panel). ")
end
if  enginestage == 3 and elec_dc_ok:get()==1 and GenSelect == 0.5 and MainGen == 1 and Fuel == 0 and FuelPump == 1  and Hydraulics == 1 and ForceTrim == 1 and Throtpos >= -0.50 and Throtpos <= 0.89 and APUgen == 0 and RPM <= -0.5 and Inverter == 0 and Compass == 0 then
print_message_to_user("8. Throttle fully open (collective twist, PgUp). ")
end
if  elec_dc_ok:get()==1 and GenSelect == 0.5 and MainGen == 1 and Fuel == 0 and FuelPump == 1  and Hydraulics == 1 and ForceTrim == 1 and Throtpos >= 0.9 and APUgen == 0 and RPM <= -0.5 and Inverter == 0 and Compass == 0 then
print_message_to_user("9. Throttle back to idle (collective twist, PgDn). This sets throttle to idle.).). ")
end
if  enginestage == 4 and elec_dc_ok:get()==1 and GenSelect == 0.5 and MainGen == 1 and Fuel == 0 and FuelPump == 1  and Hydraulics == 1 and ForceTrim == 1  and Throtpos <= 0.1 and APUgen == 0 and RPM <= -0.5 and Inverter == 0 and Compass == 0 then
print_message_to_user("10. Gen Starter Switch to 'GEN START' (top panel). ")
end
if  elec_dc_ok:get()==1 and GenSelect == 0.5 and MainGen == 1 and Fuel == 0 and FuelPump == 1  and Hydraulics == 1 and ForceTrim == 1 and Throtpos <= 0.1 and APUgen == 0.5 and RPM <= 0.0 and Inverter == 0 and Compass == 0 then
print_message_to_user("11. Hold 'START' button untill 68% RPM, then let go (main console, right). ")
end
if  elec_dc_ok:get()==1 and GenSelect == 0.5 and MainGen == 1 and Fuel == 0 and FuelPump == 1  and Hydraulics == 1 and ForceTrim == 1 and Throtpos <= 0.1 and APUgen == 0.5 and RPM1 > 60 and Inverter == 0 and Compass == 0 then
print_message_to_user("12. Turn the VM dial to 'STBY GEN' (top panel). ")
end
if  elec_dc_ok:get()==1 and GenSelect == 1 and MainGen == 1 and Fuel == 0 and FuelPump == 1  and Hydraulics == 1 and ForceTrim == 1 and Throtpos <= 0.1 and APUgen == 0.5 and RPM1 > 60 and Inverter == 0 and Compass == 0 then
print_message_to_user("13. StarterGen switch to 'STBY GEN' (top panel). ")
end
if  elec_dc_ok:get()==1 and GenSelect == 1 and MainGen == 1 and Fuel == 0 and FuelPump == 1  and Hydraulics == 1 and ForceTrim == 1 and Throtpos <= 0.1 and APUgen == 1 and RPM1 > 60 and Inverter == 0 and Compass == 0 then
print_message_to_user("14. Switch on Inverter to 'ON Main' (top panel). ")
end
if  elec_dc_ok:get()==1 and GenSelect == 1 and MainGen == 1 and Fuel == 0 and FuelPump == 1  and Hydraulics == 1 and ForceTrim == 1 and Throtpos <= 0.1 and APUgen == 1 and RPM1 > 60 and Inverter == 1 and Compass == 0 then
print_message_to_user("15. Switch on compass (main console). ")
end
if  elec_dc_ok:get()==1 and GenSelect == 1 and MainGen == 1 and Fuel == 0 and FuelPump == 1  and Hydraulics == 1 and ForceTrim == 1 and Throtpos <= 0.1 and APUgen == 1 and RPM1 > 60 and Inverter == 1 and Compass == 1 then
print_message_to_user("16. Throttle to  100% , Fly when ready (collective twist, PgUp). ")
end
end

if Hintsw == -1.0 then
		dev:performClickableAction(device_commands.GenSelect, 0)
		dev:performClickableAction(device_commands.APUGEN, 0)		
		dev:performClickableAction(device_commands.Forcetrim, 0)
		dev:performClickableAction(device_commands.Hydraulics, 0)
		dev:performClickableAction(device_commands.Compass, 0)
		dev:performClickableAction(device_commands.FuelPumpSw, 0)
enginestage = 0
ticker = ticker + 1
if ticker >= 30 then
		dev:performClickableAction(device_commands.Hints, 0)
		ticker = 0
end

end
if Hintsw == 0 then
end

end


function update()
starterbutton()
startup()
LowRPM()
sounds()
Hints()
enginestage_param:set(enginestage)
end


need_to_be_closed = false -- close lua state after initialization