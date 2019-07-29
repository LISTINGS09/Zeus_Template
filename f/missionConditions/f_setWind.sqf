// F3 - SetWeather
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================
params [["_wind",0]];

if (!isServer || isNil "_wind") exitWith {};

// SELECT MISSION WIND

// ACE SETTINGS
// ACE_WIND_PARAMS = [currentDirection, directionChange, currentSpeed, speedChange, transitionTime];

0 setWaves (_wind / 10);
setWind [_wind,random _wind];

f_param_wind = _wind;
publicVariable "f_param_wind";

["f_setWind.sqf",format["Wind %1", _wind],"INFO"] call f_fnc_logIssue;