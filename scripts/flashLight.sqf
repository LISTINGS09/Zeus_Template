// 2600K - Adds flashlights to leaders of a given side.
// [<side>,<light>] execVM "scripts\flashLight.sqf";
// Sides: west | east | resistance
// Lights: "acc_flashlight" or "rhs_acc_2dpZenit" etc..
if !isServer exitWith {};

params ["_side","_item"];

if (f_param_debugMode == 1) then {
	diag_log text format ["[F3] DEBUG (flashLight.sqf): Adding lights for Side: %1 - Type: %2.",_side,_item];
};

//_att = configName (configFile >> "CfgWeapons" >> _item);

{
	if (side _x == _side && _x IsKindof "Man" && !isPlayer _x && leader _x == _x && alive _x) then {
			_x addPrimaryWeaponItem _item;
			_x assignItem _item;
			_x enableGunLights "ForceOn";
	};
} forEach allUnits;