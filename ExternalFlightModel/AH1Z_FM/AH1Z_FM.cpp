#define WIN32_LEAN_AND_MEAN
#include <Windows.h>
#include <algorithm>
#include <cmath>
#include <cstdio>
#include <cstring>

#include "FM/wHumanCustomPhysicsAPI.h"

namespace
{
struct Vec3
{
	double x = 0.0;
	double y = 0.0;
	double z = 0.0;
};

template <typename T>
T clamp(T value, T low, T high)
{
	return std::max(low, std::min(value, high));
}

double approach(double current, double target, double rate, double dt)
{
	const double step = clamp(rate * dt, 0.0, 1.0);
	return current + (target - current) * step;
}

double sq_signed(double value)
{
	return value * std::abs(value);
}

// Source tier A: official NAVAIR/Bell/GE public data.
constexpr double LBS_TO_KG = 0.45359237;
constexpr double FT_TO_M = 0.3048;
constexpr double IN_TO_M = 0.0254;
constexpr double SHP_TO_W = 745.699872;
constexpr double G0 = 9.80665;

constexpr double AH1Z_EMPTY_MASS_KG = 12300.0 * LBS_TO_KG;
constexpr double AH1Z_MAX_GROSS_MASS_KG = 18500.0 * LBS_TO_KG;
constexpr double AH1Z_FUEL_CAPACITY_KG = 412.5 * 6.7 * LBS_TO_KG; // JP-5/JP-8 approximate lb/gal.
constexpr double AH1Z_FUSELAGE_LENGTH_M = (44.0 + 10.0 / 12.0) * FT_TO_M;
constexpr double AH1Z_OVERALL_LENGTH_M = (58.0 + 3.0 / 12.0) * FT_TO_M;
constexpr double AH1Z_HEIGHT_M = (14.0 + 4.0 / 12.0) * FT_TO_M;
constexpr double AH1Z_ENGINE_COUNT = 2.0;
constexpr double AH1Z_ENGINE_INTERMEDIATE_POWER_W = 1800.0 * SHP_TO_W;
constexpr double AH1Z_ENGINE_CONTINUOUS_POWER_W = 1662.0 * SHP_TO_W; // GE T700-401C/-701C max continuous.
constexpr double AH1Z_ENGINE_MAX_POWER_W = 1890.0 * SHP_TO_W; // GE maximum, 10 min.
constexpr double AH1Z_MAX_SPEED_MPS = 200.0 * 0.514444;
constexpr double AH1Z_CRUISE_SPEED_MPS = 139.0 * 0.514444;
constexpr double AH1Z_SIDE_REAR_SPEED_MPS = 45.0 * 0.514444;

// Source tier B: user-supplied MSFS AH-1Z/Viper config, used for unpublished sim geometry.
constexpr double AH1Z_MAIN_ROTOR_RADIUS_M = 24.0 * FT_TO_M;
constexpr double AH1Z_MAIN_ROTOR_RPM = 315.0;
constexpr double AH1Z_TAIL_ROTOR_RADIUS_M = 6.0 * FT_TO_M;
constexpr double AH1Z_TAIL_ROTOR_RPM = 1300.0;
constexpr double AH1Z_MAIN_BETA_MIN_DEG = -2.5;
constexpr double AH1Z_MAIN_BETA_MAX_DEG = 12.0;
constexpr double AH1Z_CYCLIC_MAX_DEG = 7.0;

// Source tier B inertia: MSFS slug-ft^2 values converted to kg-m^2.
constexpr double SLUG_FT2_TO_KGM2 = 1.3558179483314004;
constexpr double AH1Z_IXX_KGM2 = 20938.0 * SLUG_FT2_TO_KGM2; // pitch MOI in source data
constexpr double AH1Z_IZZ_KGM2 = 38638.0 * SLUG_FT2_TO_KGM2; // roll MOI in source data
constexpr double AH1Z_IYY_KGM2 = 59573.0 * SLUG_FT2_TO_KGM2; // yaw MOI in source data

// Calibrated section: public AH-1Z specs do not publish these derivatives.
// They are bounded against public performance targets, not copied from another mod.
constexpr double CONTROL_RESPONSE_ROLL = 3.3;
constexpr double CONTROL_RESPONSE_PITCH = 2.7;
constexpr double CONTROL_RESPONSE_YAW = 1.7;
constexpr double CYCLIC_NEUTRAL_ROLL = 0.55;
constexpr double CYCLIC_NEUTRAL_PITCH = 0.70;
constexpr double RATE_DAMP_ROLL = 2.25;
constexpr double RATE_DAMP_PITCH = 2.10;
constexpr double RATE_DAMP_YAW = 1.55;
constexpr double ATTITUDE_DAMP_FWD = 0.34;
constexpr double FUSELAGE_DRAG_AREA_FRONT_M2 = 1.15;
constexpr double FUSELAGE_DRAG_AREA_SIDE_M2 = 3.10;
constexpr double FUSELAGE_DRAG_AREA_VERTICAL_M2 = 2.20;
constexpr double FUSELAGE_CD = 0.95;
constexpr double ROTOR_SYSTEM_EFFICIENCY = 0.72;
constexpr double HOVER_COLLECTIVE_NORM = 0.56;

constexpr int CMD_PITCH = 2001;
constexpr int CMD_ROLL = 2002;
constexpr int CMD_RUDDER = 2003;
constexpr int CMD_COLLECTIVE = 2004;
constexpr int CMD_AUTOSTART = 3015;
constexpr int CMD_AUTOSTOP = 3016;

Vec3 force_local;
Vec3 moment_local;
Vec3 force_pos;
Vec3 cg;
Vec3 inertia{ AH1Z_IZZ_KGM2, AH1Z_IYY_KGM2, AH1Z_IXX_KGM2 };
Vec3 body_vel;
Vec3 body_wind;
Vec3 body_rates;
Vec3 body_accel;

double mass_kg = AH1Z_MAX_GROSS_MASS_KG;
double fuel_kg = AH1Z_FUEL_CAPACITY_KG;
double rho = 1.225;
double speed_of_sound = 340.294;
double altitude_msl = 0.0;
double surface_h = 0.0;
double surface_h_obj = 0.0;
double yaw_rad = 0.0;
double pitch_rad = 0.0;
double roll_rad = 0.0;
double collective_input = 0.0;
double roll_input = 0.0;
double pitch_input = 0.0;
double pedal_input = 0.0;
double collective = 0.0;
double roll_cmd = 0.0;
double pitch_cmd = 0.0;
double pedal_cmd = 0.0;
double rotor_rpm_norm = 0.0;
double rotor_phase = 0.0;
bool engine_running = false;
bool unlimited_fuel = false;
bool repair_needed = false;

double rotor_area()
{
	return 3.14159265358979323846 * AH1Z_MAIN_ROTOR_RADIUS_M * AH1Z_MAIN_ROTOR_RADIUS_M;
}

double agl_m()
{
	return std::max(0.0, altitude_msl - surface_h_obj);
}

double available_power_w()
{
	if (!engine_running || fuel_kg <= 0.0)
	{
		return 0.0;
	}

	const double continuous = AH1Z_ENGINE_COUNT * AH1Z_ENGINE_CONTINUOUS_POWER_W;
	const double intermediate = AH1Z_ENGINE_COUNT * AH1Z_ENGINE_INTERMEDIATE_POWER_W;
	const double collective_power = continuous + (intermediate - continuous) * clamp(collective, 0.0, 1.0);
	return collective_power * ROTOR_SYSTEM_EFFICIENCY * rotor_rpm_norm;
}

double power_limited_thrust(double requested_thrust)
{
	if (requested_thrust <= 0.0)
	{
		return 0.0;
	}

	const double density = std::max(0.25, rho);
	const double disk = rotor_area();
	const double induced_power = std::pow(requested_thrust, 1.5) / std::sqrt(2.0 * density * disk);
	const double power = available_power_w();
	if (power <= 1.0 || induced_power <= power)
	{
		return requested_thrust;
	}

	return std::pow(power * std::sqrt(2.0 * density * disk), 2.0 / 3.0);
}

void reset_state(bool hot, bool airborne)
{
	engine_running = hot || airborne;
	rotor_rpm_norm = engine_running ? 1.0 : 0.0;
	rotor_phase = 0.0;
	collective_input = 0.0;
	roll_input = 0.0;
	pitch_input = 0.0;
	pedal_input = 0.0;
	collective = 0.0;
	roll_cmd = 0.0;
	pitch_cmd = 0.0;
	pedal_cmd = 0.0;
	force_local = {};
	moment_local = {};
	repair_needed = false;
}

void write_debug_line(double dt, double thrust)
{
	static unsigned long long last_ms = 0;
	const unsigned long long now = GetTickCount64();
	if (now - last_ms < 500)
	{
		return;
	}
	last_ms = now;

	FILE* f = nullptr;
	fopen_s(&f, "C:\\Users\\mac92.LEGION\\Saved Games\\DCS.openbeta\\Logs\\AH1Z_independent_fm.log", "a");
	if (!f)
	{
		return;
	}

	fprintf(f,
		"%llu dt=%.4f mass=%.1f fuel=%.1f rpm=%.3f coll=%.3f pitch=%.3f roll=%.3f pedal=%.3f thrust=%.1f vel=%.1f,%.1f,%.1f rates=%.3f,%.3f,%.3f\n",
		now, dt, mass_kg, fuel_kg, rotor_rpm_norm, collective, pitch_cmd, roll_cmd, pedal_cmd, thrust,
		body_vel.x, body_vel.y, body_vel.z, body_rates.x, body_rates.y, body_rates.z);
	fclose(f);
}
}

extern "C"
{
__declspec(dllexport) void ed_fm_add_local_force(double& x, double& y, double& z, double& pos_x, double& pos_y, double& pos_z)
{
	x = force_local.x;
	y = force_local.y;
	z = force_local.z;
	pos_x = force_pos.x;
	pos_y = force_pos.y;
	pos_z = force_pos.z;
}

__declspec(dllexport) void ed_fm_add_global_force(double& x, double& y, double& z, double& pos_x, double& pos_y, double& pos_z)
{
	x = y = z = pos_x = pos_y = pos_z = 0.0;
}

__declspec(dllexport) bool ed_fm_add_local_force_component(double& x, double& y, double& z, double& pos_x, double& pos_y, double& pos_z)
{
	x = y = z = pos_x = pos_y = pos_z = 0.0;
	return false;
}

__declspec(dllexport) bool ed_fm_add_global_force_component(double& x, double& y, double& z, double& pos_x, double& pos_y, double& pos_z)
{
	x = y = z = pos_x = pos_y = pos_z = 0.0;
	return false;
}

__declspec(dllexport) void ed_fm_add_local_moment(double& x, double& y, double& z)
{
	x = moment_local.x;
	y = moment_local.y;
	z = moment_local.z;
}

__declspec(dllexport) void ed_fm_add_global_moment(double& x, double& y, double& z)
{
	x = y = z = 0.0;
}

__declspec(dllexport) bool ed_fm_add_local_moment_component(double& x, double& y, double& z)
{
	x = y = z = 0.0;
	return false;
}

__declspec(dllexport) bool ed_fm_add_global_moment_component(double& x, double& y, double& z)
{
	x = y = z = 0.0;
	return false;
}

__declspec(dllexport) void ed_fm_simulate(double dt)
{
	const double frame_dt = clamp(dt, 0.001, 0.050);
	const double rpm_target = engine_running ? 1.0 : 0.0;
	rotor_rpm_norm = approach(rotor_rpm_norm, rpm_target, engine_running ? 0.80 : 0.18, frame_dt);
	rotor_phase += (AH1Z_MAIN_ROTOR_RPM / 60.0) * rotor_rpm_norm * frame_dt;
	rotor_phase -= std::floor(rotor_phase);

	collective = approach(collective, collective_input, 6.0, frame_dt);
	roll_cmd = approach(roll_cmd, clamp(roll_input + CYCLIC_NEUTRAL_ROLL, -1.0, 1.0), 8.0, frame_dt);
	pitch_cmd = approach(pitch_cmd, clamp(pitch_input + CYCLIC_NEUTRAL_PITCH, -1.0, 1.0), 8.0, frame_dt);
	pedal_cmd = approach(pedal_cmd, pedal_input, 7.0, frame_dt);

	const double beta_deg = AH1Z_MAIN_BETA_MIN_DEG + (AH1Z_MAIN_BETA_MAX_DEG - AH1Z_MAIN_BETA_MIN_DEG) * collective;
	const double beta_norm = clamp((beta_deg - AH1Z_MAIN_BETA_MIN_DEG) / (AH1Z_MAIN_BETA_MAX_DEG - AH1Z_MAIN_BETA_MIN_DEG), 0.0, 1.0);
	const double hover_ratio = std::max(0.15, HOVER_COLLECTIVE_NORM);
	const double weight = mass_kg * G0;
	const double thrust_requested = weight * (beta_norm / hover_ratio) * rotor_rpm_norm * rotor_rpm_norm;
	const double thrust_ge = agl_m() < AH1Z_MAIN_ROTOR_RADIUS_M
		? thrust_requested * (1.0 + 0.12 * (1.0 - agl_m() / AH1Z_MAIN_ROTOR_RADIUS_M))
		: thrust_requested;
	const double thrust = power_limited_thrust(clamp(thrust_ge, 0.0, weight * 2.5));

	const double pitch_tilt = std::sin((pitch_cmd * AH1Z_CYCLIC_MAX_DEG) * 3.14159265358979323846 / 180.0);
	const double roll_tilt = std::sin((roll_cmd * AH1Z_CYCLIC_MAX_DEG) * 3.14159265358979323846 / 180.0);
	const double vertical_tilt = std::sqrt(std::max(0.70, 1.0 - pitch_tilt * pitch_tilt - roll_tilt * roll_tilt));

	const double vx_air = body_vel.x - body_wind.x;
	const double vy_air = body_vel.y - body_wind.y;
	const double vz_air = body_vel.z - body_wind.z;
	const double qx = 0.5 * rho * sq_signed(vx_air);
	const double qy = 0.5 * rho * sq_signed(vy_air);
	const double qz = 0.5 * rho * sq_signed(vz_air);

	force_local.x = thrust * pitch_tilt - FUSELAGE_CD * FUSELAGE_DRAG_AREA_FRONT_M2 * qx;
	force_local.y = thrust * vertical_tilt - FUSELAGE_CD * FUSELAGE_DRAG_AREA_VERTICAL_M2 * qy;
	force_local.z = thrust * roll_tilt - FUSELAGE_CD * FUSELAGE_DRAG_AREA_SIDE_M2 * qz;
	force_pos = cg;

	const double speed = std::sqrt(vx_air * vx_air + vy_air * vy_air + vz_air * vz_air);
	const double fwd_stability = clamp(speed / AH1Z_CRUISE_SPEED_MPS, 0.0, 1.0);
	moment_local.x = inertia.x * (CONTROL_RESPONSE_ROLL * roll_cmd - RATE_DAMP_ROLL * body_rates.x - ATTITUDE_DAMP_FWD * roll_rad * fwd_stability);
	moment_local.y = inertia.y * (-CONTROL_RESPONSE_YAW * pedal_cmd - RATE_DAMP_YAW * body_rates.y);
	moment_local.z = inertia.z * (CONTROL_RESPONSE_PITCH * pitch_cmd - RATE_DAMP_PITCH * body_rates.z - ATTITUDE_DAMP_FWD * pitch_rad * fwd_stability);

	if (!unlimited_fuel && engine_running)
	{
		const double shp_used = available_power_w() / SHP_TO_W;
		const double fuel_pph = 0.459 * shp_used;
		fuel_kg = std::max(0.0, fuel_kg - fuel_pph * LBS_TO_KG * frame_dt / 3600.0);
		if (fuel_kg <= 0.0)
		{
			engine_running = false;
		}
	}

	write_debug_line(frame_dt, thrust);
}

__declspec(dllexport) void ed_fm_set_surface(double h, double h_obj, unsigned, double, double, double)
{
	surface_h = h;
	surface_h_obj = h_obj;
}

__declspec(dllexport) void ed_fm_set_atmosphere(double h, double, double a, double ro, double, double, double, double)
{
	altitude_msl = h;
	rho = std::max(0.05, ro);
	speed_of_sound = std::max(250.0, a);
}

__declspec(dllexport) void ed_fm_set_clouds_density(const atmo_clouds_and_precipation&)
{
}

__declspec(dllexport) void ed_fm_wind_vector_field_update_request(wind_vector_field& in_out)
{
	in_out.field = nullptr;
	in_out.field_points_count = 0;
}

__declspec(dllexport) void ed_fm_wind_vector_field_done()
{
}

__declspec(dllexport) void ed_fm_set_current_mass_state(double mass, double center_of_mass_x, double center_of_mass_y, double center_of_mass_z, double moment_of_inertia_x, double moment_of_inertia_y, double moment_of_inertia_z)
{
	mass_kg = clamp(mass, AH1Z_EMPTY_MASS_KG, AH1Z_MAX_GROSS_MASS_KG + 2000.0);
	cg = { center_of_mass_x, center_of_mass_y, center_of_mass_z };
	if (moment_of_inertia_x > 1.0) inertia.x = moment_of_inertia_x;
	if (moment_of_inertia_y > 1.0) inertia.y = moment_of_inertia_y;
	if (moment_of_inertia_z > 1.0) inertia.z = moment_of_inertia_z;
}

__declspec(dllexport) void ed_fm_set_current_state(double, double, double, double vx, double vy, double vz, double, double, double, double, double, double, double, double, double, double, double, double, double)
{
	// World velocity is kept only as a fallback; body-axis callback is authoritative for force calculation.
	(void)vx;
	(void)vy;
	(void)vz;
}

__declspec(dllexport) void ed_fm_set_current_state_body_axis(double ax, double ay, double az, double vx, double vy, double vz, double wind_vx, double wind_vy, double wind_vz, double, double, double, double omegax, double omegay, double omegaz, double yaw, double pitch, double roll, double, double)
{
	body_accel = { ax, ay, az };
	body_vel = { vx, vy, vz };
	body_wind = { wind_vx, wind_vy, wind_vz };
	body_rates = { omegax, omegay, omegaz };
	yaw_rad = yaw;
	pitch_rad = pitch;
	roll_rad = roll;
}

__declspec(dllexport) void ed_fm_set_command(int command, float value)
{
	if (value > 1.0f)
	{
		float device_id = 0.0f;
		value = std::modf(value, &device_id) * 8.0f - 2.0f;
	}

	switch (command)
	{
	case CMD_PITCH:
		pitch_input = clamp(-static_cast<double>(value), -1.0, 1.0);
		break;
	case CMD_ROLL:
		roll_input = clamp(static_cast<double>(value), -1.0, 1.0);
		break;
	case CMD_RUDDER:
		pedal_input = clamp(-static_cast<double>(value), -1.0, 1.0);
		break;
	case CMD_COLLECTIVE:
		collective_input = clamp(static_cast<double>(value), 0.0, 1.0);
		break;
	case CMD_AUTOSTART:
		if (value > 0.5f) engine_running = true;
		break;
	case CMD_AUTOSTOP:
		if (value > 0.5f) engine_running = false;
		break;
	default:
		break;
	}
}

__declspec(dllexport) bool ed_fm_change_mass(double& delta_mass, double& x, double& y, double& z, double& moi_x, double& moi_y, double& moi_z)
{
	delta_mass = x = y = z = moi_x = moi_y = moi_z = 0.0;
	return false;
}

__declspec(dllexport) void ed_fm_set_internal_fuel(double fuel)
{
	fuel_kg = clamp(fuel, 0.0, AH1Z_FUEL_CAPACITY_KG);
}

__declspec(dllexport) double ed_fm_get_internal_fuel()
{
	return fuel_kg;
}

__declspec(dllexport) void ed_fm_set_external_fuel(int, double, double, double, double)
{
}

__declspec(dllexport) double ed_fm_get_external_fuel()
{
	return 0.0;
}

__declspec(dllexport) void ed_fm_refueling_add_fuel(double fuel)
{
	fuel_kg = clamp(fuel_kg + fuel, 0.0, AH1Z_FUEL_CAPACITY_KG);
}

__declspec(dllexport) void ed_fm_set_draw_args_v2(float* array, size_t size)
{
	if (!array || size <= 500) return;
	array[9] = static_cast<float>(collective);
	array[11] = static_cast<float>(roll_cmd);
	array[15] = static_cast<float>(-pitch_cmd);
	array[36] = static_cast<float>(rotor_phase);
	array[37] = static_cast<float>(rotor_phase);
	array[40] = static_cast<float>(std::fmod(rotor_phase * (AH1Z_TAIL_ROTOR_RPM / AH1Z_MAIN_ROTOR_RPM), 1.0));
	array[500] = static_cast<float>(-pedal_cmd);
}

__declspec(dllexport) void ed_fm_set_fc3_cockpit_draw_args_v2(float* array, size_t size)
{
	ed_fm_set_draw_args_v2(array, size);
}

__declspec(dllexport) void ed_fm_set_draw_args(EdDrawArgument* array, size_t size)
{
	if (!array || size <= 500) return;
	array[9].f = static_cast<float>(collective);
	array[11].f = static_cast<float>(roll_cmd);
	array[15].f = static_cast<float>(-pitch_cmd);
	array[36].f = static_cast<float>(rotor_phase);
	array[37].f = static_cast<float>(rotor_phase);
	array[40].f = static_cast<float>(std::fmod(rotor_phase * (AH1Z_TAIL_ROTOR_RPM / AH1Z_MAIN_ROTOR_RPM), 1.0));
	array[500].f = static_cast<float>(-pedal_cmd);
}

__declspec(dllexport) void ed_fm_set_fc3_cockpit_draw_args(EdDrawArgument* array, size_t size)
{
	ed_fm_set_draw_args(array, size);
}

__declspec(dllexport) double ed_fm_get_shake_amplitude()
{
	return 0.0;
}

__declspec(dllexport) void ed_fm_configure(const char*)
{
}

__declspec(dllexport) void ed_fm_release()
{
	reset_state(false, false);
}

__declspec(dllexport) double ed_fm_get_param(unsigned param_enum)
{
	switch (param_enum)
	{
	case ED_FM_PROPELLER_0_RPM:
		return AH1Z_MAIN_ROTOR_RPM * rotor_rpm_norm;
	case ED_FM_PROPELLER_0_PITCH:
	case ED_FM_PROPELLER_0_TILT:
	case ED_FM_PROPELLER_0_INTEGRITY_FACTOR:
		return 1.0;
	case ED_FM_ENGINE_1_RPM:
	case ED_FM_ENGINE_1_RELATED_RPM:
	case ED_FM_ENGINE_1_CORE_RPM:
	case ED_FM_ENGINE_1_CORE_RELATED_RPM:
		return rotor_rpm_norm;
	case ED_FM_ENGINE_1_THRUST:
	case ED_FM_ENGINE_1_RELATED_THRUST:
	case ED_FM_ENGINE_1_CORE_THRUST:
	case ED_FM_ENGINE_1_CORE_RELATED_THRUST:
		return available_power_w();
	case ED_FM_ENGINE_1_TEMPERATURE:
		return engine_running ? 620.0 : 20.0;
	case ED_FM_ENGINE_1_FUEL_FLOW:
		return engine_running ? 0.459 * (available_power_w() / SHP_TO_W) : 0.0;
	case ED_FM_FUEL_INTERNAL_FUEL:
	case ED_FM_FUEL_TOTAL_FUEL:
		return fuel_kg;
	case ED_FM_STICK_FORCE_CENTRAL_PITCH:
	case ED_FM_STICK_FORCE_CENTRAL_ROLL:
		return 0.0;
	case ED_FM_STICK_FORCE_FACTOR_PITCH:
	case ED_FM_STICK_FORCE_FACTOR_ROLL:
		return 1.0;
	case ED_FM_FC3_RUDDER_PEDALS:
		return pedal_cmd;
	case ED_FM_SUSPENSION_0_GEAR_POST_STATE:
	case ED_FM_SUSPENSION_1_GEAR_POST_STATE:
	case ED_FM_SUSPENSION_2_GEAR_POST_STATE:
		return 1.0;
	default:
		return 0.0;
	}
}

__declspec(dllexport) void ed_fm_cold_start()
{
	reset_state(false, false);
}

__declspec(dllexport) void ed_fm_hot_start()
{
	reset_state(true, false);
}

__declspec(dllexport) void ed_fm_hot_start_in_air()
{
	reset_state(true, true);
}

__declspec(dllexport) bool ed_fm_make_balance(double&, double&, double&, double&, double&, double&, double&, double&, double&, double&, double&, double&, double&, double&, double&)
{
	return false;
}

__declspec(dllexport) bool ed_fm_enable_debug_info()
{
	return false;
}

__declspec(dllexport) size_t ed_fm_debug_watch(int, char* buffer, size_t maxlen)
{
	if (!buffer || maxlen == 0) return 0;
	return static_cast<size_t>(sprintf_s(buffer, maxlen, "AH1Z independent FM rpm %.2f coll %.2f fuel %.0f", rotor_rpm_norm, collective, fuel_kg));
}

__declspec(dllexport) void ed_fm_set_plugin_data_install_path(const char*)
{
}

__declspec(dllexport) void ed_fm_on_planned_failure(const char*)
{
}

__declspec(dllexport) void ed_fm_on_damage(int, double element_integrity_factor)
{
	if (element_integrity_factor < 0.35)
	{
		repair_needed = true;
	}
}

__declspec(dllexport) void ed_fm_repair()
{
	repair_needed = false;
}

__declspec(dllexport) bool ed_fm_need_to_be_repaired()
{
	return repair_needed;
}

__declspec(dllexport) void ed_fm_set_immortal(bool)
{
}

__declspec(dllexport) void ed_fm_unlimited_fuel(bool value)
{
	unlimited_fuel = value;
}

__declspec(dllexport) void ed_fm_set_easy_flight(bool)
{
}

__declspec(dllexport) void ed_fm_set_property_numeric(const char*, float)
{
}

__declspec(dllexport) void ed_fm_set_property_string(const char*, const char*)
{
}

__declspec(dllexport) bool ed_fm_pop_simulation_event(ed_fm_simulation_event&)
{
	return false;
}

__declspec(dllexport) bool ed_fm_push_simulation_event(const ed_fm_simulation_event&)
{
	return false;
}

__declspec(dllexport) void ed_fm_suspension_feedback(int, const ed_fm_suspension_info*)
{
}

__declspec(dllexport) bool ed_fm_LERX_vortex_update(unsigned, LERX_vortex&)
{
	return false;
}
}

BOOL APIENTRY DllMain(HMODULE, DWORD, LPVOID)
{
	return TRUE;
}
