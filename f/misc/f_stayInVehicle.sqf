// Stubborn Crew
// v2
// Thanks to the gorgeous Wolfenswan @FA for initial code, modified by 2600K.
//
// FEATURE
// Vehicle crews will only bail when the vehicle damage is over 0.8 or the guns are destroyed.
//
// USAGE
// Globally checks units and sets all non-player side vehicles.
//
// EXAMPLE
// [] execVM "f\misc\f_stayInVehicle.sqf";
if !isServer exitWith {};

if (!isNil "DAC_Basic_Value") then {waitUntil {sleep 5;DAC_Basic_Value > 0}} else {sleep 30};

private _ignoresides = [];

// Get list of sides to ignore.
{
	if !(side _x in _ignoreSides) then {
		_ignoreSides pushBack (side _x);
	};
} forEach playableUnits + switchableUnits;

private _vehicles = vehicles select { canFire _x && !(side _x in _ignoreSides) && !(_x isKindOf "StaticWeapon") && count crew _x > 0};

if (count _vehicles == 0) exitWith {};

if (missionNamespace getVariable["f_param_debugMode",0] == 1) then {diag_log text format["[F3] DEBUG (fn_stayInVehicle.sqf): Found: %1 vehicles",count _vehicles];};

{
	if (_x getVariable ["zeu_stayIn", false]) then {
		private _unit = _x;
		
		// Enable ACE Cooking
		if (vehicleVarName _unit == "" && random 1 > 0.3) then { _unit setVariable ["ace_cookoff_enable", true, true] };
		
		if (missionNamespace getVariable["f_param_debugMode",0] == 1) then {diag_log text format["[F3] DEBUG (fn_stayInVehicle.sqf): Processing vehicle: %1 (%2)",_unit,typeOf _unit];};
		
		_unit allowCrewInImmobile true;
		_unit setVariable ["zeu_stayIn",true];

		_x addEventHandler [ "Hit",
			{
				params["_unit"];

				 if (getDammage _unit > 0.8 || !(canFire _unit)) then {
					_unit allowCrewInImmobile false;
					{_x action ["eject", _unit];} forEach crew _unit;
					_unit removeEventHandler ["Hit", _thisEventhandler];
				};
			}
		];
   };
} forEach _vehicles;