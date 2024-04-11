// v1.1 by 2600K
// Radiation script applies effect and damages player
// Can be reversed so 'hazard areas' become safe zones and the entire world is radioactive.
// _nul = [TR_AREA_1,TR_AREA_2] execVM "scripts\radiation_area.sqf";
//
// To include a zone mid-mission (server side)
// missionNamespace setVariable ["ZRA_Areas", (missionNamespace getVariable ["ZRA_Areas",[]]) + [TR_AREA_1], true];
ZRA_version = 1.2;
if !hasInterface exitWith {};

sleep 1;

// Variables
if (isNil "ZRA_Damage") then { ZRA_Damage = 0.05 }; // Base damage per loop
if (isNil "ZRA_Loop") then { ZRA_Loop = true };
if (isNil "ZRA_Debug") then { ZRA_Debug = false };
if (isNil "ZRA_Timer") then { ZRA_Timer = 5 };

// If this has already been called, just add the supplied zones.
if !(isNil "ZRA_Areas") exitWith { 
	ZRA_Loop = true;
	
	{
		if (_x isEqualType "") then { 
			if (getMarkerType _x != "") then {
				ZRA_Areas pushBackUnique _x;
			} else {
				["ERROR",format["Marker %1 was not found in mission!", _x]] call ZRA_logIssue;
			};
		};
		if (_x isEqualType objNull) then { 
			if ((missionNamespace getVariable [str _x, objNull]) != objNull) then {
				ZRA_Areas pushBackUnique _x;
			} else {
				["ERROR",format["Object %1 was not found in mission!", str _x]] call ZRA_logIssue;
			};
		};
	} forEach _this;
};

// Functions
ZRA_getPlayerPPE = {
	// Players protection value to counter damage
	_protection = 0;
	
	// Protective Classes
	_ppeEyes = ["gm_ge_facewear_m65","gm_gc_army_facewear_schm41m","G_RegulatorMask_F","G_AirPurifyingRespirator_01_F","G_AirPurifyingRespirator_01_nofilter_F","G_AirPurifyingRespirator_02_black_F","G_AirPurifyingRespirator_02_olive_F","G_AirPurifyingRespirator_02_sand_F"]; // Goggles
	_ppeHead = ["H_HelmetO_ViperSP_hex_F","H_HelmetO_ViperSP_ghex_F"]; // Helmet
	_ppeVest = ["V_RebreatherIA","V_RebreatherIR","V_RebreatherB"]; // Vest
	_ppeBody = ["U_C_CBRN_Suit_01_Blue_F","U_B_CBRN_Suit_01_MTP_F","U_B_CBRN_Suit_01_Tropic_F","U_C_CBRN_Suit_01_White_F","U_B_CBRN_Suit_01_Wdl_F","U_I_CBRN_Suit_01_AAF_F","U_I_E_CBRN_Suit_01_EAF_F"]; // Uniforms
	_ppeBack = ["B_CombinationUnitRespirator_01_F","B_SCBA_01_F"]; // Backpacks

	// Protection Values
	_ppeEyesValue = 1;
	_ppeHeadValue = 1;
	_ppeVestValue = 0.6;
	_ppeBodyValue = 0.6;
	_ppeBackValue = 0.8;
			
	// If player is wearing any suitable kit, add the values
	{
		_x params [["_checklist",[]],["_value",0],["_wearing",""]];
		if (toLower _wearing in (_checklist apply { toLower _x })) then { _protection = _protection + _value };
	} forEach [
		[_ppeEyes, _ppeEyesValue, goggles player]
		,[_ppeHead, _ppeHeadValue, headgear player]
		,[_ppeVest, _ppeVestValue, vest player]
		,[_ppeBody, _ppeBodyValue, uniform player]
		,[_ppeBack, _ppeBackValue, backpack player]
	];
	
	// Apply protection if player is in vehicle
	if (vehicle player != player) then {
		 _protection = _protection + 1;
	};

	_protection
};

ZRA_logIssue = {
	params [["_lev", ""], ["_msg", ""]];
	if (ZRA_Debug || _lev != "DEBUG") then { 
		systemChat format["[ZRA] %1: %2",_lev, _msg];
		diag_log text format["[ZRA] %1: %2",_lev, _msg];
	};
};

// CORE SCRIPT - No need to change anything beyond this point!

// Get a list of valid Hazard Zones
ZRA_Areas = [];

{
	if (_x isEqualType "") then { 
		if (getMarkerType _x != "") then {
			ZRA_Areas pushBackUnique _x;
		} else {
			["ERROR",format["Marker %1 was not found in mission!", _x]] call ZRA_logIssue;
		};
	};
	if (_x isEqualType objNull) then { 
		if ((missionNamespace getVariable [str _x, objNull]) != objNull) then {
			ZRA_Areas pushBackUnique _x;
		} else {
			["ERROR",format["Object %1 was not found in mission!", str _x]] call ZRA_logIssue;
		};
	};
} forEach _this;

// Set-up Screen Effects
ZRA_ppGrain = ppEffectCreate ["FilmGrain", 23];
ZRA_ppGrain ppEffectAdjust [0, 0, 0, 0, 0];
ZRA_ppGrain ppEffectCommit 0;
ZRA_ppGrain ppEffectEnable true;

ZRA_ppBlur = ppEffectCreate ["DynamicBlur", 24];
ZRA_ppBlur ppEffectAdjust [0];
ZRA_ppBlur ppEffectCommit 0;
ZRA_ppBlur ppEffectEnable true;

ZRA_ppColor = ppEffectCreate ["ColorCorrections", 25];
ZRA_ppColor ppEffectAdjust [1, 1, 0, [0, 0, 0, 0], [0, 0, 0, 1], [0, 0, 0, 0]];
ZRA_ppColor ppEffectCommit 0;
ZRA_ppColor ppEffectEnable true;

// MAIN LOOP
["DEBUG",format["Zones Present: %1", count ZRA_Areas]] call ZRA_logIssue;
["DEBUG",format["Protection value: %1", call ZRA_getPlayerPPE]] call ZRA_logIssue;

[] spawn {
	sleep ZRA_Timer;
	
	while {ZRA_Loop} do {	
		_inArea = (ZRA_Areas findIf { player inArea _x }) >= 0;

		if (alive player && _inArea) then {
			// Player is inside a zone
			["DEBUG","Radiation: ACTIVE"] call ZRA_logIssue;
			
			// Calculate PPE
			_protection = call ZRA_getPlayerPPE;
			
			// Calculate Rads
			_damage = if (_protection < 1) then { ZRA_Damage * (1 - _protection) } else { 0 };
			_percent = round ((_damage / ZRA_Damage) * 100);

			// Apply Effects
			if (alive player) then {
				["DEBUG", format ["Protection: %1  Radiation: %2 (%3%)", _protection, _damage, _percent]] call ZRA_logIssue;
				
				if (_percent >= 90) then {
					ZRA_ppBlur ppEffectAdjust [1];
					ZRA_ppBlur ppEffectCommit 3;
				} else {
					ZRA_ppBlur ppEffectAdjust [0];
					ZRA_ppBlur ppEffectCommit 3;
				};

				// ?? Tones
				ZRA_ppColor ppEffectAdjust [
					1, // brightness
					1, // contrast
					0, // offset
					[0, 1, 0, 0.1], // [blendR, blendG, blendB, blendA]
					[0, 1, 0, 0.9], // [colorizeR, colorizeG, colorizeB, colorizeA]
					[0, 0, 0, 0] // [weightR, weightG, weightB, 0]
				]; 
				ZRA_ppColor ppEffectCommit 3;

				ZRA_ppGrain ppEffectAdjust [
					0.15, // intensity
					0.15, // sharpness
					0.5, // grainSize
					0.2, // intensityX0
					0, // intensityX1
					0 // monochromatic
				];
				ZRA_ppGrain ppEffectCommit 3;

				// Assign Damage
				if (_damage > 0) then {
					if ("ace_main" in activatedAddons) then {
						[player, _damage, "Body"] call ace_medical_fnc_addDamageToUnit;
					} else {
						player setDamage (getDammage player) + _damage;
					};
					_rand = (floor random 18) + 1;
					_sound = format["A3\sounds_f\characters\human-sfx\P%1\Soundbreathinjured_Max_%2.wss", format["0%1",_rand] select [(count format["0%1",_rand]) - 2,2], (floor random 3) + 1];
					playSound3D [_sound, player, false, getPosASL player, 1.5, 1, 50];
				} else {
					if (goggles player != "") then {
						_sound = format["a3\sounds_f\characters\human-sfx\p%1\water_breath_0%2.wss", format["0%1",_rand] select [(count format["0%1",_rand]) - 2,2], (floor random 5) + 1];
						playSound3D [_sound, player, false, getPosASL player, 1, 1 + random 0.2, 25];
					};
				};
			};
		} else {
			// Player is outside of zone
			["DEBUG","Radiation: INACTIVE"] call ZRA_logIssue;

			// Remove Effects
			ZRA_ppBlur ppEffectAdjust [0];
			ZRA_ppBlur ppEffectCommit 1;
			ZRA_ppColor ppEffectAdjust [1, 1, 0, [0, 0, 0, 0], [0, 0, 0, 1], [0, 0, 0, 0]];
			ZRA_ppColor ppEffectCommit 1;
			ZRA_ppGrain ppEffectAdjust [0, 0, 0, 0, 0];
			ZRA_ppGrain ppEffectCommit 1;
		};
		
		sleep ZRA_Timer;
	};
};