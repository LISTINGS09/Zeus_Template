// F3 - Folk ARPS Assign Gear Script (Server-side)
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

// DECLARE VARIABLES AND FUNCTIONS
params[["_typeofUnit","",[""]],["_unit", player],["_side", side group (_this#1)],["_skipCheck",false,[false]]];

// This is kept in incase older version of gear scripts are running...
if (isNil "f_param_backpacks") then {f_param_backpacks = 1};

// DECIDE IF THE SCRIPT SHOULD RUN
// Depending on locality the script decides if it should run
if (!local _unit) exitWith {};

if (isNil "f_fnc_addBackpack") then { f_fnc_addBackpack = compileFinal preprocessFileLineNumbers "f\assignGear\fn_addBackpack.sqf"; };
if (isNil "f_fnc_addWeapon") then { f_fnc_addWeapon = compileFinal preprocessFileLineNumbers "f\assignGear\fn_addWeapon.sqf"; };
if (isNil "f_fnc_arrayCheck") then { f_fnc_arrayCheck = compileFinal preprocessFileLineNumbers "f\assignGear\fn_arrayCheck.sqf"; };
if (isNil "f_fnc_compatibleItems") then { f_fnc_compatibleItems = compileFinal preprocessFileLineNumbers "f\assignGear\fn_compatibleItems.sqf"; };
if (isNil "f_fnc_tidyGear") then { f_fnc_tidyGear = compileFinal preprocessFileLineNumbers "f\assignGear\fn_tidyGear.sqf"; };

// DETECT unit FACTION
if (_side == sideUnknown) then { _side = [_unit, true] call BIS_fnc_objectSide };

_typeofUnit = toLower _typeofUnit;

// Get side string
if (_side isEqualType west) then { _side = format["%1",_side] };

// DECLARE VARIABLES AND FUNCTIONS 2
// Used by the faction-specific scripts
private ["_attach1","_attach2","_flashHider","_silencer1","_silencer2","_silencer3","_scope1","_scope2","_scope3","_scope4","_bipod1","_bipod2","_attachments","_attach_co","_attach_fl","_attach_fl","_attach_mg","_attach_dm","_attach_sn","_hg_silencer1","_hg_scope1","_hg_attachments","_rifle","_riflemag","_riflemag_tr","_carbine","_carbinemag","_carbinemag_tr","_smg","_smgmag","_smgmag_tr","_diverWep","_diverMag1","_diverMag2","_glrifle","_glriflemag","_glriflemag_tr","_glmag","_glsmoke","_glsmokealt1","_glsmokealt2","_glflare","_glflarealt","_glflareyellow","_glflaregreen","_pistol","_pistolmag","_grenade","_grenadealt","_smokegrenade","_smokegrenadealt","_firstaid","_medkit","_nvg","_uavterminal","_chem","_chemalt","_chemyellow","_chemblue","_bagsmall","_bagmedium","_baglarge","_bagmediumdiver","_baguav","_baghmgg","_baghmgag","_baghatg","_baghatag","_bagmtrg","_bagmtrag","_baghsamg","_baghsamag","_AR","_ARmag","_ARmag_tr","_MMG","_MMGmag","_MMGmag_tr","_Tracer","_DMrifle","_DMriflemag","_RAT","_RATmag","_MAT","_MATmag1","_MATmag2","_HAT","_HATmag1","_HATmag2","_SAM","_SAMmag","_SNrifle","_SNrifleMag","_ATmine","_satchel","_APmine1","_APmine2","_light","_heavy","_diver","_pilot","_crew","_ghillie","_specOp","_baseUniform","_baseHelmet","_baseGlasses","_lightRig","_mediumRig","_heavyRig","_diverUniform","_diverHelmet","_diverRig","_diverGlasses","_pilotUniform","_pilotHelmet","_pilotRig","_pilotGlasses","_crewUniform","_crewHelmet","_crewRig","_crewGlasses","_ghillieUniform","_ghillieHelmet","_ghillieRig","_ghillieGlasses","_sfuniform","_sfhelmet","_sfRig","_sfGlasses","_typeofUnit","_unit","_isMan","_backpack","_typeofBackPack","_loadout","_COrifle","_grenadealt","_DCrifle","_FTLrifle","_armag","_RATmag","_typeofUnit"];

_isMan = _unit isKindOf "CAManBase";	// We check if we're dealing with a soldier or a vehicle
if (_typeofUnit == "") then {
	if (_isMan) then { // Try and work out the units type.
		_unitClasses = [
			["B_soldier_F"	,	"r"		],
			["I_soldier_F"	,	"r"		],
			["O_soldier_F"	,	"r"		],
			["B_G_soldier_F",	"r"		],
			["I_G_soldier_F",	"r"		],
			["O_G_soldier_F",	"r"		],
			["_unarmed_",		"empty"	],
			["_officer_"	,	"co"	],
			["_colonel_"	,	"co"	],
			["_sl_"			,	"dc"	],
			["_tl_"			,	"ftl"	],
			["_lite_"		,	"car"	],
			["_ar_"			,	"ar"	],
			["_aar_"		,	"aar"	],
			["_a_"			,	"aar"	],
			["_lat_"		,	"rat"	],
			["_lat2_"		,	"rat"	],
			["_medic_"		,	"m"		],
			["_gl_"			,	"gren"	],
			["_exp_"		,	"engm"	],
			["_mine_"		,	"engm"	],
			["_engineer_"	,	"eng"	],
			["_mg_"			,	"mmgg"	],
			["_heavygunner_",	"mmgg"	],
			["_amg_"		,	"mmgag"	],
			["_at_"			,	"matg"	],
			["_aat_"		,	"matag"	],
			["_hat_"		,	"hatg"	],
			["_ahat_"		,	"hatag"	],
			["_aa_"			,	"msamg"	],
			["_aaa_"		,	"msamag"],
			["_amort_"		,	"mtrag" ],
			["_mort_"		,	"mtrg"  ],
			["_uav_"		,	"uav"	],
			["_ugv_"		,	"uav"	],
			["_m_"			,	"dm"	],
			["_sharpshooter_",	"dm"	],
			["_sniper_"		,	"sn"	],
			["_spotter_"	,	"sp"	],
			["_diver_"		,	"div"	],
			["_repair_"		,	"vd"	],
			["_crew_"		,	"vd"	],
			["_helipilot_"	,	"pp"	],
			["_helicrew_"	,	"pc"	],
			["_pilot_"		,	"pp"	],
			["_cbrn_"		,	"cbrn"	],
			["_radio"		,	"ro"	],
			["t_1_"			,	"m"		],
			["t_2_"			,	"rat"	],
			["t_3_"			,	"ar"	],
			["t_4_"			,	"ftl"	],
			["t_5_"			,	"r"		],
			["t_6_"			,	"gren"	],
			["t_7_"			,	"car"	],
			["t_8_"			,	"engm"	],
			["p_1_"			,	"r"		],
			["p_2_"			,	"ftl"	],
			["p_3_"			,	"m"		],
			["p_4_"			,	"ar"	],
			["p_5_"			,	"rat"	],
			["p_6_"			,	"gren"	],
			["p_7_"			,	"car"	],
			["p_8_"			,	"eng"	]
		];
		
		_known = false;
		{
			_known = [toLower (_x#0),toLower (typeOf _unit)] call BIS_fnc_inString;

			// If the unit's class-name corresponds to a class in the assignment array, set it's type
			if (_known) exitWith {
				_typeofUnit = _x#1;
			};
		} forEach _unitClasses;
		
		// Promote crew if they are a leader.
		if (_typeofUnit == "vd" && leader _unit == _unit) then { _typeofUnit = "vc" };

		// If the class is not in the _unitClasses array
		if (!_known) then {
			_typeofUnit = "r";
			["fn_assignGear.sqf",format["Could not auto-identify gear for %1 %2. Ensure you are using vanilla units (NATO/CSAT/AAF) for players!", _unit, typeOf _unit]] call f_fnc_logIssue;
		};
	} else {
		if (_unit isKindOf "Thing") then {
			_typeofUnit = "crate_med";
		} else {
			_typeofUnit = "v_car";
		};
	};
};

// SET A PUBLIC VARIABLE
// A public variable is set on the unit, indicating their type. This is mostly relevant for the F3 respawn component
_unit setVariable ["f_var_assignGear",_typeofUnit, true];

// This variable simply tracks the progress of the gear assignation process, for other scripts to reference.
_unit setVariable ["f_var_assignGear_done", false];

// Defined Loadouts for the Factions - YOU CAN DEFINE EACH FACTIONS GEAR IN THIS!
#include "..\..\mission\loadout\assignedLoadouts.sqf";

_f_fnc_parseGear = {
	params ["_varName","_gearArray",["_cfgFile","CfgMagazines"]];
	private _foundGear = [];
	
	if (isNil "_gearArray") then {_gearArray = []};
	if (_gearArray isEqualType "") then {_gearArray = [_gearArray]};
	
	{
		if !(isNil _x) then {
			if (isClass (configFile >> _cfgFile >> format["%1",call compile _x])) then {
				_foundGear pushBackUnique configName (configFile >> _cfgFile >> format["%1",call compile _x]);
			};
		};
	} forEach _gearArray;
	
	missionNamespace setVariable [_varName,_foundGear,true];
};

// Store item classes for selection later
if (isNil format["f_var_%1_gear_smokeTH",_side]) then { [format["f_var_%1_gear_smokeTH",_side],["_smokegrenade","_smokegrenade1","_smokegrenade2","_smokegrenade3","_smokeGrenadeAlt","_smokeGrenadeAlt1","_smokeGrenadeAlt2"]] call _f_fnc_parseGear; };	
if (isNil format["f_var_%1_gear_flareTH",_side]) then { [format["f_var_%1_gear_flareTH",_side],["_chem","_chem1","_chem2","_chem3","_chemAlt","_chemAlt1","_chemAlt2"]] call _f_fnc_parseGear; };	
if (isNil format["f_var_%1_gear_smokeGL",_side]) then { [format["f_var_%1_gear_smokeGL",_side],["_glsmoke","_glsmoke1","_glsmoke2","_glsmoke3","_glsmokealt","_glsmokealt1","_glsmokealt2"]] call _f_fnc_parseGear; };	
if (isNil format["f_var_%1_gear_flareGL",_side]) then { [format["f_var_%1_gear_flareGL",_side],["_glflare","_glflare1","_glflare2","_glflare3","_glflarealt","_glflarealt1","_glflarealt2"]] call _f_fnc_parseGear; };	
if (isNil format["f_var_%1_gear_grenade",_side]) then { [format["f_var_%1_gear_grenade",_side],["_grenade","_grenade1","_grenade2","_grenade3","_grenadealt","_grenadealt1","_grenadealt2"]] call _f_fnc_parseGear; };	
if (isNil format["f_var_%1_gear_glasses",_side]) then { [format["f_var_%1_gear_glasses",_side],"_baseGlasses","CfgGlasses"] call _f_fnc_parseGear; };

// Gear Checking
if (_isMan && !_skipCheck) then {
	_unitMags = (magazines _unit) apply { toLower _x };
	
	if (handgunWeapon _unit != "") then {
		_configMags = ([handgunWeapon _unit] call BIS_fnc_compatibleMagazines) apply { toLower _x };
		
		if (_unitMags arrayIntersect _configMags isEqualTo []) then {
			["fn_assignGear.sqf",format["Unit %1 %2_%3 has no additional magazines for side-arm '%4'.",_unit,_side,_typeofUnit,handgunWeapon _unit]] call f_fnc_logIssue;
			_unit addMagazines [(_configMags select 0),2];
		};
	};
	
	if (primaryWeapon _unit == "") then {
		["fn_assignGear.sqf",format["Unit %1 %2_%3 has no primary weapon!",_unit,_side,_typeofUnit]] call f_fnc_logIssue;
	} else {
		_configMags = ([primaryWeapon _unit] call BIS_fnc_compatibleMagazines) apply { toLower _x };
		
		if (_unitMags arrayIntersect _configMags isEqualTo []) then {
			["fn_assignGear.sqf",format["Unit %1 %2_%3 has no additional magazines for primary '%4'.",_unit,_side,_typeofUnit,primaryWeapon _unit]] call f_fnc_logIssue;
			_unit addMagazines [(_configMags select 0),2];
			reload _unit;
		};
	};
	
	// Warn if any gear is overfilled - Credit: JonBons@BWF
	if !(_unit canAdd "ItemMap") then {
		["fn_assignGear.sqf",format["Gear for %1 %2_%3 slot is overfilled.",_unit,_side,_typeofUnit]] call f_fnc_logIssue;
	};
};

// This variable simply tracks the progress of the gear assignation process, for other
// scripts to reference.
_unit setVariable ["f_var_assignGear_done", true];

// ERROR CHECKING
// If the faction of the unit cannot be defined, the script exits with an error.

if (isNil "_carbine") then { //_carbine should exist unless no faction has been called
	["fn_assignGear.sqf",format["%1 is not defined for side '%2'",_typeofUnit, _side]] call f_fnc_logIssue;
};