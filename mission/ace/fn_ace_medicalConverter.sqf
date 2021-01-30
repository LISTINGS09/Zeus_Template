// F3 - Medical Systems ACE3 Advanced Medical System Converter
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================
if !isServer exitWith {}; // Server only

waitUntil{!isNil "f_var_medical_level"};

if (f_var_medical_level == 0 || !isClass(configFile >> "CfgPatches" >> "ace_main")) exitWith {}; // ACE not running so don't do anything more!

waitUntil{missionNamespace getVariable ["ace_common_settingsinitfinished",false]};

// DECLARE VARIABLES AND FUNCTIONS
private ["_itemCargoList","_cntFAK","_cntMediKit"];
params["_unit"];

if (!alive _unit) exitWith {}; // Nothing to convert.

// COUNT AMOUNT OF FAKS AND MEDIKITS
_itemCargoList = itemCargo _unit;
if (count _itemCargoList == 0) exitWith {}; // Nothing to convert.

_cntFAK = {_x == "FirstAidKit"} count _itemCargoList;
_cntMediKit = {_x == "MediKit"} count _itemCargoList;

if (_cntFAK + _cntMediKit == 0) exitWith {}; // Nothing to convert.

private _advMedical = missionNamespace getVariable ["ace_medical_treatment_advancedBandages", 0] == 1; // ACE Advanced Medical Setting

if (missionNamespace getVariable["f_param_debugMode",0] == 1) then { 
	["fn_ace_medicalConverter.sqf",format["Converting medical (ADV:%5) for %2 (%1 - F%3 M%4)", _unit, typeOf _unit, _cntFAK, _cntMediKit, _advMedical],"INFO"] call f_fnc_logIssue;
};

// REMOVE ALL VANILLA ITEMS
{
	if (_x == "FirstAidKit" || {_x == "MediKit"}) then { _itemCargoList = _itemCargoList - [_x] };
} forEach _itemCargoList;

clearItemCargoGlobal _unit;

{ _unit addItemCargoGlobal [_x,1] } forEach _itemCargoList;

// ADD BACK ACE3 ITEMS FOR REMOVED VANILLA ITEMS
_unit addItemCargoGlobal ["ACE_fieldDressing", (_cntFAK * 2)];

// Medic Specialist Equipment
if (_unit getVariable ["ace_medical_medicclass", getNumber (configFile >> "CfgVehicles" >> typeOf _unit >> "attendant")] > 0) then {	
	{	
		if (isClass (configFile >> "CfgWeapons" >> _x )) then { _unit addItemCargoGlobal [_x, _cntFAK * 3] };
	} forEach ["ACE_morphine", "ACE_epinephrine", "ACE_fieldDressing", "ACE_bloodIV_250", "ACE_bloodIV_500", "ACE_bloodIV", "ACE_bodyBag"];
	
	if ((missionNamespace getVariable ["ace_medical_fractures", 0]) > 0) then { _unit addItemCargoGlobal ["ACE_splint", 10]; };	
	
	if (_advMedical) then {
		{	
			if (isClass (configFile >> "CfgWeapons" >> _x )) then { _unit addItemCargoGlobal [_x, _cntFAK * 2] };
		} forEach ["ACE_tourniquet", "ACE_elasticBandage", "ACE_packingBandage", "ACE_quikclot"];
		
		{	
			if (isClass (configFile >> "CfgWeapons" >> _x )) then { _unit addItemCargoGlobal [_x, _cntFAK * 2] };
		} forEach ["ACE_plasmaIV_250", "ACE_plasmaIV_500", "ACE_plasmaIV", "ACE_salineIV_250", "ACE_salineIV_500", "ACE_salineIV"];
	};
	
	if ((missionNamespace getVariable ["ace_medical_treatment_locationPAK", 0]) != 4) then { _unit addItemCargoGlobal ["ACE_personalAidKit", 4 + _cntMediKit * 4]; };
	if ((missionNamespace getVariable ["ace_medical_treatment_locationSurgicalKit", 0]) != 4 && (missionNamespace getVariable ["ace_medical_treatment_woundReopening", false])) then { _unit addItemCargoGlobal ["ACE_surgicalKit", 4 + _cntMediKit * 4]; };
};

{	
	if (isClass (configFile >> "CfgWeapons" >> _x )) then { _unit addItemCargoGlobal [_x, _cntFAK * 2] };
} forEach ["ACE_morphine", "ACE_epinephrine", "ACE_fieldDressing", "ACE_bloodIV"];

if (_advMedical) then {
	{	
		if (isClass (configFile >> "CfgWeapons" >> _x )) then { _unit addItemCargoGlobal [_x, _cntFAK * 3] };
	} forEach ["ACE_tourniquet", "ACE_elasticBandage", "ACE_packingBandage", "ACE_quikclot", "ACE_salineIV_500"];
};

if ((missionNamespace getVariable ["ace_medical_fractures", 0]) > 0) then { _unit addItemCargoGlobal ["ACE_splint", 15]; };		
if ((missionNamespace getVariable ["ace_medical_treatment_locationPAK", 0]) != 4) then { _unit addItemCargoGlobal ["ACE_personalAidKit", 2 + _cntMediKit * 2]; };
if ((missionNamespace getVariable ["ace_medical_treatment_locationSurgicalKit", 0]) != 4 && (missionNamespace getVariable ["ace_medical_treatment_woundReopening", false])) then { _unit addItemCargoGlobal ["ACE_surgicalKit", 2 + _cntMediKit * 2]; };