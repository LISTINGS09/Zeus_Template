// Zeus Civilian Spawning - By 2600K Based on Enigma(?) Civilian Script
// [] execVM "scripts\civPopulation.sqf";
ZCS_version = 2.6;
if !isServer exitWith {};
// missionNamespace getVariable ["ZCS_var_deadCivCount", 0] - Keeps a track of total civs killed.

// The following constants may be used to tweak behaviour
if (isNil "ZCS_var_WaitTime") then { ZCS_var_WaitTime = 60 }; // Maximum standing still time in seconds
if (isNil "ZCS_var_RunChance") then { ZCS_var_RunChance = 0.25 }; // Chance of running instead of walking
if (isNil "ZCS_var_UnitsPerBuilding") then { ZCS_var_UnitsPerBuilding = 0.1 };
if (isNil "ZCS_var_MaxGrpCount") then { ZCS_var_MaxGrpCount = 15 };
if (isNil "ZCS_var_MinDist") then { ZCS_var_MinDist = 100 };
if (isNil "ZCS_var_MaxDist") then { ZCS_var_MaxDist = 300 };
if (isNil "ZCS_var_EnemyChance") then { ZCS_var_EnemyChance = 0.05 }; // Chance of a hostile civilian appearing
if (isNil "ZCS_var_BomberChance") then { ZCS_var_BomberChance = 0.005 }; // Chance of hostile civilian being a bomber
if (isNil "ZCS_var_BlackList") then { ZCS_var_BlackList = [] };
if (isNil "ZCS_var_HideMrk") then { ZCS_var_HideMrk = false };
if (isNil "ZCS_var_LOWTasks") then { ZCS_var_LOWTasks = true };
if (isNil "ZCS_var_Debug") then { ZCS_var_Debug = false };


// Define custom gear if needed here - Empty array below will not override class gear, use [""] to force remove gear.
ZCS_var_UnitGear = [
	[], // Headgear
	[], // Glasses
	[],  // Uniforms
	[], // Vests
	[], // Backpack
	[] // Items
];

ZCS_var_UnitClass = switch (toLower worldName) do {
	case "tanoa": { [ "C_Man_casual_1_F_tanoan","C_Man_casual_2_F_tanoan","C_Man_casual_3_F_tanoan","C_Man_casual_4_v2_F_tanoan","C_Man_casual_5_v2_F_tanoan","C_Man_casual_6_v2_F_tanoan","C_Man_casual_7_F_tanoan","C_Man_casual_8_F_tanoan","C_Man_casual_9_F_tanoan","C_Man_casual_4_F_tanoan","C_Man_casual_5_F_tanoan","C_Man_casual_6_F_tanoan","C_Man_smart_casual_1_F_tanoan","C_Man_smart_casual_2_F_tanoan" ] };
	case "enoch": { [ "C_Man_1_enoch_F","C_Man_2_enoch_F","C_Man_3_enoch_F","C_Man_4_enoch_F","C_Man_5_enoch_F","C_Man_6_enoch_F","C_Farmer_01_enoch_F","C_Man_casual_9_F_afro","C_Man_casual_8_F_afro","C_Man_casual_7_F_afro","C_Man_casual_6_v2_F_afro" ] }; // Livonia
	case "cam_lao_nam";
	case "vn_khe_sanh";
	case "vn_the_bra": { [ "vn_c_men_13","vn_c_men_14","vn_c_men_15","vn_c_men_16","vn_c_men_17","vn_c_men_18","vn_c_men_19","vn_c_men_20","vn_c_men_21","vn_c_men_22","vn_c_men_01","vn_c_men_02","vn_c_men_03","vn_c_men_04"] };
	case "gm_weferlingen_winter";
	case "gm_weferlingen_summer": { [ "gm_gc_civ_man_01_80_blk","gm_gc_civ_man_01_80_blu","gm_gc_civ_man_03_80_blu","gm_gc_civ_man_03_80_grn","gm_gc_civ_man_02_80_brn","gm_gc_civ_man_03_80_gry","gm_gc_civ_man_04_80_blu","gm_gc_civ_man_04_80_gry" ] };
	case "sefrouramal": { [ "C_Djella_01_lxWS","C_Tak_02_A_lxWS","C_Tak_03_A_lxWS","C_Tak_01_A_lxWS"] };
	case "spe_normandy": { [ "SPE_CIV_Citizen_1_tie","SPE_CIV_Citizen_2","SPE_CIV_Citizen_3_trop","SPE_CIV_Citizen_4","SPE_CIV_Citizen_5_tropSPE_CIV_Citizen_6","SPE_CIV_Citizen_7","SPE_CIV_Swetr_1","SPE_CIV_Swetr_2","SPE_CIV_Swetr_2_vest","SPE_CIV_Swetr_4","SPE_CIV_Swetr_5","SPE_CIV_Worker_Coverall_1","SPE_CIV_Worker_Coverall_2","SPE_CIV_Worker_3"] };	
	default { [ "C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F","C_journalist_F","C_Man_casual_9_F_afro","C_Man_casual_8_F_afro","C_Man_casual_7_F_afro","C_Man_casual_6_v2_F_afro","C_Man_casual_4_v2_F_asia","C_Man_casual_3_F_asia","C_Man_casual_4_F_euro","C_Man_casual_5_F_euro","C_Man_casual_6_F_euro"]; }; // Vanilla
};

// Do not edit anything beneath this line!

// Parse markers list.
{
	if (getMarkerColor _x == "") then { 
		ZCS_var_BlackList deleteAt _forEachIndex;
		diag_log text format["[ZCS] WARNING - Marker not found '%1'", _x];
	} else {
		// Hide blacklist areas if set.
		if (ZCS_var_HideMrk) then { _x setMarkerAlpha 0 }; 
	};
} forEach ZCS_var_BlackList;

ZCS_fnc_FindSpawnPos = {
	params ["_playerBuildings"];
		
	private _tries = 0;
	private _foundPosition = [];

	while { count _playerBuildings > 0 && count _foundPosition == 0 && _tries < 10 } do {
		_tries = _tries + 1;
		private _building = selectRandom _playerBuildings;
		_playerBuildings deleteAt (_playerBuildings find _building); // Remove it from the list
		//_playerBuildings = _playerBuildings - [_building]; // Remove it from the list
		
		private _buildingPosList = _building buildingPos -1;
		
		if (count _buildingPosList > 0) then {		
			private _tooClose = (allPlayers findIf { _x distance _building < ZCS_var_MinDist }) >= 0;
			
			if (!_tooClose && (ZCS_var_BlackList findIf {getPos _building inArea _x} < 0)) exitWith {
				_foundPosition = selectRandom _buildingPosList;
			};
		};
	};
	
	if ZCS_var_Debug then { diag_log text format["[ZCS] DEBUG - FindSpawnPos: Found %1 after %2 attempts.", _foundPosition, _tries] };

	_foundPosition
};

ZCS_fnc_FindDestPos = {
	params ["_unit"];

	private _foundPosition = [];
	private _tries = 0;
	private _unitPos = getPosAtl _unit;
	
	if (random 100 > 50) then {
		// Pick a building
		_buildings = nearestObjects [_unitPos, ["house"], ZCS_var_MaxDist];
		
		while { count _buildings > 0 && count _foundPosition == 0 && _tries < 10 } do {
			_tries = _tries + 1;
			
			private _building = selectRandom _buildings;
			private _buildings = _buildings - [_building];
			private _buildingPosList = _building buildingPos -1;
									
			if (count _buildingPosList > 0 && (ZCS_var_BlackList findIf {getPos _building inArea _x} < 0)) exitWith {
				_foundPosition = selectRandom _buildingPosList;
			};
		};
	} else {
		// Get a random position
		while { count _foundPosition == 0 && _tries < 10 } do {
			_tries = _tries + 1;
			
			private _pos = _unitPos getPos [random 200, random 360];
			if (!isOnRoad _pos && !surfaceIsWater _pos && (ZCS_var_BlackList findIf {_pos inArea _x} < 0)) exitWith {
				_foundPosition = _pos;
			};
		};
	};	
	
	if ZCS_var_Debug then { diag_log text format["[ZCS] DEBUG - FindDestPos: %1 found %2 after %3 attempts.", _unit, _foundPosition, _tries] };
	
	_foundPosition
};

ZCS_fnc_NearBuildings = {
	// Get all player positions and find any good buildings within the max range.
	private _buildings = [];
	
	{
		{	
			_buildings pushBackUnique _x;			
		} forEach ((nearestObjects [_x, ["house"], ZCS_var_MaxDist]) select { count (_x buildingPos -1) > 0 });
	} forEach allPlayers;
	
	// Remove all buildings that are inside a blacklist marker
	{
		_bPos = getPos _x;
		if (ZCS_var_BlackList findIf {_bPos inArea _x} >= 0) then { _buildings deleteAt _forEachIndex };
	} forEach _buildings;
		
	_buildings
};

ZCS_fnc_DressUnit = {
	// Assigns a unit a random selection of items from ZCS_var_UnitGear.
	params ["_unit"];
	
	ZCS_var_UnitGear params [["_head",[],[[]]], ["_glasses",[],[[]]], ["_uniform",[],[[]]], ["_vest",[],[[]]], ["_backpack",[],[[]]], ["_items",[],[[]]]];
	
	{
		_x params [["_classes",[]],["_classTree","CfgWeapons"]];
		
		if (count _classes == 0) exitWith {};
		
		private _item = selectRandom _classes;
		
		if (isNil "_item") then { _item = "" };
		
		if (!(isClass (configFile >> _classTree >> _item)) && {_item != ""}) then {
			diag_log text format["[ZCS] WARNING - DressUnit: Invalid gear type '%1'", _item];
			_item = "";
		};
		
		switch _forEachIndex do {
			case 0: { removeHeadgear _unit; if (_item != "") then { _unit addHeadgear _item }; };
			case 1: { removeGoggles _unit; if (_item != "") then { _unit addGoggles _item } };
			case 2: { removeUniform _unit; if (_item != "") then { _unit forceAddUniform _item } };
			case 3: { removeVest _unit; if (_item != "") then { _unit addVest _item } };
			case 4: { removeBackpack _unit; if (_item != "") then { _unit addBackpack _item } };
			case 5: { if (_item != "") then { _unit addItem _item } };
		};
	} forEach [
		[_head],
		[_glasses,"CfgGlasses"],
		[_uniform],
		[_vest],
		[_backpack,"CfgVehicles"],
		[_items]
	];
};

ZCS_fnc_SpawnUnit = {
	params [["_pos",[]]];
	
	if (_pos isEqualTo []) exitWith { objNull };
	
	private _unit = createAgent [selectRandom ZCS_var_UnitClass, [0,0,0], [], 0, "NONE"];
	
	[_unit] spawn ZCS_fnc_DressUnit;
	
	_unit addEventHandler ["killed",{
		private _killer = if (isNull (_this#2)) then { (_this#0) getVariable ["ace_medical_lastDamageSource", (_this#1)] } else { (_this#2) };
		
		if (isPlayer _killer) then { 
			missionNamespace setVariable ["ZCS_var_deadCivCount", (missionNamespace getVariable ["ZCS_var_deadCivCount",0])+1,true]; 
			missionNamespace setVariable ["ZCS_var_EnemyChance", (missionNamespace getVariable ["ZCS_var_EnemyChance",0.05])+0.2, true];
			missionNamespace setVariable ["ZCS_var_BomberChance", (missionNamespace getVariable ["ZCS_var_BomberChance",0.005])+0.05, true];
			
			if (ZCS_var_LOWTasks) then {
				format["%1 (%2) killed Civilian (%3)",name _killer,groupId group _killer,name (_this select 0)] remoteExec ["systemChat",0];
				
				// Create Parent Task
				if !(["ZCS_TSK_PARENT"] call BIS_fnc_taskExists) then {
					_task = ["ZCS_TSK_PARENT", TRUE, ["The <font color='#72E500'>Laws of War</font> are a set of international rules that set out what can and cannot be done during an armed conflict.<br/><br/>The main purpose of international humanitarian law is to maintain some humanity in armed conflicts, saving lives and reducing suffering.", "Laws of War", ""], nil, "CREATED", 1, false, true, "meet"] call BIS_fnc_setTask;
				};
				
				// Create Player Sub-Task
				if !([format["ZCS_TSK_%1", name _killer]] call BIS_fnc_taskExists) then {
					_task = [[format["ZCS_TSK_%1", name _killer], "ZCS_TSK_PARENT"], TRUE, [format["Disciplinary charges are to be preferred against <font color='#72E500'>%1</font> due to breaches of international humanitarian law.<br/><br/>Their dangerous conduct has resulted in the the deaths of non-combatant personnel during the mission.", name _killer], [name _killer], ""], nil, "CREATED", 1, true, true, "danger"] call BIS_fnc_setTask;
				};
			};
		};
	}];

	_unit addEventHandler["firedNear",{
		(_this#0) playMoveNow selectRandom ["ApanPknlMstpSnonWnonDnon_G01","ApanPpneMstpSnonWnonDnon_G01"]; // ApanPercMstpSnonWnonDnon_G01 ?
		(_this#0) setSpeedMode "FULL";
		(_this#0) setDestination [((_this#0) getPos [350, random 360]), "LEADER PLANNED", true];
		(_this#0) removeAllEventHandlers "firedNear";
	}];
		
	ZCS_Count = ZCS_Count + 1;
	_unit setVehicleVarName "ZCS_CIV_" + str ZCS_Count;

	_unit setPos _pos;
	
	{ _x addCuratorEditableObjects [[_unit],true] } forEach allCurators;
	
	_unit
};

ZCS_fnc_SpawnHunter = {
	params [["_pos",[]]];
	
	if (_pos isEqualTo []) then {
		_pos = [[] call ZCS_fnc_NearBuildings] call ZCS_fnc_FindSpawnPos;
	};
	
	private _huntPlayer = selectRandom (allPlayers select { alive _x && vehicle _x == _x });
	 
	if(isNil "_huntPlayer") exitWith { objNull };

	private _enemyGroup = createGroup [if (side group _huntPlayer getFriend WEST < 0.6 && WEST countSide allGroups > 0) then { WEST } else { if (side group _huntPlayer getFriend EAST < 0.6 && EAST countSide allGroups > 0) then { EAST } else { INDEPENDENT }; }, true];
	
	private _hunter = (createGroup [civilian, true]) createUnit [selectRandom ZCS_var_UnitClass, [0,0,0], [], 0, "FORM"];
	[_hunter] joinSilent _enemyGroup; // BugFix - createUnit group is ignored?
	
	[_hunter] call ZCS_fnc_DressUnit;
	
	selectRandom [["hgun_Rook40_F","16Rnd_9x21_Mag"],["hgun_Pistol_heavy_01_F","11Rnd_45ACP_Mag"],["SMG_05_F","30Rnd_9x21_Mag_SMG_02"],["hgun_PDW2000_Holo_F","30Rnd_9x21_Mag"],["SMG_02_ACO_F","30Rnd_9x21_Mag_SMG_02"],["SMG_03C_TR_khaki","50Rnd_570x28_SMG_03"]] params ["_weapon", "_ammo"];
	uniformContainer _hunter addItemCargo ["HandGrenade", 1];
	uniformContainer _hunter addItemCargo ["HandGrenade", 1];
	if (random 1 <= 0.9) then {
		uniformContainer _hunter addMagazineCargo [_ammo, 3];
		_hunter addWeapon _weapon;
	};
	_hunter setCombatMode "RED";
	_hunter setBehaviour "AWARE";
	
	_hunter setPos _pos;
	{ _x addCuratorEditableObjects [[_hunter],true] } forEach allCurators;

	[_enemyGroup, group _huntPlayer] spawn BIS_fnc_Stalk;
	
	_hunter
};

ZCS_fnc_SpawnBomber = {
	params [["_pos",[]]];

	if (_pos isEqualTo []) then {
		_pos = [[] call ZCS_fnc_NearBuildings] call ZCS_fnc_FindSpawnPos;
	};
	
	private _huntPlayer = selectRandom (allPlayers select { alive _x && vehicle _x == _x });
	 
	if(isNil "_huntPlayer") exitWith { objNull };
	
	private _enemyGroup = createGroup [if (side group _huntPlayer getFriend WEST < 0.6 && WEST countSide allGroups > 0) then { WEST } else { if (side group _huntPlayer getFriend EAST < 0.6 && EAST countSide allGroups > 0) then { EAST } else { INDEPENDENT }; }, true];
	
	private _bomber = ( createGroup [civilian, true]) createUnit [selectRandom ZCS_var_UnitClass, [0,0,0], [], 0, "FORM"];
	[_bomber] joinSilent _enemyGroup; // BugFix - createUnit group is ignored?
	
	[_bomber] spawn ZCS_fnc_DressUnit;
	_bomber addBackpack selectRandom ["B_Messenger_Black_F","B_Messenger_Gray_F"];
	
	private _ied1 = "DemoCharge_Remote_Ammo" createVehicle [0,0,0];
	private _ied2 = "DemoCharge_Remote_Ammo" createVehicle [0,0,0];
	private _ied3 = "DemoCharge_Remote_Ammo" createVehicle [0,0,0];

	_ied1 attachTo [_bomber, [-0.1,0.1,0.15],"Pelvis"];
	[_ied1, [[0.5,0.5,0],[-0.5,0.5,0]]] remoteExec ["setVectorDirAndUp", _bomber];

	_ied2 attachTo [_bomber, [0,0.15,0.15],"Pelvis"];
	[_ied2, [[1,0,0],[0,1,0]]] remoteExec ["setVectorDirAndUp", _bomber];

	_ied3 attachTo [_bomber, [0.1,0.1,0.15],"Pelvis"];
	[_ied3, [[0.5,-0.5,0],[0.5,0.5,0]]] remoteExec ["setVectorDirAndUp", _bomber];
	
	_bomber setBehaviour "CARELESS";
	_bomber setPos _pos;
	{ _x addCuratorEditableObjects [[_bomber],true] } forEach allCurators;
	
	_bomber addEventHandler ["killed",{ { deleteVehicle _x } forEach attachedObjects (_this#0) }];

	[_enemyGroup, group _huntPlayer] spawn BIS_fnc_Stalk;
	
	[_bomber] spawn {
		params ["_unit"];
		
		waitUntil { sleep 1; playSound3D ["A3\sounds_f\sfx\beep_target.wss", _unit, false, getPosASL _unit, 1, 0.5, 100]; (!alive _unit || allPlayers findIf { alive _x && _unit distance _x < 5 } >= 0) };

		if(random 1 > 0.2) then {
			_exp = "HelicopterExploSmall" createVehicle (getPos _unit);
			_exp attachTo [_unit,[-0.02,-0.07,0.042],"rightHand"];
		};
	};
	
	_bomber
};

sleep 0.5;

// Internal Counter
ZCS_Count = 0;
ZCS_CivList = []; // Items of type [unit, destination pos, last pos, isMoving, nextActionTime, isRunning].
ZCS_var_Running = true;

while { ZCS_var_Running } do {
	private _playerBuildings = [] call ZCS_fnc_NearBuildings;
	private _unitsCount = ceil (ZCS_var_UnitsPerBuilding * count _playerBuildings);
	if (_unitsCount > ZCS_var_MaxGrpCount) then { _unitsCount = ZCS_var_MaxGrpCount; };

	if (count ZCS_CivList < _unitsCount) then {
		private _pos = [_playerBuildings] call ZCS_fnc_FindSpawnPos;
		private _newUnit = objNull;
		
		if (_pos isEqualTo []) exitWith {}; // No valid position
		
		private _spawnClose = ["respawn_east","respawn_west","respawn_guerrila","respawn_civilian"] findIf { getMarkerPos _x distance _pos < 1000 } > 0;
		
		if !(_spawnClose) then {
			_newUnit = if (random 1 <= ZCS_var_EnemyChance) then {
				if ( random 1 <= ZCS_var_BomberChance) then {
					[_pos] call ZCS_fnc_SpawnBomber;
				} else {
					[_pos] call ZCS_fnc_SpawnHunter;
				}
			} else {
				[_pos] call ZCS_fnc_SpawnUnit;
			};
		};
		
		if (!isNull _newUnit) then {
			ZCS_CivList pushBack [_newUnit, [], getPos _newUnit, false, time, random 1 < ZCS_var_RunChance];
		};
		
		sleep 0.1;
	};
	
	{
		_x params ["_unit"];	
		
		if (allPlayers findIf { _x distance _unit < ZCS_var_MaxDist } < 0) then {
			_unit removeAllEventHandlers "killed";
			_unit removeAllEventHandlers "firedNear";
			deleteVehicle _unit;
		};
		
		if (!alive _unit) then { ZCS_CivList deleteAt _forEachIndex };
		
		sleep 0.1;
	} forEach ZCS_CivList;
	
	{
		_x params ["_unit", "_destinationPos", "_lastPos", "_isMoving", "_nextActionTime", "_isRunning"];

		// If civilian has reached its destination or we've been waiting too long
		if ((_isMoving && _lastPos distance getPos _unit < 1) || _nextActionTime > time + (ZCS_var_WaitTime * 2)) then {
			private _nextActionTime = time + random ZCS_var_WaitTime;
			
			_x set [3, false]; // Set isMoving = false
			_x set [4, _nextActionTime]; // Next action time
		};
		
		// If it is time for civilian to move
		if ((!_isMoving || surfaceIsWater _lastPos) && time > _nextActionTime) then {
			private _destPos = [_unit] call ZCS_fnc_FindDestPos;
			if (count _destPos > 0) then {
				_unit setDestination [_destPos, "LEADER PLANNED", true];
				_unit setBehaviour "SAFE";
				_isRunning = random 1 < ZCS_var_RunChance;
				
				_x set [1, _destPos]; // Set destinationPos
				_x set [3, true]; // Set isMoving
				_x set [5, _isRunning]; // Set isRunning
			};
			
			if ZCS_var_Debug then { diag_log text format["[ZCS] DEBUG - NewDestSet: %1 is %2 to %3", _unit, ["walking","running"] select _isRunning, _destPos] };
		};
		
		_unit forceSpeed (if _isRunning then { -1 } else { 1 });

		_x set [2, getPos _unit];
	} forEach ZCS_CivList select { side _x == Civilian };
	
	if (diag_tickTime - (missionNamespace getVariable ["ZCS_var_LastCheck",0]) > 300) then {
		if (ZCS_var_EnemyChance > 0.05) then { missionNamespace setVariable ["ZCS_var_EnemyChance", (ZCS_var_EnemyChance - 0.05) max 0.05, true ] };
		if (ZCS_var_BomberChance > 0.005) then { missionNamespace setVariable ["ZCS_var_BomberChance", (ZCS_var_BomberChance - 0.01) max 0.005, true] };
		ZCS_var_LastCheck = diag_tickTime;
	};

	sleep 5;
};