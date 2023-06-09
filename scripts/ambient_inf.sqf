// Ambient Infantry v0.2
// Author: 2600K
// Generates ambient groups
//
// Usage: _nul = [] execVM "scripts\ambient_inf.sqf";
if !isServer exitWith {};

// Unit Variables

/*
// CHOOSE ONE SIDE AND ONE ARRAY OF MEN!

private _side = WEST;
ZMM_WESTMan = ["B_T_Soldier_F","B_T_soldier_LAT_F","B_T_Soldier_F","B_T_soldier_AR_F","B_T_Soldier_F","B_T_Soldier_TL_F","B_T_Soldier_F",selectRandom["B_T_Soldier_AA_F","B_T_Soldier_AT_F"]]; // WEST - NATO TANOA (VANILLA)
ZMM_WESTMan = ["B_Soldier_F","B_soldier_LAT_F","B_Soldier_F","B_soldier_AR_F","B_Soldier_F","B_Soldier_TL_F","B_Soldier_F",selectRandom["B_Soldier_AA_F","B_Soldier_AT_F"]]; // WEST - NATO (VANILLA)
ZMM_WESTMan = ["B_W_Soldier_F","B_W_soldier_AR_F","B_W_Soldier_F","B_W_Soldier_TL_F","B_W_Soldier_F","B_W_Soldier_LAT2_F","B_W_Soldier_F",selectRandom["B_W_Soldier_AA_F","B_W_Soldier_AT_F"]]; // WEST - NATO (WOODLAND)
ZMM_WESTMan = ["B_G_Soldier_F","B_G_Soldier_LAT_F","B_G_Soldier_F","B_G_Soldier_SL_F","B_G_Soldier_F","B_G_Soldier_AR_F"]; // WEST - FIA (VANILLA)
ZMM_WESTMan = ["B_GEN_Soldier_F","B_GEN_Commander_F","B_GEN_Soldier_F","B_GEN_Soldier_F"]; // WEST - GENDARME (VANILLA)

private _side = EAST;
ZMM_EASTMan = ["O_T_Soldier_F","O_T_Soldier_LAT_F","O_T_Soldier_F","O_T_Soldier_GL_F","O_T_Soldier_F","O_T_Soldier_AR_F","O_T_Soldier_F",selectRandom["O_T_Soldier_AA_F","O_T_Soldier_AT_F"]]; // EAST - CSAT TANOA (VANILLA)
ZMM_EASTMan = ["O_Soldier_F","O_Soldier_LAT_F","O_Soldier_F","O_Soldier_GL_F","O_Soldier_F","O_Soldier_AR_F","O_Soldier_F",selectRandom["O_Soldier_AA_F","O_Soldier_AT_F"]]; // EAST - CSAT (VANILLA)
ZMM_EASTMan = ["O_R_Soldier_TL_F","O_R_soldier_M_F","O_R_Soldier_AR_F","O_R_JTAC_F","O_R_medic_F","O_R_Soldier_LAT_F","O_R_Soldier_GL_F"]; // EAST - SPETSNAZ (VANILLA)
ZMM_EASTMan = ["O_G_Soldier_SL_F","O_G_Soldier_F","O_G_Soldier_AR_F","O_G_Soldier_F","O_G_Soldier_LAT_F","O_G_Soldier_F"]; // EAST - FIA (VANILLA)

private _side = INDEPENDENT;
ZMM_GUERMan = ["I_C_Soldier_Para_7_F","I_C_Soldier_Para_4_F","I_C_Soldier_Para_1_F","I_C_Soldier_Para_2_F"]; // GUER - SYNDIKAT (VANILLA)
ZMM_GUERMan = ["I_Soldier_F","I_Soldier_LAT2_F","I_Soldier_F","I_Soldier_GL_F","I_Soldier_F","I_Soldier_AR_F","I_Soldier_F",selectRandom["I_Soldier_AA_F","I_Soldier_AT_F"]]; // GUER - AAF (VANILLA)
ZMM_GUERMan = ["I_E_Soldier_F","I_E_Soldier_LAT2_F","I_E_Soldier_F","I_E_Soldier_AR_F","I_E_Soldier_F","I_E_Soldier_TL_F","I_E_Soldier_F",selectRandom["I_E_Soldier_AA_F","I_E_Soldier_AT_F"]]; // GUER - LDF (VANILLA)
*/

sleep 5;

// User Variables
AMBI_Debug = false;	// Show Markers
AMBI_DistMax = 1000;	// Max distance to find buildings.
AMBI_DistMin = 500; // Min distance to spawn.
AMBI_UnitsMax = 80;	// Max units active at once.
AMBI_UnitsChance = 80; // Overall chance to spawn
AMBI_SafeAreas = missionNamespace getVariable ["ZCS_var_BlackList",[]]; // List of Safe Areas - Imported from ZMM

// Script Variables
AMBI_Loop = true;
AMBI_UnitsActive = [];

private _loopNo = 1;

private _fnc_log = {
	params ["_text"];
	systemChat _text;
	diag_log text _text;
};

while {AMBI_Loop} do {
	private _tempBuild = [];
	private _finalBuild = [];
	private _unitsToCheck = allPlayers select { (getPosATL _x)#2 < 5 && leader group _x == _x }; // All leaders on ground
	
	//format["[AMBI] INIT Loop #%1 - Players %2 - Units %3", _loopNo, count _unitsToCheck, count AMBI_UnitsActive] call _fnc_log;

	{ 
		if (_x find "mkr_ambi_" > -1) then {
			if ((_x find "mkr_ambi_spawn_" > -1 || _x find "mkr_ambi_tracker_" > -1) && markerAlpha _x > 0) then {
				_x setMarkerAlphaLocal (markerAlpha _x - 0.05)
			} else {
				deleteMarker _x
			};
	}} forEach allMapMarkers;

	{ 
		private _unit = _x;

		// Breadcrumbs - These markers gradually fade and prevent units from spawning in those zones.
		if (allMapMarkers findIf { getMarkerPos _x distance2D _unit < 200 && _x find "mkr_ambi_tracker_" > -1} == -1) then {
			private _mrkr = createMarkerLocal [format ["mkr_ambi_tracker_%1_%2", _loopNo, _forEachIndex], _unit];
			_mrkr setMarkerShapeLocal "ELLIPSE";
			_mrkr setMarkerSizeLocal [400, 400];
			_mrkr setMarkerColorLocal "ColorWest";
			
			private _tempList = (_x nearObjects ["House", AMBI_DistMax]) select { count (_x buildingPos -1) > 4 };
			
			// TODO: Improve this - Filter buildings at the stage instead of leaving it to later?
			// If the unit is in a safe zone, but the houses are outside, we can't skip this step.
		
			{
				private _bld = _x;
				//systemChat format["[AMBI] Loop #%1 - %2 - %3m", _forEachIndex, _bld, player distance2D _bld];
				if (_unitsToCheck findIf { _x distance2D _bld < AMBI_DistMin } == -1) then { _tempBuild pushBackUnique _bld };
			} forEach (_tempList - _tempBuild);
		};
		
		if (AMBI_Debug) then {
			private _mrkr = createMarkerLocal [format ["mkr_ambi_player_%1", _forEachIndex], _unit];
			_mrkr setMarkerPosLocal getPos _unit;
			_mrkr setMarkerTypeLocal "mil_dot";
			_mrkr setMarkerColorLocal "ColorOrange";
			
			private	_mrkr = createMarkerLocal [format ["mkr_ambi_max_%1", _forEachIndex], _unit];
			_mrkr setMarkerPosLocal getPos _unit;
			_mrkr setMarkerShapeLocal "ELLIPSE";
			_mrkr setMarkerBrushLocal "Border";
			_mrkr setMarkerSizeLocal [AMBI_DistMax, AMBI_DistMax];
			_mrkr setMarkerColorLocal "ColorOrange";
			
			private	_mrkr = createMarkerLocal [format ["mkr_ambi_min_%1", _forEachIndex], _unit];
			_mrkr setMarkerPosLocal getPos _unit;
			_mrkr setMarkerShape "ELLIPSE";
			_mrkr setMarkerBrushLocal "Border";
			_mrkr setMarkerSizeLocal [AMBI_DistMin, AMBI_DistMin];
			_mrkr setMarkerColorLocal "ColorOrange";
		};
	} forEach _unitsToCheck;
		
	// Filter the largest buildings within 150m of each other
	{
		private _bld = _x;
		// Remove nearby smaller buildings.
		_tempBuild = _tempBuild - (_tempBuild select { _bld != _x && _bld distance2D _x < 100 && count (_x buildingPos -1) <= count (_bld buildingPos -1) });
		// Remove buildings in safe zone or that have infantry already
		if ((allGroups select { side _x isEqualto _side } apply { leader _x }) findIf { _x distance2D _bld < 100 } > -1 || count (allMapMarkers select { (_x find "mkr_ambi_tracker_" > -1 || _x in AMBI_SafeAreas) && _bld inArea _x }) > 0) then { _tempBuild = _tempBuild - [_bld] };
	} forEach _tempBuild;
	
	//format["[AMBI] After Filter %1 - %2", count _tempBuild, _tempBuild] call _fnc_log;
	
	{
		private _house = _x;
		private _bPos = [0,0,0];
		
		if (AMBI_Debug) then {
			private _mrkr = createMarkerLocal [ format ["mkr_ambi_house_%1_%2", _loopNo, _forEachIndex], _house];
			_mrkr setMarkerPosLocal _house;
			_mrkr setMarkerTypeLocal "mil_dot";
			_mrkr setMarkerColorLocal "ColorYellow";
			_mrkr setMarkerTextLocal format["AMB_%1_%2m",_loopNo, round (_house distance2D player)];
		};
		
		// Find middle position in building.
		{ if (_house distance _x < _house distance _bPos) then { _bPos = _x } } forEach (_house buildingPos -1);
		
		// Add Garrison
		private _enemyMen = missionNamespace getVariable [format["ZMM_%1Man", _side], ["O_Solider_F"]];
		private _enemyTeam = [];
		for "_i" from 0 to (2 * (missionNamespace getVariable ["ZZM_Diff", 1])) do { _enemyTeam set [_i, selectRandom _enemyMen] };
		
		//format["[AMBI] Spawning Garrison at %1", _bPos] call _fnc_log;
		
		private _garrisonGroup = [_bPos, _side, _enemyTeam] call BIS_fnc_spawnGroup;
		_garrisonGroup deleteGroupWhenEmpty true;
		_garrisonGroup enableDynamicSimulation true;

		private _garrisonUnits = units _garrisonGroup;
		private _bPoss = [] call BIS_fnc_arrayShuffle;

		{
			_x disableAI "PATH";
			_x setUnitPos selectRandom ["UP","UP","MIDDLE"];
			_x addEventHandler["Fired",{ params ["_unit"]; _unit enableAI "PATH"; _unit setUnitPos "AUTO"; _unit removeEventHandler ["Fired",_thisEventHandler]; }];
			_x setPosATL (selectRandom (_house buildingPos -1));
		} foreach _garrisonUnits;
				
		if (count AMBI_UnitsActive < AMBI_UnitsMax && random 100 <= AMBI_UnitsChance) then {
			private _enemyMen = missionNamespace getVariable [format["ZMM_%1Man", _side], ["O_Solider_F"]];
			private _enemyTeam = [];
			for "_i" from 0 to (3 * (missionNamespace getVariable ["ZZM_Diff", 1])) do { _enemyTeam set [_i, selectRandom _enemyMen] };
			
			//format["[AMBI] Spawning Team at %1", _bPos] call _fnc_log;
			
			private _patrolGroup = [_bPos, _side, _enemyTeam] call BIS_fnc_spawnGroup;
			_patrolGroup deleteGroupWhenEmpty true;
			_patrolGroup enableDynamicSimulation true;
			
			if (random 1 > 0.3) then {
				[_patrolGroup, getPos _house, 100 + random 100] call BIS_fnc_taskPatrol;
			};
			
			// Add to global list
			AMBI_UnitsActive append units _patrolGroup;
			
			{ _x addCuratorEditableObjects [units _patrolGroup, true] } forEach allCurators;
			
			if (AMBI_Debug) then {
				private _mrkr = createMarkerLocal [format ["mkr_ambi_spawn_%1_%2", _loopNo, _forEachIndex], _bPos];
				_mrkr setMarkerPosLocal _bPos;
				_mrkr setMarkerTypeLocal "mil_dot";
				_mrkr setMarkerColorLocal "ColorRed";
				_mrkr setMarkerTextLocal format["SP_%1_%2",_loopNo, _forEachIndex];
			};
			sleep 1;
		};
	} forEach _tempBuild;
	
	{
		private _unit = _x;
		if (allPlayers findIf { _x distance2D _unit < (AMBI_DistMax * 1.5) } == -1) then { 
			//format["[AMBI] Deleting Unit %1", _unit] call _fnc_log;
			AMBI_UnitsActive deleteAt (AMBI_UnitsActive find _unit);
			deleteVehicle _x;
		};
	} forEach AMBI_UnitsActive;
	
	_loopNo = _loopNo + 1;
	sleep 10;
};

