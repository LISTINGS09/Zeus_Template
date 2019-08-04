// F3 - Fireteam Member Markers
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================

// DECLARE PRIVATE VARIABLES
private ["_mkrType","_mkrColor","_mkrName","_mkr","_mkrBorder","_pos","_color"];
params ["_unit"];

// SET KEY VARIABLES
// Using variables passed to the script instance, we will create some local variables:
_mkrName = Format ["zft_%1",_unit];
_mkrborderName = Format ["zft_%1B",_unit];

// CREATE MARKERS

// this marker is slightly bigger and abused in such a way to make it seem like the next maker has a border
_pos = getposATL _unit;
_mkrBorder = createMarkerLocal [_mkrborderName,_pos];
_mkrBorder setMarkerShapeLocal "ICON";
_mkrBorder setMarkerTypeLocal "MIL_TRIANGLE";
_mkrBorder setMarkerColorLocal "ColorBlack";
_mkrBorder setMarkerSizeLocal [0.50, 0.50];
_mkrBorder setMarkerDirLocal (direction _unit);

// This marker is the real marker
_mkr = createMarkerLocal [_mkrName,_pos];
_mkr setMarkerShapeLocal "ICON";
_mkr setMarkerTypeLocal "MIL_TRIANGLE";
_mkr setMarkerColorLocal "ColorWhite";
_mkr setMarkerSizeLocal [0.45, 0.45];
_mkr setMarkerDirLocal (direction _unit);

// Run the loop that sets the marker position
while{alive _unit && (_unit in f_var_HandlerGroup)} do {
	_pos = getposATL _unit;
	_dir = (direction _unit);
	
	if (alive _unit && {_unit in units player}) then {
		_mkrBorder setMarkerPosLocal _pos;
		_mkrBorder setMarkerDirLocal _dir;
		_mkr setMarkerPosLocal _pos;
		_mkr setMarkerDirLocal _dir;
		_mkr setMarkerColorLocal ([assignedTeam _unit] call f_fnc_GetMarkerColor);
	} else {
		f_var_HandlerGroup = f_var_HandlerGroup - [_unit];
	};
	sleep 3;
};

//He's dead Jim, let's clear up obsolete markers
deleteMarkerLocal _mkrBorder;
deleteMarkerLocal _mkr;