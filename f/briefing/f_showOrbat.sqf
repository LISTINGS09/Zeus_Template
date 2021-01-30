// F3 - ORBAT Notes
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================
// MAKE SURE THE PLAYER INITIALIZES PROPERLY
if !hasInterface exitWith {};
if (!isDedicated && (isNull player)) then {
    waitUntil {uiSleep 0.1; !isNull player};
};

waitUntil{!isNil "f_var_setGroupsIDs";};

["f_showOrbatNotes.sqf","Started","DEBUG"] call f_fnc_logIssue;

private _orbatText = "<br/><font size='18' color='#80FF00'>ORDER OF BATTLE</font><br/>The ORBAT below is <b>ONLY</b> accurate at mission start.<br/><br/>";
private _groups = [];
private _hiddenGroups = missionNamespace getVariable["f_var_hiddenGroups",[]]; // Add hidden groups if param is set.
private  _stringFilter = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_- .,/[]()";

{
	// Add to ORBAT if side matches, group isn't already listed, group has players and isn't in the hidden groups.
	if ((side _x == side group player) && !(_x in _groups) && ({_x in playableUnits + switchableUnits} count units _x) > 0 && !(_x in _hiddenGroups)) then {
		_groups pushBack _x;
	};
} forEach allGroups;

// Loop through the group, print out group ID, leader name and medics.
// If group is players group, expand to incude all units and their weapons.
{
	private _groupName = groupId _x;
	private _color = "#397200";
	
	// Highlight the player's group with a different color (based on the player's side)	
	if (_x == group player) then { _color = "#00FFFF"; };
	
	_orbatText = _orbatText + format ["<font color='%3'>%1</font> - %2",_groupName, name leader _x,_color] + "<br />";
	
	{
		if (_x getVariable ["f_var_assignGear",""] == "m" && {_x != leader group _x}) then {
			_orbatText = _orbatText + format["<i><font color='%3'>%1 Medic</font></i> - %2",_groupName,name _x,_color] + "<br />";
		};
	} forEach units _x;
} forEach _groups;

// Show all members of the group and their weapons.
_orbatText = _orbatText + format["<br /><font size='18' color='#80FF00'>%1 GROUP</font><br />",toUpper(groupId group player)];
	
_orbatText = _orbatText + format["Assume <execute expression=""
		if (leader group player != player and time > 0 and alive player) then {
			[group player, player] remoteExec ['selectLeader',group player];
			'%1 has taken lead of %2' remoteExec ['systemChat',group player];
		};
	"">leadership of %2</execute> to update the location of any group marker.<br/><br/>",name player, groupId (group player)];

// Team Colour Switch
_orbatText = _orbatText + "Switch or reset your fire-team colour, by clicking on any colour below:<br/>";

{
	_x params ["_hex","_txt","_cmd"];
	_orbatText = _orbatText + format["[<font color='#%1'><execute expression=""if (assignedTeam player != '%2') then { [player,'%2'] remoteExec ['assignTeam', group player] };"">%3</execute></font>]  ", _hex, _cmd, _txt];
} forEach [
	["FFFFFF","White","MAIN"],
	["FF0000","Red","RED"],
	["0000FF","Blue","BLUE"],
	["00FF00","Green","GREEN"],
	["FFFF00","Yellow","YELLOW"]
];

_orbatText = _orbatText + "<br/>";

{	
	private _color = "#999999";
	if (_x == player) then { _color = "#72E500"; };
	
	_orbatText = _orbatText + format["<br/><img image='%4' height='16'/> <font color='%3'>%1</font> (%2)",
		name _x,
		([getText (configFile >> "CfgVehicles" >> (typeOf _x) >> "displayName"),_stringFilter] call BIS_fnc_filterString),
		_color,
		(getText (configFile >> "CfgVehicles" >> (typeOf _x) >> "icon") call bis_fnc_textureVehicleIcon)
	];
	
	// All weapons minus the field glasses				
	{
		if (_x != "") then { 
			_orbatText = _orbatText + format[" <font color='#666666'>+ %1</font>",[getText (configFile >> "CfgWeapons" >> _x >> "displayName"),_stringFilter] call BIS_fnc_filterString];
		};
	} forEach [primaryWeapon _x,secondaryWeapon _x];
} forEach units group player;

private _getWeaponText = {
	params ["_veh"];
	private _returnText = "";
	
	// Check if is a support
	if (getFuelCargo _veh > 0 || getAmmoCargo _veh > 0 || getRepairCargo _veh > 0) then { _returnText = _returnText + "<font color='#666666'>Support Vehicle</font><br/>"; };
	
	if (_veh lockedTurret [0]) exitWith { "<font color='#666666'>Turret Disabled</font><br/>" };
	
	private _allWeapons = [];
	{ _allWeapons append (_veh weaponsTurret _x) } forEach ([[-1]] + allTurrets [_veh, true]);
	
	// List weapons and ammo
	{
		private ["_vehWep", "_skip"];
		_vehWep = _x;
		_skip = FALSE;
		{
			
			if ((toLower _vehWep) find _x >= 0 || (toLower getText (configFile >> "CfgWeapons" >> _x >> "displayName")) find _x >= 0) exitWith {
				_skip = TRUE 
			}; 
		} forEach ["ircm","_fcs"];
		
		if !_skip then {
			private ["_wepMags", "_magName", "_count", "_vehMags"];
			// Loop all Magazines for Weapon
			_wepMags = getArray (configFile >> "CfgWeapons" >> _x >> "magazines");
			{_wepMags set [_forEachIndex, toLower _x]} forEach _wepMags; // Convert to lower-case because RHS is bad.
			
			_magName = [];
			_count = 0;
			{
				if (toLower (_x select 0) in _wepMags) then {
					_magName pushBackUnique getText (configFile >> "CfgMagazines" >> _x#0 >> "displayName");
					_count = _count + _x#2;
				};
			} forEach magazinesAllTurrets _veh;
		
			_vehMags = [if (_count > 1) then { format["%1x", _count] } else {""}, if (count _magName > 0) then { format["%1", _magName joinString ", "] } else { "" }];
			_vehMags = _vehMags - [""];
			
			if !(_vehMags isEqualTo []) then {
				_returnText = _returnText + format ["<font color='#666666'>%1</font> <font color='#444444'>%2</font><br/>", 
					getText (configFile >> "CfgWeapons" >> _x >> "displayName"), 
					if (count _vehMags > 0) then { "(" + (_vehMags  joinString " ") + ")" } else { "" }
				];
			};
		};
	} forEach _allWeapons;

	_returnText
};


// Show vehicle crew and cargo.
_vehArray = [];
{
	if ({vehicle _x != _x} count units _x > 0 ) then {
		{
			if (vehicle _x != _x && {!(vehicle _x in _vehArray)}) then { _vehArray pushBack (vehicle _x) };
		} forEach units _x;
	};
} forEach _groups;

if (count _vehArray > 0) then {
	_orbatText = _orbatText + "<br/><br/><font size='18' color='#80FF00'>VEHICLE CREWS + PASSENGERS</font><br/>";

	{
		 // Filter all characters which might break the diary entry (such as the & in Orca Black & White)
		private _vehName = [getText (configFile >> "CfgVehicles" >> (typeOf _x) >> "displayName"),_stringFilter] call BIS_fnc_filterString;
		private _vehIcon = getText (configFile >> "CfgVehicles" >> (typeOf _x) >> "icon");
		private _vehCrewIn = count fullCrew [_x, "commander", FALSE] + count fullCrew [_x, "driver", FALSE] + count fullCrew [_x, "gunner", FALSE];
		private _vehCrew = count fullCrew [_x, "commander", TRUE] + count fullCrew [_x, "driver", TRUE] + count fullCrew [_x, "gunner", TRUE];
		private _vehPassIn = count fullCrew [_x, "", FALSE] - _vehCrewIn;
		private _vehPass = count fullCrew [_x, "", TRUE] - _vehCrew;
		
		_orbatText = _orbatText + "<br />" + format["<img image='%1' width='16' height='16'/> <font color='#72E500'>%2</font> ",_vehIcon,_vehName];

		if (_vehCrew + _vehPass > 0) then {
			_orbatText = _orbatText + format ["<font color='#777777'>(%1/%2 Crew%3)</font>", _vehCrewIn, _vehCrew, if (_vehPass > 0) then { format[" %1/%2 Seat%3", _vehPassIn, _vehPass, if (_vehPass > 1) then { "s" } else { "" }] } else { "" }];
		};
		
		// Object must be named in 3DEN
		if (count getPylonMagazines _x > 1) then {
			_orbatText = _orbatText + format[" <execute expression=""if !(missionNamespace getVariable ['diary_%1', false]) then { systemChat '[%2] Added ''Pylons (%2)'' Diary'; ['%1'] execVM 'f\misc\f_pylons.sqf' }"">Pylons</execute>", typeOf _x, _vehName];
		};
		
		// Add lists of weapons and ammo
		_orbatText = _orbatText + "<br/>" + (_x call _getWeaponText);

		{
			if ((assignedVehicleRole _x select 0) != "CARGO") then {
				private _veh = vehicle _x;
				private _crewrole = switch (true) do {
					case (driver _veh == _x && !((vehicle _x isKindOf "helicopter") || (vehicle _x isKindOf "plane"))):{" <font color='#777777'>Driver:</font>"};
					case (driver _veh == _x && ((vehicle _x isKindOf "helicopter") || (vehicle _x isKindOf "plane"))):{" <font color='#777777'>Pilot:</font>"};
					case (commander _veh == _x):{" <font color='#777777'>Commander:</font>"};
					case (gunner _veh == _x):{" <font color='#777777'>Gunner:</font>"};
					case (assignedVehicleRole _x select 0 == "Turret" && commander _veh != _x && gunner _veh != _x && driver _veh != _x):{" <font color='#777777'>Co-Pilot:</font>"};
					default {" <font color='#777777'>Crew:</font>"};
				};
				_orbatText = _orbatText + format["%1 %2<br/>",_crewrole,name _x];
			};
		} forEach crew _x;

		private _groupList = [];

		{
			if (!(group _x in _groupList) && {(assignedVehicleRole _x select 0) == "CARGO"} count (units group _x) > 0) then {
				_groupList pushBack (group _x);
			};
		} forEach crew _x;

		if (count _groupList > 0) then {
			{
				_orbatText =_orbatText + format["<font color='#777777'>In Cargo:</font> %1",groupId _x] + "<br/>";
			} forEach _groupList;
		};
	} forEach _vehArray;
};

// Find nearby empty vehicles.
_vehArray = [];
{
	private _veh = _x;
	{
		{
			if (_veh distance2D _x < 100) exitWith { _vehArray pushBackUnique _veh };
		} forEach units _x;
	} forEach _groups;
} forEach (vehicles select { count (crew _x) == 0 && locked _x <= 1 && fuel _x > 0 && _x isKindOf "AllVehicles" && typeOf _x != "ACE_friesAnchorBar" });

if (count _vehArray > 0) then {
	_orbatText = _orbatText + "<br/><br/><font size='18' color='#80FF00'>OTHER VEHICLES</font><br/>All empty vehicles available near units:<br/><br/>";
	
	_vehSorted = [];
	
	{
		private ["_vehObj", "_vehName", "_vehIcon", "_vehCrew", "_vehPass", "_vehText"];
		_vehObj = _x;

		_vInd = _vehSorted findIf {_x#0 == typeOf _vehObj};
		
		// Skip duplicate vehicles
		if (_vInd < 0 ) then {
			 // Filter all characters which might break the diary entry (such as the & in Orca Black & White)
			_vehName = [getText (configFile >> "CfgVehicles" >> (typeOf _vehObj) >> "displayName"),_stringFilter] call BIS_fnc_filterString;
			_vehIcon = getText (configFile >> "CfgVehicles" >> (typeOf _vehObj) >> "icon");
			_vehCrew = count fullCrew [_vehObj, "commander", TRUE] + count fullCrew [_vehObj, "driver", TRUE] + count fullCrew [_vehObj, "gunner", TRUE];
			_vehPass = count fullCrew [_vehObj, "", TRUE] - _vehCrew;
			_vehText = format["<img image='%1' width='16' height='16'/> <font color='#72E500'>%2</font>^ <font color='#397200'>(%3%4)</font>", 
				_vehIcon,
				_vehName,
				if (_vehPass <= 1 && _vehObj isKindOf "car") then { format["%1 Driver", _vehCrew] } else { format["%1 Crew", _vehCrew] },
				if (_vehPass > 0) then { format[" %1 Seat%2", _vehPass, if (_vehPass > 1) then { "s" } else { "" }] } else { "" }
			];
			
			if (count getPylonMagazines _vehObj > 1) then {
				_vehText = _vehText + format[" <execute expression=""if !(missionNamespace getVariable ['diary_%1', false]) then { systemChat '[%2] Added ''Pylons (%2)'' Diary'; ['%1'] execVM 'f\misc\f_pylons.sqf' }"">Pylon Template</execute>", typeOf _vehObj, _vehName];
			};
			
			_vehText = _vehText + "<br/>";
			
			
			if (getNumber (configFile >> "CfgVehicles" >> (typeOf _vehObj) >> "ace_fastroping_enabled") == 1 || !(isNull (_vehObj getVariable ["ace_fastroping_fries",objNull]))) then {
				_vehText = _vehText + "<font color='#666666'>Fast Rope Insertion/Extraction System</font><br/>";
			};

			// Add lists of weapons and ammo	
			_vehText = _vehText + (_vehObj call _getWeaponText) + "<br/>";
			
			_vehSorted pushBack [typeOf _vehObj, _vehText, 1];
		} else {
			_vTemp = _vehSorted # _vInd;
			_vTemp set [2, (_vTemp # 2) + 1]; // Add +1 Count
			_vehSorted set [_vInd, _vTemp];
		};
	} forEach _vehArray;
	
	_vehSorted sort TRUE;
	
	{
		_tempArr = _x#1 splitString "^";
		_orbatText = _orbatText + format["%1%2%3", _tempArr#0, if (_x#2 > 1) then { format[" x%1",_x#2] } else {""}, _tempArr#1];
	} forEach _vehSorted;
};

_orbatText = _orbatText + "<br/><br/>Add a Pylon Template for any vehicle while inside it:<br/><execute expression=""if (vehicle player != player AND count getPylonMagazines vehicle player > 1 AND isNil format['diary_%1', typeOf vehicle player]) then { [typeOf vehicle player] execVM 'f\misc\f_pylons.sqf' }"">Create Pylon Template</execute><br/><br/>";

// Insert final result into subsection ORBAT of section Notes
//player removeDiaryRecord ["Diary", "ORBAT"];
_orb = player createDiaryRecord ["Diary", ["ORBAT", _orbatText]];