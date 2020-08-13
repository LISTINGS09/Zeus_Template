// Creates a custom briefing section to switch pylons mission start.
// Must have vehicle named in EDITOR 
// [] execVM "f\misc\f_pylons.sqf";
params [["_vType", typeOf vehicle player]];

if (isNil "f_pylon_disabled") then { f_pylon_disabled = false }; // Use this to exclude certain players / roles
if (isNil "f_pylon_excludeMags") then { f_pylon_excludeMags = ["rhs_mag_DAGR_8","rhs_mag_AGM114L_2","rhs_mag_AGM114K_2","rhs_mag_AGM114M_2","rhs_mag_AGM114N_2","rhs_mag_M151_7","rhs_mag_M229_7","PylonRack_3Rnd_ACE_Hellfire_AGM114K","PylonRack_3Rnd_ACE_Hellfire_AGM114N","PylonRack_3Rnd_ACE_Hellfire_AGM114L","ace_hot_1_PylonRack_3Rnd","ace_hot_2_PylonRack_3Rnd","ace_hot_2MP_PylonRack_3Rnd","ace_hot_3_PylonRack_3Rnd"] }; // Exclude any pylons from CfgMagazines here (must be array!).
if (isNil "f_pylon_rearmMode") then { f_pylon_rearmMode = 1 }; // Rearm mode: 0 = Time Only, 1 = Vehicle Needed after FreeTime
if (isNil "f_pylon_freeTime") then { f_pylon_freeTime = 300 }; // Grace period for free changes (5 minutes).

if (_vType isEqualType objNull) then { _vType = typeOf _vType };

if (f_pylon_disabled || count (_vType getCompatiblePylonMagazines 1) < 1) exitWith {}; // Nothing to do!

private _vName = [getText (configFile >> "CfgVehicles" >> _vType >> "displayName"),"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_- .,/[]()"] call BIS_fnc_filterString;

missionNamespace setVariable [format['f_var_pylon_%1', _vType], []]; // Store vehicles starting loadout.
missionNamespace setVariable [format['f_var_pylon_%1_owner', _vType], []];

if !(f_pylon_excludeMags isEqualType []) then { f_pylon_excludeMags = [] }; // Exclude list must be array!

fnc_pylon_setPylons = {
	params [["_type", "", [""]]];
	
	_nearObjs = nearestObjects [player, [_type], 50];
	private _v = if (count _nearObjs > 0) then { _nearObjs#0 } else { objNull };
		
	private _vName = [getText (configFile >> "CfgVehicles" >> _type >> "displayName"),"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_- .,/[]()"] call BIS_fnc_filterString;
	private _disabled = missionNamespace getVariable ["f_pylon_disabled", false];
	private _timeLimit = missionNamespace getVariable ["f_pylon_freeTime", 300];
	private _rearmMode = missionNamespace getVariable ["f_pylon_rearmMode", 0];
	private _loadout = missionNamespace getVariable [ format["f_var_pylon_%1", _type], []];
	private _owner = missionNamespace getVariable [ format["f_var_pylon_%1_owner", _type], []];
	private _cfgTurret = (configProperties [configFile >> "CfgVehicles" >> _type >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"]) apply { getArray ( _x >> "turret" ) };
	
	if (isNull _v) exitWith { systemChat format["[%1] No valid vehicle found within 50m!", _vName] };
	if (count fullCrew [_v,"",false] > 0) exitWith { systemChat format["[%1] Vehicle must be empty!", _vName] };
		
	private _pylons = getPylonMagazines _v;
	
	if (_disabled || count _pylons == 0) exitWith {};
	if (count _loadout == 0) exitWith { systemChat format["[%1] No pylons defined!", _vName] };
	if (time < 1) exitWith { systemChat format["[%1] Cannot change pylons during briefing!", _vName] };
	if (time > _timeLimit && _timeLimit > 0 && _rearmMode < 1) exitWith { systemChat format["[%1] Cannot change pylons after time has passed!", _vName] };
	if (time > _timeLimit && _timeLimit > 0 && count (vehicles select { (getAmmoCargo _x > 0 || (getNumber (configFile >> "CfgVehicles" >> typeOf _x >> "ace_rearm_defaultSupply") > 0)) && locked _x <= 1 && { _x distance _v < 50 } }) < 1 && _rearmMode == 1) exitWith { systemChat format["[%1] No Support Vehicle within 50m!", _vName] };
	
	{
		_v removeWeaponGlobal getText (configFile >> "CfgMagazines" >> _x >> "pylonWeapon");
	} forEach ((_pylons arrayIntersect _pylons) - [""]);
	
	{
		// Use override value otherwise use the vehicle setting
		private _turret = if ((_cfgTurret#_forEachIndex) isEqualTo [0]) then { [0] } else { [] };
		if (_forEachIndex < count _owner) then { if ((_owner#_forEachIndex) isEqualType []) then { _turret = _owner#_forEachIndex } };
		
		//diag_log text format["%1:%2 - W:%3 T:%4", _type, _forEachIndex + 1, if (_forEachIndex >= count _loadout) then { "" } else { _loadout#_forEachIndex }, _turret];
		[_v, [_forEachIndex + 1, if (_forEachIndex >= count _loadout) then { "" } else { _loadout#_forEachIndex }, true, _turret]] remoteExec ["setPylonLoadout"];
	} forEach _pylons;
		
	systemChat format["[%1] Pylons Applied", _vName];
	[_type] call fnc_pylon_getPylons;
};

fnc_pylon_getPylons = {
	params [["_type", "", [""]]];
	
	_nearObjs = nearestObjects [player, [_type], 100];
	private _v = if (count _nearObjs > 0) then { _nearObjs#0 } else { objNull };
	private _vName = [getText (configFile >> "CfgVehicles" >> _type >> "displayName"),"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_- .,/[]()"] call BIS_fnc_filterString;
	
	if (isNull _v || count getPylonMagazines _v == 0) exitWith { systemChat format["[%1] No valid vehicle within 100m!", _vName] };
	
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
	} forEach (getPylonMagazines _v); 

	if (count _railNone > 0) then {
		systemChat format["[%1] Empty Bays: %2", _vName, _railNone joinString ", "];
	}; 
	
	if (count _railFull > 0) then {
		private _railText = _railFull apply { format["%1 (%2)", _x#0, _x#1] };
		systemChat format["[%1] Equipped Bays: %2", _vName, _railText joinString " "];
	}; 
};

private _pylonRecord = "<font size='18' color='#FF7F00'>Pylon Template</font><br/>";
_pylonRecord = _pylonRecord + format["The following allows a Virtual Template to be built and applied to a vehicle in-game. Set up the Template during briefing and then apply it to the vehicle when in the mission. You will have <font color='#00FFFF'>%1 Minutes</font> to apply a Template to the vehicle. After which a <font color='#00FFFF'>Support Vehicle</font> must be present to apply any changes.<br/><br/>", round (f_pylon_freeTime / 60)];
_pylonRecord = _pylonRecord + format["%1 <font color='#AAAAAA'>(%2 Pylons)</font>", _vName, count ("true" configClasses (configFile >> "CfgVehicles" >> _vType >> "Components" >> "TransportPylonsComponent" >> "pylons"))];
_pylonRecord = _pylonRecord + format[" | <execute expression=""['%1'] call fnc_pylon_getPylons;"">Vehicle Loadout</execute>", _vType];
_pylonRecord = _pylonRecord + format[" | <execute expression=""['%1'] call fnc_pylon_setPylons;"">Apply Template</execute><br/>", _vType];
_pylonRecord = _pylonRecord + format["<img image='%1' height='64'/>", getText (configFile >> "CfgVehicles" >> _vType >> "icon") call BIS_fnc_textureVehicleIcon];

// List Pylon Owners
_pylonOwners = "<br/><br/><font size='14' color='#FF7F00'>Pylon Control</font><br/>You may override the default control of any Pylon to either the Pilot or Gunner. The default owner of the pylon is indicated by *.<br/><br/>";

private _pylonConfigs = configProperties [configFile >> "CfgVehicles" >> _vType >> "Components" >> "TransportPylonsComponent" >> "Pylons", "isClass _x"];
private _hasTurret = false;

{
	private _isTurret = false;
	if (getArray ( _x >> "turret" ) isEqualTo [0]) then { _hasTurret = true; _isTurret = true };
	private _pylonNo = _forEachIndex + 1;
	private _pylonStr = if (_pylonNo > 9) then { _pylonNo } else { '0' + str _pylonNo };
	_pylonOwners = _pylonOwners + format["ID %1", _pylonStr];
	_pylonOwners = _pylonOwners + format[" | <execute expression=""systemChat '%3 (%5) owner: Pilot'; f_var_pylon_%1_owner set [%4,[]];"">Pilot%2</execute>", _vType, ["*",""] select _isTurret, configName _x, _forEachIndex, _pylonStr];
	_pylonOwners = _pylonOwners + format[" | <execute expression=""systemChat '%3 (%5) owner: Gunner'; f_var_pylon_%1_owner set [%4,[0]];"">Gunner%2</execute>", _vType, ["","*"] select _isTurret, configName _x, _forEachIndex, _pylonStr];
	_pylonOwners = _pylonOwners + format[" | <execute expression=""systemChat '%3 (%5) owner: Default'; f_var_pylon_%1_owner set [%4,0];"">Clear</execute> - <font color='#80FF00'>%3</font><br/>", _vType, "", configName _x, _forEachIndex, _pylonStr];
} forEach _pylonConfigs;

// Add to briefing if a turret is present
if (_hasTurret) then { _pylonRecord = _pylonRecord + _pylonOwners };

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

private _pylonMags = _vType getCompatiblePylonMagazines 0;
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