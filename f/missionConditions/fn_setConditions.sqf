// F3 - SetWeather
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================

// RUN ONLY ON THE SERVER
// This function does never need to run on a client
if !isServer exitWith {};

f_fnc_setFog = compileFinal preprocessFileLineNumbers "f\missionConditions\f_setFog.sqf";
f_fnc_setWeather = compileFinal preprocessFileLineNumbers "f\missionConditions\f_setWeather.sqf";
f_fnc_setWind = compileFinal preprocessFileLineNumbers "f\missionConditions\f_setWind.sqf";
f_fnc_setTime = compileFinal preprocessFileLineNumbers "f\missionConditions\f_setTime.sqf";

waitUntil {!isNil "f_var_setParams"};

// Only run if TOD parameter has not been set.
if (isNil "f_var_timeOfDay") then {
	[missionNamespace getVariable ["f_param_timeOfDay",0]] call f_fnc_setTime;
	[missionNamespace getVariable ["f_param_fog",0]] spawn f_fnc_setFog;
	[missionNamespace getVariable ["f_param_weather",0]] call f_fnc_setWeather;
};