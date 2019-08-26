// Stubborn Crew
// v1 02.02.2016
// Thanks to the gorgeous Wolfenswan @FA for initial code, modified by 2600K.
//
// FEATURE
// Vehicle crews will only bail when the vehicle damage is over 0.8 or the guns are destroyed.
//
// USAGE
// Globally checks units and sets all non-player side vehicles.
//
// EXAMPLE
// [] execVM "f\misc\f_stayInVehicle.sqf";
if !isServer exitWith {};
private ["_ignoreSides", "_vehicles"];

if (!isNil "DAC_Basic_Value") then {waitUntil {sleep 5;DAC_Basic_Value > 0}} else {sleep 30};

_ignoresides = [];

// Get list of sides to ignore.
{
	if !(side _x in _ignoreSides) then {
		_ignoreSides pushBack (side _x);
	};
} forEach playableUnits + switchableUnits;

//if (missionNamespace getVariable["f_param_debugMode",0] == 1) then {diag_log text format["[F3] DEBUG (fn_stayInVehicle.sqf): Ignoring: %1",_ignoreSides];};

_vehicles = [];

{
	if (canFire _x && !(side _x in _ignoreSides) && !(_x isKindOf "StaticWeapon")) then { _vehicles pushBack _x };
} forEach vehicles;

if (missionNamespace getVariable["f_param_debugMode",0] == 1) then {diag_log text format["[F3] DEBUG (fn_stayInVehicle.sqf): Found: %1 vehicles",count _vehicles];};

if (count _vehicles == 0) exitWith {};

{
	private ["_unitset", "_unit", "_damage"];
	_unitset = _x getVariable "z_stayIn";
	if (isNil "_unitset") then {
		_unit = _x;
		
		if (missionNamespace getVariable["f_param_debugMode",0] == 1) then {diag_log text format["[F3] DEBUG (fn_stayInVehicle.sqf): Processing vehicle: %1 (%2)",_unit,typeOf _unit];};
		
		_unit allowCrewInImmobile true;
		_unit setVariable ["z_stayIn",true];

		_x addEventHandler [ "Hit",
		{
			params["_unit"];
			_damage = getDammage _unit;

			 if (_damage > 0.8 || !(canFire _unit)) then {
				_unit allowCrewInImmobile false;
				{_x action ["eject", _unit];} forEach crew _unit;
				_unit removeEventHandler ["Hit",0];
			};
		}];
   };
} forEach _vehicles;