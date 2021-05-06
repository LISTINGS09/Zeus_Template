// F3 - Mission Maker Teleport
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================
// this addAction ["<t color='#B70000'>HALO</t>", { [[1,0,false,[],2000,true], "f\mapClickTeleport\f_mapClickTeleportAction.sqf"] remoteExec ["execVM", (_this select 1)]; },"",0,true,true,"","true",6];

// Only run this for players
if (!hasInterface) exitWith {};

f_fnc_mapClickTeleportGroup = compileFinal preprocessFileLineNumbers "f\mapClickTeleport\fn_mapClickTeleportGroup.sqf";
f_fnc_mapClickTeleportUnit = compileFinal preprocessFileLineNumbers "f\mapClickTeleport\fn_mapClickTeleportUnit.sqf";
f_fnc_mapClickHaloEffect = compileFinal preprocessFileLineNumbers "f\mapClickTeleport\fn_mapClickHaloEffect.sqf";

// MAKE SURE THE PLAYER INITIALIZES PROPERLY
if (!isDedicated && (isNull player)) then {
    waitUntil {sleep 0.1; !isNull player};
};

params [["_uses",1,[1]],["_timeLimit",0,[0]],["_groupTP",true,[true]],["_unitList",[],[[]]],["_dropHeight",0,[0]],["_skipAction",false,[false]]];

// How often the TP action can be used. 0 = infinite usage.
if (isNil "f_var_mapClickTeleport_Uses") then {f_var_mapClickTeleport_Uses = _uses};

// False: everyone can TP. True: Only group leaders can TP and will move their entire group.
if (isNil "f_var_mapClickTeleport_GroupTeleport") then {f_var_mapClickTeleport_GroupTeleport = _groupTP};

// If > 0 map click TP will act as a HALO drop and automatically assign parachutes to units
if (isNil "f_var_mapClickTeleport_Height") then {f_var_mapClickTeleport_Height = _dropHeight};

// Allow all group leaders or those of senior rank access to Teleport.
if (f_var_mapClickTeleport_GroupTeleport && player != leader group player && rank player in ["PRIVATE","CORPORAL"]) exitWith {};
		
// Make sure that no non-existing units have been parsed
{
	if (isNil _x) then {
		_unitList set [_forEachIndex,objNull];
	} else {
		_unitList set [_forEachIndex,call compile format ["%1",_x]];
	};
} forEach _unitList;

// Reduce the array to valid units only
_unitList = _unitList - [objNull];

// CHECK IF COMPONENT SHOULD BE ENABLED
// We end the script if it is not running on a server or if only group leaders can use
// the action and the player is not the leader of his/her group
if (count _unitList > 0 && !(player in _unitList)) exitWith {};

// Skip action setup and just execute
if (_skipAction) exitWith { [] spawn f_fnc_mapClickTeleportUnit };

_string = if (f_var_mapClickTeleport_Height == 0) then {"Fast Travel"} else {"HALO Drop"};

// Add briefing for SLs
//player removeDiaryRecord ["Diary", _string];
private _tel = player createDiaryRecord ["Diary", [_string, format["
	<br/><font size='18' color='#80FF00'>%2</font>
	<br/>You may use the <font color='#00FFFF'>%1</font color> option to initiate the %2%3%4%5%6",
	if (isClass(configFile >> "CfgPatches" >> "ace_main")) then { "ACE Team Management" } else { "Action Menu" },
	_string,
	if (f_var_mapClickTeleport_Uses > 1) then { format[", this option may be used <font color='#FF0080'>%1</font color> times.", f_var_mapClickTeleport_Uses] } else { ", once used this action will be removed." },
	if (_timeLimit > 0) then { format["<br/><br/>This option will EXPIRE after <font color='#FF0080'>%1</font color> seconds.", _timeLimit] } else { "" },
	if (f_var_mapClickTeleport_GroupTeleport) then { "<br/><br/>Using this command will also move your entire team, so ensure they are ready!" } else { "<br/><br/>Using this command will move only your unit, it will not affect other players." },
	if (f_var_mapClickTeleport_Height > 0) then { format["<br/><br/>You will be dropping from a height of around <font color='#FF0080'>%1m</font color>.", f_var_mapClickTeleport_Height] } else { "<br/><br/>If you are inside a vehicle, that vehicle will also be transported." }
]]];

if (f_var_mapClickTeleport_GroupTeleport) then {
	_string = _string + " (Whole Squad)";
};

f_var_mapClickTeleport_textAction = format["<t color='#80FF00'>%1</t>",_string];

// ADD TELEPORT ACTION TO PLAYER ACTION MENU
// Whilst the player is alive we add the teleport action to the player's action menu.
// If the player dies we wait until he is alive again and re-add the action.

if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {
		[_string] spawn { sleep 4; player groupChat format["Use ACE Team Management to begin %1.",_this select 0]; };
		ace_par_action = ['PAR',format["%1",_string],['\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\run_ca.paa','\A3\ui_f_orange\data\cfgTaskTypes\airdrop_ca.paa'] select (f_var_mapClickTeleport_Height > 0),{[] spawn f_fnc_mapClickTeleportUnit},{true}] call ace_interact_menu_fnc_createAction;
		[player, 1, ["ACE_SelfActions","ACE_TeamManagement"], ace_par_action] call ace_interact_menu_fnc_addActionToObject;
		if (_timeLimit > 0) then {
			sleep _timeLimit;
			[player, 1, ["ACE_SelfActions","ACE_TeamManagement","PAR"]] call ace_interact_menu_fnc_removeActionFromObject;
		};
} else {
	[_string] spawn { sleep 4; player groupChat format["Use Action Menu to begin %1.",_this select 0]; };
	f_mapClickTeleportAction = player addAction [f_var_mapClickTeleport_textAction,{[] spawn f_fnc_mapClickTeleportUnit},"", 0, false,true,"","_this == player"];	
	if (_timeLimit > 0) then {
		sleep _timeLimit;
		player removeAction f_mapClickTeleportAction;
	};
};