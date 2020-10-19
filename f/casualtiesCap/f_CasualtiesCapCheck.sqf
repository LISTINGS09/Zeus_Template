// F3 - Casualties Cap
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
//
// [nil, 2] execVM "f\casualtiesCap\f_CasualtiesCapCheck.sqf";
// [west, {f_var_casualtyLimitHit = true;}] execVM "f\casualtiesCap\f_CasualtiesCapCheck.sqf"; // Alternative use with trigger.
if !isServer exitWith {};

sleep 1;

if (isNil "f_param_CasualtiesCap") then { f_param_CasualtiesCap = 80 }; // Percentage of casualties.
if (isNil "f_param_CasMinToStart") then { f_param_CasMinToStart = 16 };	// Minimum players needed to start checking.

params["_grpstemp",						// Side (e.g. BLUFOR), or group name(s) as string array (e.g. ["mrGroup1","myGroup2"])
		"_end",							// Ending or code to be executed on limit being hit.
       ["_pc", f_param_CasualtiesCap],	// Percentage of casualties, if not used the global parameter will be taken instead.
       ["_onlyPlayers",true],			// If only groups with a playable leader slot will be included (default is true)
       ["_faction",[]]];  				// What faction(s) to filter for if the first variable is a side  (e.g. ["blu_f"])
	   
if (isNil "f_fnc_updateCas") then { f_fnc_updateCas = compileFinal preprocessFileLineNumbers "f\casualtiesCap\fn_UpdateCasualties.sqf"; };
	   
sleep 10;

if (isNil "_grpstemp") then {
	private _west = WEST countSide allPlayers;
	private _east = EAST countSide allPlayers;
	private _guer = INDEPENDENT countSide allPlayers;
	
	_grpstemp = if (_west < _east) then { EAST } else { if ( _east < _guer ) then { INDEPENDENT } else { WEST } };
};
	   
// Don't start if we've low players
if (({ alive _x } count allPlayers) < f_param_CasMinToStart) then { 
	waitUntil { 
		sleep 30;
		diag_log text format ["[F3] INFO (f\casualtiesCap\f_CasualtiesCapCheck.sqf): Insufficient players (%1/%2)", ({ alive _x } count allPlayers), f_param_CasMinToStart, _grpstemp];
		({ alive _x } count allPlayers) >= f_param_CasMinToStart;
	};
};
	   
// Cap is disabled, so exit.
if (_pc == 0) exitWith {};

// COLLECT GROUPS TO CHECK
// If a side variable was passed we collect all relevant groups
private _grps = [];

// if the variable is any of the side variables use it to construct a list of groups in that faction.
if (_grpstemp isEqualType west) then {
	{
		if (_onlyPlayers) then {
			_grps = allGroups select { side _x == _grpstemp && leader _x in allPlayers };
		} else {
			_grps = allGroups select { side _x == _grpstemp };
		};
	} forEach allGroups;

	// Filter the selected factions
	if (count _faction > 0) then { _grps = _grps select { faction (leader _x) in _faction } };
} else {
	// Get the named groups.
	sleep 1;
	{
		_tempGrp = call compile format ["%1", _x];
		if (!isNil "_tempGrp") then { _grps pushBack _tempGrp };
	} forEach _grpstemp;
};

// FAULT CHECK
// 10 seconds into the mission we check if any groups were found. If not, exit with an error message
sleep 10;

if (count _grps == 0) exitWith {
	diag_log text format ["[F3] DEBUG (f\casualtiesCap\f_CasualtiesCapCheck.sqf): No groups found, _grpstemp = %1, _grps = %2",_grpstemp,_grps];
};

// CREATE STARTING VALUES
// A count is made of units in the groups listed in _grps.

private _started = 0;
{_started = _started + (count (units _x))} forEach _grps;

// DEBUG
if (missionNamespace getVariable["f_param_debugMode",0] == 1) then {
	diag_log text format ["[F3] DEBUG (f\casualtiesCap\f_CasualtiesCapCheck.sqf): %2_started = %1",_started,_grpstemp];
};

// CHECK IF CASUALTIES CAP HAS BEEN REACHED OR EXCEEDED
// Every 6 seconds the server will check to see if the number of casualties sustained
// within the group(s) has reached the percentage specified in the variable _pc. If
// the cap has been reached, the loop will exit to trigger the ending.
while {true} do {
	private _remaining = 0;
	private _rawLimit = false;

	// Calculate how many units in the groups are still alive
	{
		private _grp = _x;
		private _alive = {	alive _x && 
			!(_x getVariable ["ACE_isUnconscious", false]) &&
			(lifeState _x in ["HEALTHY","INJURED"])
		} count (units _grp); 
		
		_remaining = _remaining + _alive;
		
		// Check side counter isn't over the raw count, if true exit.
		if ((missionNamespace getVariable [format["f_var_casualtyCount_%1",side _grp], 0]) > _pc) then {_rawLimit = true};
	} forEach _grps;
	
	// DEBUG
	if (missionNamespace getVariable["f_param_debugMode",0] == 1) then {
		diag_log text format ["[F3] DEBUG (f_CasualtiesCapCheck.sqf): %1/%2 - %3/%4", _remaining, _started, round (((_started - _remaining) / _started) * 100), _pc];
	};

	if (_remaining == 0 || ((_started - _remaining) / _started) >= (_pc / 100) || _rawLimit) exitWith {};

	sleep 10;
};

sleep 5;

// Don't continue if the mission is finishing
if !(isNil "BIS_fnc_endMission_effects") exitWith {};

// END CASCAP
// Depending on input, either MPEnd or the parsed code itself is called
if (_end isEqualType 0) exitWith {
		diag_log text format ["[F3] INFO (f_CasualtiesCapCheck.sqf): End%1 Called.",_end];
		format["End%1",_end] call BIS_fnc_endMissionServer;
};

if (_end isEqualType {}) exitWith {
	diag_log text format ["[F3] INFO (f_CasualtiesCapCheck.sqf): End%1 Spawned.",_end];
	_end remoteExec["bis_fnc_spawn"];
};

diag_log text format ["[F3] WARNING (fn_CasualtiesCapCheck.sqf): Ending didn't fire, expecting code or scalar. _end = %1, typeName _end: %2", _end, typeName _end];