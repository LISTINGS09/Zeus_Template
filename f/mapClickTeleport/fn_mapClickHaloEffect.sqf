// F3 - Mission Maker Teleport
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================
private ["_unit","_bp","_bpi"];
params["_unit"];

_bp = backpack _unit;
_bpi = backPackItems _unit;

removeBackpack _unit;
ace_map_mapShake = true;

"dynamicBlur" ppEffectEnable true;
"dynamicBlur" ppEffectAdjust [6];
"dynamicBlur" ppEffectCommit 0; 
"dynamicBlur" ppEffectAdjust [0.0];
"dynamicBlur" ppEffectCommit 5;

sleep 0.5;

_unit addBackpack "B_parachute";

cutText ["", "BLACK IN", 5];

waitUntil {sleep 0.1; (position _unit select 2) < 125;};

//Check if players chute is open, if not open it.
if (vehicle _unit isEqualto _unit && alive _unit) then {
	_unit action ["openParachute", _unit];
};

waitUntil {sleep 0.1; isTouchingGround _unit || (position _unit select 2) < 1 };
_unit action ["eject", vehicle _unit];
sleep 1;

removeBackpack _unit;
sleep 0.5;

ace_map_mapShake = false;
_unit addBackPack _bp;
sleep 0.5;

{
	_unit addItemToBackpack _x;
} forEach _bpi;