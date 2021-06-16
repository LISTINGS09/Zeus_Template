// F3 - TFR/ACRE Settings
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

// SHARED SETTINGS (ACRE / TFAR / VANILLA)
// Should any radios should be assigned at all, to anyone?
f_radios_settings_disableAllRadios = false;

// Unit types you want to give a long-range
// e.g: ["co","dc","pp","pc","pcc","vc","vd","vg"] would give the CO, FTLs and all medics long-range
f_radios_settings_longRangeUnits = ["leaders"]; // ["co","ftl","vc","pp"];

// Set the list of units that get a personal/short-range radio e.g. "co","dc","ftl","pp"
// Undefined will assign to ALL by default, below gives any leader a PR
f_radios_settings_personalRadio = ["leaders","co","dc","ftl","pp","vc"];

// Set the list of units that get a rifleman's/basic radio
// Undefined will assign to all by default or leave empty array for no radios.
f_radios_settings_riflemanRadio = [];

// Set custom LR Nets if required (LR otherwise determined by 'groups.sqf').
f_radios_settings_longRangeGroups = ["Company", "Platoon 1", "Platoon 2", "Air", "Support"]; // "NEUTRAL" is shared in ACRE.

// If a backpack is to be assigned, use this class.
//f_radios_WESTBackpack = "tf_rt1523g_black";
//f_radios_EASTBackpack = "tf_mr3000_bwmod";
//f_radios_GUERBackpack = "tf_anprc155_coyote";

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