//////////////////////////////
//    Dynamic-AI-Creator    //
//    Version 3.1b - 2014   //
//--------------------------//
//    DAC_Config_Creator    //
//--------------------------//
//    Script by Silola      //
//    silola@freenet.de     //
//////////////////////////////

_scr = [] spawn (compile preprocessFileLineNumbers "scripts\DAC\Scripts\DAC_Preprocess.sqf");
waitUntil {scriptDone _scr};

scalar = "any";DAC_Init_Camps = 0;

waitUntil{time > 0.3};

if(isServer) then {if(local player) then {DAC_Code = 1} else {DAC_Code = 0}} else {if(isNull player) then {DAC_Code = 3} else {DAC_Code = 2}};

//26K - Local testing info enable
if((isServer && hasInterface) || (missionNamespace getVariable["f_param_debugMode",0] == 1)) then { DAC_Com_Values = [1,2,0,0]; DAC_Marker = 2; };

//===============|
// DAC_Settings	 |
//===============|=============================================================================================|

	if(isNil "DAC_STRPlayers") then {	
		DAC_STRPlayers = ["UnitIND_CO","UnitBLU_CO","UnitOPF_CO"];
		{ if (!((vehicleVarName _x) in DAC_STRPlayers)) then { DAC_STRPlayers pushBack (vehicleVarName _x); }; } forEach playableUnits + switchableUnits;
	};
	if(isNil "DAC_AI_Count_Level")	then {		DAC_AI_Count_Level  = [[1,2],[2,4],[3,6],[4,8],[6,10]]			};
	if(isNil "DAC_Dyn_Weather") 	then {		DAC_Dyn_Weather		= [0,0,0,[0, 0, 0],0]						};
	if(isNil "DAC_Reduce_Value") 	then {		DAC_Reduce_Value	= [500,600,0.3]								};
	if(isNil "DAC_AI_Spawn") 		then {		DAC_AI_Spawn		= [[10,5,5],[10,5,15],0,120,250,0]			};
	if(isNil "DAC_Delete_Value") 	then {		DAC_Delete_Value	= [[0,150],[0,500],600]		 				};
	if(isNil "DAC_Del_PlayerBody") 	then {		DAC_Del_PlayerBody	= [60,100]									};
	if(isNil "DAC_Com_Values") 		then {		DAC_Com_Values		= [0,0,0,0]									};
	if(isNil "DAC_AI_AddOn") 		then {		DAC_AI_AddOn		= 1											};
	if(isNil "DAC_AI_Level") 		then {		DAC_AI_Level		= 3											};
	if(isNil "DAC_Res_Side") 		then {		DAC_Res_Side		= 0											};
	if(isNil "DAC_Marker") 			then {		DAC_Marker			= 0											};
	if(isNil "DAC_WP_Speed") 		then {		DAC_WP_Speed		= 0.01										};
	if(isNil "DAC_Join_Action")		then {		DAC_Join_Action		= false										};
	if(isNil "DAC_Fast_Init") 		then {		DAC_Fast_Init		= false										};
	if(isNil "DAC_Player_Marker")	then {		DAC_Player_Marker	= false										};
	if(isNil "DAC_Direct_Start")	then {		DAC_Direct_Start	= false										};
	if(isNil "DAC_Activate_Sound")	then {		DAC_Activate_Sound	= false										};
	if(isNil "DAC_Auto_UnitCount")	then {		DAC_Auto_UnitCount	= [40,5]									};
	if(isNil "DAC_Player_Support")	then {		DAC_Player_Support	= [10,[4,2000,3,1000]]						};
	if(isNil "DAC_SaveDistance")	then {		DAC_SaveDistance	= [500,["DAC_Save_Pos"]]					};
	if(isNil "DAC_Radio_Max")		then {		DAC_Radio_Max		= DAC_AI_Level								};
		
	DAC_BadBuildings 	= 	[];
	DAC_GunNotAllowed	= 	[];
	DAC_VehNotAllowed	= 	[];
	DAC_Locked_Veh		=	[];
	DAC_SP_Soldiers     =   ["B_soldier_AR_F","B_G_soldier_AR_F","O_soldier_AR_F","O_soldierU_AR_F","O_G_soldier_AR_F","I_soldier_AR_F","I_G_soldier_AR_F","rhsusf_army_ocp_autorifleman","rhsusf_army_ucp_autorifleman","rhsusf_usmc_marpat_wd_autorifleman_m249",
							"rhsusf_usmc_marpat_d_autorifleman_m249","ACR_Vojak03","ACR_DES_Vojak03","B_G_Soldier_AR_F","TEC_O_soldier_AR_F","TEC_O_Soldier_Semiarid_AR_F","TEC_O_Soldier_Urban_AR_F","TEC_O_Soldier_Woodland_AR_F","rhs_msv_machinegunner",
							"rhs_msv_emr_machinegunner","rhs_vdv_machinegunner","rhs_vdv_flora_machinegunner","rhs_vdv_mflora_machinegunner","O_G_Soldier_AR_F","I_soldier_AR_F","AFR_PARAMIL_AR_RPK47","EURO_PARAMIL_AR_RPK47","EAST_PARAMIL_AR_RPK47"];
	DAC_Data_Array 		= 	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,[]];
	DAC_Marker_Val		= 	[];
	DAC_Zones			=	[];

	//=============================================================================================================|
	
	_scr = [] spawn (compile preprocessFileLineNumbers "scripts\DAC\Scripts\DAC_Start_Creator.sqf");
	waitUntil {scriptDone _scr};
	sleep 0.1;
	waitUntil {(DAC_Basic_Value > 0)};
	
if (DAC_Code < 2) then {
	//===========================================|
	// StartScriptOnServer                       |
	//===========================================|
	//player sidechat "ServerStart"
	//[] execVM "myServerScript.sqf";
	//onMapSingleClick "_fun = [_pos,_shift]execVM ""Action.sqf""";
} else {
	if(DAC_Code == 3) then {
		//===========================================|
		// StartScriptOnJipClient                    |
		//===========================================|
		//player sidechat "JipClientStart"
		//[] execVM "myJipClientScript.sqf";
	} else {
		//===========================================|
		// StartScriptOnClient                       |
		//===========================================|
		//player sidechat "ClientStart"
		//[] execVM "myClientScript.sqf";
		//onMapSingleClick "_fun = [_pos,_shift]execVM ""Action.sqf""";
	};
};