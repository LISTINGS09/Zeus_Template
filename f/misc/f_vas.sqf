// 	Zeus - VAS Option
//  Description: Allows players to quickly teleport to their team.
// ====================================================================================
if !hasInterface exitWith {};

private _flagType = "Flag_White_F";
private _flagMarker = "respawn_civilian";

switch (side (group player)) do {
	case west		: { _flagType = "Flag_Blue_F"; 	_flagMarker = "respawn_west"; };
	case east		: { _flagType = "Flag_Red_F"; 	_flagMarker = "respawn_east"; };
	case resistance	: { _flagType = "Flag_Green_F"; _flagMarker = "respawn_guerrila"; };
};

if (_flagMarker in allMapMarkers) then {
	if (isNil "f_obj_spawnFlag") then {
		private _mrkPos = getMarkerPos _flagMarker;
		_mrkPos set [2,0];
		
		f_obj_spawnFlag = _flagType createVehicleLocal _mrkPos;
		sleep 0.1;
		
		// Don't spawn on seabed.
		if (underwater f_obj_spawnFlag) then {
			private _flagStone = "Land_W_sharpStone_02" createVehicleLocal [0,0,0];		
			_flagStone setPosASL [_mrkPos#0,_mrkPos#1,-1];
			f_obj_spawnFlag setPosASL (lineIntersectsSurfaces [_mrkPos vectorAdd [0,0,1000], AGLToASL _mrkPos] #0 #0);
		};
	};
	
	// Get Server Admin List
	private _incAdmin = false;
	private _uidList = ["76561197970695190"]; // 2600K
	if (!isNil "f_var_AuthorUID") then { _uidList pushBack f_var_AuthorUID };
	if (!isNil "f_zeusAdminNames") then { if (f_zeusAdminNames isEqualType []) then { _uidList append f_zeusAdminNames }; };

	// Check if player is authorised admin (or 2600K) ;)
	if ((getPlayerUID player) in _uidList) then { _incAdmin = true;};

	if (missionNamespace getVariable ['f_param_virtualArsenal',0] == 0 && (serverCommandAvailable "#kick" || _incAdmin || !isMultiplayer)) then {
		f_obj_spawnFlag addAction ["<t color='#CCCCCC'>Lock Virtual Arsenal (Admin)</t>", { missionNamespace setVariable ['f_param_virtualArsenal', 0, true] }, nil, 0.5, true, true, "", "missionNamespace getVariable ['f_param_virtualArsenal',0] != 0"];
		f_obj_spawnFlag addAction ["<t color='#CCCCCC'>Unlock Virtual Arsenal (Admin)</t>", { missionNamespace setVariable ['f_param_virtualArsenal', 1, true] }, nil, 0.5, true, true, "", "missionNamespace getVariable ['f_param_virtualArsenal',0] == 0"];
	};
	
	if (missionNamespace getVariable ['f_param_virtualGarage',0] == 0 && (serverCommandAvailable "#kick" || _incAdmin || !isMultiplayer)) then {
		f_obj_spawnFlag addAction ["<t color='#CCCCCC'>Lock Virtual Garage (Admin)</t>", { missionNamespace setVariable ['f_param_virtualGarage', 0, true] }, nil, 0.5, true, true, "", "missionNamespace getVariable ['f_param_virtualGarage',0] != 0"];
		f_obj_spawnFlag addAction ["<t color='#CCCCCC'>Unlock Virtual Garage (Admin)</t>", { missionNamespace setVariable ['f_param_virtualGarage', 1, true] }, nil, 0.5, true, true, "", "missionNamespace getVariable ['f_param_virtualGarage',0] == 0"];
	};
	
	f_obj_spawnFlag addAction ["<t color='#0080FF'>Virtual Garage</t>", { if (!isNil "ZEU_fnc_StartVirtualGarage") then { [] spawn ZEU_fnc_StartVirtualGarage } else { systemChat "[VG] Check the briefing to set Virtual Garage spawn point"; [] execVM "f\misc\f_virtualGarage.sqf"; }}, nil, 1.4, true, true, "", "missionNamespace getVariable ['f_param_virtualGarage',0] != 0 OR serverCommandAvailable '#kick'"];	
	f_obj_spawnFlag addAction ["<t color='#FF8000'>Virtual Arsenal</t>", {["Open",true] spawn BIS_fnc_arsenal}, nil, 1.6, true, true, "", "missionNamespace getVariable ['f_param_virtualArsenal',0] != 0 OR serverCommandAvailable '#kick'"];
	
	// TODO: Add ability to choose traits
	
	f_obj_spawnFlag addAction ["<t color='#FF8000'>Create Gear Guide</t>", {
		private _create = false;
		
		if (isNil "f_obj_gearGuide") then {
			_create = true
		} else {;
			if (!alive f_obj_gearGuide) then { deleteVehicle f_obj_gearGuide; _create = true };
		};
		
		if (_create) then {
			private _agent = createAgent ["C_Soldier_VR_F", getPosATL f_obj_spawnFlag, [], 2, "NONE"];
			_agent allowDamage false;
			_agent disableAI "ALL";
			missionNamespace setVariable ["f_obj_gearGuide", _agent, true];
		};
		
		removeAllWeapons f_obj_gearGuide;
		removeAllItems f_obj_gearGuide;
		removeAllAssignedItems f_obj_gearGuide;
		removeUniform f_obj_gearGuide;
		removeVest f_obj_gearGuide;
		removeBackpackGlobal f_obj_gearGuide;
		removeHeadgear f_obj_gearGuide;
		removeGoggles f_obj_gearGuide;
		
		f_obj_gearGuide forceAddUniform uniform player;
		f_obj_gearGuide addVest vest player; 
		f_obj_gearGuide addBackpackGlobal backpack player; 
		f_obj_gearGuide addHeadgear headgear player;
		f_obj_gearGuide addWeapon primaryWeapon player;
	}, nil, 1.5, true, true, "", "missionNamespace getVariable ['f_param_virtualArsenal',0] != 0 OR serverCommandAvailable '#kick'"];
	
	f_obj_spawnFlag addAction ["<t color='#007F00'>Copy Guide Uniform</t>",{ 		
		if (uniform f_obj_gearGuide != uniform player && uniform f_obj_gearGuide != "") then {
			private _mag = magazineCargo uniformContainer player;
			private _itm = itemCargo uniformContainer player;
			removeUniform player;
			player forceAddUniform uniform f_obj_gearGuide; 
			{ uniformContainer player addMagazineCargoGlobal [_x,1] } forEach _mag;
			{ uniformContainer player addItemCargoGlobal [_x,1] } forEach _itm;
		};
		if (vest f_obj_gearGuide != vest player && vest f_obj_gearGuide != "") then {
			private _mag = magazineCargo vestContainer player;
			private _itm = itemCargo vestContainer player;
			removeVest player;
			player addVest vest f_obj_gearGuide; 
			{ vestContainer player addMagazineCargoGlobal [_x,1] } forEach _mag;
			{ vestContainer player addItemCargoGlobal [_x,1] } forEach _itm;
		};
		if (backpack f_obj_gearGuide != backpack player && backpack f_obj_gearGuide != "") then {
			private _mag = magazineCargo backpackContainer player;
			private _itm = itemCargo backpackContainer player;
			removeBackpackGlobal player;
			player addBackpackGlobal backpack f_obj_gearGuide; 
			{ backpackContainer player addMagazineCargoGlobal [_x,1] } forEach _mag;
			{ backpackContainer player addItemCargoGlobal [_x,1] } forEach _itm;
		};
		if (headgear f_obj_gearGuide != headgear player) then {
			removeHeadgear player;
			player addHeadgear headgear f_obj_gearGuide;
		};
		systemChat "Copied Uniform from Guide";
	}, nil, 1.5, true, true, "", "!isNil 'f_obj_gearGuide' && alive f_obj_gearGuide"];
	
	
	f_obj_spawnFlag addAction ["<t color='#007F00'>Copy Leaders Uniform</t>",{ 		
		if (uniform leader player != uniform player  && uniform leader player != "") then {
			private _mag = magazineCargo uniformContainer player;
			private _itm = itemCargo uniformContainer player;
			removeUniform player;
			player forceAddUniform uniform leader player; 
			{ uniformContainer player addMagazineCargoGlobal [_x,1] } forEach _mag;
			{ uniformContainer player addItemCargoGlobal [_x,1] } forEach _itm;
		};
		if (vest leader player != vest player && vest leader player != "") then {
			private _mag = magazineCargo vestContainer player;
			private _itm = itemCargo vestContainer player;
			removeVest player;
			player addVest vest leader player; 
			{ vestContainer player addMagazineCargoGlobal [_x,1] } forEach _mag;
			{ vestContainer player addItemCargoGlobal [_x,1] } forEach _itm;
		};
		if (backpack leader player != backpack player && backpack leader player != "") then {
			private _mag = magazineCargo backpackContainer player;
			private _itm = itemCargo backpackContainer player;
			removeBackpackGlobal player;
			player addBackpackGlobal backpack leader player; 
			{ backpackContainer player addMagazineCargoGlobal [_x,1] } forEach _mag;
			{ backpackContainer player addItemCargoGlobal [_x,1] } forEach _itm;
		};
		if (headgear leader player != headgear player) then {
			removeHeadgear player;
			player addHeadgear headgear leader player;
		};
		
		systemChat format["Copied Uniform from %1", name leader player];
	}, nil, 1.5, true, true, "", "missionNamespace getVariable ['f_param_virtualArsenal',0] != 0"];
} else {
	if (_flagMarker != "respawn_civilian") then { ["f_VAS.sqf",format["No respawn marker found for VAS (%1).",side (group player)]] call f_fnc_logIssue };
};