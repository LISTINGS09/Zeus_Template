// F3 - SetFog
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================
if !isServer exitWith {};

// FOG VALUES
// [
//	0 = Value for fog at base level, 
//	1 = Decay of fog density with altitude. If set to 0 fog strength is consistent throughout.
// 	2 = Base altitude of fog (in meters). Up until this height fog does *not* loose density.
// ]

// DECLARE VARIABLES AND FUNCTIONS
params[["_fog",0], ["_delay",0], "_overRide"];

// If fog is defined in-mission, exit.
if (_fog == 0) exitWith {};

waitUntil { !isNil "f_var_missionLoaded" }; // SP FIX - Init.sqf needs to load to process any override settings.

// Picks a random value from the existing f_param_fog values (if 0 is not present)
private _paramsFog = getArray (missionConfigFile >> "Params" >> "f_param_fog" >> "values");	
if (!(0 in _paramsFog) && count _paramsFog > 0) then { _fog = selectRandom _paramsFog };

if (!isNil "_overRide") then {
	_delay setFog _overRide;
} else {
	// SELECT FOG VALUES
	// Using the value of _fog, new fog values are set.
	private _fogSettings = if (isNil "f_var_fogOverride") then {
			// DEFAULT FOG SETTING
			[
				[0,0,0],			// None
				[0.2,0,0], 			// Low
				[0.4,0,0], 			// Heavy
				[random 0.15,0,0] 	// Random
			]
		} else {
			f_var_fogOverride;
		};

	_delay setFog (_fogSettings select (_fog - 1));
};

["f_setFog.sqf",format["Fog setting - %1: %2", _fog, fogParams],"INFO"] call f_fnc_logIssue;