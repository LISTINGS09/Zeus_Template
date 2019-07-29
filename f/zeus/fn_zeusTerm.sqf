// F3 Zeus Support  - Termination
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================
if !isServer exitWith {};

params [["_unit",objNull]];

_curator = getAssignedCuratorLogic _unit;

if (isNull _curator || typeOf _curator != "ModuleCurator_F") exitWith { format["[Zeus] Invalid Curator for %1", name _unit] remoteExec ["systemChat",_unit] };

// Break connection
unassignCurator _curator;
format["[Zeus] Curator Removed for %1 (%2)", name _unit, _curator] remoteExec ["systemChat",_unit];

