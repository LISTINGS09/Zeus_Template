// F3 - SetTime
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================
if !isServer exitWith {};

// Player is JIP so time will be synced automatically.
params [["_timeOfDay",0]];

// DECLARE VARIABLES AND FUNCTIONS
private ["_year","_month","_day","_transition","_hour","_minute","_time","_sunrise","_sunset","_sunsetSunrise"];

// f_var_timeOfDay also used in fn_TidyGear and f_setWeather
if (_timeOfDay == 0) exitWith { missionNamespace setVariable ["f_var_timeOfDay", daytime, true] };

// SET DEFAULT VALUES
// The default values that together form the in-game date are set.
_year = 2030;
_month = 6;
_day = 16;
_sunrise = [4,40];
_sunset = [19,10];

// CALCULATE SUNSET/SUNRISE
// Ensure dawn and dusk don't happen in the dark during different seasons and at different latitudes
_sunsetSunrise = [_year,_month,_day,0,0] call BIS_fnc_sunriseSunsetTime;

if !(_sunsetSunrise in [[-1,0],[0,-1]]) then {
	_sunrise = [floor (_sunsetSunrise select 0), floor (((_sunsetSunrise select 0) % 1) * 60)];
	_sunset = [floor (_sunsetSunrise select 1), floor (((_sunsetSunrise select 1) % 1) * 60)];
};

// function for correcting adding hours and minutes to hours and minutes
_addTime = {
    params ["_timeStart","_minutes"];
    _result = [_timeStart,[0,_minutes]] call BIS_fnc_vectorAdd;
	
	// Balance additional minutes
    while { _result select 1 > 60 } do {
        _result set [1,(_result select 1) - 60];
        _result set [0,(_result select 0) + 1];
    };
	
	// Balance negative minutes.
	while { _result select 1 < 0 } do {
        _result set [1,(_result select 1) + 60];
        _result set [0,(_result select 0) - 1];
    };
		
    // make sure hour is in range [0,23]
    _result set [0,(_result select 0) % 24];
    if (_result select 0 < 0) then {
        _result set [0,(_result select 0) + 24];
    };
    _result
};

// SELECT MISSION TIME OF DAY
//Picks a random value from the existing f_param_timeOfDay values (if 0 not present)
private _paramsTime = getArray (missionConfigFile >> "Params" >> "f_param_timeOfDay" >> "values");	
if (!(0 in _paramsTime) && count _paramsTime > 0) then { _time = selectRandom _paramsTime };

// Using the value of _timeOfDay, we define new values for _hour and _minute.
_time = switch (_timeOfDay) do {
	// 60m to Sunrise
	case 1: { [_sunrise,-60] call _addTime; };	
	// 30m to Sunrise
	case 2: { [_sunrise,-30] call _addTime; };
	// Sunrise
	case 3: { _sunrise; };
	// Early Morning 30m after Sunrise
	case 4: { [_sunrise,30] call _addTime; };
	// Morning 90m after Sunrise
	case 5: { [_sunrise,60] call _addTime; };
	// Late Morning
	case 6: { [9,0]; }; 
	// Noon
	case 7:{ [12,0]; }; 
	// Afternoon
	case 8:{ [15,0]; }; 
	// Late Afternoon (60m To Last Light)
	case 9: { [_sunset,-60] call _addTime; };	
	// Evening (30m To Last Light)
	case 10: { [_sunset,-30] call _addTime; };	
	// Sunset
	case 11: { _sunset; };	
	// Night
	case 12:{ [22,15]; }; 
	// Midnight
	case 13: { [0,0]; };
	// Random
	case 14:{ [floor random 23.9,floor random 60]; };
};

// VR Daytime
if (worldName == "VR") then { _time = [12,0] };

_time params ["_hour","_minute"];

[[_year,_month,_day,_hour,_minute],true,false] call BIS_fnc_setDate;

["f_setTime.sqf",format["Time set to %1:%2", _hour, _minute],"INFO"] call f_fnc_logIssue;

missionNamespace setVariable ["f_var_timeOfDay", _hour, true];

setTimeMultiplier (missionNamespace getVariable ["f_param_timeMultiplier", 1]);
