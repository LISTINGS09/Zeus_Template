// F3 - Set Group IDs
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================

if !isServer exitWith {};

// INCLUDE GROUP LIST
private _grpList = []; 

// Local function to name group ID or wait until it is created
_f_fnc_setGroupID = { 
	params["_side","_grpVar","_grpName","_mkrType","_mkrText","_mkrColor"];
	
	_grpList pushBack _this;
	
	private _group = missionNamespace getVariable [_grpVar,grpNull];
	if !(isNull _group) then { _group setGroupIdGlobal [_grpName] };
};

// SET GROUP IDS
// Execute setGroupID Function for all factions
{
	_x params ["_grpSide"];
		
	if (playableSlotsNumber _grpSide > 0) then {
		{ ([_grpSide] + _x) call _f_fnc_setGroupID } forEach (missionNamespace getVariable [format["f_var_groups%1", _grpSide], []])
	};
} forEach [west, east, independent, civilian];

// Save the complete list for future reference.
missionNamespace setVariable ["f_var_allGroups", _grpList, true];

f_var_setGroupsIDs = true;
publicVariable "f_var_setGroupsIDs";

[] spawn {
	while {true} do {
		{
			_x params["_side","_grpVar","_grpName","_mkrType","_mkrText","_mkrColor"];
			private _group = missionNamespace getVariable [_grpVar,grpNull];
			
			// Check group wasn't removed
			if !(isNull _group) then {
				if (groupId _group != _grpName) then {
					_group setGroupIdGlobal [_grpName];
					[[_grpVar,_grpName,_mkrType,_mkrText,_mkrColor], "f\groupMarkers\fn_localGroupMarker.sqf"] remoteExec ["execVM", _side, _grpVar];
				};
			};
		} forEach f_var_allGroups;
		sleep 30;
	};
};