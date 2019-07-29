if isDedicated exitWith{};

params ["_killed","_killer","_respawn","_respawnDelay"];

// Casualty Counter
_killed spawn {
	if (time < 30) exitWith {};
	
	_group = group _this;
	
	// Random sleep to allow network sync if multiple casualties.
	sleep random 25;
	{
		_x params ["_sideVar","_markerVar"];
		if (side _group == _sideVar) exitWith {
			_casVar = missionNamespace getVariable [format["f_var_casualtyCount_%1",_sideVar],0];
			// Change the respawn marker to reflect # of casualties.
			missionNamespace setVariable [format["f_var_casualtyCount_%1",_sideVar],_casVar + 1,true];
			_markerVar setMarkerText format["Casualties: %1",(_casVar + 1)];
			// Increase the groups own casualty value.
			_group setVariable ["f_var_casualtyCount", (_group getVariable ["f_var_casualtyCount",0]) + 1, true];
		};
	} forEach [
		[west,"respawn_west"],
		[east,"respawn_east"],
		[resistance,"respawn_guerrila"],
		[civilian,"respawn_civilian"]
	];
};

// Save players dying gear
[_killed, [missionNamespace, "f_var_savedGear"]] call BIS_fnc_saveInventory;

if (isNil "f_param_respawn") then {f_param_respawn = 0};
if (isNil "f_var_localTickets") then { f_var_localTickets = if (f_param_respawn <= 10) then {f_param_respawn} else {0}; };

// Players sometime lose group when respawning
f_var_lastGroup = group _killed;

// Basic Spawning is set.
if (f_param_respawn in [30,60]) exitWith { 
	setPlayerRespawnTime f_param_respawn; 
};

// Player has tickets remaining.
if (f_var_localTickets > 0) exitWith {	
	setPlayerRespawnTime 20;
	f_var_localTickets = f_var_localTickets - 1;
	[format["Tickets: %1 Remaining",f_var_localTickets],0] call BIS_fnc_respawnCounter;
};

// Spawn disabled or no tickets remaining!
setPlayerRespawnTime 9999999;

// Check if Wave Spawning is required
if (f_param_respawn > 60) then {	
	// Work out time until spawning is due.
	private _respawnTime = f_param_respawn - (time mod f_param_respawn);
	// Set players spawn timer.
	setPlayerRespawnTime _respawnTime;
	// Update GUI
	[format["Reinforcements: Every %1 Minutes",round f_param_respawn / 60],0] call BIS_fnc_respawnCounter;
	// Start Spectator
	sleep 2;
	[] call f_fnc_spectateInit;
} else {
	// Hide the Spawn Counter
	sleep 1;
	_layer = "BIS_fnc_respawnCounter" call bis_fnc_rscLayer;
	_layer cutText ["", "plain"];
	// Start Spectator
	sleep 2;
	[] call f_fnc_spectateInit;
};