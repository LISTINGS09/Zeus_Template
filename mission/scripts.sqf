// MISSION VARAIBLES
player addRating 100000;
[player, "NoVoice"] remoteExec ["setSpeaker", -2, format["NoVoice_%1", netId player]]; // No player voice
showSubtitles false; // No radio calls
"Group" setDynamicSimulationDistance 800;
enableEngineArtillery false; 	// Disable Artillery Computer
//onMapSingleClick "_shift";	// Disable Map Clicking
f_param_groupMarkers = 3; 		// 0 = Disable, 1 = On Map, 2 = On Map + Screen, 3 = Map + Squad Stats, 4 = Commander Map Only, 5 = Commander Map + Squad Stats
f_param_thirdPerson = 0; 		// 0 = Disable, 1 = In Vehicles Only, 2 = Not Allowed (TvT)
f_param_jipTeleport = 3; 		// 0 = Disable, 1 = AddAction Only, 2 = FlagPole Only, 3 = Both
f_var_AuthorUID = '76561197970695190'; // Allows GUID to access Admin/Zeus features in MP.
//f_var_fogOverride = [[0,0,0],[0.1,0.005,100],[0.1,0.04,100],[0.1,random 0.02,100]]; // Override default fog settings [[none],[Light],[heavy],[rand]].
//[] spawn {sleep 1; tao_foldmap_isOpen = true;}; // Disable TAO Folding Map
//[] spawn {sleep 5; ZEU_tkLog_mpKilledEH = {};}; // Disable Zeus TK Spam
// ====================================================================================
// F3 - Casualty Cap - Sides: west | east | resistance - Format: [SIDE,ENDING,<PERCENT>]
//[west,2] execVM "f\casualtiesCap\f_CasualtiesCapCheck.sqf";
//[east,2] execVM "f\casualtiesCap\f_CasualtiesCapCheck.sqf";
//[resistance,2] execVM "f\casualtiesCap\f_CasualtiesCapCheck.sqf";
//[west,{f_var_casualtyLimitHit = true;}] execVM "f\casualtiesCap\f_CasualtiesCapCheck.sqf"; // Alternative use with trigger.
// ====================================================================================
// F3 - Map Click Teleport
// [1,600,true,[],3000] execVM "f\mapClickTeleport\f_mapClickTeleportAction.sqf";	// Set for HALO (3000m Height)
// [] execVM "f\mapClickTeleport\f_mapClickTeleportAction.sqf"; 					// Use Defaults (Land Teleport, Leaders Only)
// ====================================================================================
// [RESISTANCE,"acc_flashlight"] execVM "scripts\flashLight.sqf";			// AI Flashlights
// DAC_Basic_Value = 0; execVM "scripts\DAC\DAC_Config_Creator.sqf";		// DAC
// [] execVM "scripts\civPopulation.sqf";									// Civ Spawner
// ====================================================================================
// Remove Enemy weapons on death
if isServer then {
	addMissionEventHandler ["EntityKilled", {
		params ["_unit"];
		if (_unit isKindOf "CAManBase" && !(isPlayer _unit)) then {
				_unit removeWeapon (primaryWeapon _unit); 
				_unit removeWeapon (secondaryWeapon _unit);
		};
	}];
};
// ====================================================================================
// Post-process effects
/* if (hasInterface) then {
	_hdl = ppEffectCreate ["colorCorrections", 1501];
	_hdl ppEffectEnable true;			
		// Pick One:
		//_hdl ppEffectAdjust [1, 0.4, 0, [0.8,0.9,1,-0.1], [1,1,1,1.66], [-0.5,0,-1,5]]; // Arma2 Tones
		//_hdl ppEffectAdjust [.6, 1.0, 0.0, [0.84, 0.67, 0.44, 0.22], [0.81, 0.76, 0.64, 0.43], [0.81, 0.77, 0.62, 0.31]]; // light beige/dessert
		//_hdl ppEffectAdjust [1,1,0,[0.1,0.2,0.3,-0.3],[1,1,1,0.5],[0.5,0.2,0,1]]; // Real Is Brown 2
		//_hdl ppEffectAdjust [1, 1.1, 0.0, [0.0, 0.0, 0.0, 0.0], [1.0,0.7, 0.6, 0.60], [0.200, 0.600, 0.100, 0.0]]; // Nightstalkers
		//_hdl ppEffectAdjust [1.0, 1.0, 0.0,[1.0, 1.0, 1.0, 0.0],[1.0, 1.0, 0.9, 0.35],[0.3,0.3,0.3,-0.1]]; // Gray Tone
		//_hdl ppEffectAdjust [1.0, 1.0, 0.0,[0.2, 0.2, 1.0, 0.0],[0.4, 0.75, 1.0, 0.60],[0.5,0.3,1.0,-0.1]]; // Cold Tone
		//_hdl ppEffectAdjust [0.9, 1, 0, [0.1, 0.1, 0.1, -0.1], [1, 1, 0.8, 0.528],  [1, 0.2, 0, 0]]; // Takistan
	_hdl ppEffectCommit 0;
};*/