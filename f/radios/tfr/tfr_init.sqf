// Load in TFAR Radio Settings
#include "..\..\..\mission\radios.sqf";

// Compile TFAR relevant functions
f_fnc_tfr_addRadios = compileFinal preprocessFileLineNumbers "f\radios\tfr\fn_tfr_addRadios.sqf";
f_fnc_tfr_aiHearing = compileFinal preprocessFileLineNumbers "f\radios\tfr\fn_tfr_aiHearing.sqf";

if hasInterface then { execVM "f\radios\tfr\tfr_clientInit.sqf"; };