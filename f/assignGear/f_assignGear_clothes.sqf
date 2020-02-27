// F3 - F3 Folk ARPS Assign Gear
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================

// Prevent BIS Randomisation System
// BIS created a system for randomisation unit loadouts, that may overwrite the changes made by this script, this will fix such system.

_unit setVariable ["BIS_enableRandomization", false];

// ====================================================================================

// Assign default clothes
_uniform = _baseUniform;
_helmet = _baseHelmet;
_rig = _mediumRig;
_glasses = _baseGlasses;

// Flip through unit to assign specialized uniforms

// Light
if (_typeofUnit in _light) then {
	_rig = _lightRig;
};

// Heavy
if (_typeofUnit in _heavy) then {
	_rig = _heavyRig;
};

// Pilot
if (_typeofUnit in _pilot) then {
	_helmet = _pilotHelmet;
	_uniform = _pilotUniform;
	_rig = _pilotRig;
	_glasses = _pilotGlasses
};

// Crew
if (_typeofUnit in _crew) then {
	_helmet = _crewHelmet;
	_uniform = _crewUniform;
	_rig = _crewRig;
	_glasses = _crewGlasses;
};

// Diver
if (_typeofUnit in _diver) then {
	_helmet = _diverHelmet;
	_uniform = _diverUniform;
	_rig = _diverRig;
	_glasses = _diverGlasses;
};

// Ghillie
if (_typeofUnit in _ghillie) then {
	_helmet = _ghillieHelmet;
	_uniform = _ghillieUniform;
	_rig = _ghillieRig;
	_glasses = _ghillieGlasses;
};

// Spec Op
if (_typeofUnit in _specOp) then {
	_helmet = _sfHelmet;
	_uniform = _sfUniform;
	_rig = _sfRig;
	_glasses = _sfGlasses;
};

//Random Uniform:
if(count _uniform > 0) then {
	private _toCheck = [_uniform] call f_fnc_arrayCheck;
	if (_toCheck == "") then {
		removeUniform _unit;
	} else {
		if ((!isNil "_toCheck") && {isClass (configFile >> "CfgWeapons" >> _toCheck)}) then {
			removeUniform _unit;
			_unit forceAddUniform _toCheck;
		} else {
			["f_assingnGear_clothes.sqf",format["Uniform (%1) not found for %2 of type '%3'",_toCheck,_unit,_typeofUnit]] call f_fnc_logIssue;
		};
	};
	
	if (_uniform isEqualType [] && isPlayer _unit) then { missionNamespace setVariable [format["f_var_%1_%2_gear_uniform",_side,_typeofUnit], _uniform select {isClass (configFile >> "CfgWeapons" >> _x)}, true] };
};

//Random Helmet:
if(count _helmet > 0) then {
	private _toCheck = [_helmet] call f_fnc_arrayCheck;
	if (_toCheck == "") then {
		removeHeadgear _unit;
	} else {
		if ((!isNil "_toCheck") && {isClass (configFile >> "CfgWeapons" >> _toCheck)}) then {
			removeHeadgear _unit;
			_unit addHeadgear _toCheck;
		} else {
			["f_assingnGear_clothes.sqf",format["Helmet (%1) not found for %2 of type '%3'",_toCheck,_unit,_typeofUnit]] call f_fnc_logIssue;
		};
	};
	
	if (_helmet isEqualType [] && isPlayer _unit) then { missionNamespace setVariable [format["f_var_%1_%2_gear_headgear",_side,_typeofUnit], _helmet select {isClass (configFile >> "CfgWeapons" >> _x)}, true] };
};

//Random Rig:
if(count _rig > 0) then {
	private _toCheck = [_rig] call f_fnc_arrayCheck;
	if (_toCheck == "") then {
		removeVest _unit;
	} else {
		if ((!isNil "_toCheck") && {isClass (configFile >> "CfgWeapons" >> _toCheck)}) then {
			removeVest _unit;
			_unit addVest _toCheck;
		} else {
			["f_assingnGear_clothes.sqf",format["Vest (%1) not found for %2 of type '%3'",_toCheck,_unit,_typeofUnit]] call f_fnc_logIssue;
		};
	};
	
	if (_rig isEqualType [] && isPlayer _unit) then { missionNamespace setVariable [format["f_var_%1_%2_gear_vest",_side,_typeofUnit], _rig] };
};

//Random Glasses:
if(count _glasses > 0) then {
	private _toCheck = [_glasses] call f_fnc_arrayCheck;
	if (_toCheck == "") then {
		removeGoggles _unit;
	} else {
		if ((!isNil "_toCheck") && {isClass (configFile >> "CfgGlasses" >> _toCheck)}) then {
			_unit addGoggles _toCheck;
		} else {
			["f_assingnGear_clothes.sqf",format["Goggles (%1) not found for %2 of type '%3'",_toCheck,_unit,_typeofUnit]] call f_fnc_logIssue;
		};
	};
	
	if (_glasses isEqualType [] && isPlayer _unit) then { missionNamespace setVariable [format["f_var_%1_%2_gear_goggles",_side,_typeofUnit], _glasses] };
} else {
	removeGoggles _unit;
};