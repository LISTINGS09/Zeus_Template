// Compile TFAR relevant functions
f_fnc_tfr_addRadios = compileFinal preprocessFileLineNumbers "f\radios\tfr\fn_tfr_addRadios.sqf";

if hasInterface then { execVM "f\radios\tfr\tfr_clientInit.sqf"; };