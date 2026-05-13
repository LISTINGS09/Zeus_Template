/*
	Author: 2600K / Josef Zemanek

	Description:
	Enemy Reinforcements Spawner
	
	_nul = [getMarkerPos "Objective"] execVM "scripts\qrfSpawn.sqf";
	_nul = [thisTrigger] execVM "scripts\qrfSpawn.sqf";
	_nul = [TR_QRF] execVM "scripts\qrfSpawn.sqf";
	
	Any marker containing text 'safezone' will not spawn units.
	Any marker containing text 'spawn' will act as an additional spawn point.
*/
ZQR_version = 1.4;
if !isServer exitWith {};

params [
	"_destination",			// Hunt/Search location.
	["_delay", 300],		// Seconds between waves.
	["_waveMax", 6],		// Maximum Wave #
	["_spawnDist", 1200]	// Spawning Distance
];

// Configuration - Pick ONE side.

/*

//**********************
//*** VANILLA GROUPS ***
//**********************

// WEST - NATO TANOA (VANILLA)
_side = WEST;
ZMM_WEST_Man = ["B_T_Soldier_F","B_T_soldier_LAT_F","B_T_Soldier_F","B_T_soldier_AR_F","B_T_Soldier_F","B_T_Soldier_TL_F","B_T_Soldier_F",selectRandom["B_T_Soldier_AA_F","B_T_Soldier_AT_F"]];
ZMM_WEST_Truck = [configFile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Motorized" >> "B_T_MotInf_Reinforcements"];
ZMM_WEST_Light = ["B_T_MRAP_01_gmg_F","B_T_MRAP_01_hmg_F","B_T_LSV_01_AT_F","B_T_LSV_01_armed_F"];
ZMM_WEST_Medium = [["B_T_AFV_Wheeled_01_up_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"],["B_T_APC_Wheeled_01_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5,'showSLATHull',0.6,'showSLATTurret',0.3]] call BIS_fnc_initVehicle;"],["B_T_APC_Tracked_01_rcws_F","[_grpVeh,false,['showCamonetHull',0.3]] call BIS_fnc_initVehicle;"]];
ZMM_WEST_Heavy = [["B_T_APC_Tracked_01_AA_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"],["B_T_MBT_01_TUSK_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"]];
ZMM_WEST_Air = ["B_Heli_Light_01_F",["B_Heli_Transport_01_F","[_grpVeh,['Green',1]] call BIS_fnc_initVehicle;"],"B_Heli_Transport_03_F"];
ZMM_WEST_Cas = ["B_Heli_Light_01_dynamicLoadout_F",["B_Heli_Attack_01_dynamicLoadout_F","_grpVeh setPylonLoadout [3,'PylonRack_12Rnd_missiles'];_grpVeh setPylonLoadout [4,'PylonRack_12Rnd_missiles'];"],["B_Plane_CAS_01_dynamicLoadout_F","_grpVeh setPylonLoadout [3,'PylonRack_7Rnd_Rocket_04_HE_F'];_grpVeh setPylonLoadout [4,'PylonMissile_1Rnd_Mk82_F'];_grpVeh setPylonLoadout [5,'PylonMissile_1Rnd_BombCluster_03_F'];_grpVeh setPylonLoadout [6,'PylonMissile_1Rnd_BombCluster_03_F'];_grpVeh setPylonLoadout [7,'PylonMissile_1Rnd_Mk82_F'];_grpVeh setPylonLoadout [8,'PylonRack_7Rnd_Rocket_04_AP_F'];"]];
ZMM_WEST_Boat = ["B_Boat_Armed_01_minigun_F","I_C_Boat_Transport_02_F","EF_B_CombatBoat_HMG_NATO"];

// WEST - NATO (VANILLA)
_side = WEST;
ZMM_WEST_Man = ["B_Soldier_F","B_soldier_LAT_F","B_Soldier_F","B_soldier_AR_F","B_Soldier_F","B_Soldier_TL_F","B_Soldier_F",selectRandom["B_Soldier_AA_F","B_Soldier_AT_F"]];
ZMM_WEST_Truck = [configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Motorized" >> "BUS_MotInf_Reinforce"];
ZMM_WEST_Light = ["B_MRAP_01_gmg_F","B_MRAP_01_hmg_F","B_LSV_01_AT_F","B_LSV_01_armed_F"];
ZMM_WEST_Medium = [["B_AFV_Wheeled_01_up_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"],["B_APC_Wheeled_01_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5,'showSLATHull',0.6,'showSLATTurret',0.3]] call BIS_fnc_initVehicle;"],["B_APC_Tracked_01_rcws_F","[_grpVeh,false,['showCamonetHull',0.3]] call BIS_fnc_initVehicle;"]];
ZMM_WEST_Heavy = [["B_APC_Tracked_01_AA_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"],["B_MBT_01_TUSK_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"]];
ZMM_WEST_Air = ["B_Heli_Light_01_F","B_Heli_Transport_01_F",["B_Heli_Transport_03_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;"]];
ZMM_WEST_Cas = ["B_Heli_Light_01_dynamicLoadout_F",["B_Heli_Attack_01_dynamicLoadout_F","_grpVeh setPylonLoadout [3,'PylonRack_12Rnd_missiles'];_grpVeh setPylonLoadout [4,'PylonRack_12Rnd_missiles'];"],["B_Plane_CAS_01_dynamicLoadout_F","_grpVeh setPylonLoadout [3,'PylonRack_7Rnd_Rocket_04_HE_F'];_grpVeh setPylonLoadout [4,'PylonMissile_1Rnd_Mk82_F'];_grpVeh setPylonLoadout [5,'PylonMissile_1Rnd_BombCluster_03_F'];_grpVeh setPylonLoadout [6,'PylonMissile_1Rnd_BombCluster_03_F'];_grpVeh setPylonLoadout [7,'PylonMissile_1Rnd_Mk82_F'];_grpVeh setPylonLoadout [8,'PylonRack_7Rnd_Rocket_04_AP_F'];"]];
ZMM_WEST_Boat = ["B_Boat_Armed_01_minigun_F","I_C_Boat_Transport_02_F",["EF_B_CombatBoat_HMG_NATO","[_grpVeh,['Grey',1]] call BIS_fnc_initVehicle;"]];

// WEST - NATO (WOODLAND)
ZMM_WEST_Man = ["B_W_Soldier_F","B_W_soldier_AR_F","B_W_Soldier_F","B_W_Soldier_TL_F","B_W_Soldier_F","B_W_Soldier_LAT2_F","B_W_Soldier_F",selectRandom["B_W_Soldier_AA_F","B_W_Soldier_AT_F"]];
ZMM_WEST_Truck = ["B_T_Truck_01_covered_F"];
ZMM_WEST_Light = ["B_T_MRAP_01_gmg_F","B_T_MRAP_01_hmg_F","B_T_LSV_01_AT_F","B_T_LSV_01_armed_F"];
ZMM_WEST_Medium = [["B_T_AFV_Wheeled_01_up_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"],["B_T_APC_Wheeled_01_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5,'showSLATHull',0.6,'showSLATTurret',0.3]] call BIS_fnc_initVehicle;"],["B_T_APC_Tracked_01_rcws_F","[_grpVeh,false,['showCamonetHull',0.3]] call BIS_fnc_initVehicle;"]];
ZMM_WEST_Heavy = [["B_T_APC_Tracked_01_AA_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"],["B_T_MBT_01_TUSK_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"]];
ZMM_WEST_Air = ["B_Heli_Light_01_F",["B_Heli_Transport_01_F","[_grpVeh,['Green',1]] call BIS_fnc_initVehicle;"],"B_Heli_Transport_03_F"];
ZMM_WEST_Cas = ["B_Heli_Light_01_dynamicLoadout_F","B_Heli_Attack_01_dynamicLoadout_F"];
ZMM_WEST_Boat = ["B_Boat_Armed_01_minigun_F","I_C_Boat_Transport_02_F","EF_B_CombatBoat_HMG_NATO"];

// WEST - FIA (VANILLA)
_side = WEST;
ZMM_WEST_Man = ["B_G_Soldier_F","B_G_Soldier_LAT_F","B_G_Soldier_F","B_G_Soldier_SL_F","B_G_Soldier_F","B_G_Soldier_AR_F"];
Truck = ["B_G_Van_01_transport_F"];
ZMM_WEST_Light = ["B_G_Offroad_01_AT_F","B_G_Offroad_01_armed_F"];
ZMM_WEST_Medium = [["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_02',1],['showSLATHull',0.3]] call BIS_fnc_initVehicle;"]];
ZMM_WEST_Heavy = [["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_02',1],['showSLATHull',0.7]] call BIS_fnc_initVehicle;"]];
ZMM_WEST_Air = [["B_Heli_Light_01_F","_grpVeh setObjectTextureGlobal [0, selectRandom['\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_graywatcher_co.paa','\A3\air_f\heli_light_01\data\heli_light_01_ext_ion_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_wasp_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_shadow_co.paa']];"]];
ZMM_WEST_Cas = [["B_Heli_Light_01_dynamicLoadout_F","_grpVeh setObjectTextureGlobal [0, selectRandom['\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_graywatcher_co.paa','\A3\air_f\heli_light_01\data\heli_light_01_ext_ion_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_wasp_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_shadow_co.paa']];"]];
ZMM_WEST_Boat = ["I_C_Boat_Transport_02_F"];

// WEST - GENDARME (VANILLA)
_side = WEST;
ZMM_WEST_Man = ["B_GEN_Soldier_F","B_GEN_Commander_F","B_GEN_Soldier_F","B_GEN_Soldier_F"];
Truck = ["B_GEN_Van_02_transport_F"];
ZMM_WEST_Light = [["B_G_Offroad_01_armed_F","[_grpVeh,false,['HideDoor1',0,'HideDoor2',0,'HideDoor3',0,'HideBackpacks',1,'HideBumper1',0,'HideBumper2',1,'HideConstruction',0]] call BIS_fnc_initVehicle;_grpVeh setObjectTextureGlobal [0,'\A3\Soft_F_Exp\Offroad_01\Data\Offroad_01_ext_gen_CO.paa']"]];
ZMM_WEST_Medium =[["O_MRAP_02_hmg_F","_grpVeh setObjectTextureGlobal [0,'#(rgb,8,8,3)color(0.7,0.8,1,0.03)'];_grpVeh setObjectTextureGlobal [1,'#(rgb,8,8,3)color(1,1,1,0.01)'];_grpVeh setObjectTextureGlobal [2,'#(rgb,8,8,3)color(1,1,1,0.01)'];"]];
ZMM_WEST_Heavy = [["O_T_APC_Wheeled_02_rcws_v2_ghex_F","_grpVeh setObjectTextureGlobal [0,'#(rgb,8,8,3)color(0.7,0.8,1,0.03)'];_grpVeh setObjectTextureGlobal [1,'#(rgb,8,8,3)color(1,1,1,0.01)'];_grpVeh setObjectTextureGlobal [2,'#(rgb,8,8,3)color(1,1,1,0.01)'];_grpVeh setObjectTextureGlobal [4,'#(rgb,8,8,3)color(0,0,0,1)'];"]];
ZMM_WEST_Air = [["I_Heli_Transport_02_F","_grpVeh setObjectTextureGlobal [0,'a3\air_f_beta\Heli_Transport_02\Data\Skins\heli_transport_02_1_ion_co.paa'];_grpVeh setObjectTextureGlobal [1,'a3\air_f_beta\Heli_Transport_02\Data\Skins\heli_transport_02_2_ion_co.paa'];_grpVeh setObjectTextureGlobal [2,'a3\air_f_beta\Heli_Transport_02\Data\Skins\heli_transport_02_3_ion_co.paa'];"]];
ZMM_WEST_Cas = [];
ZMM_WEST_Boat = ["I_C_Boat_Transport_02_F"];

// EAST - CSAT TANOA (VANILLA)
_side = EAST;
ZMM_EAST_Man = ["O_T_Soldier_F","O_T_Soldier_LAT_F","O_T_Soldier_F","O_T_Soldier_GL_F","O_T_Soldier_F","O_T_Soldier_AR_F","O_T_Soldier_F",selectRandom["O_T_Soldier_AA_F","O_T_Soldier_AT_F"]];
ZMM_EAST_Truck = [configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Motorized_MTP" >> "O_T_MotInf_Reinforcements"];
ZMM_EAST_Light = ["O_T_MRAP_02_hmg_ghex_F","O_T_LSV_02_armed_F"];
ZMM_EAST_Medium = [["O_T_APC_Wheeled_02_rcws_v2_ghex_F","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["O_T_APC_Tracked_02_cannon_ghex_F","[_grpVeh,false,['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
ZMM_EAST_Heavy = [["O_T_APC_Tracked_02_AA_ghex_F","[_grpVeh,false,['showSLATHull',0.5,'showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_T_MBT_02_cannon_ghex_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_T_MBT_04_command_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"]];
ZMM_EAST_Air = [["O_Heli_Light_02_unarmed_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;"],["O_Heli_Transport_04_covered_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;"]];
ZMM_EAST_Cas = [["O_T_VTOL_02_infantry_dynamicLoadout_F","_grpVeh setPylonLoadout [1,'PylonRack_19Rnd_Rocket_Skyfire']; _grpVeh setPylonLoadout [4,'PylonRack_19Rnd_Rocket_Skyfire'];"],["O_Heli_Light_02_dynamicLoadout_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;_grpVeh setPylonLoadout [2,'PylonRack_12Rnd_missiles'];"],["O_Heli_Attack_02_dynamicLoadout_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle; _grpVeh setPylonLoadout [1,'PylonRack_19Rnd_Rocket_Skyfire']; _grpVeh setPylonLoadout [4,'PylonRack_19Rnd_Rocket_Skyfire'];"],"O_Plane_CAS_02_dynamicLoadout_F"];
ZMM_EAST_Boat = ["I_C_Boat_Transport_02_F","O_Boat_Armed_01_hmg_F","EF_O_CombatBoat_HMG_OPF"];

// EAST - CSAT (VANILLA)
_side = EAST;
ZMM_EAST_Man = ["O_Soldier_F","O_Soldier_LAT_F","O_Soldier_F","O_Soldier_GL_F","O_Soldier_F","O_Soldier_AR_F","O_Soldier_F",selectRandom["O_Soldier_AA_F","O_Soldier_AT_F"]];
ZMM_EAST_Truck = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Motorized" >> "OIA_MotInf_Reinforce"];
ZMM_EAST_Light = ["O_MRAP_02_gmg_F","O_MRAP_02_hmg_F","O_LSV_02_AT_F","O_LSV_02_armed_F"];
ZMM_EAST_Medium = [["O_APC_Wheeled_02_rcws_v2_F","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["O_APC_Tracked_02_cannon_F","[_grpVeh,false,['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
ZMM_EAST_Heavy = [["O_APC_Tracked_02_AA_F","[_grpVeh,false,['showSLATHull',0.5,'showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_MBT_02_railgun_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_MBT_02_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_MBT_04_command_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"]];
ZMM_EAST_Air = ["O_Heli_Light_02_unarmed_F","O_Heli_Transport_04_covered_F"];
ZMM_EAST_Cas = [["O_T_VTOL_02_infantry_dynamicLoadout_F","[_grpVeh,['Hex',1]] call BIS_fnc_initVehicle;_grpVeh setPylonLoadout [1,'PylonRack_19Rnd_Rocket_Skyfire']; _grpVeh setPylonLoadout [4,'PylonRack_19Rnd_Rocket_Skyfire'];"],["O_Heli_Light_02_dynamicLoadout_F","_grpVeh setPylonLoadout [2,'PylonRack_12Rnd_missiles'];"],["O_Heli_Attack_02_dynamicLoadout_F", "_grpVeh setPylonLoadout [1,'PylonRack_19Rnd_Rocket_Skyfire']; _grpVeh setPylonLoadout [4,'PylonRack_19Rnd_Rocket_Skyfire'];"],"O_Plane_CAS_02_dynamicLoadout_F"];
ZMM_EAST_Boat = ["I_C_Boat_Transport_02_F","O_Boat_Armed_01_hmg_F","EF_O_CombatBoat_HMG_OPF"];

// EAST - SPETSNAZ (VANILLA)
_side = EAST;
ZMM_EAST_Man = ["O_R_Soldier_TL_F","O_R_soldier_M_F","O_R_Soldier_AR_F","O_R_JTAC_F","O_R_medic_F","O_R_Soldier_LAT_F","O_R_Soldier_GL_F"];
ZMM_EAST_Truck = [configFile >> "CfgGroups" >> "East" >> "OPF_R_F" >> "SpecOps" >> "O_T_MotInf_Reinforcements"];
ZMM_EAST_Light = ["O_T_MRAP_02_hmg_ghex_F","O_T_LSV_02_armed_F"];
ZMM_EAST_Medium = [["O_T_APC_Wheeled_02_rcws_v2_ghex_F","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["O_T_APC_Tracked_02_cannon_ghex_F","[_grpVeh,false,['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
ZMM_EAST_Heavy = [["O_T_APC_Tracked_02_AA_ghex_F","[_grpVeh,false,['showSLATHull',0.5,'showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_T_MBT_02_cannon_ghex_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_T_MBT_04_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"]];
ZMM_EAST_Air = [["O_Heli_Light_02_unarmed_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;"],["O_Heli_Transport_04_bench_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;"]];
ZMM_EAST_Cas = [["O_T_VTOL_02_infantry_dynamicLoadout_F","[_grpVeh,['Grey',1]] call BIS_fnc_initVehicle;_grpVeh setPylonLoadout [1,'PylonRack_19Rnd_Rocket_Skyfire']; _grpVeh setPylonLoadout [4,'PylonRack_19Rnd_Rocket_Skyfire'];"],["O_Heli_Light_02_dynamicLoadout_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;_grpVeh setPylonLoadout [2,'PylonRack_12Rnd_missiles'];"],["O_Heli_Attack_02_dynamicLoadout_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle; _grpVeh setPylonLoadout [1,'PylonRack_19Rnd_Rocket_Skyfire']; _grpVeh setPylonLoadout [4,'PylonRack_19Rnd_Rocket_Skyfire'];"],"O_Plane_CAS_02_dynamicLoadout_F"];
ZMM_EAST_Boat = ["I_C_Boat_Transport_02_F","O_Boat_Armed_01_hmg_F","EF_O_CombatBoat_HMG_OPF"];

// EAST - FIA (VANILLA)
_side = EAST;
ZMM_EAST_Man = ["O_G_Soldier_SL_F","O_G_Soldier_F","O_G_Soldier_AR_F","O_G_Soldier_F","O_G_Soldier_LAT_F","O_G_Soldier_F"];
ZMM_EAST_Truck = ["O_G_Van_01_transport_F"];
ZMM_EAST_Light = ["O_G_Offroad_01_armed_F","O_G_Offroad_01_AT_F"];
ZMM_EAST_Medium = [["I_LT_01_cannon_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["I_LT_01_AT_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
ZMM_EAST_Heavy = [["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_02',1],['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
ZMM_EAST_Air = [["B_Heli_Light_01_F","_grpVeh setObjectTextureGlobal [0, selectRandom['\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_graywatcher_co.paa','\A3\air_f\heli_light_01\data\heli_light_01_ext_ion_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_wasp_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_shadow_co.paa']];"]];
ZMM_EAST_Cas = [["B_Heli_Light_01_dynamicLoadout_F","_grpVeh setObjectTextureGlobal [0, selectRandom['\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_graywatcher_co.paa','\A3\air_f\heli_light_01\data\heli_light_01_ext_ion_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_wasp_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_shadow_co.paa']];"]];
ZMM_EAST_Boat = ["I_C_Boat_Transport_02_F"];

// GUER - SYNDIKAT (VANILLA)
_side = INDEPENDENT;
ZMM_GUER_Man = ["I_C_Soldier_Para_7_F","I_C_Soldier_Para_4_F","I_C_Soldier_Para_1_F","I_C_Soldier_Para_2_F"];
ZMM_GUER_Truck = ["I_C_Van_01_transport_F"];
ZMM_GUER_Light = ["I_C_Offroad_02_LMG_F","I_C_Offroad_02_AT_F"];
ZMM_GUER_Medium = [["I_LT_01_cannon_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["I_LT_01_AT_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
ZMM_GUER_Heavy = [["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_01',1,'Guerilla_03',0.5],['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
ZMM_GUER_Air = ["I_Heli_light_03_unarmed_F"];
ZMM_GUER_Cas = [["I_Heli_light_03_dynamicLoadout_F","[_grpVeh,['Green',1],TRUE] call BIS_fnc_initVehicle;"]];
ZMM_GUER_Boat = ["I_C_Boat_Transport_02_F"];

// GUER - AAF (VANILLA)
_side = INDEPENDENT;
ZMM_GUER_Man = ["I_Soldier_F","I_Soldier_LAT2_F","I_Soldier_F","I_Soldier_GL_F","I_Soldier_F","I_Soldier_AR_F","I_Soldier_F",selectRandom["I_Soldier_AA_F","I_Soldier_AT_F"]];
ZMM_GUER_Truck = [configFile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Motorized" >> "HAF_MotInf_Reinforce"];
ZMM_GUER_Light = ["I_MRAP_03_hmg_F","I_MRAP_03_gmg_F"];
ZMM_GUER_Medium = [["I_LT_01_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["I_LT_01_AT_F","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["I_APC_Wheeled_03_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["I_APC_tracked_03_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3,'showSLATHull',0.5,'showSLATTurret',0.3]] call BIS_fnc_initVehicle;"]];
ZMM_GUER_Heavy = [["I_MBT_03_cannon_F","[_grpVeh,false,['HideTurret',0.3,'HideHull',0.3,'showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"]];
ZMM_GUER_Air = [["I_Heli_light_03_unarmed_F","[_grpVeh,['Indep',1]] call BIS_fnc_initVehicle;"],"I_Heli_Transport_02_F", ["O_Heli_Light_02_unarmed_F","_grpVeh setObjectTextureGlobal [0,'\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa'];"], ["B_Heli_Light_01_F","_grpVeh setObjectTextureGlobal [0,'A3\Air_F\Heli_Light_01\Data\heli_light_01_ext_indp_co.paa'];"]];
ZMM_GUER_Cas = ["I_Heli_light_03_dynamicLoadout_F","I_Plane_Fighter_03_dynamicLoadout_F",["O_Heli_Light_02_dynamicLoadout_F","_grpVeh setObjectTextureGlobal [0,'\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa']; _grpVeh setPylonLoadout [2,'PylonRack_12Rnd_missiles'];"]];
ZMM_GUER_Boat = ["I_C_Boat_Transport_02_F",["EF_B_CombatBoat_HMG_NATO","[_grpVeh,['Grey',1]] call BIS_fnc_initVehicle;"]];

// GUER - LDF (VANILLA)
_side = INDEPENDENT;
ZMM_GUER_Man = ["I_E_Soldier_F","I_E_Soldier_LAT2_F","I_E_Soldier_F","I_E_Soldier_AR_F","I_E_Soldier_F","I_E_Soldier_TL_F","I_E_Soldier_F",selectRandom["I_E_Soldier_AA_F","I_E_Soldier_AT_F"]];
ZMM_GUER_Truck = [configFile >> "CfgGroups" >> "Indep" >> "IND_E_F" >> "Motorized" >> "I_E_MotInf_Reinforcements"];
ZMM_GUER_Light = [["I_G_Offroad_01_armed_F","[_grpVeh,['EAF',1]] call BIS_fnc_initVehicle;"],["I_MRAP_03_HMG_F","{ _grpVeh setObjectTextureGlobal [_forEachIndex,_x] } forEach ['\A3\soft_f_beta\mrap_03\data\mrap_03_ext_co.paa','\A3\data_f\vehicles\turret_co.paa'];"],["I_MRAP_03_GMG_F","{ _grpVeh setObjectTextureGlobal [_forEachIndex,_x] } forEach ['\A3\soft_f_beta\mrap_03\data\mrap_03_ext_co.paa','\A3\data_f\vehicles\turret_co.paa'];"]];
ZMM_GUER_Medium = [["I_LT_01_cannon_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["I_LT_01_AT_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
ZMM_GUER_Heavy = [["I_E_APC_tracked_03_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3,'showSLATHull',0.5,'showSLATTurret',0.3]] call BIS_fnc_initVehicle;"]];
ZMM_GUER_Air = ["I_E_Heli_light_03_unarmed_F"];
ZMM_GUER_Cas = ["I_E_Heli_light_03_dynamicLoadout_F"];
ZMM_GUER_Boat = ["I_C_Boat_Transport_02_F",["EF_B_CombatBoat_HMG_NATO","[_grpVeh,['Grey',1]] call BIS_fnc_initVehicle;"]];


//********************
//*** ADDON GROUPS ***
//********************

// WEST - CDF (RHS)
_side = WEST;
ZMM_WEST_Man = ["rhsgref_cdf_b_reg_machinegunner","rhsgref_cdf_b_reg_rifleman","rhsgref_cdf_b_reg_grenadier","rhsgref_cdf_b_reg_grenadier_rpg"];
ZMM_WEST_Truck = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_cdf_b_ground" >> "rhs_group_cdf_b_gaz66" >> "rhs_group_cdf_b_gaz66_squad", configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_cdf_b_ground" >> "rhs_group_cdf_b_ural" >> "rhs_group_cdf_b_ural_squad"];
ZMM_WEST_Light = ["rhsgref_cdf_b_reg_uaz_ags","rhsgref_cdf_b_reg_uaz_dshkm","rhsgref_cdf_b_reg_uaz_spg9"];
ZMM_WEST_Medium = ["rhsgref_cdf_b_btr70","rhsgref_cdf_b_bmp2k","rhsgref_cdf_b_bmd1k","rhsgref_cdf_b_bmd2k"];
ZMM_WEST_Heavy = ["rhsgref_cdf_b_zsu234","rhsgref_cdf_b_t72bb_tv"];
ZMM_WEST_Air = ["rhsgref_cdf_b_reg_Mi8amt","rhsgref_cdf_b_reg_Mi17Sh"];
ZMM_WEST_Cas = ["rhsgref_cdf_b_Mi35","rhsgref_cdf_b_su25"];
ZMM_WEST_Boat = ["I_C_Boat_Transport_02_F"];

// WEST - US ARMY D (RHS)
_side = WEST;
ZMM_WEST_Man = ["rhsusf_army_ocp_rifleman","rhsusf_army_ocp_machinegunner","rhsusf_army_ocp_grenadier","rhsusf_army_ocp_riflemanat","rhsusf_army_ocp_squadleader"];
ZMM_WEST_Truck = [configFile >> "CfgGroups" >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_d" >> "rhs_group_nato_usarmy_d_RG33" >> "rhs_group_nato_usarmy_d_RG33_m2_squad", configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_d" >> "rhs_group_nato_usarmy_d_RG33" >> "rhs_group_nato_usarmy_d_RG33_squad"];
ZMM_WEST_Light = ["rhsusf_m1025_d_m2","rhsusf_m1025_d_Mk19"];
ZMM_WEST_Medium = ["rhsusf_m113d_usarmy","rhsusf_m113d_usarmy_MK19"];
ZMM_WEST_Heavy = ["RHS_M2A3","RHS_M6","rhsusf_m1a1aimd_usarmy"];
ZMM_WEST_Air = ["RHS_UH60M2_d","RHS_UH60M_d","RHS_MELB_MH6M"];
ZMM_WEST_Cas = ["RHS_MELB_AH6M","RHS_AH64DGrey","RHS_AH1Z"];
ZMM_WEST_Boat = ["I_C_Boat_Transport_02_F"];

// WEST - US ARMY W (RHS)
_side = WEST;
ZMM_WEST_Man = ["rhsusf_army_ucp_rifleman","rhsusf_army_ucp_machinegunner","rhsusf_army_ucp_grenadier","rhsusf_army_ucp_riflemanat","rhsusf_army_ucp_squadleader"];
ZMM_WEST_Truck = [configFile >> "CfgGroups" >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_wd" >> "rhs_group_nato_usarmy_wd_RG33" >> "rhs_group_nato_usarmy_wd_RG33_m2_squad", configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_wd" >> "rhs_group_nato_usarmy_wd_RG33" >> "rhs_group_nato_usarmy_wd_RG33_squad"];
ZMM_WEST_Light = ["rhsusf_m1025_w_m2","rhsusf_m1025_w_Mk19"];
ZMM_WEST_Medium = ["rhsusf_m113_usarmy","rhsusf_m113_usarmy_MK19"];
ZMM_WEST_Heavy = ["RHS_M2A3_wd","RHS_M6_wd","rhsusf_m1a1aimwd_usarmy"];
ZMM_WEST_Air = ["RHS_UH60M2","RHS_UH60M","RHS_MELB_MH6M"];
ZMM_WEST_Cas = ["RHS_MELB_AH6M","RHS_AH64D_wd"];
ZMM_WEST_Boat = ["I_C_Boat_Transport_02_F"];

// WEST - HORIZON (RHS)
_side = WEST;
ZMM_WEST_Man = ["rhsgref_hidf_grenadier","rhsgref_hidf_squadleader","rhsgref_hidf_autorifleman"];
ZMM_WEST_Truck = ["rhsgref_hidf_m998_4dr"];
ZMM_WEST_Light = ["rhsgref_hidf_m1025_m2","rhsgref_hidf_m1025_mk19"];
ZMM_WEST_Medium = ["rhsgref_hidf_m113a3_m2","rhsgref_hidf_m113a3_mk19"];
ZMM_WEST_Heavy = ["RHS_M2A3_wd","RHS_M6_wd","rhsusf_m1a1aimwd_usarmy"];
ZMM_WEST_Air = ["RHS_UH60M2","RHS_UH60M","RHS_MELB_MH6M"];
ZMM_WEST_Cas = ["RHS_MELB_AH6M","RHS_AH64D_wd"];
ZMM_WEST_Boat = ["I_C_Boat_Transport_02_F"];

// EAST - RU MSV (RHS)
_side = EAST;
ZMM_EAST_Man = ["rhs_msv_rifleman","rhs_msv_grenadier","rhs_msv_rifleman","rhs_msv_LAT","rhs_msv_rifleman","rhs_msv_grenadier_rpg","rhs_msv_rifleman","rhs_msv_machinegunner"];
ZMM_EAST_Truck = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_Ural" >> "rhs_group_rus_msv_Ural_squad", configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_gaz66" >> "rhs_group_rus_msv_gaz66_squad"];
ZMM_EAST_Light = ["rhs_tigr_sts_msv","rhsgref_nat_uaz_dshkm","rhsgref_nat_uaz_ags","rhsgref_nat_uaz_spg9"];
ZMM_EAST_Medium = ["rhs_btr80a_msv","rhs_btr70_msv","rhs_btr80_msv"];
ZMM_EAST_Heavy = ["rhs_bmp1_msv","rhs_bmp2e_msv","rhs_bmp3_msv"];
ZMM_EAST_Air = ["RHS_Mi8mt_vvsc","RHS_Mi8AMT_vvsc"];
ZMM_EAST_Cas = ["RHS_Mi24P_vvsc","RHS_Ka52_vvsc"];
ZMM_EAST_Boat = ["I_C_Boat_Transport_02_F"];

// EAST - RU DESERT (RHS)
_side = EAST;
ZMM_EAST_Man = ["rhs_vdv_mflora_rifleman","rhs_vdv_mflora_at","rhs_vdv_mflora_grenadier","rhs_vdv_mflora_sergeant","rhs_vdv_mflora_machinegunner"];
ZMM_EAST_Truck = [["RHS_Ural_VDV_01","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
ZMM_EAST_Light = [["RHS_Ural_Zu23_VDV_01","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"],["rhs_btr70_vdv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
ZMM_EAST_Medium = [["rhs_bmd2","[_grpVeh,['Desert',1]] call BIS_fnc_initVehicle;"],["rhs_bmp1k_vdv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
ZMM_EAST_Heavy = [["rhs_t72bc_tv","[_grpVeh,['rhs_Sand',1]] call BIS_fnc_initVehicle;"], ["rhs_zsu234_aa","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
ZMM_EAST_Air = ["RHS_Mi8mt_vvsc","RHS_Mi8AMT_vvsc"];
ZMM_EAST_Cas = [["RHS_Mi24V_vvs","_grpVeh setPylonLoadout [5,'']; _grpVeh setPylonLoadout [6,''];"]];
ZMM_EAST_Boat = ["I_C_Boat_Transport_02_F"];

// EAST - TAKI (ZEU)
_side = EAST;
ZMM_EAST_Man = ["O_Taki_soldier_TL_F","O_Taki_soldier_R26_F","O_Taki_soldier_R_AK103_F","O_Taki_soldier_R_AK105_F"];
ZMM_EAST_Truck = [configFile >> "CfgGroups" >> "East" >> "Taki_Opfor" >> "Motorized" >> "Taki_MountedWarband"];
ZMM_EAST_Light = ["Taki_Ural_Zu23_F","Taki_UAZ_ags30_F","Taki_UAZ_dshkm_F","Taki_UAZ_spg9_F"];
ZMM_EAST_Medium = ["Taki_bmd1_F","Taki_bmp1_F"];
ZMM_EAST_Heavy = ["Taki_t72_F", "Taki_zsu_F"];
ZMM_EAST_Air = ["Taki_mi8_armed_F"];
ZMM_EAST_Cas = ["Taki_mi8_armed_F"];
ZMM_EAST_Boat = ["I_C_Boat_Transport_02_F"];

// GUER - SAF (RHS)
_side = INDEPENDENT;
ZMM_GUER_Man = ["rhssaf_army_m93_oakleaf_summer_spec_aa","rhssaf_army_m93_oakleaf_summer_spec_at","rhssaf_army_m93_oakleaf_summer_sq_lead","rhssaf_army_m93_oakleaf_summer_ft_lead","rhssaf_army_m93_oakleaf_summer_rifleman_m70","rhssaf_army_m93_oakleaf_summer_mgun_m84","rhssaf_army_m93_oakleaf_summer_gl","rhssaf_army_m93_oakleaf_summer_rifleman_at"];
ZMM_GUER_Truck = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_chdkz_g" >> "rhs_group_indp_ins_g_ural" >> "rhs_group_chdkz_ural_squad"];
ZMM_GUER_Light = ["rhsgref_nat_uaz_ags","rhsgref_nat_uaz_spg9","rhsgref_nat_uaz_dshkm"];
ZMM_GUER_Medium = ["rhsgref_nat_btr70"];
ZMM_GUER_Heavy = ["rhsgref_ins_g_bmp1k"];
ZMM_GUER_Air = [["RHS_Mi8mt_vvs","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
ZMM_GUER_Cas = ["rhsgref_ins_g_Mi8amt"];
ZMM_GUER_Boat = ["I_C_Boat_Transport_02_F"];

// GUER - REBELS (RHS)
_side = INDEPENDENT;
ZMM_GUER_Man = ["rhsgref_ins_g_rifleman","rhsgref_ins_g_machinegunner","rhsgref_ins_g_grenadier","rhsgref_ins_g_rifleman_RPG26"];
ZMM_GUER_Truck = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_chdkz_g" >> "rhs_group_indp_ins_g_ural" >> "rhs_group_chdkz_ural_squad"];
ZMM_GUER_Light = ["rhsgref_ins_g_uaz_ags","rhsgref_ins_g_uaz_dshkm_chdkz","rhsgref_ins_g_uaz_spg9"];
ZMM_GUER_Medium = ["rhsgref_ins_g_btr70"];
ZMM_GUER_Heavy = ["rhsgref_ins_g_bmd1","rhsgref_ins_g_bmp1","rhsgref_ins_g_zsu234"];
ZMM_GUER_Air = [["RHS_Mi8mt_vvs","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
ZMM_GUER_Cas = [["RHS_Mi8MTV3_vvs","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
ZMM_GUER_Boat = ["I_C_Boat_Transport_02_F"];


//***************************
//*** GLOBAL MOBILISATION ***
//***************************

// East Germany - Winter
_side = EAST;
ZMM_EAST_Man = ["gm_gc_army_antitank_mpiak74n_rpg7_80_win","gm_gc_army_machinegunner_pk_80_win","gm_gc_army_rifleman_mpiak74n_80_win","gm_gc_army_squadleader_mpiak74n_80_win"];
ZMM_EAST_Truck = [configFile >> "CfgGroups" >> "East" >> "gm_gc_army_win" >> "gm_motorizedinfantry_80" >> "gm_gc_army_motorizedinfantly_squad_ural4320_cargo"];
ZMM_EAST_Light = ["gm_gc_army_brdm2_olw"];
ZMM_EAST_Medium = ["gm_gc_army_bmp1sp2_olw","gm_gc_army_btr60pa_olw"];
ZMM_EAST_Heavy = ["2gm_gc_army_t55a_olw","gm_gc_army_zsu234v1_olw"];
ZMM_EAST_Air = [["gm_gc_airforce_mi2p","[_grpVeh,['gm_gc_un',1]] call BIS_fnc_initVehicle;"]];
ZMM_EAST_Cas = [["gm_gc_airforce_mi2urn","[_grpVeh,['gm_gc_un',1]] call BIS_fnc_initVehicle;"]];
ZMM_EAST_Boat = ["I_C_Boat_Transport_02_F"];

// East Germany - Summer
_side = EAST;
ZMM_EAST_Man = ["gm_gc_army_rifleman_mpiak74n_80_str","gm_gc_army_squadleader_mpiak74n_80_str","gm_gc_army_machinegunner_pk_80_str","gm_gc_army_antitank_mpiak74n_rpg7_80_str","gm_gc_army_squadleader_mpiak74n_80_str"];
ZMM_EAST_Truck = [configFile >> "CfgGroups" >> "East" >> "gm_gc_army" >> "gm_motorizedinfantry_80" >> "gm_gc_army_motorizedinfantly_squad_ural4320_cargo"];
ZMM_EAST_Light = ["gm_gc_army_brdm2"];
ZMM_EAST_Medium = ["gm_gc_army_bmp1sp2","gm_gc_army_btr60pa"];
ZMM_EAST_Heavy = ["2gm_gc_army_t55a","gm_gc_army_zsu234v1"];
ZMM_EAST_Air = ["gm_gc_airforce_mi2p"];
ZMM_EAST_Cas = ["gm_gc_airforce_mi2urn"];
ZMM_EAST_Boat = ["I_C_Boat_Transport_02_F"];

// West Germany - Summer
_side = WEST;
ZMM_WEST_Man = ["gm_ge_army_grenadier_g3a3_80_ols","gm_ge_army_rifleman_g3a3_80_ols","gm_ge_army_squadleader_g3a3_p2a1_80_ols","gm_ge_army_machinegunner_mg3_80_ols"];
ZMM_WEST_Truck = [configFile >> "CfgGroups" >> "West" >> "gm_ge_army" >> "gm_motorizedinfantry_80" >> "gm_ge_army_motorizedInfantry_squad_u1300l"];
ZMM_WEST_Light = ["gm_ge_army_iltis_milan"];
ZMM_WEST_Medium = ["gm_ge_army_fuchsa0_engineer","gm_ge_army_m113a1g_apc"];
ZMM_WEST_Heavy = ["gm_ge_army_Leopard1a3","gm_ge_army_gepard1a1"];
ZMM_WEST_Air = [["gm_ge_army_bo105p1m_vbh_swooper","[_grpVeh,['gm_ge_oli',1]] call BIS_fnc_initVehicle;"]];
ZMM_WEST_Cas = [["gm_ge_army_bo105p_pah1","[_grpVeh,['gm_ge_oli',1]] call BIS_fnc_initVehicle;"]];
ZMM_WEST_Boat = ["I_C_Boat_Transport_02_F"];

// West Germany - Winter
_side = WEST;
ZMM_WEST_Man = ["gm_ge_army_machinegunner_mg3_parka_80_win","gm_ge_army_rifleman_g3a3_parka_80_win","gm_ge_army_squadleader_g3a3_p2a1_parka_80_win","gm_ge_army_grenadier_g3a3_parka_80_win"];
ZMM_WEST_Truck = [configFile >> "CfgGroups" >> "West" >> "gm_ge_army_win" >> "gm_motorizedinfantry_80" >> "gm_ge_army_motorizedInfantry_squad_u1300l"];
ZMM_WEST_Light = ["gm_ge_army_iltis_milan_win"];
ZMM_WEST_Medium = ["gm_ge_army_fuchsa0_engineer_win","gm_ge_army_m113a1g_apc_win"];
ZMM_WEST_Heavy = ["gm_ge_army_Leopard1a1a1_win","gm_ge_army_gepard1a1_win"];
ZMM_WEST_Air = [["gm_ge_army_bo105p1m_vbh_swooper","[_grpVeh,['gm_ge_un',1]] call BIS_fnc_initVehicle;"]];
ZMM_WEST_Cas = [["gm_ge_army_bo105p_pah1","[_grpVeh,['gm_ge_un',1]] call BIS_fnc_initVehicle;"]];
ZMM_WEST_Boat = ["I_C_Boat_Transport_02_F"];

// West Germany - Tropical
_side = WEST;
ZMM_WEST_Man = ["gm_ge_army_grenadier_g3a3_80_ols","gm_ge_army_rifleman_g3a3_80_ols","gm_ge_army_squadleader_g3a3_p2a1_80_ols","gm_ge_army_machinegunner_mg3_80_ols"];
ZMM_WEST_Truck = [["gm_ge_army_u1300l_cargo","[_grpVeh,['gm_ge_trp',1]] call BIS_fnc_initVehicle;"]];
ZMM_WEST_Light = ["gm_ge_army_iltis_milan_trp"];
ZMM_WEST_Medium = ["gm_ge_army_fuchsa0_engineer_trp","gm_ge_army_m113a1g_apc_trp"];
ZMM_WEST_Heavy = ["gm_ge_army_Leopard1a3_trp","gm_ge_army_gepard1a1_trp"];
ZMM_WEST_Air = [["gm_ge_army_bo105p1m_vbh_swooper","[_grpVeh,['gm_ge_oli',1]] call BIS_fnc_initVehicle;"]];
ZMM_WEST_Cas = [["gm_ge_army_bo105p_pah1","[_grpVeh,['gm_ge_oli',1]] call BIS_fnc_initVehicle;"]];
ZMM_WEST_Boat = ["I_C_Boat_Transport_02_F"];

// West Germany - Desert
_side = WEST;
ZMM_WEST_Man = ["gm_ge_army_grenadier_g3a3_80_ols","gm_ge_army_rifleman_g3a3_80_ols","gm_ge_army_squadleader_g3a3_p2a1_80_ols","gm_ge_army_machinegunner_mg3_80_ols"];
ZMM_WEST_Truck = [["gm_ge_army_u1300l_cargo","[_grpVeh,['gm_ge_des',1]] call BIS_fnc_initVehicle;"]];
ZMM_WEST_Light = ["gm_ge_army_iltis_milan_des"];
ZMM_WEST_Medium = ["gm_ge_army_fuchsa0_engineer_des","gm_ge_army_m113a1g_apc_des"];
ZMM_WEST_Heavy = ["gm_ge_army_Leopard1a3_des","gm_ge_army_gepard1a1_des"];
ZMM_WEST_Air = [["gm_ge_army_bo105p1m_vbh_swooper","[_grpVeh,['gm_ge_oli',1]] call BIS_fnc_initVehicle;"]];
ZMM_WEST_Cas = [["gm_ge_army_bo105p_pah1","[_grpVeh,['gm_ge_oli',1]] call BIS_fnc_initVehicle;"]];
ZMM_WEST_Boat = ["I_C_Boat_Transport_02_F"];

// Poland - Winter
_side = EAST;
ZMM_EAST_Man = ["gm_pl_army_rifleman_akm_80_win","gm_pl_army_squadleader_akm_80_win","gm_pl_army_machinegunner_pk_80_win","gm_pl_army_antitank_akm_rpg7_80_win"];
ZMM_EAST_Truck = [configFile >> "CfgGroups" >> "East" >> "gm_pl_army_win" >> "gm_motorizedinfantry_80" >> "gm_pl_army_motorizedinfantly_squad_ural4320_cargo_80"];
ZMM_EAST_Light = ["gm_pl_army_brdm2_olw"];
ZMM_EAST_Medium = ["gm_pl_army_bmp1sp2_olw","gm_pl_army_ot64a_olw"];
ZMM_EAST_Heavy = ["gm_pl_army_zsu234v1_olw","gm_pl_army_pt76b_olw","gm_pl_army_t55_olw"];
ZMM_EAST_Air = [["gm_pl_airforce_mi2p","[_grpVeh,['gm_pl_un',1]] call BIS_fnc_initVehicle;"]];
ZMM_EAST_Cas = [["gm_pl_airforce_mi2urn","[_grpVeh,['gm_pl_un',1]] call BIS_fnc_initVehicle;"]];
ZMM_EAST_Boat = ["I_C_Boat_Transport_02_F"];

// Poland - Summer
_side = EAST;
ZMM_EAST_Man = ["gm_pl_army_rifleman_akm_80_autumn_moro","gm_pl_army_squadleader_akm_80_autumn_moro","gm_pl_army_machinegunner_pk_80_autumn_moro","gm_pl_army_antitank_akm_rpg7_80_autumn_moro"];
ZMM_EAST_Truck = [configFile >> "CfgGroups" >> "East" >> "gm_pl_army" >> "gm_motorizedinfantry_80" >> "gm_pl_army_motorizedinfantly_squad_ural4320_cargo_80"];
ZMM_EAST_Light = ["gm_pl_army_brdm2"];
ZMM_EAST_Medium = ["gm_pl_army_bmp1sp2","gm_pl_army_ot64a"];
ZMM_EAST_Heavy = ["gm_pl_army_zsu234v1","gm_pl_army_pt76b","gm_pl_army_t55"];
ZMM_EAST_Air = ["gm_pl_airforce_mi2p"];
ZMM_EAST_Cas = ["gm_pl_airforce_mi2urn"];
ZMM_EAST_Boat = ["I_C_Boat_Transport_02_F"];

// GMX CDF - 1980
_side = WEST;
ZMM_WEST_Man = ["gmx_cdf_army_antitank_ak74_rpg7_ttsko","gmx_cdf_army_rifleman_ak74_ttsko","gmx_cdf_army_machinegunner_rpk_ttsko","gmx_cdf_army_rifleman_ak74_ttsko","gmx_cdf_army_squadleader_ak74_ttsko","gmx_cdf_army_rifleman_ak74_ttsko","gmx_cdf_army_rifleman_ak74_ttsko"];
ZMM_WEST_Truck = ["gmx_cdf_ural4320_cargo_wdl"];
ZMM_WEST_Light = ["gmx_cdf_uaz469_spg9_wdl","gmx_cdf_uaz469_dshkm_wdl"];
ZMM_WEST_Medium = ["gmx_cdf_btr60pb_wdl","gmx_cdf_bmp1sp2_wdl","gmx_cdf_brdm2_wdl"];
ZMM_WEST_Heavy = ["gmx_cdf_zsu234v1_wdl","gmx_cdf_pt76b_wdl","gmx_cdf_t55_wdl"];
ZMM_WEST_Air = ["gmx_cdf_mi2p_wdl"];
ZMM_WEST_Cas = ["gmx_cdf_mi2urn_wdl"];
ZMM_WEST_Boat = ["I_C_Boat_Transport_02_F"];

// GMX CDF - 2022
_side = WEST;
ZMM_WEST_Man = ["gmx_cdf2022_army_rifleman_trg21_digittsko","gmx_cdf2022_army_machinegunner_pk_digittsko","gmx_cdf2022_army_rifleman_trg21_digittsko","gmx_cdf2022_army_antitank_trg21_pzf3_digittsko","gmx_cdf2022_army_rifleman_trg21_digittsko","gmx_cdf2022_army_squadleader_trg21_digittsko"];
ZMM_WEST_Truck = ["gmx_cdf2022_ural4320_cargo_wdl"];
ZMM_WEST_Light = ["gmx_cdf2022_uaz469_dshkm_wdl","gmx_cdf2022_uaz469_spg9_wdl"];
ZMM_WEST_Medium = ["gm_ge_army_fuchsa0_engineer_trp","gm_ge_army_m113a1g_apc_trp"];
ZMM_WEST_Heavy = ["gm_ge_army_Leopard1a3_trp","gm_ge_army_gepard1a1_trp"];
ZMM_WEST_Air = ["gmx_cdf2022_mi2p_wdl"];
ZMM_WEST_Cas = ["gmx_cdf2022_mi2urn_wdl"];
ZMM_WEST_Boat = ["I_C_Boat_Transport_02_F"];

// GMX ChDkz
_side = EAST;
ZMM_EAST_Man = ["gmx_chdkz_army_rifleman_akm_mix","gmx_chdkz_army_squadleader_akm_win","gmx_chdkz_army_rifleman_akm_mix","gmx_chdkz_army_antitank_akm_rpg7_mix","gmx_chdkz_army_machinegunner_rpk_mix","gmx_chdkz_army_rifleman_akm_mix","gmx_chdkz_army_grenadier_akm_pallad_mix"];
ZMM_EAST_Truck = ["gmx_chdkz_ural4320_cargo_wdr"];
ZMM_EAST_Light = ["gmx_chdkz_uaz469_dshkm_wdr","gmx_chdkz_uaz469_spg9_wdr"];
ZMM_EAST_Medium = ["gmx_chdkz_bmp1sp2_wdr","gmx_chdkz_brdm2_wdr","gmx_chdkz_btr60pb_wdr","gmx_chdkz_ot64a_wdr"];
ZMM_EAST_Heavy = ["gmx_chdkz_zsu234v1_wdr","gmx_chdkz_t55_wdr","gmx_chdkz_t55_wdr"];
ZMM_EAST_Air = ["gmx_chdkz_mi2p_wdl"];
ZMM_EAST_Cas = ["gmx_chdkz_mi2urn_wdl"];
ZMM_EAST_Boat = ["I_C_Boat_Transport_02_F"];

// GMX AAF 1990
_side = INDEPENDENT;
ZMM_GUER_Man = ["I_Soldier_F","I_Soldier_LAT_F","I_Soldier_GL_F","I_Soldier_AR_F"];
ZMM_GUER_Truck = [];
ZMM_GUER_Light = ["gmx_aaf_fuchsa0_engineer_wdl","gmx_aaf_iltis_milan_wdl"];
ZMM_GUER_Medium = ["gmx_aaf_luchsa2_wdl","gmx_aaf_marder1a2_wdl"];
ZMM_GUER_Heavy = ["gmx_aaf_gepard1a1_wdl","gmx_aaf_leopard1a5_wdl","gmx_aaf_leopard1a5_wdl"];
ZMM_GUER_Air = [["I_Heli_light_03_unarmed_F","[_grpVeh,['Indep',1]] call BIS_fnc_initVehicle;"],"I_Heli_Transport_02_F", ["O_Heli_Light_02_unarmed_F","_grpVeh setObjectTextureGlobal [0,'\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa'];"], ["B_Heli_Light_01_F","_grpVeh setObjectTextureGlobal [0,'A3\Air_F\Heli_Light_01\Data\heli_light_01_ext_indp_co.paa'];"]];
ZMM_GUER_Cas = ["I_Heli_light_03_dynamicLoadout_F","I_Plane_Fighter_03_dynamicLoadout_F",["O_Heli_Light_02_dynamicLoadout_F","_grpVeh setObjectTextureGlobal [0,'\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa']; _grpVeh setPylonLoadout [2,'PylonRack_12Rnd_missiles'];"]];
ZMM_GUER_Boat = ["I_C_Boat_Transport_02_F"];

// GM Revolutionaries
_side = INDEPENDENT;
ZMM_GUER_Man = ["gm_xx_army_squadleader_m16a1_80_grn","gm_xx_army_rifleman_01_akm_alp","gm_xx_army_machinegunner_rpk_80_oli","gm_xx_army_assault_ak74nk_80_wdl","gm_xx_army_antitank_hk53a2_rpg7_80_oli"];
ZMM_GUER_Truck = [["gmx_chdkz_ural4320_cargo_wdr","[_grpVeh,['gmx_chdkz_wdl',1]] call BIS_fnc_initVehicle;"]];
ZMM_GUER_Light = [[["gmx_chdkz_uaz469_dshkm_wdr","[_grpVeh,['gmx_chdkz_wdl',1]] call BIS_fnc_initVehicle;"]],[["gmx_chdkz_uaz469_spg9_wdr","[_grpVeh,['gmx_chdkz_wdl',1]] call BIS_fnc_initVehicle;"]]];
ZMM_GUER_Medium = [[["gmx_chdkz_btr60pb_wdr","[_grpVeh,['gmx_chdkz_wdl',1]] call BIS_fnc_initVehicle;"]]];
ZMM_GUER_Heavy = [[["gmx_chdkz_bmp1sp2_wdr","[_grpVeh,['gmx_chdkz_wdl',1]] call BIS_fnc_initVehicle;"]],[["gmx_chdkz_t55_wdr","[_grpVeh,['gmx_chdkz_wdl',1]] call BIS_fnc_initVehicle;"]]];
ZMM_GUER_Air = ["gmx_chdkz_mi2p_wdl"];
ZMM_GUER_Cas = ["gmx_chdkz_mi2urn_wdl"];
ZMM_GUER_Boat = ["I_C_Boat_Transport_02_F"];


//*****************
//*** SPEADHEAD ***
//*****************

// Germany (Sturmtroopers)
_side = WEST;
ZMM_WEST_Man = ["SPE_sturmtrooper_SquadLead","SPE_sturmtrooper_mgunner","SPE_sturmtrooper_rifleman","SPE_sturmtrooper_medic","SPE_sturmtrooper_rifleman","SPE_sturmtrooper_stggunner","SPE_sturmtrooper_rifleman","SPE_sturmtrooper_amgunner","SPE_sturmtrooper_LAT_rifleman","SPE_sturmtrooper_ober_grenadier","SPE_sturmtrooper_rifleman"];
ZMM_WEST_Truck = ["SPE_ST_OpelBlitz"];
ZMM_WEST_Light = [["SPE_GER_R200_MG34","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_SdKfz250_1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
ZMM_WEST_Medium = [["SPE_OpelBlitz_Flak38","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_StuH_42","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_ST_PzKpfwIII_J","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwIV_G","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
ZMM_WEST_Heavy = [["SPE_Jagdpanther_G1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwV_G","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwVI_H1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
ZMM_WEST_Cas = ["SPE_FW190F8"];
ZMM_WEST_Boat = ["I_C_Boat_Transport_02_F"];

/// Germany (Wehrmacht)
_side = WEST;
ZMM_WEST_Man = ["SPE_GER_SquadLead","SPE_GER_rifleman","SPE_GER_mgunner","SPE_GER_medic","SPE_GER_rifleman","SPE_GER_amgunner","SPE_GER_rifleman","SPE_GER_LAT_Rifleman","SPE_GER_ober_grenadier","SPE_GER_rifleman"];
ZMM_WEST_Truck = ["SPE_OpelBlitz"];
ZMM_WEST_Light = [["SPE_GER_R200_MG34","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_SdKfz250_1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
ZMM_WEST_Medium = [["SPE_OpelBlitz_Flak38","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_StuH_42","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_ST_PzKpfwIII_J","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwIV_G","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
ZMM_WEST_Heavy = [["SPE_Jagdpanther_G1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwV_G","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"],["SPE_PzKpfwVI_H1","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
ZMM_WEST_Cas = ["SPE_FW190F8"];
ZMM_WEST_Boat = ["I_C_Boat_Transport_02_F"];

// US Army
_side = INDEPENDENT;
ZMM_GUER_Man = ["SPE_US_Rangers_SquadLead","SPE_US_Rangers_HMGunner","SPE_US_Rangers_rifleman","SPE_US_Rangers_medic","SPE_US_Rangers_rifleman","SPE_US_Rangers_AHMGunner","SPE_US_Rangers_rifleman","SPE_US_Rangers_grenadier","SPE_US_Rangers_Rifleman_AmmoBearer","SPE_US_Rangers_rifleman"];
ZMM_GUER_Truck = ["SPE_US_M3_Halftrack_Unarmed"];
ZMM_GUER_Light = ["SPE_US_M3_Halftrack"];
ZMM_GUER_Medium = ["SPE_US_M16_Halftrack"];
ZMM_GUER_Heavy = ["SPE_M10","SPE_M4A1_75"];
ZMM_GUER_Air = ["SPEX_C47_Skytrain"];
ZMM_GUER_Cas = ["SPE_P47"];
ZMM_GUER_Boat = ["I_C_Boat_Transport_02_F"];

// French Revolutionaries
_side = INDEPENDENT;
ZMM_GUER_Man = ["SPE_FR_SquadLead","SPE_FR_Rifleman_Carbine","SPE_FR_Autorifleman","SPE_FR_Rifleman","SPE_FR_Assist_SquadLead","SPE_FR_Rifleman_Carbine","SPE_FR_AT_Soldier","SPE_FR_Rifleman","SPE_FR_Grenadier","SPE_FR_Rifleman"];
ZMM_GUER_Truck = ["SPE_FFI_OpelBlitz"];
ZMM_GUER_Light = [["SPE_GER_R200_MG34","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"],["SPE_SdKfz250_1","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"]];
ZMM_GUER_Medium = [["SPE_SdKfz250_1","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"],["SPE_OpelBlitz_Flak38","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"],["SPE_SdKfz250_1","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"]];
ZMM_GUER_Heavy = [["SPE_PzKpfwIII_J","[_grpVeh,['Panzergrau',1]] call BIS_fnc_initVehicle;"]];
ZMM_GUER_Air = [["SPEX_C47_Skytrain","[_grpVeh,['bare',1]] call BIS_fnc_initVehicle;"]];
ZMM_GUER_Cas = ["SPE_P47"];
ZMM_GUER_Boat = ["I_C_Boat_Transport_02_F"];

//**********************
//*** WESTERN SAHARA ***
//**********************

// WEST - ION
_side = WEST;
ZMM_WEST_Man = ["B_ION_TL_lxWS","B_ION_Soldier_lxWS","B_ION_soldier_AR_lxWS","B_ION_Soldier_lxWS","B_ION_Soldier_GL_lxWS","B_ION_Soldier_lxWS","B_ION_shot_lxWS",selectRandom["B_ION_medic_lxWS","B_ION_marksman_lxWS"]];
ZMM_WEST_Truck = ["B_ION_Truck_02_covered_lxWS"];
ZMM_WEST_Light = ["B_ION_Pickup_mmg_rf","B_ION_Offroad_armed_lxWS"];
ZMM_WEST_Medium = ["B_ION_APC_Wheeled_02_hmg_lxWS"];
ZMM_WEST_Heavy = ["B_ION_APC_Wheeled_01_command_lxWS"];
ZMM_WEST_Air = ["B_ION_Heli_EC_01_RF"];
ZMM_WEST_Cas = ["B_ION_Heli_Light_02_dynamicLoadout_lxWS"];
ZMM_WEST_Boat = ["I_C_Boat_Transport_02_F"];

// WS - SFIA
_side = EAST; 
ZMM_EAST_Man = ["O_SFIA_Soldier_TL_lxWS","O_SFIA_soldier_lxWS","O_SFIA_soldier_at_lxWS","O_SFIA_soldier_lxWS","O_SFIA_Soldier_AR_lxWS","O_SFIA_medic_lxWS",selectRandom["O_SFIA_sharpshooter_lxWS","O_SFIA_medic_lxWS"]]; 
ZMM_EAST_Truck = ["O_SFIA_Truck_02_transport_lxWS"];
ZMM_EAST_Light = ["O_SFIA_Offroad_AT_lxWS","O_SFIA_Offroad_armed_lxWS"];
ZMM_EAST_Medium = ["O_SFIA_Truck_02_aa_lxWS","O_SFIA_APC_Wheeled_02_hmg_lxWS"];
ZMM_EAST_Heavy = ["O_SFIA_MBT_02_cannon_lxWS","O_SFIA_APC_Tracked_02_30mm_lxWS","O_SFIA_APC_Tracked_02_AA_lxWS"];
ZMM_EAST_Air = ["O_SFIA_Heli_EC_02_RF"];
ZMM_EAST_Cas = ["O_SFIA_Heli_Attack_02_dynamicLoadout_lxWS"];
ZMM_EAST_Boat = ["I_C_Boat_Transport_02_F"];

// WS - TURA
_side = EAST; 
ZMM_EAST_Man = ["O_Tura_enforcer_lxWS","O_Tura_hireling_lxWS","O_Tura_watcher_lxWS","O_Tura_defector_lxWS","O_Tura_deserter_lxWS",selectRandom["O_Tura_scout_lxWS","O_Tura_medic2_lxWS","O_Tura_thug_lxWS"]];
ZMM_EAST_Truck = ["O_SFIA_Truck_02_transport_lxWS"];
ZMM_EAST_Light = ["O_Tura_Offroad_armor_AT_lxWS","O_Tura_Offroad_armor_armed_lxWS"];
ZMM_EAST_Medium = ["O_Tura_Truck_02_aa_lxWS","O_SFIA_APC_Wheeled_02_hmg_lxWS"];
ZMM_EAST_Heavy = ["O_SFIA_APC_Wheeled_02_hmg_lxWS"];
ZMM_EAST_Air = ["O_SFIA_Heli_EC_02_RF"];
ZMM_EAST_Cas = ["O_SFIA_Heli_Attack_02_dynamicLoadout_lxWS"];
ZMM_EAST_Boat = ["I_C_Boat_Transport_02_F"];

//****************************
//*** EXPEDITIONARY FORCES ***
//****************************

// WEST - MJTF (Desert)
_side = WEST;
ZMM_WEST_Man = ["EF_B_Marine_R_Des","EF_B_Marine_LAT2_Des","EF_B_Marine_R_Des","EF_B_Marine_TL_Des","EF_B_Marine_R_Des","EF_B_Marine_AR_Des","EF_B_Marine_R_Des",selectRandom["EF_B_Marine_Mark_Des","EF_B_Marine_Medic_Des","EF_B_Marine_Exp_Des","EF_B_Marine_AA_Des","EF_B_Marine_AT_Des"]]; // WEST - MTJF (ARID)
ZMM_WEST_Truck = ["EF_B_Truck_01_covered_MJTF_Des"];
ZMM_WEST_Light = ["EF_B_MRAP_01_FSV_MJTF_Des","EF_B_MRAP_01_gmg_MJTF_Des","EF_B_MRAP_01_hmg_MJTF_Des"];
ZMM_WEST_Medium = ["EF_B_AAV9_MJTF_Des","EF_B_AAV9_50mm_MJTF_Des"];
ZMM_WEST_Heavy = ["EF_B_MBT_01_TUSK_MJTF_Des"];
ZMM_WEST_Air = ["EF_B_Heli_Transport_01_MJTF_Des"];
ZMM_WEST_Cas = ["EF_B_Heli_Attack_01_dynamicLoadout_MJTF_Des"];
ZMM_WEST_Boat = ["I_C_Boat_Transport_02_F","EF_B_CombatBoat_HMG_MJTF_Des"];

// WEST - MJTF (Woodland)
_side = WEST; 
ZMM_WEST_Man = ["EF_B_Marine_R_Wdl","EF_B_Marine_LAT2_Wdl","EF_B_Marine_R_Wdl","EF_B_Marine_TL_Wdl","EF_B_Marine_R_Wdl","EF_B_Marine_AR_Wdl","EF_B_Marine_R_Wdl",selectRandom["EF_B_Marine_Mark_Wdl","EF_B_Marine_Medic_Wdl","EF_B_Marine_Exp_Wdl","EF_B_Marine_AA_Wdl","EF_B_Marine_AT_Wdl"]]; // WEST - MTJF (WOODLAND)
ZMM_WEST_Truck = ["EF_B_Truck_01_covered_MJTF_Wdl"];
ZMM_WEST_Light = ["EF_B_MRAP_01_FSV_MJTF_Wdl","EF_B_MRAP_01_gmg_MJTF_Wdl","EF_B_MRAP_01_hmg_MJTF_Wdl"];
ZMM_WEST_Medium = ["EF_B_AAV9_MJTF_Wdl","EF_B_AAV9_50mm_MJTF_Wdl"];
ZMM_WEST_Heavy = ["EF_B_MBT_01_TUSK_MJTF_Wdl"];
ZMM_WEST_Air = ["EF_B_Heli_Transport_01_MJTF_Wdl"];
ZMM_WEST_Cas = ["EF_B_Heli_Attack_01_dynamicLoadout_MJTF_Wdl"];
ZMM_WEST_Boat = ["I_C_Boat_Transport_02_F","EF_B_CombatBoat_HMG_MJTF_Wdl"];

*/

/*
//
ZQR_WaveDetail = [
	[
		// Wave 1
		[selectRandom ["land","house"], 4],
		[selectRandom ["land","house"], 4]
	],
	[
		// Wave 2
		["road", selectRandom (
			(missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + 
			(missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]])
		)],
		,[selectRandom ["land","house"], 4],
		[selectRandom ["land","house"], 4]
	],
	[
		// Wave 3
		["road", selectRandom (
			(missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + 
			(missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]])
		)],
		["road", selectRandom (
			(missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]]) + 
			(missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]])
		)],
		[selectRandom ["land","house"], 4],
		[selectRandom ["land","house"], 4]
	],
	[
		// Wave 4
		["road", selectRandom (
			(missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + 
			(missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]])
		)],
		["road", selectRandom (
			(missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]]) + 
			(missionNamespace getVariable [format["ZMM_%1_Light",_side],[]])
		)],
		[selectRandom ["land","house"], 4],
		[selectRandom ["land","house"], 4]
	],
	[
		// Wave 5
		["road", selectRandom (
			(missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]) + 
			(missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]])
		)],
		["road", selectRandom (
			(missionNamespace getVariable [format["ZMM_%1_Heavy",_side],[]]) + 
			(missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]])
		)],
		["road", selectRandom (
			(missionNamespace getVariable [format["ZMM_%1_Heavy",_side],[]]) + 
			(missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]])
		)],
		["house", 6],
		["house", 6]
	]
];
*/

// CORE Functions - Don't touch these!
zmm_fnc_misc_logMsg = {
	params ["_lev", "_msg"];
	diag_log text format ["[QRF] [%1] %2", _lev, _msg];
	if ((missionNamespace getVariable ["f_param_debugMode",0] == 1 || missionNamespace getVariable ["ZMM_Debug", false] || !( toUpper _lev isEqualTo "DEBUG")) || _lev isEqualTo "ERROR") then { format ["[QRF] [%1] %2", _lev, _msg] remoteExec ["SystemChat"] } else { systemChat format ["[QRF] [%1] %2", _lev, _msg] };
};

zmm_fnc_qrf_spawnCrew = {
	// zmm_fnc_qrf_spawnCrew
	params ["_veh", "_side", ["_inclueCargo", false], ["_maxCargo", 12]];

	private _vehCfg = configFile >> "CfgVehicles" >> typeOf _veh;
	private _difficulty = missionNamespace getVariable ["f_param_ZMMDiff", missionNamespace getVariable ["ZZM_Diff", 1]];

	private _crewPositions = (fullCrew [_veh, "", true]) apply { _x#1 };

	private _crewCount = count (_crewPositions select { _x in ["driver","gunner","commander","turret"] });

	// Adjust for difficulty
	_maxCargo = _maxCargo * _difficulty;

	if (_inclueCargo) then { 
		private _cargoCount = count (_crewPositions select { _x in ["cargo"] });
		// Cap the max size of the cargo
		_crewCount = (count _crewPositions) + (_cargoCount min _maxCargo);
	};

	private _enemyMen = missionNamespace getVariable [format["ZMM_%1_Man",_side],["O_Soldier_F"]];

	private _crew = [];	
	for "_i" from 0 to (_crewCount - 1) do {
		_crew pushBack ( if (_i < 3) then { _enemyMen#0 } else { selectRandom _enemyMen } );
	};

	private _crewGrp = [[0,0,0], _side, _crew] call BIS_fnc_spawnGroup;

	[_veh,[1, 0.8, 0.2]] remoteExec ["setVehicleTIPars"];
	_crewGrp addVehicle _veh;	
	{ _x moveInAny _veh } forEach units _crewGrp;

	(driver _veh) assignAsDriver _veh;
	(commander _veh) assignAsCommander _veh;
	(gunner _veh) assignAsGunner _veh;

	_crewGrp deleteGroupWhenEmpty true;
	_crewGrp
};

zmm_fnc_qrf_spawnGroup = {
	// zmm_fnc_qrf_spawnGroup
	params [
		["_targetPos", []],			// Target Destination to stop at
		["_spawnArray", []],		// Array of String/Object/Marker Starting Positions
		["_side", WEST],			// Side of spawned vehicle
		["_startClass", ""],		// Classname, Config, Number or Array [classname,code]
		["_spawnDistCheck", 500],	// Don't spawn this close to players
		["_tries", 0],				// If too close to players, then try up to 5 times
		["_zoneID", 0],				// ZMM Compatability - The Zone this group will belong
		["_UPSMkr",""]				// ZMM Compatability - If this exists will call UPS to allow patrol instead of travel
	];

	if (_startClass isEqualTo "") exitWith { ["WARNING", format["spawnGroup - Empty Unit Passed: %1 (%2)", _startClass, _side]] call zmm_fnc_misc_logMsg };
	if (_tries > 5 || count _spawnArray == 0 || count _targetPos == 0) exitWith {};

	private _id = if (_zoneID > 0) then { _zoneID } else { missionNamespace getVariable ["ZQR_wave", 0] };
	private _uid = (missionNamespace getVariable ["ZQR_count", 0]) + 1;	
	ZQR_count = _uid;

	//["DEBUG", format["W%1_G%2 - qrf_spawnGroup - Starting - %3 [%4] Attempt:%5", _id, _uid, _startClass, _side, _tries]] call zmm_fnc_misc_logMsg;

	private _unitClass = _startClass;
	private _mainGrp = grpNull;
	private _suppGrp = grpNull;
	private _grpVeh = objNull;
	private _vehType = "";
	private _customInit = "";

	// Fix any positions are not in array format
	{
		switch (typeName _x) do {
			case "STRING": { _spawnArray set [_forEachIndex, getMarkerPos _x] };
			case "OBJECT": { _spawnArray set [_forEachIndex, getPos _x] };
		};
	} forEach _spawnArray;

	private _startingPos = selectRandom _spawnArray;
	_startingPos set [2,0];
	private _enemyMen = missionNamespace getVariable [format["ZMM_%1_Man", _side], ["O_Soldier_F"]];

	// Don't spawn object if too close to any players.
	if ( isMultiplayer && {allPlayers findIf { alive _x && _x distance2D _startingPos < _spawnDistCheck } > -1} ) exitWith {
		sleep 30;
		[_targetPos, _spawnArray, _side, _startClass, _spawnDistCheck, _tries + 1, _zoneID, _UPSMkr] call zmm_fnc_qrf_spawnGroup;
	};

	// If _unitClass is array, extract the custom init.
	// if (_unitClass isEqualType []) then { _unitClass params ["_unitClass","_customInit"] }; // Does this overwrite class correctly??
	if (_unitClass isEqualType []) then { _customInit = _unitClass#1; _unitClass = _unitClass#0 };

	// If _unitClass is a number, fill it with random units.
	if (_unitClass isEqualType 1) then {
		_vehType = "Man";
		private _enemyTeam = [];
		for "_i" from 0 to (_unitClass - 1) do {  _enemyTeam set [_i, selectRandom _enemyMen] };
		_unitClass = _enemyTeam;
	};

	private _isArmed = false;
		
	//["DEBUG", format["W%1_G%3 - qrf_spawnGroup - Spawning - %4 [%5] at %6", _id, _uid, _unitClass, _side, _startingPos]] call zmm_fnc_misc_logMsg;

	if (_unitClass isEqualType "") then {
		_vehType = toLower getText (configFile >> "CfgVehicles" >> _unitClass >> "vehicleClass");
		
		if ("Air" in ([(configFile >> "CfgVehicles" >> _unitClass), true] call BIS_fnc_returnParents)) then { _vehType = "air"; _startingPos set [2, 800]; };
		if ("Ship" in ([(configFile >> "CfgVehicles" >> _unitClass), true] call BIS_fnc_returnParents)) then { _vehType = "ship"; };
		
		_grpVeh = createVehicle [_unitClass, _startingPos, [], 0, if (_vehType == "air") then {"FLY"} else {"NONE"}];
		private _dir = _grpVeh getDir _targetPos;
		_grpVeh setDir _dir;
		
		_isArmed = [_grpVeh] call zmm_fnc_misc_isArmed;
		private _fillVeh = if (_vehType in ["ship","air"] || !_isArmed || random 1 > 0.6) then { true } else { false };
						
		if (_vehType == "air") then {
			//_grpVeh setVelocity ((vectorNormalized (_targetPos vectorDiff _startingPos)) vectorMultiply 100);
			_grpVeh setVelocity [100 * (sin _dir), 100 * (cos _dir), 0];
			if (_isArmed && (count (fullCrew [_grpVeh, "cargo", true]) <= 4)) then { _fillVeh = false };
		};
		
		_mainGrp = [_grpVeh, _side, _fillVeh] call zmm_fnc_qrf_spawnCrew;
		_mainGrp setGroupIdGlobal [format["QRF_W%1_G%2", _id, _uid]];
		
		["DEBUG", format["W%1_G%2 - spawnGroup %3%4%5", _id, _uid, _unitClass, if (_fillVeh) then { " with inf" } else {""}, _startingPos]] call zmm_fnc_misc_logMsg;
		// Leave group as main if its unarmed, otherwise split them into a infantry group
		if _fillVeh then {
			{
				if (isNull _suppGrp) then {
					_suppGrp = createGroup [_side, true];
					_suppGrp setGroupIdGlobal [format["QRF_W%1_G%2_INF", _id, _uid]];
					_suppGrp addVehicle _grpVeh;
					_wp = _suppGrp addWaypoint [_targetPos, 50];
					_wp setWaypointType "GUARD";
				};
				[_x#0] joinSilent _suppGrp;
			} forEach ((fullCrew [_grpVeh, "cargo"]) + (if (count (fullCrew [_grpVeh, "turret"]) <= 4) then { [] } else { fullCrew [_grpVeh, "turret"] }));
		};
	} else {
		["DEBUG", format["W%1_G%2 - spawnGroup %3", _id, _uid, _unitClass]] call zmm_fnc_misc_logMsg;
		_mainGrp = [_startingPos, _side, _unitClass] call BIS_fnc_spawnGroup;
		_mainGrp deleteGroupWhenEmpty true;
		_mainGrp setGroupIdGlobal [format["QRF_W%1_G%2", _id, _uid]];
			
		_vehArray = (units _mainGrp apply { assignedVehicle _x }) - [objNull];
		
		if (count (_vehArray arrayIntersect _vehArray) > 0) then {
			_grpVeh = (_vehArray arrayIntersect _vehArray)#0;
			_vehType = "car";
			_isArmed = [_grpVeh] call zmm_fnc_misc_isArmed;
			uiSleep 0.5;
			{ _x moveInAny _grpVeh; if (vehicle _x == _x) then { deleteVehicle _x } } forEach (units _mainGrp select { vehicle _x == _x });
		};
	};

	if (!isNull _grpVeh && (_vehType == "air" || (random 1 > 0.2 && _isArmed))) then { _grpVeh setVehicleLock "LOCKEDPLAYER" };

	// Run custom init for vehicle (set camos etc).
	if !(isNil "_customInit") then { 
		if !(_customInit isEqualTo "") then { call compile _customInit; };
	};

	{ _x addCuratorEditableObjects [[_grpVeh] + (units _mainGrp) + (units _suppGrp)] } forEach allCurators;

	// *** UPS Marker was passed, so don't set any further waypoints. ***
	if (_UPSMkr != "") exitWith { ([leader _mainGrp, _UPSMkr] + (if (_vehType == "man") then { ["RANDOM", "SHOWMARKER"] } else { ["SHOWMARKER"] })) spawn zmm_fnc_aiUPS };

	// SET GROUP WAYPOINTS
	switch (toLower _vehType) do {
		// INFANTRY ONLY
		case "man": {
			_wp = _mainGrp addWaypoint [_startingPos, 0];
			_wp setWaypointType "MOVE";
			_largestGrps = [allGroups select { isPlayer leader _x }, [], { count units _x }, "DESCEND"] call BIS_fnc_sortBy;
			[_mainGrp, _largestGrps#0, 10, 25] spawn BIS_fnc_stalk;
		};
		
		// BOAT VEHICLES
		case "ship": {
			private _hasInf = !isNull _suppGrp;
			
			_wp = _mainGrp addWaypoint [_startingPos, 0];
			_wp setWaypointSpeed "FULL";
			_wp setWaypointType "MOVE";
			
			// Armed with no cargo, nothing to dismount
			if (_isArmed && !_hasInf) exitWith {
				_wp = _mainGrp addWaypoint [_startingPos, 300];
				_wp setWaypointType "SAD";
				_mainGrp setCombatMode "RED";
				_wp = _mainGrp addWaypoint [_startingPos, 300];
				_wp setWaypointType "GUARD";
			};
			
			// Find a random point nearby for rough landing position
			private _beachPos = _targetPos getPos [300, random 360];
			for [{_i = 100}, {_i <= (_startingPos distance2D _beachPos)}, {_i = _i + 50}] do {			
				private _checkLand = _beachPos getPos [_i, _beachPos getDir _startingPos];
				if (surfaceIsWater _checkLand) exitWith { _beachPos = _checkLand };
			};
			
			_wp = _mainGrp addWaypoint [_beachPos, 0];
			_wp setWaypointType "MOVE";
			_wp setWaypointCompletionRadius 50;
			_wp setWaypointStatements ["true", "
				if (vehicle this == this|| !local this) exitWith {};
				(vehicle this) spawn {
					private _counter = 0;
					waitUntil { 
						sleep 1;
						_counter = _counter + 1;
						if (_counter >= 30) then {
							{
								if (alive _x) then { moveOut _x; unassignVehicle _x; [_x] orderGetIn false; _x allowFleeing 0; };
							} forEach (if ([_this] call zmm_fnc_misc_isArmed) then { (fullCrew [_this, 'cargo']) apply { _x#0 } } else { units _this });
						}; 
						count (fullCrew [_this, 'cargo']) == 0
					};
				};
			"];
						
			// If is armed with cargo just unload the cargo, otherwise everyone gets out.
			_wp = _mainGrp addWaypoint [_beachPos, 0];
			_wp setWaypointType (if _isArmed then { "TR UNLOAD" } else { "GETOUT" });
			_wp setWaypointCompletionRadius 50;
			
			if _isArmed then {
				_wp setWaypointStatements ["count (fullCrew [vehicle this, 'cargo']) == 0", format["
					if !(local this) exitWith{};
					if (random 1 < 0.4) then { [vehicle this, 'SmokeLauncher'] spawn BIS_fnc_fire; };
				", _startingPos]];
		
				_wp = _mainGrp addWaypoint [selectRandom _spawnArray, 50];
				_wp setWaypointSpeed "NORMAL";
				_wp setWaypointType "MOVE";
				
				_wp = _mainGrp addWaypoint [selectRandom _spawnArray, 50];
				_wp setWaypointType "MOVE";
				
				_wp = _mainGrp addWaypoint [selectRandom _spawnArray, 300];
				_wp setWaypointType "GUARD";
			} else {
				_wp = _mainGrp addWaypoint [_targetPos, 300];
				_wp setWaypointType "SAD";
				
				_wp = _mainGrp addWaypoint [_targetPos, 50];
				_wp setWaypointType "GUARD";
			};
			
			if _hasInf then {
				_wp = _suppGrp addWaypoint [_beachPos, 0];
				_wp setWaypointType "GETOUT";
				_wp setWaypointCompletionRadius 50;
					
				_wp = _suppGrp addWaypoint [_targetPos, 300];
				_wp setWaypointType "SAD";
				
				_wp = _suppGrp addWaypoint [_targetPos, 50];
				_wp setWaypointType "GUARD";
			};
		};
		
		// AIR VEHICLES
		case "air": {
			private _hasInf = !isNull _suppGrp;
			
			// Armed with no cargo, nothing to dismount
			if (_isArmed && !_hasInf) exitWith {
				_wp = _mainGrp addWaypoint [_targetPos, 200];
				_wp setWaypointType "SAD";
				_wp setWaypointCompletionRadius 500;
				_wp setWaypointBehaviour "AWARE";
				_wp = _mainGrp addWaypoint [_targetPos getPos [400, random 360], 200];
				_wp setWaypointType "LOITER";
				_wp setWaypointCompletionRadius 1000;
			};
			
			private _infPos = _targetPos;
			if _isArmed then {
				// Far unload WP for transport
				_infPos = _targetPos getPos [600, random 360];
				_wp = _mainGrp addWaypoint [_infPos, 50];
				_wp setWaypointType "TR UNLOAD";
				_wp setWaypointCompletionRadius 100;
			
				// Add tracking code for last WP completion
				_wp setWaypointStatements ["true", "
					if (vehicle this == this || !local this) exitWith {};
					(vehicle this) spawn {
						private _timeOut = time + 600;
						private _mainGrp = group effectiveCommander _this;
						_mainGrp setBehaviour 'AWARE';
						waitUntil {
							uiSleep 15;
							{ if (_mainGrp knowsAbout _x < 4) then { _mainGrp reveal [_x, 4] } } forEach (allPlayers select { _x distance2D leader _mainGrp < 2000 });
							time > _timeOut || (count units _mainGrp == 0 || !(alive vehicle _this));
						};
					};
				"];
				
				_wp = _mainGrp addWaypoint [_targetPos, 0];
				_wp setWaypointType "SAD";
				_wp setWaypointCompletionRadius 500;
				_wp setWaypointBehaviour "AWARE";
				_wp = _mainGrp addWaypoint [_targetPos getPos [400, random 360], 0];
				_wp setWaypointType "LOITER";
				_wp setWaypointCompletionRadius 800;
			} else {
				// Close unload WP
				_infPos = _targetPos getPos [400, random 360];
				_wp = _mainGrp addWaypoint [_infPos, 50];
				_wp setWaypointType "TR UNLOAD";
				_wp setWaypointCompletionRadius 100;
				//_wp setWaypointStatements ["((count fullCrew [vehicle this, 'cargo']) + (count fullCrew [vehicle this, 'turret'])) == 0", ""];
				
				private _farPos = _targetPos getPos [3000, random 360];
				_wp = _mainGrp addWaypoint [_farPos, 200];
				_wp setWaypointType "MOVE";
				_wp setWaypointSpeed "FULL";
				
				_wp = _mainGrp addWaypoint [_farPos, 50];
				_wp setWaypointType "MOVE";
				_wp setWaypointStatements ["true", "private _mainGrp = group this; private _veh = vehicle this; { deleteVehicle _x } forEach (crew _veh); deleteVehicle _veh; deleteGroup _mainGrp;"];
			};
			
			// Infantry WPs 
			if _hasInf then {
				_mainGrp setBehaviour "CARELESS";
				_wp = _suppGrp addWaypoint [_infPos, 0];
				_wp setWaypointType "GETOUT";
				_wp setWaypointCompletionRadius 200;
					
				_wp = _suppGrp addWaypoint [_targetPos, 300];
				_wp setWaypointType "SAD";
				
				_wp = _suppGrp addWaypoint [_targetPos, 50];
				_wp setWaypointType "GUARD";
			};
		};
		
		// ANY OTHER VEHICLE TYPES
		default {
			private _hasInf = !isNull _suppGrp;
			
			_wp = _mainGrp addWaypoint [_startingPos, 0];
			_wp setWaypointType "MOVE";
			
			// Armed with no cargo, nothing to dismount
			if (_isArmed && !_hasInf) exitWith {				
				if (random 1 > 0.3) then {
					_wp = _mainGrp addWaypoint [_targetPos, 100];
					_wp setWaypointType "SAD";
				};

				_wp = _mainGrp addWaypoint [_targetPos, 250];
				_wp setWaypointType "GUARD";
			};
			
			_wp = _mainGrp addWaypoint [_startingPos, 0];
			_wp setWaypointType "MOVE";
			_wp setWaypointSpeed selectRandom ["FULL","NORMAL","FULL"];
			
			private _radius = (if _hasInf then { 300 } else { if _isArmed then { 100 } else { 200 } }) + random 200;
			
			// If is armed with cargo just unload the cargo, otherwise everyone gets out.
			_wp = _mainGrp addWaypoint [_targetPos, 0];
			_wp setWaypointType (if _isArmed then { "TR UNLOAD" } else { "GETOUT" });
			_wp setWaypointCompletionRadius _radius;
			_wp setWaypointStatements ["count (fullCrew [vehicle this, 'cargo']) == 0", "if !(local this) exitWith{}; if (random 1 > 0.5) then { [vehicle this, 'SmokeLauncher'] spawn BIS_fnc_fire };"];

			_wp = _mainGrp addWaypoint [_targetPos, 200];
			_wp setWaypointType 'SAD';
			
			_wp = _mainGrp addWaypoint [_targetPos, 50];
			_wp setWaypointType "GUARD";
			
			if !(_isArmed) then { 
				_grpVeh setVehicleLock 'UNLOCKED' 
			};
			
			if _hasInf then {
				_wp = _suppGrp addWaypoint [_targetPos, 0];
				_wp setWaypointType "GETOUT";
				_wp setWaypointCompletionRadius _radius;
				
				_wp = _suppGrp addWaypoint [_targetPos, 300];
				_wp setWaypointType 'SAD';
				
				_wp = _suppGrp addWaypoint [_targetPos, 50];
				_wp setWaypointType 'GUARD';
			};
		};
	};
};

zmm_fnc_qrf_spawnPara = {
	params [["_targetPos", [0,0,0]], ["_spawnArray", []], ["_side", EAST], ["_veh", ""]];

	private _enemyMen = missionNamespace getVariable [format["ZMM_%1_Man",_side],["O_Soldier_F"]];
	private _wave = missionNamespace getVariable ["ZQR_wave", 0];
	private _uid = (missionNamespace getVariable ["ZQR_count", 0]) + 1;	
	missionNamespace setVariable ["ZQR_count", _uid];

	private _groupMax = 99; // Maximum para groups
	private _groupSize = 8; // Units number per para group
	private _startPos = selectRandom _spawnArray;
	_startPos set [2, 500];

	// Split out init from class.
	private _customInit = "";
	if (_veh isEqualType []) then { _customInit = _veh#1; _veh = _veh#0 };

	["DEBUG", format["W%1_G%2 - spawnPara %3", _wave, _uid, _veh]] call zmm_fnc_misc_logMsg;

	private _grpVeh = createVehicle [_veh, _startPos, [], 0, "FLY"];
	private _dirTo =  _grpVeh getDir _targetPos;
	private _dirFrom =  (_grpVeh getDir _targetPos) + 180;
	_grpVeh setDir _dirTo;
	_grpVeh setVehicleLock "LOCKEDPLAYER";

	// Find the number of seats we can hold
	private _cargoMax = fullCrew [_veh, "cargo", true];

	if (_cargoMax < 1) exitWith { deleteVehicle _grpVeh };

	// Run the custom init 
	if !(isNil "_customInit") then { if !(_customInit isEqualTo "") then { call compile _customInit; } };

	private _grpPilot = [_grpVeh, _side] call zmm_fnc_ai_spawnCrew;

	// Create Para Group
	private _paraList = [];
	private _cargoLeft = _cargoMax;

	// Work out how many groups we can have without overfilling the vehicle.
	for [{_i = 0}, {_i <= ceil (_cargoMax / _groupSize)}, {_i = _i + 1}] do {
		if (_cargoLeft - _groupSize >= _groupSize) then {
			_paraList set [_i,_groupSize];
		} else {
			// Only part of a group can be added, if its worth adding include it.
			if (_cargoLeft > 2) then {
				_paraList set [_i,_groupSize];
			};
		};
		
		_cargoLeft = _cargoLeft - _groupSize;
	};

	// If there are more groups than allowed, remove them.
	if (count _paraList > _groupMax) then { _paraList resize _groupMax };

	// Create the groups and store them in a variable
	private _grpVehVar = [];
	private _grpVehCount = 0;

	{
		private _paraUnits = [];	
		for [{_i = 1}, {_i <= _x}, {_i = _i + 1}] do { _paraUnits pushBack (selectRandom _enemyMen) };

		_grpPara = [[0,0,0], _side, _paraUnits] call BIS_fnc_spawnGroup;
		_grpPara deleteGroupWhenEmpty true;
		_grpPara setGroupIdGlobal [format["QRF_W%1_G%2_PARA%3", _wave, _uid, _forEachIndex]];

		{ _x moveInAny _grpVeh } forEach units _grpPara;
		
		_wp = _grpPara addWaypoint [_targetPos, 0];
		_wp setWaypointType 'SAD';
		_wp = _grpPara addWaypoint [_targetPos, 0];
		_wp setWaypointType 'GUARD';

		sleep 0.5;
		
		_grpVehCount = _grpVehCount + _x;
	} forEach _paraList;

	// Set pilot wayPoints
	_wp = _grpPilot addWaypoint [_startPos, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointSpeed "FULL";
	_wp setWaypointBehaviour "CARELESS";
	_wp setWaypointStatements ["true","(vehicle this) setCollisionLight true;"];

	// Set Pilots wayPoints
	private  _dropStart = _targetPos getPos [_grpVehCount * 25, _dirFrom];
	/*private _tmp = createMarkerLocal ["dropStart", _dropStart];
	_tmp setMarkerTypeLocal "mil_dot";
	_tmp setMarkerTextLocal "Drop Start";*/

	_wp = _grpPilot addWaypoint [_dropStart, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointStatements ["true","
		(vehicle this) spawn {
			{
				unassignVehicle _x;
				[_x] orderGetIn false;
				moveOut _x; 
				sleep 0.5;
				_pc = createVehicle ['Steerable_Parachute_F', (getPosATL _x), [], 0, 'NONE'];
				_pc setPosATL (getPosatl _x);
				_vel = velocity _pc;
				_dir = random 360;
				_pc setVelocity [(_vel#0) + (sin _dir * 10),  (_vel#1) + (cos _dir * 10), (_vel#2)];
				_x moveinDriver _pc;
			} forEach ((crew _this) select { group driver _this != group _x });
		};
	"];

	if (([_grpVeh] call zmm_fnc_misc_isArmed) && random 1 > 0.7) then {
		_grpPilot setGroupIdGlobal [format["QRF_W%1_G%2_CREW", _wave, _uid]];
		_wp = _grpPilot addWaypoint [_targetPos, 0];
		_wp setWaypointType "SAD";
		_wp setWaypointCompletionRadius 300;
		_wp setWaypointBehaviour "AWARE";
		_wp = _grpPilot addWaypoint [_targetPos, 1];
		_wp setWaypointType "LOITER";
		_wp setWaypointCompletionRadius 500;
	} else {
		private _dropDelete = _targetPos getPos [3000, _dirTo];
		_wp = _grpPilot addWaypoint [_dropDelete, 0];
		_wp setWaypointType "MOVE";
		_wp setWaypointCompletionRadius 500;
		_wp setWaypointStatements ["true","private _mainGrp = group this; private _veh = vehicle this; { deleteVehicle _x } forEach (crew _veh); deleteVehicle _veh; deleteGroup _mainGrp;"];
	};
};

zmm_fnc_misc_isArmed = { 
	// zmm_fnc_misc_isArmed 
	params ["_veh"];

	if (isNil "_veh" || {isNull _veh}) exitWith { false };

	private _weapCount = 0;

	{
		_weapCount = _weapCount + count ((_veh weaponsTurret _x) select { 
			!(
				"dispenser" in toLower _x ||
				"fcs" in toLower _x ||
				"flare" in toLower _x ||
				"horn" in toLower _x ||
				"laser" in toLower _x ||
				"safe" in toLower _x ||
				"smoke" in toLower _x
			)
		})
	} forEach [[-1]] + allTurrets _veh;

	_weapCount > 0
};

zmm_fnc_misc_checkConfig = {
	params [["_side", EAST]];
	
	private _toCheck = [];
	_toCheck pushBack (missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]]);
	_toCheck pushBack (missionNamespace getVariable [format["ZMM_%1_Light",_side],[]]);
	_toCheck pushBack (missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]]);
	_toCheck pushBack (missionNamespace getVariable [format["ZMM_%1_Heavy",_side],[]]);
	_toCheck pushBack (missionNamespace getVariable [format["ZMM_%1_Air",_side],[]]);
	_toCheck pushBack (missionNamespace getVariable [format["ZMM_%1_CasP",_side],[]]);
	_toCheck pushBack (missionNamespace getVariable [format["ZMM_%1_CasH",_side],[]]);
	_toCheck pushBack (missionNamespace getVariable [format["ZMM_%1_Cas",_side],[]]);
	_toCheck pushBack (missionNamespace getVariable [format["ZMM_%1_Boat",_side],[]]);
	_toCheck pushBack (missionNamespace getVariable [format["ZMM_%1_Convoy",_side],[]]);
	_toCheck pushBack (missionNamespace getVariable [format["ZMM_%1_Static",_side],[]]);
	_toCheck pushBack (missionNamespace getVariable [format["ZMM_%1_Util",_side],[]]);
	
	// Check Vehicles
	{
		{
			_x params [["_obj",""],["_init",""]];
			
			if (_obj isEqualType "") then {
				if !(isClass (configFile >> "CfgVehicles" >> _obj)) then { ["ERROR", format["Invalid Unit: %1", _obj]] call zmm_fnc_misc_logMsg };
			} else {
				if !(isClass _obj) then { ["ERROR", format["Invalid Config: %1", _obj]] call zmm_fnc_misc_logMsg };
			};
		} forEach _x;
	} forEach _toCheck;

	// Check Units
	private _unitArray = missionNamespace getVariable [format["ZMM_%1_Man", _side], []];
	{ if !(isClass (configFile >> "CfgVehicles" >> _x)) then { ["ERROR", format["Invalid %2 Unit: %1", _x, _side]] call zmm_fnc_misc_logMsg } } forEach _unitArray;
};

zmm_fnc_qrf_createWave = {
	// zmm_fnc_qrf_createWave
	params [
		["_wave", 1]
		,["_side", EAST]
		,["_hasLand", true]
		,["_hasRoad", true]
		,["_hasSea", false]
		,["_hasAir", true]
	];

	private _waveInfo = [];
	private _difficulty = missionNamespace getVariable ["ZQR_difficulty", 1];
	private _players = (if isMultiplayer then { (count (allPlayers select { alive _x })) } else { 8 }) max 4;
	private _gunners = (
		count (allPlayers select {
			alive _x &&
			vehicle _x != _x &&
			_x == gunner vehicle _x
		})
	) min 4;
	private _effectivePlayers = (_players * (1 + (_gunners * 0.6))) * (0.75 + (_difficulty * 0.25));

	// Vehicle pools
	private _vehTruck = missionNamespace getVariable [format["ZMM_%1_Truck",_side],[]];
	private _vehLight = missionNamespace getVariable [format["ZMM_%1_Light",_side],[]];
	private _vehMedium = missionNamespace getVariable [format["ZMM_%1_Medium",_side],[]];
	private _vehHeavy = missionNamespace getVariable [format["ZMM_%1_Heavy",_side],[]];
	private _vehUtil = missionNamespace getVariable [format["ZMM_%1_Util",_side],[]];
	private _vehStatic = missionNamespace getVariable [format["ZMM_%1_Static",_side],[]];
	private _vehAirTransport =  missionNamespace getVariable [format["ZMM_%1_Air",_side],[]];
	private _vehAirPlane = missionNamespace getVariable [format["ZMM_%1_CasP",_side], missionNamespace getVariable [format["ZMM_%1_Cas",_side],[]]];
	private _vehAirHeli = missionNamespace getVariable [format["ZMM_%1_CasH",_side], missionNamespace getVariable [format["ZMM_%1_Cas",_side],[]]];
	private _vehBoat = missionNamespace getVariable [format["ZMM_%1_Boat",_side],[]];
	private _vehAirCas = _vehAirHeli + _vehAirPlane;

	// Unit Counts
	private _unitFactor = switch (true) do { case (_wave < 4): { 1 }; case (_wave < 6): { 1 + ((_wave - 3) * 0.5) }; default { 3 }; };
	private _unitCount = (
			round (
				4 * _unitFactor *
				(0.75 + (_difficulty * 0.25)) *
				(1 + ((_players - 4) * 0.03 max 0))
			)
		) min 12 max 3;

	// Group Counts
	private _infantryFactor = switch (true) do { case (_wave < 3): { 0.75 }; case (_wave < 5): { 1.25 }; default { 2 }; };
	private _infantryGroups = (round((_effectivePlayers / 3) * _infantryFactor * _difficulty)) max 1 min 6;
	private _lightVehGroups = (floor((_effectivePlayers / 10) * (_wave / 3) * _difficulty)) min 4;
	private _mediumVehGroups = if (_wave >= 3) then { floor((_effectivePlayers / 12) * ((_wave - 2) / 3) * _difficulty) min 3 } else { 0 };
	private _heavyVehGroups = if (_wave >= 5) then { floor((_effectivePlayers / 14) * ((_wave - 4) / 4) * _difficulty) min 2 } else { 0 };
	private _planeVehGroups = 0;

	if (_wave >= 3) then {
		// Much rarer aircraft scaling
		private _planeChance = (0.01 * _wave * _difficulty) min 0.25;
		if ((random 1) < _planeChance) then { 
			_planeVehGroups = 1;
			if (_wave >= 5 && _difficulty >= 1.5 && (random 1) < 0.2) then {
				_planeVehGroups = 2;
			};
		};
	};

	// Work out what the default should be
	private _defaultType = switch (true) do {
		case _hasLand: { [selectRandom ["house", "land"], _unitCount] };
		case _hasSea: { ["sea", selectRandom _vehBoat] };
		default { ["air", selectRandom _vehAirTransport] };
	};


	private _chanceHigh = random 1 < (((((_wave min 6) - 1) / (6 - 1)) * 0.5) min 0.5);
	private _chanceLow = random 1 < (((((_wave min 6) - 1) / (6 - 1)) * 0.2) min 0.2);

	if (_infantryGroups > 0) then {
		switch (true) do {
			case (_chanceHigh && _hasRoad && {count _vehTruck > 0} ): {
				_waveInfo pushBack ["road", selectRandom _vehTruck];
			};
			case (_chanceHigh && _hasSea && {count _vehBoat > 0} ): {
				_waveInfo pushBack ["sea", selectRandom _vehBoat];
			};
			case (_chanceLow && _hasAir && {count _vehAirTransport > 0}): {
				_waveInfo pushBack [ selectRandom ["air", "drop"], selectRandom _vehAirTransport];
			};
			default {
				_waveInfo pushBack _defaultType;
			};
		};
	};

	if (_lightVehGroups > 0) then {
		switch (true) do {
			case (_chanceHigh && _hasRoad && {count _vehTruck > 0}): {
				_waveInfo pushBack ["road", selectRandom _vehTruck];
			};
			case (_hasRoad && {count _vehLight > 0}): {
				_waveInfo pushBack ["road", selectRandom _vehLight];
			};
			case (_hasSea && {count _vehBoat > 0}): {
				_waveInfo pushBack ["sea", selectRandom _vehBoat];
			};
			default {
				_waveInfo pushBack _defaultType;
			};
		};
	};

	if (_mediumVehGroups > 0) then {
		switch (true) do {
			case (_chanceLow && _hasAir && {count _vehAirTransport > 0}): {
				_waveInfo pushBack [ selectRandom ["air", "drop"], selectRandom _vehAirTransport];
			};
			case (_hasRoad && {count _vehMedium > 0}): {
				_waveInfo pushBack ["road", selectRandom _vehMedium];
			};
			case (_hasRoad && {count _vehLight > 0}): {
				_waveInfo pushBack ["road", selectRandom _vehLight];
			};
			case (_hasSea && {count _vehBoat > 0}): {
				_waveInfo pushBack ["sea", selectRandom _vehBoat];
			};
			default {
				_waveInfo pushBack _defaultType;
			};
		};
	};

	if (_heavyVehGroups > 0) then {
		// 20% chance to replace with airdrop
		switch (true) do {
			case (_chanceLow && _hasAir && {count _vehAirTransport > 0}): {
				_waveInfo pushBack [ selectRandom ["air", "drop"], selectRandom _vehAirTransport];
			};
			case (_hasRoad && {count _vehHeavy > 0}): {
				_waveInfo pushBack ["road", selectRandom _vehHeavy];
			};
			case (_hasRoad && {count _vehMedium > 0}): {
				_waveInfo pushBack ["road", selectRandom _vehMedium];
			};
			case (_hasRoad && {count _vehLight > 0}): {
				_waveInfo pushBack ["road", selectRandom _vehLight];
			};
			case (_hasSea && {count _vehBoat > 0}): {
				_waveInfo pushBack ["sea", selectRandom _vehBoat];
			};
			case (_hasAir && {count _vehAirTransport > 0}): {
				_waveInfo pushBack [ selectRandom ["air", "drop"], selectRandom _vehAirTransport];
			};
			default {
				_waveInfo pushBack _defaultType;
			};
		};		
	};

	if (_planeVehGroups > 0 && {count _vehAirCas > 0}) then {
		_waveInfo pushBack ["cas", selectRandom _vehAirCas];
		
		// TODO IF THIS HAS FREE SEATS MAKE IT PARADROP
	};

	_waveInfo
};
	
// Get difficulty settings
ZQR_difficulty = missionNamespace getVariable ["f_param_ZMMDiff", missionNamespace getVariable ["ZZM_Diff", 1]];
ZQR_waveMax = _waveMax * ZQR_difficulty;
private _instance = (missionNamespace getVariable ["ZQR_instance", 0]) + 1;

// ZMM Stealh Ops support for ZoneIDs
if (isNil "_zoneID") then { ZQR_instance = _instance } else { _instance = _zoneID };

// Convert passed destination
switch (typeName _destination) do {
	case "STRING": {_destination = getMarkerPos _destination};
	case "OBJECT": {_destination = getPos _destination};
};

// Basic Error Checking
if !(_destination isEqualType []) exitWith { ["ERROR", "Invalid Destination Object/Position"] call zmm_fnc_misc_logMsg };
if isNil "_side" exitWith { ["ERROR", "Variable Undefined: '_side'"] call zmm_fnc_misc_logMsg };
if (count (allGroups select { side _x == _side }) == 0) then { ["WARNING", format["No groups present for %1 - Wrong faction?", _side]] call zmm_fnc_misc_logMsg };
if (count (missionNamespace getVariable [format["ZMM_%1_Man",_side],[]]) == 0) then { 
	if (count (missionNamespace getVariable [format["ZMM_%1_Man",_side],[]]) > 0) exitWith { 
		missionNamespace setVariable [format["ZMM_%1_Man",_side], missionNamespace getVariable [format["ZMM_%1_Man",_side],[]]]
	};
	["ERROR", format["No units in ZMM_%1_Man variable",_side]] call zmm_fnc_misc_logMsg 
};

// Position arrays
private _safePositions = [];
private _spawnAir = [];
private _spawnAirFar = [];
private _spawnHouse = [];
private _spawnLand = [];
private _spawnRoad = [];
private _spawnSea = [];

// Create safe-zones around spawn.
{
	if (_x in allMapMarkers) then {		
		_mkr = createMarkerLocal [format ["safezone_%1", _forEachIndex + 1000], getMarkerPos _x];
		_mkr setMarkerShapeLocal "ELLIPSE";
		_mkr setMarkerSizeLocal [1000,1000];
		_mkr setMarkerAlphaLocal 0.25;
	};
} forEach ["respawn_west","respawn_east","respawn_guerrila","respawn_civilian"];

{	
	if (["safezone_", toLower _x] call BIS_fnc_inString) then { _safePositions pushBack _x; };
} forEach allMapMarkers;

// White list custom spawns - Change this marker if needed!
{	
	if (["qrf_", toLower _x] call BIS_fnc_inString) then { _spawnLand pushBack getMarkerPos _x; };
} forEach allMapMarkers;

// Collect all roads 2km around the location that are not in a safe location.
for [{_i = 0}, {_i <= 360}, {_i = _i + 5}] do {
	private _posR = _destination getPos [_spawnDist, _i];
	_roads = (_posR nearRoads 50) select {((boundingBoxReal _x) select 0) distance2D ((boundingBoxReal _x) select 1) >= 25};
	
	if (count _roads > 0 && { _posR inArea _x } count _safePositions == 0) then {
		_road = _roads select 0;
		if ({_x distance2D _road < 200} count _spawnRoad == 0) then {
			_connected = roadsConnectedTo _road;
			_nearestRoad = objNull;
			{if ((_x distance _destination) < (_nearestRoad distance _destination)) then {_nearestRoad = _x}} forEach _connected;			
			if !(isnull _nearestRoad) then { _spawnRoad pushBackUnique position _nearestRoad };
		};
	};
	
	// House Pos not in safe area and more than 200m away from another point	
	private _posH = _destination getPos [(_spawnDist * 0.3), _i];
	private _nearBuild = nearestBuilding _posH;
	if (_nearBuild distance2D _posH < 100 && { _posH inArea _x } count _safePositions == 0) then {
		private _bpos = _nearBuild buildingPos -1;		
		_bpos = _bpos select { !(surfaceIsWater _x) };
		if (count _bpos > 0) then {
			private _lowestPos = ([_bpos, [], { _x select 2 }, "ASCEND"] call BIS_fnc_sortBy) select 0;
			if ({_x distance2D _lowestPos < 100} count _spawnHouse == 0) then {
				_spawnHouse pushBack _lowestPos;
			};
		};
	};
	
	// Land Pos not in safe area and more than 400m away from another point	
	private _posL = _destination getPos [(_spawnDist * 0.5), _i];
	if (!surfaceIsWater _posL && { _posL inArea _x } count _safePositions == 0) then {
		if ({_x distance2D _posL < 400} count _spawnLand == 0) then {
			_posL set [2, 0.5];
			_spawnLand pushBack _posL;
		};
	};
	
	// Water Pos not in safe area and more than 400m away from another point
	private _posS = _destination getPos [_spawnDist, _i];
	if (surfaceIsWater _posS && { _posS inArea _x } count _safePositions == 0) then {
		if ({_x distance2D _posS < 400} count _spawnSea == 0 && (0 - (getTerrainHeightASL _posS)) > 15) then {
			_posS set [2, (0 - (getTerrainHeightASL _posS))];
			_spawnSea pushBack _posS;
		};
	};
	
	// Air Pos not in safe area and more than 800m away from another point
	private _posA = _destination getPos [(_spawnDist * 3), _i];
	if ({ _posA inArea _x } count _safePositions == 0) then {
		if ({_x distance2D _posA < 1500} count _spawnAir == 0) then {
			_posA set [2, 500];
			_spawnAir pushBack _posA;
		};
	};
	
	// AirFar Pos not in safe area and more than 5000m away from another point
	private _posAF = _destination getPos [(_spawnDist * 5), _i];
	if ({ _posAF inArea _x } count _safePositions == 0) then {
		if ({_x distance2D _posAF < 5000} count _spawnAirFar == 0) then {
			_posAF set [2, 500];
			_spawnAirFar pushBack _posAF;
		};
	};
};

private _hasLand = count _spawnLand > 1;
private _hasRoad = count _spawnRoad > 1;
private _hasSea = count _spawnSea > 0;
private _hasAir = count _spawnAir > 0;

// DEBUG: Show Spawn Markers in local
{
	_x params ["_posType", "_mkrName", "_mkrText", "_mkrColor"];
	{
		private _mrkr = createMarkerLocal [format [_mkrName, _forEachIndex], _x];
		_mrkr setMarkerPosLocal _x;
		_mrkr setMarkerTypeLocal "mil_triangle";
		_mrkr setMarkerColorLocal _mkrColor;
		_mrkr setMarkerAlphaLocal 0.6;
		_mrkr setMarkerSizeLocal [0.6,0.6];
		_mrkr setMarkerDirLocal (_x getDir _destination);
		//_mrkr setMarkerTextLocal format[_mkrText,_forEachIndex];
	} forEach _posType;
} forEach [
	[_spawnRoad, "mkr_qrf_road_%1", "R%1", "ColorYellow"]
	,[_spawnLand, "mkr_qrf_land_%1", "L%1", "ColorOrange"]
	,[_spawnHouse, "mkr_qrf_house_%1", "H%1", "ColorRed"]
	,[_spawnSea, "mkr_qrf_water_%1", "W%1", "ColorBlue"]
	,[_spawnAir, "mkr_qrf_air_%1", "A%1", "ColorWhite"]
	,[_spawnAirFar, "mkr_qrf_airf_%1", "F%1", "ColorGreen"]
];

// Correct if no houses are avaliable
if (count _spawnHouse == 0) then { _spawnHouse = _spawnLand };
if (count _spawnAir == 0) then { _spawnAir = _spawnAirFar };
if (count _spawnAirFar == 0) then { _spawnAirFar = _spawnAir };

[_side] call zmm_fnc_misc_checkConfig;

// MAIN
// Spawn waves.
for [{_wave = 1}, {_wave <= ZQR_waveMax}, {_wave = _wave + 1}] do {
	ZQR_wave = _wave;
	
	// Stop spawns if no-one is nearby.
	if (({ _destination distance2D _x < (_spawnDist + 1000) } count (switchableUnits + playableUnits)) isEqualTo 0 && isMultiplayer) exitWith {
		["DEBUG", format["Wave %1 - Aborted - No players within %2 meters!", _wave, _spawnDist + 1000]] call zmm_fnc_misc_logMsg;
	};
	
	private _waveInfo = [];
	if (count (missionNamespace getVariable ["ZQR_WaveDetail",[]]) == 0) then {
		_waveInfo = [_wave] call zmm_fnc_qrf_createWave;
	} else {
		 _waveInfo = ZQR_WaveDetail select ((_wave - 1) min (count ZQR_WaveDetail - 1));
	};
	
	//["DEBUG", format["Starting Zone %1 - Wave %2/%3 - %4 %5", _instance, _wave, ZQR_waveMax, _side, _waveInfo]] call zmm_fnc_misc_logMsg;
	
	{
		_x params ["_location","_object"];
		
		if (_object isEqualType []) then { _object = selectRandom _object };
		
		["DEBUG", format["Zone %1 Wave %2/%3 - Spawning %4 (%5)", _instance, _wave, ZQR_waveMax, _object, _location]] call zmm_fnc_misc_logMsg;
	
		switch (toLower _location) do {
			case "air": { [_destination, _spawnAir, _side, _object, 1000] call zmm_fnc_qrf_spawnGroup };
			case "cas": { [_destination, _spawnAirFar, _side, _object, 1000] call zmm_fnc_qrf_spawnGroup };
			case "drop": { [_destination, _spawnAir, _side, _object] call zmm_fnc_qrf_spawnPara };
			case "house": { [_destination, _spawnHouse, _side, _object, 200] call zmm_fnc_qrf_spawnGroup };
			case "land": { [_destination, _spawnLand, _side, _object, 500] call zmm_fnc_qrf_spawnGroup };
			case "road": { [_destination, _spawnRoad, _side, _object, 500] call zmm_fnc_qrf_spawnGroup };
			case "sea": { [_destination, _spawnSea, _side, _object, 800] call zmm_fnc_qrf_spawnGroup };
			default { ["ERROR", format["Wave %1 - Invalid Spawn Location Type (%2)", _wave, _location]] call zmm_fnc_misc_logMsg };
		};
		
		sleep 5;
	} forEach _waveInfo;
	
	_tNextWave = time + _delay;	
	waitUntil {sleep 10; time > _tNextWave};
};