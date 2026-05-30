# AH-1Z Independent EFM Data Sources

This DLL is intentionally independent from the UH-1M, CH53, AH-64, and other mod flight-model source trees.

## Source Tier A: Public Official Data

- NAVAIR AH-1Z Viper product page:
  - Empty weight: 12,300 lb
  - Max gross weight: 18,500 lb
  - Fuselage length: 44 ft 10 in
  - Overall length: 58 ft 3 in
  - Height: 14 ft 4 in
  - Engines: two General Electric T700-GE-401C turboshafts

- Bell AH-1Z fact sheet:
  - Max speed: 200 KIAS
  - Cruise speed: 139 KTAS
  - Sideward/rearward flight: 45 KIAS
  - Combat radius: 131 nm
  - Maneuver limits: -0.5 to +2.5 g
  - Max gross weight: 18,500 lb
  - Useful load: 5,764 lb
  - Fuel capacity: 412.5 gal
  - Engine output: 1,800 shp each

- GE T700-401C/-701C data sheet:
  - Intermediate rating: 1,800 shp
  - Maximum continuous rating: 1,662 shp
  - Maximum rating: 1,890 shp
  - Contingency rating: 1,940 shp
  - Specific fuel consumption near max continuous/intermediate: about 0.459-0.460 lb/shp-hr

## Source Tier B: User-Supplied Viper Config Data

Used where public official sources do not publish sim-ready values:

- Main rotor radius: 24 ft
- Main rotor rated RPM: 315
- Tail rotor radius: 6 ft
- Tail rotor rated RPM: 1300
- Main rotor blade pitch range: -2.5 to +12.0 degrees
- Cyclic disk limit: 7 degrees
- Empty weight inertia values: 20,938 / 38,638 / 59,573 slug-ft^2

## Calibrated Values

The following are not claimed as published AH-1Z data:

- Pitch, roll, yaw control response
- Rate damping
- Fuselage drag areas and drag coefficient
- Rotor system efficiency
- Hover collective normalization

These are set inside the "Calibrated section" of `AH1Z_FM.cpp` and should be tuned only against observed behavior and the public performance targets above.
