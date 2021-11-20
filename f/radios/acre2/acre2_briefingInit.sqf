params ["_groupFreqIndex", "_groupLRFreqIndex","_presetSRArray","_presetLRArray","_preset"];

private _radioText = "<br/><font size='18' color='#80FF00'>RADIO OPERATION</font><br/>";
// Populate any missing radio defaults missed from radios.sqf
private _fRadiosShortRange = (missionNamespace getVariable ["f_radios_settings_riflemanRadio",["all"]]) + (missionNamespace getVariable ["f_radios_settings_personalRadio",["leaders"]]);
private _srRadio = getText (configFile >> "CfgWeapons" >> f_radios_settings_acre2_standardSRRadio >> "displayName");

private _fRadiosLongRange = missionNamespace getVariable ["f_radios_settings_longRangeUnits",["leaders"]];
private _lrRadio = getText (configFile >> "CfgWeapons" >> f_radios_settings_acre2_standardLRRadio >> "displayName");

private _fRadiosExtraRadio = missionNamespace getVariable ["f_radios_settings_acre2_extraRadios",[]];
private _exRadio = getText (configFile >> "CfgWeapons" >> f_radios_settings_acre2_extraRadio >> "displayName");

private _languages = [];
private _unitMap = createHashMapFromArray [ ["leaders","Leaders"],["vc","Vehicle Crew"], ["pp","Pilots"], ["dc","SL"]
];

// Iterate languages.
{
	private _tempLang = _x;
	{
		if (_tempLang isEqualTo (_x select 0)) exitWith { 
			_languages pushBack(_x select 1);
		};
	} forEach f_radios_settings_acre2_languages;
} forEach f_var_acreLanguages;

if (count _languages > 1) then {
	_radioText = _radioText + format["<br/>Languages Spoken: <font color='#00FFFF'>%1</font>.<br/>", (_languages joinString ", ")];
};

if (f_radios_settings_disableAllRadios) exitWith {
	_radioText = _radioText + "<br/>Radios are <font color='#FF0000'>NOT PROVIDED</font> to units as standard kit for this mission.";
	//player removeDiaryRecord ["Diary", "Signal"];
	player createDiaryRecord ["Diary", ["Signal",_radioText]];
};

// SHORT
if ("all" in _fRadiosShortRange) then {
	_radioText = _radioText + format["<br/>Standard equipment for all units is a short-range %1 hand-held radio.",_srRadio];
} else {
	if (count _fRadiosShortRange > 0) then {
		_radioText = _radioText + format["<br/>Certain soldiers (%2) are provided with a short-range %1 hand-held radio.<br/>All other units carry <font color='#FF0000'>NO RADIO</font>.", _srRadio, (_fRadiosShortRange apply { _unitMap getOrDefault [_x, toUpper _x] }) joinString ", "];
	} else {
		_radioText = _radioText + "<br/>Short-range radios are <font color='#FF0000'>NOT PROVIDED</font>.";
	};
};

// LONG
if ("leaders" in _fRadiosLongRange) then { 
	_radioText = _radioText + format["<br/><br/>All leaders carry a long-range %1 radio.",_lrRadio]; 
} else {
	if (count _fRadiosLongRange > 0) then {
		_radioText = _radioText + format["<br/><br/>Only selected soldiers (%2) carry a long-range %1 radio.",_lrRadio, (_fRadiosLongRange apply { _unitMap getOrDefault [_x, toUpper _x] }) joinString ", "]; 
	} else {
		_radioText = _radioText + "<br/>Long-range radios are <font color='#FF0000'>NOT PROVIDED</font>.";
	};
};

// EXTRA
if ("leaders" in _fRadiosExtraRadio) then { 
	_radioText = _radioText + format["<br/><br/>All leaders carry an extra long-range %1 radio.",_exRadio]; 
} else {
	if (count _fRadiosExtraRadio > 0) then {
		_radioText = _radioText + format["<br/><br/>Only selected soldiers (%2) carry an extra long-range %1 radio.",_exRadio, (_fRadiosExtraRadio apply { _unitMap getOrDefault [_x, toUpper _x] }) joinString ", "]; 
	};
};

_radioText = _radioText + "<br/><br/>Radios will be tuned to the highlighted channels upon mission start.<br/>";
_radioText = _radioText + format["<br/><font size='18' color='#80FF00'>Short Range Channels (%1)</font><br/><br/>", _srRadio];

{
	try {
		private _chanNum = _forEachIndex + 1;
		private _frequency = [f_radios_settings_acre2_standardSRRadio, _preset, _chanNum, "frequencyTX"] call acre_api_fnc_getPresetChannelField;
		
		if (_frequency >= 1000) then {_frequency = round (_frequency * 100) / 100};

		if (_groupFreqIndex == _forEachIndex) then {
			_radioText = _radioText + format["<font color='%3'>%1</font><font color='#777777'>: Frequency %2 MHz</font> <font color='#00FFFF'>(B%3 C%4)</font><br/>",(_x select 0),_frequency,floor(_chanNum/17)+1,_chanNum mod 17 + (if (_chanNum >= 17) then {1} else {0})];
		} else {
			_radioText = _radioText + format["<font color='#888888'>%1</font><font color='#555555'>: Frequency %2 MHz</font> <font color='#666666'>(B%3 C%4)</font><br/>",(_x select 0),_frequency,floor(_chanNum/17)+1,_chanNum mod 17 + (if (_chanNum >= 17) then {1} else {0})];
		};
	} catch {};
} forEach _presetSRArray;

_radioText = _radioText + format["<br/><font size='18' color='#80FF00'>Long Range Channels (%1 / %2)</font><br/><br/>", _lrRadio, _exRadio];

{
	try {
		private _chanNum = _forEachIndex + 1;
		private _frequency = [f_radios_settings_acre2_standardLRRadio, _preset, _chanNum, "frequencyTX"] call acre_api_fnc_getPresetChannelField;

		if (_groupLRFreqIndex == _forEachIndex) then {
			_radioText = _radioText + format["<font color='%3'>%1</font>: <font color='#777777'>Frequency %2 MHz</font> <font color='#FF0080'>(Channel %3)</font><br/>",(_x select 0),_frequency,_chanNum];
		} else {
			_radioText = _radioText + format["<font color='#888888'>%1</font><font color='#555555'>: Frequency %2 MHz</font> <font color='#666666'>(Channel %3)</font><br/>",(_x select 0),_frequency,_chanNum];
		};
	} catch {};
} forEach _presetLRArray;

_radioText = _radioText + format["<br/><br/><br/>Problem? Re-run the <execute expression='[] call f_acre2_reinitRadio;'>Radio Setup</execute> script to attempt to re-add any radios.", _groupFreqIndex, _groupLRFreqIndex];
_radioText = _radioText + format["<br/>Give Radio <execute expression=""uniformContainer player addItemCargoGlobal ['%2', 1]; systemChat 'Added %1';"">%1</execute> | <execute expression=""uniformContainer player addItemCargoGlobal ['%4', 1]; systemChat 'Added %3';"">%3</execute>",_lrRadio,f_radios_settings_acre2_standardLRRadio,_srRadio,f_radios_settings_acre2_standardSRRadio];

//player removeDiaryRecord ["Diary", "Signal"];
player createDiaryRecord ["Diary", ["Signal",_radioText]];