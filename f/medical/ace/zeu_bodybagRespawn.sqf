// Body Bag Respawn - v1.0 by 2600K
// Respawns a player when they're placed in a body bag, 300 secs by default.
// Enabled by default if ACE is running.

if (isNil "f_param_bodybagRespawn") then { f_param_bodybagRespawn = false };	// Should Dog Tag respawn be enabled? Disabled by default.

// Exit if you're not one of the chosen.
if (!f_param_bodybagRespawn || !(isClass(configFile >> "CfgPatches" >> "ace_main"))) exitWith {};

zeu_bag_check = {
 	params ["_target", "_bodyBag"];
	
	if (!isPlayer _target || !local _target || alive player) exitWith {};
	
	private _resTime = missionNamespace getVariable["f_param_bodybagTime", 300];
	
	if (playerRespawnTime > _resTime) then { 
		setPlayerRespawnTime _resTime;

		private _layer = "BIS_fnc_respawnCounter" call bis_fnc_rscLayer; 
		RscRespawnCounter_Custom = _resTime; 
		RscRespawnCounter_description = "";
		_layer cutRsc ["RscRespawnCounter","PLAIN"];
			
		titleText [format["<t size='2'>Your body was recovered. Respawn in %1 Minutes<br/>", round _resTime / 60], "PLAIN DOWN", 2, true, true];
	};
};

["ace_placedInBodyBag", zeu_bag_check] call CBA_fnc_addEventHandler;

player createDiaryRecord ["Diary", ["Body Bag", 
	format["<br/><font size='18' color='#80FF00'>Body Recovery</font><br/>Body Bag respawn is active - Any bagged player will respawn in <font color='#00FFFF'>%1 Seconds</font color>.",
		missionNamespace getVariable["f_param_bodybagTime", 300]
	]
]];