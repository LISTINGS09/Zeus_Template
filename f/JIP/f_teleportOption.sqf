// 	Zeus - Join-In-Progress Teleport Option
//  Description: Allows players to quickly teleport to their team.
//  Parameters
//		1. Boolean - Add a JIP action for the player.
//		2. Boolean - Create a local spawn flag for the player with JIP Action.
//	Returns:
//		Nothing.
// 	Example:
// 		[true, false] execVM "f\JIP\f_teleportOption.sqf";
//
// 	0 = Disable, 1 = AddAction Only, 2 = FlagPole Only, 3 = Both
//	f_param_jipTeleport = 3; 		
// Give player time to get in-game.
sleep 5;

// Exit if player is dead, non-player or not enabled.
if (!alive player || !hasInterface || playerSide == sideLogic) exitWith {};

// Is the variable set?
if (isNil "f_param_jipTeleport") then { f_param_jipTeleport = 3 };

// Exit if disabled
if (missionNamespace getVariable["f_param_jipTeleport", 0] == 0) exitWith {};

// Set defaults.
params [
	["_spawnAction", (switch (f_param_jipTeleport) do { case 1; case 3: { true }; default { false } }) ],
	["_spawnFlag", (switch (f_param_jipTeleport) do { case 2; case 3: { true }; default { false } }) ]
];

// If both flag and action has been disabled, exit.
if (!_spawnFlag && !_spawnAction) exitWith {};

// Set up move player function
if (isNil "f_fnc_teleportPlayer") then { f_fnc_teleportPlayer = compileFinal preprocessFileLineNumbers "f\JIP\fn_teleportPlayer.sqf"; };

// ====================================================================================

// Create JIP Flag
if _spawnFlag then {
	private _flagType = "Flag_White_F";
	private _flagMarker = "respawn_civilian";

	switch (side group player) do {
		case west		: { _flagType = "Flag_Blue_F"; 	_flagMarker = "respawn_west"; };
		case east		: { _flagType = "Flag_Red_F"; 	_flagMarker = "respawn_east"; };
		case resistance	: { _flagType = "Flag_Green_F"; _flagMarker = "respawn_guerrila"; };
	};

	if (_flagMarker in allMapMarkers) then {
		if (isNil "f_obj_spawnFlag") then {
			private _mrkPos = getMarkerPos _flagMarker;
			_mrkPos set [2,0];
			
			f_obj_spawnFlag = _flagType createVehicleLocal _mrkPos;
			sleep 0.1;
			
			// Don't spawn on seabed.
			if (underwater f_obj_spawnFlag) then {
				_flagStone = "Land_W_sharpStone_02" createVehicleLocal [0,0,0];		
				_flagStone setPosASL [_mrkPos#0,_mrkPos#1,-1];
				f_obj_spawnFlag setPosASL (lineIntersectsSurfaces [_mrkPos vectorAdd [0,0,1000], AGLToASL _mrkPos] #0 #0);
			};
		};

		f_obj_spawnFlag addAction ["<t color='#80FF00'>Spawn on Team</t>",f_fnc_teleportPlayer];
	} else {
		if (_flagMarker != "respawn_civilian") then {
			["f_teleportOption.sqf",format["No respawn marker found for %1.",side (group player)]] call f_fnc_logIssue;
		};
	};
};

// ====================================================================================

// Create Action
if _spawnAction then {
	// Re-add the action if enabled.
	if (missionNamespace getVariable ["f_param_jipRespawn", false] && isNil "f_param_jipEHID") then {
		f_param_jipEHID = player addEventHandler ["Respawn",{execVM "f\JIP\f_teleportOption.sqf";}];
	};
	
	// Don't run if mission has just started.
	if (time < 10) exitWith {};

	private ["_teleAction","_preText","_postText","_timer"];
	
	_timer = 900;
	_preText = "<br/><t size='1.4' color='#72E500'>Spawn On Team</t><br/><br/>This mission has JIP Teleport enabled.<br/><br/>";
	_postText = format["This option will automatically be removed after %1 minutes, if not used.<br/><br/>",round(_timer / 60)];

	// If client has ACE, use ACE Interact Menu
	if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {
		hintSilent parseText (_preText + "To use this feature open your <t color='#80FF00'>ACE Self-Interaction</t> menu <t color='#777777'>(Windows Key + Left Ctrl)</t> then go to <t color='#80FF00'>Team Management</t><br/> and select <t color='#80FF00'>Spawn on Team</t><br/><br/><br/>" + _postText);
		systemChat "Spawn On Team is ENABLED - Use: ACE Self-Interact > Team Management";
		ace_jip_action = ['JIP','Spawn on Team','\a3\Ui_f\data\Map\Diary\Icons\unitgroupplayable_ca.paa',f_fnc_teleportPlayer,{true}] call ace_interact_menu_fnc_createAction;
		[player, 1, ["ACE_SelfActions","ACE_TeamManagement"], ace_jip_action] call ace_interact_menu_fnc_addActionToObject;
		sleep _timer;
		[player, 1, ["ACE_SelfActions","ACE_TeamManagement","JIP"]] call ace_interact_menu_fnc_removeActionFromObject;
	} else {
		// Vanilla Action Menu
		hintSilent parseText (_preText + "Use <t color='#80FF00'>Action Menu</t> <t color='#777777'>(Mouse Wheel)</t> to spawn near your teams current location.<br/><br/><br/>" + _postText);
		systemChat "Spawn On Team is ENABLED - Check Action Menu";
		_teleAction = player addAction ["<t color='#80FF00'>Spawn on Team</t>",f_fnc_teleportPlayer];
		sleep _timer;
		player removeAction _teleAction;
	};
};