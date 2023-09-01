// Zeus - Checks a units magazines and converts them from the old weapon to a given one.
// USAGE: [player,"arifle_Katiba_F","SMG_02_F"] call f_fnc_magazineCheck;
// ====================================================================================
params["_unit",["_weaponOld",""],["_weaponNew",""]];

if (isNil "_unit") exitWith {};
if (!(isClass (configFile >> "CfgWeapons" >> _weaponNew)) || !(isClass (configFile >> "CfgWeapons" >> _weaponOld))) exitWith {
	["fn_magazineCheck.sqf",format["Invalid Weapon (%1 to %2)",_weaponOld, _weaponNew], "ERROR"] call f_fnc_logIssue;
};

private _isMissile = _weaponNew isKindOf ["Launcher", configFile >> "CfgWeapons"];
private _magsOld = (getArray(configFile >> "CfgWeapons" >> _weaponOld >> "magazines")) apply { toLower _x };
private _magSize = getNumber (configfile >> "CfgMagazines" >> (currentMagazine _unit) >> "count"); // Get Bullet Count

// Only one mag? Find other compatible magazines.
if (count _magsOld <= 1) then { 
	private _oldGLMags = [];
	private _oldMuzzle = getArray (configFile >> "CfgWeapons" >> _weaponOld >> "muzzles");
	if (count _oldMuzzle > 1) then { _oldGLMags = (getArray (configFile >> "CfgWeapons" >> _weaponOld >> _oldMuzzle#1 >> "magazines")) apply { toLower _x } };
	_magsOld = (([_weaponOld] call BIS_fnc_compatibleMagazines) - _oldGLMags) select { _magSize isEqualTo getNumber (configfile >> "CfgMagazines" >> _x >> "count") };
};

// Fix BIS Config Issues - MX is missing the default tracer mag
private _magsNew = switch (_weaponNew) do {
	case "arifle_MX_F";
	case "arifle_MX_GL_F";
	case "arifle_MXC_F";
	case "arifle_MXM_F": { ["30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag_tracer"] };
	case "arifle_MX_SW_F": { ["100rnd_65x39_caseless_mag","100rnd_65x39_caseless_mag_tracer"] };
	case "arifle_MX_Black_F";
	case "arifle_MX_GL_Black_F";
	case "arifle_MXC_Black_F";
	case "arifle_MXM_Black_F": { ["30rnd_65x39_caseless_black_mag","30Rnd_65x39_caseless_black_mag_tracer"] };
	case "arifle_MX_SW_Black_F": { ["100rnd_65x39_caseless_black_mag","100rnd_65x39_caseless_black_mag_tracer"] };
	case "arifle_MX_khk_F";
	case "arifle_MX_GL_khk_F";
	case "arifle_MXC_khk_F";
	case "arifle_MXM_khk_F": { ["30rnd_65x39_caseless_khaki_mag","30rnd_65x39_caseless_khaki_mag_tracer"] };
	case "arifle_MX_SW_khk_F": { ["100rnd_65x39_caseless_khaki_mag","100rnd_65x39_caseless_khaki_mag_tracer"] };
	case "arifle_AK12_F";
	case "arifle_AK12_GL_F";
	case "arifle_AKM_F": { ["30Rnd_762x39_AK12_Mag_F","30Rnd_762x39_AK12_Mag_Tracer_F"] };
	default { getArray (configFile >> "CfgWeapons" >> _weaponNew >> "magazines") };
};

//diag_log format["[F3] MAGCHECK: _magsOld: %1",_magsOld];
//diag_log format["[F3] MAGCHECK: _magsNew: %1",_magsNew];

private _magsCurrent = (magazines _unit) apply { toLower _x }; 
private _numDefault = 0;
{
	if (_x in _magsOld && !(_x in _magsNew)) then {
		_unit removeMagazine _x;
		_numDefault = _numDefault + 1;
	};
} forEach _magsCurrent;

// No suitable magazines found to add!
if (_numDefault isEqualTo 0 || count _magsNew == 0) exitWith {}; 

private _magsNewDefault = _magsNew#0; // Default new magazine.
private _numTracer = 0;
private _magsStandard = _numDefault;

// Check weapon type to see if we need tracer rounds.
if (getNumber (configFile >> "CfgWeapons" >> _weaponNew >> "type") == 1) then {
	_numTracer = ceil (_numDefault * 0.5);
	_magsStandard = _numDefault - _numTracer;
};

private _fnc_addMagazine = {
	params ["_unit", "_class", "_count", "_isLauncher"];
	
	private _bc = backpackContainer _unit;
	private _vc = vestContainer _unit;
	private _uc = uniformContainer _unit;
	
	//systemChat format ["Adding %1 of %2", _count, _class];
	//diag_log format["[F3] MAGCHECK - Adding %1 of %2", _count, _class];
	
	if (_isLauncher) exitWith { _bc addItemCargoGlobal [_class, _count] };

	private _containers = [_vc, _bc, _uc] - [objNull];	
	(_containers#0) addItemCargoGlobal [_class, _count];
};

//diag_log format["[F3] MAGCHECK: There are %1 magazines to add, %2 std %3 special.",_numDefault,_magsStandard,_numTracer];
[_unit, _magsNewDefault, _magsStandard, _isMissile] call _fnc_addMagazine;

if (_numTracer isEqualTo 0) exitWith {};
// Try and find 'special' mags that fit the factions tracer.
// Get array of tracer rounds, then try and find the factions own tracer if possible.

// TRY1: Get a list of ALL the tracer rounds from the magazine class.
private _magsNewTracer = _magsNew select { getNumber(configFile >> "cfgMagazines" >> _x >> "tracersEvery") isEqualTo 1 };
//diag_log format["[F3] MAGCHECK: Result of tracer search: %1",_magsNewTracer];

if (count _magsNewTracer isEqualTo 0) exitWith { [_unit, _magsNewDefault, _numTracer, _isMissile] call _fnc_addMagazine };
	
private _tracerColor = switch (side _unit) do {case west: {"red"}; case east: {"green"}; default {"yellow"};};

// TRY2: Filter the list further to just find the factions tracer.
private _magTracerFaction = _magsNewTracer select { 	
	toLower (_x + getText(configFile >> "cfgMagazines" >> _x >> "ammo") +
		getText(configFile >> "cfgMagazines" >> _x >> "displayNameShort") + 
		getText(configFile >> "cfgMagazines" >> _x >> "displayName") + 
		getText(configFile >> "cfgMagazines" >> _x >> "descriptionShort")) 
	find _tracerColor > 0 };

//diag_log format["[F3] MAGCHECK: Result of faction search: %1",_magTracerFaction];

if (count _magTracerFaction > 0) then {
	[_unit, _magTracerFaction select 0, _numTracer, _isMissile] call _fnc_addMagazine;
} else {
	[_unit, _magsNewTracer select 0, _numTracer, _isMissile] call _fnc_addMagazine;
};