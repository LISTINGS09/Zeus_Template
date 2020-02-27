// Create custom radio channels for base platoons.
// * Mission must be coop if using channels defined in radios.sqf
// * Group leads can auto-join channels when the channel name is added at the end of the group line in groups.sqf
//if !isMultiplayer exitWith {};
waitUntil{missionNamespace getVariable ["f_var_customRadio", false]}; // Wait until server setup has finished.

private _chList = missionNamespace getVariable [format["f_var_ch%1", side group player], []];

// No channels were defined, so just exit
if (count _chList == 0) exitWith {};

// Function to establish if the player can use the radio
f_fnc_hasUsableRadio = {
	params [["_unit", player]];
	
	// Always allow use if in free mode
	if (f_param_radioMode < 1) exitWith { true };
		
	if ((toLower backpack _unit) find "radio" < 0 && // Any radio class backpack
		{ _unit distance _x < 5 && missionNamespace getVariable ["f_radios_backpack","B_RadioBag_01_wdl_F"] == backpack _x} count (allPlayers) <= 0 && // Has or is near Backpack
		rank _unit != "COLONEL" && // Commander can do anything
		vehicle _unit == _unit // Not in a vehicle
	) exitWith { 
		false
	};
	
	_unit setVariable ["f_radios_isOperator", true];
	true
};

// Function to handle channel switches
f_fnc_radioSwitchChannel = {
	params ["_id", ["_doAdd", false], ["_reason", ""], ["_unit", player]];
	
	private _name = ((missionNamespace getVariable format["f_var_ch%1", side group _unit]) select {_x#1 == _id})#0#0;

	if _doAdd then {
		if !(setCurrentChannel (_id + 5)) then {
			// Add channel if player is allowed
			if !([] call f_fnc_hasUsableRadio) exitWith {
				titleText [format["<t color='#FF0000' size='1.5'>No valid Radio or Vehicle to join %1!</t><br/>", _name], "PLAIN DOWN", -1, true, true];
			};
			
			// Set local variable for EHs to run from
			_unit setVariable ["f_radios_isOperator", true];
		
			[_id, [_unit]] remoteExecCall ['radioChannelAdd', 2];
			_time = time + 3;
			waitUntil { (setCurrentChannel (_id + 5) || time > _time) };
			if (setCurrentChannel (_id + 5)) then {
				titleText [format["<t color='#80FF00' size='1.5'>%1 </t><t size='1.5'>Connected %2</t>", _name, _reason], "PLAIN DOWN", -1, true, true];
				f_radios_activeChID pushBackUnique _id;
			} else {
				titleText [format["<t color='#FF0000' size='1.5'>Failed to join %1 (#%2)</t><br/>", _name, _id], "PLAIN DOWN", -1, true, true];
			};
		};
	} else {
		if (setCurrentChannel (_id + 5)) then {
			setCurrentChannel 3;
			[_id, [_unit]] remoteExecCall ['radioChannelRemove', 2];
			titleText [format["<t color='#CF142B' size='1.5'>%1 </t><t size='1.5'>Disconnected %2</t>", _name, _reason], "PLAIN DOWN", -1, true, true];
		};
	};
	
	true
};

// Local variable to hold active channels
f_radios_activeChID = [];

// Set up for restricted radio mode for clients
if (f_param_radioMode == 1) then { 
	call compile preprocessFileLineNumbers "f\radios\vanilla\restricted_radios.sqf"
} else { 
	// Rejoin channels on respawn
	if !(isNil "f_eh_respawnRadio") then { player removeEventHandler ["Respawn", f_eh_respawnRadio] };
	f_eh_respawnRadio = player addEventHandler ["Respawn", {
		params ["_unit", "_corpse"];
		{ [_x, true] spawn f_fnc_radioSwitchChannel } forEach f_radios_activeChID;
	}];
};

// Disable the Command Channel
2 enableChannel [false,false];

// Generate channels text
private _radioText = "<br/><font size='18' color='#80FF00'>RADIO CHANNELS</font>";
_radioText = _radioText + format["<br/>You are a member of Group <font color='#72E500'>%1</font>%3.<br/><br/>The vanilla 'Command' channel has been replaced with a 'Company' channel that all <font color='#FF0080'>%2</font> automatically join.<br/><br/>These channels are available to allow Lead Elements to communicate directly with certain platoons and keep the Company Channel free for emergencies only.", 
	groupId (group player),
	["Group Leaders","Radio Operators"] select f_param_radioMode,
	["",", channels are <font color='#00FFFF'>Restricted</font>. Only units with radios or inside vehicles may use these channels"] select f_param_radioMode];
		
_radioText = _radioText + "<br/><br/><font size='18' color='#80FF00'>CHANNEL LIST</font>";

private _joinText = "";

// Define default channel ID for player if it hasn't already been set (LOCAL VARIABLE)
if (isNil "f_radios_mainChID") then { 
	_fID = _chList findIf { _x#0 == "company channel"}; 
	f_radios_mainChID = missionNamespace getVariable [format["f_radios_%1ChID",side group player], if (_fID >= 0) then { _chList#_fID#1 } else { _chList#0#1 }];
};

{
	_x params["_chName","_chID","_chColor","_chGrps"];

	_radioText = _radioText + format["<br/><font color='#72E500'><execute expression=""[%2, true] spawn f_fnc_radioSwitchChannel;"">Join</execute></font> - <font color='#CF142B'><execute expression=""[%2, false] spawn f_fnc_radioSwitchChannel; f_radios_activeChID = f_radios_activeChID - [%2];"">Leave</execute></font> - <font color='%3'>%1</font>", _chName, _chID, _chColor];

	// SLs automatically get added channels.
	if (((leader player == player && f_param_radioMode == 0) || player getVariable ["f_radios_isOperator", false]) && ((groupId group player) in _chGrps || _chID == f_radios_mainChID)) then {
		_joinText = _joinText + format["<br/><font color='#999999'>Automatically will be added to </font><font color='#72E500'>%1</font>", _chName];
		[_chID, _chName] spawn {
			uiSleep 5;
			[_this#0, true, "(Auto Join)"] spawn f_fnc_radioSwitchChannel;
		};
	};
} forEach _chList;

if (f_param_radioMode == 1) then {
	_radioText = _radioText + "<br/><br/><font size='18' color='#80FF00'>LOST RADIO</font><br/>Anyone may request a <execute expression=""[player, true] spawn f_fnc_giveRadioBackpack; hintSilent format['Radio assigned to %1', name player];"">Replacement Radio</execute> if your Radio Operator is MIA or any other technical issue.";
};

//player removeDiaryRecord ["Diary", "Signal"];
private _rad = player createDiaryRecord ["Diary", ["Signal",_radioText + "<br/>" + _joinText]];