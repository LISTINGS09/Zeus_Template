/* taskConvoy.sqf
By Wolfenswan [FA]: wolfenswanarps@gmail.com | folkarps.com
Thanks to Norrin's convoy script for inspiration and guidance: http://forums.bistudio.com/showthread.php?152279-norrin-s-ArmA2-scripts-ported-to-ArmA3
You can find a video tutorial here: http://youtu.be/_aELNA7j__c

FEATURE
The passed vehicles will follow the given route to it's destination, where they will disembark and take sentry waypoints.
The convoy will follow any given path and dismount on enemy contact.

RETURNS
true once convoy has reached the destination or made contact

USAGE
Place an ungrouped selection of vehicles. All trailing vehicles should share the name of the leading vehicle followed by _n, where n is an incrementing number (e.g.: veh, veh_1, veh_2).
Place markers indicating the convoy route, ideally on roads. All markers should share the name of the first marker followed by _n, where n is an incrementing number (e.g.: mkr, mkr_1, mkr_2).
You can change which waypoint type the units will be assigned on dismounting below as _finalWP

Minimal:
[[vehicle1,vehicle2],"firstMarker"] execVM "scripts\taskConvoy.sqf";

Full:
[[vehicle1,vehicle2],"firstMarker",speedLimit] execVM "scripts\taskConvoy.sqf";

PARAMETERS
1. The vehicles 																					 	| MANDATORY - object
2. The first marker indicating the convoy route (all other markers should share the naming template) 	| MANDATORY - can be marker, object or positional array
3. Speed limit in km/h (the slower the more reliably the convoy will move) 								| OPTIONAL - any number (default: 14)

EXAMPLE
[[c1,c2,c3,c4,c5],"cvwp"] execVM "scripts\taskConvoy.sqf"; - All vehicles provided would follow the route indicated by the markers sharing the "cvwp"-name ("cvwp","cvwp_1","cvwp_2"...)
[[V1,V2,V3,V4,V5,V6,V7],"wp"] execVM "scripts\taskConvoy.sqf";
*/
if !isServer exitWith {};

sleep 1;

params [["_convoy",[]],["_marker",""],["_speedLimit",30],["_spacing",50]];

// What waypoint-type the final/combat waypoint will be. Sentry or Hold work best
_finalwp = "GUARD";

// Exit the script if any of the required variables is invalid
if (count _convoy == 0 || _marker == "") exitWith {};

_leadv = _convoy#0;

if (!local _leadv) exitWith {};

// Collect the Markers
_waypoints = [];

{
	if ([_marker, _x] call BIS_fnc_inString) then {
	   _waypoints pushBack _x;
	};
} forEach allMapMarkers;

_run = true;

// Check if the convoy is in a condition to move at all
if (({!canMove _x || !alive _x} count _convoy) > 0) then {_run = false};

// Setup convoy mode
{
	group _x setBehaviour "SAFE";
	group _x setSpeedMode "LIMITED";
	[leader _x] orderGetIn true; // RHS FFV - https://dev.cup-arma3.org/T1367
	_speed = getNumber (configFile >> "CfgVehicles" >> typeOf _x >> "maxSpeed");
	if (_speed < _speedLimit) then { _speedLimit = _speed };
} forEach _convoy;

// Set the found speed limit
{
	_x forceSpeed _speedLimit;
	_x limitSpeed _speedLimit;
} forEach _convoy;

_vRear = objNull;

{
	_leader = leader _x;
	_notFront = _forEachIndex > 0;
	_vRear = _x;
	{
		_wp = group _leader addWaypoint [getMarkerPos _x, 0];
		if (_notFront) then { _wp setWaypointCompletionRadius 100 };
		_wp setWaypointType "MOVE";
		_wp setWaypointBehaviour "SAFE";
		_wp setWaypointSpeed "LIMITED";
	} forEach _waypoints;
} forEach _convoy;

diag_log text format["[CNV] Found %1 wps for %2 vehicles - Speed %3", count _waypoints, count _convoy, _speedLimit];
systemChat format["[CNV] Found %1 wps for %2 vehicles - Speed %3", count _waypoints, count _convoy, _speedLimit];

// As long as the convoy isn't threatened, keep it moving
while {_run} do {
	{
		_v = _x;
		
		_vFront = if (_forEachIndex - 1 >= 0) then { _convoy select (_forEachIndex - 1) } else { objNull };
		_vBack = if (_forEachIndex + 1 < count _convoy) then { _convoy select (_forEachIndex + 1) } else { objNull };

		// Set the destination for the leading vehicle
		if (_v == _leadv) then {
			_wp =  (_waypoints select 0);

			if (_v distance _vBack > _spacing || _v distance _vRear > ((_spacing * count _convoy) + 50)) then {
				_v forceSpeed (_speedLimit - 10);
				_v limitSpeed (_speedLimit - 10);
				systemChat format["[CNV] Lead [%1] - Slowing: %2kmh (%3)", _v, speed _v, _speedLimit];
				
				_vm = velocityModelSpace _v;
				_vm set [1,(_vm#1) * 0.9];
				_v setVelocityModelSpace _vm;
				
			} else {
				_v forceSpeed _speedLimit;
				_v limitSpeed _speedLimit;
				
				systemChat format["[CNV] Lead [%1] - Normal: %2kmh (%3)", _v, speed _v, _speedLimit];
			};
		} else {
			if (_v distance _vFront < _spacing) then {
				_vm = velocityModelSpace _v;
				
				if (_v distance _vFront < (_spacing / 2)) then {
					if (_v distance _vFront < 10) then {
						_vm set [1,(_vm#1) * 0.1];
						_v setVelocityModelSpace _vm;
					} else {
						_vm set [1,(_vm#1) * 0.5];
						_v setVelocityModelSpace _vm;
					};
				} else {
					if (speed _v > _speedLimit) then {
						_vm set [1,(_vm#1) * 0.9];
						_v setVelocityModelSpace _vm;
					};
				};
			};
		};
	} forEach _convoy;

	// If convoy was engaged exit the loop and set the convoy to combat mode
	if (({!canMove _x || !alive _x || (!isNull (_x findNearestEnemy (getPosATL _x)))} count _convoy) > 0) then {
		_run = false;
		{
			group (driver _x) setBehaviour "COMBAT";
			group (driver _x) setSpeedMode "NORMAL";	
			//_units = if (!canFire) then { fullCrew 
		} forEach _convoy;
		diag_log text "[CNV] Convoy Stopped - Switching to Combat";
	};

	sleep 0.5;
};

// Once the convoy has reached the destination or is being engaged have all groups which aren't crew disembark
{
	_v = _x;
	_grp = group _x;

	if (!canFire _v) then {
		// Transport Vehicle
		_grp leaveVehicle _v;
		
		if (random 1 > 0.4) then { _smoke = selectRandom["SmokeShellYellow","SmokeShell","SmokeShellBlue"] createVehicle (leader _grp getPos [2, random 360]) };
		
		_wp = _grp addWaypoint [_v getPos [25, random 360], 25];
		_wp setWaypointBehaviour "COMBAT";
		_wp setWaypointType "MOVE";
		_grp setCurrentWaypoint _wp;
		
		_wp = _grp addWaypoint [getPos _v, 25];
		_wp setWaypointBehaviour "AWARE";
		_wp setWaypointType "GUARD";
	} else {
		// Armed vehicle
		_wp = _grp addWaypoint [getPos _v, 25];
		_wp setWaypointBehaviour "AWARE";
		_wp setWaypointType "GUARD";
		_grp setCurrentWaypoint _wp;
		
		_newGrp = createGroup [side leader _grp, true];
		// Split non-essential crew
		{
			if (_v getCargoIndex _x >= 0) then { [_x] joinSilent _newGrp };
		} forEach crew _v;
		
		if (count units _newGrp > 0) then {
			_newGrp leaveVehicle _v;
			
			_wp = _grp addWaypoint [_v getPos [25, random 360], 25];
			_wp setWaypointBehaviour "COMBAT";
			_wp setWaypointType "MOVE";
			_newGrp setCurrentWaypoint _wp;

			if (random 1 > 0.4) then { _smoke = selectRandom["SmokeShellYellow","SmokeShell","SmokeShellBlue"] createVehicle (leader _newGrp getPos [2, random 360]) };
			_wp = _newGrp addWaypoint [_v getPos [50, random 360], 25];
			_wp setWaypointBehaviour "COMBAT";
			_wp setWaypointType "GUARD";
			_newGrp setCurrentWaypoint _wp;
		} else { 
			deleteGroup _newGrp;
		};
	};
} forEach _convoy;