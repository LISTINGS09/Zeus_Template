// F3 - Nametags
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================

// MAKE SURE THE PLAYER INITIALIZES PROPERLY

if (!isDedicated && (isNull player)) then {
    waitUntil {sleep 0.1; !isNull player};
};

// Only run in MP and for valid players!
if (!isMultiplayer || !hasInterface || playerSide == sideLogic) exitWith {};

f_fnc_drawNameTag = compileFinal preprocessFileLineNumbers "f\nametag\fn_drawNametag.sqf";

// SET GLOBAL VARIABLES

// MODIFYABLE

// Default values (can be modified by players in the briefing entry)
// Comment any of these to deactivate the feature entirely
F_SHOWGROUP_NAMETAGS = true;	 // Show unit's group next to unit name (except for player's own group)
F_SHOWDISTANCE_NAMETAGS = false; // Show distance to unit under name
F_SHOWVEHICLE_NAMETAGS = false;  // Show type of vehicle under driver's name
F_SHOWCURSORONLY_NAMETAGS = false; // Show only units under cursor target (disable 360° view)

// Other values
F_DISTCURSOR_NAMETAGS = 100;	// Distance to display name tag for unit under cursor
F_DISTALL_NAMETAGS = 25;		// Distance to display name tags for all units around
F_KEY_NAMETAGS =  "TeamSwitch"; // The action key to toggle the name tags. See possible keys here: http://community.bistudio.com/wiki/Category:Key_Actions

// Display values
F_SIZE_NAMETAGS = 0.035; // The size the names are displayed in
F_HEIGHT_STANDING_NAMETAGS = 2; // Height above standing infantry unit
F_HEIGHT_CROUCH_NAMETAGS = 1.5; // Height above crouching infantry unit
F_HEIGHT_PRONE_NAMETAGS = 0.9;  // Height above prone infantry unit
F_VHEIGHT_NAMETAGS = 0; // The height of the name tags for units in vehicles (0 = hovering over vehicle)
F_SHADOW_NAMETAGS = 2; // The shadow for the name tags (0 - 2)
F_COLOR_NAMETAGS =  [1,1,1,0.9]; // The color for infantry and units in vehicle cargo (in [red,green, blue, opacity])
F_COLOR2_NAMETAGS = [1,0.1,0.2,0.9]; // The color for units in driver, gunner and other vehicle positions positions
F_GROUPCOLOR_NAMETAGS = [0,1,0.7,0.9]; // The color for units of the same group
F_FONT_NAMETAGS = "PuristaBold"; // Font for the names

// SCRIPTSIDE

F_DRAW_NAMETAGS = true;
F_ACTIONKEY_NAMETAGS = (actionKeys F_KEY_NAMETAGS)#0;
F_KEYNAME_NAMETAGS = actionKeysNames F_KEY_NAMETAGS;
if (isNil "F_ACTIONKEY_NAMETAGS") then {F_ACTIONKEY_NAMETAGS = 22; F_KEYNAME_NAMETAGS = 'U';}; // If the user has not bound 'TeamSwitch' to a key we default to 'U' to toggle the tags

F_KEYDOWN_NAMETAG = {
	_key = _this#1;
	_handeld = false;
	if(_key == F_ACTIONKEY_NAMETAGS) then
	{
		F_DRAW_NAMETAGS = !F_DRAW_NAMETAGS;
		titleText [format["%1 unit tags", if (F_DRAW_NAMETAGS) then {"Enabled"} else {"Disabled"}], "PLAIN DOWN", 2];
		_handeld = true;
	};
	_handeld;
};

// ADD BRIEFING SECTION
// A section is added to the player's briefing to inform them about name tags being available.

[] spawn {
	_bstr = format ["<font size='18' color='#80FF00'>NAME TAGS</font><br/>Toggle name tags for friendly units below.<br/><br/>
Name tags are displayed when aiming at individual units up to %4m away, and constantly for all units within %3m.
        ", F_KEYNAME_NAMETAGS, F_KEY_NAMETAGS, F_DISTALL_NAMETAGS, F_DISTCURSOR_NAMETAGS];

        _bstr = _bstr + "<br/><br/>[<execute expression=""
                if (F_DRAW_NAMETAGS) then [{hintSilent 'Tags deactivated!';F_DRAW_NAMETAGS= false},{F_DRAW_NAMETAGS = true;hintSilent 'Tags activated!'}];""
                >ENABLE NAMETAGS</execute>] Toggle tags for nearby units.";

        if !(isNil "F_SHOWGROUP_NAMETAGS") then {
                _bstr = _bstr + "<br/><br/>[<execute expression=""
                if (F_SHOWGROUP_NAMETAGS) then [{hintSilent 'Group display deactivated!';F_SHOWGROUP_NAMETAGS= false},{F_SHOWGROUP_NAMETAGS = true;hintSilent 'Group display activated!'}];""
                >TOGGLE GROUP NAME</execute>] Toggle group name next to a unit.";
        };

        if !(isNil "F_SHOWDISTANCE_NAMETAGS") then {
                _bstr = _bstr + "<br/><br/>[<execute expression=""
                if (F_SHOWDISTANCE_NAMETAGS) then [{hintSilent 'Distance display deactivated!';F_SHOWDISTANCE_NAMETAGS= false},{F_SHOWDISTANCE_NAMETAGS = true;hintSilent 'Distance display activated!'}];""
                >TOGGLE DISTANCE</execute>] Toggle distance from units.";
        };

        if !(isNil "F_SHOWVEHICLE_NAMETAGS") then {
                _bstr = _bstr + "<br/><br/>[<execute expression=""
                if (F_SHOWVEHICLE_NAMETAGS) then [{hintSilent 'Vehicle type display deactivated!';F_SHOWVEHICLE_NAMETAGS= false},{F_SHOWVEHICLE_NAMETAGS = true;hintSilent 'Vehicle type display activated!'}];""
				>TOGGLE VEHICLE TYPE</execute>] Toggle vehicle type under driver.";
        };
			
	_bstr = _bstr + "<br/><br/><font size='18' color='#80FF00'>FONT TYPES</font><br/>Click on any of the following fonts to set the font type.<br/>
	[<font face='EtelkaMonospaceProBold'><execute expression=""F_FONT_NAMETAGS = 'EtelkaMonospaceProBold';"">Etelka Bold</execute></font>]<br/>
	[<font face='PuristaBold'><execute expression=""F_FONT_NAMETAGS = 'PuristaBold';"">Purista Bold</execute></font>] (Default)<br/>
	[<font face='PuristaMedium'><execute expression=""F_FONT_NAMETAGS = 'PuristaMedium';"">Purista</execute></font>]<br/>
	[<font face='RobotoCondensedBold'><execute expression=""F_FONT_NAMETAGS = 'RobotoCondensedBold';"">Roboto Bold</execute></font>]<br/>
	[<font face='RobotoCondensed'><execute expression=""F_FONT_NAMETAGS = 'RobotoCondensed';"">Roboto</execute></font>]<br/>";
	
	_bstr = _bstr + "<br/><font size='18' color='#80FF00'>FONT SIZE</font><br/>Click on any of the below options to set the font size.<br/>
	[<execute expression=""if (f_size_Nametags > 1) then { f_size_Nametags = 1 } else { f_size_Nametags = f_size_Nametags + 0.01 };  hintSilent format['Tag Size: %1', f_size_Nametags];"">Increase Font</execute>]<br/>
	[<execute expression=""if (f_size_Nametags < 0.01) then { f_size_Nametags = 0.015 } else { f_size_Nametags = f_size_Nametags - 0.01 }; hintSilent format['Tag Size: %1', f_size_Nametags];"">Decrease Font</execute>]<br/>
	[<execute expression=""f_size_Nametags = 0.035;  hintSilent format['Tag Size: %1', f_size_Nametags];"">Reset to Default</execute>]<br/>
	";

	//player removeDiaryRecord ["Diary", "NameTags (Options)"];
	player createDiaryRecord ["Diary", ["NameTags (Options)",_bstr]];
};

// ADD EVENTHANDLERS
// After the mission has initialized event handlers are added to the register key-presses.

sleep 0.1;

waitUntil {!isNull (findDisplay 46)}; // Make sure the display we need is initialized

// DISABLE Tags for Regular Members
if (count (squadParams player) > 0) then {
	if (toUpper ((squadParams player) # 0 # 0) == "ZEUS") then { F_DRAW_NAMETAGS = false };
};

if (isClass(configFile >> "CfgPatches" >> "ace_main")) then { F_DRAW_NAMETAGS = false };

//(findDisplay 46) displayAddEventHandler   ["keyup", "_this call F_KEYUP_NAMETAG"];
(findDisplay 46) displayAddEventHandler   ["keydown", "_this call F_KEYDOWN_NAMETAG"];

addMissionEventHandler ["Draw3D", {

	if(F_DRAW_NAMETAGS) then {
	
		private ["_ents","_veh","_color","_inc","_suffix","_pos","_angle"];

		_ents = [];

		// Unless disabled, collect all entities in the relevant distance
		if !(F_SHOWCURSORONLY_NAMETAGS) then {
			_ents = (position player) nearEntities [["CAManBase","LandVehicle","Helicopter","Plane","Ship_F"], F_DISTALL_NAMETAGS];
		};

		if (!(cursorTarget in _ents) && {(player distance cursorTarget) <= F_DISTCURSOR_NAMETAGS}) then {_ents append [cursorTarget]};

		// Start looping through all entities
		{
			// Filter entities
			if (
				// Only for the player's side
				(side _x == side player || {group _x == group player}) &&
				// Only other players & no virtual units
				{_x != player && !(player isKindOf "VirtualMan_F")}
				)
			then {
				// If the entity is Infantry
				if((typeOf _x) isKindOf "Man") then {
					_pos = getPosVisual _x;
					
					if (surfaceIsWater _pos) then { _pos set [2, (getPosASL _x)#2] }; 
					
					[_x,_pos] call f_fnc_drawNameTag;
				} else {
					// Else (if it's a vehicle)
					_veh = _x;
					_inc = 1;
					_alternate = 0;

					{
						// Get the various crew slots
						_suffix = switch (true) do {
							case (driver _veh == _x && !((_veh isKindOf "helicopter") || (_veh isKindOf "plane"))):{" [D]"};
							case (driver _veh == _x && ((_veh isKindOf "helicopter") || (_veh isKindOf "plane"))):{" [P]"};
							case (commander _veh == _x);
							case (effectiveCommander _veh == _x):{" [CO]"};
							case (gunner _veh == _x):{" [G]"};
							case (assignedVehicleRole _x select 0 == "Turret" && commander _veh != _x && gunner _veh != _x && driver _veh != _x):{" [C]"};
							default {""};
						};

						_pos = getPosVisual _x;

						// Only display tags for non-driver crew and cargo if player is up close
						if (effectiveCommander _veh == _x || group _x == group player || _pos distance player <= F_DISTALL_NAMETAGS) then {

							// If the unit is the driver, calculate the available and taken seats
							if (effectiveCommander _veh == _x) then {
								// Workaround for http://feedback.arma3.com/view.php?id=21602
								_maxSlots = getNumber(configFile >> "CfgVehicles" >> typeOf _veh >> "transportSoldier") + (count allTurrets [_veh, true] - count allTurrets _veh);
								_freeSlots = _veh emptyPositions "cargo";

								if (_maxSlots > 0) then {
									_suffix = _suffix + format [" (%1/%2)",(_maxSlots-_freeSlots),_maxSlots];
								};
							};

							// If the unit is in a turret, a passenger or the driver
							if (_pos distance (getPosVisual (driver _veh)) > 0.1 || driver _veh == _x) then {
								[_x,_pos,_suffix] call f_fnc_drawNameTag;
							} else {
								// Gunners and all other slots 
								if(_x == gunner _veh) then {
									_pos = [_veh modelToWorld (_veh selectionPosition "gunnerview") select 0,_veh modelToWorld (_veh selectionPosition "gunnerview") select 1,(visiblePosition _x) select 2];
								} else {
									_angle = (getDir _veh)+180;
									_pos = [((_pos select 0) + sin(_angle)*(0.6*_inc)) , (_pos select 1) + cos(_angle)*(0.6*_inc),_pos select 2 + F_VHEIGHT_NAMETAGS];
									_inc = _inc + 1;
								};

								[_x,_pos,_suffix] call f_fnc_drawNameTag;
							};
						};
					} forEach crew _veh;
				};
			};
		} forEach _ents;
	};
}];