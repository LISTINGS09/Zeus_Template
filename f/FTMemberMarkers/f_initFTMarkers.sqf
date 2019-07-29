// 	F3 - Fireteam Member Markers
// 	Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
//  Description: Launches the main part of the FireTeam Member markers.
//  Parameters
//		Nothing.
//	Returns:
//		Nothing.
// 	Example:
// 		[] call f_fnc_initFTMarkers;
//
// ====================================================================================
// Only run for genuine players
if (!hasInterface || playerSide == sideLogic || isClass(configFile >> "CfgPatches" >> "ace_main")) exitWith {};

// MAKE SURE THE PLAYER INITIALIZES PROPERLY
waitUntil {sleep 0.1; !isNull player};

// DEFINE HELPER-FUNCTION
// Define a small function to set a unit's team colour
f_fnc_GetMarkerColor = {
	switch ((_this select 0)) do {
		case "RED": {"ColorRed"};
		case "GREEN": {"ColorGreen"};
		case "BLUE": {"ColorBlue"};
		case "YELLOW": {"ColorYellow"};
		default {"ColorWhite"};
	};
};

// START DRAWING MARKERS
// launch the subscript for drawing the marker for each unit.

[] spawn {
	f_var_HandlerGroup = [];
	while{!isNull player} do {
		{
			// check if we already are drawing the FT marker and that _x is alive
			if(!(_x in f_var_HandlerGroup) && alive _x) then {
				[_x] execVM "f\FTMemberMarkers\f_localFTMember.sqf";
				f_var_HandlerGroup pushBack _x;
			};
		} forEach units player;
	sleep 5;
	};
};