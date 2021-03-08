// Should safely teleport a player to their team, or another player of same side.
if (count (playableUnits + switchableUnits) < 2) exitWith {
	systemChat "[JIP] Failed - No other units are present!";
};

// We don't want to include players at spawn
private _nearbyUnits = (position player) nearEntities [["Man"], 100];
private _refUnitArray = [];

// Try group members to teleport to first
{
	if (alive _x) then { _refUnitArray pushBack _x; }; 
} forEach (units group player) - _nearbyUnits;

// Find any friendly member to teleport to
if (count _refUnitArray == 0) then {
	{ 
		if ((side _x) == playerSide && _x != player && alive _x) then {
			_refUnitArray pushBack _x;
		}; 
	} forEach allUnits - _nearbyUnits;
};

// We didn't find anyone!
if (count _refUnitArray == 0) exitWith {
	systemChat "[JIP] Failed - No players found outside of 100m!";
};

private _refUnit = _refUnitArray select 0;
private _removeAction = true;

// If the JIP unit's team member is in a vehicle, put him in too
// The code has fail-safe logic in case the vehicle is full
if (vehicle _refUnit != _refUnit) then {	// Member is in vehicle	
	_result = player moveInAny (vehicle _refUnit);
	
	if !_result then {	// We failed to move JIP to vehicle!
		systemChat format["[JIP] Failed - Cannot Join on %1 - Insufficient space in vehicle! Try later.",name _refUnit];
		_removeAction = false;
	} else {
		systemChat format["[JIP] Moved into %1's (%2) vehicle.",name _refUnit, groupId (group _refUnit), vehicle _refUnit];
	};
} else {
	// No safe position? Move them directly to the unit.
	if (isTouchingGround _refUnit) then {
		player setPos (_refUnit modelToWorld [0,-0.1,0]); 
		systemChat format["[JIP] Moved behind %1 (%2)",name _refUnit, groupId (group _refUnit), round (player distance2D _refUnit)];
		
		switch (stance _refUnit) do {
			case "PRONE": { player playAction "PlayerProne" };
			case "CROUCH": { player playAction "PlayerCrouch" };
		};
	} else {
		// Find a safe pos at ground level in case of HALO.
		private _pos = [getPos _refUnit select 0, getPos _refUnit select 1, 0] findEmptyPosition [0,50];
		
		if (_pos isEqualTo []) then { 
			// In the air? Set them to ground level.
			player setPos [getPos _refUnit select 0, getPos _refUnit select 1, 0]; 
			systemChat format["[JIP] Moved below %1 (%2) - Empty position not found.",name _refUnit, groupId (group _refUnit), round (player distance2D _refUnit)];
		} else {
			player setPos _pos;
			systemChat format["[JIP] Moved %3m from %1 (%2)",name _refUnit, groupId (group _refUnit), round (player distance2D _refUnit)];
		};
	};

};

if (_removeAction) then {
	if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {
		[player, 1, ["ACE_SelfActions","ACE_TeamManagement","JIP"]] call ace_interact_menu_fnc_removeActionFromObject;
	} else {
		player removeAction (_this select 2);
	};
};

hintSilent ""; // Remove the hint if present.