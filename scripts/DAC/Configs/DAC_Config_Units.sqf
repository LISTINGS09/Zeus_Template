//////////////////////////////
//    Dynamic-AI-Creator    //
//    Version 2.1 - 2009    //
//--------------------------//
//    DAC_Config_Units      //
//--------------------------//
//    Script by Silola      //
//    silola@freenet.de     //
//////////////////////////////

private ["_TypNumber","_TempArray","_Unit_Pool_S","_Unit_Pool_V","_Unit_Pool_T","_Unit_Pool_A"];
_TypNumber = _this select 0;_TempArray = [];

switch (_TypNumber) do
{

// REDFOR (A3)
  case 0:
  {
    _Unit_Pool_S = ["O_crew_F","O_Helipilot_F","O_Soldier_SL_F","O_soldier_AR_F","O_soldier_AR_F","O_soldier_exp_F","O_soldier_GL_F","O_soldier_GL_F","O_soldier_M_F","O_medic_F","O_soldier_AA_F","O_soldier_repair_F","O_Soldier_F","O_Soldier_F","O_soldier_LAT_F","O_soldier_LAT_F","O_soldier_lite_F","O_soldier_TL_F","O_soldier_TL_F"];
    _Unit_Pool_V = ["O_MRAP_02_F","O_MRAP_02_gmg_F","O_MRAP_02_hmg_F","O_Truck_02_covered_F","O_Truck_02_transport_F"];
    _Unit_Pool_T = ["O_MBT_02_arty_F","O_APC_Tracked_02_cannon_F","O_APC_Wheeled_02_rcws_F","O_MBT_02_cannon_F","O_APC_Tracked_02_AA_F"];
	_Unit_Pool_A = ["O_Heli_Attack_02_F","O_Heli_Light_02_F","O_Heli_Light_02_armed_F"];
  };

// BLUFOR (A3)
  case 1:
  {
    _Unit_Pool_S = ["B_crew_F","B_Helipilot_F","B_Soldier_SL_F","B_soldier_AR_F","B_soldier_AR_F","B_soldier_exp_F","B_soldier_GL_F","B_soldier_GL_F","B_soldier_AA_F","B_soldier_M_F","B_medic_F","B_soldier_repair_F","B_Soldier_F","B_Soldier_F","B_soldier_LAT_F","B_soldier_LAT_F","B_soldier_lite_F","B_soldier_TL_F","B_soldier_TL_F"];
    _Unit_Pool_V = ["B_MRAP_01_F","B_MRAP_01_gmg_F","B_MRAP_01_hmg_F","B_Truck_01_covered_F","B_Truck_01_transport_F"];
    _Unit_Pool_T = ["B_APC_Wheeled_01_cannon_F","B_APC_Tracked_01_AA_F","B_APC_Tracked_01_rcws_F","B_MBT_01_cannon_F","B_MBT_01_arty_F","B_MBT_01_mlrs_F"];
    _Unit_Pool_A = ["B_Heli_Light_01_armed_F","B_Heli_Transport_01_camo_F","B_Heli_Light_01_F"];
  };

// Independent (A3)
  case 2:
  {
    _Unit_Pool_S = ["I_crew_F","I_helipilot_F","I_officer_F","I_Soldier_AT_F","I_Soldier_AA_F","I_Soldier_M_F","I_Soldier_GL_F","I_Soldier_exp_F","I_engineer_F","I_medic_F","I_Soldier_AR_F","I_Soldier_A_F"];
    _Unit_Pool_V = ["I_Truck_02_covered_F","I_Truck_02_transport_F","I_MRAP_03_hmg_F","I_MRAP_03_gmg_F","I_MRAP_03_F"];
    _Unit_Pool_T = ["I_MBT_03_cannon_F","I_APC_tracked_03_cannon_F","I_APC_Wheeled_03_cannon_F"];
    _Unit_Pool_A = ["I_Heli_light_03_F"];
  };

// Civilians (A3)
  case 3:
  {
    _Unit_Pool_S = ["C_man_1","C_man_1","C_man_1","C_man_polo_1_F","C_man_polo_2_F","C_man_polo_3_F","C_man_polo_4_F","C_man_polo_5_F","C_man_polo_6_F","C_man_1_1_F","C_man_1_2_F","C_man_1_3_F"];
    _Unit_Pool_V = ["C_Van_01_box_F","C_Van_01_transport_F","C_Offroad_01_F","C_Hatchback_01_sport_F","C_Hatchback_01_F"];
    _Unit_Pool_T = ["C_Van_01_box_F","C_Van_01_transport_F","C_Offroad_01_F","C_Hatchback_01_sport_F","C_Hatchback_01_F"];
    _Unit_Pool_A = [];
  };

// CSAT PACIFIC (APEX)
  case 4:
  {
    _Unit_Pool_S = ["O_T_Soldier_SL_F","O_T_Soldier_TL_F","O_T_Soldier_A_F","O_T_Soldier_AAR_F","O_T_Soldier_AAA_F","O_T_Soldier_AAT_F","O_T_Soldier_AR_F","O_T_Medic_F","O_T_Engineer_F","O_T_Soldier_Exp_F","O_T_Soldier_GL_F","O_T_soldier_M_F","O_T_Soldier_AA_F","O_T_Soldier_AT_F","O_T_Soldier_Repair_F","O_T_Soldier_F","O_T_Soldier_LAT_F"];
    _Unit_Pool_V = ["O_T_MRAP_02_ghex_F","O_T_MRAP_02_gmg_ghex_F","O_T_MRAP_02_hmg_ghex_F","O_T_LSV_02_armed_F","O_T_LSV_02_unarmed_F","O_T_Truck_03_transport_ghex_F","O_T_Truck_03_covered_ghex_F"];
    _Unit_Pool_T = ["O_T_MBT_02_cannon_ghex_F","O_T_MBT_02_arty_ghex_F","O_T_APC_Tracked_02_cannon_ghex_F","O_T_APC_Wheeled_02_rcws_ghex_F","O_T_APC_Tracked_02_AA_ghex_F"];
	_Unit_Pool_A = ["O_T_VTOL_02_infantry_F","O_Heli_Attack_02_black_F","O_Heli_Light_02_v2_F"];
  };

// CSAT VIPER (APEX)
  case 5:
  {
    _Unit_Pool_S = ["O_V_Soldier_TL_ghex_F","O_V_Soldier_Exp_ghex_F","O_V_Soldier_JTAC_ghex_F","O_V_Soldier_M_ghex_F","O_V_Soldier_ghex_F","O_V_Soldier_Medic_ghex_F","O_V_Soldier_LAT_ghex_F"];
    _Unit_Pool_V = ["O_T_MRAP_02_ghex_F","O_T_MRAP_02_gmg_ghex_F","O_T_MRAP_02_hmg_ghex_F","O_T_LSV_02_armed_F","O_T_LSV_02_unarmed_F","O_T_Truck_03_transport_ghex_F","O_T_Truck_03_covered_ghex_F"];
    _Unit_Pool_T = ["O_T_MBT_02_cannon_ghex_F","O_T_MBT_02_arty_ghex_F","O_T_APC_Tracked_02_cannon_ghex_F","O_T_APC_Wheeled_02_rcws_ghex_F","O_T_APC_Tracked_02_AA_ghex_F"];
	_Unit_Pool_A = ["O_T_VTOL_02_infantry_F","O_Heli_Attack_02_black_F","O_Heli_Light_02_v2_F"];
  };

// NATO PACIFIC (APEX)
  case 6:
  {
    _Unit_Pool_S = ["B_T_Soldier_SL_F","B_T_Soldier_TL_F","B_T_Soldier_A_F","B_T_Soldier_AAR_F","B_T_Soldier_AAA_F","B_T_Soldier_AAT_F","B_T_Soldier_AR_F","B_T_Medic_F","B_T_Engineer_F","B_T_Soldier_Exp_F","B_T_Soldier_GL_F","B_T_soldier_M_F","B_T_Soldier_AA_F","B_T_Soldier_AT_F","B_T_Soldier_Repair_F","B_T_Soldier_F","B_T_Soldier_LAT_F"];
    _Unit_Pool_V = ["B_T_Truck_01_transport_F","B_T_Truck_01_covered_F","B_T_MRAP_01_F","B_T_MRAP_01_gmg_F","B_T_MRAP_01_hmg_F","B_T_LSV_01_armed_F","B_T_LSV_01_unarmed_F"];
    _Unit_Pool_T = ["B_T_APC_Tracked_01_AA_F","B_T_APC_Wheeled_01_cannon_F","B_T_APC_Tracked_01_CRV_F","B_T_APC_Tracked_01_rcws_F","B_T_MBT_01_arty_F","B_T_MBT_01_cannon_F","B_T_MBT_01_TUSK_F"];
	_Unit_Pool_A = ["B_T_VTOL_01_armed_F","B_Heli_Light_01_armed_F","B_Heli_Attack_01_F","B_Heli_Transport_03_F","B_Heli_Transport_01_F"];
  };

// NATO CTRG (APEX)
  case 7:
  {
    _Unit_Pool_S = ["B_CTRG_Soldier_TL_tna_F","B_CTRG_Soldier_AR_tna_F","B_CTRG_Soldier_Exp_tna_F","B_CTRG_Soldier_JTAC_tna_F","B_CTRG_Soldier_M_tna_F","B_CTRG_Soldier_Medic_tna_F","B_CTRG_Soldier_tna_F","B_CTRG_Soldier_LAT_tna_F"];
    _Unit_Pool_V = ["B_T_Truck_01_transport_F","B_T_Truck_01_covered_F","B_T_MRAP_01_F","B_T_MRAP_01_gmg_F","B_T_MRAP_01_hmg_F","B_T_LSV_01_armed_F","B_T_LSV_01_unarmed_F"];
    _Unit_Pool_T = ["B_T_APC_Tracked_01_AA_F","B_T_APC_Wheeled_01_cannon_F","B_T_APC_Tracked_01_CRV_F","B_T_APC_Tracked_01_rcws_F","B_T_MBT_01_arty_F","B_T_MBT_01_cannon_F","B_T_MBT_01_TUSK_F"];
    _Unit_Pool_A = ["B_T_VTOL_01_armed_F","B_Heli_Light_01_armed_F","B_Heli_Attack_01_F","B_Heli_Transport_03_F","B_CTRG_Heli_Transport_01_sand_F","B_CTRG_Heli_Transport_01_tropic_F"];
  };

// GUER BANDITOS (APEX)
  case 8:
  {
    _Unit_Pool_S = ["I_C_Soldier_Bandit_4_F","I_C_Soldier_Bandit_1_F","I_C_Soldier_Bandit_2_F","I_C_Soldier_Bandit_3_F","I_C_Soldier_Bandit_5_F","I_C_Soldier_Bandit_6_F","I_C_Soldier_Bandit_7_F","I_C_Soldier_Bandit_8_F"];
    _Unit_Pool_V = ["I_C_Offroad_02_unarmed_F","I_G_Offroad_01_armed_F","I_C_Van_01_transport_F"];
    _Unit_Pool_T = ["I_G_Offroad_01_armed_F"];
    _Unit_Pool_A = ["B_Heli_Light_01_armed_F"];
  };  

// GUER PARA (APEX)
  case 9:
  {
    _Unit_Pool_S = ["I_C_Soldier_Para_2_F","I_C_Soldier_Para_1_F","I_C_Soldier_Para_3_F","I_C_Soldier_Para_4_F","I_C_Soldier_Para_5_F","I_C_Soldier_Para_6_F","I_C_Soldier_Para_7_F","I_C_Soldier_Para_8_F"];
    _Unit_Pool_V = ["I_C_Offroad_02_unarmed_F","I_G_Offroad_01_armed_F","I_C_Van_01_transport_F"];
    _Unit_Pool_T = ["I_G_Offroad_01_armed_F"];
    _Unit_Pool_A = ["B_Heli_Light_01_armed_F"];
  };

// OPFOR Rebels Red (OPF_G_F)
  case 10:
  {
    _Unit_Pool_S = ["O_G_Soldier_F","O_G_Soldier_F","O_G_Soldier_SL_F","O_G_Soldier_AR_F","O_G_Soldier_LAT_F","O_G_Soldier_A_F","O_G_medic_F","O_G_Soldier_F","O_G_Soldier_GL_F","O_G_Soldier_M_F","O_G_engineer_F"];
    _Unit_Pool_V = ["O_G_Offroad_01_F","O_G_Offroad_01_armed_F","O_G_Van_01_transport_F"];
    _Unit_Pool_T = ["O_G_Offroad_01_armed_F"];
    _Unit_Pool_A = ["B_Heli_Light_01_armed_F"];
  };

// BLUFOR Rebels Blue (BLU_G_F)
  case 11:
  {
    _Unit_Pool_S = ["B_G_Soldier_F","B_G_Soldier_F","B_G_Soldier_SL_F","B_G_Soldier_AR_F","B_G_Soldier_LAT_F","B_G_Soldier_A_F","B_G_medic_F","B_G_Soldier_F","B_G_Soldier_GL_F","B_G_Soldier_M_F","B_G_engineer_F"];
    _Unit_Pool_V = ["B_G_Offroad_01_F","B_G_Offroad_01_armed_F","B_G_Van_01_transport_F"];
    _Unit_Pool_T = ["B_G_Offroad_01_armed_F"];
    _Unit_Pool_A = ["B_Heli_Light_01_armed_F"];
  };

// INDFOR Rebels Green (IND_G_F)
  case 12:
  {
    _Unit_Pool_S = ["I_G_Soldier_F","I_G_Soldier_F","I_G_Soldier_SL_F","I_G_Soldier_AR_F","I_G_Soldier_LAT_F","I_G_Soldier_A_F","I_G_medic_F","I_G_Soldier_F","I_G_Soldier_GL_F","I_G_Soldier_M_F","I_G_engineer_F"];
    _Unit_Pool_V = ["I_G_Offroad_01_F","I_G_Offroad_01_armed_F","I_G_Van_01_transport_F"];
    _Unit_Pool_T = ["I_G_Offroad_01_armed_F"];
    _Unit_Pool_A = ["B_Heli_Light_01_armed_F"];
  }; 
// BLUFOR NATO Woodland (BLU_E_F)
  case 13:
  {
    _Unit_Pool_S = ["B_W_Soldier_TL_F","B_W_Soldier_LAT2_F","B_W_Soldier_AT_F","B_W_Soldier_AA_F","B_W_soldier_M_F","B_W_Soldier_GL_F","B_W_Engineer_F","B_W_Soldier_AR_F","B_W_Medic_F"];
    _Unit_Pool_V = ["B_T_LSV_01_armed_F","B_T_LSV_01_AT_F","B_T_Truck_01_covered_F","B_T_MRAP_01_hmg_F","B_T_MRAP_01_gmg_F"];
    _Unit_Pool_T = ["B_T_APC_Wheeled_01_cannon_F","B_T_APC_Tracked_01_rcws_F","B_T_APC_Tracked_01_AA_F"];
    _Unit_Pool_A = ["B_T_VTOL_01_armed_F","B_Heli_Light_01_armed_F","B_Heli_Attack_01_F","B_Heli_Transport_03_F","B_Heli_Transport_01_F"];
  };
// INDFOR LDF (IND_E_F)
  case 14:
  {
    _Unit_Pool_S = ["I_E_Soldier_TL_F","I_E_Soldier_LAT2_F","I_E_Soldier_AR_F","I_E_Soldier_F","I_E_soldier_M_F","I_E_Soldier_GL_F","I_E_Engineer_F","I_E_Soldier_AT_F","I_E_Soldier_AA_F"];
    _Unit_Pool_V = ["I_E_UGV_01_rcws_F","I_E_Truck_02_F"];
    _Unit_Pool_T = ["I_E_APC_tracked_03_cannon_F"];
    _Unit_Pool_A = ["I_E_Heli_light_03_dynamicLoadout_F"];
  };
  
  
  
  
  
	// OPFOR RHS Russian Motor Rifle Troops (MSV - EMR) rhs_faction_msv
	case 17:
	{
		_Unit_Pool_S = [ "rhs_msv_emr_sergeant","rhs_msv_emr_aa","rhs_msv_emr_at","rhs_msv_emr_arifleman","rhs_msv_emr_efreitor","rhs_msv_emr_engineer","rhs_msv_emr_grenadier_rpg","rhs_msv_emr_strelok_rpg_assist","rhs_msv_emr_junior_sergeant","rhs_msv_emr_machinegunner","rhs_msv_emr_machinegunner_assistant","rhs_msv_emr_marksman","rhs_msv_emr_medic","rhs_msv_emr_rifleman","rhs_msv_emr_grenadier","rhs_msv_emr_LAT","rhs_msv_emr_RShG2" ];
		_Unit_Pool_V = [ "rhs_btr80_msv","rhs_tigr_msv","rhs_tigr_sts_msv","RHS_UAZ_MSV_01","rhs_uaz_open_MSV_01","RHS_Ural_MSV_01","RHS_Ural_Open_MSV_01","RHS_Ural_Zu23_MSV_01" ];
		_Unit_Pool_T = [ "rhs_btr80a_msv","rhs_bmp3_msv","rhs_zsu234_aa","rhs_bmp2k_tv","rhs_bmp1k_tv","rhs_t72bb_tv","rhs_t80b","rhs_bmd1k","rhs_bmd4m_vdv","rhs_bmd2k" ];
		_Unit_Pool_A = [ "rhs_mi28n_vvsc","RHS_Mi8AMTSh_UPK23_vvsc","RHS_Mi24V_vvsc" ];
	};
	
	// OPFOR RHS Russian Motor Rifle Troops (MSV - FLORA) rhs_faction_msv
	case 18:
	{
		_Unit_Pool_S = [ "rhs_msv_sergeant","rhs_msv_aa","rhs_msv_at","rhs_msv_arifleman","rhs_msv_efreitor","rhs_msv_engineer","rhs_msv_grenadier_rpg","rhs_msv_strelok_rpg_assist","rhs_msv_junior_sergeant","rhs_msv_machinegunner","rhs_msv_machinegunner_assistant","rhs_msv_marksman","rhs_msv_medic","rhs_msv_rifleman","rhs_msv_grenadier","rhs_msv_LAT","rhs_msv_RShG2" ];
		_Unit_Pool_V = [ "rhs_btr80_msv","rhs_tigr_msv","rhs_tigr_sts_msv","RHS_UAZ_MSV_01","rhs_uaz_open_MSV_01","RHS_Ural_MSV_01","RHS_Ural_Open_MSV_01","RHS_Ural_Zu23_MSV_01" ];
		_Unit_Pool_T = [ "rhs_btr80a_msv","rhs_bmp3_msv","rhs_zsu234_aa","rhs_bmp2k_tv","rhs_bmp1k_tv","rhs_t72bb_tv","rhs_t80b","rhs_bmd1k","rhs_bmd4m_vdv","rhs_bmd2k" ];
		_Unit_Pool_A = [ "rhs_mi28n_vvsc","RHS_Mi8AMTSh_UPK23_vvsc","RHS_Mi24V_vvsc" ];
	};
	
	// OPFOR RHS - Russians VDV (EMR)
	case 19:
	{
		_Unit_Pool_S = [ "rhs_vdv_sergeant", "rhs_vdv_RShG2", "rhs_vdv_LAT", "rhs_vdv_rifleman", "rhs_vdv_medic", "rhs_vdv_marksman", "rhs_vdv_machinegunner", "rhs_vdv_machinegunner_assistant", "rhs_vdv_at", "rhs_vdv_strelok_rpg_assist", "rhs_vdv_grenadier", "rhs_vdv_engineer", "rhs_vdv_aa" ];
		_Unit_Pool_V = [ "rhs_btr80_msv","rhs_tigr_msv","rhs_tigr_sts_msv","RHS_UAZ_MSV_01","rhs_uaz_open_MSV_01","RHS_Ural_MSV_01","RHS_Ural_Open_MSV_01","RHS_Ural_Zu23_MSV_01" ];
		_Unit_Pool_T = [ "rhs_btr80a_msv","rhs_bmp3_msv","rhs_zsu234_aa","rhs_bmp2k_tv","rhs_bmp1k_tv","rhs_t72bb_tv","rhs_t80b","rhs_bmd1k","rhs_bmd4m_vdv","rhs_bmd2k" ];
		_Unit_Pool_A = [ "rhs_mi28n_vvsc","RHS_Mi8AMTSh_UPK23_vvsc","RHS_Mi24V_vvsc" ];
	};
	
	// OPFOR RHS - Russians VDV (EMR-DESERT)
	case 20:
	{
		_Unit_Pool_S = [ "rhs_vdv_des_sergeant", "rhs_vdv_des_RShG2", "rhs_vdv_des_LAT", "rhs_vdv_des_rifleman", "rhs_vdv_des_medic", "rhs_vdv_des_marksman", "rhs_vdv_des_machinegunner", "rhs_vdv_des_machinegunner_assistant", "rhs_vdv_des_at", "rhs_vdv_des_strelok_rpg_assist", "rhs_vdv_des_grenadier", "rhs_vdv_des_engineer", "rhs_vdv_des_aa" ];
		_Unit_Pool_V = [ "rhs_btr80_msv","rhs_tigr_3camo_vdv","rhs_tigr_sts_3camo_vdv","RHS_UAZ_MSV_01","rhs_uaz_open_MSV_01","RHS_Ural_MSV_01","RHS_Ural_Open_MSV_01","RHS_Ural_Zu23_MSV_01" ];
		_Unit_Pool_T = [ "rhs_btr80a_msv","rhs_bmp3_msv","rhs_zsu234_aa","rhs_bmp2k_tv","rhs_bmp1k_tv","rhs_t72bb_tv","rhs_t80b","rhs_bmd1k","rhs_bmd4m_vdv","rhs_bmd2k" ];
		_Unit_Pool_A = [ "rhs_mi28n_vvsc","RHS_Mi8AMTSh_UPK23_vvsc","RHS_Mi24V_vvsc" ];
	};

	
	// OPFOR RHS - Russians VDV (FLORA)
	case 21:
	{
		_Unit_Pool_S = [ "rhs_vdv_flora_sergeant", "rhs_vdv_flora_RShG2", "rhs_vdv_flora_LAT", "rhs_vdv_flora_rifleman", "rhs_vdv_flora_medic", "rhs_vdv_flora_marksman", "rhs_vdv_flora_machinegunner", "rhs_vdv_flora_machinegunner_assistant", "rhs_vdv_flora_at", "rhs_vdv_flora_strelok_rpg_assist", "rhs_vdv_flora_grenadier", "rhs_vdv_flora_engineer", "rhs_vdv_flora_aa" ];
		_Unit_Pool_V = [ "rhs_btr80_msv","rhs_tigr_msv","rhs_tigr_sts_msv","RHS_UAZ_MSV_01","rhs_uaz_open_MSV_01","RHS_Ural_MSV_01","RHS_Ural_Open_MSV_01","RHS_Ural_Zu23_MSV_01" ];
		_Unit_Pool_T = [ "rhs_btr80a_msv","rhs_bmp3_msv","rhs_zsu234_aa","rhs_bmp2k_tv","rhs_bmp1k_tv","rhs_t72bb_tv","rhs_t80b","rhs_bmd1k","rhs_bmd4m_vdv","rhs_bmd2k" ];
		_Unit_Pool_A = [ "rhs_mi28n_vvsc","RHS_Mi8AMTSh_UPK23_vvsc","RHS_Mi24V_vvsc" ];
	};
	
	// OPFOR RHS - Russians VDV (MFLORA)
	case 22:
	{
		_Unit_Pool_S = [ "rhs_vdv_mflora_sergeant", "rhs_vdv_mflora_RShG2", "rhs_vdv_mflora_LAT", "rhs_vdv_mflora_rifleman", "rhs_vdv_mflora_medic", "rhs_vdv_mflora_marksman", "rhs_vdv_mflora_machinegunner", "rhs_vdv_mflora_machinegunner_assistant", "rhs_vdv_mflora_at", "rhs_vdv_mflora_strelok_rpg_assist", "rhs_vdv_mflora_grenadier", "rhs_vdv_mflora_engineer", "rhs_vdv_mflora_aa" ];
		_Unit_Pool_V = [ "rhs_btr80_msv","rhs_tigr_3camo_vdv","rhs_tigr_sts_3camo_vdv","RHS_UAZ_MSV_01","rhs_uaz_open_MSV_01","RHS_Ural_MSV_01","RHS_Ural_Open_MSV_01","RHS_Ural_Zu23_MSV_01" ];
		_Unit_Pool_T = [ "rhs_btr80a_msv","rhs_bmp3_msv","rhs_zsu234_aa","rhs_bmp2k_tv","rhs_bmp1k_tv","rhs_t72bb_tv","rhs_t80b","rhs_bmd1k","rhs_bmd4m_vdv","rhs_bmd2k" ];
		_Unit_Pool_A = [ "rhs_mi28n_vvsc","RHS_Mi8AMTSh_UPK23_vvsc","RHS_Mi24V_vvsc" ];
	};
	
	// OPFOR RHS - ChDkz
	case 23:
	{
		_Unit_Pool_S = [ "rhsgref_ins_grenadier","rhsgref_ins_specialist_aa","rhsgref_ins_grenadier_rpg","rhsgref_ins_machinegunner","rhsgref_ins_medic","rhsgref_ins_rifleman","rhsgref_ins_rifleman_akm","rhsgref_ins_rifleman_aksu","rhsgref_ins_rifleman_RPG26","rhsgref_ins_saboteur","rhsgref_ins_engineer","rhsgref_ins_sniper","rhsgref_ins_spotter" ];
		_Unit_Pool_V = [ "rhsgref_ins_btr70","rhsgref_ins_uaz","rhsgref_ins_uaz_ags","rhsgref_ins_uaz_dshkm","rhsgref_ins_uaz_spg9","rhsgref_BRDM2_ins","rhsgref_ins_ural","rhsgref_ins_ural_Zu23","rhsgref_ins_ural_open" ]; 
		_Unit_Pool_T = [ "rhsgref_ins_zsu234","rhsgref_ins_btr70","rhsgref_ins_bmp1k","rhsgref_ins_bmd1","rhsgref_ins_bmd2","rhsgref_ins_bmp2k","rhsgref_ins_t72bb" ];
		_Unit_Pool_A = [ "rhsgref_ins_Mi8amt" ];
	};

	
	// BLUFOR RHS CDF
	case 24:
	{
		_Unit_Pool_S = [ "rhsgref_cdf_b_reg_squadleader","rhsgref_cdf_b_reg_specialist_aa","rhsgref_cdf_b_reg_grenadier_rpg","rhsgref_cdf_b_reg_engineer","rhsgref_cdf_b_reg_machinegunner","rhsgref_cdf_b_reg_marksman","rhsgref_cdf_b_reg_medic","rhsgref_cdf_b_reg_rifleman","rhsgref_cdf_b_reg_grenadier","rhsgref_cdf_b_reg_rifleman_lite","rhsgref_cdf_b_reg_rifleman_m70" ]; 
		_Unit_Pool_V = [ "rhsgref_cdf_b_btr70","rhsgref_cdf_b_reg_uaz","rhsgref_cdf_b_reg_uaz_ags","rhsgref_cdf_b_reg_uaz_dshkm","rhsgref_cdf_b_reg_uaz_spg9","rhsgref_BRDM2_b","rhsgref_cdf_b_ural","rhsgref_cdf_b_ural_open","rhsgref_cdf_b_ural_Zu23" ]; 
		_Unit_Pool_T = [ "rhsgref_cdf_b_zsu234","rhsgref_cdf_b_btr70","rhsgref_cdf_b_bmd1k","rhsgref_cdf_b_bmd2k","rhsgref_cdf_b_bmp1k","rhsgref_cdf_b_bmp2k","rhsgref_cdf_b_t80b_tv","rhsgref_cdf_b_t72ba_tv" ]; 
		_Unit_Pool_A = [ "rhsgref_b_mi24g_UPK23","rhsgref_cdf_b_Mi35_UPK","rhsgref_cdf_b_reg_Mi17Sh_UPK" ]; 
	};
	
	// BLUFOR RHS Americans - US Army (Desert)
	case 25:
	{
		_Unit_Pool_S = [ "rhsusf_army_ocp_squadleader","rhsusf_army_ocp_teamleader", "rhsusf_army_ocp_rifleman", "rhsusf_army_ocp_riflemanl", "rhsusf_army_ocp_riflemanat", "rhsusf_army_ocp_grenadier", "rhsusf_army_ocp_marksman", "rhsusf_army_ocp_medic", "rhsusf_army_ocp_machinegunner", "rhsusf_army_ocp_machinegunnera", "rhsusf_army_ocp_engineer", "rhsusf_army_ocp_autorifleman", "rhsusf_army_ocp_aa", "rhsusf_army_ocp_javelin" ]; 
		_Unit_Pool_V = [ "rhsusf_m1025_d_m2","rhsusf_m1025_d_Mk19","rhsusf_m1025_d","rhsusf_m998_d_4dr_fulltop","rhsusf_m113d_usarmy","rhsusf_M1083A1P2_d_fmtv_usarmy","rhsusf_M1083A1P2_d_open_fmtv_usarmy" ]; 
		_Unit_Pool_T = [ "rhsusf_m1a1aimd_usarmy","rhsusf_m1a1aim_tuski_d","RHS_M2A2","RHS_M6","RHS_M2A2_BUSKI" ];
		_Unit_Pool_A = [ "RHS_AH64D","RHS_UH60M_d","RHS_MELB_AH6M_L","RHS_MELB_AH6M_M" ]; 
	};
	
	// BLUFOR RHS Americans - US Army (Woodland) 
	case 26:
	{
		_Unit_Pool_S = [ "rhsusf_army_ucp_squadleader","rhsusf_army_ucp_teamleader", "rhsusf_army_ucp_rifleman", "rhsusf_army_ucp_riflemanl", "rhsusf_army_ucp_riflemanat", "rhsusf_army_ucp_grenadier", "rhsusf_army_ucp_marksman", "rhsusf_army_ucp_medic", "rhsusf_army_ucp_machinegunner", "rhsusf_army_ucp_machinegunnera", "rhsusf_army_ucp_engineer", "rhsusf_army_ucp_autorifleman", "rhsusf_army_ucp_aa", "rhsusf_army_ucp_javelin" ]; 
		_Unit_Pool_V = [ "rhsusf_m113_usarmy","rhsusf_M1083A1P2_wd_fmtv_usarmy","rhsusf_M1083A1P2_wd_open_fmtv_usarmy","rhsusf_m1025_w_m2","rhsusf_m1025_w_mk19","rhsusf_m998_w_4dr_fulltop","rhsusf_m1025_w" ]; 
		_Unit_Pool_T = [ "rhsusf_m1a1hc_wd","rhsusf_m1a1fep_wd","RHS_M6_wd","RHS_M2A2_wd","RHS_M2A2_BUSKI_WD" ]; 
		_Unit_Pool_A = [ "RHS_AH64D_wd","RHS_UH60M","RHS_MELB_AH6M_L","RHS_MELB_AH6M_M" ]; 
	};


	// BLUFOR RHS - USMC (Desert)
	case 27:
	{
		_Unit_Pool_S = [ "rhsusf_usmc_marpat_d_teamleader", "rhsusf_usmc_marpat_d_riflemanat", "rhsusf_usmc_marpat_d_rifleman", "rhsusf_usmc_marpat_d_marksman", "rhsusf_usmc_marpat_d_machinegunner_ass", "rhsusf_usmc_marpat_d_machinegunner", "rhsusf_usmc_marpat_d_autorifleman_m249", "rhsusf_usmc_marpat_d_autorifleman_m249_ass", "rhsusf_usmc_marpat_d_stinger" ];
		_Unit_Pool_V = [ "rhsusf_m1025_d_m2","rhsusf_m1025_d_Mk19","rhsusf_m1025_d","rhsusf_m998_d_4dr_fulltop","rhsusf_m113d_usarmy","rhsusf_M1083A1P2_d_fmtv_usarmy","rhsusf_M1083A1P2_d_open_fmtv_usarmy" ]; 
		_Unit_Pool_T = [ "rhsusf_m1a1aimd_usarmy","rhsusf_m1a1aim_tuski_d","RHS_M2A2","RHS_M6","RHS_M2A2_BUSKI" ];
		_Unit_Pool_A = [ "RHS_UH1Y_d_GS","RHS_AH1Z","RHS_MELB_AH6M_L","RHS_MELB_AH6M_M" ]; 
	};
	
	// BLUFOR RHS - USMC (Woodland)
	case 28:
	{
		_Unit_Pool_S = [ "rhsusf_usmc_marpat_wd_teamleader", "rhsusf_usmc_marpat_wd_riflemanat", "rhsusf_usmc_marpat_wd_rifleman", "rhsusf_usmc_marpat_wd_marksman", "rhsusf_usmc_marpat_wd_machinegunner_ass", "rhsusf_usmc_marpat_wd_machinegunner", "rhsusf_usmc_marpat_wd_autorifleman_m249", "rhsusf_usmc_marpat_wd_autorifleman_m249_ass", "rhsusf_usmc_marpat_wd_stinger" ];
		_Unit_Pool_V = [ "rhsusf_m113_usarmy","rhsusf_M1083A1P2_wd_fmtv_usarmy","rhsusf_M1083A1P2_wd_open_fmtv_usarmy","rhsusf_m1025_w_m2","rhsusf_m1025_w_mk19","rhsusf_m998_w_4dr_fulltop","rhsusf_m1025_w" ]; 
		_Unit_Pool_T = [ "rhsusf_m1a1hc_wd","rhsusf_m1a1fep_wd","RHS_M6_wd","RHS_M2A2_wd","RHS_M2A2_BUSKI_WD" ];
		_Unit_Pool_A = [ "RHS_AH1Z_wd","RHS_UH1Y_GS","RHS_MELB_AH6M_L","RHS_MELB_AH6M_M" ]; 
	};
	
	// INDEP RHS - Nationalist Troops
	case 29:
	{
		_Unit_Pool_S = [ "rhsgref_nat_grenadier","rhsgref_nat_specialist_aa","rhsgref_nat_grenadier_rpg","rhsgref_nat_hunter","rhsgref_nat_machinegunner","rhsgref_nat_medic","rhsgref_nat_rifleman_akms","rhsgref_nat_rifleman","rhsgref_nat_rifleman_m92","rhsgref_nat_saboteur" ];
		_Unit_Pool_V = [ "rhsgref_nat_btr70","rhsgref_nat_uaz_ags","rhsgref_nat_uaz_ags","rhsgref_nat_uaz_spg9","rhsgref_nat_ural","rhsgref_nat_ural_Zu23" ]; 
		_Unit_Pool_T = [ "rhsgref_ins_g_bmd1","rhsgref_ins_g_bmd2","rhsgref_ins_g_bmp1","rhsgref_ins_g_bmp2e","rhsgref_ins_g_t72bb" ];
		_Unit_Pool_A = [ "rhsgref_ins_Mi8amt" ]; 
	};

	// INDEP RHS - ChDkz Troops
	case 30:
	{
		_Unit_Pool_S = [ "rhsgref_ins_g_grenadier","rhsgref_ins_g_specialist_aa","rhsgref_ins_g_grenadier_rpg","rhsgref_ins_g_machinegunner","rhsgref_ins_g_medic","rhsgref_ins_g_rifleman","rhsgref_ins_g_rifleman_akm","rhsgref_ins_g_rifleman_aksu","rhsgref_ins_g_rifleman_RPG26","rhsgref_ins_g_saboteur","rhsgref_ins_g_engineer","rhsgref_ins_g_sniper","rhsgref_ins_g_spotter" ];
		_Unit_Pool_V = [ "rhsgref_ins_g_btr60","rhsgref_ins_g_btr70","rhsgref_ins_g_uaz_ags","rhsgref_ins_g_uaz_ags","rhsgref_ins_g_uaz_open","rhsgref_ins_g_uaz_spg9","rhsgref_BRDM2_ins_g","rhsgref_ins_g_ural","rhsgref_ins_g_ural_Zu23" ]; 
		_Unit_Pool_T = [ "rhsgref_ins_g_zsu234","rhsgref_ins_g_bmd1","rhsgref_ins_g_bmd1p","rhsgref_ins_g_bmd2","rhsgref_ins_g_bmp1","rhsgref_ins_g_bmp1d","rhsgref_ins_g_bmp1k","rhsgref_ins_g_bmp1p","rhsgref_ins_g_bmp2e","rhsgref_ins_g_bmp2","rhsgref_ins_g_t72bb" ];
		_Unit_Pool_A = [ "rhsgref_ins_g_Mi8amt" ];
	};

	// ZEUS - TAKIBAN
	case 31:
	{
		_Unit_Pool_S = [ "O_Taki_soldier_SL_F", "O_Taki_soldier_Eng_F", "O_Taki_soldier_Exp_F", "O_Taki_soldier_G_AK74M_F", "O_Taki_soldier_G_AKM_F", "O_Taki_soldier_G_RPG_F", "O_Taki_soldier_G_ARPG_F", "O_Taki_soldier_R26_F", "O_Taki_soldier_RSG_F", "O_Taki_soldier_MG_F", "O_Taki_soldier_M_F", "O_Taki_soldier_Med_F", "O_Taki_soldier_S_F", "O_Taki_soldier_TL_F", "O_Taki_soldier_AA_F"	];
		_Unit_Pool_V = [ "Taki_UAZ_F","Taki_UAZ_dshkm_F","Taki_UAZ_spg9_F","Taki_UAZ_ags30_F","Taki_Ural_Zu23_F","Taki_Ural_03_F" ];     
		_Unit_Pool_T = [ "Taki_zsu_F","Taki_bmd1_F","Taki_bmp1_F","Taki_t72_F" ];
		_Unit_Pool_A = [ "Taki_mi8_armed_F","rhsgref_mi24g_CAS" ]; 
	};
	
	// UNSUNG - US
	case 50:
	{
		_Unit_Pool_S = [ "uns_men_USMC_65_PL","uns_men_USMC_65_AHMG","uns_men_USMC_65_ENG","uns_men_USMC_65_GL","uns_men_USMC_65_HMG","uns_men_USMC_65_MED","uns_men_USMC_65_MRK","uns_men_USMC_65_MTSG","uns_men_USMC_65_RF2","uns_men_USMC_65_RF4","uns_men_USMC_65_RTO","uns_men_USMC_65_SCT","uns_men_USMC_65_SL","uns_men_USMC_65_TRI","uns_men_USMC_68_AT" ];
		_Unit_Pool_V = [ "uns_willys","uns_willysmg50","uns_willysmg","uns_M113_M2","uns_M113_M134" ];     
		_Unit_Pool_T = [ "uns_m551","uns_m48a3" ];
		_Unit_Pool_A = [ "uns_UH1C_M6_M158","uns_UH1D_m60","uns_UH1C_M21_M158","uns_ch47_m60_usmc" ]; 
	};
	
	// UNSUNG - VC
	case 51:
	{
		_Unit_Pool_S = [ "uns_men_NVA_68_off","uns_men_NVA_68_AAuns_men_NVA_68_AS3","uns_men_NVA_68_AS4","uns_men_NVA_68_AS6","uns_men_NVA_68_AT","uns_men_NVA_68_AT2","uns_men_NVA_68_COM","uns_men_NVA_68_HMG","uns_men_NVA_68_MED","uns_men_NVA_68_MRK","uns_men_NVA_68_MTS","uns_men_NVA_68_RF4","uns_men_NVA_68_RTO","uns_men_NVA_68_SAP","uns_men_NVA_68_TRI","uns_men_NVA_68_nco" ];
		_Unit_Pool_V = [ "uns_Type55_MG","uns_Type55_M40","uns_Type55_patrol","uns_nvatruck","uns_Type55","uns_nvatruck_zpu","uns_Type55_ZU" ];     
		_Unit_Pool_T = [ "pook_ZSU_NVA","uns_t34_85_nva","uns_t55_nva" ];
		_Unit_Pool_A = [ "uns_Mi8T_VPAF","uns_Mi8TV_VPAF_MG" ]; 
	};

	// UNSUNG - VC
	case 52:
	{
		_Unit_Pool_S = [ "uns_men_VC_recon_nco","uns_men_VC_recon_AS3","uns_men_VC_recon_AS3","uns_men_VC_recon_AS3","uns_men_VC_recon_MED","uns_men_VC_recon_RF2","uns_men_VC_recon_RF1","uns_men_VC_recon_RF5","uns_men_VC_recon_RF6","uns_men_VC_recon_SAP2","uns_men_VC_recon_LMG","uns_men_VC_recon_HMG","uns_men_VC_recon_nco","uns_men_VC_recon_AS2","uns_men_VC_recon_AS1","uns_men_VC_recon_AS5" ];
		_Unit_Pool_V = [ "uns_Type55_MG","uns_Type55_M40","uns_Type55_patrol","uns_nvatruck","uns_Type55","uns_nvatruck_zpu","uns_Type55_ZU" ];     
		_Unit_Pool_T = [ "pook_ZSU_NVA","uns_t34_76_vc","uns_t55_nva" ];
		_Unit_Pool_A = [ "uns_Mi8T_VPAF","uns_Mi8TV_VPAF_MG" ]; 
	};
	
	
	// SOG - US
	case 53:
	{
		_Unit_Pool_S = [ "vn_b_men_army_12","vn_b_men_army_05","vn_b_men_army_04","vn_b_men_army_07","vn_b_men_army_06","vn_b_men_army_10","vn_b_men_army_03","vn_b_men_army_15","vn_b_men_army_16","vn_b_men_army_18","vn_b_men_army_19","vn_b_men_army_20","vn_b_men_army_21" ];
		_Unit_Pool_V = [ "vn_b_wheeled_m151_mg_04","vn_b_wheeled_m151_mg_02","vn_b_wheeled_m151_mg_03","vn_b_wheeled_m54_mg_01","vn_b_wheeled_m54_mg_03","vn_b_wheeled_m54_mg_02" ];     
		_Unit_Pool_T = [ "vn_b_armor_m41_01_01" ];
		_Unit_Pool_A = [ "vn_b_air_ah1g_07_usmc","vn_b_air_f4b_usmc_ucas","vn_b_air_f4b_usmc_mbmb" ]; 
	};
	
	// SOG - NVA - 65
	case 54:
	{
		_Unit_Pool_S = [ "vn_o_men_nva_65_15","vn_o_men_nva_65_16","vn_o_men_nva_65_21","vn_o_men_nva_65_23","vn_o_men_nva_65_24","vn_o_men_nva_65_25","vn_o_men_nva_65_26","vn_o_men_nva_65_28","vn_o_men_nva_65_17","vn_o_men_nva_65_18","vn_o_men_nva_65_19","vn_o_men_nva_65_20","vn_o_men_nva_65_22" ];
		_Unit_Pool_V = [ "vn_o_wheeled_z157_mg_01_nva65","vn_o_wheeled_btr40_mg_02_nva65","vn_o_wheeled_btr40_mg_01_nva65","vn_o_wheeled_btr40_mg_03_nva65" ];     
		_Unit_Pool_T = [ "vn_o_armor_type63_01_nva65" ];
		_Unit_Pool_A = [ "vn_o_air_mi2_03_03","vn_o_air_mi2_03_04" ]; 
	};

	// SOG - NVA
	case 55:
	{
		_Unit_Pool_S = [ "vn_o_men_nva_15","vn_o_men_nva_16","vn_o_men_nva_21","vn_o_men_nva_23","vn_o_men_nva_24","vn_o_men_nva_25","vn_o_men_nva_26","vn_o_men_nva_28","vn_o_men_nva_17","vn_o_men_nva_18","vn_o_men_nva_19","vn_o_men_nva_20","vn_o_men_nva_22" ];
		_Unit_Pool_V = [ "vn_o_wheeled_z157_mg_01","vn_o_wheeled_btr40_mg_02","vn_o_wheeled_btr40_mg_01","vn_o_wheeled_btr40_mg_03" ];     
		_Unit_Pool_T = [ "vn_o_armor_type63_01" ];
		_Unit_Pool_A = [ "vn_o_air_mi2_03_03","vn_o_air_mi2_03_04" ]; 
	};

	// SOG - ARVN
	case 56:
	{
		_Unit_Pool_S = [ "vn_i_men_army_12","vn_i_men_army_05","vn_i_men_army_04","vn_i_men_army_07","vn_i_men_army_06","vn_i_men_army_10","vn_i_men_army_15","vn_i_men_army_16","vn_i_men_army_18","vn_i_men_army_19","vn_i_men_army_20","vn_i_men_army_21","vn_i_men_army_02" ];
		_Unit_Pool_V = [ "vn_i_wheeled_m151_mg_01","vn_b_wheeled_m54_mg_01","vn_b_wheeled_m54_mg_03","vn_o_wheeled_btr40_mg_02_nva65" ];     
		_Unit_Pool_T = [ "vn_i_armor_m41_01","vn_i_armor_type63_01" ];
		_Unit_Pool_A = [ "vn_i_air_uh1c_02_01","vn_i_air_uh1c_01_01" ]; 
	};
	
	// SOG - VC
	case 57:
	{
		_Unit_Pool_S = [ "vn_o_men_vc_local_28","vn_o_men_vc_local_07","vn_o_men_vc_local_11","vn_o_men_vc_local_10","vn_o_men_vc_local_08","vn_o_men_vc_local_01","vn_o_men_vc_local_16","vn_o_men_vc_local_02","vn_o_men_vc_local_06","vn_o_men_vc_local_18","vn_o_men_vc_local_03","vn_o_men_vc_local_05","","vn_o_men_vc_local_13","vn_o_men_vc_local_23","vn_o_men_vc_local_12" ];
		_Unit_Pool_V = [ "vn_o_wheeled_z157_mg_01_vcmf","vn_o_wheeled_btr40_mg_02_vcmf","vn_o_wheeled_btr40_mg_01_vcmf","vn_o_wheeled_btr40_mg_03_vcmf" ];     
		_Unit_Pool_T = [ "vn_o_armor_type63_01_vcmf" ];
		_Unit_Pool_A = [ "vn_o_air_mi2_03_03","vn_o_air_mi2_03_04" ]; 
	};
	
  
  Default
  {
    if(DAC_Basic_Value != 5) then
    {
      DAC_Basic_Value = 5;publicVariable "DAC_Basic_Value",
	  //hintc "Error: DAC_Config_Units > No valid config number";
	  ["[x] Error: DAC_Config_Units > No valid config number"] call BIS_fnc_error;
    };
    if(true) exitWith {};
  };
};

if(count _this == 2) then
{
  _TempArray = _TempArray + [_Unit_Pool_S,_Unit_Pool_V,_Unit_Pool_T,_Unit_Pool_A];
}
else
{
  _TempArray = _Unit_Pool_V + _Unit_Pool_T + _Unit_Pool_A;
};
_TempArray