// 	Zeus - VAS Option
//  Description: Allows players to quickly teleport to their team.
// ====================================================================================
if (missionNamespace getVariable["f_param_virtualArsenal",0] == 0 || !hasInterface || playerSide == sideLogic) exitWith {};

private ["_flagType","_flagMarker"];

_flagType = "Flag_White_F";
_flagMarker = "respawn_civilian";

switch (side (group player)) do {
	case west		: { _flagType = "Flag_Blue_F"; 	_flagMarker = "respawn_west"; };
	case east		: { _flagType = "Flag_Red_F"; 	_flagMarker = "respawn_east"; };
	case resistance	: { _flagType = "Flag_Green_F"; _flagMarker = "respawn_guerrila"; };
};

if (_flagMarker in allMapMarkers) then {
	if (isNil "f_obj_BaseFlag") then {
		f_obj_BaseFlag = _flagType createVehicleLocal [getMarkerPos _flagMarker select 0, (getMarkerPos _flagMarker select 1) - 5, 0];
		sleep 0.5;
		
		// Don't spawn on seabed.
		if (underwater f_obj_BaseFlag) then {
			f_obj_BaseFlag setPosASL [position f_obj_BaseFlag select 0,position f_obj_BaseFlag select 1,0];
			_flagStone = "Land_W_sharpStone_02" createVehicleLocal [0,0,0];
			_flagStone setPosASL [getMarkerPos _flagMarker select 0, (getMarkerPos _flagMarker select 1) - 5,-1];
		};
	};
		
	f_obj_BaseFlag addAction ["<t color='#007F00'>Virtual Arsenal</t>",{["Open",true] spawn BIS_fnc_arsenal}];
	f_obj_BaseFlag addAction ["<t color='#007F00'>Copy Leaders Uniform</t>",{ 		
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
	}];
} else {
	["f_VAS.sqf",format["No respawn marker found for VAS (%1).",side (group player)]] call f_fnc_logIssue;
};