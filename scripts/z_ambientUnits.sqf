// Zeus Community Ambient Units
// Author: 2600K
// Generates Ambient Garrison and Patrols
//
// Usage: _nul = [] execVM "scripts\z_ambientUnits.sqf";
ZAU_version = 1.6;
if !isServer exitWith {};


// Unit Variables

/*
// CHOOSE ONE SIDE AND ONE ARRAY OF MEN!

ZAU_Side = WEST;
ZMM_WEST_Man = ["B_T_Soldier_F","B_T_soldier_LAT_F","B_T_Soldier_F","B_T_soldier_AR_F","B_T_Soldier_F","B_T_Soldier_TL_F","B_T_Soldier_F",selectRandom["B_T_Soldier_AA_F","B_T_Soldier_AT_F"]]; // WEST - NATO TANOA (VANILLA)
ZMM_WEST_Man = ["B_Soldier_F","B_soldier_LAT_F","B_Soldier_F","B_soldier_AR_F","B_Soldier_F","B_Soldier_TL_F","B_Soldier_F",selectRandom["B_Soldier_AA_F","B_Soldier_AT_F"]]; // WEST - NATO (VANILLA)
ZMM_WEST_Man = ["B_W_Soldier_F","B_W_soldier_AR_F","B_W_Soldier_F","B_W_Soldier_TL_F","B_W_Soldier_F","B_W_Soldier_LAT2_F","B_W_Soldier_F",selectRandom["B_W_Soldier_AA_F","B_W_Soldier_AT_F"]]; // WEST - NATO (WOODLAND)
ZMM_WEST_Man = ["B_G_Soldier_F","B_G_Soldier_LAT_F","B_G_Soldier_F","B_G_Soldier_SL_F","B_G_Soldier_F","B_G_Soldier_AR_F"]; // WEST - FIA (VANILLA)
ZMM_WEST_Man = ["B_GEN_Soldier_F","B_GEN_Commander_F","B_GEN_Soldier_F","B_GEN_Soldier_F"]; // WEST - GENDARME (VANILLA)

ZAU_Side = EAST;
ZMM_EAST_Man = ["O_T_Soldier_F","O_T_Soldier_LAT_F","O_T_Soldier_F","O_T_Soldier_GL_F","O_T_Soldier_F","O_T_Soldier_AR_F","O_T_Soldier_F",selectRandom["O_T_Soldier_AA_F","O_T_Soldier_AT_F"]]; // EAST - CSAT TANOA (VANILLA)
ZMM_EAST_Man = ["O_Soldier_F","O_Soldier_LAT_F","O_Soldier_F","O_Soldier_GL_F","O_Soldier_F","O_Soldier_AR_F","O_Soldier_F",selectRandom["O_Soldier_AA_F","O_Soldier_AT_F"]]; // EAST - CSAT (VANILLA)
ZMM_EAST_Man = ["O_R_Soldier_TL_F","O_R_soldier_M_F","O_R_Soldier_AR_F","O_R_JTAC_F","O_R_medic_F","O_R_Soldier_LAT_F","O_R_Soldier_GL_F"]; // EAST - SPETSNAZ (VANILLA)
ZMM_EAST_Man = ["O_G_Soldier_SL_F","O_G_Soldier_F","O_G_Soldier_AR_F","O_G_Soldier_F","O_G_Soldier_LAT_F","O_G_Soldier_F"]; // EAST - FIA (VANILLA)

ZAU_Side = INDEPENDENT;
ZMM_GUER_Man = ["I_C_Soldier_Para_7_F","I_C_Soldier_Para_4_F","I_C_Soldier_Para_1_F","I_C_Soldier_Para_2_F"]; // GUER - SYNDIKAT (VANILLA)
ZMM_GUER_Man = ["I_Soldier_F","I_Soldier_LAT2_F","I_Soldier_F","I_Soldier_GL_F","I_Soldier_F","I_Soldier_AR_F","I_Soldier_F",selectRandom["I_Soldier_AA_F","I_Soldier_AT_F"]]; // GUER - AAF (VANILLA)
ZMM_GUER_Man = ["I_E_Soldier_F","I_E_Soldier_LAT2_F","I_E_Soldier_F","I_E_Soldier_AR_F","I_E_Soldier_F","I_E_Soldier_TL_F","I_E_Soldier_F",selectRandom["I_E_Soldier_AA_F","I_E_Soldier_AT_F"]]; // GUER - LDF (VANILLA)


// GMX

ZAU_Side = WEST;
ZMM_WEST_Man = ["gmx_cdf2022_army_rifleman_trg21_digittsko","gmx_cdf2022_army_machinegunner_pk_digittsko","gmx_cdf2022_army_rifleman_trg21_digittsko","gmx_cdf2022_army_antitank_trg21_pzf3_digittsko","gmx_cdf2022_army_rifleman_trg21_digittsko","gmx_cdf2022_army_squadleader_trg21_digittsko"]; // GMX CDF - 2022
ZMM_WEST_Man = ["gm_ge_army_grenadier_g3a3_80_ols","gm_ge_army_rifleman_g3a3_80_ols","gm_ge_army_squadleader_g3a3_p2a1_80_ols","gm_ge_army_machinegunner_mg3_80_ols"]; // West Germany - Summer
ZMM_WEST_Man = ["gm_ge_army_machinegunner_mg3_parka_80_win","gm_ge_army_rifleman_g3a3_parka_80_win","gm_ge_army_squadleader_g3a3_p2a1_parka_80_win","gm_ge_army_grenadier_g3a3_parka_80_win"]; // West Germany - Winter
ZMM_WEST_Man = ["gm_ge_army_grenadier_g3a3_80_ols","gm_ge_army_rifleman_g3a3_80_ols","gm_ge_army_squadleader_g3a3_p2a1_80_ols","gm_ge_army_machinegunner_mg3_80_ols"]; // West Germany - Tropical
ZMM_WEST_Man = ["gm_ge_army_grenadier_g3a3_80_ols","gm_ge_army_rifleman_g3a3_80_ols","gm_ge_army_squadleader_g3a3_p2a1_80_ols","gm_ge_army_machinegunner_mg3_80_ols"]; // West Germany - Desert
ZMM_WEST_Man = ["gmx_cdf_army_antitank_ak74_rpg7_ttsko","gmx_cdf_army_rifleman_ak74_ttsko","gmx_cdf_army_machinegunner_rpk_ttsko","gmx_cdf_army_rifleman_ak74_ttsko","gmx_cdf_army_squadleader_ak74_ttsko","gmx_cdf_army_rifleman_ak74_ttsko","gmx_cdf_army_rifleman_ak74_ttsko"]; // GMX CDF - 1980

ZAU_Side = EAST;
ZMM_EAST_Man = ["gm_gc_army_antitank_mpiak74n_rpg7_80_win","gm_gc_army_machinegunner_pk_80_win","gm_gc_army_rifleman_mpiak74n_80_win","gm_gc_army_squadleader_mpiak74n_80_win"]; // East Germany - Winter
ZMM_EAST_Man = ["gm_gc_army_rifleman_mpiak74n_80_str","gm_gc_army_squadleader_mpiak74n_80_str","gm_gc_army_machinegunner_pk_80_str","gm_gc_army_antitank_mpiak74n_rpg7_80_str","gm_gc_army_squadleader_mpiak74n_80_str"]; // East Germany - Summer
ZMM_EAST_Man = ["gm_pl_army_rifleman_akm_80_win","gm_pl_army_squadleader_akm_80_win","gm_pl_army_machinegunner_pk_80_win","gm_pl_army_antitank_akm_rpg7_80_win"]; // Poland - Winter
ZMM_EAST_Man = ["gm_pl_army_rifleman_akm_80_autumn_moro","gm_pl_army_squadleader_akm_80_autumn_moro","gm_pl_army_machinegunner_pk_80_autumn_moro","gm_pl_army_antitank_akm_rpg7_80_autumn_moro"]; // Poland - Summer
ZMM_EAST_Man = ["gmx_chdkz_army_rifleman_akm_mix","gmx_chdkz_army_squadleader_akm_win","gmx_chdkz_army_rifleman_akm_mix","gmx_chdkz_army_antitank_akm_rpg7_mix","gmx_chdkz_army_machinegunner_rpk_mix","gmx_chdkz_army_rifleman_akm_mix","gmx_chdkz_army_grenadier_akm_pallad_mix"];	// GMX ChDkz

ZAU_Side = INDEPENDENT;
ZMM_GUER_Man = ["I_Soldier_F","I_Soldier_LAT_F","I_Soldier_GL_F","I_Soldier_AR_F"];	// GMX AAF 1990
ZMM_GUER_Man = ["gm_xx_army_squadleader_m16a1_80_grn","gm_xx_army_rifleman_01_akm_alp","gm_xx_army_machinegunner_rpk_80_oli","gm_xx_army_assault_ak74nk_80_wdl","gm_xx_army_antitank_hk53a2_rpg7_80_oli"];	 // GM Revolutionaries

*/

sleep 5;

// Disable script if difficulty is explicitly disabled
if ((missionNamespace getVariable ["f_param_ZMMDiff", 1]) <= 0) exitWith {};

// User Variables
if (isNil "ZAU_Debug" ) 		then { ZAU_Debug = false };		// Show Markers
if (isNil "ZAU_DistMax" ) 		then { ZAU_DistMax = 800 };		// Max distance to find buildings.
if (isNil "ZAU_DistMin" ) 		then { ZAU_DistMin = 400 }; 	// Min distance to spawn.
if (isNil "ZAU_UnitsMax" ) 		then { ZAU_UnitsMax = 20 * (missionNamespace getVariable ["f_param_ZMMDiff", 1]) };		// Max units active at once.
if (isNil "ZAU_UnitsChance" ) 	then { ZAU_UnitsChance = 60 }; 	// Overall chance to spawn
if (isNil "ZAU_UnitsGarrison" ) then { ZAU_UnitsGarrison = (2 + floor ((count allPlayers min 16) / 8)) min 4 }; // # of units in garrison
if (isNil "ZAU_UnitsPatrol" ) 	then { ZAU_UnitsPatrol = (2 + floor ((count allPlayers min 16) / 8)) min 4 }; 	// # of units in patrols
if (isNil "ZAU_SleepTime" ) 	then { ZAU_SleepTime = 30 }; 	// Seconds between checks
if (isNil "ZAU_SafeAreas" ) 	then { ZAU_SafeAreas = ((allMapMarkers select { "cover" in toLower _x || "safezone" in toLower _x}) - ["bis_fnc_moduleCoverMap_border"]) + (missionNamespace getVariable ["ZCS_var_BlackList",[]]) };
if (isNil "ZAU_FadeMarker" ) 	then { ZAU_FadeMarker = false };// Allow locations to be repopulated

// Script Variables
ZAU_Loop = true;
ZAU_UnitsActive = [];

private _loopNo = 1;

if (isNil "zmm_fnc_misc_logMsg") then {
	private zmm_fnc_misc_logMsg = {
		params [["_lev", "INFO"], ["_msg", ""]];

		if ( missionNamespace getVariable ["ZAU_Debug", false] || !(toUpper _lev isEqualTo "DEBUG") ) then { 
			diag_log text format ["[QRF] [%1] %2", _lev, _msg];
		};
		
		if ( missionNamespace getVariable ["ZAU_Debug", false] || toUpper _lev isEqualTo "ERROR" ) then { 
			format ["[QRF] [%1] %2", _lev, _msg] remoteExec ["SystemChat"]
		} else {
			systemChat format ["[QRF] [%1] %2", _lev, _msg]
		};
	};
};

if (isNil "zmm_fnc_misc_findEnemySide") then {
	zmm_fnc_misc_findEnemySide = {
		params [
			["_nearPos", [0,0,0]],
			["_inDist", 2000],
			["_markerList",missionNamespace getVariable ["ZMM_LocationMarkerList",[]]]
		];

		private _foundSide = missionNamespace getVariable ["ZAU_Side", CIVILIAN];
		if (_foundSide != CIVILIAN) exitWith { _foundSide };

		//["DEBUG", format["Find Side - Checking %1 within %2", _nearPos, _inDist]] call zmm_fnc_misc_logMsg;

		// This will most often be called in ZMM so 
		if (count _markerList == 0) then { _markerList = allMapMarkers };
		if (isNil "ZMM_enemySides") then { ZMM_enemySides = [WEST, EAST, INDEPENDENT] - ((switchableUnits + playableUnits) apply { side group _x }) };

		private _sideColors = ZMM_enemySides apply { toUpper format["Color%1", _x] };
			
		// Check marker colours to match on.
		[([
			_markerList select {
				toUpper (getMarkerColor _x) in _sideColors && 
				getMarkerPos _x distance2D _nearPos < _inDist
			},
			[],
			{ _nearPos distance2D getMarkerPos _x },
			"ASCEND"
		] call BIS_fnc_sortBy) select 0] params [["_nearMarker",""]];

		// Found markers so find the nearest
		if (_nearMarker != "") then {
			_foundSide = switch (toUpper (getMarkerColor _nearMarker)) do { case "COLORWEST": { WEST }; case "COLOREAST": { EAST }; default { INDEPENDENT }; };
		};

		if (_foundSide in ZMM_enemySides) exitWith { _foundSide };

		// Find near entities to get side.
		[side (([
			allGroups select {
				leader _x distance2D _nearPos < _inDist &&
				side _x in ZMM_enemySides
			},
			[],
			{ leader _x distance2D _nearPos },
			"ASCEND"
		] call BIS_fnc_sortBy) select 0)] params [["_groupSide", CIVILIAN]];

		if (_groupSide in ZMM_enemySides) exitWith { _groupSide };

		selectRandom ZMM_enemySides
	};
};

if (isNil "zmm_fnc_misc_unitDirPos") then {
	zmm_fnc_misc_unitDirPos = {
		params [["_unit", objNull]];

		if !(alive _unit) exitWith {};

		// Force unit to hold - doStop is a 'soft' hold, disableAI stops movement permanently.
		if (random 1 > 0.7) then { doStop _unit } else { _unit disableAI "PATH" };

		private _unitEyePos = eyePos _unit;

		// Make unit crouch if they have sky above their heads.
		if (count (lineIntersectsWith [_unitEyePos, (_unitEyePos vectorAdd [0, 0, 10])] select {_x isKindOf 'Building'}) < 1) then {
			_unit setUnitPos "MIDDLE";
			// Reset source to new height.
			_unitEyePos = eyePos _unit; 
		}; 

		private _p1 = []; // Great pos, facing outside building.
		private _p2 = []; // Good pos but facing inside building.
		private _p3 = []; // OK pos but not best views.
		private _p4 = []; // Bad pos facing wall.

		// Get Building Direction
		private _unitBld = nearestBuilding _unit;

		if (!isNull _unitBld) then {
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
		};
			
		// Pick a random angle from the best grouping.
		private _finalDir = random 360;
		{	
			if (count _x > 0) exitWith {_finalDir = selectRandom _x };
		} forEach [_p1, _p2, _p3, _p4];

		_unit setDir _finalDir;
		_unit doWatch (_unit getPos [200,_finalDir]);

		// Semi-exposed area, set to kneel.
		if (count (_p1 + _p2) >= 5 && random 1 > 0.2) then { _unit setUnitPos "MIDDLE" };

		// Exposed area, set to prone.
		if (count (_p1 + _p2) >= 7) then { 
			if (random 1 > 0.8) then { _unit setUnitPos "MIDDLE" } else { _unit setUnitPos "DOWN" };
		};
	};
};

while {ZAU_Loop} do {
	// Clean dead or deleted units
	ZAU_UnitsActive = ZAU_UnitsActive select { !isNull _x && alive _x };
	
	private _tempBuild = [];
	private _finalBuild = [];
	private _unitsToCheck = allPlayers select { alive _x && (getPosATL _x)#2 < 5 && leader group _x == _x }; // All leaders on ground
	
	private _allMarkers = allMapMarkers;
	private _trackerMarkers = _allMarkers select { _x find "mkr_ZAU_tracker_" > -1 };
	private _safeMarkers = _trackerMarkers + ZAU_SafeAreas;
	
	//format["[ZAU] INIT Loop #%1 - Players %2 - Units %3", _loopNo, count _unitsToCheck, count ZAU_UnitsActive] call _fnc_log;

	// Fade markers over time to allow units to spawn there later
	{ 
		if (_x find "mkr_ZAU_" > -1 && {ZAU_FadeMarker}) then {
			if ((_x find "mkr_ZAU_spawn_" > -1 || _x find "mkr_ZAU_tracker_" > -1) && markerAlpha _x > 0) then {
				_x setMarkerAlphaLocal (markerAlpha _x - 0.01)
			} else {
				deleteMarker _x
			};
	}} forEach _allMarkers;

	{ 
		private _unit = _x;

		// Breadcrumbs - These markers gradually fade and prevent units from spawning in those zones.
		if (_trackerMarkers findIf { getMarkerPos _x distance2D _unit < (ZAU_DistMin*0.5) && _x find "mkr_ZAU_tracker_" > -1} == -1) then {
			private _mrkr = createMarkerLocal [format ["mkr_ZAU_tracker_%1_%2", _loopNo, _forEachIndex], _unit];
			_mrkr setMarkerShapeLocal "ELLIPSE";
			_mrkr setMarkerSizeLocal [ZAU_DistMin, ZAU_DistMin];
			_mrkr setMarkerColorLocal "ColorGrey";
			if !ZAU_Debug then { _mrkr setMarkerAlphaLocal 0; };
		};
		
		private _tempList = [];
		private _side = missionNamespace getVariable ["ZAU_Side",CIVILIAN];
		if (_side == CIVILIAN) then { _side = [getPos _unit] call zmm_fnc_misc_findEnemySide };

		{
			private _positions = _x buildingPos -1;
			
			if (
				!(surfaceIsWater (getPosATL _x)) &&
				{count _positions > 2}
			) then {	
				if ((_x getVariable ["ZAU_BuildingSide", sideUnknown]) != _side) then {
					_x setVariable ["ZAU_BuildingPositions", _positions];
					_x setVariable ["ZAU_BuildingSide", _side];
				};
				_tempList pushBack _x;
			};
		} forEach (nearestTerrainObjects [getPosATL _unit, ["HOUSE"], ZAU_DistMax, false, true]);
		
		// If the unit is in a safe zone, but the houses are outside, we can't skip this step.
		{
			private _bld = _x;
			//systemChat format["[ZAU] Loop #%1 - %2 - %3m", _forEachIndex, _bld, player distance2D _bld];
			if (_unitsToCheck findIf { _x distance2D _bld < ZAU_DistMin } < 0 && (_safeMarkers findIf { _bld inArea _x } < 0 )) then { _tempBuild pushBackUnique _bld };
		} forEach (_tempList - _tempBuild);
						
		if (ZAU_Debug) then {
			private _mrkr = createMarkerLocal [format ["mkr_ZAU_player_%1", _forEachIndex], _unit];
			_mrkr setMarkerPosLocal getPos _unit;
			_mrkr setMarkerTypeLocal "mil_dot";
			_mrkr setMarkerColorLocal format["Color%1",side group _unit];
			
			private	_mrkr = createMarkerLocal [format ["mkr_ZAU_max_%1", _forEachIndex], _unit];
			_mrkr setMarkerPosLocal getPos _unit;
			_mrkr setMarkerShapeLocal "ELLIPSE";
			_mrkr setMarkerBrushLocal "Border";
			_mrkr setMarkerSizeLocal [ZAU_DistMax, ZAU_DistMax];
			_mrkr setMarkerColorLocal format["Color%1",side group _unit];
			
			private	_mrkr = createMarkerLocal [format ["mkr_ZAU_min_%1", _forEachIndex], _unit];
			_mrkr setMarkerPosLocal getPos _unit;
			_mrkr setMarkerShape "ELLIPSE";
			_mrkr setMarkerBrushLocal "Border";
			_mrkr setMarkerSizeLocal [ZAU_DistMin, ZAU_DistMin];
			_mrkr setMarkerColorLocal format["Color%1",side group _unit];
		};
	} forEach _unitsToCheck;
	
	_finalBuild = [];
								
	// First Pass to filter the largest buildings within 100 of each other
	{
		private _bld = _x;
	
		if ( _tempBuild findIf { _bld != _x && 
			_bld distance2D _x < 100 && 
			count (_x getVariable ["ZAU_BuildingPositions", []]) > count (_bld getVariable ["ZAU_BuildingPositions", []]) } < 0 && 
			_finalBuild findIf { _bld distance2D _x < 100 } < 0 &&
			allGroups findIf { leader _x distance2D _bld < 100 } < 0
		) then {		
			_finalBuild pushBack _x;
			
			if (ZAU_Debug) then {
				//format["[ZAU] Building %1/%2 - Dist: %3 - %4 vs %5", _forEachIndex, count _tempBuild, round (_bld distance2D _x), count (_x getVariable ["ZAU_BuildingPositions", []]), count (_bld getVariable ["ZAU_BuildingPositions", []])] call _fnc_log;
		
				private _mrkr = createMarkerLocal [ format ["mkr_ZAU_house_%1_%2", _loopNo, _forEachIndex], _bld];
				_mrkr setMarkerPosLocal getPos _bld;
				_mrkr setMarkerTypeLocal "mil_dot";
				_mrkr setMarkerSizeLocal [0.6,0.6];
				_mrkr setMarkerColorLocal "ColorGreen";
			};
		};
	} forEach _tempBuild;
		
	//format["[ZAU] Filter %1 vs %2 - %3", count _finalBuild, count _tempBuild, _finalBuild] call _fnc_log;
	
	{
		private _bld = _x;
		private _bMid = [0,0,0];
		private _side = missionNamespace getVariable ["ZAU_Side", CIVILIAN];
		if (_side == CIVILIAN) then { _side = _bld getVariable ["ZAU_BuildingSide", EAST] };
		
		if (ZAU_Debug) then {
			private _mrkr = createMarkerLocal [ format ["mkr_ZAU_house_%1_%2", _loopNo, _forEachIndex], _bld];
			_mrkr setMarkerPosLocal _bld;
			_mrkr setMarkerTypeLocal "mil_dot";
			_mrkr setMarkerColorLocal "ColorYellow";
			_mrkr setMarkerTextLocal format["AMB_%1_%2m",_loopNo, round (_bld distance2D player)];
		};
		
		// Find middle position in building.
		{ if (_bld distance _x < _bld distance _bMid) then { _bMid = _x } } forEach (_bld getVariable ["ZAU_BuildingPositions", []]);
		
		// Add Garrison
		if (count ZAU_UnitsActive < ZAU_UnitsMax && random 100 <= ZAU_UnitsChance) then {
			private _enemyMen = missionNamespace getVariable [
					format["ZMM_%1_Man", _side], 
					[(["O_Soldier_F","B_Soldier_F","I_Soldier_F"] select (_side call BIS_fnc_sideID))]
				];
			private _enemyTeam = [];
			for "_i" from 0 to ((ZAU_UnitsGarrison * (missionNamespace getVariable ["ZZM_Diff", 1])) - 1) do { _enemyTeam set [_i, selectRandom _enemyMen] };
			
			//format["[ZAU] Spawning Garrison at %1", _bMid] call _fnc_log;
			
			private _garrisonGroup = [_bMid, _side, _enemyTeam] call BIS_fnc_spawnGroup;
			_garrisonGroup deleteGroupWhenEmpty true;
			
			private _bpa = _bld getVariable ["ZAU_BuildingPositions", []];
			
			{
				private _unit = _x;
				if (count _bpa < 1) exitWith {};
				
				private _tempPos = selectRandom _bpa;
				_bpa = _bpa - [_tempPos];
				
				if (count (_tempPos nearEntities ["Man", 1]) < 1) then {
					_unit setPosATL _tempPos;
					[_unit] spawn zmm_fnc_misc_unitDirPos;
				};
				
				ZAU_UnitsActive pushBackUnique _x;
			} foreach (units _garrisonGroup);
			
			ZAU_Count = (missionNamespace getVariable ["ZAU_Count", 0]) + 1;
			_garrisonGroup setGroupIdGlobal [format["ZAU_HOLD_%1", missionNamespace getVariable ["ZAU_Count", 0]]];
			_garrisonGroup spawn { sleep 5; _this enableDynamicSimulation true };
			
			sleep 1;
		};
			
		// Add Patrol
		if (count ZAU_UnitsActive < ZAU_UnitsMax && random 100 <= ZAU_UnitsChance) then {
			private _enemyMen = missionNamespace getVariable [
				format["ZMM_%1_Man", _side],
				[(["O_Soldier_F","B_Soldier_F","I_Soldier_F"] select (_side call BIS_fnc_sideID))]
			];
			private _enemyTeam = [];
			for "_i" from 0 to ((ZAU_UnitsPatrol * (missionNamespace getVariable ["ZZM_Diff", 1])) - 1) do { _enemyTeam set [_i, selectRandom _enemyMen] };
			
			//format["[ZAU] Spawning Team at %1", _bMid] call _fnc_log;
			
			private _patrolGroup = [_bMid, _side, _enemyTeam] call BIS_fnc_spawnGroup;
			_patrolGroup deleteGroupWhenEmpty true;
			_patrolGroup spawn { sleep 5; _this enableDynamicSimulation true };
						
			if (random 1 > 0.3) then {
				[_patrolGroup, getPos _bld, 100 + random 100] call BIS_fnc_taskPatrol;
			};
			
			// Add to global list
			ZAU_UnitsActive append units _patrolGroup;
			
			{ _x addCuratorEditableObjects [units _patrolGroup, true] } forEach allCurators;
			
			if (ZAU_Debug) then {
				private _mrkr = createMarkerLocal [format ["mkr_ZAU_spawn_%1_%2", _loopNo, _forEachIndex], _bMid];
				_mrkr setMarkerPosLocal _bMid;
				_mrkr setMarkerTypeLocal "mil_dot";
				_mrkr setMarkerColorLocal format["Color%1",_side];
				_mrkr setMarkerTextLocal format["SP_%1_%2",_loopNo, _forEachIndex];
			};
			
			ZAU_Count = (missionNamespace getVariable ["ZAU_Count", 0]) + 1;
			_patrolGroup setGroupIdGlobal [format["ZAU_FREE_%1", missionNamespace getVariable ["ZAU_Count", 0]]];
			
			sleep 1;
		};
	} forEach _finalBuild;
	
	private _remainingUnits = [];

	{
		private _unit = _x;

		if ( allPlayers findIf { _x distance2D _unit < (ZAU_DistMax * 1.8) } == -1 ) then {
			deleteVehicle _unit;
		} else {
			_remainingUnits pushBack _unit;
		};
	} forEach ZAU_UnitsActive;

	ZAU_UnitsActive = _remainingUnits;
	
	_loopNo = _loopNo + 1;
	sleep ZAU_SleepTime;
};