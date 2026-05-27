local count = 0
local function counter()
	count = count + 1
	return count
end
-------DEVICE ID-------
devices = {}
devices["ELECTRIC_SYSTEM"]	= counter()
devices["WEAPON_SYSTEM"]	= counter()
devices["RWR"] 				= counter()
devices["EXTLIGHTS"]		= counter()
--devices["EXTANIM"]			= counter()
devices["AVIONICS"]			= counter()
devices["DIGITAL_CLOCK"]	= counter()
devices["EFM_HELPER"]		= counter()
devices["FCS"]				= counter()
devices["HELMET_DEVICE"] 	= counter() 
devices["OILPRESSURE"]		= counter() 
devices["CLOCK"]			= counter() 
devices["WINCH"]			= counter() 
devices["SYSTEM"]			= counter()
--devices["GEAR"]				= counter()  
devices["WIPERS"]			= counter()  
devices["GUNNERS"]			= counter()  
devices["OPENTAIL"]			= counter()  
devices["REFUELPROBE"]		= counter()
devices["RAMP"]				= counter()
devices["ELECWARN"]			= counter()
devices["COCKSHAKE"] 		= counter()
devices["OPENDOOR"] 		= counter()
devices["TRIM"] 			= counter()
--devices["BRAKES"] 			= counter()
devices["RADIO"] 			= counter()
--devices["STEERING"] 		= counter()
devices["AUTOPILOT"] 		= counter()
devices["ENGINE"]        	= counter()
devices["MPEE"]  	      	= counter()
devices["INTERCOM"]        	= counter()
devices["UHF_RADIO"]  	   	= counter()
devices["COUNTERMEASURES"]  = counter()
devices["FUEL"] 			= counter()
--devices["HELPER"] 			= counter()
devices["AH1Z_EFM_BRIDGE"] = counter()

devices["WINDVANE"] = counter()
devices["PILOT_MFD"] = counter()


