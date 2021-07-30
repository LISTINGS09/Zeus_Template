// Zeus Hunter Seeker Script v1.1
// Spawns defined group(s) using BIS_fnc_Stalk. Will respawn when killed - Endless pursuit.
// Can change the allPlayers filter to only include certain groups etc...
//
// Parameters:
// location - Required - Object, Position or Marker.
// number - Optional - How many groups to be spawned.
// units - Optional - Array of units to hunt.
//
// [player, 2, units player] execVM "scripts\huntGroup.sqf";
//
if !isServer exitWith {};

params ["_location", ["_number",1], "_units"];

// Find a valid player array if none was provided.
if (isNil "_units") then { _units = allPlayers select { alive _x && isTouchingGround _x }; };

ZHS_SpawnDist = 400; // Minimum distance to spawn.
ZHS_Side = EAST;
ZHS_Config = [configFile >> "CfgGroups" >> "East" >> "OPF_G_F" >> "Infantry" >> "O_G_InfTeam_Light"]; // East
//ZHS_Config = [configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfTeam"]; // West
//ZHS_Config = [configFile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfTeam"]; // Guer
//ZHS_Config = [["vn_o_men_nva_dc_01", "vn_o_men_nva_dc_02", "vn_o_men_nva_dc_03", "vn_o_men_nva_dc_04", "vn_o_men_nva_dc_05", "vn_o_men_nva_dc_06", "vn_o_men_nva_dc_07", "vn_o_men_nva_dc_08", "vn_o_men_nva_dc_09", "vn_o_men_nva_dc_10", "vn_o_men_nva_dc_11", "vn_o_men_nva_dc_12"]]; //EAST SOC DAC CONG

// Get the centre point
switch (typeName _location) do {
	case "STRING": {_location = getMarkerPos _location};
	case "OBJECT": {_location = getPos _location};
};

_ZHS_fnc_spawnTeam = {
	// Spawns a team and adds an EH to spawn a new team when all dead.
	params [["_pos",[0,0,0]], ["_side", ZHS_Side], ["_configEntry", ZHS_Config]];
	
	private _grp = [_pos, _side, selectRandom _configEntry] call BIS_fnc_spawnGroup;
	
	// Dress with custom gear
	_grp spawn {
		{ 
			// Custom Loadouts here etc...
			
			// Re-run script when leader is killed.
			if (leader _this == _x) then {
				_x addEventHandler ["killed",{
					params ["_unit"];
					[_unit] execVM "scripts\huntGroup.sqf";
				}];
			};
		} forEach units _this;
	};
	
	_grp deleteGroupWhenEmpty true;

	{ _x addCuratorEditableObjects [units _grp, TRUE] } forEach allCurators;

	_grp
};

for "_i" from 1 to _number do {
	if (count _units == 0) exitWith {};

	_spawnPos = [_location, ZHS_SpawnDist, ZHS_SpawnDist + 200, 1] call BIS_fnc_findSafePos;
	_spawnPos set [2,0];
	_spawnGrp = [_spawnPos] call _ZHS_fnc_spawnTeam;

	[_spawnGrp, group (selectRandom _units)] spawn BIS_fnc_Stalk;
	
	{	
		_x allowFleeing 0;
		_x disableAI "AUTOCOMBAT";
		_x enableAttack false;
		_x setSpeedMode "FULL";
	} forEach units _spawnGrp;
};