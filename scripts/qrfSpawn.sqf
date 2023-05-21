/*
	Author: 2600K / Josef Zemanek v1.35

	Description:
	Enemy Reinforcements Spawner
	
	_nul = [getMarkerPos "Objective"] execVM "scripts\qrfSpawn.sqf";
	_nul = [thisTrigger] execVM "scripts\qrfSpawn.sqf";
	
	Any marker containing text 'safezone' will not spawn units.
	Any marker containing text 'spawn' will act as an additional spawn point.
*/
if !isServer exitWith {};

params [
	"_location",		// Hunt/Search location.
	["_delay", 300],	// Seconds between waves.
	["_waveMax",6],		// Maximum Wave #
	["_spawnDist",1500]	// Spawning Distance
];

switch (typeName _location) do {
	case "STRING": {_location = getMarkerPos _location};
	case "OBJECT": {_location = getPos _location};
};

if !(_location isEqualType []) exitWith { systemChat "[QRF] ERROR Invalid Object/Position"; diag_log text "[QRF] ERROR Invalid Object/Position"; };

// Configuration - Pick ONE side.

/*

**********************
*** VANILLA GROUPS ***
**********************

// WEST - NATO TANOA (VANILLA)
_side = WEST;
ZMM_WESTMan = ["B_T_Soldier_F","B_T_soldier_LAT_F","B_T_Soldier_F","B_T_soldier_AR_F","B_T_Soldier_F","B_T_Soldier_TL_F","B_T_Soldier_F",selectRandom["B_T_Soldier_AA_F","B_T_Soldier_AT_F"]];
_Truck = [configFile >> "CfgGroups" >> "West" >> "BLU_T_F" >> "Motorized" >> "B_T_MotInf_Reinforcements"];
_Light = ["B_T_MRAP_01_gmg_F","B_T_MRAP_01_hmg_F","B_T_LSV_01_AT_F","B_T_LSV_01_armed_F"];
_Medium = [["B_T_AFV_Wheeled_01_up_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"],["B_T_APC_Wheeled_01_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5,'showSLATHull',0.6,'showSLATTurret',0.3]] call BIS_fnc_initVehicle;"],["B_T_APC_Tracked_01_rcws_F","[_grpVeh,false,['showCamonetHull',0.3]] call BIS_fnc_initVehicle;"]];
_Heavy = [["B_T_APC_Tracked_01_AA_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"],["B_T_MBT_01_TUSK_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"]];
_Air = ["B_Heli_Light_01_F",["B_Heli_Transport_01_F","[_grpVeh,['Green',1]] call BIS_fnc_initVehicle;"],"B_Heli_Transport_03_F"];
_CAS = ["B_Heli_Light_01_dynamicLoadout_F",["B_Heli_Attack_01_dynamicLoadout_F","_grpVeh setPylonLoadout [3,'PylonRack_12Rnd_missiles'];_grpVeh setPylonLoadout [4,'PylonRack_12Rnd_missiles'];"],["B_Plane_CAS_01_dynamicLoadout_F","_grpVeh setPylonLoadout [3,'PylonRack_7Rnd_Rocket_04_HE_F'];_grpVeh setPylonLoadout [4,'PylonMissile_1Rnd_Mk82_F'];_grpVeh setPylonLoadout [5,'PylonMissile_1Rnd_BombCluster_03_F'];_grpVeh setPylonLoadout [6,'PylonMissile_1Rnd_BombCluster_03_F'];_grpVeh setPylonLoadout [7,'PylonMissile_1Rnd_Mk82_F'];_grpVeh setPylonLoadout [8,'PylonRack_7Rnd_Rocket_04_AP_F'];"]];

// WEST - NATO (VANILLA)
_side = WEST;
ZMM_WESTMan = ["B_Soldier_F","B_soldier_LAT_F","B_Soldier_F","B_soldier_AR_F","B_Soldier_F","B_Soldier_TL_F","B_Soldier_F",selectRandom["B_Soldier_AA_F","B_Soldier_AT_F"]];
_Truck = [configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Motorized" >> "BUS_MotInf_Reinforce"];
_Light = ["B_MRAP_01_gmg_F","B_MRAP_01_hmg_F","B_LSV_01_AT_F","B_LSV_01_armed_F"];
_Medium = [["B_AFV_Wheeled_01_up_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"],["B_APC_Wheeled_01_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5,'showSLATHull',0.6,'showSLATTurret',0.3]] call BIS_fnc_initVehicle;"],["B_APC_Tracked_01_rcws_F","[_grpVeh,false,['showCamonetHull',0.3]] call BIS_fnc_initVehicle;"]];
_Heavy = [["B_APC_Tracked_01_AA_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"],["B_MBT_01_TUSK_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"]];
_Air = ["B_Heli_Light_01_F","B_Heli_Transport_01_F",["B_Heli_Transport_03_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;"]];
_CAS = ["B_Heli_Light_01_dynamicLoadout_F",["B_Heli_Attack_01_dynamicLoadout_F","_grpVeh setPylonLoadout [3,'PylonRack_12Rnd_missiles'];_grpVeh setPylonLoadout [4,'PylonRack_12Rnd_missiles'];"],["B_Plane_CAS_01_dynamicLoadout_F","_grpVeh setPylonLoadout [3,'PylonRack_7Rnd_Rocket_04_HE_F'];_grpVeh setPylonLoadout [4,'PylonMissile_1Rnd_Mk82_F'];_grpVeh setPylonLoadout [5,'PylonMissile_1Rnd_BombCluster_03_F'];_grpVeh setPylonLoadout [6,'PylonMissile_1Rnd_BombCluster_03_F'];_grpVeh setPylonLoadout [7,'PylonMissile_1Rnd_Mk82_F'];_grpVeh setPylonLoadout [8,'PylonRack_7Rnd_Rocket_04_AP_F'];"]];


// WEST - NATO (WOODLAND)
ZMM_WESTMan = ["B_W_Soldier_F","B_W_soldier_AR_F","B_W_Soldier_F","B_W_Soldier_TL_F","B_W_Soldier_F","B_W_Soldier_LAT2_F","B_W_Soldier_F",selectRandom["B_W_Soldier_AA_F","B_W_Soldier_AT_F"]];
_Truck = ["B_T_Truck_01_covered_F"];
_Light = ["B_T_MRAP_01_gmg_F","B_T_MRAP_01_hmg_F","B_T_LSV_01_AT_F","B_T_LSV_01_armed_F"];
_Medium = [["B_T_AFV_Wheeled_01_up_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"],["B_T_APC_Wheeled_01_cannon_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5,'showSLATHull',0.6,'showSLATTurret',0.3]] call BIS_fnc_initVehicle;"],["B_T_APC_Tracked_01_rcws_F","[_grpVeh,false,['showCamonetHull',0.3]] call BIS_fnc_initVehicle;"]];
_Heavy = [["B_T_APC_Tracked_01_AA_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"],["B_T_MBT_01_TUSK_F","[_grpVeh,false,['showCamonetTurret',0.3,'showCamonetHull',0.5]] call BIS_fnc_initVehicle;"]];
_Air = ["B_Heli_Light_01_F",["B_Heli_Transport_01_F","[_grpVeh,['Green',1]] call BIS_fnc_initVehicle;"],"B_Heli_Transport_03_F"];
_CAS = ["B_Heli_Light_01_dynamicLoadout_F","B_Heli_Attack_01_dynamicLoadout_F"];

// WEST - FIA (VANILLA)
_side = WEST;
ZMM_WESTMan = ["B_G_Soldier_F","B_G_Soldier_LAT_F","B_G_Soldier_F","B_G_Soldier_SL_F","B_G_Soldier_F","B_G_Soldier_AR_F"];
Truck = ["B_G_Van_01_transport_F"];
_Light = ["B_G_Offroad_01_AT_F","B_G_Offroad_01_armed_F"];
_Medium = [["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_02',1],['showSLATHull',0.3]] call BIS_fnc_initVehicle;"]];
_Heavy = [["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_02',1],['showSLATHull',0.7]] call BIS_fnc_initVehicle;"]];
_Air = [["B_Heli_Light_01_F","_grpVeh setObjectTextureGlobal [0, selectRandom['\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_graywatcher_co.paa','\A3\air_f\heli_light_01\data\heli_light_01_ext_ion_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_wasp_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_shadow_co.paa']];"]];
_CAS = [["B_Heli_Light_01_dynamicLoadout_F","_grpVeh setObjectTextureGlobal [0, selectRandom['\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_graywatcher_co.paa','\A3\air_f\heli_light_01\data\heli_light_01_ext_ion_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_wasp_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_shadow_co.paa']];"]];

// WEST - GENDARME (VANILLA)
_side = WEST;
ZMM_WESTMan = ["B_GEN_Soldier_F","B_GEN_Commander_F","B_GEN_Soldier_F","B_GEN_Soldier_F"];
Truck = ["B_GEN_Van_02_transport_F"];
_Light = [["B_G_Offroad_01_armed_F","[_grpVeh,false,['HideDoor1',0,'HideDoor2',0,'HideDoor3',0,'HideBackpacks',1,'HideBumper1',0,'HideBumper2',1,'HideConstruction',0]] call BIS_fnc_initVehicle;_grpVeh setObjectTextureGlobal [0,'\A3\Soft_F_Exp\Offroad_01\Data\Offroad_01_ext_gen_CO.paa']"]];
_Medium =[["O_MRAP_02_hmg_F","_grpVeh setObjectTextureGlobal [0,'#(rgb,8,8,3)color(0.7,0.8,1,0.03)'];_grpVeh setObjectTextureGlobal [1,'#(rgb,8,8,3)color(1,1,1,0.01)'];_grpVeh setObjectTextureGlobal [2,'#(rgb,8,8,3)color(1,1,1,0.01)'];"]];
_Heavy = [["O_T_APC_Wheeled_02_rcws_ghex_F","_grpVeh setObjectTextureGlobal [0,'#(rgb,8,8,3)color(0.7,0.8,1,0.03)'];_grpVeh setObjectTextureGlobal [1,'#(rgb,8,8,3)color(1,1,1,0.01)'];_grpVeh setObjectTextureGlobal [2,'#(rgb,8,8,3)color(1,1,1,0.01)'];_grpVeh setObjectTextureGlobal [4,'#(rgb,8,8,3)color(0,0,0,1)'];"]];
_Air = [["I_Heli_Transport_02_F","_grpVeh setObjectTextureGlobal [0,'a3\air_f_beta\Heli_Transport_02\Data\Skins\heli_transport_02_1_ion_co.paa'];_grpVeh setObjectTextureGlobal [1,'a3\air_f_beta\Heli_Transport_02\Data\Skins\heli_transport_02_2_ion_co.paa'];_grpVeh setObjectTextureGlobal [2,'a3\air_f_beta\Heli_Transport_02\Data\Skins\heli_transport_02_3_ion_co.paa'];"]];
_CAS = [];

// EAST - CSAT TANOA (VANILLA)
_side = EAST;
ZMM_EASTMan = ["O_T_Soldier_F","O_T_Soldier_LAT_F","O_T_Soldier_F","O_T_Soldier_GL_F","O_T_Soldier_F","O_T_Soldier_AR_F","O_T_Soldier_F",selectRandom["O_T_Soldier_AA_F","O_T_Soldier_AT_F"]];
_Truck = [configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Motorized_MTP" >> "O_T_MotInf_Reinforcements"];
_Light = ["O_T_MRAP_02_hmg_ghex_F","O_T_LSV_02_armed_F"];
_Medium = [["O_T_APC_Wheeled_02_rcws_ghex_F","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["O_T_APC_Tracked_02_cannon_ghex_F","[_grpVeh,false,['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
_Heavy = [["O_T_APC_Tracked_02_AA_ghex_F","[_grpVeh,false,['showSLATHull',0.5,'showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_T_MBT_02_cannon_ghex_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_T_MBT_04_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"]];
_Air = [["O_Heli_Light_02_unarmed_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;"],["O_Heli_Transport_04_bench_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;"]];
_CAS = [["O_T_VTOL_02_infantry_dynamicLoadout_F","_grpVeh setPylonLoadout [1,'PylonRack_19Rnd_Rocket_Skyfire']; _grpVeh setPylonLoadout [4,'PylonRack_19Rnd_Rocket_Skyfire'];"],["O_Heli_Light_02_dynamicLoadout_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;_grpVeh setPylonLoadout [2,'PylonRack_12Rnd_missiles'];"],["O_Heli_Attack_02_dynamicLoadout_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle; _grpVeh setPylonLoadout [1,'PylonRack_19Rnd_Rocket_Skyfire']; _grpVeh setPylonLoadout [4,'PylonRack_19Rnd_Rocket_Skyfire'];"],"O_Plane_CAS_02_dynamicLoadout_F"];

// EAST - CSAT (VANILLA)
_side = EAST;
ZMM_EASTMan = ["O_Soldier_F","O_Soldier_LAT_F","O_Soldier_F","O_Soldier_GL_F","O_Soldier_F","O_Soldier_AR_F","O_Soldier_F",selectRandom["O_Soldier_AA_F","O_Soldier_AT_F"]];
_Truck = [configFile >> "CfgGroups" >> "East" >> "OPF_F" >> "Motorized" >> "OIA_MotInf_Reinforce"];
_Light = ["O_MRAP_02_hmg_F","O_LSV_02_armed_F"];
_Medium = [["O_APC_Wheeled_02_rcws_v2_F","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["O_APC_Tracked_02_cannon_F","[_grpVeh,false,['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
_Heavy = [["O_APC_Tracked_02_AA_F","[_grpVeh,false,['showSLATHull',0.5,'showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_MBT_02_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_MBT_04_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"]];
_Air = ["O_Heli_Light_02_unarmed_F","O_Heli_Transport_04_bench_F"];
_CAS = [["O_T_VTOL_02_infantry_dynamicLoadout_F","[_grpVeh,['Hex',1]] call BIS_fnc_initVehicle;_grpVeh setPylonLoadout [1,'PylonRack_19Rnd_Rocket_Skyfire']; _grpVeh setPylonLoadout [4,'PylonRack_19Rnd_Rocket_Skyfire'];"],["O_Heli_Light_02_dynamicLoadout_F","_grpVeh setPylonLoadout [2,'PylonRack_12Rnd_missiles'];"],["O_Heli_Attack_02_dynamicLoadout_F", "_grpVeh setPylonLoadout [1,'PylonRack_19Rnd_Rocket_Skyfire']; _grpVeh setPylonLoadout [4,'PylonRack_19Rnd_Rocket_Skyfire'];"],"O_Plane_CAS_02_dynamicLoadout_F"];

// EAST - SPETSNAZ (VANILLA)
_side = EAST;
ZMM_EASTMan = ["O_R_Soldier_TL_F","O_R_soldier_M_F","O_R_Soldier_AR_F","O_R_JTAC_F","O_R_medic_F","O_R_Soldier_LAT_F","O_R_Soldier_GL_F"];
_Truck = [configFile >> "CfgGroups" >> "East" >> "OPF_R_F" >> "SpecOps" >> "O_T_MotInf_Reinforcements"];
_Light = ["O_T_MRAP_02_hmg_ghex_F","O_T_LSV_02_armed_F"];
_Medium = [["O_T_APC_Wheeled_02_rcws_ghex_F","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["O_T_APC_Tracked_02_cannon_ghex_F","[_grpVeh,false,['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
_Heavy = [["O_T_APC_Tracked_02_AA_ghex_F","[_grpVeh,false,['showSLATHull',0.5,'showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_T_MBT_02_cannon_ghex_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"],["O_T_MBT_04_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"]];
_Air = [["O_Heli_Light_02_unarmed_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;"],["O_Heli_Transport_04_bench_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;"]];
_CAS = ["O_T_VTOL_02_infantry_dynamicLoadout_F","[_grpVeh,['Grey',1]] call BIS_fnc_initVehicle;_grpVeh setPylonLoadout [1,'PylonRack_19Rnd_Rocket_Skyfire']; _grpVeh setPylonLoadout [4,'PylonRack_19Rnd_Rocket_Skyfire'];"],["O_Heli_Light_02_dynamicLoadout_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle;_grpVeh setPylonLoadout [2,'PylonRack_12Rnd_missiles'];"],["O_Heli_Attack_02_dynamicLoadout_F","[_grpVeh,['Black',1]] call BIS_fnc_initVehicle; _grpVeh setPylonLoadout [1,'PylonRack_19Rnd_Rocket_Skyfire']; _grpVeh setPylonLoadout [4,'PylonRack_19Rnd_Rocket_Skyfire'];"],"O_Plane_CAS_02_dynamicLoadout_F"];

// EAST - FIA (VANILLA)
_side = EAST;
ZMM_EASTMan = ["O_G_Soldier_SL_F","O_G_Soldier_F","O_G_Soldier_AR_F","O_G_Soldier_F","O_G_Soldier_LAT_F","O_G_Soldier_F"];
_Truck = ["O_G_Van_01_transport_F"];
_Light = ["O_G_Offroad_01_armed_F","O_G_Offroad_01_AT_F"];
_Medium = [["I_LT_01_cannon_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["I_LT_01_AT_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
_Heavy = [["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_02',1],['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
_Air = [["B_Heli_Light_01_F","_grpVeh setObjectTextureGlobal [0, selectRandom['\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_graywatcher_co.paa','\A3\air_f\heli_light_01\data\heli_light_01_ext_ion_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_wasp_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_shadow_co.paa']];"]];
_CAS = [["B_Heli_Light_01_dynamicLoadout_F","_grpVeh setObjectTextureGlobal [0, selectRandom['\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_graywatcher_co.paa','\A3\air_f\heli_light_01\data\heli_light_01_ext_ion_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_wasp_co.paa','\A3\air_f\heli_light_01\data\skins\heli_light_01_ext_shadow_co.paa']];"]];

// GUER - SYNDIKAT (VANILLA)
_side = INDEPENDENT;
ZMM_GUERMan = ["I_C_Soldier_Para_7_F","I_C_Soldier_Para_4_F","I_C_Soldier_Para_1_F","I_C_Soldier_Para_2_F"];
_Truck = ["I_C_Van_01_transport_F"];
_Light = ["I_C_Offroad_02_LMG_F","I_C_Offroad_02_AT_F"];
_Medium = [["I_LT_01_cannon_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["I_LT_01_AT_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
_Heavy = [["I_APC_Wheeled_03_cannon_F","[_grpVeh,['Guerilla_01',1,'Guerilla_03',0.5],['showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
_Air = ["I_Heli_light_03_unarmed_F"];
_CAS = [["I_Heli_light_03_dynamicLoadout_F","[_grpVeh,['Green',1],TRUE] call BIS_fnc_initVehicle;"]];

// GUER - AAF (VANILLA)
_side = INDEPENDENT;
ZMM_GUERMan = ["I_Soldier_F","I_Soldier_LAT2_F","I_Soldier_F","I_Soldier_GL_F","I_Soldier_F","I_Soldier_AR_F","I_Soldier_F",selectRandom["I_Soldier_AA_F","I_Soldier_AT_F"]];
_Truck = [configFile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Motorized" >> "HAF_MotInf_Reinforce"];
_Light = ["I_MRAP_03_hmg_F","I_MRAP_03_gmg_F"];
_Medium = [["I_LT_01_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["I_LT_01_AT_F","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["I_APC_Wheeled_03_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["I_APC_tracked_03_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3,'showSLATHull',0.5,'showSLATTurret',0.3]] call BIS_fnc_initVehicle;"]];
_Heavy = [["I_MBT_03_cannon_F","[_grpVeh,false,['HideTurret',0.3,'HideHull',0.3,'showCamonetHull',0.5,'showCamonetTurret',0.3]] call BIS_fnc_initVehicle;"]];
_Air = [["I_Heli_light_03_unarmed_F","[_grpVeh,['Indep',1]] call BIS_fnc_initVehicle;"],"I_Heli_Transport_02_F", ["O_Heli_Light_02_unarmed_F","_grpVeh setObjectTextureGlobal [0,'\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa'];"], ["B_Heli_Light_01_F","_grpVeh setObjectTextureGlobal [0,'A3\Air_F\Heli_Light_01\Data\heli_light_01_ext_indp_co.paa'];"]];
_CAS = ["I_Heli_light_03_dynamicLoadout_F","I_Plane_Fighter_03_dynamicLoadout_F",["O_Heli_Light_02_dynamicLoadout_F","_grpVeh setObjectTextureGlobal [0,'\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa']; _grpVeh setPylonLoadout [2,'PylonRack_12Rnd_missiles'];"]];

// GUER - LDF (VANILLA)
_side = INDEPENDENT;
ZMM_GUERMan = ["I_E_Soldier_F","I_E_Soldier_LAT2_F","I_E_Soldier_F","I_E_Soldier_AR_F","I_E_Soldier_F","I_E_Soldier_TL_F","I_E_Soldier_F",selectRandom["I_E_Soldier_AA_F","I_E_Soldier_AT_F"]];
_Truck = [configFile >> "CfgGroups" >> "Indep" >> "IND_E_F" >> "Motorized" >> "I_E_MotInf_Reinforcements"];
_Light = [["I_MRAP_03_HMG_F","{ _grpVeh setObjectTextureGlobal [_forEachIndex,_x] } forEach ['\A3\soft_f_beta\mrap_03\data\mrap_03_ext_co.paa','\A3\data_f\vehicles\turret_co.paa'];"],["I_MRAP_03_GMG_F","{ _grpVeh setObjectTextureGlobal [_forEachIndex,_x] } forEach ['\A3\soft_f_beta\mrap_03\data\mrap_03_ext_co.paa','\A3\data_f\vehicles\turret_co.paa'];"]];
_Medium = [["I_LT_01_cannon_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"],["I_LT_01_AT_F","[_grpVeh,['Indep_Olive',1],['showCamonetHull',0.5,'showSLATHull',0.5]] call BIS_fnc_initVehicle;"]];
_Heavy = [["I_E_APC_tracked_03_cannon_F","[_grpVeh,false,['showCamonetHull',0.5,'showCamonetTurret',0.3,'showSLATHull',0.5,'showSLATTurret',0.3]] call BIS_fnc_initVehicle;"]];
_Air = ["I_E_Heli_light_03_unarmed_F"];
_CAS = ["I_E_Heli_light_03_dynamicLoadout_F"];

********************
*** ADDON GROUPS ***
********************

// WEST - CDF (RHS)
_side = WEST;
ZMM_WESTMan = ["rhsgref_cdf_b_reg_machinegunner","rhsgref_cdf_b_reg_rifleman","rhsgref_cdf_b_reg_grenadier","rhsgref_cdf_b_reg_grenadier_rpg"];
_Truck = [configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_cdf_b_ground" >> "rhs_group_cdf_b_gaz66" >> "rhs_group_cdf_b_gaz66_squad", configFile >> "CfgGroups" >> "West" >> "rhsgref_faction_cdf_b_ground" >> "rhs_group_cdf_b_ural" >> "rhs_group_cdf_b_ural_squad"];
_Light = ["rhsgref_cdf_b_reg_uaz_ags","rhsgref_cdf_b_reg_uaz_dshkm","rhsgref_cdf_b_reg_uaz_spg9"];
_Medium = ["rhsgref_cdf_b_btr70","rhsgref_cdf_b_bmp2k","rhsgref_cdf_b_bmd1k","rhsgref_cdf_b_bmd2k"];
_Heavy = ["rhsgref_cdf_b_zsu234","rhsgref_cdf_b_t72bb_tv"];
_Air = ["rhsgref_cdf_b_reg_Mi8amt","rhsgref_cdf_b_reg_Mi17Sh"];
_CAS = ["rhsgref_cdf_b_Mi35","rhsgref_cdf_b_su25"];

// WEST - US ARMY D (RHS)
_side = WEST;
ZMM_WESTMan = ["rhsusf_army_ocp_rifleman","rhsusf_army_ocp_machinegunner","rhsusf_army_ocp_grenadier","rhsusf_army_ocp_riflemanat","rhsusf_army_ocp_squadleader"];
_Truck = [configFile >> "CfgGroups" >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_d" >> "rhs_group_nato_usarmy_d_RG33" >> "rhs_group_nato_usarmy_d_RG33_m2_squad", configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_d" >> "rhs_group_nato_usarmy_d_RG33" >> "rhs_group_nato_usarmy_d_RG33_squad"];
_Light = ["rhsusf_m1025_d_m2","rhsusf_m1025_d_Mk19"];
_Medium = ["rhsusf_m113d_usarmy","rhsusf_m113d_usarmy_MK19"];
_Heavy = ["RHS_M2A3","RHS_M6","rhsusf_m1a1aimd_usarmy"];
_Air = ["RHS_UH60M2_d","RHS_UH60M_d","RHS_MELB_MH6M"];
_CAS = ["RHS_MELB_AH6M","RHS_AH64DGrey","RHS_AH1Z"];

// WEST - US ARMY W (RHS)
_side = WEST;
ZMM_WESTMan = ["rhsusf_army_ucp_rifleman","rhsusf_army_ucp_machinegunner","rhsusf_army_ucp_grenadier","rhsusf_army_ucp_riflemanat","rhsusf_army_ucp_squadleader"];
_Truck = [configFile >> "CfgGroups" >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_wd" >> "rhs_group_nato_usarmy_wd_RG33" >> "rhs_group_nato_usarmy_wd_RG33_m2_squad", configFile >> "CfgGroups" >> "West" >> "rhs_faction_usarmy_wd" >> "rhs_group_nato_usarmy_wd_RG33" >> "rhs_group_nato_usarmy_wd_RG33_squad"];
_Light = ["rhsusf_m1025_w_m2","rhsusf_m1025_w_Mk19"];
_Medium = ["rhsusf_m113_usarmy","rhsusf_m113_usarmy_MK19"];
_Heavy = ["RHS_M2A3_wd","RHS_M6_wd","rhsusf_m1a1aimwd_usarmy"];
_Air = ["RHS_UH60M2","RHS_UH60M","RHS_MELB_MH6M"];
_CAS = ["RHS_MELB_AH6M","RHS_AH64D_wd"];

// WEST - HORIZON (RHS)
_side = WEST;
ZMM_WESTMan = ["rhsgref_hidf_grenadier","rhsgref_hidf_squadleader","rhsgref_hidf_autorifleman"];
_Truck = ["rhsgref_hidf_m998_4dr"];
_Light = ["rhsgref_hidf_m1025_m2","rhsgref_hidf_m1025_mk19"];
_Medium = ["rhsgref_hidf_m113a3_m2","rhsgref_hidf_m113a3_mk19"];
_Heavy = ["RHS_M2A3_wd","RHS_M6_wd","rhsusf_m1a1aimwd_usarmy"];
_Air = ["RHS_UH60M2","RHS_UH60M","RHS_MELB_MH6M"];
_CAS = ["RHS_MELB_AH6M","RHS_AH64D_wd"];

// EAST - RU MSV (RHS)
_side = EAST;
ZMM_EASTMan = ["rhs_msv_rifleman","rhs_msv_grenadier","rhs_msv_rifleman","rhs_msv_LAT","rhs_msv_rifleman","rhs_msv_grenadier_rpg","rhs_msv_rifleman","rhs_msv_machinegunner"];
_Truck = [configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_Ural" >> "rhs_group_rus_msv_Ural_squad", configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_gaz66" >> "rhs_group_rus_msv_gaz66_squad"];
_Light = ["rhs_tigr_sts_msv","rhsgref_nat_uaz_dshkm","rhsgref_nat_uaz_ags","rhsgref_nat_uaz_spg9"];
_Medium = ["rhs_btr80a_msv","rhs_btr70_msv","rhs_btr80_msv"];
_Heavy = ["rhs_bmp1_msv","rhs_bmp2e_msv","rhs_bmp3_msv"];
_Air = ["RHS_Mi8mt_vvsc","RHS_Mi8AMT_vvsc"];
_CAS = ["RHS_Mi24P_vvsc","RHS_Ka52_vvsc"];

// EAST - RU DESERT (RHS)
_side = EAST;
ZMM_EASTMan = ["rhs_vdv_mflora_rifleman","rhs_vdv_mflora_at","rhs_vdv_mflora_grenadier","rhs_vdv_mflora_sergeant","rhs_vdv_mflora_machinegunner"];
_Truck = [["RHS_Ural_VDV_01","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
_Light = [["RHS_Ural_Zu23_VDV_01","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"],["rhs_btr70_vdv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
_Medium = [["rhs_bmd2","[_grpVeh,['Desert',1]] call BIS_fnc_initVehicle;"],["rhs_bmp1k_vdv","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
_Heavy = [["rhs_t72bc_tv","[_grpVeh,['rhs_Sand',1]] call BIS_fnc_initVehicle;"], ["rhs_zsu234_aa","[_grpVeh,['rhs_sand',1]] call BIS_fnc_initVehicle;"]];
_Air = ["RHS_Mi8mt_vvsc","RHS_Mi8AMT_vvsc"];
_CAS = [["RHS_Mi24V_vvs","_grpVeh setPylonLoadout [5,'']; _grpVeh setPylonLoadout [6,''];"]];

// EAST - TAKI (ZEU)
_side = EAST;
ZMM_EASTMan = ["O_Taki_soldier_TL_F","O_Taki_soldier_R26_F","O_Taki_soldier_R_AK103_F","O_Taki_soldier_R_AK105_F"];
_Truck = [configFile >> "CfgGroups" >> "East" >> "Taki_Opfor" >> "Motorized" >> "Taki_MountedWarband"];
_Light = ["Taki_Ural_Zu23_F","Taki_UAZ_ags30_F","Taki_UAZ_dshkm_F","Taki_UAZ_spg9_F"];
_Medium = ["Taki_bmd1_F","Taki_bmp1_F"];
_Heavy = ["Taki_t72_F", "Taki_zsu_F"];
_Air = ["Taki_mi8_armed_F"];
_CAS = ["Taki_mi8_armed_F"];

// GUER - SAF (RHS)
_side = INDEPENDENT;
ZMM_GUERMan = ["rhssaf_army_m93_oakleaf_summer_spec_aa","rhssaf_army_m93_oakleaf_summer_spec_at","rhssaf_army_m93_oakleaf_summer_sq_lead","rhssaf_army_m93_oakleaf_summer_ft_lead","rhssaf_army_m93_oakleaf_summer_rifleman_m70","rhssaf_army_m93_oakleaf_summer_mgun_m84","rhssaf_army_m93_oakleaf_summer_gl","rhssaf_army_m93_oakleaf_summer_rifleman_at"];
_Truck = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_chdkz_g" >> "rhs_group_indp_ins_g_ural" >> "rhs_group_chdkz_ural_squad"];
_Light = ["rhsgref_nat_uaz_ags","rhsgref_nat_uaz_spg9","rhsgref_nat_uaz_dshkm"];
_Medium = ["rhsgref_nat_btr70"];
_Heavy = ["rhsgref_ins_g_bmp1k"];
_Air = [["RHS_Mi8mt_vvs","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
_CAS = ["rhsgref_ins_g_Mi8amt"];

// GUER - REBELS (RHS)
_side = INDEPENDENT;
ZMM_GUERMan = ["rhsgref_ins_g_rifleman","rhsgref_ins_g_machinegunner","rhsgref_ins_g_grenadier","rhsgref_ins_g_rifleman_RPG26"];
_Truck = [configFile >> "CfgGroups" >> "Indep" >> "rhsgref_faction_chdkz_g" >> "rhs_group_indp_ins_g_ural" >> "rhs_group_chdkz_ural_squad"];
_Light = ["rhsgref_ins_g_uaz_ags","rhsgref_ins_g_uaz_dshkm_chdkz","rhsgref_ins_g_uaz_spg9"];
_Medium = ["rhsgref_ins_g_btr70"];
_Heavy = ["rhsgref_ins_g_bmd1","rhsgref_ins_g_bmp1","rhsgref_ins_g_zsu234"];
_Air = [["RHS_Mi8mt_vvs","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];
_CAS = [["RHS_Mi8MTV3_vvs","[_grpVeh,['Camo1',1]] call BIS_fnc_initVehicle;"]];


***************************
*** GLOBAL MOBILISATION ***
***************************

// East Germany - Winter
_side = EAST;
ZMM_EASTMan = ["gm_gc_army_antitank_mpiak74n_rpg7_80_win","gm_gc_army_machinegunner_pk_80_win","gm_gc_army_rifleman_mpiak74n_80_win","gm_gc_army_squadleader_mpiak74n_80_win"];
_Truck = [configFile >> "CfgGroups" >> "East" >> "gm_gc_army_win" >> "gm_motorizedinfantry_80" >> "gm_gc_army_motorizedinfantly_squad_ural4320_cargo"];
_Light = ["gm_gc_army_brdm2_olw"];
_Medium = ["gm_gc_army_bmp1sp2_olw","gm_gc_army_btr60pa_olw"];
_Heavy = ["2gm_gc_army_t55a_olw","gm_gc_army_zsu234v1_olw"];
_Air = [["gm_gc_airforce_mi2p","[_grpVeh,['gm_gc_un',1]] call BIS_fnc_initVehicle;"]];
_CAS = [];

// East Germany - Summer
_side = EAST;
ZMM_EASTMan = ["gm_gc_army_rifleman_mpiak74n_80_str","gm_gc_army_squadleader_mpiak74n_80_str","gm_gc_army_machinegunner_pk_80_str","gm_gc_army_antitank_mpiak74n_rpg7_80_str","gm_gc_army_squadleader_mpiak74n_80_str"];
_Truck = [configFile >> "CfgGroups" >> "East" >> "gm_gc_army" >> "gm_motorizedinfantry_80" >> "gm_gc_army_motorizedinfantly_squad_ural4320_cargo"];
_Light = ["gm_gc_army_brdm2"];
_Medium = ["gm_gc_army_bmp1sp2","gm_gc_army_btr60pa"];
_Heavy = ["2gm_gc_army_t55a","gm_gc_army_zsu234v1"];
_Air = ["gm_gc_airforce_mi2p"];
_CAS = [];

// West Germany - Summer
_side = WEST;
ZMM_WESTMan = ["gm_ge_army_grenadier_g3a3_80_ols","gm_ge_army_rifleman_g3a3_80_ols","gm_ge_army_squadleader_g3a3_p2a1_80_ols","gm_ge_army_machinegunner_mg3_80_ols"];
_Truck = [configFile >> "CfgGroups" >> "West" >> "gm_ge_army" >> "gm_motorizedinfantry_80" >> "gm_ge_army_motorizedInfantry_squad_u1300l"];
_Light = ["gm_ge_army_iltis_milan"];
_Medium = ["gm_ge_army_fuchsa0_engineer","gm_ge_army_m113a1g_apc"];
_Heavy = ["gm_ge_army_Leopard1a3","gm_ge_army_gepard1a1"];
_Air = [];
_CAS = [];

// West Germany - Winter
_side = WEST;
ZMM_WESTMan = ["gm_ge_army_machinegunner_mg3_parka_80_win","gm_ge_army_rifleman_g3a3_parka_80_win","gm_ge_army_squadleader_g3a3_p2a1_parka_80_win","gm_ge_army_grenadier_g3a3_parka_80_win"];
_Truck = [configFile >> "CfgGroups" >> "West" >> "gm_ge_army_win" >> "gm_motorizedinfantry_80" >> "gm_ge_army_motorizedInfantry_squad_u1300l"];
_Light = ["gm_ge_army_iltis_milan_win"];
_Medium = ["gm_ge_army_fuchsa0_engineer_win","gm_ge_army_m113a1g_apc_win"];
_Heavy = ["gm_ge_army_Leopard1a1a1_win","gm_ge_army_gepard1a1_win"];
_Air = [];
_CAS = [];

// West Germany - Tropical
_side = WEST;
ZMM_WESTMan = ["gm_ge_army_grenadier_g3a3_80_ols","gm_ge_army_rifleman_g3a3_80_ols","gm_ge_army_squadleader_g3a3_p2a1_80_ols","gm_ge_army_machinegunner_mg3_80_ols"];
_Truck = [["gm_ge_army_u1300l_cargo","[_grpVeh,['gm_ge_trp',1]] call BIS_fnc_initVehicle;"]];
_Light = ["gm_ge_army_iltis_milan_trp"];
_Medium = ["gm_ge_army_fuchsa0_engineer_trp","gm_ge_army_m113a1g_apc_trp"];
_Heavy = ["gm_ge_army_Leopard1a3_trp","gm_ge_army_gepard1a1_trp"];
_Air = [];
_CAS = [];

// West Germany - Desert
_side = WEST;
ZMM_WESTMan = ["gm_ge_army_grenadier_g3a3_80_ols","gm_ge_army_rifleman_g3a3_80_ols","gm_ge_army_squadleader_g3a3_p2a1_80_ols","gm_ge_army_machinegunner_mg3_80_ols"];
_Truck = [["gm_ge_army_u1300l_cargo","[_grpVeh,['gm_ge_des',1]] call BIS_fnc_initVehicle;"]];
_Light = ["gm_ge_army_iltis_milan_des"];
_Medium = ["gm_ge_army_fuchsa0_engineer_des","gm_ge_army_m113a1g_apc_des"];
_Heavy = ["gm_ge_army_Leopard1a3_des","gm_ge_army_gepard1a1_des"];
_Air = [];
_CAS = [];

// Poland - Winter
_side = EAST;
ZMM_EASTMan = ["gm_pl_army_rifleman_akm_80_win","gm_pl_army_squadleader_akm_80_win","gm_pl_army_machinegunner_pk_80_win","gm_pl_army_antitank_akm_rpg7_80_win"];
_Truck = [configFile >> "CfgGroups" >> "East" >> "gm_pl_army_win" >> "gm_motorizedinfantry_80" >> "gm_pl_army_motorizedinfantly_squad_ural4320_cargo_80"];
_Light = ["gm_pl_army_brdm2_olw"];
_Medium = ["gm_pl_army_bmp1sp2_olw","gm_pl_army_ot64a_olw"];
_Heavy = ["gm_pl_army_zsu234v1_olw","gm_pl_army_pt76b_olw","gm_pl_army_t55_olw"];
_Air = [];
_CAS = [];

// Poland - Summer
_side = EAST;
ZMM_EASTMan = ["gm_pl_army_rifleman_akm_80_autumn_moro","gm_pl_army_squadleader_akm_80_autumn_moro","gm_pl_army_machinegunner_pk_80_autumn_moro","gm_pl_army_antitank_akm_rpg7_80_autumn_moro"];
_Truck = [configFile >> "CfgGroups" >> "East" >> "gm_pl_army" >> "gm_motorizedinfantry_80" >> "gm_pl_army_motorizedinfantly_squad_ural4320_cargo_80"];
_Light = ["gm_pl_army_brdm2"];
_Medium = ["gm_pl_army_bmp1sp2","gm_pl_army_ot64a"];
_Heavy = ["gm_pl_army_zsu234v1","gm_pl_army_pt76b","gm_pl_army_t55"];
_Air = [];
_CAS = [];

// GMX CDF - 1980
_side = WEST;
ZMM_WESTMan = ["gmx_cdf_army_antitank_ak74_rpg7_ttsko","gmx_cdf_army_rifleman_ak74_ttsko","gmx_cdf_army_machinegunner_rpk_ttsko","gmx_cdf_army_rifleman_ak74_ttsko","gmx_cdf_army_squadleader_ak74_ttsko","gmx_cdf_army_rifleman_ak74_ttsko","gmx_cdf_army_rifleman_ak74_ttsko"];
_Truck = ["gmx_cdf_ural4320_cargo_wdl"];
_Light = ["gmx_cdf_uaz469_spg9_wdl","gmx_cdf_uaz469_dshkm_wdl"];
_Medium = ["gmx_cdf_btr60pb_wdl","gmx_cdf_bmp1sp2_wdl","gmx_cdf_brdm2_wdl"];
_Heavy = ["gmx_cdf_zsu234v1_wdl","gmx_cdf_pt76b_wdl","gmx_cdf_t55_wdl"];
_Air = ["gmx_cdf_mi2p_wdl"];
_CAS = ["gmx_cdf_mi2urn_wdl"];

// GMX CDF - 2022
_side = WEST;
ZMM_WESTMan = ["gmx_cdf2022_army_rifleman_trg21_digittsko","gmx_cdf2022_army_machinegunner_pk_digittsko","gmx_cdf2022_army_rifleman_trg21_digittsko","gmx_cdf2022_army_antitank_trg21_pzf3_digittsko","gmx_cdf2022_army_rifleman_trg21_digittsko","gmx_cdf2022_army_squadleader_trg21_digittsko"];
_Truck = ["gmx_cdf2022_ural4320_cargo_wdl"];
_Light = ["gmx_cdf2022_uaz469_dshkm_wdl","gmx_cdf2022_uaz469_spg9_wdl"];
_Medium = ["gm_ge_army_fuchsa0_engineer_trp","gm_ge_army_m113a1g_apc_trp"];
_Heavy = ["gm_ge_army_Leopard1a3_trp","gm_ge_army_gepard1a1_trp"];
_Air = ["gmx_cdf2022_mi2p_wdl"];
_CAS = ["gmx_cdf2022_mi2urn_wdl"];

// GMX ChDkz
_side = EAST;
ZMM_EASTMan = ["gmx_chdkz_army_rifleman_akm_mix","gmx_chdkz_army_squadleader_akm_win","gmx_chdkz_army_rifleman_akm_mix","gmx_chdkz_army_antitank_akm_rpg7_mix","gmx_chdkz_army_machinegunner_rpk_mix","gmx_chdkz_army_rifleman_akm_mix","gmx_chdkz_army_grenadier_akm_pallad_mix"];
_Truck = ["gmx_chdkz_ural4320_cargo_wdr"];
_Light = ["gmx_chdkz_uaz469_dshkm_wdr","gmx_chdkz_uaz469_spg9_wdr"];
_Medium = ["gmx_chdkz_bmp1sp2_wdr","gmx_chdkz_brdm2_wdr","gmx_chdkz_btr60pb_wdr","gmx_chdkz_ot64a_wdr"];
_Heavy = ["gmx_chdkz_zsu234v1_wdr","gmx_chdkz_t55_wdr","gmx_chdkz_t55_wdr"];
_Air = ["gmx_chdkz_mi2p_wdl"];
_CAS = ["gmx_chdkz_mi2urn_wdl"];

// GMX AAF 1990
_side = INDEPENDENT;
ZMM_GUERMan = ["I_Soldier_F","I_Soldier_LAT_F","I_Soldier_GL_F","I_Soldier_AR_F"];
_Sentry = [configFile >> "CfgGroups" >> "Indep" >> "IND_F" >> "Infantry" >> "HAF_InfSentry"];
_Light = ["gmx_aaf_fuchsa0_engineer_wdl","gmx_aaf_iltis_milan_wdl"];
_Medium = ["gmx_aaf_luchsa2_wdl","gmx_aaf_marder1a2_wdl"];
_Heavy = ["gmx_aaf_gepard1a1_wdl","gmx_aaf_leopard1a5_wdl","gmx_aaf_leopard1a5_wdl"];
_Air = [["I_Heli_light_03_unarmed_F","[_grpVeh,['Indep',1]] call BIS_fnc_initVehicle;"],"I_Heli_Transport_02_F", ["O_Heli_Light_02_unarmed_F","_grpVeh setObjectTextureGlobal [0,'\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa'];"], ["B_Heli_Light_01_F","_grpVeh setObjectTextureGlobal [0,'A3\Air_F\Heli_Light_01\Data\heli_light_01_ext_indp_co.paa'];"]];
_CAS = ["I_Heli_light_03_dynamicLoadout_F","I_Plane_Fighter_03_dynamicLoadout_F",["O_Heli_Light_02_dynamicLoadout_F","_grpVeh setObjectTextureGlobal [0,'\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa']; _grpVeh setPylonLoadout [2,'PylonRack_12Rnd_missiles'];"]];

// GM Revolutionaries
_side = INDEPENDENT;
ZMM_GUERMan = ["gm_xx_army_squadleader_m16a1_80_grn","gm_xx_army_rifleman_01_akm_alp","gm_xx_army_machinegunner_rpk_80_oli","gm_xx_army_assault_ak74nk_80_wdl","gm_xx_army_antitank_hk53a2_rpg7_80_oli"];
_Truck = [["gmx_chdkz_ural4320_cargo_wdr","[_grpVeh,['gmx_chdkz_wdl',1]] call BIS_fnc_initVehicle;"]];
_Light = [[["gmx_chdkz_uaz469_dshkm_wdr","[_grpVeh,['gmx_chdkz_wdl',1]] call BIS_fnc_initVehicle;"]],[["gmx_chdkz_uaz469_spg9_wdr","[_grpVeh,['gmx_chdkz_wdl',1]] call BIS_fnc_initVehicle;"]]];
_Medium = [[["gmx_chdkz_btr60pb_wdr","[_grpVeh,['gmx_chdkz_wdl',1]] call BIS_fnc_initVehicle;"]]];
_Heavy = [[["gmx_chdkz_bmp1sp2_wdr","[_grpVeh,['gmx_chdkz_wdl',1]] call BIS_fnc_initVehicle;"]],[["gmx_chdkz_t55_wdr","[_grpVeh,['gmx_chdkz_wdl',1]] call BIS_fnc_initVehicle;"]]];
_Air = ["gmx_chdkz_mi2p_wdl"];
_CAS = ["gmx_chdkz_mi2urn_wdl"];

*/

if isNil "_side" exitWith { systemChat "QRFSpawn.sqf - ERROR - No Side defined!"; diag_log "QRFSpawn.sqf - ERROR - No Side defined!"; };

// Functions.
zmm_fnc_spawnUnit = {
	params [
		["_targetPos", []],
		["_posArray", []],
		"_side",
		["_unitClass", ""],
		["_tries", 1]
	];

	if (_unitClass isEqualTo "") exitWith { diag_log format["[QRF] SpawnUnit - Empty Unit Passed: %1 (%2)", _unitClass, _side] };
	if (_tries > 10) exitWith {};

	diag_log format["[QRF] SpawnUnit - Passed %1: %2 [%3] Try:%4", _targetPos, _unitClass, _side, _tries];

	private _reinfGrp = grpNull;
	private _grpVeh = objNull;
	private _vehType = "";
	private _sleep = true;
	private _dir = 0;
	private _customInit = "";

	// No positions to use
	if (count _posArray == 0 || count _targetPos == 0) exitWith {};

	// Fix any positions are not in array format
	{
		switch (typeName _x) do {
			case "STRING": { _posArray set [_forEachIndex, getMarkerPos _x] };
			case "OBJECT": { _posArray set [_forEachIndex, getPos _x] };
		};
	} forEach _posArray;

	private _startingPos = selectRandom _posArray;
	_startingPos set [2,0];
	_dir = _startingPos getDir _targetPos;
	private _enemyMen = missionNamespace getVariable [format["ZMM_%1Man", _side], ["B_Soldier_F"]];

	// If _unitClass is array, extract the custom init.
	if (_unitClass isEqualType []) then { _customInit = _unitClass # 1; _unitClass = _unitClass # 0 };

	// If _unitClass is a number, fill it with random units.
	if (_unitClass isEqualType 1) then { 
		private _enemyTeam = [];
		for "_i" from 0 to (_unitClass - 1) do {  _enemyTeam set [_i, selectRandom _enemyMen] };
		_unitClass = _enemyTeam;
	};

	// Check if _unitClass is an air vehicle.
	_isAir = false;
	if (_unitClass isEqualType "") then {
		if ("Air" in ([(configFile >> "CfgVehicles" >> _unitClass), true] call BIS_fnc_returnParents)) then { _isAir = true; _startingPos set [2, 500]; };
	};

	// Don't spawn object if too close to any players.
	if ({ alive _x && _x distance2D _startingPos < (if _isAir then {1000} else {500})} count allPlayers > 0 && isMultiplayer) exitWith { 
		sleep 30;
		[_targetPos, _posArray, _side, _unitClass, _tries + 1] call zmm_fnc_spawnUnit;
	};

	if (_unitClass isEqualType "") then {
		_vehType = toLower getText (configFile >> "CfgVehicles" >> _unitClass >> "vehicleClass");
		_vehName = toLower getText (configFile >> "CfgVehicles" >> _unitClass >> "displayName");
		_grpVeh = createVehicle [_unitClass, _startingPos, [], 0, if _isAir then {"FLY"} else {"NONE"}];
		_grpVeh setVehicleLock "LOCKEDPLAYER";
		[_grpVeh,[1, 0.5, 0.5]] remoteExec ["setVehicleTIPars"];

		if _isAir then {
			_sleep = false;
			_grpVeh setDir (_grpVeh getDir _targetPos);
			_grpVeh setVelocity [100 * (sin (_grpVeh getDir _targetPos)), 100 * (cos (_grpVeh getDir _targetPos)), 0];
		} else {
			_grpVeh setDir _dir;
		};
		
		_startingPos set [2,0]; // Reset Starting Pos
		
		if (_vehType == "car" || (!canFire _grpVeh && !_isAir)) then {
			_vehType = "car";
			private _soldierArr = [];
			private _cargoNo = (count fullCrew [_grpVeh, "", true]) min 12;
			for "_i" from 1 to _cargoNo do { _soldierArr pushBack (if (_cargoNo > 4) then { selectRandom _enemyMen } else { _enemyMen#0 }) }; // Random units for cargo
		
			_reinfGrp = [_grpVeh getPos [15, random 360], _side, _soldierArr] call BIS_fnc_spawnGroup;
			_reinfGrp addVehicle _grpVeh;
			
			{ if !(_x moveInAny _grpVeh) then { /* deleteVehicle _x */ }; uiSleep 0.1; } forEach (units _reinfGrp select { vehicle _x == _x });
			
			uiSleep 0.5;
			
			_reinfGrp selectLeader effectiveCommander _grpVeh;
		} else {
			createVehicleCrew _grpVeh;
			
			// Convert crew if using another faction vehicle.
			if (([getNumber (configFile >> "CfgVehicles" >> _unitClass >> "Side")] call BIS_fnc_sideType) != _side) then {
				_reinfGrp = createGroup [_side, true];
				(crew _grpVeh) join _reinfGrp;
			};
			
			_reinfGrp = group effectiveCommander _grpVeh;
		};	
	} else {
		_reinfGrp = [_startingPos, _side, _unitClass] call BIS_fnc_spawnGroup;
		
		_vehArray = (units _reinfGrp apply { assignedVehicle _x }) - [objNull];
		
		if (count (_vehArray arrayIntersect _vehArray) > 0) then {
			_grpVeh = (_vehArray arrayIntersect _vehArray)#0;
			_vehType = "car";
			
			uiSleep 0.5;
			
			{ if !(_x moveInAny _grpVeh) then { deleteVehicle _x }; uiSleep 0.1; } forEach (units _reinfGrp select { vehicle _x == _x });
			
			_reinfGrp selectLeader effectiveCommander _grpVeh;
		};
	};

	// Run custom init for vehicle (set camos etc).
	if !(isNil "_customInit") then { 
		if !(_customInit isEqualTo "") then { call compile _customInit; };
	};

	if !_isAir then {
		if (random 1 > 0.3) then {
			_newWP = _reinfGrp addWaypoint [_targetPos, 100];
			_newWP setWaypointType "SAD";
		};

		_newWP = _reinfGrp addWaypoint [_targetPos, 100];
		_newWP setWaypointType "GUARD";
		
		if (_vehType == "car") then {
			_null = [_reinfGrp, _startingPos, _grpVeh, _targetPos] spawn {
				params ["_selGrp", "_startPos", "_selVeh", "_destPos"];

				private _leader = effectiveCommander _selVeh;
							
				waitUntil{ uiSleep 10; if (_leader distance2D _destPos < (400 + random 200) || !alive _leader || !canMove _selVeh) exitWith {true}; false; };
				
				if (!alive _leader || !canMove _selVeh) exitWith {};
				
				// Leave team in if it can fire
				if (canFire _selVeh) then {
					_vehGrp = createGroup [side group _leader, true];
					[_leader, driver _selVeh, gunner _selVeh] joinSilent _vehGrp;
				};
				
				_selGrp leaveVehicle _selVeh;
				{unassignVehicle _x; [_x] orderGetIn false; _x allowFleeing 0} forEach units _selGrp;
				
				waitUntil{ uiSleep 1; if ({vehicle _x == _selVeh} count units _selGrp == 0 || !alive _leader || !canMove _selVeh) exitWith {true}; false; };
				
				if (!alive _leader || !canMove _selVeh) exitWith {};
								
				uiSleep 5;
				
				if (canFire _selVeh) then {
					if (random 1 > 0.7) then {
						_newWP = group _leader addWaypoint [_destPos, 100];
						_newWP setWaypointType "SAD";
					};
					
					_newWP = group _leader addWaypoint [_destPos, 100];
					_newWP setWaypointType "GUARD";
				} else {
					_newWP = group _leader addWaypoint [_startPos, 0];
					waitUntil{ uiSleep 0.5; if (_selVeh distance2D _startPos < 50 || !alive _leader || !canMove _selVeh) exitWith {true}; false; };
					if (!alive _leader || !canMove _selVeh) exitWith {};
					_selVeh deleteVehicleCrew driver _selVeh;
					deleteGroup group _leader;
					deleteVehicle _selVeh;
				};
			};
		};
	} else {
		private _paraGrp = grpNull;
		private _cargoNo = ((count fullCrew [_grpVeh, "", true]) - (count fullCrew [_grpVeh, "", false])) min 12;
		
		// No cargo seats so assume its CAS
		if (_cargoNo > 1) then {
			_reinfGrp setBehaviour "CARELESS";
			_soldierArr = [];
			
			for "_i" from 1 to _cargoNo do { _soldierArr pushBack (selectRandom _enemyMen) };

			_paraGrp = [[0,0,0], _side, _soldierArr] call BIS_fnc_spawnGroup;
			
			{ if !(_x moveInAny _grpVeh) then { deleteVehicle _x }; uiSleep 0.1; } forEach (units _paraGrp select { vehicle _x == _x });
			
			_landPos = [_targetPos, 300, random 360] call BIS_fnc_relPos;		
			_unloadWP = _reinfGrp addWaypoint [_landPos, 100];
			_unloadWP setWaypointStatements ["true", "(vehicle this) land 'GET OUT'; {unassignVehicle _x; [_x] orderGetIn false} forEach ((crew vehicle this) select {group _x != group this})"];
			_newWP = _reinfGrp addWaypoint [waypointPosition _unloadWP, 0];
			_newWP setWaypointStatements ["{group _x != group this && alive _x} count crew vehicle this == 0", ""];
		};

		_weapCount = 0;
		{ _weapCount = _weapCount + count _x } forEach (([[-1]] + (allTurrets _grpVeh)) apply { (_grpVeh weaponsTurret _x) - [
			"rhsusf_weap_CMDispenser_ANALE39",
			"rhsusf_weap_CMDispenser_ANALE40",
			"rhsusf_weap_CMDispenser_ANALE52",
			"rhsusf_weap_CMDispenser_M130",
			"rhs_weap_CMDispenser_ASO2",
			"rhs_weap_CMDispenser_BVP3026",
			"rhs_weap_CMDispenser_UV26",
			"rhs_weap_MASTERSAFE",
			"rhsusf_weap_LWIRCM",
			"Laserdesignator_pilotCamera",
			"rhs_weap_fcs_ah64"]
		});
		
		// If has turrets hang around AO, otherwise despawn.
		if (_weapCount > 1) then {
			// TODO: Could be better? Make heli leave after a few SAD wps?
			_newWP = _reinfGrp addWaypoint [_targetPos, 0];
			_newWP setWaypointType "SAD";
			_newWP setWaypointCompletionRadius 300;
			_newWP setWaypointBehaviour "AWARE";
			_newWP = _reinfGrp addWaypoint [_targetPos, 1];
			_newWP setWaypointType "LOITER";
			_newWP setWaypointCompletionRadius 500;
			
			_null = [_reinfGrp, _startingPos, _targetPos] spawn {
				params ["_rGrp","_sPos","_tPos"];
								
				private _time = time + 600;
				while {	alive (vehicle leader _rGrp) && time < _time } do {
					uiSleep 30;
					{ if (_rGrp knowsAbout _x < 4) then { _rGrp reveal [_x, 4] } } forEach (allPlayers select {_x distance2D leader _rGrp < 2500 && stance _x != "PRONE" });
				};
			};
		} else {
			_newWP = _reinfGrp addWaypoint [_startingPos, 0];
			_null = [_reinfGrp, _startingPos] spawn {
				params ["_reinfGrp","_startingPos"];
				_heli = vehicle leader _reinfGrp;
				waitUntil{ uiSleep 5; if ((leader _reinfGrp) distance2D _startingPos > 200 || !alive (leader _reinfGrp) || !canMove _heli) exitWith {true}; false; };
				waitUntil{ uiSleep 0.5; if ((leader _reinfGrp) distance2D _startingPos < 200 || !alive (leader _reinfGrp) || !canMove _heli) exitWith {true}; false; };
				if (!alive (leader _reinfGrp) || !canMove _heli) exitWith {};
				{_heli deleteVehicleCrew _x} forEach crew _heli;
				deleteGroup _reinfGrp;
				deleteVehicle _heli;
			};
		};
		
		if (count units _paraGrp > 0) then {
			_newWP = _paraGrp addWaypoint [_targetPos, 100];
			_newWP setWaypointType "SAD";
			_newWP = _paraGrp addWaypoint [_targetPos, 100];
			_newWP setWaypointType "GUARD";
			_reinfGrp = _paraGrp;
		};
	};

	if (!isNull _reinfGrp) then { _reinfGrp deleteGroupWhenEmpty true };

	{ _x addCuratorEditableObjects [(units _reinfGrp) + [_grpVeh], true] } forEach allCurators;

	if (_sleep) then { sleep random 20 };
};

zmm_fnc_spawnPara = {
	params [["_location", [0,0,0]], ["_side", EAST], ["_vehicle", ""]];

	private _man = missionNamespace getVariable [format["ZMM_%1Man",_side],["O_Soldier_F"]];

	sleep random 30;

	private _groupMax = 99; // Maximum para groups
	private _groupSize = 8; // Units number per para group

	_startPos = _location getPos [3000, random 360];

	// Split out init from class.
	private _customInit = "";
	if (_vehicle isEqualType []) then { _customInit = _vehicle # 1; _vehicle = _vehicle # 0 };

	private _grpVeh = createVehicle [_vehicle, _startPos, [], 0, "FLY"];
	private _dirTo =  _grpVeh getDir _location;
	private _dirFrom =  (_grpVeh getDir _location) + 180;
	_grpVeh setDir _dirTo;
	//_grpVeh flyInHeight 200;

	// Run the custom init 
	if !(isNil "_customInit") then { 
		if !(_customInit isEqualTo "") then { call compile _customInit; };
	};

	createVehicleCrew _grpVeh;
	(group effectiveCommander _grpVeh) deleteGroupWhenEmpty true;

	// Convert crew if using another sides vehicle.
	if (([getNumber (configFile >> "CfgVehicles" >> _vehicle >> "Side")] call BIS_fnc_sideType) != _side) then {
		_grp = createGroup [_side, true];
		(crew _grpVeh) join _grp;
	};

	private _grp = group effectiveCommander _grpVeh;

	// Find the number of seats we can hold
	private _cargoMax = ([_vehicle, true] call BIS_fnc_crewCount) - ([_vehicle, false] call BIS_fnc_crewCount);

	if (_cargoMax < 1) exitWith { _grpVeh setDamage 1 };

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
		for [{_i = 1}, {_i <= _x}, {_i = _i + 1}] do { _paraUnits pushBack (selectRandom _man) };

		_grpPara = [[0,0,0], _side, _paraUnits] call BIS_fnc_spawnGroup;

		{ _x moveInAny _grpVeh } forEach units _grpPara;
		
		_wp = _grpPara addWaypoint [_location, 0];
		_wp setWaypointType 'SAD';
		_wp = _grpPara addWaypoint [_location, 0];
		_wp setWaypointType 'GUARD';
		
		sleep 0.5;

		_grpVehVar pushBack _grpPara;
		
		_grpVehCount = _grpVehCount + _x;
	} forEach _paraList;

	_grpVeh setVariable ['var_dropGroup', _grpVehVar];

	// Set pilot wayPoints
	_wp = _grp addWaypoint [_startPos, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointSpeed "FULL";
	_wp setWaypointBehaviour "CARELESS";
	_wp setWaypointStatements ["true","(vehicle this) setPilotLight true;"];

	// Set Pilots wayPoints

	private  _dropStart = _location getPos [_grpVehCount * 25, _dirFrom];
	private _tmp = createMarkerLocal ["dropStart", _dropStart];
	_tmp setMarkerTypeLocal "mil_dot";
	_tmp setMarkerTextLocal "Start";

	_wp = _grp addWaypoint [_dropStart, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointStatements ["true","
		(vehicle this) spawn {
			{
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
				} forEach (units _x);
				sleep 1;
			} forEach (_this getVariable ['var_dropGroup',[]]);
		};
	"];

	private _dropDelete = _location getPos [3000, _dirTo];
	_wp = _grp addWaypoint [_dropDelete, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointCompletionRadius 500;
	_wp setWaypointStatements ["true","_delVeh = (vehicle this); { deleteVehicle (_x#0) } forEach (fullCrew _delVeh); deleteVehicle _delVeh; deleteGroup (group this);"];
};

// PREPERATION
private _safePositions = [];
private _spawnRoad = [];
private _spawnLand = [];

if (!isNil "_Soldier") then { missionNamespace setVariable [format["ZMM_%1Man", _side], _Soldier]; }; // Variable array for function reference.

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
for [{_i = 0}, {_i <= 360}, {_i = _i + 1}] do {
	private _posR = _location getPos [_spawnDist, _i];
	_roads = (_posR nearRoads 50) select {((boundingBoxReal _x) select 0) distance2D ((boundingBoxReal _x) select 1) >= 25};
	
	if (count _roads > 0 && { _posR inArea _x } count _safePositions == 0) then {
		_road = _roads select 0;
		if ({_x distance2D _road < 100} count _spawnRoad == 0) then {
			_connected = roadsConnectedTo _road;
			_nearestRoad = objNull;
			{if ((_x distance _location) < (_nearestRoad distance _location)) then {_nearestRoad = _x}} forEach _connected;
			_spawnRoad pushBackUnique position _nearestRoad;
		};
	};
	
	private _posL = _location getPos [(_spawnDist / 2), _i];
	
	if (!surfaceIsWater _posL && { _posL inArea _x } count _safePositions == 0) then {
		if ({_x distance2D _posL < 400} count _spawnLand == 0) then {
			_spawnLand pushBack _posL;
		};
	};	
};

// DEBUG: Show Spawn Markers in local
{
	_mrkr = createMarkerLocal [format ["mkr_road_%1", _forEachIndex], _x];
	(format ["mkr_road_%1", _forEachIndex]) setMarkerTypeLocal "mil_dot";
	(format ["mkr_road_%1", _forEachIndex]) setMarkerColorLocal "ColorYellow";
	(format ["mkr_road_%1", _forEachIndex]) setMarkerTextLocal format["R%1",_forEachIndex];
} forEach _spawnRoad;

{
	_mrkr = createMarkerLocal [format ["mkr_land_%1", _forEachIndex], _x];
	(format ["mkr_land_%1", _forEachIndex]) setMarkerTypeLocal "mil_dot";
	(format ["mkr_land_%1", _forEachIndex]) setMarkerColorLocal "ColorOrange";
	(format ["mkr_land_%1", _forEachIndex]) setMarkerTextLocal format["L%1",_forEachIndex];
} forEach _spawnLand;

// Adjust Difficulty
if ((missionNamespace getVariable ["f_param_ZMMDiff",0]) > 0) then { _waveMax = _waveMax * f_param_ZMMDiff };

// MAIN
// Spawn waves.
for [{_wave = 1}, {_wave < _waveMax}, {_wave = _wave + 1}] do {
	// Stop spawns if no-one is nearby.
	if (({ _location distance2D _x < (_spawnDist + 1000) } count (switchableUnits + playableUnits)) isEqualTo 0 && isMultiplayer) exitWith {
		diag_log text format["[QRF] Aborting - No players within %1 meters!", _spawnDist + 1000];
	};
	
	diag_log text format["[QRF] Spawning - Wave %1/%2", _wave, _waveMax];
	
	switch (_wave) do {
		case 1: {
			[_location, _spawnRoad, _side, selectRandom (_Light + _Truck)] call zmm_fnc_spawnUnit;
			[_location, _spawnRoad, _side, selectRandom (_Light + _Truck)] call zmm_fnc_spawnUnit;
			[_location, _spawnLand, _side, 4] call zmm_fnc_spawnUnit;
			
		};
		case 2: {
			[_location, _spawnRoad, _side, selectRandom (_Light + _Truck)] call zmm_fnc_spawnUnit;
			[_location, _spawnRoad, _side, selectRandom (_Air + _Medium)] call zmm_fnc_spawnUnit;
			[_location, _side, selectRandom _Air] call zmm_fnc_spawnPara;
			[_location, _spawnLand, _side, 4] call zmm_fnc_spawnUnit;
		};
		case 3: {
			[_location, _spawnRoad, _side, selectRandom (_Light + _Truck)] call zmm_fnc_spawnUnit;
			[_location, _spawnRoad, _side, selectRandom (_Truck + _Medium)] call zmm_fnc_spawnUnit;
			[_location, _spawnLand, _side, 4] call zmm_fnc_spawnUnit;
		};
		case 4: {
			[_location, _spawnRoad, _side, selectRandom (_Light + _Truck)] call zmm_fnc_spawnUnit;
			[_location, _spawnRoad, _side, selectRandom (_Air + _Medium)] call zmm_fnc_spawnUnit;
			[_location, _side, selectRandom _Air] call zmm_fnc_spawnPara;
			[_location, _spawnLand, _side, 4] call zmm_fnc_spawnUnit;
			[_location, _spawnLand, _side, 4] call zmm_fnc_spawnUnit;
		};
		default {
			[_location, _spawnRoad, _side, selectRandom (_Light + _Truck)] call zmm_fnc_spawnUnit;
			[_location, _spawnRoad, _side, selectRandom (_Heavy + _Medium)] call zmm_fnc_spawnUnit;
			[_location, _spawnRoad, _side, selectRandom (_Heavy + _Medium)] call zmm_fnc_spawnUnit;
			[_location, _spawnLand, _side, 4] call zmm_fnc_spawnUnit;
			[_location, _spawnLand, _side, 4] call zmm_fnc_spawnUnit;
		};
	};

	_tNextWave = time + _delay;	
	waitUntil {sleep 10; time > _tNextWave};
};