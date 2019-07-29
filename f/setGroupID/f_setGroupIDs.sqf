// F3 - Set Group IDs
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================

if !isServer exitWith {};

// INCLUDE GROUP LIST
private _grpBLU = []; private _grpOPF = []; private _grpIND = []; private _grpCIV = [];
private _grpList = []; 
#include "..\..\mission\groups.sqf";

// Local function to name group ID or wait until it is created
_f_fnc_setGroupID = { 
	params["_side","_grpVar","_grpName","_mkrType","_mkrText","_mkrColor"];
	
	_grpList pushBack _this;
	
	private _group = missionNamespace getVariable [_grpVar,grpNull];
	if !(isNull _group) then { _group setGroupIdGlobal [_grpName] };
};

// SET GROUP IDS
// Execute setGroupID Function for all factions
{([west] + _x) call _f_fnc_setGroupID} forEach _grpBLU;
{([east] + _x) call _f_fnc_setGroupID} forEach _grpOPF;
{([independent] + _x) call _f_fnc_setGroupID} forEach _grpIND;
{([civilian] + _x) call _f_fnc_setGroupID} forEach _grpCIV;

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
//					diag_log text format["[F3] INFO (fn_setGroupIDs.sqf): Group %1 (%2) was not synchronised (JIP), correcting.",_group,_grpName];
				};
			};
		} forEach f_var_allGroups;
		sleep 30;
	};
};