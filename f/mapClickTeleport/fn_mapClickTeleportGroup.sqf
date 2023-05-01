// F3 - Mission Maker Teleport
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================

// DECLARE VARIABLES AND FUNCTIONS

params["_unit","_pos",["_requested","Unknown"]];

if !(local _unit) exitWith {};

diag_log format["[F3] Teleported to %1 by %2.", _pos, _requested];

if (f_var_mapClickTeleport_Height == 0) then {
	_unit setPos (_pos getPos [random 5, random 360]);
} else {
	cutText ["", "BLACK FADED",999];
	_unit setPos ((_pos getPos [random 500, random 360]) vectorAdd [0, 0, f_var_mapClickTeleport_Height]);
	[_unit] spawn f_fnc_mapClickHaloEffect;
};