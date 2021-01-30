// F3 - ACE Advanced Clientside Initialisation
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
if (missionNamespace getVariable["f_param_debugMode",0] == 1) then { 
	["ace_clientInit.sqf",format["Starting for %1",player],"INFO"] call f_fnc_logIssue;
};

// Wait for gear assignation to take place.
_timeUntil = time + 5;
waitUntil{(player getVariable ["f_var_assignGear_done", false]) || time > _timeUntil};

// Wait for ACE to finish setting up.
waitUntil{missionNamespace getVariable ["ace_common_settingsinitfinished",false]};

_typeofUnit = player getVariable ["f_var_assignGear", "r"];

// Remove pre-assigned medical items
{player removeItems _x} forEach ["FirstAidKit","Medikit","ACE_tourniquet","ACE_fieldDressing","ACE_morphine","ACE_epinephrine","ACE_packingBandage","ACE_salineIV_250"];

// Add basic items to all units
(uniformContainer player) addItemCargoGlobal ["ACE_CableTie",4];
(uniformContainer player) addItemCargoGlobal ["ACE_fieldDressing",8];
(uniformContainer player) addItemCargoGlobal ["ACE_morphine",2];
(uniformContainer player) addItemCargoGlobal ["ACE_tourniquet",1];
if (missionNamespace getVariable ["ace_medical_treatment_advancedBandages", 0] == 1) then { (uniformContainer player) addItemCargoGlobal ["ACE_elasticBandage",8]; };

player setVariable ["ACE_hasEarPlugsIn", true, true];
player removeItem "ACE_EarPlugs";
player addEventHandler ["Respawn", { player setVariable ["ACE_hasEarPlugsIn", true] }];

if (_typeofUnit == "m" || (player getUnitTrait "medic")) then {
	player setVariable ["ACE_IsMedic",1];
	(unitBackpack player) addItemCargoGlobal ["ACE_fieldDressing", 10];
	(unitBackpack player) addItemCargoGlobal ["ACE_morphine", 16];
	(unitBackpack player) addItemCargoGlobal ["ACE_epinephrine", 10];
	(unitBackpack player) addItemCargoGlobal ["ACE_tourniquet", 4];
	
	if ((missionNamespace getVariable ["ace_medical_fractures", 0]) > 0) then { (unitBackpack player) addItemCargoGlobal ["ACE_splint", 6]; };	// Fractures
	if ((missionNamespace getVariable ["ace_medical_treatment_locationPAK", 0]) != 4) then { (unitBackpack player) addItemCargoGlobal ["ACE_personalAidKit", 2]; }; // PAKs
	if ((missionNamespace getVariable ["ace_medical_treatment_locationSurgicalKit", 0]) != 4 && (missionNamespace getVariable ["ace_medical_treatment_woundReopening", false])) then { (unitBackpack player) addItemCargoGlobal ["ACE_surgicalKit", 1] }; // Wound Reopening
	if (missionNamespace getVariable ["ace_medical_treatment_advancedMedication", false]) then { (unitBackpack player) addItemCargoGlobal ["ACE_adenosine", 10]; }; // Advanced Medication
	
	// Advanced Bandages
	if (missionNamespace getVariable ["ace_medical_treatment_advancedBandages", 0] == 1) then {
		(unitBackpack player) addItemCargoGlobal ["ACE_elasticBandage", 30];
		(unitBackpack player) addItemCargoGlobal ["ACE_quikclot", 15];
		(unitBackpack player) addItemCargoGlobal ["ACE_packingBandage", 15];
		(unitBackpack player) addItemCargoGlobal ["ACE_salineIV_250", 6];
		(unitBackpack player) addItemCargoGlobal ["ACE_salineIV_500", 6];
		(unitBackpack player) addItemCargoGlobal ["ACE_salineIV", 4];
	} else {
		(unitBackpack player) addItemCargoGlobal ["ACE_fieldDressing", 20];
		(unitBackpack player) addItemCargoGlobal ["ACE_bloodIV_250", 6];
		(unitBackpack player) addItemCargoGlobal ["ACE_bloodIV_500", 6];
		(unitBackpack player) addItemCargoGlobal ["ACE_bloodIV", 4];
	};
};

if ("ACE_Vector" in (items player + assignedItems player)) then {
	player addItem "ACE_microDAGR";
	(unitBackpack player) addItemCargoGlobal ["ACE_fieldDressing", 10];
};

if (_typeofUnit in ["vc","vd","vg","pp","pc"]) then {
	player setVariable ["ACE_IsEngineer",1];
};

if (_typeofUnit == "eng" || (player getUnitTrait "engineer")) then {
	player setVariable ["ACE_IsEngineer",1];
	(vestContainer player) addItemCargoGlobal ["ACE_clacker",1];
	(vestContainer player) addItemCargoGlobal ["ACE_M26_Clacker",1];
};

if (_typeofUnit == "engm" || (player getUnitTrait "explosiveSpecialist")) then {	
	player setVariable ["ACE_isEOD",1];
	(vestContainer player) addItemCargoGlobal ["ACE_DefusalKit",1];
	player addWeapon "ACE_VMH3";
};

if (_typeofUnit == "eng" || _typeofUnit == "engm") then {
	(unitBackpack player) addItemCargoGlobal ["ACE_wirecutter", 1];
	(unitBackpack player) addItemCargoGlobal ["ACE_EntrenchingTool", 1];
};

if (_typeofUnit in ["sn","sp"]) then {
	(vestContainer player) addItemCargoGlobal ["ACE_ATragMX",1];
	(vestContainer player) addItemCargoGlobal ["ACE_Kestrel4500",1];
	(vestContainer player) addItemCargoGlobal ["ACE_RangeCard",1];
};

if (_typeofUnit in ["ar","mmgg"] && playerSide == west) then {
	(unitBackpack player) addItemCargoGlobal ["ACE_SpareBarrel", 1];
};

if (_typeofUnit in ["mtrg","mtrag"]) then {
	(uniformContainer player) addItemCargoGlobal ["ACE_RangeTable_82mm",1];
	(uniformContainer player) addItemCargoGlobal ["ACE_MapTools",1];
	(uniformContainer player) addItemCargoGlobal ["ACE_RangeCard",1];
	private _box = createVehicle ["ACE_Box_82mm_Mo_Combo", position player, [], 0, "NONE"];
};

player setVariable ["f_var_ACEclientInitDone",true];