// CARGO: CAR - room for 10 weapons and 50 cargo items
case "v_car":
{
	clearWeaponCargoGlobal _unit;
	clearMagazineCargoGlobal _unit;
	clearItemCargoGlobal _unit;
	clearBackpackCargoGlobal _unit;
	_unit addItemCargoGlobal ["ToolKit",1];
	_unit addItemCargoGlobal [([_binos1,true] call f_fnc_arrayCheck),1];
	_unit addWeaponCargoGlobal [([_carbine,true] call f_fnc_arrayCheck), 1];
	_unit addMagazineCargoGlobal [_riflemag, 4];
	_unit addMagazineCargoGlobal [_riflemag_tr, 4];
	_unit addMagazineCargoGlobal [_glriflemag, 4];
	_unit addMagazineCargoGlobal [_glriflemag_tr, 4];
	_unit addMagazineCargoGlobal [_carbinemag, 2];
	_unit addMagazineCargoGlobal [_carbinemag_tr, 8];
	_unit addMagazineCargoGlobal [_smgmag_tr, 2];
	_unit addMagazineCargoGlobal [_armag, 1];
	_unit addMagazineCargoGlobal [_armag_tr, 2];
	_unit addMagazineCargoGlobal [_MMGmag_tr, 2];
	_unit addMagazineCargoGlobal [_satchel, 2];
	if (isNil "_RATmag") then {_unit addWeaponCargoGlobal [([_rat,true] call f_fnc_arrayCheck),1]} else {_unit addMagazineCargoGlobal [_RATmag,1]}; // RHS Single shot RPGs
	_unit addMagazineCargoGlobal [_grenade, 4];
	_unit addMagazineCargoGlobal [_smokegrenade, 4];
	_unit addMagazineCargoGlobal [_smokegrenadealt, 2];
	_unit addMagazineCargoGlobal [_chem, 4];
	_unit addMagazineCargoGlobal [_glmag, 4];
	_unit addMagazineCargoGlobal [_glsmoke, 4];
	_unit addMagazineCargoGlobal [_glflare, 8];
	_unit addItemCargoGlobal [_firstaid,4];
};

// CARGO: TRUCK - room for 50 weapons and 200 cargo items
case "v_tr":
{
	clearWeaponCargoGlobal _unit;
	clearMagazineCargoGlobal _unit;
	clearItemCargoGlobal _unit;
	clearBackpackCargoGlobal _unit;
	_unit addItemCargoGlobal ["ToolKit",1];
	_unit addItemCargoGlobal [([_binos1,true] call f_fnc_arrayCheck),1];
	_unit addWeaponCargoGlobal [([_carbine,true] call f_fnc_arrayCheck), 2];	
	_unit addMagazineCargoGlobal [_riflemag, 8];
	_unit addMagazineCargoGlobal [_riflemag_tr, 4];
	_unit addMagazineCargoGlobal [_glriflemag, 8];
	_unit addMagazineCargoGlobal [_glriflemag_tr, 4];
	_unit addMagazineCargoGlobal [_carbinemag, 8];
	_unit addMagazineCargoGlobal [_carbinemag_tr, 4];
	_unit addMagazineCargoGlobal [_smgmag, 2];
	_unit addMagazineCargoGlobal [_armag, 2];
	_unit addMagazineCargoGlobal [_armag_tr, 4];
	_unit addMagazineCargoGlobal [_MMGmag, 2];
	_unit addMagazineCargoGlobal [_MMGmag_tr, 2];
	_unit addMagazineCargoGlobal [_satchel, 4];
	if (isNil "_RATmag") then {_unit addWeaponCargoGlobal [([_rat,true] call f_fnc_arrayCheck),4]} else {_unit addMagazineCargoGlobal [_RATmag,4]}; // RHS Single shot RPGs
	_unit addMagazineCargoGlobal [_MATmag1, 2];		
	_unit addMagazineCargoGlobal [_grenade, 12];
	_unit addmagazineCargoGlobal [_grenadealt,8];
	_unit addMagazineCargoGlobal [_smokegrenade, 12];
	_unit addMagazineCargoGlobal [_smokegrenadealt, 4];
	_unit addMagazineCargoGlobal [_chem, 12];
	_unit addMagazineCargoGlobal [_glmag, 6];
	_unit addMagazineCargoGlobal [_glsmoke, 8];
	_unit addMagazineCargoGlobal [_glflare, 16];
	_unit addItemCargoGlobal [_firstaid,8];
};

// CARGO: IFV - room for 10 weapons and 100 cargo items
case "v_ifv":
{
	clearWeaponCargoGlobal _unit;
	clearMagazineCargoGlobal _unit;
	clearItemCargoGlobal _unit;
	clearBackpackCargoGlobal _unit;
	_unit addItemCargoGlobal ["ToolKit",1];
	_unit addItemCargoGlobal [([_binos1,true] call f_fnc_arrayCheck),2];
	_unit addWeaponCargoGlobal [([_carbine,true] call f_fnc_arrayCheck), 2];
	_unit addMagazineCargoGlobal [_riflemag, 8];
	_unit addMagazineCargoGlobal [_riflemag_tr, 6];
	_unit addMagazineCargoGlobal [_glriflemag, 8];
	_unit addMagazineCargoGlobal [_glriflemag_tr, 6];
	_unit addMagazineCargoGlobal [_carbinemag, 8];
	_unit addMagazineCargoGlobal [_carbinemag_tr, 6];
	_unit addMagazineCargoGlobal [_smgmag, 2];
	_unit addMagazineCargoGlobal [_armag, 1];
	_unit addMagazineCargoGlobal [_armag_tr, 3];
	_unit addMagazineCargoGlobal [_MMGmag, 1];
	_unit addMagazineCargoGlobal [_MMGmag_tr, 1];
	_unit addMagazineCargoGlobal [_satchel, 4];
	if (isNil "_RATmag") then {_unit addWeaponCargoGlobal [([_rat,true] call f_fnc_arrayCheck),2]} else {_unit addMagazineCargoGlobal [_RATmag,2]}; // RHS Single shot RPGs
	_unit addMagazineCargoGlobal [_MATmag1, 1];
	_unit addMagazineCargoGlobal [_grenade, 8];
	_unit addmagazineCargoGlobal [_grenadealt,6];
	_unit addMagazineCargoGlobal [_smokegrenade, 8];
	_unit addMagazineCargoGlobal [_smokegrenadealt, 2];
	_unit addMagazineCargoGlobal [_chem, 8];
	_unit addMagazineCargoGlobal [_glmag, 4];
	_unit addMagazineCargoGlobal [_glsmoke, 6];
	_unit addMagazineCargoGlobal [_glflare, 12];
	_unit addItemCargoGlobal [_firstaid,6];
};

// CRATE: Small, ammo for 1 fireteam
case "crate_small":
{
	clearWeaponCargoGlobal _unit;
	clearMagazineCargoGlobal _unit;
	clearItemCargoGlobal _unit;
	clearBackpackCargoGlobal _unit;
	_unit addItemCargoGlobal ["ToolKit",1];
	_unit addItemCargoGlobal [([_binos1,true] call f_fnc_arrayCheck),2];
	_unit addMagazineCargoGlobal [_riflemag, 5];
	_unit addMagazineCargoGlobal [_glriflemag_tr, 5];
	_unit addMagazineCargoGlobal [_armag, 5];
	_unit addMagazineCargoGlobal [_glmag, 5];
	_unit addMagazineCargoGlobal [_glsmoke, 4];
	_unit addMagazineCargoGlobal [_satchel, 2];
	if (isNil "_RATmag") then {_unit addWeaponCargoGlobal [([_rat,true] call f_fnc_arrayCheck),1]} else {_unit addMagazineCargoGlobal [_RATmag,2]}; // RHS Single shot RPGs
	_unit addMagazineCargoGlobal [_grenade, 8];
	_unit addMagazineCargoGlobal [_smokegrenade, 8];
	_unit addMagazineCargoGlobal [_smokegrenadealt, 2];
	_unit addMagazineCargoGlobal [_glflare,10];
	_unit addMagazineCargoGlobal [_chem, 8];
	_unit addItemCargoGlobal [_firstaid, 6];
};

// CRATE: Medium, ammo for 1 squad
case "crate_med":
{
	clearWeaponCargoGlobal _unit;
	clearMagazineCargoGlobal _unit;
	clearItemCargoGlobal _unit;
	clearBackpackCargoGlobal _unit;
	_unit addItemCargoGlobal ["ToolKit",1];
	_unit addItemCargoGlobal [([_binos1,true] call f_fnc_arrayCheck),4];
	_unit addMagazineCargoGlobal [_riflemag, 6];
	_unit addMagazineCargoGlobal [_riflemag_tr, 4];
	_unit addMagazineCargoGlobal [_glriflemag, 6];
	_unit addMagazineCargoGlobal [_glriflemag_tr, 4];
	_unit addMagazineCargoGlobal [_carbinemag, 6];
	_unit addMagazineCargoGlobal [_carbinemag_tr, 4];
	_unit addMagazineCargoGlobal [_smgmag, 2];
	_unit addMagazineCargoGlobal [_armag, 2];
	_unit addMagazineCargoGlobal [_armag_tr, 2];
	_unit addMagazineCargoGlobal [_MMGmag, 2];
	_unit addMagazineCargoGlobal [_MMGmag_tr, 2];
	_unit addMagazineCargoGlobal [_satchel, 4];
	_unit addMagazineCargoGlobal [_glmag, 16];
	_unit addMagazineCargoGlobal [_glsmoke,16];
	_unit addMagazineCargoGlobal [_satchel, 4];
	if (isNil "_RATmag") then {_unit addWeaponCargoGlobal [([_rat,true] call f_fnc_arrayCheck),4]} else {_unit addMagazineCargoGlobal [_RATmag,6]}; // RHS Single shot RPGs
	_unit addMagazineCargoGlobal [_grenade, 12];
	_unit addMagazineCargoGlobal [_smokegrenade, 16];
	_unit addMagazineCargoGlobal [_smokegrenadealt, 8];
	_unit addMagazineCargoGlobal [_glflare,24];
	_unit addMagazineCargoGlobal [_chem, 8];
	_unit addItemCargoGlobal [_firstaid, 25];
};

// CRATE: Large, ammo for 1 platoon
case "crate_large":
{
	clearWeaponCargoGlobal _unit;
	clearMagazineCargoGlobal _unit;
	clearItemCargoGlobal _unit;
	clearBackpackCargoGlobal _unit;
	_unit addItemCargoGlobal ["ToolKit",1];
	_unit addItemCargoGlobal [([_binos1,true] call f_fnc_arrayCheck),8];
	_unit addMagazineCargoGlobal [_riflemag, 8];
	_unit addMagazineCargoGlobal [_riflemag_tr, 8];
	_unit addMagazineCargoGlobal [_glriflemag, 8];
	_unit addMagazineCargoGlobal [_glriflemag_tr, 8];
	_unit addMagazineCargoGlobal [_carbinemag, 8];
	_unit addMagazineCargoGlobal [_carbinemag_tr, 8];
	_unit addMagazineCargoGlobal [_smgmag, 4];
	_unit addMagazineCargoGlobal [_armag, 4];
	_unit addMagazineCargoGlobal [_armag_tr, 4];
	_unit addMagazineCargoGlobal [_MMGmag, 4];
	_unit addMagazineCargoGlobal [_MMGmag_tr, 4];
	_unit addMagazineCargoGlobal [_satchel, 4];
	_unit addMagazineCargoGlobal [_glmag, 24];
	_unit addMagazineCargoGlobal [_glsmoke,24];
	_unit addMagazineCargoGlobal [_satchel, 8];
	if (isNil "_RATmag") then {_unit addWeaponCargoGlobal [([_rat,true] call f_fnc_arrayCheck),6]} else {_unit addMagazineCargoGlobal [_RATmag,8]}; // RHS Single shot RPGs
	_unit addMagazineCargoGlobal [_grenade, 20];
	_unit addMagazineCargoGlobal [_smokegrenade, 20];
	_unit addMagazineCargoGlobal [_smokegrenadealt, 10];
	_unit addMagazineCargoGlobal [_glflare,25];
	_unit addMagazineCargoGlobal [_chem, 20];
	_unit addItemCargoGlobal [_firstaid, 75];
};