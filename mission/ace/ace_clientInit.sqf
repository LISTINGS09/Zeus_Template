// F3 - ACE Advanced Clientside Initialisation
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================
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
{player addItem "ACE_CableTie"} forEach [1,2,3,4];
{player addItem "ACE_fieldDressing"} forEach [1,2,3,4,5,6,7,8];
{player addItem "ACE_morphine"} forEach [1,2];
{player addItem "ACE_epinephrine"} forEach [1,2];
if (missionNamespace getVariable ["ace_medical_treatment_advancedBandages", false]) then {
	player addItem "ACE_tourniquet";
	{player addItem "ACE_elasticBandage"} forEach [1,2,3,4,5,6,7,8];
};

player setVariable ["ACE_hasEarPlugsIn", true, true];
player removeItem "ACE_EarPlugs";

if (_typeofUnit == "m" || (player getUnitTrait "medic")) then {
	player setVariable ["ACE_IsMedic",1];
	(unitBackpack player) addItemCargoGlobal ["ACE_fieldDressing", 10];
	(unitBackpack player) addItemCargoGlobal ["ACE_morphine", 16];
	(unitBackpack player) addItemCargoGlobal ["ACE_epinephrine", 10];
	(unitBackpack player) addItemCargoGlobal ["ACE_adenosine", 10];
	
	if ((missionNamespace getVariable ["ace_medical_fractures", 0]) > 0) then { (unitBackpack player) addItemCargoGlobal ["ACE_splint", 4]; };	
	
	if (missionNamespace getVariable ["ace_medical_treatment_advancedBandages", false]) then {
		if ((missionNamespace getVariable ["ace_medical_treatment_locationPAK", 0]) != 4) then { (unitBackpack player) addItemCargoGlobal ["ACE_personalAidKit", 2] };
		if ((missionNamespace getVariable ["ace_medical_treatment_locationSurgicalKit", 0]) != 4 && (missionNamespace getVariable ["ace_medical_treatment_woundReopening", false])) then { (unitBackpack player) addItemCargoGlobal ["ACE_surgicalKit", 1] };
		(unitBackpack player) addItemCargoGlobal ["ACE_elasticBandage", 30];
		(unitBackpack player) addItemCargoGlobal ["ACE_tourniquet", 4];
		(unitBackpack player) addItemCargoGlobal ["ACE_quikclot", 15];
		(unitBackpack player) addItemCargoGlobal ["ACE_packingBandage", 15];
		(unitBackpack player) addItemCargoGlobal ["ACE_salineIV_500", 6];
	} else {
		(unitBackpack player) addItemCargoGlobal ["ACE_fieldDressing", 20];
		(unitBackpack player) addItemCargoGlobal ["ACE_bloodIV_500", 6];
	};
};

if ("ACE_Vector" in (items player + assignedItems player)) then {
	player addItem "ACE_microDAGR";
};

if (_typeofUnit in ["vc","vd","vg","pp","pc"]) then {
	player setVariable ["ACE_IsEngineer",1];
};

if (_typeofUnit == "eng" || (player getUnitTrait "engineer")) then {
	player setVariable ["ACE_IsEngineer",1];
	player addItem "ACE_clacker";
	player addItem "ACE_M26_Clacker";
	player addItem "ACE_wirecutter";
	player addItem "ACE_EntrenchingTool";
};

if (_typeofUnit == "engm" || (player getUnitTrait "explosiveSpecialist")) then {	
	player setVariable ["ACE_isEOD",1];
	player addItem "ACE_DefusalKit";
	player addItem "ACE_wirecutter";
	player addItem "ACE_EntrenchingTool";
	player addWeapon "ACE_VMH3";
};

if (_typeofUnit in ["sn","sp"]) then {
	player addItem "ACE_ATragMX";
	player addItem "ACE_Kestrel4500";
	player addItem "ACE_RangeCard";
};

if (_typeofUnit in ["ar","mmgg"] && playerSide == west) then {
	player addItem "ACE_SpareBarrel";
};

if (_typeofUnit in ["mtrg","mtrag"]) then {
	player addItem "ACE_RangeTable_82mm";
	player addItem "ACE_MapTools";
	player addItem "ACE_RangeCard";
};

player setVariable ["f_var_ACEclientInitDone",true];