// F3 - Draw Nametag
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================

private ["_color","_str","_height","_showgroup","_showdis","_showveh","_veh"];

// Declare variables

params ["_u","_pos",["_suffix",""]];

_height = switch (stance _u) do {
		case "CROUCH": {
			F_HEIGHT_CROUCH_NAMETAGS;
		};
		case "PRONE": {
			F_HEIGHT_PRONE_NAMETAGS;
		};
		default {F_HEIGHT_STANDING_NAMETAGS};
	};

_str = name _u + _suffix;

//If the unit is dead, exit.
if (!alive _u) exitWith {};

// Define the color of the nametag
_color = F_COLOR_NAMETAGS; // Default color
if (_suffix != "") then {_color = F_COLOR2_NAMETAGS};			// Mounted units
if(_u in units player) then {
	switch (assignedTeam _u) do {
		case "RED": {_color = [1,0,0,0.7]; };
		case "GREEN": {_color = [0,1,0,0.7]; };
		case "BLUE": {_color = [0,0.5,1,0.7]; };
		case "YELLOW": {_color = [1,1,0,0.7]; };
		default {_color = F_GROUPCOLOR_NAMETAGS };
	};
}; // Units of same group


// Check which tags to show
_showgroup = if (!isNil "F_SHOWGROUP_NAMETAGS") then [{F_SHOWGROUP_NAMETAGS},{false}];
_showdis = if (!isNil "F_SHOWDISTANCE_NAMETAGS") then [{F_SHOWDISTANCE_NAMETAGS},{false}];
_showveh = if (!isNil "F_SHOWVEHICLE_NAMETAGS") then [{F_SHOWVEHICLE_NAMETAGS},{false}];

// Show group name for other groups only
if (_showgroup && group _u != group player) then {_str = format ["(%1) ",groupID (group _u)] + _str};

// Show distance for units in over 3m distance only
if (_showdis && {_pos distance player >= 3}) then {
	_str = _str + format [" - %1m",round (_pos distance player)];
};

drawIcon3D ["", _color, [_pos#0,_pos#1,(_pos#2) + _height], 0, 0, 0, _str, F_SHADOW_NAMETAGS, F_SIZE_NAMETAGS, F_FONT_NAMETAGS];

// Show vehicle type only for vehicles the player is not crewing himself
if (_showveh && {!(typeOf (vehicle _u) isKindof "Man") && vehicle _u != vehicle player && ((_u == driver vehicle _u) || (_u == gunner vehicle _u))}) then {
  _str = format ["%1",getText (configFile >> "CfgVehicles" >> (typeOf vehicle _u) >> "displayName")];
  drawIcon3D ["", _color, [_pos#0,_pos#1,(_pos#2) + _height - 0.2], 0, 0, 0, _str,F_SHADOW_NAMETAGS,F_SIZE_NAMETAGS,F_FONT_NAMETAGS];
};