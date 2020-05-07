// Creates a custom briefing section to switch pylons BEORE mission start.
params [["_veh", objNull]];

if (isNil "f_pylon_disabled") then { f_pylon_disabled = false }; // Use this to exclude certain players / roles
if (isNil "f_pylon_excludeMagazines") then { f_pylon_excludeMagazines = ["PylonRack_4Rnd_BombDemine_01_F"] }; // Exclude any pylons from CfgMagazines here.
if (isNil "f_pylon_timeLimit") then { f_pylon_timeLimit = 300 }; // Allow 5 minutes to configure pylons at start.

if (isNull _veh || f_pylon_disabled ) exitWith {};

private _vID = vehicleVarName _veh;
private _type = typeOf _veh;
private _pylons = _veh getCompatiblePylonMagazines 0;

if (count _pylons < 1) exitWith {}; // Nothing to do!

if !(f_pylon_excludeMagazines isEqualType []) then { systemChat "[Pylon] Excluded Magazine list must be of type ARRAY!"; f_pylon_excludeMagazines = []; };

// Briefing needs a named object to reference, create a local one if it doesn't exist.
if (vehicleVarName _veh == "") then {
	if (isNil "var_pylonID") then { var_pylonID = 1 };
	_vID = format["pylon_%1", var_pylonID];
	missionNamespace setVariable [_vID, _veh];
	systemChat format["[Pylon] Invalid Vehicle ID (%1) - Assigned: %2",typeOf _veh, _vID];
	var_pylonID = var_pylonID + 1;
};

private _pylonRecord = "<font size='18' color='#FF7F00'>Pylon Loadout</font><br/>";
_pylonRecord = _pylonRecord + format["%1 <font color='#AAAAAA'>(%2 Pylons)</font>", getText (configFile >> "CfgVehicles" >> _type >> "displayName"), count (getPylonMagazines _veh)];
_pylonRecord = _pylonRecord + format[" | <execute expression=""if (isMultiplayer AND time > f_pylon_timeLimit) exitWith {}; private _railFull = []; private _railNone = [];
	{
		private _pylon = str (_forEachIndex + 1);
		if (_x == '') then {
			_railNone pushBack _pylon;
		} else {
			private _mag = getText (configFile >> 'CfgMagazines' >> _x >> 'displayName');
			private _loc = _railFull findIf { _x#0 == _mag };
			
			if (_loc >= 0) then {
				_railFull set [_loc, [_mag, (_railFull#_loc#1) + ', ' + _pylon]];
			} else {
				_railFull pushBack [_mag, _pylon];
			};
		};
	} forEach (getPylonMagazines %1); 

	if (count _railNone > 0) then {
		systemChat ('[Pylon] Empty: ' + (_railNone joinString ', '));
	}; 
	
	if (count _railFull > 0) then {
		private _railText = _railFull apply { (_x#0) + ' (' + (_x#1) + ')' };
		systemChat ('[Pylon] Loaded: ' + (_railText joinString ' '));
	}; 
	systemChat _rails;
"">List Loadout</execute><br/>", _vID];
_pylonRecord = _pylonRecord + format["<img image='%1' height='64'/>", getText (configFile >> "CfgVehicles" >> _type >> "icon") call BIS_fnc_textureVehicleIcon];

// List load-out pre-sets
_pylonRecord = _pylonRecord + "<br/><br/><font size='14' color='#FF7F00'>Preset Loadouts</font><br/>";
_pylonRecord = _pylonRecord + format["<execute expression=""if (isMultiplayer AND time > f_pylon_timeLimit) exitWith {}; { [%1,[_forEachIndex + 1, '']] remoteExec ['setPylonLoadout', %1] } forEach (getPylonMagazines %1); systemChat '[Pylon] Set Template: Empty';"">Empty</execute>", _vID];

{
	if !(toUpper (configName _x) in ['EMPTY','NONE']) then {
		_pylonRecord = _pylonRecord + format[" | <execute expression=""if (isMultiplayer AND time > f_pylon_timeLimit) exitWith {}; { [%1,[_forEachIndex + 1, _x]] remoteExec ['setPylonLoadout', %1] } forEach (getArray (configFile >> 'CfgVehicles' >> '%2' >> 'Components' >> 'TransportPylonsComponent' >> 'Presets' >> '%3' >> 'attachment')); systemChat '[Pylon] Set Template: %3';"">%3</execute>", _vID, _type, getText (_x >> "displayName"), configName _x];
	};
} forEach ("true" configClasses (configFile >> "CfgVehicles" >> _type >> "Components" >> "TransportPylonsComponent" >> "Presets"));

_pylonRecord = _pylonRecord + "<br/><br/><font size='14' color='#FF7F00'>Custom Loadouts</font><br/>Click any of the corresponding numbers after the Magazine to customise the vehicle pylon.<br/><br/>";

private _magazines = [];
{{ _magazines pushBackUnique _x } forEach _x } forEach _pylons; // Build list of unique mags.

// For each mag, add 
{
	_x params ["_mag"];
	
	_name = getText (configFile >> "CfgMagazines" >> _mag >> "displayName");
	_pylonRecord = _pylonRecord + format["<font size='12' color='#FF7F00'>%1 </font>", _name];

	{
		private _pylonNo = _forEachIndex + 1;
		if (_mag in _x) then { _pylonRecord = _pylonRecord + format[" | <font size='12'> <execute expression=""if (isMultiplayer AND time > f_pylon_timeLimit) exitWith {}; systemChat '[Pylon] #%2 Equipped: %3'; [%4, [%2, '%5', true]] remoteExec ['setPylonLoadout', %4];"">%1</execute></font>", if (_pylonNo > 9) then { _pylonNo } else { '0' + str _pylonNo }, _pylonNo, _name, _vID, _mag] };
	} forEach _pylons;
	
	_pylonRecord = _pylonRecord + format["<br/><font size='10'>%1</font><br/>", getText (configFile >> "CfgMagazines" >> _mag >> "descriptionShort")];
	//_pylonRecord = _pylonRecord + format["<font size='10' color='#666666'>(%1)</font><br/>", _mag]; // DEBUG - Show Magazine class name
} forEach (_magazines - f_pylon_excludeMagazines);

player createDiaryRecord ["diary", [format["Pylons (%1)", getText (configFile >> "CfgVehicles" >> _type >> "displayName")], _pylonRecord]];