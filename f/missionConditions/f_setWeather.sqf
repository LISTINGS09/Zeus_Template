// F3 - SetWeather
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================
params [["_weather",0],["_delay",0]];

if (!isServer || isNil "_weather") exitWith {};

waitUntil { !isNil "f_var_timeOfDay" }; // Wait until TOD is set.

// If weather is mission-defined exit.
if (_weather == 0) exitWith {};

// Preselect random weather
if (_weather == 7) then {
	//Picks a random value from the existing f_param_weather values (if 0 not present)
	private _paramsWeather = getArray (missionConfigFile >> "Params" >> "f_param_weather" >> "values");
	
	if (0 in _paramsWeather || count _paramsWeather == 0) then {
		// If its night and if we should make the night clear.
		_sunrise = 4;
		_sunset = 19;
		_sunsetSunrise = date call BIS_fnc_sunriseSunsetTime;

		if !(_sunsetSunrise in [[-1,0],[0,-1]]) then {
			_sunrise = floor (_sunsetSunrise select 0);
			_sunset = floor (_sunsetSunrise select 1);
		};
		
		if (f_var_timeOfDay < _sunrise || f_var_timeOfDay >= _sunset) then { 
			_weather = 1;
		} else {
			_weather = selectRandom [1,1,1,1,1,1,1,1,1,1,2,2,3,3,4,4,5,5,6];
		};
	} else {
		_weather = selectRandom _paramsWeather;
	};
};

// SELECT MISSION WEATHER
// Using the value of _weather, new weather conditions are set.

switch (_weather) do {
// Clear (Calm)
	case 1:
	{
		_delay setOvercast 0;
		[0.5] call f_fnc_setWind;
	};
// Light Cloud
	case 2:
	{
		_delay setOvercast 0.3;
		[1] call f_fnc_setWind;
	};
// Overcast
	case 3:
	{
		_delay setOvercast 0.5;
		_delay setRain 0;
		[2] call f_fnc_setWind;
	};
// Light Rain
	case 4:
	{
		_delay setOvercast 0.7;
		_delay setRain 0.3;
		[3] call f_fnc_setWind;
	};
// Rain
	case 5:
	{
		_delay setOvercast 0.9;
		_delay setRain 0.7;
		[4] call f_fnc_setWind;
	};
// Storm
	case 6:
	{
		_delay setOvercast 1;
		_delay setRain 1;
		_delay setLightnings 1;
		[6] call f_fnc_setWind;
	};
};

["f_setWeather.sqf",format["Weather %1 in %2s", _weather, _delay],"INFO"] call f_fnc_logIssue;

if (_delay == 0) then { forceWeatherChange };