// F3 - ACRE Clientside Initialisation
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================

// DECLARE VARIABLES AND FUNCTIONS
f_radios_acre2_giveRadioAction = {
	_unit = player;
	
	//Give the player a message so it isn't forgotten about during the briefing.
	[_this] spawn {
		waitUntil{time>10};
		systemChat format["[ACRE] WARNING: No room to add '%1'! Use scroll-wheel action to get a radio.",_this select 0];
	};

	//Create addAction to give radio.
	_radioName = getText (configFile >> "CfgWeapons" >> _this >> "displayName");
	_actionID = _unit addAction [format ["<t color='#3375D6'>[ACRE] Add %1</t>",_radioName],
		 {
			 _radioToGive = (_this select 3) select 0;
			 _unit = (_this select 0),
			 if (_unit canAdd _radioToGive) then {
				_unit addItem _radioToGive;
				_unit removeAction (_this select 2);
			 } else {
				 systemChat format["[ACRE] WARNING: No room to add radio '%1', remove items and try again",_radioToGive];
			 };
		 }
		 ,[_this],0,false,false,"","(_target == _this)"];
	[_actionID,_unit] spawn {
		sleep 300;
		if (!isNull (_this select 1)) then {
			(_this select 1) removeAction (_this select 0);
		};
	};
};

// CHANNEL NAMES
// Establish default pre-set frequencies.
private _presetName = "default";

// If each side has separate frequencies, assign their channels individually.
if (playerSide in [west, east, independent] && {f_radios_settings_acre2_SplitFrequencies}) then { 
	_presetName = switch (playerSide) do {
		case east: { "default2"; };
		case west: { "default3"; };
		case independent: { "default4"; };
	};
};

// BABEL
// Check and set languages for customized unit (ex. translator)
_spokenLanguages = player getVariable ["f_var_acreLanguages", []];

// If no predefined side is found, default to independent side.
if (_spokenLanguages isEqualTo []) then {
	_spokenLanguages = missionNamespace getVariable [format["f_radios_settings_acre2_language_%1", playerSide],["en"]];
	f_var_acreLanguages = _spokenLanguages;
};

_spokenLanguages call acre_api_fnc_babelSetSpokenLanguages;

{
	[_x,_presetName] call acre_api_fnc_setPreset;
} forEach [f_radios_settings_acre2_standardSRRadio, f_radios_settings_acre2_standardLRRadio, f_radios_settings_acre2_extraRadio];

private _presetSRArray = missionNamespace getVariable [format["f_radios_settings_acre2_sr_groups_%1", playerSide],[]];
private _presetLRArray = missionNamespace getVariable [format["f_radios_settings_acre2_lr_groups_%1", playerSide],[]];

waitUntil{!isNil "f_var_setGroupsIDs";};

// ASSIGN DEFAULT CHANNELS TO RADIOS
private _groupSRChannelIndex = -1;
private _groupLRChannelIndex = 0;
private _groupName = groupId (group player);

{
	if (_groupName in (_x select 1)) exitWith {_groupSRChannelIndex = _forEachIndex;};
} forEach _presetSRArray;

{
	if (_groupName in (_x select 1)) exitWith {_groupLRChannelIndex = _forEachIndex;};
} forEach _presetLRArray;

if (isNil "f_var_acreBriefDone") then {
	[_groupSRChannelIndex, _groupLRChannelIndex, _presetSRArray, _presetLRArray, _presetName] execVM "f\radios\acre2\acre2_briefingInit.sqf";
	f_var_acreBriefDone = true;
};

// RADIO ASSIGNMENT
// Wait for gear assignation to take place
waitUntil{(player getVariable ["f_var_assignGear_done", false])};
_typeofUnit = player getVariable ["f_var_assignGear", "r"];

// REMOVE ALL RADIOS
// Wait for ACRE2 to initialise any radios the unit has in their inventory, and then
// remove them to ensure that duplicate radios aren't added by accident.
if(!f_radios_settings_disableAllRadios) then {
    waitUntil{uiSleep 0.3; !("ItemRadio" in (items player + assignedItems player))};
    uiSleep 1;

    waitUntil{[] call acre_api_fnc_isInitialized};
    {player removeItem _x;} forEach ([] call acre_api_fnc_getCurrentRadioList);
};

// ASSIGN RADIOS TO UNITS
// Populate radio defaults if they have not been set (also referenced when assigning radios).
private _fRadiosShortRange = (missionNamespace getVariable ["f_radios_settings_riflemanRadio",["all"]]) + (missionNamespace getVariable ["f_radios_settings_personalRadio",["leaders"]]);
private _fRadiosLongRange = missionNamespace getVariable ["f_radios_settings_longRangeUnits",["leaders"]];
private _fRadiosExtraRadio = missionNamespace getVariable ["f_radios_settings_acre2_extraRadios",[]];

// Depending on the loadout used in the assignGear component, each unit is assigned
// a set of radios.

// If radios are enabled in the settings
if(!f_radios_settings_disableAllRadios) then {
	// Everyone gets a short-range radio by default
	if ((player getVariable ["f_var_radioAddSR", true]) && (_typeofUnit in _fRadiosShortRange || "all" in _fRadiosShortRange || (player == leader (group player) && "leaders" in _fRadiosShortRange))) then {
		if (player canAdd f_radios_settings_acre2_standardSRRadio) then {
			player addItem f_radios_settings_acre2_standardSRRadio;
		} else {
			f_radios_settings_acre2_standardSRRadio call f_radios_acre2_giveRadioAction;
		};
	};

	// If unit is in the above list, add a 148
	if((player getVariable ["f_var_radioAddLR", true]) && (_typeofUnit in _fRadiosLongRange || "all" in _fRadiosLongRange || (player == leader (group player) && "leaders" in _fRadiosLongRange))) then {
		if (player canAdd f_radios_settings_acre2_standardLRRadio) then {
			player addItem f_radios_settings_acre2_standardLRRadio;
		} else {
			f_radios_settings_acre2_standardLRRadio call f_radios_acre2_giveRadioAction;
		};
	};
	
	// If unit is in the list of units that receive an extra long-range radio, add another 148
	if((player getVariable ["f_var_radioAddAR", true]) && (_typeofUnit in _fRadiosExtraRadio || "all" in _fRadiosExtraRadio)) then {
		if (player canAdd f_radios_settings_acre2_extraRadio) then {
			player addItem f_radios_settings_acre2_extraRadio;
		} else {
			f_radios_settings_acre2_extraRadio call f_radios_acre2_giveRadioAction;
		};
	};
};

// ASSIGN DEFAULT CHANNELS TO RADIOS
// Depending on the squad joined, each radio is assigned a default starting channel
[_groupSRChannelIndex,_groupLRChannelIndex] spawn {
	params ["_SRChIndx","_LRChIndx"];
    private ["_radioSR","_radioLR","_hasSR","_hasLR","_hasExtra"];

    waitUntil {sleep 0.1; [] call acre_api_fnc_isInitialized};
	
    _radioSR = [f_radios_settings_acre2_standardSRRadio] call acre_api_fnc_getRadioByType;
    _radioLR = [f_radios_settings_acre2_standardLRRadio] call acre_api_fnc_getRadioByType;
	
	//Show Radio Nets:
	_hasSR = false;
	_hasLR = false;
	{
		if (_x isKindOf [f_radios_settings_acre2_standardSRRadio, configFile >> "CfgWeapons"]) then {_hasSR = true;};
		if (_x isKindOf [f_radios_settings_acre2_standardLRRadio, configFile >> "CfgWeapons"]) then {_hasLR = true;};
	} forEach (items player);

    if (_SRChIndx == -1 && {_hasSR}) then {
		["acre2_clientInit.sqf",format["Unknown group for short-range channel defaults (%1).", groupId (group player)]] call f_fnc_logIssue;
		player groupChat format["[ACRE] Group (%1) was not found in Signals.", groupId (group player)];
        _SRChIndx = 0;
    };
	
    if (_hasSR && _SRChIndx >= 0) then {
		player groupChat format["[ACRE] %1: Tuned to %3.",getText (configFile >> "CfgWeapons" >> f_radios_settings_acre2_standardSRRadio >> "descriptionShort"), _SRChIndx+1, groupId group player];
        [_radioSR, (_SRChIndx + 1)] call acre_api_fnc_setRadioChannel;
    };

    if (_hasLR) then {	
		private _LRChName = ((missionNamespace getVariable [format["f_radios_settings_acre2_lr_groups_%1", playerSide],f_radios_settings_longRangeGroups]) select _LRChIndx) select 0;
		player groupChat format["[ACRE] %1: Tuned to %3.",getText (configFile >> "CfgWeapons" >> f_radios_settings_acre2_standardLRRadio >> "descriptionShort"), _LRChIndx + 1, _LRChName];
        [_radioLR, (_LRChIndx + 1)] call acre_api_fnc_setRadioChannel;
    };
};