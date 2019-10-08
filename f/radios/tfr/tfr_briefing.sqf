if (isNull player) then { waitUntil {sleep 0.1; !isNull player}; };
if (missionNamespace getVariable["f_param_debugMode",0] == 1) then { diag_log text "[F3] DEBUG (tfr_briefing.sqf): Running."; };

params [["_SRGroups",[]], ["_LRGroups",[]], ["_SRindex",-1], ["_LRindex",0]];

private _side = [str playerSide, "INDEPENDENT"] select (playerSide == Independent);

private _radioNames = [];

{
	_x params ["_class", "_config"];
	
	if (isClass (configFile >> _config >> _class)) then {
		_radioNames set [_forEachIndex,  getText (configFile >> _config >> _class >> "displayName")];
	} else {
		_radioNames set [_forEachIndex, "Unknown"];
	};
} forEach [
	[missionNamespace getVariable [ format["TFAR_DefaultRadio_Personal_%1", _side], missionNamespace getVariable [ format["TF_default%1PersonalRadio", playerSide], ""]], "CfgWeapons"],
	[missionNamespace getVariable [ format["TFAR_DefaultRadio_Rifleman_%1", _side], missionNamespace getVariable [ format["TF_default%1RiflemanRadio", playerSide], ""]], "CfgWeapons"],
	[missionNamespace getVariable [ format["TFAR_DefaultRadio_Backpack_%1", _side], missionNamespace getVariable [ format["TF_default%1Backpack", playerSide], ""]], "CfgVehicles"]
];

_radioNames params ["_pr", "_rf", "_bp"];

private _srFreq = missionNamespace getVariable [format["TFAR_defaultFrequencies_sr_%1", [playerSide, "Independent"] select (playerSide == Independent)], []];
private _lrFreq = missionNamespace getVariable [format["TFAR_defaultFrequencies_lr_%1", [playerSide, "Independent"] select (playerSide == Independent)], []];

private _radioText = "<br/><font size='18' color='#80FF00'>RADIO OPERATION</font>";

if (count _SRGroups == 0) exitWith {
	["tfr_briefing.sqf",format["No groups found in mission\groups.sqf for side %1.",side group player]] call f_fnc_logIssue;
	diag_log text format["[F3] WARNING (tfr_briefing.sqf): No groups found in mission\groups.sqf for side %1.",side group player];
};

if (f_radios_settings_disableAllRadios) exitWith {
	_radioText = _radioText + "<br/>Radios are <font color='#FF0000'>NOT PROVIDED</font> to units as standard kit for this mission.";
	//player removeDiaryRecord ["Diary", "Signal"];
	_rad = player createDiaryRecord ["Diary", ["Signal",_radioText]];
};

// Default any missing TFAR settings.
private _fRadiosPersonal = missionNamespace getVariable ["f_radios_settings_personalRadio",["leaders"]];
private _fRadiosRifleman = missionNamespace getVariable ["f_radios_settings_riflemanRadio",["all"]];
private _fRadiosLongRange = missionNamespace getVariable ["f_radios_settings_longRangeUnits",["leaders"]];

if ("all" in _fRadiosPersonal) then {
	_radioText = _radioText + format["<br/>Standard equipment for all units is a short-range %1 radio.",_pr];
} else {
	if ("all" in _fRadiosRifleman) then {
		_radioText = _radioText + format["<br/>Senior ranks are provided with a short-range %1 personal radio.<br/>All other units carry a %2 rifleman radio.",_pr,_rf];
	} else {
		if (count _fRadiosRifleman == 0 && count _fRadiosPersonal == 0) then {
			_radioText = _radioText + format["<br/>Short-range radios are <font color='#FF0000'>NOT PROVIDED</font>.",_pr];
		} else {
			_radioText = _radioText + format["<br/>Only senior ranks have a short-range %1 personal radio.<br/>All other units carry <font color='#FF0000'>NO RADIO</font>.",_pr];
		};
	};
};

if ("leaders" in _fRadiosLongRange) then { 
	_radioText = _radioText + format["<br/><br/>All leaders carry a long-range %1 backpack radio.",_bp]; 
};

if (!("leaders" in _fRadiosLongRange) && count _fRadiosLongRange > 0) then { 
	_radioText = _radioText + format["<br/><br/>Only selected soldiers carry a long-range %1 backpack radio.",_bp]; 
};

_radioText = _radioText + format["<br/><br/><br/><font size='18' color='#80FF00'>SHORT RANGE (%1 / %2)</font>",_pr,_rf];

// SHORT RANGE
private _lastSR = 0;
{
	if (_forEachIndex < count _srFreq) then { 
		_lastSR = parseNumber (_srFreq select _forEachIndex);
	} else {
		_lastSR = _lastSR + 1; // Increment Freq
	};
	
	if (_SRindex == _forEachIndex) then {
		_radioText = _radioText + format["<br/>%1: <font color='#777777'>SR Frequency</font> %2Mhz <font color='#00FFFF'>(Channel #1)</font>", (_x select 0), _lastSR];
		f_tfar_localSRfreq = _lastSR;
	} else {
		_radioText = _radioText + format["<br/>%1: <font color='#555555'>SR Frequency %2Mhz</font>", (_x select 0), _lastSR];
	};
} forEach _SRGroups;

if (count _fRadiosLongRange > 0) then {
	_radioText = _radioText + format["<br/><br/><font size='18' color='#80FF00'>LONG RANGE (%1)</font>",_bp];
	
	// LONG RANGE
	private _lastLR = 0;
	{
		// Player can't select more than 8 channels!
		if (_forEachIndex < count _lrFreq) then {
			_lastLR = parseNumber (_lrFreq select _forEachIndex);
			if (_LRindex == _forEachIndex) then {
				_radioText = _radioText + format["<br/>%1: <font color='#777777'>LR Frequency</font> %2Mhz <font color='#00FFFF'>(Channel #%3)</font>", (_x select 0), _lastLR, _forEachIndex + 1 ];
			} else {
				_radioText = _radioText + format["<br/>%1: <font color='#555555'>LR Frequency %2Mhz</font> <font color='#666666'>(Channel #%3)</font>", (_x select 0), _lastLR, _forEachIndex + 1 ]; 
			};
		} else {
			_lastLR = _lastLR + 0.2; // Increment Freq
			_radioText = _radioText + format["<br/>%1: <font color='#555555'>LR Frequency %2Mhz</font>", (_x select 0), _lastLR];
		};
	} forEach _LRGroups;
} else { 
	_radioText = _radioText + "<br/><br/>Long-range radios are <font color='#FF0000'>NOT PROVIDED</font>.<br/>"; 
};

if (isNil "f_tfar_localSRfreq") then {
	_radioText = _radioText + format["<br/><br/>*** No frequency provided for %1 ***", groupId (group player) ];
};

if (missionNamespace getVariable["f_param_debugMode",0] == 1) then { diag_log text "[F3] DEBUG (tfr_briefing.sqf): Loaded."; };

//player removeDiaryRecord ["Diary", "Signal"];
_rad = player createDiaryRecord ["Diary", ["Signal",_radioText]];
