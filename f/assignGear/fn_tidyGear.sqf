// Removes redundant items according to the mission time.
// NVG/Flares during daytime, some smokes during nighttime etc...
if !hasInterface exitWith {};

waitUntil{!isNil "f_var_setParams"};

if (isNil "f_param_timeOfDay") exitWith { ["fn_tidyGear.sqf", "No TOD Parameter set - Exiting", "INFO"] call f_fnc_logIssue };

waitUntil{!isNil "f_var_timeOfDay" || time > 0};

["fn_tidyGear.sqf", format["Tidy Gear Running - Time of Day: %1", f_var_timeOfDay], "INFO"] call f_fnc_logIssue;

params ["_unit","_forced"];

private ["_sunsetSunrise","_sunrise","_sunset","_itemsNVG", "_chem", "_flare", "_smoke", "_isNightTime", "_removeMag", "_removeItem","_itemCount","_tempArr"];

// Work out first/last light
_sunsetSunrise = date call BIS_fnc_sunriseSunsetTime;
_sunrise = 4;
_sunset = 19;

// Ensure dawn and dusk don't happen in the dark during different seasons and at different latitudes
if !(_sunsetSunrise in [[-1,0],[0,-1]]) then {
	_sunrise = floor (_sunsetSunrise select 0);
	_sunset = floor (_sunsetSunrise select 1);
};

// If we're in-game and the param isn't set get the in-game hour.
if (isNil "f_var_timeOfDay") then {
	f_var_timeOfDay = floor daytime;
};

// Skip script on dusk, dawn or 1hr before dusk as light will change.
if (isNil "_forced") then {
	if (f_var_timeOfDay == _sunrise || f_var_timeOfDay == _sunset || f_var_timeOfDay == (_sunset - 1)) exitWith {};
	_isNightTime = (floor daytime < _sunrise || floor daytime > _sunset);
} else {
	_isNightTime = _forced;
};

// Items to remove at daytime.
_itemsNVG = [
	"ACE_IR_Strobe_Item",
	"ACE_Flashlight_Xl50",
	"ACE_Flashlight_KSF1",
	"ACE_Flashlight_MX991",
	"NVGoggles_OPFOR",
	"NVGoggles",
	"NVGoggles_INDEP",
	"NVGoggles_tna_F",
	"O_NVGoggles_ghex_F",
	"O_NVGoggles_hex_F",
	"O_NVGoggles_urb_F",
	"NVGogglesB_blk_F",
	"NVGogglesB_grn_F",
	"NVGogglesB_gry_F",
	"ACE_NVG_Gen1",
	"ACE_NVG_Gen2",
	"ACE_NVG_Gen3",
	"ACE_NVG_Gen4",
	"ACE_NVG_Wide",
	"UK3CB_BAF_HMNVS",
	"rhsusf_ANPVS_15",
	"rhsusf_ANPVS_14",
	"rhs_1PN138"
];

// Chemlights etc.
_chem = [
	"Chemlight_green",
	"Chemlight_red",
	"Chemlight_yellow",
	"Chemlight_blue",
	"rhs_mag_nspn_yellow",
	"rhs_mag_nspn_green",
	"rhs_mag_nspn_red",
	"B_IR_Grenade",
	"O_IR_Grenade",
	"I_IR_Grenade",
	"ACE_HandFlare_White",
	"ACE_HandFlare_Red",
	"ACE_HandFlare_Green",
	"ACE_HandFlare_Yellow",
	"ACE_Chemlight_HiWhite",
	"ACE_Chemlight_HiYellow",
	"ACE_Chemlight_HiRed",
	"ACE_Chemlight_HiOrange",
	"ACE_Chemlight_IR",
	"ACE_Chemlight_Orange",
	"ACE_Chemlight_White",
	"FlareWhite_F",
	"FlareGreen_F",
	"FlareRed_F",
	"FlareYellow_F"
];

// UGL Flares
_flare = [
	"UGL_FlareWhite_F",
	"3Rnd_UGL_FlareWhite_F",
	"UGL_FlareGreen_F",
	"3Rnd_UGL_FlareGreen_F",
	"UGL_FlareRed_F",
	"3Rnd_UGL_FlareRed_F",
	"UGL_FlareYellow_F",
	"3Rnd_UGL_FlareYellow_F",
	"UGL_FlareCIR_F",
	"3Rnd_UGL_FlareCIR_F",
	"rhs_VG40OP_white",
	"rhs_VG40OP_red",
	"rhs_VG40OP_green",
	"rhs_mag_M585_white",
	"rhs_mag_m661_green",
	"rhs_mag_m662_red"
];

// Basic smoke
_smoke = [
	"SmokeShell",
	"1Rnd_Smoke_Grenade_shell",
	"3Rnd_Smoke_Grenade_shell",
	"rhs_mag_m714_White",
	"rhs_mag_rdg2_white",
	"rhs_GRD40_White"
];

// Collate the item types
_removeMag = if (_isNightTime) then {_smoke} else {_chem + _flare};
_removeItem = if (_isNightTime) then {[]} else {_itemsNVG};

//diag_log text format["[F3] TIDYGEAR (fn_tidyGear.sqf): Unit: %3 - Night: %1 (%2)",_isNightTime,f_var_timeOfDay,_unit];

_itemCount = 0;

{
	_x params ["_checkList", "_cfg", ["_gearList",[]]];
	
	private _temp = [];
	// Validate array
	{_temp pushBack (configName (configFile >> _cfg >> _x))} forEach _checkList;
	
	_temp = _temp - [""]; // Remove invalid classes.
	
	//diag_log text format["[F3] DEBUG (fn_tidyGear.sqf): List is: %1",_temp];
	
	{
		if (_cfg == "CfgMagazines" && {_x in _temp}) then {
			_unit removeMagazine _x;
			_itemCount = _itemCount + 1;
			//diag_log text format["[F3] DEBUG (fn_tidyGear.sqf): Removing item %1 for %2",_x,_unit];
		};
		if (_cfg == "CfgWeapons" && {_x in _temp}) then {
			_unit removeItem _x;
			_unit unlinkItem _x;
			_itemCount = _itemCount + 1;
			//diag_log text format["[F3] DEBUG (fn_tidyGear.sqf): Removing item %1 for %2",_x,_unit];
		};
	} forEach _gearList;
} forEach [[_removeMag,"CfgMagazines",(magazines _unit)],[_removeItem,"CfgWeapons",(assignedItems _unit) + (items _unit)]];

if !(isNil "_forced") then {
	if (_forced) then {
		systemChat format["[Gear] Switched to Night Operation, %1 items were removed.",_itemCount];
	} else {
		systemChat format["[Gear] Switched to Daytime Operation, %1 items were removed.",_itemCount];
	};
};

["fn_tidyGear.sqf", format["Gear switched, removed %2 items", _itemCount], "INFO"] call f_fnc_logIssue;