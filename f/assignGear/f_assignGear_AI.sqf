// F3 - Assign Gear Script - AI
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================

if !(isServer) exitWith {};

params [["_units",[]]];

if (_units isEqualType objNull) then { 
	["", _units, side group _units, true] spawn f_fnc_assignGear;
} else {
	{ ["", _x, side group _x, true] spawn f_fnc_assignGear } forEach _units;
};