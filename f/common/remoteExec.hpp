class Commands {
	// Can target anyone, don't allow to jip
	class diag_log { allowedTargets=0; }; 					
	class systemChat { allowedTargets=0; };				// Generic
	class execVM { allowedTargets=0; };					// f_setGroupIDs.sqf
	class reveal { allowedTargets=0; }; 				// fn_tfr_aiHearing.sqf
	class setFace { allowedTargets=0; jip=1; }; 		// f_assignGear_clothes.sqf
	class radioChannelAdd { allowedTargets=0; }; 		// restricted_radios.sqf
	class radioChannelRemove { allowedTargets=0; }; 	// restricted_radios.sqf
	class setCurrentChannel { allowedTargets=0; }; 		// restricted_radios.sqf
	class setPylonLoadout { allowedTargets=0; }; 		// f_pylons.sqf
	class setDir { allowedTargets=0; }; 				// FAR Revive.sqf
	class TitleText { allowedTargets=0; }; 				// FAR Revive.sqf
	class switchMove { allowedTargets=0; }; 			// FAR Revive.sqf
	class playActionNow { allowedTargets=0; }; 			// FAR Revive.sqf
	class setUnconscious { allowedTargets=0; }; 		// FAR Revive.sqf
	class action { allowedTargets=0; }; 				// FAR Revive.sqf
	class setPlayerRespawnTime { allowedTargets=0; }	// Wave Respawn
	class animatedoor { allowedTargets=0; }; 			// RHS
	class lockturret { allowedTargets=0; };				// RHS
};
class Functions {
	class BIS_fnc_setTaskLocal { allowedTargets=0; };			// Generic
	class BIS_fnc_effectKilledAirDestruction { allowedTargets=0; };	// Generic
	class BIS_fnc_effectKilledSecondaries { allowedTargets=0; };	// Generic
	class BIS_fnc_loadInventory { allowedTargets=0; };			// Generic
	class BIS_fnc_objectVar { allowedTargets=0; };				// Prereq for execVM
	class BIS_fnc_spawn { allowedTargets=0; jip=1; }; 			// fn_casualtiesCapCheck.sqf
	class BIS_fnc_execVM { allowedTargets=0; }; 				// f_safeStartLoop.sqf
	class BIS_fnc_showNotification { allowedTargets=0; }; 		// f_breifing_admin.sqf
	class f_fnc_zeusInit { allowedTargets=2; }; 				// f_breifing_admin.sqf
	class f_fnc_zeusTerm { allowedTargets=2; };					// f_breifing_admin.sqf
	class f_fnc_zeusAddAddons { allowedTargets=2; };			// f_breifing_admin.sqf
	class f_fnc_zeusAddObjects { allowedTargets=2; }; 			// f_breifing_admin.sqf
	class f_fnc_safety { allowedTargets=0; jip=1; };			// f_safeStartLoop.sqf
	class f_fnc_assignGear { allowedTargets=0; };				// f_assignGear_AI.sqf
	class f_fnc_updateCas { allowedTargets=2; }; 				// fn_casualtiesCapCheck.sqf
	class f_fnc_mapClickTeleportGroup { allowedTargets=0; };	// fn_mapClickTeleportUnit.sqf
	class f_fnc_radioSwitchChannel { allowedTargets=0; };		// restricted_radios.sqf
};