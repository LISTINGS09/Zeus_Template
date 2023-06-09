// F3 - Briefing - Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// <marker name='XXX'>XXX</marker>
// Green #80FF00
// Orange #FF7F00
// Blue #00FFFF

if (isNil "f_param_CasualtiesCap") then { f_param_CasualtiesCap = 100 }; // Set CasCap if author did not.

// The code below creates the administration sub-section of notes.
_adm = player createDiaryRecord ["Diary", ["Administration",[] call f_fnc_fillAdministration]];

// Edit the if statement for different faction briefs.

if (side group player != CIVILIAN) then {
	// The code below creates the execution sub-section of notes.
	_exe = player createDiaryRecord ["Diary", ["Mission",format["
	<br/><font size='18' color='#80FF00'>OBJECTIVES</font>
	<br/>*** Insert the mission here. ***
	<br/>
	<br/>%1 <!--- Casualties Cap --->
	<br/><font size='18' color='#80FF00'>SPECIAL TASKS</font>
	<br/>*** Insert instructions for specific units here. ***
	<br/>
	<br/><font size='18' color='#80FF00'>FRIENDLY FORCES</font>
	<br/>*** Insert information about friendly forces here.***
	<br/>
	<br/><font size='18' color='#80FF00'>ENEMY FORCES</font>
	<br/>The following units are known to be operational in the AO:
	<br/>%2%3
	<br/>High Threats:
	<br/>%4
	<br/>
	<br/><font size='18' color='#80FF00'>CREDITS</font>
	<br/>Created by <font color='#FF0080'>?</font color>
	<br/>
	<br/>A custom-made mission for ArmA 3 and Zeus Community
	<br/>http://zeus-community.net
	<br/>",
	if (f_param_CasualtiesCap > 0 && f_param_CasualtiesCap < 100) then { format["Ensure casualties are kept below %1 and %1&#37; of your force is not incapacitated.<br/>", f_param_CasualtiesCap] } else { "" },
	(((vehicles select { side _x getFriend side group player < 0.6 && !(_x isKindOf "staticWeapon" || _x isKindOf "static") && count crew _x > 0}) apply {  getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName") }) call BIS_fnc_consolidateArray) apply { format["%2x <font color='#00FFFF'>%1</font><br/>", _x#0, _x#1] } joinString "",
	format["%1x <font color='#00FFFF'>Infantry Groups</font><br/>", { side _x getFriend side group player < 0.6 && count units _x >= 3 && vehicle leader _x == leader _x} count allGroups],
	((allUnits select { side _x getFriend side group player < 0.6 && count crew _x > 0 && (vehicle _x != _x || secondaryWeapon _x != "") && (getarray(configFile >> "CfgVehicles" >> typeOf vehicle _x >> "threat")#1 >= 0.9 || getarray(configFile >> "CfgVehicles" >> typeOf vehicle _x >> "threat")#2 == 1) } apply {  getText (configFile >> "CfgVehicles" >> typeOf (if (secondaryWeapon _x isEqualTo "") then { vehicle _x } else { _x }) >> "displayName") }) call BIS_fnc_consolidateArray) apply { format["%2x <font color='#00FFFF'>%1</font><br/>", _x#0, _x#1] } joinString ""
	]]];
};

/*
// Commander Endings
if (rank player in ["MAJOR","COLONEL"]) then {
	private _missionEndings = "<font size='18' color='#80FF00'>ENDINGS</font><br/><br/>These endings are available. To trigger an ending click on its link - It will take a few seconds to synchronise across all clients.<br/><br/>";

	for "_i" from 1 to 15 do {
		private _eID = format ["end%1",_i];

		if (getText (getMissionConfig "CfgDebriefing" >> _eID >> "Title") != "") then {	
			_missionEndings = _missionEndings + format [
				"%4<br/><execute expression=""['f_briefing.sqf','End%1 called by %5','INFO'] remoteExec ['f_fnc_logIssue',2]; 'End%1' remoteExec ['BIS_fnc_endMission'];"">Ending #%1</execute> - %2:<br/>%3<br/><br/>",
				_i,
				getText (getMissionConfig "CfgDebriefing" >> _eID >> "title"),
				getText (getMissionConfig "CfgDebriefing" >> _eID >> "description"),
				format["<img image='%1' height='32'/>", getText (getMissionConfig "CfgDebriefing" >> _eID >> "picture")],
				name player
			];	
		};
	};

	// Create the briefing section to display the endings
	player createDiaryRecord ["Diary", ["Endings",_missionEndings]];
};
*/

/*
// Sector Heatmap (PEL Markers)
// <br/>Toggle PEL IDs <font color='#80FF00'><execute expression=""allMapMarkers apply { if (['pel_text_',_x] call BIS_fnc_inString) then { _x setMarkerAlphaLocal 0.3 }; };"">On</execute></font> | <font color='#CF142B'><execute expression=""allMapMarkers apply { if (['pel_text_',_x] call BIS_fnc_inString) then { _x setMarkerAlphaLocal 0 }; };"">Off</execute></font>
{
	_x params ["_pos", "_count"];
	
	private _mkr = createMarkerLocal [format["pel_area_%1",_forEachIndex], _pos];
	_mkr setMarkerShapeLocal "RECTANGLE";
	_mkr setMarkerBrushLocal "SolidBorder";
	_mkr setMarkerAlphaLocal 0.3;
	_mkr setMarkerColorLocal "ColorEast";
	_mkr setMarkerSizeLocal [50,50];
	
	private _mkr = createMarkerLocal [format["pel_text_%1",_forEachIndex], [(_pos#0)-50,(_pos#1)-40]];
	_mkr setMarkerTypeLocal "MIL_DOT";
	_mkr setMarkerTextLocal format["PEL %1", _forEachIndex + 1];
	_mkr setMarkerAlphaLocal 0;
	_mkr setMarkerColorLocal "ColorEast";
	_mkr setMarkerSizeLocal [0.1,0.1];
} forEach ((allGroups select { side _x getFriend side group player < 0.6 && count units _x >= 2 } apply { getPos leader _x select [0,2] apply { _x - _x % 100 + 50 } }) call BIS_fnc_consolidateArray);
*/

/*
// Unit (Enemy Markers)
{
	private _icon = "o_unknown";
	private _veh = _x;
	
	switch true do {
		case (_veh isKindOf "staticWeapon" || _veh isKindOf "static" ): { if ("Artillery" in getArray (configFile >> "CfgVehicles" >> typeOf _veh >> "availableForSupportTypes")) then { _icon = "o_mortar" } else { _icon = "o_installation" } };
		case (_veh isKindOf "Tank"): { _icon = "o_armor" };
		case (_veh isKindOf "Truck" || _veh isKindOf "Car"): { if (canFire _veh && getNumber (configFile >> "CfgVehicles" >> typeOf _veh >> "numberPhysicalWheels") > 4) then { _icon = "o_mech_inf" } else { _icon = "o_motor_inf" } };
		case (_veh isKindOf "Plane_Base_F"): { _icon = "o_plane" };
		case (_veh isKindOf "UAV_02_base_F"): { _icon = "o_uav" };
		case (_veh isKindOf "Helicopter"): { _icon = "o_air" };
		case (_veh isKindOf "Boat_F"): { _icon = "o_naval" };
		case (_veh isKindOf "Man"): { _icon = "o_inf" };
	};
	
	if (_icon != "" && count (allMapMarkers select { (getPos _veh distance2D getMarkerPos _x) < 50 }) == 0) then {
		private _mkr = createMarkerLocal [format["veh_mkr_%1",_forEachIndex], getPos _veh];
		_mkr setMarkerTypeLocal _icon;
		_mkr setMarkerColorLocal ([side _x, true] call BIS_fnc_sideColor);
		//_mkr setMarkerTextLocal getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName");
		
		// Grey Marker when Destroyed
		private _trg = createTrigger ["EmptyDetector", getPos _veh, false];
		_trg setTriggerActivation ["NONE", "PRESENT", false];
		_trg setVariable ["monitorUnit", _veh];
		_trg setTriggerStatements ["!alive (thisTrigger getVariable ['monitorUnit', objNull]);",format["'%1' setMarkerColorLocal 'ColorGrey';", _mkr],""];
		_trg setTriggerTimeout [5, 5, 5, true];
	};
} forEach (vehicles select { side _x getFriend side group player < 0.6 && count crew _x > 0});
*/