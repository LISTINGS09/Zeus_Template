// Create custom radio channels for base platoons.
// * Mission must be coop if using channels defined in radios.sqf
// * Group leads can auto-join channels when the channel name is added at the end of the group line in groups.sqf

// Set the radio mode with 'f_param_radioMode'
// 0 = free - Any player can join any channel.
// 1 = restricted - Need backpack or vehicle to join a channel.
// 'f_radios_backpack' has allowed radio backpack class or override with 'f_radios_<SIDE>backpack' for different sides in one mission.
// 'f_radios_settings_longRangeUnits' in radios.sqf has allowed radio backpack unit types (e.g. ['leaders'] or ['co','dc'] etc...

if (isNil "f_param_radioMode" && isServer) then { missionNamespace setVariable ["f_param_radioMode", 0, true] };

// Start set up for client
[] execVM "f\radios\vanilla\vanilla_client.sqf";

// Set up the server radio channels (server ONLY)
if !isServer exitWith {};

{
	private _tempArr = [];
	_x params ["_chSide"]; 
	
	_chGroups = missionNamespace getVariable [format["f_var_groups%1", _chSide], []];
	
	// Loop each group in the list.
	{
		_x params ["_grpID","_grpName","_icon","_sName","_color",["_customCh",""]];
		// Was a channel defined?
		if (_customCh != "") then {
			private _newChannel = true;
			{
				if (_customCh isEqualTo (_x select 0)) exitWith { (_x select 3) pushBack _grpName; _newChannel = false; };
			} forEach _tempArr;
		
			// Was it previously created?	
			if _newChannel then {
				private _channelID = radioChannelCreate [_color, _customCh, "%CHANNEL_LABEL (%UNIT_GRP_NAME - %UNIT_NAME)", []];
				
				if (_channelID != 0) then {
					_tempArr pushBack [_customCh, _channelID, (_color call BIS_fnc_colorRGBAtoHTML), [_grpName]];
				} else {
					["radios\custom_init.sqf",format["Create Channel '%1' (%2) Failed! Only 8 Channels are supported", _customCh, _chSide],"ERROR"] call f_fnc_logIssue;
				};
			};
		};
	} forEach _chGroups;
	
	// If no custom channels were specified and the game-type is coop only, generate automatically.
	if (count _tempArr == 0 && count _chGroups > 0 && toUpper (getText ((getMissionConfig "Header") >> "gameType")) == "COOP" && playableSlotsNumber _chSide > 0) then {
		if (count (missionNamespace getVariable ["f_radios_settings_longRangeGroups",[]]) > 0) then {
			{	
				_chName = _x + " Channel";
				
				// First Channel is separate color to rest.
				_chColor = if (_forEachIndex isEqualTo 0) then { [1,1,0.333,1] } else { [1,0.4,1,1] };
				
				// Was a channel defined?
				private _channelID = radioChannelCreate [_chColor, _chName, "%CHANNEL_LABEL (%UNIT_GRP_NAME - %UNIT_NAME)", []];

				if (_channelID != 0) then {
					_tempArr pushBack [_chName, _channelID, (_chColor call BIS_fnc_colorRGBAtoHTML), []];
				} else {
					["radios\custom_init.sqf",format["Create Channel '%1' (%2) Failed! Only 8 Channels are supported", _x, _chSide],"ERROR"] call f_fnc_logIssue;
				};
			} forEach f_radios_settings_longRangeGroups;
		};
	};
	
	// Store channel info into public variable.
	missionNamespace setVariable [format["f_var_ch%1",_chSide], _tempArr, true];
} forEach [west, east, independent, civilian];

// Set-up completed
missionNamespace setVariable ["f_var_customRadio", true, true];