/*
ARMA3 - FILL HOUSE SCRIPT v1.7 - by 26K, SPUn & lostvar

Fills house or buildings in defined range with soldiers

Calling the script:
default: _nul = [this] execVM "scripts\LV\fillHouse.sqf";
custom:  _nul = [target, side, patrol, spawn rate, radius, skills] execVM "scripts\LV\fillHouse.sqf";

example:  _nul = [thisTrigger, "NATO", FALSE, 1, 50, 1] execVM "scripts\LV\fillHouse.sqf";

Parameters:
		
	target 		= 	center point 	(Game Logics/Objects/Marker name, ex: GL01 or this or "marker1")
	side 		= 	"NATO", "WEST", "CSAT", "EAST", "AFF" or "FIA"											DEFAULT: "NATO"
	patrol 		= 	TRUE or FALSE 	(if TRUE, units will patrol) 											DEFAULT: TRUE
	patrol dist	= 	1-999 radius in meters for patrol (if TRUE, units will patrol) 							DEFAULT: 100
	spawn rate  = 	1-100 OR Array 	(on how many percentage of possible positions are soldiers spawned) 	DEFAULT: 50
				NOTE: Array - you can also use following syntax: [amount,random amount] for example:
				[10,12] will spawn at least 10 units + random 12 units 
	radius 		= 	1 or larger number (1=nearest building. if larger number, then all buildings in radius) DEFAULT: 1
	skills 		= 	"default" 	(default AI skills) 														DEFAULT: "default"
				or	number	=	0-1.0 = this value will be set to all AI skills, ex: 0.8
				or	array	=	all AI skills individually in array, values 0-1.0, order:
		[aimingAccuracy, aimingShake, aimingSpeed, spotDistance, spotTime, courage, commanding, general, reloadSpeed] 
		ex: 	[0.75,0.5,0.6,0.85,0.9,1,1,0.75,1] 
	
EXAMPLE:
_nul = [this, "NATO", FALSE, 1, [1, round random 8], 15] execVM "scripts\LV\fillHouse.sqf";
*/
if !isServer exitWith{};
private["_bPoss", "_rat", "_gSide", "_menArray", "_helper"];
params [ "_center",
	["_sideOption", "NATO"],
	["_patrol", FALSE],
	["_pDist", 100],
	["_ratio", [2,2]],
	["_radius", 1],
	["_skills", [0.4,0.5,1,0.8,0.7,1,1,1,1]]
];

#include "groupsList.sqf";

switch (typeName _center) do {
	case "STRING": 	{_center = getMarkerPos _center};
	case "OBJECT":	{_center = getPos _center};
};

if (_center in allMapMarkers) then { _center = getMarkerPos _center };

_bPoss = [];

if(_radius > 1) then {
	{
		_bPoss append (_x buildingPos -1);
	} forEach (nearestObjects [_center, ["building"], _radius]);
} else {
	_bPoss = (nearestBuilding _center) buildingPos -1;
};

if(count _bPoss == 0) exitWith {};

if (typeName _ratio == "ARRAY") then{
	_rat = (_ratio select 0) + (random (_ratio select 1));
}else{
	_rat = ceil((_ratio / 100) * (count _bPoss));
};

_newGroup = createGroup [_gSide,TRUE];

// Disable VCOMAI
_newGroup setVariable ["VCM_DISABLE", TRUE];

for "_i" from 1 to _rat do {
	if (count _bPoss == 0) exitWith {};
	_tempPos = selectRandom _bPoss;
	_bPoss = _bPoss - [_tempPos];
    _unitType = selectRandom _menArray;
	
	//if (missionNamespace getVariable["f_param_debugMode",0] == 1) then { diag_log text format["[LV] DEBUG (fillHouse.sqf): Creating man %1 (%5) at %4. Positions: %2. Ratio: %3",_i,count _bPoss,_rat,_tempPos, _unitType]; };
	if !(_unitType isKindOF "CAMANBASE") exitWith { diag_log text format ["[FillHouse] ERROR - Invalid Unit: %1", _unitType] };
	
	_unit = _newGroup createUnit [_unitType, _tempPos, [], 0, "NONE"];
	_unit setPosATL _tempPos;
	
	_unitEyePos = eyePos _unit;
	
	// Make unit crouch if they have sky above their heads.
	if (count (lineIntersectsWith [_unitEyePos, (_unitEyePos vectorAdd [0, 0, 10])] select {_x isKindOf 'Building'}) < 1) then {
		_unit setUnitPos "MIDDLE";
		// Reset source to new height.
		_unitEyePos = eyePos _unit; 
	}; 
	
	// Force unit to hold - doStop is a 'soft' hold, disableAI stops movement permanently.
	if (random 1 > 0.7) then { doStop _unit } else { _unit disableAI "PATH" };
	
	_p1 = []; // Great pos, facing outside building.
	_p2 = []; // Good pos but facing inside building.
	_p3 = []; // OK pos but not best views.
	_p4 = []; // Bad pos facing wall.
	
	// Get Building Direction
	_unitBld = nearestBuilding _unit;
	
	for "_dir" from (getDir _unitBld) to ((getDir _unitBld) + 359) step 45 do { 
		// Check 3m
		if (count (lineIntersectsWith [_unitEyePos, [_unitEyePos, 3, _dir] call BIS_fnc_relPos] select {_x isKindOf 'Building'}) > 0) then { 
			_p4 pushBack _dir;
			_helper = "Sign_Arrow_Direction_F";
		} else { 
			// Check 10m
			if (count (lineIntersectsWith [_unitEyePos, [_unitEyePos, 10, _dir] call BIS_fnc_relPos] select {_x isKindOf 'Building'}) > 0) then { 
				_p3 pushBack _dir;
				_helper = "Sign_Arrow_Direction_Yellow_F";
			} else { 
				if (abs ((_unitEyePos getDir _unitBld) - _dir) >= 120) then {
					_p1 pushBack _dir;
					_helper = "Sign_Arrow_Direction_Green_F";
				} else {
					_p2 pushBack _dir;
					_helper = "Sign_Arrow_Direction_Cyan_F";
				};
			};
		};
		
		/*
		_obj = createSimpleObject [_helper, [_unitEyePos, 1, _dir] call BIS_fnc_relPos]; 
		_obj setDir _dir;
		*/
	};  
		
	// Pick a random angle from the best grouping.
	_finalDir = -1;
	{	
		if (count _x > 0) then {_finalDir = selectRandom _x };
		if (_finalDir >= 0) exitWith {}; 
	} forEach [_p1, _p2, _p3, _p4];
	
	_unit doWatch (_unit getPos [200,_finalDir]);
	
	// Semi-exposed area, set to kneel.
	if (count (_p1 + _p2) >= 5 && random 1 > 0.2) then { _unit setUnitPos "MIDDLE" };

	// Exposed area, set to prone.
	if (count (_p1 + _p2) >= 7) then { 
		if (random 1 > 0.8) then { _unit setUnitPos "MIDDLE" } else { _unit setUnitPos "DOWN" };
	};	
	
	if (_skills isEqualType []) then { 
		{
			_x setSkill ["aimingAccuracy",(_skills select 0)];
			_x setSkill ["aimingShake",(_skills select 1)];
			_x setSkill ["aimingSpeed",(_skills select 2)];
			_x setSkill ["spotDistance",(_skills select 3)];
			_x setSkill ["spotTime",(_skills select 4)];
			_x setSkill ["courage",(_skills select 5)];
			_x setSkill ["commanding",(_skills select 6)];
			_x setSkill ["general",(_skills select 7)];
			_x setSkill ["reloadSpeed",(_skills select 8)];
		} forEach units _unit;
	} else { _unit setSkill _skills; };
	
	//Add to Zeus
	{
		_x addCuratorEditableObjects [[_unit],TRUE];
	} forEach allCurators;
};

if (_patrol) then { [_newGroup, getPos leader _newGroup, _pDist] spawn BIS_fnc_taskPatrol };