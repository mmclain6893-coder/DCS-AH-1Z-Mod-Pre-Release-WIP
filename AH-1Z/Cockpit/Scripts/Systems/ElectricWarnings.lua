dofile(LockOn_Options.script_path.."command_defs.lua")


local ElectricWarnings = GetSelf()
local update_rate = 0.01
make_default_activity(update_rate)
elec_dc_ok  = get_param_handle("DC_POWER_AVAIL")
local sensor_data = get_base_data()

ElectricWarnings:listen_command(device_commands.FuelShutoffSw)
ElectricWarnings:listen_command(Keys.BattSwitch)
ElectricWarnings:listen_command(EFM_commands.generatorSwitch) --	generatorSwitch 	= 3004,
ElectricWarnings:listen_command(EFM_commands.inverterSwitch) --	inverterSwitch 		= 3005,

local elecwarn1 = -0.1 --
local elecwarn2 = -0.1 --
ELECWARN1 = get_param_handle("ELECWARN1")
ELECWARN2 = get_param_handle("ELECWARN2")
VOLTAGE1 = get_param_handle("VOLTAGE1")

local voltage1 = 0


function SetCommand(command,value)

Emergencyfuelcut = get_cockpit_draw_argument_value(18)

end


function post_initialize()


end





function update_Elecwarn() --this partly works...... there are too many combinations..... good for now.... needs work

	local rpm = sensor_data.getEngineLeftRPM() * 100
	local Power1 = get_cockpit_draw_argument_value(17)
	local Generator1 = get_cockpit_draw_argument_value(16)
	local Inverter1 = get_cockpit_draw_argument_value(15)

if Power1  == 1 and Generator1 == 1 and rpm > 60 then
	voltage1 = voltage1 + 1
	elecwarn1 = 1 
	elecwarn2 = 0
--	print_message_to_user("Battery Charging VOLTAGE  "..voltage1)
elseif voltage1 > 3000 then voltage1 = 3000
end

if Power1 == 0 then
	elecwarn1 = 0
	--print_message_to_user("Battery Off VOLTAGE  "..voltage1)
end

if 	Power1  == 1 and Generator1 == 0 then
	elecwarn2 = elecwarn2 + 0.01
	voltage1 = voltage1 - 0.1
	elecwarn1 = 0
	--print_message_to_user("Discharging VOLTAGE  "..voltage1) -- 3000 cycles flat battery ~5mins
elseif voltage1 < 1500 then voltage1 = 1500


end

	if elecwarn2 >= 1 
	then elecwarn2 = 0
end
if elec_dc_ok:get()==0 then
	voltage1 = 0
end


end


function update()



update_Elecwarn()
ELECWARN1:set(elecwarn1)
ELECWARN2:set(elecwarn2)
VOLTAGE1:set(voltage1)

end






need_to_be_closed = false -- close lua state after initialization

