// Draws Tag info for nearby units.

if (isNil "F_SHOW_TAGS") exitWith {};

if !F_SHOW_TAGS exitWith {};

// Set defaults in case they were missed
if (isNil "F_SIZE_TAGS") then { F_SIZE_TAGS = 0.04 };
if (isNil "F_FONT_TAGS") then { F_FONT_TAGS = "PuristaBold" };
if (isNil "F_TEAM_TAGS") then { F_TEAM_TAGS = true };
if (isNil "F_NAME_TAGS") then { F_SHOW_TAGS = true };
if (isNil "F_GPID_TAGS") then { F_GPID_TAGS = true };
if (isNil "F_TYPE_TAGS") then { F_TYPE_TAGS = true };
if (isNil "F_TYPE_ICON") then { F_TYPE_ICON = true };
if (isNil "F_OVER_ONLY") then { F_OVER_ONLY = false };

{
	private _unit = _x;

	_dist = (player distance _unit) / (missionNamespace getVariable ['F_DIST_TAGS', 60]);
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