// F3 - Nametags
if (!isDedicated && (isNull player)) then { waitUntil {sleep 0.1; !isNull player} };

// Only run in MP and for valid players!
if (!isMultiplayer || !hasInterface || playerSide == sideLogic) exitWith {};

// SET GLOBAL VARIABLES
F_DIST_TAGS = 60;		// Distance to display name tags for all units around
F_KEY_TAGS =  "TeamSwitch"; // The action key to toggle the name tags. See possible keys here: http://community.bistudio.com/wiki/Category:Key_Actions

// Globally disable this script by setting a mission variable 'F_SHOW_TAGS = FALSE'.
F_SHOW_TAGS = missionNamespace getVariable ['F_SHOW_TAGS', profileNamespace getVariable ['F_SHOW_TAGS', true]]; // Draw tags (master)

F_SIZE_TAGS = profileNamespace getVariable ['F_SIZE_TAGS', 0.04]; // The size the names are displayed in
F_FONT_TAGS = profileNamespace getVariable ['F_FONT_TAGS', "PuristaBold"]; // Font for the names

F_TEAM_TAGS = profileNamespace getVariable ['F_TEAM_TAGS', true]; // Show team icons only?
F_NAME_TAGS = profileNamespace getVariable ['F_NAME_TAGS', true]; // Draw names
F_GPID_TAGS = profileNamespace getVariable ['F_GPID_TAGS', true]; // Show unit's group next to unit name (except for player's own group)
F_TYPE_TAGS = profileNamespace getVariable ['F_TYPE_TAGS', true]; // Show type of vehicle under driver's names
F_TYPE_ICON = profileNamespace getVariable ['F_TYPE_ICON', true]; // Show type of vehicle under driver's names
F_OVER_ONLY = profileNamespace getVariable ['F_OVER_ONLY', false]; // Cursor only mode

// DISABLE Tags for Regular Members
if (count (squadParams player) > 0 && F_SHOW_TAGS) then {
	if (toUpper ((squadParams player) # 0 # 0) == "ZEUS") then { F_SHOW_TAGS = false };
};

if (isClass(configFile >> "CfgPatches" >> "ace_main") && F_SHOW_TAGS) then { F_SHOW_TAGS = false };

F_ACTIONKEY_TAGS = (actionKeys F_KEY_TAGS)#0;
F_KEYNAME_TAGS = actionKeysNames F_KEY_TAGS;
if (isNil "F_ACTIONKEY_TAGS") then {F_ACTIONKEY_TAGS = 22; F_KEYNAME_TAGS = 'U';}; // If the user has not bound 'TeamSwitch' to a key we default to 'U' to toggle the tags

F_KEYDOWN_NAMETAG = {
	_key = _this#1;
	_handeld = false;
	if(_key == F_ACTIONKEY_TAGS) then {
		F_SHOW_TAGS = !F_SHOW_TAGS;
		titleText [format["%1 unit tags", if (F_SHOW_TAGS) then {"Enabled"} else {"Disabled"}], "PLAIN DOWN", 2];
		//_handeld = true;
	};
	_handeld;
};

// ADD BRIEFING SECTION
// A section is added to the player's briefing to inform them about name tags being available.
cursorTarget enableSimulationGlobal true;
[] spawn {
	_bstr = format ["<font size='18' color='#80FF00'>NAME TAGS</font><br/>Toggle name tags for friendly units below.<br/><br/>No information will be displayed for any units greater than %3m away.<br/>", 
		F_KEYNAME_TAGS, F_KEY_TAGS, F_DIST_TAGS];

	{
		_x params ["_title","_desc","_id","_off","_on","_color"];
		
		if (missionNamespace getVariable [str _id,""] == "") then {
			_bstr = _bstr + format["<br/><font color='#00FFFF'>%1</font> - %2 <font %6><execute expression=""%3 = true; hintSilent '%1: %5'; profileNamespace setVariable ['%3', %3]; saveProfileNamespace;"">%5</execute></font> | <font %7><execute expression=""%3 = false; hintSilent '%1: %4'; profileNamespace setVariable ['%3', %3]; saveProfileNamespace;"">%4</execute></font>",
				_title,
				_desc,
				_id,
				_off,
				_on,
				if (_color) then {"color='#80FF00'"} else {""},
				if (_color) then {"color='#CF142B'"} else {""}
			];
		};
	} forEach [
		["All Tags","Displaying of all unit tags: ","F_SHOW_TAGS","Disabled","Enabled",true],
		["Icon Display","Display Icons for: ","F_OVER_ONLY","Nearby Units","Cursor Only",false],
		["Icon Filter","Floating Icons for: ","F_TEAM_TAGS","Everyone","Team Only",false],
		["Group ID","Show when looking at a unit: ","F_GPID_TAGS","Deactivated","Activated",true],
		["Unit Name","Show when looking at a unit: ","F_NAME_TAGS","Deactivated","Activated",true],
		["Type Text","Show when looking at a unit: ","F_TYPE_TAGS","Deactivated","Activated",true],
		["Type Icon","Show all units ranks or types: ","F_TYPE_ICON","Rank","Type",false]
	];
			
	_bstr = _bstr + "<br/><br/><font size='18' color='#80FF00'>FONT TYPES</font><br/>Click on any of the following fonts to set the font type.<br/>
	<font face='EtelkaMonospaceProBold'><execute expression=""F_FONT_TAGS = 'EtelkaMonospaceProBold'; hintSilent 'Font: Etelka Bold'; profileNamespace setVariable ['F_FONT_TAGS', F_FONT_TAGS]; saveProfileNamespace;"">Etelka Bold</execute></font><br/>
	<font face='PuristaBold'><execute expression=""F_FONT_TAGS = 'PuristaBold'; hintSilent 'Font: Purista Bold'; profileNamespace setVariable ['F_FONT_TAGS', F_FONT_TAGS]; saveProfileNamespace;"">Purista Bold</execute></font> (Default)<br/>
	<font face='PuristaMedium'><execute expression=""F_FONT_TAGS = 'PuristaMedium'; hintSilent 'Font: Purista'; profileNamespace setVariable ['F_FONT_TAGS', F_FONT_TAGS]; saveProfileNamespace;"">Purista</execute></font><br/>
	<font face='RobotoCondensedBold'><execute expression=""F_FONT_TAGS = 'RobotoCondensedBold'; hintSilent 'Font: Roboto Bold'; profileNamespace setVariable ['F_FONT_TAGS', F_FONT_TAGS]; saveProfileNamespace;"">Roboto Bold</execute></font><br/>
	<font face='RobotoCondensed'><execute expression=""F_FONT_TAGS = 'RobotoCondensed'; hintSilent 'Font: Roboto'; profileNamespace setVariable ['F_FONT_TAGS', F_FONT_TAGS]; saveProfileNamespace;"">Roboto</execute></font><br/>";
	
	_bstr = _bstr + "<br/><font size='18' color='#80FF00'>FONT SIZE</font><br/>Click on any of the below options to set the font size.<br/>
	<execute expression=""if (F_SIZE_TAGS > 1) then { F_SIZE_TAGS = 1 } else { F_SIZE_TAGS = F_SIZE_TAGS + 0.005 };  hintSilent format['Tag Size: %1', F_SIZE_TAGS]; profileNamespace setVariable ['F_SIZE_TAGS', F_SIZE_TAGS]; saveProfileNamespace;"">+ Increase Font</execute><br/>
	<execute expression=""if (F_SIZE_TAGS < 0.01) then { F_SIZE_TAGS = 0.01 } else { F_SIZE_TAGS = F_SIZE_TAGS - 0.005 }; hintSilent format['Tag Size: %1', F_SIZE_TAGS]; profileNamespace setVariable ['F_SIZE_TAGS', F_SIZE_TAGS]; saveProfileNamespace;"">- Decrease Font</execute><br/>
	<execute expression=""F_SIZE_TAGS = 0.04;  hintSilent format['Tag Size: %1', F_SIZE_TAGS]; profileNamespace setVariable ['F_SIZE_TAGS', F_SIZE_TAGS]; saveProfileNamespace;"">Reset to Default</execute><br/>";

	//player removeDiaryRecord ["Diary", "NameTags (Options)"];
	player createDiaryRecord ["Diary", ["NameTags (Options)",_bstr]];
};

// ADD EVENTHANDLERS
// After the mission has initialized event handlers are added to the register key-presses.

sleep 0.1;

waitUntil {!isNull (findDisplay 46)}; // Make sure the display we need is initialized

if (!isNil "f_eh_nameKeys") then { (findDisplay 46) displayRemoveEventHandler ["keyDown", f_eh_nameKeys] };
f_eh_nameKeys = (findDisplay 46) displayAddEventHandler   ["keyDown", "_this spawn F_KEYDOWN_NAMETAG"];

// Set defaults in case they were missed
if (isNil "F_SIZE_TAGS") then { F_SIZE_TAGS = 0.04 };
if (isNil "F_FONT_TAGS") then { F_FONT_TAGS = "PuristaBold" };
if (isNil "F_TEAM_TAGS") then { F_MODE_TAGS = true };
if (isNil "F_NAME_TAGS") then { F_SHOW_TAGS = false };
if (isNil "F_GPID_TAGS") then { F_SHOW_TAGS = false };
if (isNil "F_TYPE_TAGS") then { F_SHOW_TAGS = false };
if (isNil "F_TYPE_ICON") then { F_NAME_TAGS = false };
if (isNil "F_OVER_ONLY") then { F_NAME_TAGS = true };

if (!isNil "f_eh_nameTags") then { removeMissionEventHandler ["Draw3D", f_eh_nameTags] };
f_eh_nameTags = addMissionEventHandler ["Draw3D", {
	if F_SHOW_TAGS then {
		{
			private _unit = _x;

			_dist = (player distance _unit) / F_DIST_TAGS;
			_colorIcon = [1,1,1,1];
			_colorName = [1,1,1,1];
			_colorRole = [1,0.75,0,1];
			_icon = format ["a3\Ui_f\data\GUI\Cfg\Ranks\%1_gs.paa",rank _unit];

			if (leader _unit == _unit) then {
				_colorIcon = [1,0.75,0,1];
				//_colorRole = [1,1,1,1];
				_icon = "a3\Ui_f\data\GUI\Cfg\Ranks\general_gs.paa";
			};
			
			if (F_TYPE_ICON) then {
				if (leader _unit == _unit) exitWith { _icon = "\A3\ui_f\data\map\vehicleIcons\iconManLeader_ca.paa" };
				_icon = getText (configFile >> "CfgVehicles" >> typeOf (vehicle _unit) >> "icon");
			};

			if (_unit getVariable "talking") then {
				_icon = selectRandom ["A3\Ui_f\data\GUI\Rsc\RscDisplayArsenal\voice_ca.paa"];
			};
			
			// Units of same group
			if(_unit in units player) then {
				switch (assignedTeam _unit) do {
					case "RED": {_colorIcon = [1,0,0,1]; };
					case "GREEN": {_colorIcon = [0,1,0,1]; };
					case "BLUE": {_colorIcon = [0,0.5,1,1]; };
					case "YELLOW": {_colorIcon = [1,1,0,1]; };
					default {_colorIcon = [1,1,1,1] };
				};
			};
			
			// Set role icon
			if (vehicle _unit != _unit) then {
				(((fullCrew (vehicle _unit)) select {_x#0 isEqualTo _unit})#0) params ["", "_role", "_index", "_turretPath", "_isTurret"];
				
				if (_role == "driver") exitWith { _icon = "a3\ui_f\data\igui\cfg\commandBar\imagedriver_ca.paa" };
				if (_role == "commander") exitWith { _icon = "a3\ui_f\data\igui\cfg\commandBar\imagecommander_ca.paa" };
				if (_role == "cargo") exitWith { _icon = "a3\ui_f\data\igui\cfg\commandBar\imagecargo_ca.paa" };
				if (_role == "turret" && _isTurret) exitWith { _icon = "a3\ui_f\data\igui\cfg\simpleTasks\types\rifle_ca.paa" };
				if (_role == "gunner" || (_role == "turret" && !_isTurret)) exitWith { _icon = "a3\ui_f\data\igui\cfg\commandBar\imagegunner_ca.paa" };
			};
						
			// Check if we're allowed to show the injured icons
			if (missionNamespace getVariable ["f_var_ShowInjured", true]) then {
				// Show incapacitated units if allowed
				if ((_unit getVariable["ACE_isUnconscious", false]) || lifeState _unit == "INCAPACITATED") then {
					_icon = "\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_forceRespawn_ca.paa";
					_colorIcon = [1,0.1,0.1,1];
				};
				
				// Show stabilised units if allowed
				if (_unit getVariable "FAR_var_isStable") then { 
					_icon = "\a3\ui_f\data\IGUI\Cfg\holdActions\holdAction_revive_ca.paa";
					_colorIcon = [0.7,0.0,0.6,1];
				};
			};

			_trans = 1 - _dist;
			
			if (_trans > 0.1) then {
				_colorIcon set [3, _trans min 0.6];
				_colorName set [3, _trans];
				_colorRole set [3, _trans];
							
				_posIcon = getPosVisual _unit;
				_height = [(if (surfaceIsWater _posIcon) then { (getPosASL _unit)#2 } else { (getPosATL _unit)#2 }) + 2, 3] select (vehicle _unit != _unit);
				_posIcon set [2, _height];
				
				_target = effectiveCommander vehicle cursorTarget;
				
				if (F_OVER_ONLY && _target != _unit) exitWith {};

				// Icon
				if (!F_TEAM_TAGS || _unit in units player || _target == _unit) then {
					drawIcon3D [
						_icon,
						_colorIcon,
						_posIcon,
						1,
						1,
						2,
						"",
						2,
						F_SIZE_TAGS * 0.7,
						F_FONT_TAGS
					];
				};
				
				if (_target == _unit || (!F_TEAM_TAGS && vehicle _unit != _unit)) then {
					// Name / Group
					drawIcon3D [
					"",
					_colorName,
					_posIcon,
					2,
					-1.40,
					0,
					format["%1%2",
						if (F_GPID_TAGS) then { if (group _unit != group player || !F_NAME_TAGS) then { format["%1%2", groupId (group _unit), [""," - "] select F_NAME_TAGS] } else { "" } } else { "" },
						if (F_NAME_TAGS) then { name _unit } else { ""}
					],
					2,
					F_SIZE_TAGS,
					F_FONT_TAGS,
					"Right"
					];

					// Role / Vehicle
					drawIcon3D [
					"",
					_colorRole,
					_posIcon,
					2,
					0.20,
					0,
					format["%1%2",
						if (F_TYPE_TAGS || vehicle _unit != _unit) then { getText (configFile >> "CfgVehicles" >> typeOf (vehicle _unit) >> "displayName") + " " } else { "" },
						if (vehicle _unit != _unit) then { format["[%1/%2] ", count fullCrew [vehicle _unit, "", false], count fullCrew [vehicle _unit, "", true]] } else { "" }
					],
					2,
					F_SIZE_TAGS * 0.7,
					F_FONT_TAGS,
					"Right"
					];
				};
			};
		} forEach ((playableUnits + switchableUnits - [player]) select {alive _x && (side group _x getFriend side group player) > 0.6 && (vehicle _x == _x || (effectiveCommander (vehicle _x)) == _x)});
	};
}];