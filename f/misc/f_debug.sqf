// Iterates task modules and highlights any potential problems.
// Basically, stuff I usually forget when copying mission info!
private ["_arr","_module","_moduleID","_unitsWest","_unitsEast","_unitsResi","_unitsCiv"];
params[["_limitDebug",true]];
		
// Count units on various sides.
_unitsWest = {side _x == west && alive _x && !isPlayer _x} count allUnits;
_unitsEast = {side _x == east && alive _x && !isPlayer _x} count allUnits;
_unitsResi = {side _x == resistance && alive _x && !isPlayer _x} count allUnits;
_unitsCiv = {side _x == civilian && alive _x && !isPlayer _x} count allUnits;

diag_log text format ["Players: %1, AI: BLU/%2, OPF/%3, RES/%4, CIV/%5",count (playableUnits + switchableUnits),_unitsWest,_unitsEast,_unitsResi,_unitsCiv];

// Don't run in full unless it's been called from the Administrator Menu.
if (isMultiplayer && _limitDebug) exitWith {};

// Check Game Type
if (getText ((getMissionConfig "Header") >> "gameType") == "") then { ["f_debug.sqf","Game Type has not been defined!"] call f_fnc_logIssue }; 

// Check for BIS Revive
if (getMissionConfigValue ["ReviveMode",0] > 0) then { ["f_debug.sqf","BIS Revive is Active, cannot use FAROOQ Medical."] call f_fnc_logIssue }; 

// Check for mines
if (count allMines > 5 && { _x getUnitTrait 'explosiveSpecialist' } count (playableUnits + switchableUnits) <= 0) then { ["f_debug.sqf","Mines present but no Explosives Experts detected!"] call f_fnc_logIssue }; 

// Missing Group Markers
if ({ !(groupID group _x in ((missionNamespace getVariable ["f_var_allGroups",[["","",""]]]) apply { _x#2 }))} count (playableUnits + switchableUnits) > 0) then {
	["groups.sqf",format["%1 units have no group ID assigned: %2",
		{ !(groupID group _x in ((missionNamespace getVariable ["f_var_allGroups",[["","",""]]]) apply { _x#2 }))} count (playableUnits + switchableUnits),
		(playableUnits + switchableUnits) select { !(groupID group _x in ((missionNamespace getVariable ["f_var_allGroups",["","",""]]) apply { _x#2 }))}
		]
	] call f_fnc_logIssue
}; 

// Warn if the file wasn't cleared.
if (count (missionNamespace getVariable ["f_var_allGroups",[]]) > 25) then { ["mission\groups.sqf",format["%1 groups are listed! Remove unused groups from 'groups.sqf'", count f_var_allGroups]] call f_fnc_logIssue };

_arr = [];

{	// Module Check
	//diag_log text format["[F3] INFO (fn_moduleCheck.sqf): Checking Module %1 - %2",_x,typeOf _x];
	if (["module", format ["%1",typeOf _x]] call BIS_fnc_inString) then {
		_module = _x;
		_moduleID = "";
		
		if ("id" in allVariables _module) then {
			_moduleID = _module getVariable "id";
			
			if (_moduleID == "") then {
				_mkr = createMarkerLocal[format["ztk_%1_noid",_module],getPos _module];
				_mkr setMarkerShapeLocal "ICON";
				_mkr setMarkerColorLocal "ColorYellow";
				_mkr setMarkerSizeLocal [0.8,0.8];
				_mkr setMarkerTypeLocal "mil_dot";
				["f_debug.sqf",format["<marker name='%3'>%1</marker> in %2 has a no ID, assign one.<br/>",_moduleID,typeOf _module,_mkr]] call f_fnc_logIssue;
			};
			
			if (_moduleID in _arr) then {
				_mkr = createMarkerLocal[format["ztk_%1_duplicate",_module],getPos _module];
				_mkr setMarkerShapeLocal "ICON";
				_mkr setMarkerColorLocal "ColorRed";
				_mkr setMarkerSizeLocal [0.8,0.8];
				_mkr setMarkerTypeLocal "mil_dot";
				["f_debug.sqf",format["<marker name='%3'>%1</marker> in %2 has a duplicate ID! IDs cannot be the same.<br/>",_moduleID,typeOf _module,_mkr]] call f_fnc_logIssue;
			} else { _arr pushBack _moduleID; }; // Add to checking array.
		};
		
		if ("owner" in allVariables _module) then {
				switch (_module getVariable "owner") do {
					case 1: {
						if (count synchronizedObjects _module == 0) then {
							_mkr = createMarkerLocal[format["ztk_%1_owner",_module],getPos _module];
							_mkr setMarkerShapeLocal "ICON";
							_mkr setMarkerColorLocal "ColorOrange";
							_mkr setMarkerSizeLocal [0.8,0.8];
							_mkr setMarkerTypeLocal "mil_dot";
							["f_debug.sqf",format["<marker name='%2'>Task %1</marker> has owner assigned as group but no synchronized units.",_moduleID,_mkr]] call f_fnc_logIssue;
						};
					};
					case 4: {
						if ({side _x == west} count (playableUnits + switchableUnits) == 0) then {
							_mkr = createMarkerLocal[format["ztk_%1_owner",_module],getPos _module];
							_mkr setMarkerShapeLocal "ICON";
							_mkr setMarkerColorLocal "ColorOrange";
							_mkr setMarkerSizeLocal [0.8,0.8];
							_mkr setMarkerTypeLocal "mil_dot";
							["f_debug.sqf",format["<marker name='%2'>Task %1</marker> has owner assigned as BLUFOR but no playable units.",_moduleID,_mkr]] call f_fnc_logIssue;
						};
					};
					case 5: {
						if ({side _x == east} count (playableUnits + switchableUnits) == 0) then {
							_mkr = createMarkerLocal[format["ztk_%1_owner",_module],getPos _module];
							_mkr setMarkerShapeLocal "ICON";
							_mkr setMarkerColorLocal "ColorOrange";
							_mkr setMarkerSizeLocal [0.8,0.8];
							_mkr setMarkerTypeLocal "mil_dot";
							["f_debug.sqf",format["<marker name='%2'>Task %1</marker> has owner assigned as OPFOR but no playable units.",_moduleID,_mkr]] call f_fnc_logIssue;
						};
					};
					case 6: {
						if ({side _x == resistance} count (playableUnits + switchableUnits) == 0) then {
							_mkr = createMarkerLocal[format["ztk_%1_owner",_module],getPos _module];
							_mkr setMarkerShapeLocal "ICON";
							_mkr setMarkerColorLocal "ColorOrange";
							_mkr setMarkerSizeLocal [0.8,0.8];
							_mkr setMarkerTypeLocal "mil_dot";
							["f_debug.sqf",format["<marker name='%2'>Task %1</marker> has owner assigned as INDFOR but no playable units.",_moduleID,_mkr]] call f_fnc_logIssue;
						};
					};
				};
		};
	};
} forEach allMissionObjects "Module_F";

{	// Trigger Check
	//diag_log text format["[F3] INFO (fn_moduleCheck.sqf): Checking Trigger %1 - %2",_x,typeOf _x];
	if (triggerStatements _x find "this" >= 0) then {
		private ["_mkr"];
		switch (toUpper((triggerActivation _x) select 0)) do {
			case "WEST": {
				if ({side _x == west} count allUnits == 0) then {
					_mkr = createMarkerLocal[format["ztr_%1_owner",_x],getPos _x];
					_mkr setMarkerShapeLocal "ICON";
					_mkr setMarkerColorLocal "ColorBlue";
					_mkr setMarkerSizeLocal [0.8,0.8];
					_mkr setMarkerTypeLocal "mil_dot";
					["f_debug.sqf",format["<marker name='%1'>Trigger (%2)</marker> has activation type as BLUFOR but no units present.",_mkr,vehicleVarName _x]] call f_fnc_logIssue;
				};
			};
			case "EAST": {
				if ({side _x == east} count allUnits == 0) then {
					_mkr = createMarkerLocal[format["ztr_%1_owner",_x],getPos _x];
					_mkr setMarkerShapeLocal "ICON";
					_mkr setMarkerColorLocal "ColorBlue";
					_mkr setMarkerSizeLocal [0.8,0.8];
					_mkr setMarkerTypeLocal "mil_dot";
					["f_debug.sqf",format["<marker name='%1'>Trigger (%2)</marker> has activation type as OPFOR but no units present.",_mkr,vehicleVarName _x]] call f_fnc_logIssue;
				};
			};
			case "GUER": {
				if ({side _x == resistance} count allUnits == 0) then {
					_mkr = createMarkerLocal[format["ztr_%1_owner",_x],getPos _x];
					_mkr setMarkerShapeLocal "ICON";
					_mkr setMarkerColorLocal "ColorBlue";
					_mkr setMarkerSizeLocal [0.8,0.8];
					_mkr setMarkerTypeLocal "mil_dot";
					["f_debug.sqf",format["<marker name='%1'>Trigger (%2)</marker> has activation type as INDFOR but no units present.",_mkr,vehicleVarName _x]] call f_fnc_logIssue;
				};
			};
		};
	};
} forEach allMissionObjects "EmptyDetector";

waitUntil { time > 0 };

player globalChat format ["Players: %1, AI: BLU/%2, OPF/%3, RES/%4, CIV/%5",count (playableUnits + switchableUnits),_unitsWest,_unitsEast,_unitsResi,_unitsCiv];

// Display Issues List
if (count (missionNamespace getVariable ["f_var_missionLog",[]]) > 0) then { 
	
	private _fnc_replaceInString = {
		params ["_str", "_find", "_replace"];
		private _matchPos = _str find _find;
		if (_matchPos isEqualTo -1) exitWith {_str};
		private _parts = [];
		private _len = count _find;
		while {_matchPos >= 0} do {
			_parts pushBack (_str select [0, _matchPos]);
			_str = _str select [_matchPos + _len];
			_matchPos = _str find _find;
		};
		_parts pushBack _str;
		_parts joinString _replace;  
	};
	
	hint "";

	f_var_missionLog sort true;
		
	private _list = [];
	
	{
		_x params ["_title", "_desc"];
		
		_loc = _list findIf { _x#0 == _title };
		
		if (_loc >= 0) then {
			_list set [_loc, [_title, (_list#_loc#1) + "<br/>" + _desc]];
		} else {
			_list pushBack [_title, _desc];
		};
	} forEach f_var_missionLog;
	
	player createDiaryRecord ["Diary", ["** ISSUES **", (_list apply { format["<font color='#72E500'>%1</font><br/>%2<br/>",_x#0,_x#1]} joinString "<br/>")]];
	hint parseText ("<t color='#FF0008'>Issues Found</t><br/>" + (_list apply { format["<t color='#72E500'>%1</t><br/>%2<br/>",_x#0,[_x#1,"marker","t"] call _fnc_replaceInString]} joinString "<br/>"));
};