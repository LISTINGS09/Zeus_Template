//  AI Paradrop Script - Spawns a vehicle and drops AI Soldiers
//  Version: 0.1
//  Author: 2600K
//	_nul = [thisTrigger] execVM "scripts\paradrop.sqf";
//
if !isServer exitWith {};

scriptName "paradrop.sqf";

params ["_location","_startPos"];

_side = EAST;
_man = ["O_T_Soldier_F","O_T_Soldier_LAT_F","O_T_Soldier_GL_F","O_T_Soldier_AR_F"];
_vehicle = selectRandom [
	["B_T_VTOL_01_infantry_F","[_grpVeh,['Blue',1]] call BIS_fnc_initVehicle;"]
	//"O_Heli_Light_02_unarmed_F",
	//["O_Heli_Transport_04_bench_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;"],
	//["O_T_VTOL_02_infantry_dynamicLoadout_F","[_grpVeh,['Grey',1]] call BIS_fnc_initVehicle;"]
];

_groupMax = 99; // Maximum para groups
_groupSize = 8; // Units number per para group

// Return the location for a marker or object
_location = switch (typeName _location) do { case "STRING": { getMarkerPos _location }; case "OBJECT": { getPos _location }; default { _location }; };
_location set [2,0];

_startPos = if (!isNil "_startPos") then {
		switch (typeName _startPos) do {
			case "STRING": { getMarkerPos _startPos};
			case "OBJECT": { getPos _startPos};
		};
	} else { _location getPos [3000, random 360] };

// Split out init from class.
_init = "";
if (_vehicle isEqualType []) then { _init = _vehicle # 1; _vehicle = _vehicle # 0 };

_grpVeh = createVehicle [_vehicle, _startPos, [], 0, "FLY"];

_dirTo =  _grpVeh getDir _location;
_dirFrom =  (_grpVeh getDir _location) + 180;

_grpVeh setDir _dirTo;
//_grpVeh flyInHeight 200;

// Run the custom init 
if !(_init isEqualTo "") then { call compile _init; };

createVehicleCrew _grpVeh;
(group effectiveCommander _grpVeh) deleteGroupWhenEmpty true;

// Convert crew if using another sides vehicle.
if (([getNumber (configFile >> "CfgVehicles" >> _vehicle >> "Side")] call BIS_fnc_sideType) != _side) then {
	_grp = createGroup [_side, true];
	(crew _grpVeh) join _grp;
};

_grp = group effectiveCommander _grpVeh;

// Find the number of seats we can hold
_cargoMax = ([_vehicle, true] call BIS_fnc_crewCount) - ([_vehicle, false] call BIS_fnc_crewCount);

if (_cargoMax < 1) exitWith { systemChat "No space for infantry cargo!" };




// Create Para Group
_paraList = [];
_cargoLeft = _cargoMax;

// Work out how many groups we can have without overfilling the vehicle.
for [{_i = 0}, {_i <= ceil (_cargoMax / _groupSize)}, {_i = _i + 1}] do {
	if (_cargoLeft - _groupSize >= _groupSize) then {
		_paraList set [_i,_groupSize];
	} else {
		// Only part of a group can be added, if its worth adding include it.
		if (_cargoLeft > 2) then {
			_paraList set [_i,_groupSize];
		};
	};
	
	_cargoLeft = _cargoLeft - _groupSize;
};

// If there are more groups than allowed, remove them.
if (count _paraList > _groupMax) then { _paraList resize _groupMax };

systemChat format["[PARA] Groups are: %1",_paraList];

// Create the groups and store them in a variable
_grpVehVar = [];
_grpVehCount = 0;

{
	_paraUnits = [];	
	for [{_i = 1}, {_i <= _x}, {_i = _i + 1}] do { _paraUnits pushBack (selectRandom _man) };

	_grpPara = [[0,0,0], _side, _paraUnits] call BIS_fnc_spawnGroup;

	{ _x moveInAny _grpVeh } forEach units _grpPara;
	
	_wp = _grpPara addWaypoint [_location, 0];
	_wp setWaypointType 'SAD';
	_wp = _grpPara addWaypoint [_location, 0];
	_wp setWaypointType 'GUARD';
	
	sleep 0.5;

	_grpVehVar pushBack _grpPara;
	
	_grpVehCount = _grpVehCount + _x;
} forEach _paraList;

_grpVeh setVariable ['var_dropGroup', _grpVehVar];

// Set pilot wayPoints
_wp = _grp addWaypoint [_startPos, 0];
_wp setWaypointType "MOVE";
_wp setWaypointSpeed "FULL";
_wp setWaypointBehaviour "CARELESS";
_wp setWaypointStatements ["true","(vehicle this) setPilotLight true;"];

// Set Pilots wayPoints

_dropStart = _location getPos [_grpVehCount * 25, _dirFrom];
_tmp = createMarkerLocal ["dropStart", _dropStart];
_tmp setMarkerTypeLocal "mil_dot";
_tmp setMarkerTextLocal "Start";

_wp = _grp addWaypoint [_dropStart, 0];
_wp setWaypointType "MOVE";
_wp setWaypointStatements ["true","
	(vehicle this) spawn {
		{
			{
				unassignVehicle _x;
				[_x] orderGetIn false;
				moveOut _x; 
				sleep 0.5;
				_pc = createVehicle ['Steerable_Parachute_F', (getPosATL _x), [], 0, 'NONE'];
				_pc setPosATL (getPosatl _x);
				_vel = velocity _pc;
				_dir = random 360;
				_pc setVelocity [(_vel#0) + (sin _dir * 10),  (_vel#1) + (cos _dir * 10), (_vel#2)];
				_x moveinDriver _pc;
			} forEach (units _x);
			sleep 1;
		} forEach (_this getVariable ['var_dropGroup',[]]);
	};
"];

_dropDelete = _location getPos [3000, _dirTo];
_wp = _grp addWaypoint [_dropDelete, 0];
_wp setWaypointType "MOVE";
_wp setWaypointCompletionRadius 500;
_wp setWaypointStatements ["true","_delVeh = (vehicle this); { deleteVehicle (_x#0) } forEach (fullCrew _delVeh); deleteVehicle _delVeh; deleteGroup (group this);"];