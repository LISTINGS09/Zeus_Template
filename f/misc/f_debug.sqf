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

if (hasInterface && count (missionNamespace getVariable ["f_var_missionLog",[]]) > 0) then { player createDiaryRecord ["Diary", ["** ISSUES **", format["%1<br/>", f_var_missionLog joinString "<br/>"]]] };

// Don't run in full unless it's been called from the Administrator Menu.
if (isMultiplayer && _limitDebug) exitWith {};

if (getText ((getMissionConfig "Header") >> "gameType") == "") then { ["f_debug.sqf","Game Type has not been defined!"] call f_fnc_logIssue }; 

// Warn if the file wasn't cleared.
if (count (missionNamespace getVariable ["f_var_allGroups",[]]) > 30) then { ["mission\groups.sqf",format["%1 groups are listed! Remove unused groups from 'groups.sqf'", count f_var_allGroups]] call f_fnc_logIssue };

_arr = [];

{	// Module Check
	//diag_log text format["[F3] INFO (fn_moduleCheck.sqf): Checking Module %1 - %2",_x,typeOf _x];
	if (["module", format ["%1",typeOf _x]] call BIS_fnc_inString) then {
		_module = _x;
		_moduleID = "";
		
		if ("id" in allVariables _module) then {
			_moduleID = _module getVariable "id";
			
			if (_moduleID == "") then {
				_mkr = createMarkerLocal[format["%1_badMarker",_module],getPos _module];
				_mkr setMarkerShapeLocal "ICON";
				_mkr setMarkerColorLocal "ColorYellow";
				_mkr setMarkerSizeLocal [0.8,0.8];
				_mkr setMarkerTypeLocal "mil_dot";
				["f_debug.sqf",format["<font color='#0080FF'><marker name='%3'>%1</marker></font color> in %2 has a no ID, assign one.<br/>",_moduleID,typeOf _module,_mkr]] call f_fnc_logIssue;
			};
			
			if (_moduleID in _arr) then {
				_mkr = createMarkerLocal[format["%1_dupMarker",_module],getPos _module];
				_mkr setMarkerShapeLocal "ICON";
				_mkr setMarkerColorLocal "ColorRed";
				_mkr setMarkerSizeLocal [0.8,0.8];
				_mkr setMarkerTypeLocal "mil_dot";
				["f_debug.sqf",format["<font color='#0080FF'><marker name='%3'>%1</marker></font color> in %2 has a duplicate ID! IDs cannot be the same.<br/>",_moduleID,typeOf _module,_mkr]] call f_fnc_logIssue;
			} else { _arr pushBack _moduleID; }; // Add to checking array.
		};
		
		if ("owner" in allVariables _module) then {
				switch (_module getVariable "owner") do {
					case 4: {
						if ({side _x == west} count (playableUnits + switchableUnits) == 0) then {
							_mkr = createMarkerLocal[format["%1_marker",_module],getPos _module];
							_mkr setMarkerShapeLocal "ICON";
							_mkr setMarkerColorLocal "ColorOrange";
							_mkr setMarkerSizeLocal [0.8,0.8];
							_mkr setMarkerTypeLocal "mil_dot";
							["f_debug.sqf",format["<font color='#0080FF'><marker name='%2'>Task %1</marker></font color> has owner assigned as BLUFOR but no playable units.",_moduleID,_mkr]] call f_fnc_logIssue;
						};
					};
					case 5: {
						if ({side _x == east} count (playableUnits + switchableUnits) == 0) then {
							_mkr = createMarkerLocal[format["%1_marker",_module],getPos _module];
							_mkr setMarkerShapeLocal "ICON";
							_mkr setMarkerColorLocal "ColorOrange";
							_mkr setMarkerSizeLocal [0.8,0.8];
							_mkr setMarkerTypeLocal "mil_dot";
							["f_debug.sqf",format["<font color='#0080FF'><marker name='%2'>Task %1</marker></font color> has owner assigned as OPFOR but no playable units.",_moduleID,_mkr]] call f_fnc_logIssue;
						};
					};
					case 6: {
						if ({side _x == resistance} count (playableUnits + switchableUnits) == 0) then {
							_mkr = createMarkerLocal[format["%1_marker",_module],getPos _module];
							_mkr setMarkerShapeLocal "ICON";
							_mkr setMarkerColorLocal "ColorOrange";
							_mkr setMarkerSizeLocal [0.8,0.8];
							_mkr setMarkerTypeLocal "mil_dot";
							["f_debug.sqf",format["<font color='#0080FF'><marker name='%2'>Task %1</marker></font color> has owner assigned as INDFOR but no playable units.",_moduleID,_mkr]] call f_fnc_logIssue;
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
					_mkr = createMarkerLocal[format["%1_marker",_x],getPos _x];
					_mkr setMarkerShapeLocal "ICON";
					_mkr setMarkerColorLocal "ColorBlue";
					_mkr setMarkerSizeLocal [0.8,0.8];
					_mkr setMarkerTypeLocal "mil_dot";
					["f_debug.sqf",format["<font color='#0080FF'><marker name='%1'>Trigger (%2)</marker></font color> has activation type as BLUFOR but no playable present.",_mkr,vehicleVarName _x]] call f_fnc_logIssue;
				};
			};
			case "EAST": {
				if ({side _x == east} count allUnits == 0) then {
					_mkr = createMarkerLocal[format["%1_marker",_x],getPos _x];
					_mkr setMarkerShapeLocal "ICON";
					_mkr setMarkerColorLocal "ColorBlue";
					_mkr setMarkerSizeLocal [0.8,0.8];
					_mkr setMarkerTypeLocal "mil_dot";
					["f_debug.sqf",format["<font color='#0080FF'><marker name='%1'>Trigger (%2)</marker></font color> has activation type as OPFOR but no playable present.",_mkr,vehicleVarName _x]] call f_fnc_logIssue;
				};
			};
			case "GUER": {
				if ({side _x == resistance} count allUnits == 0) then {
					_mkr = createMarkerLocal[format["%1_marker",_x],getPos _x];
					_mkr setMarkerShapeLocal "ICON";
					_mkr setMarkerColorLocal "ColorBlue";
					_mkr setMarkerSizeLocal [0.8,0.8];
					_mkr setMarkerTypeLocal "mil_dot";
					["f_debug.sqf",format["<font color='#0080FF'><marker name='%1'>Trigger (%2)</marker></font color> has activation type as INDFOR but no playable present.",_mkr,vehicleVarName _x]] call f_fnc_logIssue;
				};
			};
		};
	};
} forEach allMissionObjects "EmptyDetector";

player globalChat format ["Players: %1, AI: BLU/%2, OPF/%3, RES/%4, CIV/%5",count (playableUnits + switchableUnits),_unitsWest,_unitsEast,_unitsResi,_unitsCiv];