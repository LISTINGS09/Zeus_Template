// F3 - Caching Script Init
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/

// Wait for the mission to have launched before starting to cache.
sleep 0.1;

// Wait up to the desired time into the mission to give AI and players time to settle
waitUntil {time > 15};

// Check whether the parameter is defined (or caching switched off)) - if not, just exit
if (missionNameSpace getVariable ["f_param_caching",0] == 0 || !isMultiplayer || !isNil "DAC_Basic_Value") exitWith {};

// Player and the headless client's (if present) groups are always excluded from being cached
if (!isDedicated && !(group player getVariable ["f_cacheExcl", false])) then {
        (group player) setVariable ["f_cacheExcl", true, true];
};

// Rest of the Script is only run server-side
if !isServer exitWith {};

// Set up functions.
f_fnc_cTracker = compileFinal preprocessFileLineNumbers "f\cache\fn_cTracker.sqf";
f_fnc_gCache = compileFinal preprocessFileLineNumbers "f\cache\fn_gCache.sqf";
f_fnc_gUncache = compileFinal preprocessFileLineNumbers "f\cache\fn_gUncache.sqf";
f_fnc_nearPlayer = compileFinal preprocessFileLineNumbers "f\cache\fn_nearPlayer.sqf";

// Make sure script is only run once
if (missionNameSpace getVariable ["f_cInit", false]) exitWith {};
f_cInit = true;

// All groups with playable units or DS are set to be ignored as well
{
	if ({ _x in playableUnits || _x in switchableUnits } count units _x > 0 || dynamicSimulationEnabled _x) then {
		if !(_x getVariable ["f_cacheExcl", false]) then {
			_x setVariable ["f_cacheExcl", true, true];
		};
	};
} forEach allGroups;

// Define parameters
_range = f_param_caching;	// The range outside of which to cache units
f_var_cacheSleep = 6; 		// The time to sleep between checking
f_var_cacheRun = true;

[_range] spawn f_fnc_cTracker;

// Start the debug tracker
if (missionNamespace getVariable["f_param_debugMode",0] == 1) then {
	systemChat format ["f_fnc_cInit DBG: Starting to track %1 groups, %2 range, %3 sleep",count allGroups,_range,f_var_cacheSleep];
	diag_log text format ["f_fnc_cInit DBG: Starting to track %1 groups, %2 range, %3 sleep",count allGroups,_range,f_var_cacheSleep];

	[] spawn {
		// Giving the tracker a head start
		sleep (f_var_cacheSleep * 1.1);

			while {f_var_cacheRun} do {
				_str1 = "f_fnc_cache:<br/>";
				_str2 = format["Total Groups: %1<br/>",count allGroups];
				_str3 = format ["Cached:%1<br/>",{_x getVariable "f_cached"} count allGroups];
				_str4 = format ["Activated:%1<br/>",{!(_x getVariable "f_cached")} count allGroups];
				_str5 = format ["Excluded:%1<br/>",{(_x getVariable "f_cacheExcl")} count allGroups];

				hintSilent parseText (_str1+_str2+_str3+_str4+_str5);
				diag_log (_str1+_str2+_str3+_str4+_str5);

				sleep f_var_cacheSleep;
			};
	};
};