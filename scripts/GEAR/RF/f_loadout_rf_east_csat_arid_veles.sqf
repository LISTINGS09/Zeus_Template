// F3 - Folk ARPS Assign Gear Script - NATO
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ================================
// GENERAL EQUIPMENT USED BY MULTIPLE CLASSES
// ATTACHMENTS - PRIMARY
_attach1 = ["acc_pointer_IR","acc_flashlight"];
_attach2 = "";

_flashHider = "";
_silencer1 = ["muzzle_snds_H","muzzle_snds_58_blk_F"]; // Rifleman
_silencer2 = ["muzzle_snds_93mmg_tan","muzzle_snds_58_blk_F"]; // MG

_scope1 = ["optic_ACO_grn_desert_RF","optic_ACO_desert_RF","optic_ACO","optic_ACO_grn"]; // CQB
_scope2 = ["optic_Arco_blk_F","optic_Arco","optic_MRCO"]; // Low
_scope3 = ["optic_DMS","optic_SOS","optic_NVS"]; // Medium
_scope4 = ["optic_LRPS","optic_KHS_blk","optic_KHS_hex","optic_Nightstalker"]; // High

_bipod1 = ["bipod_02_F_blk","bipod_02_F_hex"];

// Default setup
_attachments = [_attach1,_scope2]; // The default attachment set for most units, overwritten in the individual unitType

// Predefined Class Attachment Setup
_attach_co = [_attach1,_scope2];
_attach_dc = [_attach1,_scope2]; // Also SL!
_attach_fl = [_attach1,_scope2];
_attach_mg = [_attach1,_scope2,_bipod1];
_attach_dm = [_scope3,_bipod1];
_attach_sn = [_scope4,_bipod1];

// [] = remove all
// [_attach1,_scope1,_silencer] = remove all, add items assigned in _attach1, _scope1 and _silencer1
// [_scope2] = add _scope2, remove rest

// ================================

// ATTACHMENTS - HANDGUN
_hg_silencer1 = "";
_hg_scope1 = "";

// Default setup
_hg_attachments= []; // The default attachment set for handguns, overwritten in the individual unitType

// ================================

// WEAPON SELECTION

// Basic magazine counts given to most infantry, MMG etc get _defMags_tr as default count.
_defMags = 4;
_defMags_tr = 3;

// Standard Riflemen ( MMG Assistant Gunner, Assistant Automatic Rifleman, MAT Assistant Gunner, MTR Assistant Gunner, Rifleman)
_rifle = ["arifle_ash12_LR_desert_RF","arifle_CTAR_hex_F"];
_riflemag = "20Rnd_127x55_Mag_desert_RF";
_riflemag_tr = "20Rnd_127x55_Mag_desert_RF";

// Standard Carabineer (Medic, Rifleman (AT), MAT Gunner, MTR Gunner, Carabineer)
_carbine = ["arifle_ash12_desert_RF","arifle_CTAR_hex_F"];
_carbinemag = "20Rnd_127x55_Mag_desert_RF";
_carbinemag_tr = "20Rnd_127x55_Mag_desert_RF";

// Standard Submachine Gun/Personal Defence Weapon (Aircraft Pilot, Submachinegunner)
_smg = ["SMG_02_F","SMG_05_F"];
_smgmag = "30Rnd_9x21_Mag";
_smgmag_tr = "30Rnd_9x21_Green_Mag";

// Diver
_diverWep = "arifle_SDAR_F";
_diverMag1 = "30Rnd_556x45_Stanag";
_diverMag2 = "20Rnd_556x45_UW_mag";

// Rifle with GL and HE grenades (CO, DC, FTLs)
_glrifle = ["arifle_ash12_GL_desert_RF","arifle_CTAR_GL_hex_F"];
_glriflemag = "20Rnd_127x55_Mag_desert_RF";
_glriflemag_tr = "20Rnd_127x55_Mag_desert_RF";
_glmag = "1Rnd_HE_Grenade_shell";

// Smoke for FTLs, Squad Leaders, etc
_glsmoke = "1Rnd_SmokeRed_Grenade_shell";
_glsmokealt1 = "1Rnd_RC40_shell_RF";
_glsmokealt2 = "1Rnd_RC40_HE_shell_RF";

// Flares for FTLs, Squad Leaders, etc
_glflare = "UGL_FlareWhite_F";
_glflarealt = "UGL_FlareRed_F";

// Pistols (CO, DC, Automatic Rifleman, Medium MG Gunner)
_pistol = "hgun_Rook40_F";
_pistolmag = "16Rnd_9x21_Mag";

// Grenades
_grenade = "HandGrenade";
_grenadealt = "MiniGrenade";
_smokegrenade = "SmokeShell";
_smokegrenadealt = "SmokeShellGreen";

// misc medical items.
_firstaid = "FirstAidKit";
_medkit = "Medikit";

// Binoculars
_binos1 = "Rangefinder";
_binos2 = "Laserdesignator_02";

// Night Vision Goggles (NVGoggles)
_nvg = "NVGoggles_OPFOR";

// UAV Terminal
_uavterminal = "O_UavTerminal";

// Chemlights
_chem =  "Chemlight_red";
_chemalt = "Chemlight_green";

// Backpacks
_bagsmall = "B_AssaultPack_ocamo";			// carries 120, weighs 20
_bagmedium = "B_FieldPack_ocamo";			// carries 200, weighs 30
_baglarge =  "B_Carryall_ocamo"; 			// carries 320, weighs 40
_bagmediumdiver =  "B_AssaultPack_blk";		// used by divers
_baguav = "O_UAV_01_backpack_F";			// used by UAV operator
_baghmgg = "O_HMG_01_weapon_F";				// used by Heavy MG gunner
_baghmgag = "O_HMG_01_support_F";			// used by Heavy MG assistant gunner
_baghatg = "O_AT_01_weapon_F";				// used by Heavy AT gunner
_baghatag = "O_HMG_01_support_F";			// used by Heavy AT assistant gunner
_bagmtrg = "O_Mortar_01_weapon_F";			// used by Mortar gunner
_bagmtrag = "O_Mortar_01_support_F";		// used by Mortar assistant gunner
_baghsamg = "O_AA_01_weapon_F";				// used by Heavy SAM gunner
_baghsamag = "O_HMG_01_support_F";			// used by Heavy SAM assistant gunner

// ====================================================================================

// UNIQUE, ROLE-SPECIFIC EQUIPMENT

// Automatic Rifleman
_AR = ["LMG_Zafir_F","arifle_CTARS_blk_F","arifle_CTARS_hex_F"];
_ARmag = "150Rnd_762x54_Box";
_ARmag_tr = "150Rnd_762x54_Box_Tracer";

// Medium MG
_MMG = ["MMG_01_hex_F","MMG_01_tan_F"];
_MMGmag = "150Rnd_93x64_Mag";
_MMGmag_tr = "150Rnd_93x64_Mag";

// Marksman rifle
_DMrifle = ["srifle_DMR_01_F","srifle_DMR_05_hex_F","srifle_DMR_07_hex_F","srifle_DMR_04_Tan_F"];
_DMriflemag = "10Rnd_762x54_Mag";

// Rifleman AT
_RAT = "launch_RPG32_F";
_RATmag = "RPG32_F";
_RATmag2 = "RPG32_HE_F";

// Medium AT
_MAT = ["launch_O_Titan_short_F","launch_O_Vorona_brown_F"];
_MATmag1 = "Titan_AT";
_MATmag2 = "Titan_AP";

// Surface Air
_SAM = "launch_O_Titan_F";
_SAMmag = "Titan_AA";

// Heavy AT
_HAT = "launch_O_Titan_short_F";
_HATmag1 = "Titan_AT";
_HATmag2 = "Titan_AP";

// Sniper
_SNrifle = ["srifle_GM6_camo_F","srifle_GM6_F","srifle_DMR_05_blk_F","srifle_DMR_05_hex_F","srifle_DMR_04_Tan_F"];
_SNrifleMag = "5Rnd_127x108_Mag";

// Engineer items
_ATmine = "ATMine_Range_Mag";
_satchel = "DemoCharge_Remote_Mag";
_APmine1 = "APERSBoundingMine_Range_Mag";
_APmine2 = "APERSMine_Range_Mag";

// ====================================================================================

// FACE, CLOTHES AND UNIFORMS

// Define classes. This defines which gear class gets which uniform
// "medium" vests are used for all classes if they are not assigned a specific uniform
_light = [];
_heavy =  ["eng","engm"];
_diver = ["div"];
_pilot = ["pp","pcc","pc"];
_crew = ["vc","vg","vd"];
_ghillie = ["sn","sp"];
_specOp = [];

// Basic clothing
// The outfit-piece is randomly selected from the array for each unit

// Woodland-Hex
_baseUniform = ["U_O_CombatUniform_ocamo"];
_baseHelmet = ["H_HelmetHeavy_Simple_Hex_RF"];
_baseGlasses = ["G_Bandanna_khk","G_Bandanna_shades","G_Sport_Blackred","G_Bandanna_blk","G_Shades_Blue",""];

// Vests
_lightRig = ["V_HarnessO_brn"];
_mediumRig = ["V_TacVest_khk"]; 	// default for all infantry classes
_heavyRig = _mediumRig;

// Diver
_diverUniform =  ["U_O_Wetsuit"];
_diverHelmet = [];
_diverRig = ["V_RebreatherIR"];
_diverGlasses = ["G_Diving"];

// Pilot
_pilotUniform = ["U_O_PilotCoveralls"];
_pilotHelmet = ["H_PilotHelmetHeli_O"];
_pilotRig = ["V_HarnessO_brn"];
_pilotGlasses = [];

// Crewman
_crewUniform = ["U_O_SpecopsUniform_ocamo"];
_crewHelmet = ["H_HelmetCrew_O"];
_crewRig = ["V_HarnessO_brn"];
_crewGlasses = [];

// Ghillie
_ghillieUniform = ["U_O_SpecopsUniform_ocamo"];
_ghillieHelmet = ["H_HelmetSpecO_ocamo"];
_ghillieRig = ["V_Chestrig_khk"];
_ghillieGlasses = [];

// Spec Op
_sfuniform = [];
_sfhelmet = [];
_sfRig = [];
_sfGlasses = [];

// ================================

// This block needs only to be run on an infantry unit
if (_isMan) then {
	// PREPARE UNIT FOR GEAR ADDITION
	// The following code removes all existing weapons, items, magazines and backpacks
	removeBackpack _unit;
	removeAllWeapons _unit;
	removeAllItemsWithMagazines _unit;
	removeAllAssignedItems _unit;

	// HANDLE CLOTHES
	// Handle clothes and helmets and such using the include file called next.
	#include "..\..\f\assignGear\f_assignGear_clothes.sqf";

	// ADD UNIVERSAL ITEMS
	// Add items universal to all units of this faction

	_unit linkItem _nvg;			// Add and equip the faction's nvg
	_unit addItem _firstaid;		// Add a single first aid kit (FAK)
	_unit linkItem "ItemMap";		// Add and equip the map
	_unit linkItem "ItemCompass";	// Add and equip a compass
	_unit linkItem "ItemRadio";		// Add and equip A3's default radio
	_unit linkItem "ItemWatch";		// Add and equip a watch
	_unit linkItem "ItemGPS"; 		// Add and equip a GPS
	_unit addItem "H_MilCap_ocamo";// Free Hat!
};
// ====================================================================================

// SETUP BACKPACKS
// Include the correct backpack file for the faction

_backpack = {
	_typeOfBackPack = _this select 0;
	switch (_typeOfBackPack) do
	{
		#include "f_backpack.sqf";
	};
};

// ====================================================================================

// DEFINE UNIT TYPE LOADOUTS
// The following blocks of code define loadouts for each type of unit (the unit type
// is passed to the script in the first variable)

switch (_typeOfUnit) do
{

	// LOADOUT: COMMANDER
	case "co":
	{
		_unit addHeadGear "H_MilCap_ocamo";
		["g"] call _backpack;
		_unit setUnitTrait ["engineer",true];
		_unit addMagazines [_glriflemag,_defMags];
		_unit addMagazines [_glriflemag_tr,_defMags_tr];
		_unit addMagazines [_glmag,3];
		_unit addMagazines [_glsmoke,4];
		[_unit, _glrifle] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,1];
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_smokegrenadealt,2];
		_unit addMagazines [_chem,2];
		[_unit, _binos2] call f_fnc_addWeapon;
		_unit addMagazines ["Laserbatteries",2];
		_unit linkItem _uavterminal;
		_attachments = _attach_co;
	};

	// LOADOUT: DEPUTY COMMANDER AND SQUAD LEADER
	case "dc":
	{
		["g"] call _backpack;
		_unit addMagazines [_glriflemag,_defMags];
		_unit addMagazines [_glriflemag_tr,_defMags_tr];
		_unit addMagazines [_glmag,3];
		_unit addMagazines [_glsmoke,4];
		[_unit, _glrifle] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,1];
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_smokegrenadealt,2];
		_unit addMagazines [_chem,2];
		[_unit, _binos2] call f_fnc_addWeapon;
		_unit addMagazines ["Laserbatteries",2];
		_attachments = _attach_dc;
		_unit linkItem _uavterminal;
	};

	// LOADOUT: MEDIC
	case "m":
	{
		[_typeOfUnit] call _backpack;
		_unit setUnitTrait ["medic",1];
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenadealt,4];
		_unit addMagazines [_chem,2];
		{_unit addItem _firstaid} forEach [1,2,3,4];
	};

	// LOADOUT: FIRE TEAM LEADER
	case "ftl":
	{
		["g"] call _backpack;
		_unit addMagazines [_glriflemag,_defMags];
		_unit addMagazines [_glriflemag_tr,_defMags_tr];
		_unit addMagazines [_glmag,3];
		_unit addMagazines [_glsmoke,4];
		[_unit, _glrifle] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,1];
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_smokegrenadealt,2];
		_unit addMagazines [_chem,2];
		[_unit, _binos2] call f_fnc_addWeapon;
		_unit addMagazines ["Laserbatteries",2];
		_unit linkItem _uavterminal;
		_attachments = _attach_fl;
	};


	// LOADOUT: AUTOMATIC RIFLEMAN
	case "ar":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_ARmag,_defMags_tr];
		_unit addMagazines [_ARmag_tr,1];
		[_unit, _AR] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,1];
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_chem,2];
		_unit addMagazines [_pistolmag,2];
		[_unit, _pistol] call f_fnc_addWeapon;
		_attachments = _attach_mg;
	};

	// LOADOUT: ASSISTANT AUTOMATIC RIFLEMAN
	case "aar":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_riflemag,_defMags];
		_unit addMagazines [_riflemag_tr,_defMags_tr];
		[_unit, _rifle] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,1];
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_chem,2];
		[_unit, _binos1] call f_fnc_addWeapon;
	};

	// LOADOUT: RIFLEMAN (AT)
	case "rat":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,1];
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_chem,2];
		[_unit, _RAT] call f_fnc_addWeapon;
	};

	// LOADOUT: DESIGNATED MARKSMAN
	case "dm":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_DMriflemag,_defMags];
		[_unit, _DMrifle] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,2];
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_chem,2];
		_unit addMagazines [_pistolmag,2];
		[_unit, _pistol] call f_fnc_addWeapon;
		_attachments = _attach_dm;
	};

	// LOADOUT: MEDIUM MG GUNNER
	case "mmgg":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_MMGmag,_defMags_tr];
		_unit addMagazines [_MMGmag_tr,1];
		[_unit, _MMG] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_chem,2];
		_unit addMagazines [_pistolmag,3];
		[_unit, _pistol] call f_fnc_addWeapon;
		_attachments = _attach_mg;
	};

	// LOADOUT: MEDIUM MG ASSISTANT GUNNER
	case "mmgag":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_riflemag,_defMags];
		_unit addMagazines [_riflemag_tr,2];
		[_unit, _rifle] call f_fnc_addWeapon;
		[_unit, _binos1] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,1];
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_chem,2];
	};

	// LOADOUT: HEAVY MG GUNNER
	case "hmgg":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,1];
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_chem,2];
	};

	// LOADOUT: HEAVY MG ASSISTANT GUNNER
	case "hmgag":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		[_unit, _binos1] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,1];
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_chem,2];
	};

	// LOADOUT: MEDIUM AT GUNNER
	case "matg":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_chem,2];
		[_unit, _carbine] call f_fnc_addWeapon;
		[_unit, _MAT] call f_fnc_addWeapon;
	};

	// LOADOUT: MEDIUM AT ASSISTANT GUNNER
	case "matag":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		[_unit, _binos2] call f_fnc_addWeapon;
		_unit addMagazines ["Laserbatteries",2];
		_unit addMagazines [_grenade,1];
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_chem,2];
	};

	// LOADOUT: HEAVY AT GUNNER
	case "hatg":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		[_unit, _HAT] call f_fnc_addWeapon;
	};

	// LOADOUT: HEAVY AT ASSISTANT GUNNER
	case "hatag":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		[_unit, _binos1] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,1];
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_chem,2];
	};

	// LOADOUT: MORTAR GUNNER
	case "mtrg":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,1];
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_chem,2];
	};

	// LOADOUT: MORTAR ASSISTANT GUNNER
	case "mtrag":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,1];
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_chem,2];
		[_unit, _binos2] call f_fnc_addWeapon;
		_unit addMagazines ["Laserbatteries",2];
	};

	// LOADOUT: MEDIUM SAM GUNNER
	case "msamg":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,1];
		_unit addMagazines [_smokegrenade,1];
		_unit addMagazines [_chem,1];
		[_unit, _SAM] call f_fnc_addWeapon;
		
	};

	// LOADOUT: MEDIUM SAM ASSISTANT GUNNER
	case "msamag":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		[_unit, _binos2] call f_fnc_addWeapon;
		_unit addMagazines ["Laserbatteries",2];
		_unit addMagazines [_grenade,1];
		_unit addMagazines [_smokegrenade,1];
		_unit addMagazines [_chem,1];
	};

	// LOADOUT: HEAVY SAM GUNNER
	case "hsamg":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,1];
		_unit addMagazines [_smokegrenade,1];
		_unit addMagazines [_chem,1];
	};

	// LOADOUT: HEAVY SAM ASSISTANT GUNNER
	case "hsamag":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		[_unit, _binos2] call f_fnc_addWeapon;
		_unit addMagazines ["Laserbatteries",2];
		_unit addMagazines [_grenade,1];
		_unit addMagazines [_smokegrenade,1];
		_unit addMagazines [_chem,1];
	};

	// LOADOUT: SNIPER
	case "sn":
	{
		_unit addMagazines [_SNrifleMag,_defMags_tr];
		[_unit, _SNrifle] call f_fnc_addWeapon;
		_unit addMagazines [_pistolmag,3];
		[_unit, _pistol] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,1];
		_unit addMagazines [_chem,1];
		_attachments = _attach_sn;
	};

	// LOADOUT: SPOTTER
	case "sp":
	{
		["small"] call _backpack;
		_unit addMagazines [_glriflemag,_defMags];
		_unit addMagazines [_SNrifleMag,_defMags];
		_unit addMagazines [_glriflemag_tr,_defMags_tr];
		_unit addMagazines [_glmag,3];
		_unit addMagazines [_glsmoke,4];
		[_unit, _glrifle] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,1];
		_unit addMagazines [_chem,1];
		[_unit, _binos2] call f_fnc_addWeapon;
		_unit addMagazines ["Laserbatteries",2];
	};

	// LOADOUT: VEHICLE COMMANDER
	case "vc":
	{
		["cc"] call _backpack;
		_unit setUnitTrait ["engineer",true];
		_unit addMagazines [_smgmag,_defMags];
		[_unit, _smg] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_chem,2];
		_unit linkItem "ItemGPS";
		[_unit, _binos1] call f_fnc_addWeapon;
	};

	// LOADOUT: VEHICLE DRIVER
	case "vd":
	{
		["cc"] call _backpack;
		_unit setUnitTrait ["engineer",true];
		_unit addMagazines [_smgmag,_defMags];
		[_unit, _smg] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_chem,2];
		_unit linkItem "ItemGPS";
	};

	// LOADOUT: VEHICLE GUNNER
	case "vg":
	{
		_unit addMagazines [_smgmag,_defMags];
		[_unit, _smg] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_chem,2];
		_unit linkItem "ItemGPS";
	};

	// LOADOUT: AIR VEHICLE PILOTS
	case "pp":
	{
		["cc"] call _backpack;
		_unit setUnitTrait ["engineer",true];
		_unit addMagazines [_smgmag,_defMags];
		[_unit, _smg] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_chem,2];
		_unit linkItem "ItemGPS";
	};

	// LOADOUT: AIR VEHICLE CREW CHIEF
	case "pcc":
	{
		["cc"] call _backpack;
		_unit setUnitTrait ["engineer",true];
		_unit addMagazines [_smgmag,_defMags];
		[_unit, _smg] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_chem,2];
	};

	// LOADOUT: AIR VEHICLE CREW
	case "pc":
	{
		_unit setUnitTrait ["engineer",true];
		_unit addMagazines [_smgmag,_defMags];
		[_unit, _smg] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_chem,2];
	};

	// LOADOUT: ENGINEER (DEMO)
	case "eng":
	{
		[_typeOfUnit] call _backpack;
		_unit setUnitTrait ["engineer",true];
		_unit setUnitTrait ["explosiveSpecialist",true];
		_unit addItem "MineDetector";
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_chem,2];
		_unit addMagazines [_grenade,1];
		_unit addMagazines [_satchel,2];
	};

	// LOADOUT: ENGINEER (MINES)
	case "engm":
	{
		[_typeOfUnit] call _backpack;
		_unit setUnitTrait ["engineer",true];
		_unit setUnitTrait ["explosiveSpecialist",true];
		_unit addItem "MineDetector";
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_chem,2];
		_unit addMagazines [_grenade,1];
		_unit addMagazines [_APmine2,2];
	};

	// LOADOUT: UAV OPERATOR
	case "uav":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_smgmag,_defMags];
		[_unit, _smg] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_chem,2];
		_unit addMagazines [_grenade,1];
		_unit linkItem _uavterminal;
		_unit addMagazines ["Laserbatteries",4];	// Batteries added for the F3 UAV Recharging component
	};

	// LOADOUT: Diver
	case "div":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_diverMag1,_defMags];
		_unit addMagazines [_diverMag2,_defMags_tr];
		[_unit, _diverWep] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,3];
		_unit addMagazines [_chem,2];
		_unit addMagazines [_grenade,2];
	};

	// LOADOUT: RIFLEMAN
	case "r":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_riflemag,_defMags];
		_unit addMagazines [_riflemag_tr,_defMags_tr];
		[_unit, _rifle] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,3];
		_unit addMagazines [_chem,2];
		_unit addMagazines [_grenade,2];
	};

// LOADOUT: CARABINEER
	case "car":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,3];
		_unit addMagazines [_chem,2];
		_unit addMagazines [_grenade,2];
	};

	// LOADOUT: SUBMACHINEGUNNER
	case "smg":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_smgmag,_defMags];
		[_unit, _smg] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,3];
		_unit addMagazines [_chem,2];
		_unit addMagazines [_grenade,2];
	};

	// LOADOUT: GRENADIER
	case "gren":
	{
		["g"] call _backpack;
		_unit addMagazines [_glriflemag,_defMags];
		_unit addMagazines [_glriflemag_tr,_defMags_tr];
		[_unit, _glrifle] call f_fnc_addWeapon;
		_unit addMagazines [_glmag,5];
		_unit addMagazines [_glsmoke,2];
		_unit addMagazines [_glflare,2];
		_unit addMagazines [_smokegrenade,3];
		_unit addMagazines [_chem,2];
		_unit addMagazines [_grenade,2];
	};

	case "empty": 
	{
		_skipCheck = true;
	};
	
	#include "f_vehicle_loadout.sqf";

	// LOADOUT: DEFAULT/UNDEFINED (use RIFLEMAN)
   default
   {
		_unit addMagazines [_riflemag,_defMags];
		[_unit, _rifle] call f_fnc_addWeapon;

		_unit selectWeapon primaryWeapon _unit;

		if (true) exitWith {diag_log text format ["[F3] DEBUG (f_loadout_a3_csat_d.sqf): Unit = %1. Gear template %2 does not exist!",_unit,_typeOfUnit]};
   };

// END SWITCH FOR DEFINE UNIT TYPE LOADOUTS
};

// Handle weapon attachments
#include "..\..\f\assignGear\f_assignGear_attachments.sqf";


// ENSURE UNIT HAS CORRECT WEAPON SELECTED ON SPAWNING

_unit selectWeapon primaryWeapon _unit;