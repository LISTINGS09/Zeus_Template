//
//  Urban Patrol Script Zeus Edition
//  Version: 1.9
//  Author: 2600K & Kronzky (www.kronzky.info / kronzky@gmail.com)
//  BIS Forum: http://forums.bistudio.com/showthread.php?147904-Urban-Patrol-Script&highlight=Urban+Patrol+Script
//
//  Required parameters:
//    unit          = Unit to patrol zone
//    markername    = Name of marker/trigger that covers the active zone
//
//  Optional parameters: 
//    RANDOM        = Start unit at random position in zone
//    NOWP        	= Unit will hold position until enemy is spotted
//    NOFOLLOW      = Unit will only follow an enemy within the marker zone.
//    NOSLOW        = Keep default behaviour/speed of unit (don't change to "safe" and "limited").
//    NOAI          = Don't use enhanced AI for skills, evasive and flanking manoeuvres.
//    SHOWMARKER    = Display the zone marker.
//    TRACK         = Display a position and destination marker for each unit.
//
//	  _nul = [this,"UPSZ","RANDOM"] execVM "scripts\UPS\UPS_Lite.sqf";
//
if !isServer exitWith {};

// Global Script Variables
_cycle = 10; 		// Script Cycle Time (seconds)
_safeDist = 200; 	// How far to move when under attack in meters
_closeEnough = 50; 	// WP Completion Radius
_shareDist = 400; 	// AI Comms Range in meters
_alertTime = 300; 	// AI Alert after spotting enemy
_artyTime = 300;	// Arty delay between firing
_artyRural = 100;	// Arty dispersion in rural areas
_artyUrban = 50;	// Arty dispersion in urban areas
_unitSkill = [['aimingAccuracy',0.25],['aimingShake',0.15],['aimingSpeed',0.05],['commanding',1],['courage',1],['general',1],['reloadSpeed',1],['spotDistance',1],['spotTime',0.85]]; // Average AI

if (isNil "ZAI_Debug") then { ZAI_Debug = false }; // Disable debug mode if not set

// Message Logging Function
_ZAI_fnc_LogMsg = {
	params [["_lev", ""], ["_msg", ""]];
	if (ZAI_Debug || _lev != "DEBUG") then { 
		systemChat format["UPS %1: %2",_lev, _msg];
		diag_log text format["[UPS] %1: %2",_lev, _msg];
	};
};

// Group Tasking Function
_ZAI_fnc_setGroupVariable = {
	params ["_grp","_type","_tsk"];
	_grpID = _grp getVariable ["ZAI_ID", -1];
	_grp setVariable [format["ZAI_%1", toUpper _type], _tsk];
	if (_type == "Task") then { _grp setGroupIdGlobal [format["ZAI_%1_%2_%3", _grpID, _tsk, waypointBehaviour [_grp, currentWaypoint _grp]]]};
	//["DEBUG", format["[%1] Set Variable %2: %3", _grpIDx, _type, _tsk]] call _ZAI_fnc_LogMsg;
};

// We need a group and marker as minimum
if (count _this < 2) exitWith {
	if (format["%1",_this]!="INIT") then {
		["ERROR", "Unit and marker name have to be defined!"] call _ZAI_fnc_LogMsg;
	};
};

// Convert params to UPPER CASE
_params = [];
{ if ( _x isEqualType "" ) then { _params pushBack (toUpper _x) } } forEach _this;

params ["_grp", "_areaMarker"];

if (isNil "_areaMarker") exitWith { ["ERROR", "Area marker not defined. Typo, or name not enclosed in quotation marks?"] call _ZAI_fnc_LogMsg };	

private ["_areaName","_areaSize"];

if (_areaMarker isEqualType "") then {
	_areaName = _areaMarker;
	_areaSize = getMarkerSize _areaMarker;
	if !("SHOWMARKER" in _params) then { _areaMarker setMarkerAlpha 0; };
} else {
	_areaName = vehicleVarName _areaMarker;
	_areaSize = triggerArea _areaMarker;
};

if (_areaSize#0 == 0 || count _areaSize == 0) exitWith { ["ERROR", format["Invalid Marker/Trigger: %1",_areaName]] call _ZAI_fnc_LogMsg };

// Minimum WP distance
_minDist = (_areaSize#0 + _areaSize#1) / 4;

// Wait until mission start to continue
sleep 3 + random 3;

// Update instance counter.
missionNamespace setVariable ["ZAI_ID", (missionNamespace getVariable ["ZAI_ID", 0]) + 1];

if (isNil "_grp") exitWith { ["ERROR", format["Invalid Object %1", _grp]] call _ZAI_fnc_LogMsg };
if (_grp isKindOf "Logic") exitWith { ["ERROR", format["Logic Passed: %1", _grp]] call _ZAI_fnc_LogMsg };
if (_grp isEqualType objNull) then { _grp = group _grp };
if ({alive _x} count units _grp == 0) then { ["ERROR", format["No living units in %1", _grp]] call _ZAI_fnc_LogMsg };

if ((_grp getVariable ["ZAI_ID", -1]) > 0) exitWith { ["ERROR", format["UPS Already Active on %1", _grp]] call _ZAI_fnc_LogMsg };

// give this group a unique index
_grpIDx = str ZAI_ID;
_grp setGroupId [format["ZAI_%1_%2", side _grp, _grpIDx]];
_grp setVariable ["ZAI_ID", ZAI_ID];
_grp setVariable ["ZAI_AREA", _areaName];

missionNamespace setVariable [format ["ZAI_%1_%2", side _grp, _grpIDx], _grp];

_grpVehicle = objNull;
{ 
	if (!isNull assignedVehicle _x) then { _grpVehicle = vehicle _x };
} forEach units _grp;

// What type of "vehicle" is unit ?
_isAir = _grpVehicle isKindOf "air";
_isBoat = _grpVehicle isKindOf "ship";
_isCar = _grpVehicle isKindOf "car";
_isTank = _grpVehicle isKindOf "tank" || _grpVehicle isKindOf "armored";
_isArty = if (!isNull _grpVehicle) then { "Artillery" in getArray (configFile >> "CfgVehicles" >> typeOf _grpVehicle >> "availableForSupportTypes") } else { FALSE }; 
_isStatic = _grpVehicle isKindOf "staticWeapon" || _grpVehicle isKindOf "static";
_isMan = !_isAir && !_isBoat && !_isCar && !_isTank && !_isStatic && !_isArty;

if (!isNull _grpVehicle && _isMan) then { ["WARNING", format["[%1] was an unknown vehicle type", typeOf _grpVehicle]] call _ZAI_fnc_LogMsg; };
if (!isNull _grpVehicle) then { _grp selectLeader driver _grpVehicle; [leader _grp] orderGetIn true; };

_grpType = ([(["","Man"] select _isMan), (["","Air"] select _isAir), (["","Ship"] select _isBoat), (["","Vehicle"] select _isCar), (["","Armoured"] select _isTank), (["","Static"] select _isStatic), (["","Artillery"] select _isArty) ] - [""]);
_grp setVariable ["ZAI_Type", _grpType apply { toUpper _x }];
_grp setVariable ["ZAI_Vehicle", _grpVehicle];
["DEBUG", format["[%1] was detected as %2", groupID _grp, _grpType  joinString ", "]] call _ZAI_fnc_LogMsg;

if _isAir then { _closeEnough = 1000 }; // Tolerance high for choppers & planes
//if _isStatic then { [_grp, "Task", "STATIC"] call _ZAI_fnc_setGroupVariable; }; // Statics won't be tasked.

// check to see whether group is neutral (for attack and avoidance manoeuvres)
_isSoldier = FALSE;
{
	if (side _grp getFriend _x < 0.6) exitWith { _isSoldier = TRUE };
} forEach [EAST, WEST, INDEPENDENT, CIVILIAN];

_alliedUnitList = [];

if _isSoldier then {
	{
		if ([side _x, side _grp] call BIS_fnc_areFriendly) then { _alliedUnitList pushBack _x };
	} forEach allUnits;
};

_alliedUnitList = _alliedUnitList - (switchableUnits + playableUnits) - (units _grp);

_noFollow = ("NOFOLLOW" in _params);
_noShare = ("NOSHARE" in _params);
_holdMove = ("NOMOVE" in _params || "NOWP" in _params);
if ("NOAI" in _params) then {_isSoldier = FALSE } else {
	{
		_ai = _x;
		_ai setSkill 1;
		_ai allowFleeing 0;
		{ _ai setSkill _x } forEach _unitSkill;
	} forEach units _grp;
};

if (_holdMove) then { [_grp, "Task", "HOLD"] call _ZAI_fnc_setGroupVariable; };

if (!_holdMove && !("NOSLOW" in _params)) then {
	_grp setBehaviour "SAFE"; 
	_grp setCombatBehaviour "SAFE";
	_grp setSpeedMode "LIMITED";
	_grp setCombatMode "YELLOW";
	{ _x setUnitPos "AUTO" } forEach units _grp;
};

// Set random pos if required.
_unitPos = getPos leader _grp;
if ("RANDOM" in _params) then {
	if (dynamicSimulationEnabled _grp) then { 
		// Disable temporarily to allow moving the units
		_grp enableDynamicSimulation false;
		if (!isNull _grpVehicle && !_isStatic) then { 
			_grp spawn { sleep 30; _this enableDynamicSimulation true; };
		};
	};
	
	// Find a random position (try a max of 20 positions)
	_randPos = _unitPos;

	_choosePos = TRUE;
	_counter = 0;
	while {_choosePos} do {
		_counter = _counter + 1;
		_randPos = [_areaMarker] call BIS_fnc_randomPosTrigger;
		
		// If no mines are nearby check agains the type.
		if (isNull (nearestObject [_randPos, "MineGeneric"])) then {
			if (_isAir) exitWith { _choosePos = FALSE };
			if (_isBoat && surfaceIsWater _randPos) exitWith { _choosePos = FALSE };
			if (!surfaceIsWater _randPos) exitWith { _choosePos = FALSE };
		};
		
		// Just exit if we've been searching too long.
		if (_counter > 25) then { _choosePos = FALSE };
	};
	
	_randPos = [_randPos, 1, 50, 2, 0, 0, 0, [], [_unitPos,_unitPos]] call BIS_fnc_findSafePos;
	
	// Put vehicle to a random spot
	if (!isNull _grpVehicle && !_isStatic) then {
		_vehArray = (units _grp apply { assignedVehicle _x }) - [objNull];		
		_randPos = [_randPos, 1, 250, round ((sizeOf (typeOf _grpVehicle)) / 2), 0, 0, 0, [], [_randPos,_randPos]] call BIS_fnc_findSafePos;
		
		// Get all assigned vehicles & move them to a safe location.
		{ 
			_roads = _randPos nearRoads 250;
			
			if (count _roads > 0 && (_isCar || _isTank)) then {
				_x setVehiclePosition [getPos (selectRandom _roads), [], 25, "NONE"]; 
			} else {
				_x setVehiclePosition [_randPos, [], 50, "NONE"]; 
			};
			
			_randPos = getPos _x;
			//_tempPos = [_randPos, 1, 250, round ((sizeOf (typeOf _grpVehicle)) / 2), 0, 0, 0, [], [_randPos,_randPos]] call BIS_fnc_findSafePos;
			//if (count _tempPos > 0) then { _x setPos _tempPos } else { _x setPos _randPos };
		} forEach (_vehArray arrayIntersect _vehArray);
	};
	
	// Move anyone over 25m away to the area.
	{ 
		if (_x distance2D _randPos > 25 && vehicle _x == _x) then { 
			_x setVehiclePosition [_randPos, [], 5, "NONE"]; 
			//_x setPos ([_randPos, 1, 50, 1, 1, 0, 0, [], [_randPos,_randPos]] call BIS_fnc_findSafePos) 
		};
	} forEach units _grp;
};

// track unit
_trackGrp = ("TRACK" in _params || ZAI_Debug);
if (_trackGrp) then {
	_grp addGroupIcon ["o_inf"];
	_grp setgroupIconParams [[side _grp, false] call BIS_fnc_sideColor,_grpIDx,0.8,TRUE];
	
	if !ZAI_Debug exitWith {};
	
	addMissionEventHandler ["GroupIconOverEnter", {
		params [
			"_is3D", "_group", "_waypointId",
			"_posX", "_posY",
			"_shift", "_control", "_alt"
		];
		
		_fnc_MarkDot = { 
			params ["_name","_pos","_color"];
			_mkr = createMarkerLocal [_name, _pos];
			_mkr setMarkerShapeLocal "ICON";
			_mkr setMarkerTypeLocal "MIL_DOT";
			_mkr setMarkerColorLocal _color;
			_mkr setMarkerSizeLocal [.8,.8];
		};
		
		_fnc_MarkLine = {
			params ["_name","_from","_to","_color"];
			_la = createMarkerLocal [_name, _from];
			_la setMarkerShapelocal "RECTANGLE";
			_la setMarkerColorlocal _color;
			_ld = ((_from distance _to) / 2);
			_lr = ((_to#0) - (_from#0)) atan2 ((_to#1) - (_from#1));
			_lp = [(_from#0) + (Sin (_lr) * _ld),(_from#1) + (Cos (_lr) * _ld),0];
			_la setMarkerSizelocal [_ld,1];
			_la setMarkerPosLocal _lp;
			_la setMarkerDirlocal (_lr - 90);
		};
		
		//_sideColor = [side _group, true] call BIS_fnc_sideColor;
		_wp = (wayPoints _group) select (currentWaypoint _group);
		
		_text = format["<br/><t size='1.25' font='TahomaB' color='#72E500'>%1 Group</t><br/>",groupId _group];
		
		_text = _text + format["%1 Units - %2", {alive _x } count units _group, (_group getVariable ["ZAI_Type", []]) joinString ", "];
		_text = _text + "<t align='left'>";
		_text = _text + format["Task: %1 (%2)<br/>",_group getVariable ["ZAI_Task", "-"], if (_group getVariable ["ZAI_WaitTime", time] >= time ) then { (_group getVariable ["ZAI_WaitTime", time]) - time } else { "-" }];
		_text = _text + format["Combat: %1<br/>", combatMode leader _group];
		_text = _text + format["Behaviour: (%1/%2)<br/>",_group getVariable ["ZAI_Behaviour", "-"], behaviour leader _group];
		_text = _text + format["Speed: (%1/%2)<br/>",_group getVariable ["ZAI_Speed", "-"], speedMode leader _group];
		_text = _text + format["Nearest Enemy: %1 (%2)<br/>",if (isNull (_group getVariable ["ZAI_EnemyUnit", objNull])) then { "None" } else { _group getVariable "ZAI_EnemyUnit" }, _group knowsAbout (_group getVariable ["ZAI_EnemyUnit", objNull])];
		_text = _text + format["Attack Pos: %1<br/>",_group getVariable ["ZAI_EnemyPos", []]];
		_text = _text + "<br/>";
		
		if (!isNil "_wp") then {
			_text = _text + format["Current WP (#%1)<br/>Type: %2<br/>Combat: %3<br/>Speed: %4<br/>", (currentWaypoint _group), waypointType _wp, waypointBehaviour _wp, waypointSpeed _wp];
		};
		_text = _text + "</t><br/><br/>";
		_text = _text + "<br/>";
		
		_lastPos = getPos leader _group;
		
		// Draw out wayPoints
		{
			_x params ["_grp","_wpID"];
			
			_color = switch (waypointBehaviour _x) do {
				case "CARELESS": { "ColorWhite" };
				case "SAFE": { "ColorGreen" };
				case "AWARE": { "ColorOrange" };
				case "COMBAT": { "ColorRed" };
				case "STEALTH": { "ColorBlue" };
				default { "ColorBlack" };
			};
			
			[format["gIcon_wp_dot_%1", _forEachIndex], getWPPos _x, _color] call _fnc_MarkDot;
			[format["gIcon_wp_line_%1", _forEachIndex], _lastPos, getWPPos _x, _color] call _fnc_MarkLine;

			_lastPos = getWPPos _x;
		} forEach (wayPoints _group select { _x#1 >= (currentWaypoint _group) });
		
		// Draw attack position
		if !(_group getVariable ["ZAI_EnemyPos", []] in [[],[0,0,0]]) then {
			_pos = _group getVariable ["ZAI_EnemyPos", []];
			["gIcon_at_dot",_pos,"ColorRed"] call _fnc_MarkDot;
			["gIcon_at_line",getPos leader _group,_pos,"ColorRed"] call _fnc_MarkLine;
		};
			
		hintSilent parseText _text;
	}];

	addMissionEventHandler ["GroupIconOverLeave", { { deleteMarkerLocal _x; } forEach (allMapMarkers select { ["gIcon_",_x] call BIS_fnc_inString }); hintSilent "" }];
};	

// UPS Loop Common Variables
_lastDamage = 0;
_lastCount = 0;
_lastTime = 0;
_lastPos = _unitPos;

_grp deleteGroupWhenEmpty TRUE; // Don't keep the group when empty.

// ************************************************ MAIN LOOP ************************************************

_currCycle = _cycle;

while {TRUE} do {
	if (isNil "_grp") exitWith { ["DEBUG", format["[%1] Exiting - Null Group", _grpIDx]] call _ZAI_fnc_LogMsg }; // Group was deleted?
	if (units _grp select { alive _x } isEqualTo []) exitWith { ["DEBUG", format["[%1] Exiting - All Dead!", _grpIDx]] call _ZAI_fnc_LogMsg; }; // No-one is alive.
	if ({isPlayer _x} count units _grp > 0) exitWith { _grp selectLeader ((units _grp select { isPlayer _x })#0); }; // Player is in the group, make them lead and exit.

	_wasHit = FALSE;
	
	_grpLeader = leader _grp;
	
	// Check for damage to group
	_newDamage = 0; 
	{
		if (damage _x > 0.2) then {
			_newDamage = _newDamage + (damage _x); 
			// Increased since last check
			if (_newDamage > _lastDamage) then {
				["DEBUG", format["[%1] Taken Damage (%2/%3)", _grpIDx, _newDamage, _lastDamage]] call _ZAI_fnc_LogMsg;
				_lastDamage = _newDamage;
				_wasHit = TRUE;
				_currCycle = 1;
			};
		};
	} forEach units _grp;
	
	// groups current position
	_unitPos = getPos _grpLeader;
		
	_foundEnemy = _grpLeader findNearestEnemy _unitPos;
	
	// Enemy was detected plan attack route
	if (_grpLeader distance2D _foundEnemy < _shareDist) then {
	
		// Final location depends of knowsAbout of enemy.
		_enemyOffset = (21 - ((_grp knowsAbout _foundEnemy) * 5)) * 5;
		_attackPos = _foundEnemy getPos [random _enemyOffset, random 360];
		_attackPos set [2,0];
		
		// If no existing arty calls, request one.
		if ({ _x distance _attackPos < _safeDist } count (missionNamespace getVariable [format["ZAI_%1_ArtyQueue", side _grp],[]]) == 0) then { 
			missionNamespace setVariable [format["ZAI_%1_ArtyQueue", side _grp],(missionNamespace getVariable [format["ZAI_%1_ArtyQueue", side _grp],[]]) + [_attackPos]];
		};
		
		// Send to other non-infantry allies in range.
		if (!_noShare && _grp knowsAbout _foundEnemy >= 1.5) then {
			{
				_kbType = (group _x) getVariable ["ZAI_Type",[]];
				_kb = switch (true) do {
					case ("VEHICLE" in _kbType): { 2 };
					case ("ARMOURED" in _kbType): { 3 };
					case ("STATIC" in _kbType): { 3 };
					case ("AIR" in _kbType): { 4 };
					default { 1.5 };
				};
				
				if (_x knowsAbout _foundEnemy < _kb) then {
					["DEBUG", format["[%1] Revealing %2 to %3 (%4 to %5)", _grpIDx, _foundEnemy, group _x, _x knowsAbout _foundEnemy, _kb]] call _ZAI_fnc_LogMsg;
					(group _x) reveal [_foundEnemy, _kb];
				};
			} forEach (_alliedUnitList select { 
				alive _x &&
				local _x &&
				((_x distance _foundEnemy < _shareDist) || "STATIC" in (_x getVariable ["ZAI_Type",[]])) &&
				leader _x == _x && 
				(_grp getVariable ["ZAI_AREA", _areaName]) == _areaName
			});
		};
		
		// Recently reacted, enemy going too fast or too far
		if (time < _lastTime || (getPosATL _foundEnemy) # 0 > 25) exitWith {};

		["DEBUG", format["[%1] Spotted %2 - %3m", _grpIDx, name _foundEnemy, round (_grpLeader distance2D _foundEnemy)]] call _ZAI_fnc_LogMsg;
		
		// In contact with target so request an immediate fire mission at target position.
		if (_wasHit) then {
			_grp enableAttack true; // Re-enable attack orders if they were disabled.
			 
			// If infantry were shot, return fire
			if (_isMan) then {
				{ 
					_x setUnitPosWeak "DOWN";
					_x doWatch _foundEnemy;
					if (random 1 > 0.5) then { sleep 1; _x selectWeapon "throw"; _x forceWeaponFire ["SmokeShellMuzzle","SmokeShellMuzzle"] };
				} forEach units _grp;
				
				(selectRandom units _grp) suppressFor (10 + random 10);
			};
		};
					
		_lastTime = time + _alertTime; // Update delay timer.
		
		// Don't order statics to move!
		if (_isStatic || !_isSoldier) exitWith {};
		
		// If waiting for contact, allow the group to move.
		_holdMove = FALSE;
				
		// If distance is shorter then safe distance, use that instead.
		_moveDist = _safeDist min (_grpLeader distance _foundEnemy);
		
		_avoidPos = _grpLeader getRelPos [_moveDist,(_grpLeader getRelDir _foundEnemy) - (90 + random 25 - random 25)]; // Left of Unit
		_flankPos = _foundEnemy getRelPos [_moveDist,(_foundEnemy getRelDir _grpLeader) + (90 + random 25 - random 25)]; // Left of Target
		
		_avoidPosR = _grpLeader getRelPos [_moveDist,(_grpLeader getRelDir _foundEnemy) + (90 + random 25 - random 25)]; // Right of Unit
		_flankPosR = _foundEnemy getRelPos [_moveDist,(_foundEnemy getRelDir _grpLeader) - (90 + random 25 - random 25)]; // Right of Target
				
		// Flank left or right.
		if (random 1 > 0.5) then { _avoidPos = _avoidPosR; _flankPos = _flankPosR };	
		
		// Find a suitable road nearby
		if (!isNull _grpVehicle) then {
			_avoidRoad = [_avoidPos, 100] call BIS_fnc_nearestRoad;
			if (!isNull _avoidRoad) then { _avoidPos = getPos _avoidRoad };
		
			_flankRoad = [_flankPos, 100] call BIS_fnc_nearestRoad;
			if (!isNull _flankRoad) then { _flankPos = getPos _flankRoad };
		};
		
		// Find a valid movement position
		_movePos = _avoidPos;
		{
			if (_x#0 inArea _areaMarker) exitWith { _movePos = _x#0 };
		} forEach (selectBestPlaces [_foundEnemy, _safeDist,"(6*hills + 2*forest + 4*houses + 1.5*meadow + 2*trees) - (1000*sea) - (100*deadbody)", 100, 5]);
				
		_evadeWPs = [_avoidPos, _flankPos, _attackPos];
		
		{ 
			// Remove any WPs on water
			if (surfaceIsWater _x) then { _evadeWPs deleteAt _forEachIndex };
		} forEach _evadeWPs;	
		
		// No WPs left, exit.
		if (count _evadeWPs == 0) exitWith {}; 
		
		// Remove movePos if on water
		if (surfaceIsWater _movePos) then { _movePos = selectRandom _evadeWPs };
		
		// Clear wayPoints	
		while {count wayPoints _grp > 1} do { deleteWaypoint ((wayPoints _grp)#0); sleep 0.5; };
		
		// Infantry in contact, fight directly or run.
		if (_wasHit && _isMan) then {
			if (count units _grp > 2) then {
				// Attack Enemy
				_wp = _grp addWaypoint [_attackPos, 0];
				_wp setWaypointType "SAD";
				_wp setWaypointSpeed "NORMAL";
				_wp setWaypointFormation "WEDGE";
				_grp setCurrentWaypoint _wp;
				_grp enableAttack true;
				
				[_grp, "Task", "ATTACK"] call _ZAI_fnc_setGroupVariable;
			} else {
				// Smoke and run
				_smoke = "SmokeShell" createVehicle (_grpLeader getPos [random 3, ( _attackPos getDir _grpLeader)]); 
				_wp = _grp addWaypoint [( _grpLeader getPos [_safeDist, ( _attackPos getDir _grpLeader)]), 0];
				_wp setWaypointSpeed "NORMAL";
				_wp setWaypointStatements ["true", "(group this) enableAttack true"];
				_wp setWaypointFormation "WEDGE";
				_grp setCurrentWaypoint _wp;
				_grp enableAttack false;
				{ doStop _x; _x doFollow _grpLeader } forEach units _grp; // Regroup
				
				[_grp, "Task", "RETREAT"] call _ZAI_fnc_setGroupVariable;
			};
		} else {
			// Follow a vector - Favour movement over direct attacks.
			// EVADE - Find a good position to move to.
			// FLANK - Relocate but do not move on enemy.
			// ATTACK - Directly attack.
			// ASSAULT - Flank and then move on enemy.
			_taskType = selectRandom ["EVADE","EVADE","FLANK","ATTACK","ASSAULT"];
			switch (_taskType) do {
				case "EVADE": {
					[_grp,"Task",_taskType] call _ZAI_fnc_setGroupVariable;
					_evadeWPs = [_movePos];
				};
				case "FLANK": {
					[_grp,"Task",_taskType] call _ZAI_fnc_setGroupVariable;
					_evadeWPs = _evadeWPs - [_attackPos];
				};
				case "ATTACK": {
					[_grp,"Task",_taskType] call _ZAI_fnc_setGroupVariable;
					_evadeWPs = _evadeWPs - [_avoidPos] - [_flankPos];
				};
				default {
					[_grp,"Task",_taskType] call _ZAI_fnc_setGroupVariable;
				};
			};
	
			// Issue each WP from array
			{
				_wp = _grp addWaypoint [_x, 0];
				_wp setWaypointType "MOVE";
				_wp setWaypointSpeed "NORMAL";
				_wp setWaypointBehaviour "AWARE";
				_wp setWaypointCompletionRadius (_closeEnough / 2);
				
				if (_isMan) then { _wp setWaypointFormation "WEDGE"; };
				
				if (_forEachIndex == 0) then { _grp setCurrentWaypoint _wp };
				if (_x isEqualTo _flankPos && !canFire (vehicle _grpLeader)) then { _wp setWaypointType "GETOUT"; _wp setWaypointStatements ["true", "{ unassignVehicle _x; [_x] orderGetIn false; } forEach units this;"]; };
				if (_x isEqualTo _attackPos) then { _wp setWaypointSpeed "NORMAL"; _wp setWaypointType "SAD"; };
			} forEach _evadeWPs;
			
			["DEBUG", format["[%1] Task %2 - %3 WPs added.", _grpIDx, _taskType, count _evadeWPs]] call _ZAI_fnc_LogMsg;
		};

		_lastTime = time + _alertTime; // Update delay timer.
	};
				
	// If we're active and can move, see if anyone needs help or we're out of Wps.
	if (!_isStatic && !_holdMove) then {
	
		// Find any ZAI groups in combat (ignore all other AIs)
		_combatArea = (_alliedUnitList findIf { side _grp == side _x && _grpLeader distance leader _x < (_shareDist * 2) && behaviour leader _x == "COMBAT" && alive leader _x } > 0);

		// Find new WP if we don't have one
		if ((count wayPoints _grp) - (currentWaypoint _grp) isEqualTo 0) then {	
			// find a new target that's not too close to the current position
			_newGrpPos = getPos _grpLeader;				
						
			_tries = 0;					
			while {(_unitPos distance2D _newGrpPos) < _minDist} do {
				_tries = _tries + 1;
				_tempPos = [_areaMarker] call BIS_fnc_randomPosTrigger;					
				_roads = (_tempPos nearRoads _safeDist) select { count (roadsConnectedTo _x) > 0};
				_water = surfaceIsWater _tempPos;
				
				// Air takes any location.
				if _isAir exitWith { _newGrpPos = _tempPos };
				
				// Boats need water.
				if (_water && _isBoat) exitWith { _newGrpPos = _tempPos };
				
				// Cars need a road
				if (!_water && (_isCar || _isTank) && !(_roads isEqualTo [])) exitWith { _newGrpPos = getPos (_roads#0) };
				
				// Infantry
				if (!_water && _isMan && !(_roads isEqualTo []) && random 1 > 0.5) exitWith { _newGrpPos = getPos (_roads#0) };
				if (!_water && _isMan) exitWith { _newGrpPos = _tempPos; };
				
				if (_tries > 25) exitWith { 
					["WARNING", format["[%1] Tried %2 times to find WP [%3]",_grpIDx, _tries, _grpType]] call _ZAI_fnc_LogMsg;
					_newGrpPos = _tempPos
				};
				
				sleep 0.1;
			};
			
			_newGrpPos set [2,0];
			
			["DEBUG", format["[%1] Found WP %2 %3m after %4 tries (Combat: %5)",_grpIDx, _newGrpPos, round (_unitPos distance2D _newGrpPos), _tries, (!isNull _foundEnemy || _combatArea )]] call _ZAI_fnc_LogMsg;

			_wp = _grp addWaypoint [_newGrpPos, 25];
			_wp setWaypointType (["MOVE","SAD"] select _isAir);
			_wp setWaypointCompletionRadius (_closeEnough / 2);
			
			_wp setWaypointCombatMode "YELLOW";
			_wp setWaypointFormation "FILE";
			_wp setWaypointBehaviour (["SAFE", "AWARE"] select (!isNull _foundEnemy || _combatArea ));
			_wp setWaypointSpeed (["LIMITED", "NORMAL"] select (!isNull _foundEnemy || _combatArea ));
			
			_grp setCurrentWaypoint _wp;
			
			if (isNull _foundEnemy || !_combatArea) then { [_grp, "Task", "PATROL"] call _ZAI_fnc_setGroupVariable };
			
			if ("Man" in _grpType) then { _grpLeader commandMove _newGrpPos; { doStop _x; _x doFollow _grpLeader } forEach units _grp; }; // Regroup
		} else {
			// Go alert if unit wanders into a hot area.
			if (_combatArea && combatBehaviour _grp == "SAFE") then {
				_grp setBehaviour "AWARE";
				_grp setCombatBehaviour "AWARE";
				_grp setSpeedMode "NORMAL";
			};
		};
	};
	
	// Artillery Support
	if _isArty then {					
		_artyQueue = missionNamespace getVariable [format["ZAI_%1_ArtyQueue", side _grp],[]];
		_artyRadius = 0;
		_artyTarget = [0,0,0];
		
		if (count _artyQueue == 0) exitWith {};
		
		if (!canFire _grpVehicle) exitWith { 
			_isArty = false;
			["DEBUG", format["[%1] Artillery Aborted (Gun Cannot Fire)", _grpIDx]] call _ZAI_fnc_LogMsg;
		};
		
		if (_lastTime > time) exitWith {
			["DEBUG", format["[%1] Artillery Waiting (Ready: %2s - Waiting: %3)", _grpIDx, _lastTime - time, count _artyQueue]] call _ZAI_fnc_LogMsg;
		};
		
		// Filter fire positions from any requests.
		{
			_artyRadius = if (_x distance (nearestBuilding _x) < 25) then { _artyUrban } else { _artyRural };
			_artyEntities = (_x nearEntities (_artyRadius - 50)) select { !isAgent teamMember _x && side _x in [WEST, EAST, INDEPENDENT, CIVILIAN] };
			
			_bluClose = { side _x in [side _grp, CIVILIAN] } count _artyEntities;
			_opfClose = { side _x != side _grp && side _x != CIVILIAN } count _artyEntities;

			// Valid Target - Exit loop
			if (_opfClose > 0 && _bluClose < _opfClose) exitWith {				
				_artyTarget = _x;
				["DEBUG", format["[%1] Artillery Target Found %2 (BLU: %3 OPF: %4)", _grpIDx, _artyTarget, _bluClose, _opfClose]] call _ZAI_fnc_LogMsg;
			};
			
			// Invalid Target
			_artyQueue = _artyQueue - [_x];
			["DEBUG", format["[%1] Artillery Removing %2 (BLU: %3 OPF: %4)", _grpIDx, _x, _bluClose, _opfClose]] call _ZAI_fnc_LogMsg;
		} forEach _artyQueue;
		
		// Update the queue list, removing any requests near the target area.
		missionNamespace setVariable [format["ZAI_%1_ArtyQueue", side _grp], (_artyQueue - (_artyQueue select { _x distance _artyTarget <= _artyRadius }))];
		
		if (_artyTarget isEqualTo [0,0,0]) exitWith { 
			_lastTime = time + 10;
			["DEBUG", format["[%1] Artillery Aborted - No Valid Targets", _grpIDx]] call _ZAI_fnc_LogMsg;
		};
		
		if !(_artyTarget inRangeOfArtillery [[_grpLeader], (getArtilleryAmmo [_grpVehicle] select 0)]) exitWith {
			_lastTime = time + 10;
			["DEBUG", format["[%1] Artillery Aborted - Invalid Range", _grpIDx]] call _ZAI_fnc_LogMsg;
		};

		["DEBUG", format["[%1] Artillery Mission Started %2", _grpIDx, _artyTarget]] call _ZAI_fnc_LogMsg;
		
		_tempSmoke = "SmokeShellRed" createVehicle (_artyTarget getPos [random 5, random 360]); 
		
		sleep 30;
		
		for "_i" from 1 to 6 do {
			_grpLeader commandArtilleryFire [(_artyTarget getPos [random _artyRadius, random 360]), (getArtilleryAmmo [vehicle _grpLeader] select 0), 1];
			["DEBUG", format["[%1] Artillery Mission Round Out (%2 of 6)", _grpIDx, _i]] call _ZAI_fnc_LogMsg;
			sleep 5 + random 10;
		};
		
		(vehicle _grpLeader) setVehicleAmmo 1;
		missionNamespace setVariable [format["ZAI_%1_ArtyRequest", side _grp], []];
		_lastTime = time + _artyTime;
	};

	// Check for any AI Issues!
	if (!_isStatic && !_holdMove && !dynamicSimulationEnabled _grp && !dynamicSimulationEnabled _grpVehicle) then {
		if ((_lastPos distance2D getPos _grpLeader) == 0 && !_wasHit) then {
			_lastCount = _lastCount + 1;
			
			// Vehicles
			if (!_isMan) then {
				if (_lastCount == 10) exitWith { 
					while {count wayPoints _grp > 0} do { deleteWaypoint ((wayPoints _grp)#0); sleep 0.5; };
					_wp = _grp addWaypoint [getPos _grpLeader, 0];
					["WARNING", format["[%1] Vehicle held for %2 cycles - Clearing WPs", _grpIDx, _lastCount]] call _ZAI_fnc_LogMsg;
				};
				if (_lastCount == 20) exitWith {
					vehicle _grpLeader setDamage 0;
					_grp leaveVehicle vehicle _grpLeader;
					["WARNING", format["[%1] Vehicle held for %2 cycles - Repairing", _grpIDx, _lastCount]] call _ZAI_fnc_LogMsg;
				};
				if (_lastCount == 30) exitWith {
					vehicle _grpLeader setFuel 0.05;
					_grp leaveVehicle vehicle _grpLeader;
					["WARNING", format["[%1] Vehicle held for %2 cycles - Abandoning", _grpIDx, _lastCount]] call _ZAI_fnc_LogMsg;
				};
			};
			
			// Infantry
			if (_isMan) then {
				if (_lastCount == 10) exitWith {
					while {count wayPoints _grp > 1} do { deleteWaypoint ((wayPoints _grp)#0); sleep 0.5; };
					["WARNING", format["[%1] Leader held for %2 cycles - Clearing WPs", _grpIDx, _lastCount]] call _ZAI_fnc_LogMsg;
				};
				if (_lastCount == 15) exitWith {
					{
						_x setPos ([getPos _x, 1, 25, 2, 0, 0, 0, [], [getPos _x, getPos _x]] call BIS_fnc_findSafePos);
					} forEach units _grp;
					["WARNING", format["[%1] Leader held for %2 cycles - Moving to SafePos", _grpIDx, _lastCount]] call _ZAI_fnc_LogMsg;
				};
				if (_lastCount MOD 5 == 0) then {
					(_grpLeader) selectWeapon primaryWeapon (_grpLeader);
					["WARNING", format["[%1] Leader held for %2 cycles - Resetting Weapon", _grpIDx, _lastCount]] call _ZAI_fnc_LogMsg;
				};
			};
		} else {
			_lastCount = 0;
		};
	};
	
	_lastPos = getPos _grpLeader;
	
	[_grp, "EnemyUnit", _foundEnemy] call _ZAI_fnc_setGroupVariable;
	[_grp, "EnemyPos", getPos _foundEnemy] call _ZAI_fnc_setGroupVariable;
	[_grp, "Behaviour", behaviour leader _grp] call _ZAI_fnc_setGroupVariable;
	[_grp, "Speed", speedMode _grp] call _ZAI_fnc_setGroupVariable;
	[_grp, "WaitTime", _lastTime] call _ZAI_fnc_setGroupVariable;
	
	// slowly increase the cycle duration after an incident
	if (_currCycle < _cycle) then { _currCycle = _currCycle + 0.5};
	sleep _currCycle;
};

["DEBUG", format["[%1] Loop Aborted!", _grpIDx]] call _ZAI_fnc_LogMsg;