// F3 - TFR Clientside Initialisation
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

["tfr_clientInit.sqf",format["Running for %1",player],"INFO"] call f_fnc_logIssue;

private _sideSRGroups = [];
private _sideLRGroups = [];

{
	_x params ["_grpID","_grpName","_icon","_sName","_color",["_customCh",""]];
	_sideSRGroups pushBack [_grpName,[_grpName]];
	
	// If custom LR channel was previously defined in the loop.
	if (_customCh != "") then {
		private _newChannel = true;
		{
			if (_customCh isEqualTo (_x select 0)) exitWith { _newChannel = false; };
		} forEach _sideLRGroups;
	
		// Does a new LR channel need added?
		if _newChannel then { _sideLRGroups pushBack [_customCh, [_grpName]]; };
	};
} forEach (missionNamespace getVariable [format["f_var_groups%1", side group player], []]);

if (count _sideLRGroups == 0) then { 
	// Convert default LR strings to correct array format.
	{
		if (_x isEqualType "") then { _sideLRGroups pushBack [_x,[]]; };
	} forEach f_radios_settings_longRangeGroups;
};

private _playerSRindex = -1;
private _playerLRindex = 0;

{
	if (groupId (group player) in (_x select 1)) exitWith {_playerSRindex = _forEachIndex;};
} forEach _sideSRGroups;

{
	if (groupId (group player) in (_x select 1)) exitWith {_playerLRindex = _forEachIndex;};
} forEach _sideLRGroups;

// Signal Tab
if (isNil "f_tfar_breifingDone") then {
	[_sideSRGroups, _sideLRGroups, _playerSRindex, _playerLRindex] execVM "f\radios\tfr\tfr_briefing.sqf";
	f_tfar_breifingDone = true;
};

// WAIT FOR TFR
// Give TFR some time to initialise

sleep 3;

// Check player is alive
if (alive player) then {
	// Remove any existing radios added.
	{ private _isRadio = _x call TFAR_fnc_isRadio; if(_isRadio) then {player unlinkItem _x}; } forEach items player;
	{ private _isRadio = _x call TFAR_fnc_isRadio; if(_isRadio) then {player unlinkItem _x}; } forEach assignedItems player;

	// Wait for gear assign and radio freqs to take place
	waitUntil{(player getVariable ["f_var_assignGear_done", false])};
	
	// Configure spectator chat
	[player, false] call TFAR_fnc_forceSpectator;

	// Add radios to each unit
	[] call f_fnc_tfr_addRadios;
} else {
	// No need to fix radios, just move into spectator chat
	[player, true] call TFAR_fnc_forceSpectator;
};


