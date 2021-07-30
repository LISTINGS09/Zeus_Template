/*
ARMA3 - FILL HOUSE SCRIPT v1.12 - by 26K, SPUn & lostvar

Fills house or buildings in defined range with soldiers

Calling the script:
default: _nul = [this] execVM "scripts\LV\fillHouse.sqf";
custom:  _nul = [this, "NATO", FALSE, 1, [1, round random 8], 15] execVM "scripts\LV\fillHouse.sqf";
example: _nul = [thisTrigger, "NATO"] execVM "scripts\LV\fillHouse.sqf";

Parameters:
		
	target 		= 	center point 	(Game Logics/Objects/Marker name, ex: GL01 or this or "marker1")
	side 		= 	"NATO", "WEST", "CSAT", "EAST", "AFF" or "FIA"											DEFAULT: "NATO"
	patrol 		= 	TRUE or FALSE 	(if TRUE, units will patrol) 											DEFAULT: TRUE
	patrol dist	= 	1-999 radius in meters for patrol (if TRUE, units will patrol) 							DEFAULT: 100
	spawn rate  = 	1-100 OR Array 	(on how many percentage of possible positions are soldiers spawned) 	DEFAULT: 50
				NOTE: Array - you can also use following syntax: [amount,random amount] for example:
				[10,12] will spawn at least 10 units + random 12 units 
	radius 		= 	1 or larger number (1=nearest building. if larger number, then all buildings in radius) DEFAULT: 1
	skills 		= 	"default" 	(default AI skills) 														DEFAULT: "default"
				or	number	=	0-1.0 = this value will be set to all AI skills, ex: 0.8
				or	array	=	all AI skills individually in array, values 0-1.0, order:
		[aimingAccuracy, aimingShake, aimingSpeed, spotDistance, spotTime, courage, commanding, general, reloadSpeed] 
		ex: 	[0.75,0.5,0.6,0.85,0.9,1,1,0.75,1] 

// Code to list all the factions and sides
_factionsFound = []; 
{ 
	_factionsFound pushBackUnique [ 
		getText (configFile >> "CfgFactionClasses" >> (getText (_x >> "faction")) >> "displayName"), 
		getText (configFile >> "CfgEditorSubcategories" >> (getText (_x >> "editorSubcategory")) >> "displayName"), 
		getText (_x >> "faction"), 
		getText (_x >> "editorSubcategory") 
	]; 
} forEach ("(configName _x iskindOf 'CAManBase') && getNumber(_x >> 'scope') == 2" configClasses (configFile >> "CfgVehicles"));
_factionsFound sort TRUE; 
copyToClipboard _factionsfound;
*/

if !isServer exitWith{};

private["_bPoss", "_rat", "_side", "_tempList", "_soldierList", "_helper"];
params [ "_center",
	["_faction", "NATO"],
	["_patrol", FALSE],
	["_pDist", 100],
	["_ratio", [1,5]],
	["_radius", 25],
	["_skills", [0.4,0.5,1,0.8,0.7,1,1,1,1]]
];

// Backwards compatibility and for those too lazy to find class names
_fSel = switch (_faction) do {
	// WEST
	case "CDF": 	{ ["rhsgref_faction_cdf_ground_b","rhsgref_EdSubcat_infantry"] };
	case "CTRG": 	{ ["BLU_CTRG_F","EdSubcat_Personnel_Pacific"] };
	case "FIAW": 	{ ["BLU_G_F","EdSubcat_Personnel"] };
	case "POLICE": 	{ ["BLU_GEN_F","EdSubcat_Personnel"] };
	case "HIDF": 	{ ["rhsgref_faction_hidf","rhsgref_EdSubcat_infantry"] };
	case "NATO":	{ ["BLU_F","EdSubcat_Personnel"] };
	case "NATOP": 	{ ["BLU_T_F","EdSubcat_Personnel"] };
	case "NATOPSF": { ["BLU_T_F","EdSubcat_Personnel_SpecialForces"] };
	case "NATOW":	{ ["BLU_W_F","EdSubcat_Personnel"] };
	case "USAD": 	{ ["rhs_faction_usarmy_d","rhs_EdSubcat_infantry_ocp"] };
	case "USAW": 	{ ["rhs_faction_usarmy_wd","rhs_EdSubcat_infantry_ucp"] };
	case "USMCD": 	{ ["rhs_faction_usmc_d","rhs_EdSubcat_infantry"] };
	case "USAW": 	{ ["rhs_faction_usmc_wd","rhs_EdSubcat_infantry"] };
	case "GER": 	{ ["gm_fc_ge","gm_esc_men_80_autumn"] };
	case "GERW": 	{ ["gm_fc_ge","gm_esc_men_80_winter"] };
	// SOG(WEST)
	case "CIDG": 	{ ["B_MACV","vn_b_men_cidg"] };
	case "LRRP": 	{ ["B_MACV","vn_b_men_lrrp"] };
	case "MACV": 	{ ["B_MACV","vn_b_men_sog"] };
	case "SF": 		{ ["B_MACV","vn_b_men_sf"] };
	case "USA": 	{ ["B_MACV","vn_b_men_army"] };

	// GUER
	case "AAF": 	{ ["IND_F","EdSubcat_Personnel"] };
	case "CDFO": 	{ ["rhsgref_faction_cdf_ground","rhsgref_EdSubcat_infantry"] };
	case "CHDKZ": 	{ ["rhsgref_faction_chdkz_g","rhsgref_EdSubcat_infantry"] };
	case "FIA": 	{ ["IND_G_F","EdSubcat_Personnel"] };
	case "LDF": 	{ ["IND_E_F","EdSubcat_Personnel"] };
	case "LOOT": 	{ ["IND_L_F","EdSubcat_Personnel"] };
	case "NAPA": 	{ ["rhsgref_faction_nationalist","rhsgref_EdSubcat_infantry_militia"] };
	case "NAPAP": 	{ ["rhsgref_faction_nationalist","rhsgref_EdSubcat_infantry_paramil"] };
	case "SAF": 	{ ["rhssaf_faction_army","rhssaf_EdSubcat_army_infantry_oakleaf"] };
	case "BAN": 	{ ["IND_C_F","EdSubcat_Personnel_Bandits"] };
	case "SYND": 	{ ["IND_C_F","EdSubcat_Personnel_Paramilitary"] };
	// SOG(GUER)
	case "ARVN": 	{ ["I_ARVN","vn_i_men_arvn"] };
	case "ARVNSF": 	{ ["I_ARVN","vn_i_men_arvn_sf"] };
	case "RANGER": 	{ ["I_ARVN","vn_i_men_arvn_ranger"] };

	// EAST
	case "CHDKZE": 	{ ["rhsgref_faction_chdkz","rhsgref_EdSubcat_infantry"] };
	case "CSAT": 	{ ["OPF_F","EdSubcat_Personnel"] };
	case "CSATU": 	{ ["OPF_F","EdSubcat_Personnel_Camo_Urban"] };
	case "CSATSF": 	{ ["OPF_F","EdSubcat_Personnel_Viper"] };
	case "CSATP": 	{ ["OPF_T_F","EdSubcat_Personnel"] };
	case "CSATPSF":	{ ["OPF_T_F","EdSubcat_Personnel_Viper"] };
	case "FIAE": 	{ ["OPF_G_F","EdSubcat_Personnel"] };
	case "RUEMR": 	{ ["rhs_faction_msv","rhs_EdSubcat_infantry_emr"] };
	case "RU": 		{ ["rhs_EdSubcat_infantry_flora"] };
	case "RUD": 	{ ["rhs_faction_vdv","rhs_EdSubcat_infantry_emr_des"] };
	case "RUMF": 	{ ["rhs_faction_vdv","rhs_EdSubcat_infantry_mflora"] };
	case "SAFE": 	{ ["rhssaf_faction_army_opfor","rhssaf_EdSubcat_army_infantry_digital"] };
	case "SPZ":		{ ["OPF_R_F","EdSubcat_Personnel"] };
	case "TAKI": 	{ ["Taki_Opfor","EdSubcat_Personnel"] };
	case "TLA": 	{ ["rhsgref_faction_tla","rhsgref_EdSubcat_infantry"] };
	case "EGER": 	{ ["gm_fc_gc","gm_esc_men_80"] };
	case "EGERW": 	{ ["gm_fc_gc","gm_esc_men_80_winter"] };
	// SOG(EAST)
	case "VCMAIN": 		{ ["O_VC","vn_o_men_vc_mainforce"] };
	case "VCLOCAL": 	{ ["O_VC","vn_o_men_vc_local"] };
	case "VCREGIONAL":	{ ["O_VC","vn_o_men_vc_regional"] };
	case "PAVNFIELD65": { ["O_PAVN","vn_o_men_nva_65_d"] };
	case "PAVNFIELD": 	{ ["O_PAVN","vn_o_men_nva_d"] };
	case "PAVN": 		{ ["O_PAVN","vn_o_men_nva"] };
	case "PAVN65": 		{ ["O_PAVN","vn_o_men_nva_65"] };
	case "PAVNDACONG": 	{ ["O_PAVN","vn_o_men_nva_dac_cong"] };
	
	// CIV
	case "ZOM": 	{ ["ZOMBIE_Faction","EdSubcat_Personnel"] };
	default 		{ "INVALID" };
};

if !(_fSel isEqualType []) exitWith {
	systemChat format ["[FillHouse] ERROR - Invalid Faction: %1", _faction];
	diag_log text format ["[FillHouse] ERROR - Invalid Faction: %1", _faction];
};

_fSel params ["_factionID","_factionCat"];

if !(isClass (configFile >> "CfgFactionClasses" >> _factionID)) exitWith { 
	systemChat format ["[FillHouse] ERROR - Invalid Faction: %1", _faction];
	diag_log text format ["[FillHouse] ERROR - Invalid Faction: %1", _faction];
};

// Get side of the faciton
_side = [east, west, independent] select (getNumber (configFile >> "CfgFactionClasses" >> _factionID >> "side"));

// Get all units with a weapon and non-parachute backpack.
private _tempList = "getText (_x >> 'faction') == _factionID && getText (_x >> 'editorSubcategory') == _factionCat && (configName _x) isKindoF 'CAManBase' && getNumber(_x >> 'scope') == 2" configClasses (configFile >> "CfgVehicles");

// Filter out and invalid unit types matching strings.
_fnc_notInString = {
	params ["_type"];
	
	private _notInString = TRUE;
	{
		if (toLower _type find _x >= 0) exitWith { _notInString = FALSE };
	} forEach [ 
		"_story", 
		"_vr", 
		"competitor", 
		"ghillie", 
		"miller", 
		"survivor", 
		"crew", 
		"diver", 
		"pilot", 
		"rangemaster", 
		"uav", 
		"unarmed", 
		"officer", 
		"ugv", 
		"vn_o_men_nva_65_35",
		"vn_o_men_nva_65_36",
		"vn_o_men_nva_65_37",
		"vn_o_men_nva_65_38",
		"vn_o_men_nva_65_39",
		"vn_o_men_nva_65_40",
		"vn_o_men_nva_37",
		"vn_o_men_nva_38",
		"vn_o_men_nva_39",
		"vn_o_men_nva_40",
		"vn_o_men_nva_41",
		"vn_o_men_nva_42",
		"vn_b_men_army_13",
		"vn_b_men_army_14",
		"vn_b_men_army_23",
		"vn_b_men_army_24",
		"vn_b_men_army_25",
		"vn_b_men_army_26",
		"vn_b_men_army_28",
		"vn_b_men_army_29",
		"vn_i_men_army_13",
		"vn_i_men_army_14",
		"vn_i_men_army_23",
		"vn_i_men_army_24",
		"vn_i_men_army_25",
		"vn_i_men_army_26",
		"vn_i_men_ranger_13",
		"vn_i_men_ranger_14",
		"vn_i_men_ranger_22"
		 ];
	
	_notInString
};

// Attempt to clear up the units list - Include units with at least one weapon and a non-parachute backpack.
private _soldierList = _tempList select { ((configName _x) call _fnc_notInString) && (count getArray(_x >> "weapons") > 2) && (toLower getText (_x >> "backpack") find "para" < 0) };

// If no units remain, use the original list.
if (count _soldierList == 0) then { _soldierList = _tempList };

// No units exist at all!
if (count _soldierList == 0) exitWith {
	systemChat format ["[FillHouse] ERROR - No units found for Faction: %1", _factionID];
	diag_log text format ["[FillHouse] ERROR - No units found for Faction: %1", _factionID];
};

_center = switch (typeName _center) do {
	case "STRING": 	{ getMarkerPos _center};
	case "OBJECT":	{ getPos _center};
};

_bPoss = [];

if(_radius > 1) then {
	{
		_bPoss append (_x buildingPos -1) select { count (_x nearEntities ["Man",0.5]) < 1 }; // Any pos not already occupied
	} forEach (nearestObjects [_center, ["building"], _radius]);
} else {
	_bPoss = (nearestBuilding _center) buildingPos -1;
};

if(count _bPoss == 0) exitWith {
	systemChat format ["[FillHouse] ERROR - No valid positions at %1", _center];
	diag_log text format ["[FillHouse] ERROR - No valid positions at %1", _center];
};

if (typeName _ratio == "ARRAY") then{
	_rat = (_ratio#0) + (random (_ratio#1));
}else{
	_rat = ceil((_ratio / 100) * (count _bPoss));
};

_newGroup = createGroup [_side,TRUE];

// Disable VCOMAI
_newGroup setVariable ["VCM_DISABLE", TRUE];

for "_i" from 1 to _rat do {
	if (count _bPoss == 0 || _i > 60) exitWith {};
	_tempPos = selectRandom _bPoss;
	_bPoss = _bPoss - [_tempPos];
    _unitType = selectRandom (_soldierList apply { configName _x });
	
	//if (missionNamespace getVariable["f_param_debugMode",0] == 1) then { diag_log text format["[LV] DEBUG (fillHouse.sqf): Creating man %1 (%5) at %4. Positions: %2. Ratio: %3",_i,count _bPoss,_rat,_tempPos, _unitType]; };
	if !(_unitType isKindOF "CAMANBASE") exitWith { diag_log text format ["[FillHouse] ERROR - Invalid Unit: %1", _unitType] };
	
	_unit = _newGroup createUnit [_unitType, _tempPos, [], 0, "NONE"];
	_unit setPosATL _tempPos;
	
	_unitEyePos = eyePos _unit;
	
	// Make unit crouch if they have sky above their heads.
	if (count (lineIntersectsWith [_unitEyePos, (_unitEyePos vectorAdd [0, 0, 10])] select {_x isKindOf 'Building'}) < 1) then {
		_unit setUnitPos "MIDDLE";
		// Reset source to new height.
		_unitEyePos = eyePos _unit; 
	}; 
	
	// Force unit to hold - doStop is a 'soft' hold, disableAI stops movement permanently.
	if (random 1 > 0.7) then { doStop _unit } else { _unit disableAI "PATH" };
	
	_p1 = []; // Great pos, facing outside building.
	_p2 = []; // Good pos but facing inside building.
	_p3 = []; // OK pos but not best views.
	_p4 = []; // Bad pos facing wall.
	
	// Get Building Direction
	_unitBld = nearestBuilding _unit;
	
	for "_dir" from (getDir _unitBld) to ((getDir _unitBld) + 359) step 45 do { 
		// Check 3m
		if (count (lineIntersectsWith [_unitEyePos, [_unitEyePos, 3, _dir] call BIS_fnc_relPos] select {_x isKindOf 'Building'}) > 0) then { 
			_p4 pushBack _dir;
		} else { 
			// Check 10m
			if (count (lineIntersectsWith [_unitEyePos, [_unitEyePos, 10, _dir] call BIS_fnc_relPos] select {_x isKindOf 'Building'}) > 0) then { 
				_p3 pushBack _dir;
			} else { 
				if (abs ((_unitEyePos getDir _unitBld) - _dir) >= 120) then {
					_p1 pushBack _dir;
				} else {
					_p2 pushBack _dir;
				};
			};
		};
	};  
		
	// Pick a random angle from the best grouping.
	_finalDir = -1;
	{	
		if (count _x > 0) then {_finalDir = selectRandom _x };
		if (_finalDir >= 0) exitWith {}; 
	} forEach [_p1, _p2, _p3, _p4];
	
	_unit doWatch (_unit getPos [200,_finalDir]);
	
	// Stop unit from wandering off
	if (random 1 > 0.3) then { _unit disableAI "PATH" };
	
	// Semi-exposed area, set to kneel.
	if (count (_p1 + _p2) >= 5 && random 1 > 0.2) then { _unit setUnitPos "MIDDLE" };

	// Exposed area, set to prone.
	if (count (_p1 + _p2) >= 7) then { 
		if (random 1 > 0.8) then { _unit setUnitPos "MIDDLE" } else { _unit setUnitPos "DOWN" };
	};	
	
	if (_skills isEqualType []) then { 
		{
			_x setSkill ["aimingAccuracy",(_skills select 0)];
			_x setSkill ["aimingShake",(_skills select 1)];
			_x setSkill ["aimingSpeed",(_skills select 2)];
			_x setSkill ["spotDistance",(_skills select 3)];
			_x setSkill ["spotTime",(_skills select 4)];
			_x setSkill ["courage",(_skills select 5)];
			_x setSkill ["commanding",(_skills select 6)];
			_x setSkill ["general",(_skills select 7)];
			_x setSkill ["reloadSpeed",(_skills select 8)];
		} forEach units _unit;
	} else { _unit setSkill _skills; };
	
	//Add to Zeus
	{
		_x addCuratorEditableObjects [[_unit],TRUE];
	} forEach allCurators;
};

_newGroup spawn { sleep 5; _this enableDynamicSimulation TRUE; };

if (_patrol) then { [_newGroup, getPos leader _newGroup, _pDist] spawn BIS_fnc_taskPatrol };