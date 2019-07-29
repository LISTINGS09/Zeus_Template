// F3 - Safe Start
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================
//	This script inits the Mission Timer and the Safe Start, has the server setup the publicVariable
//      while the client waits, sets units invincibility and displays hints, then disables it.

//Setup the variables
waitUntil{!isNil "f_var_setParams"};
if (isNil "f_param_safe_start") then {f_param_safe_start = 1;};

sleep 0.5;

// If the server time is greater than the Safe-Start time, exit.
if (time > (f_param_safe_start * 60) || f_param_safe_start < 1) exitWith {};

f_fnc_safety = compileFinal preprocessFileLineNumbers "f\safeStart\fn_safety.sqf";

// BEGIN SAFE-START LOOP
// If a value was set for the mission-timer, begin the safe-start loop and turn on invincibility

if (f_param_safe_start > 0) then {
	// The server will handle the loop and notifications
	if isServer then { [] execVM "f\safeStart\f_safeStartLoop.sqf"; };

	// Enable invincibility for players
	if hasInterface then { [true] call f_fnc_safety; };
};