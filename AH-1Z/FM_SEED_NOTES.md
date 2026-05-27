# AH-1Z FM Seed Notes

These are the seed values currently used for the clean AH-1Z DCS mod. They are good enough for a first DCS aircraft table and UH-1M-style control bring-up, but they are not a tuned EFM.

## Public AH-1Z Targets

- Rotor diameter: 48 ft / 14.6 m
- Main rotor: 4 blades
- Length, rotors turning: 58 ft 3 in / 17.75 m
- Height: 14 ft 4 in / 4.37 m
- Empty weight: 12,300 lb / 5,579 kg
- Max takeoff weight: 18,500 lb / 8,391 kg
- Useful load: 5,764 lb / 2,614 kg
- Fuel capacity: 412.5 gal / about 1,254 kg Jet-A
- Engines: 2 x T700-GE-401C, 1,800 shp each
- Max speed target: 200 KIAS / 370 km/h
- Cruise target: 139 KTAS / 257 km/h
- Climb target: 2,790 ft/min / 14.2 m/s
- Max range target: 310 nm / 574 km
- Hover ceiling OGE target: 3,000 ft / 914 m
- Service ceiling target: 20,000+ ft
- Rotor RPM target: 315 to 324 RPM
- Limit load factor target: -0.5 to +2.5 g
- Sideward/rearward flight target: 45 KIAS / 83 km/h
- Combat radius target: 131 nm / 243 km

## KwikFlight/MSFS Config Values Used

Source package:
`C:\Users\mac92.LEGION\AppData\Local\Packages\Microsoft.FlightSimulator_8wekyb3d8bbwe\LocalCache\Packages\Community\Community2024\kwikflight-aircraft-striker\SimObjects\Airplanes\viper\common\config`

- `flight_model.cfg`
  - `max_gross_weight = 18500`
  - `empty_weight = 12300`
  - `empty_weight_pitch_MOI = 20938 slug ft^2`
  - `empty_weight_roll_MOI = 38638 slug ft^2`
  - `empty_weight_yaw_MOI = 59573 slug ft^2`
  - `cruise_speed = 150 KTAS`
  - `reference_frontal_area = 10 sq ft`
  - main rotor radius `24 ft`, rated RPM `315`, blades `4`, blade aspect ratio `18`
  - tail rotor position `-37.5,-2,1.35 ft`, radius `6 ft`, rated RPM `1300`, blades `4`
  - fuel tanks total `410 gal`; public Bell capacity is `412.5 gal`, so the DCS table uses about `1254 kg`
- `engines.cfg`
  - `rated_shaft_hp = 1800`
  - `PowerSpecificFuelConsumption = 0.7`
- `aircraft.cfg`
  - `ui_certified_ceiling = 20000`
  - `ui_max_range = 257 nm`; public Bell max range is `310 nm`, so the DCS table uses `310 nm`
  - `ui_autonomy = 3 hr`
  - `ui_fuel_burn_rate = 1500 lb/hr`

## Tunable Items

- `nose_gear_pos` and `main_gear_pos` are skid/contact approximations. If the aircraft still rests on the fuselage, lower the gear Y values.
- `rotor_pos` and `tail_pos` came from the MSFS config and may need visual alignment against the exported EDM origin.
- `fuselage_Cxa0`, `fuselage_Cxa90`, `tail_fin_area`, and `tail_stab_area` are still tuning values.
- MSFS rotor blade lift/stall coefficients are recorded in the config but not directly portable into this simple DCS aircraft table.

## Bell/NAVAIR Official Targets Applied

Live AH-1Z.lua has been reset to the public Bell/NAVAIR AH-1Z figures:

- V_max = 200 * knot_to_kmh
- V_max_cruise = 139 * knot_to_kmh
- V_sideward_rearward = 45 * knot_to_kmh
- combat_radius = 131 * nm_to_km
- ange = 310 * nm_to_km
- Vy_max = 14.2
- Ny_max = 2.5
- M_payload_max = 2614
- M_fuel_max = 1254
- engine power fields use 1800 * shp_to_kw per T700-GE-401C engine

Skid/contact geometry was intentionally not changed in this pass.
