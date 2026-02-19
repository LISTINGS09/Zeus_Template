// V1.0 - Shade a grid in real time for all enemy forces within an area.
// [] execVM "scripts\z_colorGrid.sqf";			// Enemy Grid Markers
if !isServer exitWith {};

params [ ["_object", objNull] ];

private _zoneID = (missionNamespace getVariable ["ZCG_instance", 0]) + 1;
missionNamespace setVariable ["ZCG_instance",_zoneID];

private ["_centre","_radius"];

if (_object isKindOf "EmptyDetector") then { 
	_centre = getPos _object;
	_radius = ((triggerArea _object)#0) max ((triggerArea _object)#1);
} else {
	_centre = getMarkerPos _object;
	_radius = ((getMarkerSize _object)#0) max ((getMarkerSize _object)#1);
};

if (isNil "ZMM_playerSide") then { ZMM_playerSide = side group (selectRandom allPlayers) };
if (isNil format["ZMM_%1_EnemySide", _zoneID]) then { missionNamespace setVariable [format["ZMM_%1_EnemySide", _zoneID], ((allGroups apply { side _x }) - [ZMM_playerSide]) select 0] };

private _gridCount = 0;

for "_z" from ((_centre#0)+(_radius * -1)) to ((_centre#0)+_radius) step 100 do {
	for "_y" from ((_centre#1)+(_radius * -1)) to ((_centre#1)+_radius) step 100 do {	
		private _tempPos = [((floor (_z / 100)) * 100) + 50, ((floor (_y / 100)) * 100) + 50, 0];
		private _gridName = format["MKR_GRID_%1_%2", _tempPos#0,  _tempPos#1];		

		if (markerText _gridName isEqualTo "" && {!surfaceIsWater _tempPos} && _tempPos inArea _object) then {
			private _tempMkr = createMarker [_gridName, _tempPos];
			_tempMkr setMarkerShape "RECTANGLE";
			_tempMkr setMarkerBrush "FDiagonal";
			_tempMkr setMarkerAlpha 0.4;
			_tempMkr setMarkerSize [50,50];
			_tempMkr setMarkerColor ([(missionNamespace getVariable format["ZMM_%1_EnemySide", _zoneID]), true] call BIS_fnc_sideColor);
			
			// Create a trigger to switch the area colour.
			private _mrkTrigger = createTrigger ["EmptyDetector", _tempPos, false];
			_mrkTrigger setTriggerTimeout [5, 5, 5, true];
			_mrkTrigger setTriggerArea [50, 50, 0, true, 100];
			_mrkTrigger setTriggerActivation ["ANY", "PRESENT", false];
			_mrkTrigger setTriggerStatements [
				format["ZMM_%1_EnemySide countSide thisList < 2 && ZMM_playerSide countSide thisList > 0", _zoneID], // Side GUER to string doesn't work!
				format["missionNamespace setVariable ['ZMM_%1_GRID', (missionNamespace getVariable ['ZMM_%1_GRID',0]) + 1, TRUE]; deleteMarker '%2'; deleteVehicle thisTrigger;", _zoneID, _gridName],
				""
			];
			
			_gridCount = _gridCount + 1;
			missionNamespace setVariable [format['TR_%1_GRID_%2', _zoneID, _gridCount], _mrkTrigger, true];
			[_mrkTrigger, format['TR_%1_GRID_%2', _zoneID, _gridCount]] remoteExec ["setVehicleVarName", 0, _mrkTrigger];
		};
	};
};

missionNamespace setVariable [format['ZMM_%1_GRID_MAX', _zoneID], _gridCount];