dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

dofile(LockOn_Options.script_path.."utils.lua")

local dev 	    = GetSelf()

currtime_hours = get_param_handle("CURRTIME_HOURS")
currtime_mins = get_param_handle("CURRTIME_MINS")
currtime_secs = get_param_handle("CURRTIME_SECS")







local second_handle_wma = WMA_wrap(0.4, 0, 0, 60)


local update_time_step = 0.1 --update will be called 10 times per second

make_default_activity(update_time_step)

function update()
    local abstime = get_absolute_model_time()
    local hours12 = abstime/3600.0
    if hours12>12.0 then
        hours12 = hours12 - 12.0
    end
    currtime_hours:set(hours12)
    local int,frac = math.modf(hours12)
    currtime_mins:set(frac*60)
    int,frac_s = math.modf(frac*60.0)
	currtime_secs:set(second_handle_wma:get_WMA_wrap(math.floor(frac_s*60)))
	

end

function post_initialize()
    local abstime = get_absolute_model_time()
    local hours12 = abstime/3600.0
    if hours12>12.0 then
        hours12 = hours12 - 12.0
    end
    currtime_hours:set(hours12)
    local int,frac = math.modf(hours12)
    currtime_mins:set(frac*60)
    int,frac_s = math.modf(frac*60.0)
    second_handle_wma:set_current_val(math.floor(frac_s*60))
    
end


function SetCommand(command,value)

end



need_to_be_closed = false -- close lua state after initialization
