// Create custom radio channels for base platoons.
// * Mission must be coop if using channels defined in radios.sqf
// * Group leads can auto-join channels when the channel name is added at the end of the group line in groups.sqf
if !isMultiplayer exitWith {};

if isServer then {
	private _sidePlayerGroups = []; 
	private _grpBLU = []; private _grpOPF = []; private _grpIND = []; private _grpCIV = [];
		
	#include "..\..\mission\groups.sqf";

	{
		// Store the channel side we're processing.
		_x params ["_groupList","_chSide"]; 
		private _tempArr = [];
		
		// Loop each group in the groups list.
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
		} forEach _groupList;
		
		// If no custom channels were specified and the game-type is coop only, generate automatically.
		if (count _tempArr == 0 && count _groupList > 0 && toUpper (getText ((getMissionConfig "Header") >> "gameType")) == "COOP") then {
			// Load the predefined radio groups.
			#include "..\..\mission\radios.sqf";

			if (count f_radios_settings_longRangeGroups > 0) then {
				{	
					_chName = _x + " channel";
					
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
	} forEach [
			[_grpBLU, west],
			[_grpOPF, east],
			[_grpIND, independent],
			[_grpCIV, civilian]
		];
	
	// Set-up completed
	missionNamespace setVariable ["f_var_customRadio", true, true];
};

if hasInterface then {
	waitUntil{missionNamespace getVariable ["f_var_customRadio", false]}; // Wait until server has finished.
	private _chList = missionNamespace getVariable [format["f_var_ch%1", side group player], []];
	
	if (count _chList > 0) then {
		// Disable the Command Channel
		2 enableChannel [false,false];
		
		private _radioText = "<br/><font size='18' color='#80FF00'>RADIO CHANNELS (OPTIONAL)</font>";
		_radioText = _radioText + format["<br/>You are a member of Group <font color='#72E500'>%1</font>.<br/><br/>The vanilla 'Command' channel has been replaced with a 'Company' channel that all group leaders automatically join.<br/><br/>Custom channels are available to allow Lead Elements to communicate directly with certain platoons and keep the Company Channel free for emergencies only.<br/>", groupId (group player)];
		_radioText = _radioText + "<br/><br/><font size='18' color='#80FF00'>CHANNEL LIST</font>";
		
		private _joinText = "";
		private _joinAllText = "";
		private _leaveAllText = "";
		{
			_x params["_chName","_chID","_chColor","_chGrps"];

			_radioText = _radioText + format["<br/><font color='%3'>%1</font> ----- <font color='#00b300'><execute expression=""
				if !(setCurrentChannel (%2 + 5)) then {
					[%2, [player]] remoteExec ['radioChannelAdd', 2];
					[] spawn {
						waitUntil{uiSleep 1; setCurrentChannel (%2 + 5)};
						systemChat '[RADIO] %4 joined %1';
					};
				};"">Join %1</execute></font> ----- <font color='#b30000'><execute expression=""
				if (setCurrentChannel (%2 + 5)) then {
					setCurrentChannel 3;
					[%2, [player]] remoteExec ['radioChannelRemove', 2];
					systemChat '[RADIO] %4 left %1';
				};"">Leave %1</execute></font>", _chName, _chID, _chColor, name player];

			_joinAllText = _joinAllText + format["if !(setCurrentChannel (%1 + 5)) then { [%1, [player]] remoteExec ['radioChannelAdd', 2]; };", _chID];
			_leaveAllText = _leaveAllText + format["if (setCurrentChannel (%1 + 5)) then { setCurrentChannel 3; [%1, [player]] remoteExec ['radioChannelRemove', 2]; };", _chID];
			
			// SLs automatically get added channels.
			if ((groupId group player in _chGrps && leader player isEqualTo player) || (_chName == "Company Channel" && leader player isEqualTo player)) then {
				_joinText = _joinText + format["<br/><font color='#999999'>Automatically added to </font><font color='#72E500'>%1</font>", _chName];
				[_chID, _chName] spawn {
					uiSleep 5;
					[_this select 0, [player]] remoteExec ['radioChannelAdd', 2];
					systemChat format["[RADIO] %1 auto-joined to %2", name player, _this select 1];
				};
			};
		} forEach _chList;
		
		// CO option to join/Leave all channels
		if (rank player == "COLONEL") then {
			_radioText = _radioText + format["<br/><br/><font color='#FFFF00'><execute expression=""%1 systemChat '[RADIO] All Channels were added';"">Join All Channels</execute></font>",_joinAllText];
			_radioText = _radioText + format["<br/><font color='#FFFF00'><execute expression=""%1 systemChat '[RADIO] All Channels were removed';"">Leave All Channels</execute></font>",_leaveAllText];
		};
		
		private _rad = player createDiaryRecord ["Diary", ["Signal",_radioText + "<br/>" + _joinText]];
	};
	
	// Default non-commanders to group, commanders to side.
	if (leader player == player) then {
		setCurrentChannel 1;
	} else {
		setCurrentChannel 3;
	};
};