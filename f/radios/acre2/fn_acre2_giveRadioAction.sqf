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

private _presetName = "default";

// Check and set languages for customized unit (ex. translator)
_spokenLanguages = player getVariable ["f_var_acreLanguages", []];

// If no predefined side is found, default to independent side.
if (side group player in [west, east, independent]) then {
	if (_spokenLanguages isEqualTo []) then {
		_spokenLanguages = missionNamespace getVariable [format["f_radios_settings_acre2_language_%1", side group player],f_radios_settings_acre2_language_guer];
	};

	if (f_radios_settings_acre2_SplitFrequencies) then {
			_presetName = format["%1",side group player];
	};
};

f_radios_settings_acre2_presetName = _presetName;

["ACRE_PRC343",_presetName] call acre_api_fnc_setPreset;
["ACRE_PRC148",_presetName] call acre_api_fnc_setPreset;
["ACRE_PRC152",_presetName] call acre_api_fnc_setPreset;
["ACRE_PRC117F",_presetName] call acre_api_fnc_setPreset;

// if dead, set spectator and exit
if (!alive player) exitWith {[true] call acre_api_fnc_setSpectator;};

_spokenLanguages call acre_api_fnc_babelSetSpokenLanguages;

private _presetSRArray = missionNamespace getVariable [format["f_radios_settings_acre2_sr_groups_%1", playerSide],[]];
private _presetLRArray = missionNamespace getVariable [format["f_radios_settings_acre2_lr_groups_%1", playerSide],[]];

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
	[_groupSRChannelIndex, _groupLRChannelIndex, _presetSRArray, _presetLRArray] execVM "f\radios\acre2\acre2_briefingInit.sqf";
	f_var_acreBriefDone = true;
};

// RADIO ASSIGNMENT

// Wait for gear assignation to take place
waitUntil{(player getVariable ["f_var_assignGear_done", false])};
_typeofUnit = player getVariable ["f_var_assignGear", (typeOf player)];

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
// Depending on the loadout used in the assignGear component, each unit is assigned
// a set of radios.

private _fRadiosPersonal = missionNamespace getVariable ["f_radios_settings_personalRadio",["leaders"]];
private _fRadiosRifleman = missionNamespace getVariable ["f_radios_settings_riflemanRadio",["all"]];
private _fRadiosLongRange = missionNamespace getVariable ["f_radios_settings_longRangeUnits",["leaders"]];
private _fRadiosExtraRadio = missionNamespace getVariable ["f_radios_settings_acre2_extraRadios",[]];

// If radios are enabled in the settings
if(!f_radios_settings_disableAllRadios) then {
	// Everyone gets a short-range radio by default
	if (_typeofUnit in _fRadiosRifleman || "all" in _fRadiosRifleman || (player == leader (group player) && "leaders" in _fRadiosRifleman)) then {
		if (player canAdd f_radios_settings_acre2_standardSHRadio) then {
			player addItem f_radios_settings_acre2_standardSHRadio;
		} else {
			f_radios_settings_acre2_standardSHRadio call f_radios_acre2_giveRadioAction;
		};
	} else {
		if (_typeofUnit in _fRadiosPersonal || "all" in _fRadiosPersonal || (player == leader (group player) && "leaders" in _fRadiosPersonal)) then {
			if (player canAdd f_radios_settings_acre2_standardSHRadio) then {
				player addItem f_radios_settings_acre2_standardSHRadio;
			} else {
				f_radios_settings_acre2_standardSHRadio call f_radios_acre2_giveRadioAction;
			};
		};
	};

	// If unit is in the above list, add a 148
	if(_typeofUnit in _fRadiosLongRange || "all" in _fRadiosLongRange || (player == leader (group player) && "leaders" in _fRadiosLongRange)) then {
		if (player canAdd f_radios_settings_acre2_standardLRRadio) then {
			player addItem f_radios_settings_acre2_standardLRRadio;
		} else {
			f_radios_settings_acre2_standardLRRadio call f_radios_acre2_giveRadioAction;
		};
	};
	
	// If unit is in the list of units that receive an extra long-range radio, add another 148
	if(_typeofUnit in _fRadiosExtraRadio || "all" in _fRadiosExtraRadio) then {
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
    private ["_radioSR","_radioLR","_radioExtra","_hasSR","_hasLR","_hasExtra"];

    waitUntil {uiSleep 0.1; [] call acre_api_fnc_isInitialized};
	
    _radioSR = [f_radios_settings_acre2_standardSHRadio] call acre_api_fnc_getRadioByType;
    _radioLR = [f_radios_settings_acre2_standardLRRadio] call acre_api_fnc_getRadioByType;
    _radioExtra = [f_radios_settings_acre2_extraRadio] call acre_api_fnc_getRadioByType;
	
	//Show Radio Nets:
	_hasSR = false;
	_hasLR = false;
	_hasExtra = false;
	{
		if (_x isKindOf [f_radios_settings_acre2_standardSHRadio, configFile >> "CfgWeapons"]) then {_hasSR = true;};
		if (_x isKindOf [f_radios_settings_acre2_standardLRRadio, configFile >> "CfgWeapons"]) then {_hasLR = true;};
		if (_x isKindOf [f_radios_settings_acre2_extraRadio, configFile >> "CfgWeapons"]) then {_hasExtra = true;};
	} forEach (items player);

    if (_SRChIndx == -1 && {_hasSR}) then {
		["acre2_clientInit.sqf",format["Unknown group for short-range channel defaults (%1).", groupId (group player)]] call f_fnc_logIssue;
		player groupChat format["[ACRE] WARNING (acre2_clientInit.sqf): Unknown group for short-range (%1)",groupId (group player)];
        _SRChIndx = 0;
    };
	
    if (_hasSR) then {
		player groupChat format["[ACRE] %1: Tuned to CH%2.",getText (configFile >> "CfgWeapons" >> f_radios_settings_acre2_standardSHRadio >> "descriptionShort"), _SRChIndx + 1];
        [_radioSR, (_SRChIndx + 1)] call acre_api_fnc_setRadioChannel;
    };

    if (_hasLR) then {
		player groupChat format["[ACRE] %1: Tuned to CH%2.",getText (configFile >> "CfgWeapons" >> f_radios_settings_acre2_standardLRRadio >> "descriptionShort"), _LRChIndx + 1];
        [_radioLR, (_LRChIndx + 1)] call acre_api_fnc_setRadioChannel;
    };

    if (_hasExtra) then {
		player groupChat format["[ACRE] %1: Tuned to CH%2.",getText (configFile >> "CfgWeapons" >> f_radios_settings_acre2_extraRadio >> "descriptionShort"), _LRChIndx + 1];
        [_radioExtra, (_LRChIndx + 1)] call acre_api_fnc_setRadioChannel;
    };
};