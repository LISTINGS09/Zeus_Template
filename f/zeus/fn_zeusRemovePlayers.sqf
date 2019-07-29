// F3 Zeus Support - Remove Players
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================

if !(isServer) exitWith {};

params [["_unit",objNull]];

private _curator = getAssignedCuratorLogic _unit;

if (isNull _curator || typeOf _curator != "ModuleCurator_F") exitWith { format["[Zeus] Invalid Curator for %1", name _unit] remoteExec ["systemChat",_unit] };

_curator removeCuratorEditableObjects [[(playableUnits + switchableUnits)], TRUE];
"[Zeus] Removed Player Units" remoteExec ["systemChat",_unit];