// F3 - Folk Group Markers
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================
if (!hasInterface || playerSide == sideLogic) exitWith {};

waitUntil{!isNil "f_var_setGroupsIDs"};

if (missionNamespace getVariable["f_param_groupMarkers",0] == 0) exitWith {}; // If 0 do nothing.

f_fnc_localGroupMarker = compileFinal preprocessFileLineNumbers "f\groupMarkers\fn_localGroupMarker.sqf";
f_var_localGroups = [];
// If Commander-Only markers are selected, exit here
if ((rank player) in ["PRIVATE", "CORPORAL", "SERGEANT"] && f_param_groupMarkers in [4,5]) exitWith {};

// DECLARE VARIABLES AND FUNCTIONS
private ["_unitSide"];

// INCLUDE GROUP LIST
private _grpBLU = []; private _grpOPF = []; private _grpIND = []; private _grpCIV = [];
#include "..\..\mission\groups.sqf";

// DETECT PLAYER SIDE
// The following code detects what side the player's slot belongs to.
_unitSide = side player;

// If the unit side is different from the group leader's side, the latter side is used
if (_unitSide != side (leader group player)) then {_unitSide = side (leader group player)};

switch (_unitSide) do {
	case west: {
		if (count _grpBLU > 0) then {
			{
				_x spawn f_fnc_localGroupMarker;
				f_var_localGroups pushBack _x;
			} forEach _grpBLU;
		};
	};
	case east: {
		if (count _grpOPF > 0) then {
			{
				_x spawn f_fnc_localGroupMarker;
				f_var_localGroups pushBack _x;
			} forEach _grpOPF;
		};
	};
	case independent: {
		if (count _grpIND > 0) then {
			{
				_x spawn f_fnc_localGroupMarker;
				f_var_localGroups pushBack _x;
			} forEach _grpIND;
		};
	};
	case civilian: {
		if (count _grpCIV > 0) then {
			{
				_x spawn f_fnc_localGroupMarker;
				f_var_localGroups pushBack _x;
			} forEach _grpCIV;
		};
	};
};

// Set icons to show in-game also if chosen
if (f_param_groupMarkers == 2) then { 
	setGroupIconsVisible [TRUE,TRUE]; 
} else {
	setGroupIconsVisible [TRUE,FALSE];
};

// Extended Group Info - Stop here if not enabled.
if (f_param_groupMarkers in [1,2,4]) exitWith {};

setGroupIconsSelectable true;

// Wait until in mission
sleep 0.5;

// Used to display fire-team colours.
f_fnc_getIconColor = {
	if (_this select 0 == "RED") exitWith {"#FF4646"};
	if (_this select 0 == "GREEN") exitWith {"#46FF46"};
	if (_this select 0 == "BLUE") exitWith {"#4646FF"};
	if (_this select 0 == "YELLOW") exitWith {"#FFFF46"};
	"#FFFFFF"
};

addMissionEventHandler ["GroupIconOverEnter", {
	params [
		"_is3D", "_group", "_waypointId",
		"_posX", "_posY",
		"_shift", "_control", "_alt"
	];
		
	_iconParams = getGroupIconParams _group;	
		
	_group setGroupIconParams [_iconParams#0, groupId _group, _iconParams#2, true]; 
	
	_text = format["<br/><t size='1.25' font='TahomaB' color='#72E500'>%1 Group</t><br/>",groupId _group];
	_text = _text + "<t align='left'>";
	{	
		_unitIco = (getText (configFile >> "CfgVehicles" >> (typeOf _x) >> "icon") call bis_fnc_textureVehicleIcon);
		_unitType = getText (configFile >> "CfgVehicles" >> (typeOf _x) >> "displayName");
		
		if ((_x getVariable["ACE_isUnconscious",false]) || lifeState _x == "INCAPACITATED" || !alive _x) then {
			_text = _text + format["<br/><t color='#%4'><img image='%2'/></t> <t color='#%4'>%1</t> <t color='#%5'>(%3)</t>", name _x, _unitIco, _unitType, ["999999","990000"] select (alive _x), ["777777","770000"] select (alive _x)];
		} else {
			_text = _text + format["<br/><t color='%3'><img image='%2'/></t> %1 <t color='#888888'>(%4)</t>", name _x, _unitIco, [assignedTeam _x] call f_fnc_getIconColor, _unitType];
		};
		
		if (leader _group == _x) then {
			_text = _text + " (<t color='#72E500'>Lead</t>)";
		};
	} forEach (units _group select { alive _x });
	
	_text = _text + "</t><br/><br/>";
	
	// Add group score, casualties and sdr
	_pts = 0;

	units _group apply { _pts = _pts + score _x };
	_cas = _group getVariable ["f_var_casualtyCount", 0];

	_text = _text + format["Score: <t color='#46FF46'>%1</t><br/>Casualties: <t color='#FF0000'>%2</t><br/>Ratio: <t color='#FFFF46'>%1</t><br/><br/>",
		_pts,
		_cas,
		if (_cas > 0) then { (_pts / _cas) toFixed 1 } else { _cas }
	];
	
	hintSilent parseText _text;
}];

addMissionEventHandler ["GroupIconOverLeave", {
	params [
		"_is3D", "_group", "_waypointId",
		"_posX", "_posY",
		"_shift", "_control", "_alt"
	];
	
	_iconParams = getGroupIconParams _group;	
	
	_grpInfo = (missionNamespace getVariable ["f_var_localGroups",[]]) select { _x#1 == groupId _group };

	_group setGroupIconParams [_iconParams#0, if (count _grpInfo > 0) then { _grpInfo#0#3 } else { groupId _group }, _iconParams#2, TRUE]; 
	hintSilent "";
}];