// F3 - Mission Maker Teleport
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================

// DECLARE VARIABLES AND FUNCTIONS

private ["_textSelect","_textDone"];

// ====================================================================================

// SET KEY VARIABLES

f_telePositionSelected = false;
if (isNil "f_var_mapClickTeleport_Used") then {f_var_mapClickTeleport_Used = 0};

// ====================================================================================

// TELEPORT FUNCTIONALITY
// Open the map for the player and display a notification, then set either the player's vehicle
// or the unit to the new position. If the group needs to be teleported too, set the group's position
// as well.

player groupChat format["Click a location on the map to %1.", (if (f_var_mapClickTeleport_Height == 0) then {"Fast Travel"} else {"HALO Drop"})];
openMap [true, false];
onMapSingleClick "f_var_mapClickTeleport_telePos = _pos; f_telePositionSelected = true";
waitUntil {sleep 0.1;f_telePositionSelected;};

// HALO - set height
if (f_var_mapClickTeleport_Height > 0) then {
	f_var_mapClickTeleport_telePos = [f_var_mapClickTeleport_telePos select 0, f_var_mapClickTeleport_telePos select 1, f_var_mapClickTeleport_Height];
};

// Move player
// If the player is in a vehicle and not HALO-ing, the complete vehicle is moved. Otherwise the player is teleported.
if (vehicle player != player && f_var_mapClickTeleport_Height == 0) then {
	(vehicle player) setPos (f_var_mapClickTeleport_telePos findEmptyPosition [0, 50, typeOf (vehicle player)]);
} else {
	player setPos f_var_mapClickTeleport_telePos;
	//player setPosASL (lineIntersectsSurfaces [AGLToASL f_var_mapClickTeleport_telePos vectorAdd [0,0,1000], AGLToASL f_var_mapClickTeleport_telePos] #0 #0);
};

if (f_var_mapClickTeleport_Height > 0) then {
	cutText ["", "BLACK FADED",999];
	[player] spawn f_fnc_mapClickHaloEffect;
};

// Move group
// If enabled, the player's group is moved next to him

if (f_var_mapClickTeleport_GroupTeleport) then {
	sleep 0.1;
	{
		if (_x distance2D player > 50) then {
			[_x,f_var_mapClickTeleport_telePos] remoteExec ["f_fnc_mapClickTeleportGroup",_x];
		};
	} forEach ((units group player) - [player]);
};

openMap false;

// ====================================================================================

// REMOVE AND READ ACTION
// Remove the action and re-add if we have uses left (or if they are infinite)

if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {
	[player, 1, ["ACE_SelfActions","ACE_TeamManagement","PAR"]] call ace_interact_menu_fnc_removeActionFromObject;
} else {
	if (!isNil "f_mapClickTeleportAction") then { player removeAction f_mapClickTeleportAction };
};

f_var_mapClickTeleport_Used = f_var_mapClickTeleport_Used + 1;

if (f_var_mapClickTeleport_Uses == 0 || f_var_mapClickTeleport_Used < f_var_mapClickTeleport_Uses) then {
	if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {
		[player, 1, ["ACE_SelfActions","ACE_TeamManagement"], ace_par_action] call ace_interact_menu_fnc_addActionToObject;
	} else {
		f_mapClickTeleportAction = player addAction [f_var_mapClickTeleport_textAction,{[] spawn f_fnc_mapClickTeleportUnit},"", 0, false,true,"","_this == player"];
	};
};