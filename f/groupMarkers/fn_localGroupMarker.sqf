// F3 - Folk Group Markers
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================

// DECLARE PRIVATE VARIABLES
private ["_grp","_mkr"];

// SET KEY VARIABLES
// Using variables passed to the script instance, we will create some local variables:
params ["_grpName","_unused","_mkrType","_mkrText","_mkrColor"];

_grp = missionNamespace getVariable [_grpName,grpNull];

// CREATE MARKER
if !(isNull _grp) then {
	//diag_log format ["fn_localGroupMarker.sqf Creating %1",_grpName];
	clearGroupIcons _grp;
	_mkr = _grp addGroupIcon [_mkrType,[0,0]];
	_grp setgroupIconParams [_mkrColor,_mkrText,0.8,TRUE];
};