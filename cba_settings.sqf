// Contains all cba-settings for this mission.
force CBA_display_ingame_warnings = FALSE;

// TFAR
force TFAR_giveLongRangeRadioToGroupLeaders = FALSE;
force TFAR_givePersonalRadioToRegularSoldier = FALSE;
force TFAR_giveMicroDagrToSoldier = FALSE;
force TFAR_SameSRFrequenciesForSide = TRUE;
force TFAR_SameLRFrequenciesForSide = TRUE;

force TFAR_setting_defaultFrequencies_sr_west = "300,301,302,303,304,305,306,307";
force TFAR_setting_defaultFrequencies_lr_west = "30,30.2,30.4,30.6,30.8,31,31.2,31.4,31.6";
force TFAR_setting_defaultFrequencies_sr_east = "400,401,402,403,404,405,406,407";
force TFAR_setting_defaultFrequencies_lr_east = "40,40.2,40.4,40.6,40.8,41,41.2,41.4,41.6";
force TFAR_setting_defaultFrequencies_sr_independent = "500,501,502,503,504,505,506,507";
force TFAR_setting_defaultFrequencies_lr_independent = "50,50.2,50.4,50.6,50.8,51,51.2,51.4,51.6";

// ACRE
force acre_sys_core_terrainLoss = 0.35;

// STHUD
force STHud_Settings_RemoveDeadViaProximity = TRUE;
force STHud_Settings_Occlusion = TRUE;

// ACE
// http://www.29th.org/a3/index.php?title=ACE_3_Settings
force ace_advanced_fatigue_loadFactor = 0.8;
force ace_advanced_fatigue_performanceFactor = 1.25;
force ace_advanced_fatigue_recoveryFactor = 1.6;
force ace_advanced_fatigue_terrainGradientFactor = 0.9;

force ace_map_mapShake = FALSE;

force ace_pylons_enabled = FALSE;

force ace_repair_engineerSetting_fullRepair = 1;
force ace_repair_fullRepairLocation = 0;

force ace_weather_enableServerController = FALSE;
force ace_weather_enabled = FALSE;
force ace_weather_useACEWeather = FALSE;

force ace_medical_AIDamageThreshold = 0.8;
force ace_medical_healHitPointAfterAdvBandage = TRUE;
force ace_medical_medicSetting_PAK = 1;
force ace_medical_useCondition_PAK = 1;
force ace_medical_useLocation_PAK = 0;
force ace_medical_consumeItem_PAK = 1;
force ace_medical_medicSetting_SurgicalKit = 1;
force ace_medical_useCondition_SurgicalKit = 0;
force ace_medical_useLocation_SurgicalKit = 0;
force ace_medical_consumeItem_SurgicalKit = 0;
force ace_medical_playerDamageThreshold = 2.5;
force ace_medical_preventInstaDeath = FALSE;
force ace_medical_enableAdvancedWounds = TRUE; // Wound Re-Opening
force ace_medical_level = 2; // 0 = "Disabled", 1 = "Basic", 2 = "Advanced"
force ace_medical_medicSetting = 2; // 0 = Everyone, 1 = Medics are medics, Doctors need param 2 = Medics are Doctors