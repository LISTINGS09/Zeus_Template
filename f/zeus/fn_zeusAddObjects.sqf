// F3 Zeus Support - Add Objects
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================

if !(isServer) exitWith {};

params [["_unit",objNull],["_mode",[]],["_onlyLeaders",false]];

private _curator = getAssignedCuratorLogic _unit;
if (isNull _curator) then { _curator = _unit; };

if (isNull _curator || typeOf _curator != "ModuleCurator_F") exitWith { format["[Zeus] Invalid Curator for %1", name _unit] remoteExec ["systemChat",_unit] };

// Decide which objects to add based on passed mode
private _objects = [];

switch (typeName _mode) do {
	case "STRING": {
		switch (toLower _mode) do {
			case "ai": { _objects = (entities "AllVehicles") select { !(_x in switchAbleUnits) && !isPlayer _x && alive _x } };
			case "vehicles": { _objects = (entities "AllVehicles") select { side _x in [east,west,resistance,civilian] && alive _x && !(_x isKindOf "CAManbase") } };
			case "empty": { _objects = (allMissionObjects "") select { !(side group _x in [east,west,resistance,civilian,sideLogic]) } }; // Includes Buildings
		};
	};
	case "ARRAY": 	{_objects = _mode};
	case "OBJECT": 	{_objects = [_mode]};
	case "SIDE": 	{ _objects = (allMissionObjects "") select {(side group _x) == _mode } };
	case "BOOL": {
		 if _mode then {
		 	_objects = allMissionObjects "";

		 	//To prevent unnecessary stress on the network compare the the new _objects array to the existing curator objects. If they are identical, reset _objects to an empty array
		 	if (_objects isEqualTo (curatorEditableObjects _curator)) then {
		 		_objects = [];
		 	};
		 } else {
		 	_curator removeCuratorEditableObjects [curatorEditableObjects _curator,true];
		 };
	 };
};

if _onlyLeaders then { _objects = (_objects select { _x == leader group _x }) };

if (count _objects == 0) exitWith {};

// Add all selected objects to curator lists
_curator addCuratorEditableObjects [_objects,true];

format["[Zeus] Added %1 objects",count _objects] remoteExec ["systemChat",_unit];