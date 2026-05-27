dofile(LockOn_Options.script_path.."utils.lua")
local dev = GetSelf()
local update_time_step = 0.05   --0.05
make_default_activity(update_time_step) -- enables call to update

local sensor_data = get_base_data()
local oil_pressure_target = 0
local oil_pressure = get_param_handle("OIL_PRESSURE")
local hydraulics1  = get_param_handle("HYDRAULICS")
local engine_heat_stress = get_param_handle("ENGINE_HEAT_STRESS")
local rpm1 = get_param_handle("RPM")
local temp = 0





function post_initialize()
end

local oil_pressure_psi=WMA(0.15,0)
local life_s_accum = 0


function SetCommand(command,value) 

end




function update_oil_pressure()


    local rpm = sensor_data.getEngineLeftRPM() * 100
    
    local oil_pressure_nominal
    if rpm > 1 then
        if rpm < 55 then
            oil_pressure_target=30
        else
            -- oil pressure 40-45 based on RPM
            oil_pressure_target = 15 * (rpm-55)/40 + 30
        end

        local stress = engine_heat_stress:get()
        oil_pressure_target = oil_pressure_target + stress * (40/100) -- up to 40psi oil pressure due to heat buildup
    else
        oil_pressure_target=0
    end
	
    if rpm > 95 then
        life_s_accum = life_s_accum + (95 / (28563 * math.exp(-0.049 * (rpm-60))))
    else
        life_s_accum = life_s_accum + (rpm-95)/100
    end

    if life_s_accum <= 0 then
        life_s_accum = 0
    end

    engine_heat_stress:set(life_s_accum)
	oil_pressure:set(oil_pressure_psi:get_WMA(oil_pressure_target))
	rpm1:set(rpm)
	
	hydraulicsSW = get_cockpit_draw_argument_value(85)
	if hydraulicsSW == 1 then
	hydraulics1:set((oil_pressure_psi:get_WMA(oil_pressure_target))*(rpm/100))
	end
	if hydraulicsSW == 0 then
	hydraulics1:set(0)
	end
end



function update()
update_oil_pressure()

end
	
	
need_to_be_closed = false -- close lua state after initialization