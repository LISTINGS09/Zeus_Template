// F3 - Briefing
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================

// MAKE SURE THE PLAYER INITIALIZES PROPERLY
if !hasInterface exitWith {};
if (!isDedicated && (isNull player)) then {waitUntil {sleep 0.1; !isNull player};};

// Wait until server has set parameters.
waitUntil{ !isNil "f_var_missionLoaded" };

// DECLARE VARIABLES AND FUNCTIONS

private ["_unitSide","_incAdmin","_uidList"];

f_fnc_fillAdministration = compileFinal preprocessFileLineNumbers "f\briefing\fn_fillAdministration.sqf";

["briefing.sqf",format["Starting for: %1 (%2)",player,side player],"DEBUG"] call f_fnc_logIssue;

// DETECT PLAYER SIDE
// The following code detects what side the player's slot belongs to, and stores
// it in the private variable _unitSide

_incAdmin = false;
_uidList = ["76561197970695190"]; // 2600K

// BRIEFING: ADMIN
// The following block of code executes only if the player is the current host
// it automatically includes a file which contains the appropriate briefing data.

// Get Author ID if present
if (!isNil "f_var_AuthorUID") then {
	_uidList pushBack f_var_AuthorUID;
};

// Get Server Admin List if present (f_zeusAdminNames from f\common\fn_processParamsArray.sqf)
if (!isNil "f_zeusAdminNames") then {
	if (f_zeusAdminNames isEqualType []) then {
		_uidList append f_zeusAdminNames;
	};
};

// Check if player is authorised admin (or 2600K) ;)
if ((getPlayerUID player) in _uidList) then { _incAdmin = true;};

if (serverCommandAvailable "#kick" || !isMultiplayer || _incAdmin) then {
	#include "f_briefing_admin.sqf";
	["briefing.sqf","Briefing for admin included","DEBUG"] call f_fnc_logIssue;
};

player createDiaryRecord ["Diary", ["",""]];

//player removeDiaryRecord ["Diary", "Administration"];
//player removeDiaryRecord ["Diary", "Mission"];

// Briefing from mission file
#include "..\..\mission\briefing.sqf";

player createDiaryRecord ["Diary", ["",""]];

// Default non-commanders to group, commanders to side.
if (leader player == player) then { setCurrentChannel 1 } else { setCurrentChannel 3 };

// Include TS Info
[] execVm "f\misc\f_zeusJoin.sqf";

// Automatically select Mission - Credits: Larrow
waitUntil {!isNull (uiNamespace getVariable ["RscDiary", displayNull])};

_fnc_selectIndex = {
	params[ "_ctrl", "_name" ];

	for "_i" from 0 to ( lnbSize _ctrl select 0 ) -1 do {
		if ( _ctrl lnbText [ _i, 0 ] == _name ) exitWith { _ctrl lnbSetCurSelRow _i };
	};
};

[uiNamespace getVariable "RscDiary" displayCtrl 1001, "Briefing" ] call _fnc_selectIndex;
[uiNamespace getVariable "RscDiary" displayCtrl 1002, "Mission" ] call _fnc_selectIndex;

// Handle any authors not using the F3 assignGear script
[] spawn {
	uiSleep 2;
	if !(player getVariable ["f_var_assignGear_done", false]) then {
		["briefing.sqf","Gear was forced to finish for player","DEBUG"] call f_fnc_logIssue;
		player setVariable ["f_var_assignGear_done", true];
	};
};
