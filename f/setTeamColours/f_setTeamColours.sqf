if (!hasInterface || playerSide == sideLogic) exitWith {};

[] spawn {
	sleep 5;
	
	if (count units player < 4) exitWith {};

	private ["_red","_blue","_yellow","_green"];
	_red = "1_"; 		// FT 1
	_blue = "2_";		// FT 2
	_green = "3_";		// FT 3
	_yellow = "_M";		// Medic

	// assignTeam is global as of 1.62 - Only run for player.
	{
		if (((str player) find _x) != -1) then {
			// Assign players team from current index of colours.
			player assignTeam (["RED","BLUE","YELLOW","GREEN"] select _forEachIndex);
			player setVariable ["ST_STHud_assignedTeam",assignedTeam player,true];
			
			if (isClass (configFile >> "CfgPatches" >> "cba_main")) then {
					["CBA_teamColorChanged", [player, assignedTeam player]] call CBA_fnc_globalEvent;
			};
		};
	} forEach [_red,_blue,_yellow,_green];
	
	if (!isMultiplayer) then {
		{	
			_unit = _x;
			{
				if (((str _unit) find _x) != -1) then {
					// Assign players team from current index of colours.
					_unit assignTeam (["RED","BLUE","YELLOW","GREEN"] select _forEachIndex);
				};
			} forEach [_red,_blue,_yellow,_green];
		} forEach units player;
	};
};