// F3 Zeus Support  - Initialization
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/

if !isServer exitWith {};

["fn_zeusInit.sqf","Started","DEBUG"] call f_fnc_logIssue;

if (isNil "f_fnc_zeusAssign") then { f_fnc_zeusAssign = compileFinal preprocessFileLineNumbers "f\zeus\fn_zeusAssign.sqf"; };
if (isNil "f_fnc_zeusAddObjects") then { f_fnc_zeusAddObjects = compileFinal preprocessFileLineNumbers "f\zeus\fn_zeusAddObjects.sqf"; };
if (isNil "f_fnc_zeusAddAddons") then { f_fnc_zeusAddAddons = compileFinal preprocessFileLineNumbers "f\zeus\fn_zeusAddAddons.sqf"; };
if (isNil "f_fnc_zeusRemovePlayers") then { f_fnc_zeusRemovePlayers = compileFinal preprocessFileLineNumbers "f\zeus\fn_zeusRemovePlayers.sqf"; };
if (isNil "f_fnc_zeusTerm") then { f_fnc_zeusTerm = compileFinal preprocessFileLineNumbers "f\zeus\fn_zeusTerm.sqf"; };

f_fnc_zeusCreate = {
	params ["_curatorID", ["_target", "objNull"]];
	waitUntil { (missionNamespace getVariable ["f_var_missionLoaded", false]) };
	
	if (!isNull (missionNamespace getVariable [_curatorID, objNull])) exitWith {};
	
	_curator = (createGroup sideLogic) createUnit ["ModuleCurator_F",[0,0,0],[],0,""];
	_curator setVehicleVarName _curatorID;
	missionNamespace setVariable [_curatorID, _curator];

	_curator setVariable ["ShowNotification", FALSE, TRUE];
	_curator setVariable ["Addons", 3, TRUE]; // 1 - Mission, 2 - Official, 3 - Unofficial
	_curator setVariable ["Owner", _target];  
	_curator setVariable ["BIS_fnc_initModules_activate", TRUE];
	
	[_curator, [-1, -2, 0]] call bis_fnc_setCuratorVisionModes;
	
	_curator setCuratorWaypointCost 0;
	{ _curator setCuratorCoef [_curatorID, 0] } forEach ["place", "edit", "delete", "destroy", "group", "synchronize"];

	["fn_zeusInit.sqf",format["Curator Assigned (%1 - %2)", _curatorID, _target], "INFO"] call f_fnc_logIssue;
	
	_curator
};

// Create free in-game curator, assign to admin by default.
["f_ZeusCurator", "#AdminLogged"] spawn f_fnc_zeusCreate;

// Set up author for Zeus
if !(isNil "f_var_AuthorUID") then {
	["f_ZeusCuratorAuthor",f_var_AuthorUID] spawn f_fnc_zeusCreate;	
} else {
	["f_ZeusCuratorAuthor","76561197970695190"] spawn f_fnc_zeusCreate;	
};