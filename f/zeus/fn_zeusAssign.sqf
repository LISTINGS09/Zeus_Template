// F3 Zeus Support  - Assign Curator
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================

if !isServer exitWith {};

params ["_unit"];

if (!isPlayer _unit) exitWith {};

_curator = objNull;

{ if (!alive getAssignedCuratorUnit _x) exitWith { _curator = _x } } forEach allCurators;

if (isNull _curator) exitWith {
	format["[Zeus] No free Curators - Creating new!",name _unit] remoteExec ["systemChat",_unit];
	_curator = [format["f_Zeus%1", name _unit],  getPlayerUID _unit] call f_fnc_zeusCreate;
};

unassignCurator _curator;
_unit assignCurator _curator;

format["[Zeus] Curator set-up complete for %1 (%2).", name _unit, _curator] remoteExec ["systemChat",_unit];

["fn_zeusAssign.sqf",format["Curator assigned to %1",name _unit],"INFO"] call f_fnc_logIssue;