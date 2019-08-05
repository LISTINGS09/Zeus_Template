// Farooq's Revive 2.1 (2600K Edit)

// Parameters - If not set in scripts.sqf defaults will be used below.
if (isNil "FAR_var_InstantDeath") 	then { FAR_var_InstantDeath = 	FALSE };	// Heavy hits to head and body will instantly kill.
if (isNil "FAR_var_DeathChance") 	then { FAR_var_DeathChance = 	15 };		// Percent to randomly survive an instant kill (head and body).
if (isNil "FAR_var_DeathDmgHead") 	then { FAR_var_DeathDmgHead = 	1.2 };		// Kill when damage to the head is over this value.
if (isNil "FAR_var_DeathDmgBody") 	then { FAR_var_DeathDmgBody = 	2 };		// Kill when damage to the body is over this value.
if (isNil "FAR_var_BleedOut") 		then { FAR_var_BleedOut = 		180 };		// Seconds until unconscious unit bleeds out and dies. Set to 0 to disable.
if (isNil "FAR_var_RespawnBagTime") then { FAR_var_RespawnBagTime = 180 };		// Time for player to respawn (if allowed). Set to 0 or less to disable.
if (isNil "FAR_var_ReviveMode") 	then { FAR_var_ReviveMode = 	2 };		// 0 = Only medics can revive  1 = All units can revive (Uses 1 FAK)  2 = Same as 1 but a medikit is required to revive
if (isNil "FAR_var_DeathMessages")	then { FAR_var_DeathMessages = 	TRUE };		// Enable Team Kill notifications
if (isNil "FAR_var_SpawnInMedical")	then { FAR_var_SpawnInMedical = TRUE };		// Units respawn in the nearest medical vehicle (if available and respawn enabled).
if (isNil "FAR_var_AICanHeal")		then { FAR_var_AICanHeal = FALSE };			// Nearest AI in team will automatically revive players.

call compile preprocessFileLineNumbers "f\medical\FAR_revive\FAR_revive_funcs.sqf";

if isDedicated exitWith {};

// Create PP effects
FAR_eff_ppVig = ppEffectCreate ["ColorCorrections", 1633];
FAR_eff_ppBlur = ppEffectCreate ["DynamicBlur", 525];
FAR_Medkit = ["Medikit","gm_gc_army_medkit","gm_ge_army_medkit_80"];
FAR_FAK = ["FirstAidKit","gm_gc_army_gauzeBandage","gm_ge_army_burnBandage","gm_ge_army_gauzeBandage","gm_ge_army_gauzeCompress"];

// Player Initialization
[] spawn {
    waitUntil { !isNull player };
	
	player addEventHandler ["HandleDamage", FAR_fnc_HandleDamage]; // Persistent after respawn
	[player] spawn FAR_fnc_unitInit;
	
	// If vehicle list isn't populated, fill it
	if (FAR_var_SpawnInMedical && isNil "FAR_var_MedicalVehs") then { FAR_var_MedicalVehs = [] call FAR_fnc_getMedicalVehicles };
};

// [Debugging] Add revive to playable AI units
if (isMultiplayer) exitWith {};

addMissionEventHandler ["TeamSwitch", { params ["_previousUnit", "_newUnit"]; _previousUnit enableAI "TeamSwitch"; [_previousUnit, _newUnit] spawn FAR_fnc_PlayerActions; }];

{
	if (!isPlayer _x && _x getVariable["FAR_var_isDragged", TRUE]) then { 
		_x addEventHandler ["HandleDamage", FAR_fnc_HandleDamage];
		[_x] spawn FAR_fnc_unitInit
	};
} forEach switchableUnits;