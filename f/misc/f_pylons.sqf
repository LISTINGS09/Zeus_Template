// Creates a custom briefing section to switch pylons mission start.
// Must have vehicle named in EDITOR 
// [] execVM "f\misc\f_pylons.sqf";
params [["_veh", vehicle player, [objNull]]];

if (isNil "f_pylon_disabled") then { f_pylon_disabled = false }; // Use this to exclude certain players / roles
if (isNil "f_pylon_excludeMags") then { f_pylon_excludeMags = ["rhs_mag_DAGR_8","rhs_mag_AGM114L_2","rhs_mag_AGM114K_2","rhs_mag_AGM114M_2","rhs_mag_AGM114N_2","rhs_mag_M151_7","rhs_mag_M229_7","PylonRack_3Rnd_ACE_Hellfire_AGM114K","PylonRack_3Rnd_ACE_Hellfire_AGM114N","PylonRack_3Rnd_ACE_Hellfire_AGM114L","ace_hot_1_PylonRack_3Rnd","ace_hot_2_PylonRack_3Rnd","ace_hot_2MP_PylonRack_3Rnd","ace_hot_3_PylonRack_3Rnd"] }; // Exclude any pylons from CfgMagazines here (must be array!).
if (isNil "f_pylon_rearmMode") then { f_pylon_rearmMode = 1 }; // Rearm mode: 0 = Time Only, 1 = Vehicle Needed after FreeTime
if (isNil "f_pylon_freeTime") then { f_pylon_freeTime = 300 }; // Grace period for free changes (5 minutes).

private _vType = typeOf _veh;
private _vName = getText (configFile >> "CfgVehicles" >> _vType >> "displayName");

if (isNull _veh || f_pylon_disabled || count getPylonMagazines _veh < 1) exitWith {}; // Nothing to do!

missionNamespace setVariable [format['f_var_pylon_%1', _vType], getPylonMagazines _veh]; // Store vehicles starting loadout.

if !(f_pylon_excludeMags isEqualType []) then { f_pylon_excludeMags = [] }; // Exclude list must be array!

// If the vehicle was spawned in we need an ID for the client to reference the object on the server.
private _vID = if (vehicleVarName _veh != "") then { vehicleVarName _veh } else { _veh getVariable ["f_var_pylonID", ""] };

if (_vID == "") then {
	_vID = format["%1_%2", typeOf _veh, profileName];
	missionNamespace setVariable [_vID, _veh, true];
	_veh setVariable ["f_var_pylonID", _vID, true];
	diag_log format["[%1] No valid ID - Created: %3", _vName, typeOf _veh, _vID];
	systemChat format["[%1] No valid ID - Created: %3", _vName, typeOf _veh, _vID];
};

fnc_pylon_setPylons = {
	params [["_obj", objNull, [objNull]]];
	
	private _objName = getText (configFile >> "CfgVehicles" >> typeOf _obj >> "displayName");
	private _disabled = missionNamespace getVariable ["f_pylon_disabled", false];
	private _timeLimit = missionNamespace getVariable ["f_pylon_freeTime", 300];
	private _rearmMode = missionNamespace getVariable ["f_pylon_rearmMode", 0];
	private _loadout = missionNamespace getVariable [ format["f_var_pylon_%1", typeOf _obj], []];
	private _pylons = getPylonMagazines _obj;
	
	if (isNull _obj || _disabled || count _loadout == 0 || count _pylons == 0) exitWith { systemChat format["[%1] Invalid Vehicle", _objName] };
	if (time < 1) exitWith { systemChat format["[%1] Cannot change pylons during briefing!", _objName] };
	if (time > _timeLimit && _rearmMode < 1) exitWith { systemChat format["[%1] Cannot change pylons after time has passed!", _objName] };
	if (count (vehicles select { locked _x <= 1 && getAmmoCargo _x > 0 && _x distance _obj < 25 }) < 1 && _rearmMode == 1) exitWith { systemChat format["[%1] No Support Vehicle within 25m!", _objName] };
	if (player distance _obj < 15) exitWith { systemChat format["[%1] You must be within 15m of the Vehicle!", _objName] };
	
	{
		_obj removeWeaponGlobal getText (configFile >> "CfgMagazines" >> _x >> "pylonWeapon");
	} forEach ((_pylons arrayIntersect _pylons) - [""]);
	
	private _pylonConfigs = (configProperties [configFile >> "CfgVehicles" >> typeOf _obj >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"]) apply { getArray ( _x >> "turret" ) };
	
	{
		private _turret = if ((_pylonConfigs#_forEachIndex) isEqualTo [0]) then { [0] } else { [] };
		[_obj, [_forEachIndex + 1, if (_forEachIndex >= count _loadout) then { "" } else { _loadout#_forEachIndex }, true, _turret]] remoteExec ["setPylonLoadout"];
	} forEach _pylons;
		
	systemChat format["[%1] Pylons Applied", _objName];
	[_obj] call fnc_pylon_getPylons;
};

fnc_pylon_getPylons = {
	params [["_obj", objNull, [objNull]]];
	
	private _objName = getText (configFile >> "CfgVehicles" >> typeOf _obj >> "displayName");
	
	if (isNull _obj || count getPylonMagazines _obj == 0) exitWith { systemChat format["[%1] Invalid Vehicle", _objName] };
	
	private _railFull = []; 
	private _railNone = [];
	
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
	} forEach (getPylonMagazines _obj); 

	if (count _railNone > 0) then {
		systemChat format["[%1] Empty Bays: %2", _objName, _railNone joinString ", "];
	}; 
	
	if (count _railFull > 0) then {
		private _railText = _railFull apply { format["%1 (%2)", _x#0, _x#1] };
		systemChat format["[%1] Equipped Bays: %2", _objName, _railText joinString " "];
	}; 
};

private _pylonRecord = "<font size='18' color='#FF7F00'>Pylon Template</font><br/>";
_pylonRecord = _pylonRecord + format["The following allows a Virtual Template to be built and applied to a vehicle in-game. Set up the Template during briefing and then apply it to the vehicle when in the mission. You will have <font color='#00FFFF'>%1 Minutes</font> to apply a Template to the vehicle. After which a <font color='#00FFFF'>Support Vehicle</font> must be present to apply any changes.<br/><br/>", round (f_pylon_freeTime / 60)];
_pylonRecord = _pylonRecord + format["%1 <font color='#AAAAAA'>(%2 Pylons)</font>", getText (configFile >> "CfgVehicles" >> _vType >> "displayName"), count (getPylonMagazines _veh)];
_pylonRecord = _pylonRecord + format[" | <execute expression=""[%1] call fnc_pylon_getPylons;"">Vehicle Loadout</execute>", _vID];
_pylonRecord = _pylonRecord + format[" | <execute expression=""[%1] call fnc_pylon_setPylons;"">Apply Template</execute><br/>", _vID];
_pylonRecord = _pylonRecord + format["<img image='%1' height='64'/>", getText (configFile >> "CfgVehicles" >> _vType >> "icon") call BIS_fnc_textureVehicleIcon];

// List load-out pre-sets
_pylonRecord = _pylonRecord + "<br/><br/><font size='14' color='#FF7F00'>Preset Template</font><br/>Selecting any template here will overwrite any customised template.<br/><br/>";
_pylonRecord = _pylonRecord + format["<execute expression=""f_var_pylon_%1 = ['']; systemChat '[%2] Template Selected: Empty';"">Empty</execute><br/><font size='12'>No Weapons</font>", _vType, _vName];

{
	if !(toUpper (configName _x) in ['EMPTY','NONE']) then {
		
		_pylonRecord = _pylonRecord + format["<br/><br/><execute expression=""f_var_pylon_%1 = getArray (configFile >> 'CfgVehicles' >> '%1' >> 'Components' >> 'TransportPylonsComponent' >> 'Presets' >> '%2' >> 'attachment'); systemChat '[%4] Template Loaded: %3';"">%3</execute><br/>", _vType, configName _x, getText (_x >> "displayName"), _vName];
		private _pylons = ((getArray (_x >> "attachment") - [""]) call BIS_fnc_consolidatearray) apply { format["<font size='12'>%1 <font color='#CCCCCC'>x%2</font></font>", getText (configFile >> 'CfgMagazines' >> (_x#0) >> 'displayName'), _x#1] };
		_pylonRecord = _pylonRecord + "" + (_pylons joinString ', ') + "";
	};
} forEach ("true" configClasses (configFile >> "CfgVehicles" >> _vType >> "Components" >> "TransportPylonsComponent" >> "Presets"));

_pylonRecord = _pylonRecord + "<br/><br/><font size='14' color='#FF7F00'>Customise Template</font><br/>";
_pylonRecord = _pylonRecord + "<font size='12' color='#80FF00'>Magazine Type</font> | <font size='12'>Pylon ID</font><br/><font size='10'>Magazine Description<br/></font><br/>";

private _pylonMags = _veh getCompatiblePylonMagazines 0;
private _magazines = [];
{{ _magazines pushBackUnique _x } forEach _x } forEach _pylonMags; // Build list of unique mags.

// For each mag, add 
{
	_x params ["_mag"];
	
	private _name = getText (configFile >> "CfgMagazines" >> _mag >> "displayName");
	_pylonRecord = _pylonRecord + format["<font size='12' color='#80FF00'>%1 </font>", _name];

	{
		private _pylonNo = _forEachIndex + 1;
		if (_mag in _x) then { _pylonRecord = _pylonRecord + format[" | <font size='12'> <execute expression=""systemChat '[%5] Template Pylon%1: %2'; f_var_pylon_%6 set [%3,'%4']"">%1</execute></font>", if (_pylonNo > 9) then { _pylonNo } else { '0' + str _pylonNo }, _name, _forEachIndex, _mag, _vName, _vType] };
	} forEach _pylonMags;
	
	_pylonRecord = _pylonRecord + "<br/>";
	
	if (count getText (configFile >> "CfgMagazines" >> _mag >> "descriptionShort") > 0) then {
		_pylonRecord = _pylonRecord + format["<font size='10'>%1</font><br/>", getText (configFile >> "CfgMagazines" >> _mag >> "descriptionShort")];
	};
	//_pylonRecord = _pylonRecord + format["<font size='10' color='#666666'>(%1)</font><br/>", _mag]; // DEBUG - Show Magazine class name
} forEach (_magazines - f_pylon_excludeMags);

player createDiaryRecord ["diary", [format["Pylons (%1)", _vName], _pylonRecord]];
missionNamespace setVariable [format["diary_%1", _vType], true]; // Don't allow multiple copies