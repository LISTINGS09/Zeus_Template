// F3 - TFR/ACRE Settings
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

// SHARED SETTINGS (ACRE / TFAR / VANILLA)
// Should any radios should be assigned at all, to anyone?
f_radios_settings_disableAllRadios = false;

// Unit types you want to give a long-range
// e.g: ["co","dc","pp","pc","pcc","vc","vd","vg"] would give the CO, FTLs and all medics long-range
f_radios_settings_longRangeUnits = ["leaders"];

// Set the list of units that get a personal/short-range radio e.g. "co","dc","ftl","p"
// Undefined will assign to ALL by default, below gives any leader a PR
f_radios_settings_personalRadio = ["leaders"];

// Set the list of units that get a rifleman's/basic radio
// Undefined will assign to all by default or leave empty array for no radios.
//f_radios_settings_riflemanRadio = [];

// Set custom LR Nets if required (LR otherwise determined by 'groups.sqf').
f_radios_settings_longRangeGroups = ["Company", "Platoon 1", "Platoon 2", "Air", "Support"]; // "NEUTRAL" is shared in ACRE.

// If a backpack is to be assigned, use this class.
//f_radios_WESTBackpack = "tf_rt1523g_black";
//f_radios_EASTBackpack = "tf_mr3000_bwmod";
//f_radios_GUERBackpack = "tf_anprc155_coyote";

// ====================================================================================
// TFAR SPECFIC
// ====================================================================================

// TFAR - The password of TS channel in "serious" mode.
TFAR_Teamspeak_Channel_Password = "123";

// TFAR - The name of TS channel in "serious" mode. 
TFAR_Teamspeak_Channel_Name = "Task Force Radio Only";

// Encryption code for side.
// Sides can communicate with the each other if these values are not different!
tf_west_radio_code = "_bluefor";
tf_east_radio_code = "_opfor";
tf_guer_radio_code = "_independent";

// TFAR Frequencies
// Sets the LR and SR Frequencies for each side.
TFAR_defaultFrequencies_sr_west = ["300","301","302","303","304","305","306","307"];
TFAR_defaultFrequencies_lr_west = ["30","30.2","30.4","30.6","30.8","31","31.2","31.4","31.6"];
TFAR_defaultFrequencies_sr_east = ["400","401","402","403","404","405","406","407"];
TFAR_defaultFrequencies_lr_east = ["40","40.2","40.4","40.6","40.8","41","41.2","41.4","41.6"];
TFAR_defaultFrequencies_sr_independent = ["500","501","502","503","504","505","506","507"];
TFAR_defaultFrequencies_lr_independent = ["50","50.2","50.4","50.6","50.8","51","51.2","51.4","51.6"];

TFAR_defaultFrequencies_sr_west = [0 ,7, TFAR_defaultFrequencies_sr_west,0, tf_west_radio_code, -1, 0, getPlayerUID player, false];
TFAR_defaultFrequencies_lr_west = [0 ,7, TFAR_defaultFrequencies_lr_west,0, tf_west_radio_code, -1, 0, false];
TFAR_defaultFrequencies_sr_east = [0 ,7, TFAR_defaultFrequencies_sr_east,0, tf_east_radio_code, -1, 0, getPlayerUID player, false];
TFAR_defaultFrequencies_lr_east = [0 ,7, TFAR_defaultFrequencies_lr_east,0, tf_east_radio_code, -1, 0, false];
TFAR_defaultFrequencies_sr_independent = [0 ,7, TFAR_defaultFrequencies_sr_independent,0, tf_guer_radio_code, -1, 0, getPlayerUID player, false];
TFAR_defaultFrequencies_lr_independent = [0 ,7, TFAR_defaultFrequencies_lr_independent,0, tf_guer_radio_code, -1, 0, false];

// ====================================================================================
// ACRE SPECFIC
// ====================================================================================

// Any units that get a PRC117F radio e.g. "co", "pp"
f_radios_settings_acre2_extraRadios = ["co","dc","pp","vc"];

// Whether or not the radio frequencies should be shared as default. TRUE = Frequency separation across sides.
f_radios_settings_acre2_SplitFrequencies = TRUE;

// Babel - Defines the languages that exist in the mission.
f_radios_settings_acre2_languages = [
	["en","English"],
	["ru","Russian"],
	["gr","Greek"],
	["ar","Arabic"],
	["fa","Farsi"]
];

// Babel - Defines the language that a player can speak. Can define multiple.
f_radios_settings_acre2_language_west = ["en"];
f_radios_settings_acre2_language_east = ["ru"];
f_radios_settings_acre2_language_guer = ["ar"];

// ACRE - Radio Types
f_radios_settings_acre2_standardSRRadio = "ACRE_PRC343";	// Standard Short
f_radios_settings_acre2_standardLRRadio = "ACRE_PRC152";	// Standard LongRange
f_radios_settings_acre2_extraRadio = "ACRE_PRC152";		// Extra Radio