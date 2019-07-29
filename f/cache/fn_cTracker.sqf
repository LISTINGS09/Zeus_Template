// F3 - Caching Script Tracker
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================
if !isServer exitWith {};

// DECLARE VARIABLES AND FUNCTIONS
private ["_range","_groups","_debug"];
params["_range"];
_groups = allGroups;

_debug = if (missionNamespace getVariable["f_param_debugMode",0] == 1) then [{true},{false}];

// BEGIN THE TRACKING LOOP
While {f_var_cacheRun} do {
	{
		if (!isNull _x) then {
			_exclude = _x getVariable ["f_cacheExcl",false];
			_cached = _x getVariable ["f_cached", false];
			
			if (!_exclude) then {
				if (_cached) then {
					if ([leader _x, _range] call f_fnc_nearPlayer) then {
						if (_debug) then {
							systemChat format ["[Cache] Activating: %1",_x];
						};
						
						_x setVariable ["f_cached", false];
						_x spawn f_fnc_gUncache;
					};
				} else {
					if !([leader _x, _range * 1.1] call f_fnc_nearPlayer) then {
						if (_debug) then {
							systemChat format ["[Cache] De-Activating: %1",_x];
						};
						
						_x setVariable ["f_cached", true];
						[_x] spawn f_fnc_gCache;
					};
				};
			};
		};
	} forEach allGroups;

	sleep f_var_cacheSleep;
};

// If the caching loop is terminated, uncache all cached groups
{
	if (_x getVariable ["f_cached", false]) then {
		_x spawn f_fnc_gUncache;
		_x setVariable ["f_cached", false];
	};
} forEach allGroups;