// F3 - Folk ARPS Assign Gear Script - NATO
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ================================
// GENERAL EQUIPMENT USED BY MULTIPLE CLASSES
// ATTACHMENTS - PRIMARY
_attach1 = "";
_attach2 = "";

_flashHider = "";
_silencer1 = "muzzle_snds_M"; // Rifleman
_silencer2 = "gm_suppressor_atec150_762mm_blk"; // MG

_scope1 = ["gm_rv_ris_blk"]; // Rifleman
_scope2 = ["gm_rv_stanagHK_blk"]; // MG
_scope3 = []; // Medium
_scope4 = ["gm_pso1_gry"]; // High

_bipod1 = ["gm_g8_bipod_blk"];

// Default setup
_attachments = [_scope1,_silencer1]; // The default attachment set for most units, overwritten in the individual unitType

// Predefined Class Attachment Setup
_attach_co = [_scope1,_silencer1];
_attach_dc = [_scope1,_silencer1]; // Also SL!
_attach_fl = [_scope1,_silencer1];
_attach_mg = [_scope2,_bipod1,_silencer2];
_attach_dm = [_scope4];
_attach_sn = [_scope4];

// [] = remove all
// [_attach1,_scope1,_silencer1] = remove all, add items assigned in _attach1, _scope1 and _silencer1
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
_defMags = 5;
_defMags_tr = 5;

// Standard Riflemen ( MMG Assistant Gunner, Assistant Automatic Rifleman, MAT Assistant Gunner, MTR Assistant Gunner, Rifleman)
_rifle = "gm_sg550_ris_blk";
_riflemag = "gm_30Rnd_556x45mm_B_DM11_sg550_brn";
_riflemag_tr = "gm_30Rnd_556x45mm_B_T_DM21_sg550_brn";

// Standard Carabineer (Medic, Rifleman (AT), MAT Gunner, MTR Gunner, Carabineer)
_carbine = "gm_sg551_ris_blk";
_carbinemag = "gm_30Rnd_556x45mm_B_DM11_sg550_brn";
_carbinemag_tr = "gm_30Rnd_556x45mm_B_T_DM21_sg550_brn";

// Standard Submachine Gun/Personal Defence Weapon (Aircraft Pilot, Submachinegunner)
_smg = "gm_sg551_ris_blk";
_smgmag = "gm_30Rnd_556x45mm_B_DM11_sg550_brn";
_smgmag_tr = "gm_30Rnd_556x45mm_B_T_DM21_sg550_brn";

// Diver
_diverWep = "arifle_SDAR_F";
_diverMag1 = "30Rnd_556x45_Stanag";
_diverMag2 = "20Rnd_556x45_UW_mag";

// Rifle with GL and HE grenades (CO, DC, FTLs)
_glrifle = "gm_sg550_ris_blk";
_glriflemag = "gm_30Rnd_556x45mm_B_DM11_sg550_brn";
_glriflemag_tr = "gm_30Rnd_556x45mm_B_T_DM21_sg550_brn";
//_glmag = "1Rnd_HE_Grenade_shell";

// Smoke for FTLs, Squad Leaders, etc
//_glsmoke = "1Rnd_Smoke_Grenade_shell";
//_glsmokealt1 = "1Rnd_SmokeGreen_Grenade_shell";
//_glsmokealt2 = "1Rnd_SmokeRed_Grenade_shell";

// Flares for FTLs, Squad Leaders, etc
//_glflare = "UGL_FlareWhite_F";
//_glflarealt = "UGL_FlareGreen_F";

// Pistols (CO, DC, Automatic Rifleman, Medium MG Gunner)
_pistol = "hgun_Rook40_F";
_pistolmag = "16Rnd_9x21_Mag";

// Grenades
_grenade = "gm_handgrenade_frag_dm51";
_grenadealt = "gm_handgrenade_frag_dm51";
_smokegrenade = "SmokeShell";
_smokegrenadealt = "SmokeShellGreen";

// misc medical items.
_firstaid = "FirstAidKit";
_medkit = "Medikit";

// Binoculars
_binos1 = "gm_df7x40_blk";
_binos2 = "gm_df7x40_blk";

// Night Vision Goggles (NVGoggles)
_nvg = "NVGoggles";

// UAV Terminal
_uavterminal = "B_UavTerminal";	  // BLUFOR - FIA

// Chemlights
//_chem =  "SmokeShellBlue";
//_chemalt = "SmokeShellOrange";

// Backpacks
_bagsmall = "B_FieldPack_cbr";
_bagmedium = "B_FieldPack_cbr";
_baglarge =  "B_Carryall_cbr";
_bagmediumdiver =  "B_AssaultPack_blk";		// used by divers
_baguav = "B_UAV_01_backpack_F";			// used by UAV operator
_baghmgg = "B_HMG_01_weapon_F";				// used by Heavy MG gunner
_baghmgag = "B_HMG_01_support_F";			// used by Heavy MG assistant gunner
_baghatg = "B_AT_01_weapon_F";				// used by Heavy AT gunner
_baghatag = "B_HMG_01_support_F";			// used by Heavy AT assistant gunner
_bagmtrg = "B_Mortar_01_weapon_F";			// used by Mortar gunner
_bagmtrag = "B_Mortar_01_support_F";		// used by Mortar assistant gunner
_baghsamg = "B_AA_01_weapon_F";				// used by Heavy SAM gunner
_baghsamag = "B_HMG_01_support_F";			// used by Heavy SAM assistant gunner

// ================================

// UNIQUE, ROLE-SPECIFIC EQUIPMENT

// Automatic Rifleman
_AR = "gm_mg8a2_blk";
_ARmag = "gm_100Rnd_762x51mm_B_T_DM21_mg8_oli";
_ARmag_tr = "gm_100Rnd_762x51mm_B_T_DM21A2_mg8_oli";

// Medium MG
_MMG = "gm_hmgpkm_prp";
_MMGmag = "gm_100Rnd_762x54mm_B_T_T46_pk_grn";
_MMGmag_tr = "gm_100Rnd_762x54mm_B_T_T46_pk_grn";

// Marksman rifle
_DMrifle = ["gm_mpikm72_prp","gm_mpikm72_brn"];
_DMriflemag = "gm_30Rnd_762x39mm_B_M43_ak47_blk";

// Rifleman AT
_RAT = "gm_rpg7_wud";
_RATmag = "gm_1Rnd_40mm_heat_pg7v_rpg7";
_RATmag2 = "gm_1Rnd_40mm_heat_pg7v_rpg7";

// Medium AT
_MAT = "gm_rpg7_wud";
_MATmag1 = "gm_1Rnd_40mm_heat_pg7v_rpg7";
_MATmag2 = "gm_1Rnd_40mm_heat_pg7v_rpg7";

// Surface Air
_SAM = "gm_9k32m_oli";
_SAMmag = "gm_1Rnd_72mm_he_9m32m";

// Heavy AT
_HAT = "gm_rpg7_wud";
_HATmag1 = "gm_1Rnd_40mm_heat_pg7v_rpg7";
_HATmag2 = "gm_1Rnd_40mm_heat_pg7v_rpg7";

// Sniper
_SNrifle = "gm_svd_wud";
_SNrifleMag = "gm_10Rnd_762x54mmR_AP_7N1_svd_blk";

// Engineer items
_ATmine = "gm_mine_at_tm46";
_satchel = "gm_explosive_plnp_charge";
_APmine1 = "gm_mine_ap_dm31";
_APmine2 = "gm_mine_ap_dm31";

// ================================

// FACE, CLOTHES AND UNIFORMS

// Define classes. This defines which gear class gets which uniform
// "medium" vests are used for all classes if they are not assigned a specific uniform
// FACE, CLOTHES AND UNIFORMS
_light = [];
_heavy =  ["eng","engm"];
_diver = ["div"];
_pilot = ["pp","pcc","pc"];
_crew = ["vc","vg","vd"];
_ghillie = ["sn","sp"];
_specOp = [];

// Basic clothing
// The outfit-piece is randomly selected from the array for each unit
_baseUniform = ["gmx_cdf_army_uniform_soldier_rolled_ttsko","gmx_cdf_army_uniform_crew_ttsko"];
_baseHelmet = "gmx_cdf_army_headgear_m96_ttsko";
_baseGlasses = "G_bandanna_khk";

// Vests
_lightRig = "gm_ge_bgs_vest_type3_gry";
_mediumRig = "V_PlateCarrier1_rgr_noflag_F"; 	// default for all infantry classes
_heavyRig = "V_PlateCarrier1_rgr_noflag_F";

// Diver
_diverUniform =  "U_B_Wetsuit";
_diverHelmet = [];
_diverRig = "V_RebreatherB";
_diverGlasses = "G_Diving";

// Pilot
_pilotUniform = "gmx_cdf_army_uniform_crew_ttsko";
_pilotHelmet = "gm_gc_headgear_zsh3_wht";
_pilotRig = "gm_dk_army_vest_54_crew";
_pilotGlasses = [];

// Crewman
_crewUniform = "gmx_cdf_army_uniform_crew_ttsko";
_crewHelmet = "gm_ge_headgear_crewhat_80_blk";
_crewRig = _lightRig;
_crewGlasses = "G_bandanna_blk";

// Ghillie
_ghillieUniform = ["gmx_cdf_army_uniform_soldier_ttsko","gmx_cdf_army_uniform_soldier_rolled_ttsko","gmx_cdf_army_uniform_crew_ttsko"];
_ghillieHelmet = "gm_ge_headgear_hat_beanie_blk";
_ghillieRig = _mediumRig;
_ghillieGlasses = "G_bandanna_oli";

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

	// _unit linkItem _nvg;			// Add and equip the faction's nvg	
	_unit addItem _firstaid;		// Add a single first aid kit (FAK)
	_unit linkItem "ItemMap";		// Add and equip the map
	_unit linkItem "ItemCompass";	// Add and equip a compass
	_unit linkItem "ItemRadio";		// Add and equip A3's default radio
	_unit linkItem "ItemWatch";		// Add and equip a watch
	_unit addItem "";
	_unit addItem "";
};

// SETUP BACKPACKS
// Include the correct backpack file for the faction

_backpack = {
	_typeOfBackPack = _this select 0;
	_loadout = f_param_backpacks;
	if (count _this > 1) then {_loadout = _this select 1};
	switch (_typeOfBackPack) do
	{
		#include "f_backpack_CDF.sqf";
	};
};

// DEFINE UNIT TYPE LOADOUTS
// The following blocks of code define loadouts for each type of unit (the unit type
// is passed to the script in the first variable)

switch (_typeOfUnit) do
{

	// LOADOUT: COMMANDER
	case "co":
	{
		["r"] call _backpack;
		_unit addHeadGear "gmx_cdf_army_headgear_cap_ttsko";
		_unit setUnitTrait ["engineer",1];
		_unit addMagazines [_glriflemag,_defMags];
		_unit addMagazines [_glriflemag_tr,_defMags_tr];
		[_unit, _glrifle] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,2];
		_unit addMagazines [_smokegrenade,2];
		[_unit, _pistol] call f_fnc_addWeapon;
		_unit addMagazines [_pistolmag,4];
		[_unit, _binos1] call f_fnc_addWeapon;
		_attachments = _attach_co;
	};

	// LOADOUT: DEPUTY COMMANDER AND SQUAD LEADER
	case "dc":
	{
		["r"] call _backpack;
		_unit addMagazines [_glriflemag,_defMags];
		_unit addMagazines [_glriflemag_tr,_defMags_tr];
	//	_unit addMagazines [_glmag,3];
		[_unit, _glrifle] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,2];
		_unit addMagazines [_smokegrenade,2];
		[_unit, _pistol] call f_fnc_addWeapon;
		_unit addMagazines [_pistolmag,4];
		[_unit, _binos1] call f_fnc_addWeapon;
		_attachments = _attach_dc;
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
		{_unit addItem _firstaid} forEach [1,2,3,4];
	};

	// LOADOUT: FIRE TEAM LEADER
	case "ftl":
	{
		["r"] call _backpack;
		_unit addMagazines [_glriflemag,_defMags];
		_unit addMagazines [_glriflemag_tr,_defMags_tr];
	//	_unit addMagazines [_glmag,3];
		[_unit, _glrifle] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,2];
		[_unit, _pistol] call f_fnc_addWeapon;
		_unit addMagazines [_pistolmag,4];
		[_unit, _binos1] call f_fnc_addWeapon;
		_attachments = _attach_fl;
	};

	// LOADOUT: AUTOMATIC RIFLEMAN
	case "ar":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_ARmag,_defMags_tr];
		_unit addMagazines [_ARmag_tr,_defMags_tr];
		[_unit, _AR] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,2];
		_unit addMagazines [_smokegrenade,2];
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
		_unit addMagazines [_grenade,2];
		_unit addMagazines [_smokegrenade,2];
		[_unit, _binos1] call f_fnc_addWeapon;
	};

	// LOADOUT: RIFLEMAN (AT)
	case "rat":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,2];
		_unit addMagazines [_smokegrenade,2];
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
		_unit addMagazines [_pistolmag,3];
		[_unit, _pistol] call f_fnc_addWeapon;
		_attachments = _attach_mg;
	};

	// LOADOUT: MEDIUM MG ASSISTANT GUNNER
	case "mmgag":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_riflemag,_defMags];
		_unit addMagazines [_riflemag_tr,_defMags_tr];
		[_unit, _rifle] call f_fnc_addWeapon;
		[_unit, _binos1] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,2];
		_unit addMagazines [_smokegrenade,2];
	};

	// LOADOUT: HEAVY MG GUNNER
	case "hmgg":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,2];
		_unit addMagazines [_smokegrenade,2];
	};

	// LOADOUT: HEAVY MG ASSISTANT GUNNER
	case "hmgag":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		[_unit, _binos1] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,2];
		_unit addMagazines [_smokegrenade,2];
	};

	// LOADOUT: MEDIUM AT GUNNER
	case "matg":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		_unit addMagazines [_smokegrenade,2];
		[_unit, _carbine] call f_fnc_addWeapon;
		[_unit, _MAT] call f_fnc_addWeapon;
		_unit addSecondaryWeaponItem "gm_feroz2x17_pzf84_blk";
	};

	// LOADOUT: MEDIUM AT ASSISTANT GUNNER
	case "matag":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		[_unit, _binos1] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,2];
		_unit addMagazines [_smokegrenade,2];
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
		_unit addMagazines [_grenade,2];
		_unit addMagazines [_smokegrenade,2];
	};

	// LOADOUT: MORTAR GUNNER
	case "mtrg":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,2];
		_unit addMagazines [_smokegrenade,2];
	};

	// LOADOUT: MORTAR ASSISTANT GUNNER
	case "mtrag":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,2];
		_unit addMagazines [_smokegrenade,2];
		[_unit, _binos1] call f_fnc_addWeapon;
	};

	// LOADOUT: MEDIUM SAM GUNNER
	case "msamg":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,2];
		_unit addMagazines [_smokegrenade,2];
		[_unit, _SAM] call f_fnc_addWeapon;
		
	};

	// LOADOUT: MEDIUM SAM ASSISTANT GUNNER
	case "msamag":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		[_unit, _binos1] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,2];
		_unit addMagazines [_smokegrenade,2];
	};

	// LOADOUT: HEAVY SAM GUNNER
	case "hsamg":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,2];
		_unit addMagazines [_smokegrenade,2];
	};

	// LOADOUT: HEAVY SAM ASSISTANT GUNNER
	case "hsamag":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		[_unit, _binos1] call f_fnc_addWeapon;
		_unit addMagazines [_grenade,2];
		_unit addMagazines [_smokegrenade,2];
	};

	// LOADOUT: SNIPER
	case "sn":
	{
		_unit addMagazines [_SNrifleMag,_defMags_tr];
		[_unit, _SNrifle] call f_fnc_addWeapon;
		_unit addMagazines [_pistolmag,3];
		[_unit, _pistol] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,4];
		_attachments = _attach_sn;
	};

	// LOADOUT: SPOTTER
	case "sp":
	{
		["small"] call _backpack;
		_unit addMagazines [_glriflemag,_defMags];
		_unit addMagazines [_SNrifleMag,_defMags];
		_unit addMagazines [_glriflemag_tr,_defMags_tr];
	//	_unit addMagazines [_glmag,3];
	//	_unit addMagazines [_glsmoke,4];
		[_unit, _glrifle] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,4];
		[_unit, _binos1] call f_fnc_addWeapon;
	};

	// LOADOUT: VEHICLE COMMANDER
	case "vc":
	{
		["cc"] call _backpack;
		_unit setUnitTrait ["engineer",1];
		_unit addMagazines [_smgmag,_defMags];
		[_unit, _smg] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,2];
		[_unit, _binos1] call f_fnc_addWeapon;
	};

	// LOADOUT: VEHICLE DRIVER
	case "vd":
	{
		["cc"] call _backpack;
		_unit setUnitTrait ["engineer",1];
		_unit addMagazines [_smgmag,_defMags];
		[_unit, _smg] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,2];
	};

	// LOADOUT: VEHICLE GUNNER
	case "vg":
	{
		_unit addMagazines [_smgmag,_defMags];
		[_unit, _smg] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,2];
	};

	// LOADOUT: AIR VEHICLE PILOTS
	case "pp":
	{
		["cc"] call _backpack;
		_unit setUnitTrait ["engineer",1];
		_unit addMagazines [_smgmag,_defMags];
		[_unit, _smg] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,2];
	};

	// LOADOUT: AIR VEHICLE CREW CHIEF
	case "pcc":
	{
		["cc"] call _backpack;
		_unit setUnitTrait ["engineer",1];
		_unit addMagazines [_smgmag,_defMags];
		[_unit, _smg] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,2];
	};

	// LOADOUT: AIR VEHICLE CREW
	case "pc":
	{
		_unit setUnitTrait ["engineer",1];
		_unit addMagazines [_smgmag,_defMags];
		[_unit, _smg] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,2];
	};

	// LOADOUT: ENGINEER (DEMO)
	case "engd":
	{
		[_typeOfUnit] call _backpack;
		_unit setUnitTrait ["engineer",1];
		_unit setUnitTrait ["explosiveSpecialist",1];
		_unit addItem "MineDetector";
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];	
		[_unit, _carbine] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_grenade,2];
		_unit addMagazines [_satchel,2];
	};

	// LOADOUT: ENGINEER (MINES)
	case "engm":
	{
		[_typeOfUnit] call _backpack;
		_unit setUnitTrait ["engineer",1];
		_unit setUnitTrait ["explosiveSpecialist",1];
		_unit addItem "MineDetector";
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];		
		[_unit, _carbine] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_grenade,2];
	//	_unit addMagazines [_APmine2,2];
	};

	// LOADOUT: UAV OPERATOR
	case "uav":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_smgmag,_defMags];
		[_unit, _smg] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_grenade,2];
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
		_unit addMagazines [_grenade,2];
	};

	// LOADOUT: RIFLEMAN
	case "r":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_riflemag,_defMags];
		_unit addMagazines [_riflemag_tr,_defMags_tr];
		[_unit, _rifle] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_grenade,2];
	};

// LOADOUT: CARABINEER
	case "car":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_carbinemag,_defMags];
		_unit addMagazines [_carbinemag_tr,_defMags_tr];
		[_unit, _carbine] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_grenade,2];
	};

	// LOADOUT: SUBMACHINEGUNNER
	case "smg":
	{
		[_typeOfUnit] call _backpack;
		_unit addMagazines [_smgmag,_defMags];
		_unit addMagazines [_smgmag_tr,_defMags_tr];		
		[_unit, _smg] call f_fnc_addWeapon;
		_unit addMagazines [_smokegrenade,2];
		_unit addMagazines [_grenade,2];
	};

	// LOADOUT: GRENADIER
	case "gren":
	{
		["g"] call _backpack;
		_unit addMagazines [_glriflemag,_defMags];
		_unit addMagazines [_glriflemag_tr,_defMags_tr];
		[_unit, _glrifle] call f_fnc_addWeapon;
	//	_unit addMagazines [_glmag,5];
	//	_unit addMagazines [_glsmoke,2];
	//	_unit addMagazines [_glflare,2];
		_unit addMagazines [_smokegrenade,4];
		_unit addMagazines [_grenade,4];
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

		if (true) exitWith {diag_log text format ["[F3] DEBUG (f_loadout_gm_west_partisan_bc.sqf): Unit = %1. Gear template %2 does not exist!",_unit,_typeOfUnit]};
   };

// END SWITCH FOR DEFINE UNIT TYPE LOADOUTS
};

// Handle weapon attachments
#include "..\..\f\assignGear\f_assignGear_attachments.sqf";


// ENSURE UNIT HAS CORRECT WEAPON SELECTED ON SPAWNING

_unit selectWeapon primaryWeapon _unit;