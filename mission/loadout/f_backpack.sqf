// BACKPACK: MEDIC
case "m": {
	[_bagmedium,_unit] call f_fnc_addBackpack;
	(unitBackpack _unit) addItemCargoGlobal [_medkit,1];
	(unitBackpack _unit) addMagazineCargoGlobal [_smokegrenade, 2];
	(unitBackpack _unit) addMagazineCargoGlobal [_smokegrenadealt, 4];
	(unitBackpack _unit) addItemCargoGlobal [_firstaid, 4];
};

// BACKPACK: GRENADIER (CO/DC/SL/FTL/G)
case "g": {
	[_bagmedium,_unit] call f_fnc_addBackpack;
	(unitBackpack _unit) addMagazineCargoGlobal [_glriflemag, 2];
	(unitBackpack _unit) addMagazineCargoGlobal [_glriflemag_tr, 2];
	(unitBackpack _unit) addMagazineCargoGlobal [_glmag, 2];
	(unitBackpack _unit) addMagazineCargoGlobal [_glsmoke, 2];
	(unitBackpack _unit) addMagazineCargoGlobal [_glsmokealt2, 2];
	(unitBackpack _unit) addMagazineCargoGlobal [_glflare,4];
	(unitBackpack _unit) addMagazineCargoGlobal [_glflarealt,2];
	(unitBackpack _unit) addMagazineCargoGlobal [_grenade, 1];
	(unitBackpack _unit) addMagazineCargoGlobal [_smokegrenade, 2];
	(unitBackpack _unit) addMagazineCargoGlobal [_smokegrenadealt, 2];
};

// BACKPACK: AR
case "ar": {
	[_bagmedium,_unit] call f_fnc_addBackpack;
	(unitBackpack _unit) addMagazineCargoGlobal [_ARmag, 2];
	(unitBackpack _unit) addMagazineCargoGlobal [_ARmag_Tr, 1];
	(unitBackpack _unit) addMagazineCargoGlobal [_grenade, 1];
	(unitBackpack _unit) addMagazineCargoGlobal [_smokegrenade, 1];
};

// BACKPACK: AAR
case "aar": {
	[_bagmedium,_unit] call f_fnc_addBackpack;
	(unitBackpack _unit) addMagazineCargoGlobal [_riflemag, 2];
	(unitBackpack _unit) addMagazineCargoGlobal [_riflemag_tr, 1];
	(unitBackpack _unit) addMagazineCargoGlobal [_grenade, 1];
	(unitBackpack _unit) addMagazineCargoGlobal [_smokegrenade, 2];
	(unitBackpack _unit) addMagazineCargoGlobal [_ARmag, 2];
	(unitBackpack _unit) addMagazineCargoGlobal [_ARmag_tr, 1];
};

// BACKPACK: RIFLEMAN AT (RAT)
case "rat": {
	[_bagmedium,_unit] call f_fnc_addBackpack;
	(unitBackpack _unit) addMagazineCargoGlobal [_carbinemag, 2];
	(unitBackpack _unit) addMagazineCargoGlobal [_carbinemag_tr, 1];
	(unitBackpack _unit) addMagazineCargoGlobal [_grenade, 1];
	(unitBackpack _unit) addMagazineCargoGlobal [_smokegrenade, 2];
	if (!isNil "_RATmag") then { (unitBackpack _unit) addMagazineCargoGlobal [_RATmag, 3]; }; // RHS Single shot RPGs
};

// BACKPACK: RIFLEMAN AT (RPG)
case "rpg": {
	["rhs_rpg",_unit] call f_fnc_addBackpack;
	(unitBackpack _unit) addMagazineCargoGlobal [_MATmag1, 3];
	(unitBackpack _unit) addMagazineCargoGlobal [_MATmag2, 1];
};

// BACKPACK: DESIGNATED MARKSMAN (DM)
case "dm": {
	[_bagsmall,_unit] call f_fnc_addBackpack;
	(unitBackpack _unit) addMagazineCargoGlobal [_DMriflemag, 2];
	(unitBackpack _unit) addMagazineCargoGlobal [_grenade, 1];
	(unitBackpack _unit) addMagazineCargoGlobal [_smokegrenade, 2];
};

// BACKPACK: RIFLEMAN (R)
case "r": {
	[_bagsmall,_unit] call f_fnc_addBackpack;
	(unitBackpack _unit) addMagazineCargoGlobal [_riflemag, 2];
	(unitBackpack _unit) addMagazineCargoGlobal [_riflemag_tr, 1];
	(unitBackpack _unit) addMagazineCargoGlobal [_grenade, 1];
	(unitBackpack _unit) addMagazineCargoGlobal [_smokegrenade, 2];
};

// BACKPACK: CARABINEER (CAR)
case "car": {
	[_bagsmall,_unit] call f_fnc_addBackpack;
	(unitBackpack _unit) addMagazineCargoGlobal [_carbinemag, 2];
	(unitBackpack _unit) addMagazineCargoGlobal [_carbinemag_tr, 1];
	(unitBackpack _unit) addMagazineCargoGlobal [_grenade, 1];
	(unitBackpack _unit) addMagazineCargoGlobal [_smokegrenade, 2];
};

// BACKPACK: MMG GUNNER (MMG)
case "mmgg": {
	[_bagmedium,_unit] call f_fnc_addBackpack;
	(unitBackpack _unit) addMagazineCargoGlobal [_MMGmag, 2];
	(unitBackpack _unit) addMagazineCargoGlobal [_MMGmag_tr, 1];
	(unitBackpack _unit) addMagazineCargoGlobal [_smokegrenade, 1];
};

// BACKPACK: MMG ASSISTANT GUNNER (MMGAG)
case "mmgag": {
	[_bagmedium,_unit] call f_fnc_addBackpack;
	(unitBackpack _unit) addMagazineCargoGlobal [_MMGmag, 2];
	(unitBackpack _unit) addMagazineCargoGlobal [_MMGmag_tr, 2];
	(unitBackpack _unit) addMagazineCargoGlobal [_smokegrenade, 1];
};

// BACKPACK: HEAVY MG GUNNER (HMGG)
case "hmgg": {
	[_baghmgg,_unit] call f_fnc_addBackpack;
};

// BACKPACK: HEAVY MG ASSISTANT GUNNER (HMGAG)
case "hmgag": {
	[_baghmgag,_unit] call f_fnc_addBackpack;
};

// BACKPACK: MAT GUNNER (MATG)
case "matg": {
	[_bagmedium,_unit] call f_fnc_addBackpack;
	(unitBackpack _unit) addMagazineCargoGlobal [_MATmag1, 2];
	(unitBackpack _unit) addMagazineCargoGlobal [_MATmag2, 1];
	(unitBackpack _unit) addMagazineCargoGlobal [_carbinemag, 1];
	(unitBackpack _unit) addMagazineCargoGlobal [_carbinemag_tr, 1];
	(unitBackpack _unit) addMagazineCargoGlobal [_smokegrenade, 1];
};

// BACKPACK: MAT ASSISTANT (MATAG)
case "matag": {
	[_bagmedium,_unit] call f_fnc_addBackpack;
	(unitBackpack _unit) addMagazineCargoGlobal [_MATmag1, 2];
	(unitBackpack _unit) addMagazineCargoGlobal [_MATmag2, 1];
	(unitBackpack _unit) addMagazineCargoGlobal [_carbinemag, 1];
	(unitBackpack _unit) addMagazineCargoGlobal [_carbinemag_tr, 1];
	(unitBackpack _unit) addMagazineCargoGlobal [_smokegrenade, 2];
};

// LOADOUT: HEAVY AT GUNNER (HATG)
case "hatg": {
	[_baglarge,_unit] call f_fnc_addBackpack;
	(unitBackpack _unit) addMagazineCargoGlobal [_HATmag1, 3];
};

// LOADOUT: HEAVY AT ASSISTANT GUNNER (HATAG)
case "hatag": {
	[_baglarge,_unit] call f_fnc_addBackpack;
	(unitBackpack _unit) addMagazineCargoGlobal [_HATmag1, 3];
};

// BACKPACK: MORTAR GUNNER (MTRG)
case "mtrg": {
	[_bagmtrg,_unit] call f_fnc_addBackpack;
};

// BACKPACK: MORTAR ASSISTANT GUNNER (MTRAG)
case "mtrag": {
	[_bagmtrag,_unit] call f_fnc_addBackpack;
};

// BACKPACK: MEDIUM SAM GUNNER (MSAMG)
case "msamg": {
	[_baglarge,_unit] call f_fnc_addBackpack;
	(unitBackpack _unit) addMagazineCargoGlobal [_SAMmag, 2];
};

// BACKPACK: MEDIUM SAM ASSISTANT GUNNER (MSAMAG)
case "msamag": {
	[_baglarge,_unit] call f_fnc_addBackpack;
	(unitBackpack _unit) addMagazineCargoGlobal [_SAMmag, 2];
};

// BACKPACK: HEAVY SAM GUNNER (HSAMG)
case "hsamg": {
	[_baghsamg,_unit] call f_fnc_addBackpack;
};

// BACKPACK: HEAVY SAM ASSISTANT GUNNER (HSAMAG)
case "hsamag": {
	[_baghsamag,_unit] call f_fnc_addBackpack;
};

// BACKPACK: ENGINEER (DEMO)
case "eng": {
	[_baglarge,_unit] call f_fnc_addBackpack;
	(unitBackpack _unit) addItemCargoGlobal ["ToolKit",1];
	(unitBackpack _unit) addItemCargoGlobal ["SatchelCharge_Remote_Mag",1];
	(unitBackpack _unit) addItemCargoGlobal [_satchel,3];
};

// BACKPACK: ENGINEER (MINES)
case "engm": {
	[_baglarge,_unit] call f_fnc_addBackpack;
	(unitBackpack _unit) addItemCargoGlobal ["ToolKit",1];
	(unitBackpack _unit) addMagazineCargoGlobal [_ATmine,2];
};

// BACKPACK: SUBMACHINEGUNNER (SMG)
case "smg": {
	[_bagsmall,_unit] call f_fnc_addBackpack;
	(unitBackpack _unit) addMagazineCargoGlobal [_smgmag, 3];
	(unitBackpack _unit) addMagazineCargoGlobal [_grenade, 1];
	(unitBackpack _unit) addMagazineCargoGlobal [_smokegrenade, 2];
};

// BACKPACK: DIVER (DIV)
case "div": {
	[_bagmediumdiver,_unit] call f_fnc_addBackpack;
	(unitBackpack _unit) addMagazineCargoGlobal [_diverMag1, 1];
	(unitBackpack _unit) addMagazineCargoGlobal [_diverMag2, 1];
	(unitBackpack _unit) addMagazineCargoGlobal [_grenade, 1];
	(unitBackpack _unit) addMagazineCargoGlobal [_smokegrenade, 1];
};

// BACKPACK: AMMOBEARER
case "ammo": {
	[_baglarge,_unit] call f_fnc_addBackpack;
	(unitBackpack _unit) addMagazineCargoGlobal [_riflemag, 6];
	(unitBackpack _unit) addMagazineCargoGlobal [_riflemag_tr, 4];
	(unitBackpack _unit) addMagazineCargoGlobal [_glmag, 2];
	(unitBackpack _unit) addMagazineCargoGlobal [_glsmoke, 4];
	(unitBackpack _unit) addMagazineCargoGlobal [_glflare, 4];
	(unitBackpack _unit) addMagazineCargoGlobal [_ARmag_tr, 1];
	(unitBackpack _unit) addMagazineCargoGlobal [_MMGmag_tr, 1];
	(unitBackpack _unit) addMagazineCargoGlobal [_smokegrenade, 4];
	(unitBackpack _unit) addMagazineCargoGlobal [_smokegrenadealt, 4];
	if (!isNil "_RATmag") then { (unitBackpack _unit) addMagazineCargoGlobal [_RATmag, 1]; }; // RHS Single shot RPGs
};

// BACKPACK: UAV
case "uav": {
	[_baguav,_unit] call f_fnc_addBackpack;
};

// BACKPACK: CREW CHIEFS & VEHICLE DRIVERS
case "cc": {
	[_bagsmall,_unit] call f_fnc_addBackpack;
	(unitBackpack _unit) addItemCargoGlobal ["ToolKit",1];
};

// OTHERS
case "small": {
	[_bagsmall,_unit] call f_fnc_addBackpack;
};

case "medium": {
	[_bagmedium,_unit] call f_fnc_addBackpack;
};

case "large": {
	[_baglarge,_unit] call f_fnc_addBackpack;
};