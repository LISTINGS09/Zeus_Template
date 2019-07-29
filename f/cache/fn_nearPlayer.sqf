// F3 - Near Player Function
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================

// DECLARE VARIABLES AND FUNCTIONS
private ["_ent","_players"];
params["_pos","_distance"];
_pos = getPosATL (_pos);

// Create a list of all players
_players = [];

{
	if (isPlayer _x) then {
		_players pushBack _x;
	};
} forEach playableUnits + switchableUnits;

// Check whether a player is in the given distance - return true if yes
if (({_x distance _pos < _distance} count _players) > 0) exitWith {true};
false
