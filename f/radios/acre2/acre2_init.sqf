// F3 - ACRE2 Init
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

if !(isClass(configFile >> "cfgPatches" >> "acre_main")) exitWith { ["acre2_init.sqf",["ACRE: Addon is not running!","ERROR"]] call f_fnc_logIssue; }; 

// Pre-compile functions
if (isNil "f_acre2_reinitRadio") then {f_acre2_reinitRadio = compile preprocessFileLineNumbers "f\radios\acre2\acre2_reinitRadio.sqf";};

// JIP check
if (!isDedicated && (isNull player)) then {
	waitUntil {sleep 0.1; !isNull player};
};

// Convert default LR strings to correct array format.
{
	if (_x isEqualType "") then { f_radios_settings_longRangeGroups set [_foreachIndex,[_x,[]]]; };
} forEach f_radios_settings_longRangeGroups;

// Check for SRs and LR Group Names
{
	_x params ["_side"];
	
	_chArray = missionNamespace getVariable [format["f_var_groups%1", _side], []];
	
	if (count _chArray > 0) then {
		private _tempSRgrps = [];
		private _tempLRgrps = [];
		{
			_x params ["_grpID","_grpName","_icon","_sName","_color",["_customCh",""]];
			_tempSRgrps pushBack [_grpName,[_grpName]];
			
			// If custom LR channel was previously defined in the loop.
			if (_customCh != "") then {
				private _newChannel = true;
				{
					if (_customCh isEqualTo (_x select 0)) exitWith { _newChannel = false; };
				} forEach _tempLRgrps;
			
				// Does a new LR channel need added?
				if _newChannel then { _tempLRgrps pushBack [_customCh, [_grpName]]; };
			};
		} forEach _chArray;
		
		// Set the SR groups array.
		missionNamespace setVariable [format["f_radios_settings_acre2_sr_groups_%1",_side], _tempSRgrps];
		
		// Set the LR groups array, use default if legacy or blank.
		if (count _tempLRgrps > 0) then {
			missionNamespace setVariable [format["f_radios_settings_acre2_lr_groups_%1",_side], _tempLRgrps];
		} else {
			missionNamespace setVariable [format["f_radios_settings_acre2_lr_groups_%1",_side], f_radios_settings_longRangeGroups];
		};
	};
} forEach [west, east, independent, civilian];


private _f_fnc_acrePresetChannels = {
	params [["_preset","default"], ["_radioGroupVar",""]];
	
	{
		private _radioName = _x;
		{	
			[_radioName, _preset, _forEachIndex + 1, "label", _x select 0] call acre_api_fnc_setPresetChannelField;
			
			if ((_x select 0) isEqualTo "NEUTRAL") then {
				// Neutral frequency set is the same for all sides.
				[_radioName, _preset, _forEachIndex + 1, "frequencyTX", 30] call acre_api_fnc_setPresetChannelField;
				[_radioName, _preset, _forEachIndex + 1, "frequencyRX", 30] call acre_api_fnc_setPresetChannelField;
			};
		} forEach (missionNamespace getVariable [_radioGroupVar,[]]);
	} forEach ["ACRE_PRC148", "ACRE_PRC152", "ACRE_PRC117F"];
	
	//diag_log text format ["[ACRE] Named channels complete for: %1",_preset];
};

// Iterate the LR groups and set labels - Must be done on server and client.
["default", "f_radios_settings_longRangeGroups"] call _f_fnc_acrePresetChannels;
["default2", "f_radios_settings_acre2_lr_groups_east"] call _f_fnc_acrePresetChannels;
["default3", "f_radios_settings_acre2_lr_groups_west"] call _f_fnc_acrePresetChannels;
["default4", "f_radios_settings_acre2_lr_groups_guer"] call _f_fnc_acrePresetChannels;

if hasInterface then {
	// define our languages (need to be the same order for everyone)
	{
		_x call acre_api_fnc_babelAddLanguageType;
	} forEach f_radios_settings_acre2_languages;
	
	// if dead, set spectator and exit
	if (!alive player) exitWith {[true] call acre_api_fnc_setSpectator;};

	[] execVM "f\radios\acre2\acre2_clientInit.sqf";
	
	player addEventHandler [ "Respawn", { [] spawn { sleep 0.1; execVM "f\radios\acre2\acre2_clientInit.sqf" } } ];
};