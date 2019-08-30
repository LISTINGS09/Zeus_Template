// F3 - Radio Framework initialisation
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================
waitUntil{!isNil "f_var_setParams"};
if (isNil "f_param_radios") exitWith { ["fn_radio_init.sqf","No radio parameters defined - Exiting","INFO"] call f_fnc_logIssue };

waitUntil{!isNil "f_var_setGroupsIDs";};
["fn_radio_init.sqf",format["Radio Starting: %1",f_param_radios],"DEBUG"] call f_fnc_logIssue;

// Load the radio settings
#include "..\..\mission\radios.sqf";

// If any radio system selected
// Check which system to use

if (f_param_radios == 1) exitWith { [] execVM "f\radios\tfr\tfr_init.sqf" };
if (f_param_radios == 2) exitWith { [] execVM "f\radios\acre2\acre2_init.sqf" };

[] execVM "f\radios\vanilla\vanilla_init.sqf";