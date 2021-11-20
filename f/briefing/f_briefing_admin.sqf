// F3 - Briefing
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================
// ADD MISSION MAKER NOTES SECTIONS
// All text added to f_var_CustomNotes will only be visible to the current admin

f_var_isAdmin = true; // Allows the player to exit the spectator menu in fn_spectateInit.sqf

if (isNil "f_var_CustomNotes") then {
	f_var_CustomNotes = "";
};

//player removeDiarySubject "ZeuAdmin";
player createDiarySubject ["ZeuAdmin","** Admin **"];

// ====================================================================================

// ADD ZEUS SUPPORT SECTION
_missionZeus = format["
<font size='18' color='#80FF00'>ZEUS SUPPORT</font><br/>
<execute expression=""
if (isNull (getAssignedCuratorLogic player)) then {
	[player] remoteExec ['f_fnc_zeusAssign',2];
} else { hintSilent parseText format['A curator is already assigned!<br/>[%1]', getAssignedCuratorLogic player] };"">Assign ZEUS to %1</execute><br/>
Creates and assigns a Zeus Curator to your in-game unit. This step must be executed BEFORE any other options can be ran.<br/>
<br/>
",profileName];

_missionZeus = _missionZeus + "<execute expression=""
if (isNull (getAssignedCuratorLogic player)) then {hintSilent 'Assign ZEUS first!'} else {
	[player] remoteExec ['f_fnc_zeusTerm',2];
};"">Disable ZEUS</execute><br/>
Disables and removes the Zeus Curator from the player.<br/>
<br/>
<br/>";

_missionZeus = _missionZeus + "<font size='18' color='#80FF00'>Objects</font><br/>";

// Garrison Fix
_missionZeus = _missionZeus + "
Re-enable <execute expression=""
if !(isNull (getAssignedCuratorLogic player)) then { (getAssignedCuratorLogic player) addEventHandler ['CuratorWaypointPlaced', { { [_x,'PATH'] remoteExec ['enableAI',_x] } forEach units (_this # 1) }]; hintSilent 'Pathing Enabled';
};"">Pathing AI</execute>.<br/>
<br/>";

// Sides
_missionZeus = _missionZeus + "
Add all by Side <execute expression=""
if (isNull (getAssignedCuratorLogic player)) then {hintSilent 'Assign yourself as ZEUS first!'} else {
	[player,west] remoteExec ['f_fnc_zeusAddObjects',2];
	hintSilent 'Added Side: West'
};"">West</execute> | 
<execute expression=""
if (isNull (getAssignedCuratorLogic player)) then {hintSilent 'Assign yourself as ZEUS first!'} else {
	[player,east] remoteExec ['f_fnc_zeusAddObjects',2];
	hintSilent 'Added Side: East'
};"">East</execute> | 
<execute expression=""
if (isNull (getAssignedCuratorLogic player)) then {hintSilent 'Assign yourself as ZEUS first!'} else {
	[player,resistance] remoteExec ['f_fnc_zeusAddObjects',2];
	hintSilent 'Added Side: Independent'
};"">Guer</execute> | 
<execute expression=""
if (isNull (getAssignedCuratorLogic player)) then {hintSilent 'Assign yourself as ZEUS first!'} else {
	[player,civilian] remoteExec ['f_fnc_zeusAddObjects',2];
	hintSilent 'Added Side: Civilian'
};"">Civ</execute> | 
<execute expression=""
if (isNull (getAssignedCuratorLogic player)) then {hintSilent 'Assign yourself as ZEUS first!'} else {
	[player,sideLogic] remoteExec ['f_fnc_zeusAddObjects',2];
	hintSilent 'Added Side: Logic'
};"">Logic</execute><br/>
<br/>";

// Everything
_missionZeus = _missionZeus + "<execute expression=""
if (isNull (getAssignedCuratorLogic player)) then {hintSilent 'Assign ZEUS first!'} else {
	[player,true] remoteExec ['f_fnc_zeusAddObjects',2];
	hintSilent 'Add All Objects.'
};"">Add Everything</execute> <font color='#FF0000'>(MAY CAUSE DESYNC)</font><br/>
Use with caution - ALL mission objects will be added to Zeus, including units, waypoints, triggers and modules.<br/>
<br/>";

// Nothing
_missionZeus = _missionZeus + "<execute expression=""
if (isNull (getAssignedCuratorLogic player)) then {hintSilent 'Assign ZEUS first!'} else {
	[player,false] remoteExec ['f_fnc_zeusAddObjects',2];
	hintSilent 'Removed All Objects.'
};"">Remove Everything</execute><br/>
Control over all mission objects is effectively reset and removed from Zeus. This includes players, units and props.<br/>
<br/>";

_missionZeus = _missionZeus + "<font size='16' color='#FF0080'>AI Units</font><br/>";

// AI Leaders
_missionZeus = _missionZeus + "<execute expression=""
if (isNull (getAssignedCuratorLogic player)) then {hintSilent 'Assign ZEUS first!'} else {
	[player,'ai',true] remoteExec ['f_fnc_zeusAddObjects',2];
	hintSilent 'AI Leaders Added'
};"">Leaders</execute> Add only infantry AI Leaders, vehicles are not included.<br/>";

// AI All
_missionZeus = _missionZeus + "<execute expression=""
if (isNull (getAssignedCuratorLogic player)) then {hintSilent 'Assign ZEUS first!'} else {
	[player,'ai'] remoteExec ['f_fnc_zeusAddObjects',2];
	hintSilent 'All AI Added'
};"">All</execute> Add every AI unit present in the world to Zeus, includes vehicles.<br/>
<br/>";

_missionZeus = _missionZeus + "<font size='16' color='#FF0080'>Players</font><br/>Adding any player to Zeus will allow the unit to PING you!<br/>";

// Players - Leaders
_missionZeus = _missionZeus + "<execute expression=""
if (isNull (getAssignedCuratorLogic player)) then {hintSilent 'Assign yourself as ZEUS first!'} else {
	[player,(playableUnits + switchableUnits),true] remoteExec ['f_fnc_zeusAddObjects',2];
	hintSilent 'Player Leaders Added'
};"">Leaders</execute> Add all player leads to Zeus.<br/>";

// Players - All
_missionZeus = _missionZeus + "<execute expression=""
if (isNull (getAssignedCuratorLogic player)) then {hintSilent 'Assign yourself as ZEUS first!'} else {
	[player,(playableUnits + switchableUnits)] remoteExec ['f_fnc_zeusAddObjects',2];
	hintSilent 'All Players Added'
};"">All</execute> Add every player to Zeus.<br/>
<br/>";

_missionZeus = _missionZeus + "<execute expression=""
if (isNull (getAssignedCuratorLogic player)) then {hintSilent 'Assign yourself as ZEUS first!'} else {
	[player] remoteExec ['f_fnc_zeusRemovePlayers',2];
};"">Remove</execute> Remove all players from Zeus.<br/>
<br/>";


_missionZeus = _missionZeus + "<font size='16' color='#FF0080'>Vehicles / Props</font><br/>";

// Vehicles
_missionZeus = _missionZeus + "<execute expression=""
if (isNull (getAssignedCuratorLogic player)) then {hintSilent 'Assign yourself as ZEUS first!'} else {
	[player,'vehicles'] remoteExec ['f_fnc_zeusAddObjects',2];
	hintSilent 'Added Vehicles'
};"">Vehicles Only</execute> Add all vehicles to Zeus.<br/>";

// Props
_missionZeus = _missionZeus + "<execute expression=""
if (isNull (getAssignedCuratorLogic player)) then {hintSilent 'Assign ZEUS first!'} else {
	[player,'empty'] remoteExec ['f_fnc_zeusAddObjects',2];
	hintSilent 'Added Objects / Props'
};"">Add Objects</execute> Add empty objects and props to Zeus.<br/>
<br/>
<br/>";

_missionZeus = _missionZeus + "<font size='18' color='#FF0080'>Addons</font><br/>Do not use if 3rd Party Addons are running (ACE3 etc).<br/><br/>";

// None
_missionZeus = _missionZeus + "<execute expression=""
if (isNull (getAssignedCuratorLogic player)) then {hintSilent 'Assign ZEUS first!'} else {
	[player,false] remoteExec ['f_fnc_zeusAddAddons',2];
	hintSilent 'Removed Addons'
};"">Remove All</execute><br/>Removes any addons present from the Zeus Interface.<br/>
<br/>";

// Basic
_missionZeus = _missionZeus + "<execute expression=""
if (isNull (getAssignedCuratorLogic player)) then {hintSilent 'Assign ZEUS first!'} else {
	[player,'basic'] remoteExec ['f_fnc_zeusAddAddons',2];
	hintSilent 'Basic Addons Enabled'
};"">Add Basic Addons</execute><br/>Assigns a basic set of module addons to Zeus. Ability to spawn units are not included.<br/>
<br/>";

// Everything
_missionZeus = _missionZeus + "<execute expression=""
if (isNull (getAssignedCuratorLogic player)) then {hintSilent 'Assign ZEUS first!'} else {
	[player,true] remoteExec ['f_fnc_zeusAddAddons',2];
	hintSilent 'All Addons Enabled'
};"">Add All Addons</execute><br/>Assigns all addons from cfgPatches. Allowing Zeus to access and place ALL units and modules.<br/>
<br/>
<br/>";

player createDiaryRecord ["ZeuAdmin", ["Zeus",_missionZeus]];

// ====================================================================================

// SAFE START SECTION
_missionSafe = "<br/><font size='18' color='#80FF00'>SAFE START CONTROL</font><br/><br/>
<execute expression=""f_param_safe_start = f_param_safe_start + 1; publicVariable 'f_param_safe_start'; hintSilent format ['Mission Timer: %1',f_param_safe_start];"">Increase Timer by 1 minute</execute><br/>
<execute expression=""f_param_safe_start = f_param_safe_start - 1; publicVariable 'f_param_safe_start'; hintSilent format ['Mission Timer: %1',f_param_safe_start];"">Decrease Timer by 1 minute</execute><br/>
Adjusts the Safe Start timer. If Safe Start is not running, it will need restarted using the command below.<br/>
<br/>
<execute expression=""[[[],'f\safeStart\f_safeStart.sqf'],'BIS_fnc_execVM',true] call BIS_fnc_MP; hintSilent 'Safe Start Running!';"">Begin Safe Start timer</execute><br/>
Restarts the Safe Start timer for all players, if the timer has previously expired it will need additional time added to it using the Safe Start command above.<br/>
<br/>
<execute expression=""f_param_safe_start = -1; publicVariable 'f_param_safe_start';
['SafeStartMissionStarting',['Safe Start Ended!']] remoteExec ['bis_fnc_showNotification',0];
[false] remoteExec ['f_fnc_safety',0,true]; hintSilent 'Safe Start ended!';"">
End Safe Start timer</execute><br/>
Immediately ends the Safe Start timer for all players.<br/>
<br/>
<br/>";

player createDiaryRecord ["ZeuAdmin", ["Safe Start",_missionSafe]];

// ====================================================================================

// DEBUG SECTION
_missionDebug = "<font size='18' color='#80FF00'>DEBUG OPTIONS</font><br/><br/>
<execute expression=""systemChat 'Dead Units Deleted'; { if (_x distance player < 300) then { deleteVehicle _x }; } forEach allDead;"">Remove Dead Units (300m)</execute><br/>
<br/>
<execute expression=""systemChat 'Click on Map to teleport'; player onMapSingleClick {player setPos _pos; openMap false; onMapSingleClick ''; true;};"">Map Click Teleport</execute><br/>
<br/>
<execute expression=""[] call fnc_AdminTasking;"">Show Task Control</execute><br/>
<br/>
Reveal Players to AI: 
<execute expression=""systemChat 'Starting Reveal'; 
{ f_var_doReveal = true;
	while {	f_var_doReveal } do { 
		sleep 60; 
		{ 
			private _rGrp = _x; 
			{ if (_rGrp knowsAbout _x < 4) then { _rGrp reveal [_x, 4] } } forEach (allPlayers select { side _x != side _rGrp AND objectParent _x == _x AND stance _x == 'STAND' });
			sleep 0.5;
		} forEach (allGroups select { side _x != side group (selectRandom allPlayers) });
	}; 
} remoteExec ['BIS_fnc_spawn', 0];"">Start</execute>
 | <execute expression=""systemChat 'Stopping Reveal'; missionNamespace setVariable ['f_var_doReveal', false, true];"">Stop</execute><br/>
<br/>
<execute expression=""[player, { if (count (missionNamespace getVariable ['f_var_missionLog',[]]) > 0) then { [_this,['Diary', ['** ISSUES (Server) **', format['%1<br/>', f_var_missionLog joinString '<br/>']]]] remoteExec ['createDiaryRecord',_this]; } else { 'Server Issue log has no entries!' remoteExec ['systemChat',_this]; } }] remoteExec ['bis_fnc_spawn', 0];"">Server Issues List</execute><br/>
<br/>
<execute expression=""diag_log text '*** Active SQF Scripts Start ***';{diag_log _x} forEach diag_activeSQFScripts;diag_log text '*** Active SQF Scripts End ***';hintSilent 'Logging Scripts to local RPT';"">SQF Debug</execute><br/>
Uses diag_activeSQFScripts to list all running SQF Scripts to your LOCAL report.<br/>
<br/>
<execute expression=""[[true],'f\misc\f_debug.sqf'] remoteExec ['BIS_fnc_execVM',2];hintSilent 'Starting Debug';"">Checking Script</execute><br/>
This performs a basic check for any mission related logic issues and problems. It is automatically called at the start of the mission in single player.<br/>
<br/>
Map Border: <execute expression=""{ if (['zao_',_x] call BIS_fnc_inString) then { _x setMarkerAlphaLocal 0 } } forEach allMapMarkers;"">Hide</execute> |
<execute expression=""{ if (['zao_',_x] call BIS_fnc_inString) then { _x setMarkerAlphaLocal 1 } } forEach allMapMarkers;"">Show</execute> |
<execute expression=""{ if (['zao_',_x] call BIS_fnc_inString) then { _x setMarkerAlpha 0 } } forEach allMapMarkers;"">Hide (Global)</execute> | 
<execute expression=""{ if (['zao_',_x] call BIS_fnc_inString) then { _x setMarkerAlpha 1 } } forEach allMapMarkers;"">Show (Global)</execute><br/>
<br/>
";

player createDiaryRecord ["ZeuAdmin", ["Debug",_missionDebug]];

// GEAR
private _missionGear = "<font size='16' color='#80FF00'>Gear</font><br/>If you are NOT in a vehicle, the vehicle or box you are looking at will attempt to be used. Otherwise, a crate will be spawned according to the spawn mode.<br/><br/>";

_missionGear = _missionGear + "
Spawn Mode: <execute expression=""missionNamespace setVariable ['var_dropAmmo',false]; systemChat 'Spawn Mode: At Feet';"">At Feet</execute> | <execute expression=""missionNamespace setVariable ['var_dropAmmo',true]; systemChat 'Spawn Mode: Air Drop';"">Air Dropped</execute><br/><br/>
<execute expression=""
	private _gearType = 'v_car';
	private _gearTarget = if (vehicle player != player) then { vehicle player } else { if (cursorObject isKindOf 'AllVehicles' || cursorObject isKindOf 'Thing') then { cursorObject } else { objNull } };
	if (isNull _gearTarget) then { _gearTarget = createVehicle ['Box_Syndicate_Ammo_F', player modelToWorld [0,2,0], [], 0, 'NONE']; if (missionNamespace getVariable ['var_dropAmmo', false]) then { _gearTarget setPos (player modelToWorld [0,1, 150]); [objNull, _gearTarget] call BIS_fnc_curatorObjectEdited; }; };
	[_gearType, _gearTarget, side group player] remoteExec ['f_fnc_assignGear', owner _gearTarget];
	systemChat format['Gear: Filled %1 (%2)', typeOf _gearTarget, _gearType];
"">Car Inventory</execute><br/>
<execute expression=""
	private _gearType = 'v_tr';
	private _gearTarget = if (vehicle player != player) then { vehicle player } else { if (cursorObject isKindOf 'AllVehicles' || cursorObject isKindOf 'Thing') then { cursorObject } else { objNull } };
	if (isNull _gearTarget) then { _gearTarget = createVehicle ['Box_Syndicate_Ammo_F', player modelToWorld [0,2,0], [], 0, 'NONE']; if (missionNamespace getVariable ['var_dropAmmo', false]) then { _gearTarget setPos (player modelToWorld [0,1, 150]); [objNull, _gearTarget] call BIS_fnc_curatorObjectEdited; }; };
	[_gearType, _gearTarget, side group player] remoteExec ['f_fnc_assignGear', owner _gearTarget];
	systemChat format['Gear: Filled %1 (%2)', typeOf _gearTarget, _gearType];
"">Truck Inventory</execute><br/>
<execute expression="" 
	private _gearType = 'v_ifv';
	private _gearTarget = if (vehicle player != player) then { vehicle player } else { if (cursorObject isKindOf 'AllVehicles' || cursorObject isKindOf 'Thing') then { cursorObject } else { objNull } };
	if (isNull _gearTarget) then { _gearTarget = createVehicle ['Box_Syndicate_Ammo_F', player modelToWorld [0,2,0], [], 0, 'NONE']; if (missionNamespace getVariable ['var_dropAmmo', false]) then { _gearTarget setPos (player modelToWorld [0,1, 150]); [objNull, _gearTarget] call BIS_fnc_curatorObjectEdited; }; };
	[_gearType, _gearTarget, side group player] remoteExec ['f_fnc_assignGear', owner _gearTarget];
	systemChat format['Gear: Filled %1 (%2)', typeOf _gearTarget, _gearType];
"">IFV Inventory</execute><br/>
Supply Inventory <execute expression="" 
	private _gearType = 'crate_small';
	private _gearTarget = if (vehicle player != player) then { vehicle player } else { if (cursorObject isKindOf 'AllVehicles' || cursorObject isKindOf 'Thing') then { cursorObject } else { objNull } };
	if (isNull _gearTarget) then { _gearTarget = createVehicle ['Box_NATO_Support_F', player modelToWorld [0,2,0], [], 0, 'NONE']; if (missionNamespace getVariable ['var_dropAmmo', false]) then { _gearTarget setPos (player modelToWorld [0,1, 150]); [objNull, _gearTarget] call BIS_fnc_curatorObjectEdited; }; };
	[_gearType, _gearTarget, side group player] remoteExec ['f_fnc_assignGear', owner _gearTarget];
	systemChat format['Gear: Filled %1 (%2)', typeOf _gearTarget, _gearType];
"">Small Box</execute> | 
<execute expression="" 
	private _gearType = 'crate_med';
	private _gearTarget = if (vehicle player != player) then { vehicle player } else { if (cursorObject isKindOf 'AllVehicles' || cursorObject isKindOf 'Thing') then { cursorObject } else { objNull } };
	if (isNull _gearTarget) then { _gearTarget = createVehicle ['B_supplyCrate_F', player modelToWorld [0,2,0], [], 0, 'NONE']; if (missionNamespace getVariable ['var_dropAmmo', false]) then { _gearTarget setPos (player modelToWorld [0,1, 150]); [objNull, _gearTarget] call BIS_fnc_curatorObjectEdited; }; };
	[_gearType, _gearTarget, side group player] remoteExec ['f_fnc_assignGear', owner _gearTarget];
	systemChat format['Gear: Filled %1 (%2)', typeOf _gearTarget, _gearType];
"">Medium Crate</execute> | 
<execute expression="" 
	private _gearType = 'crate_large';
	private _gearTarget = if (vehicle player != player) then { vehicle player } else { if (cursorObject isKindOf 'AllVehicles' || cursorObject isKindOf 'Thing') then { cursorObject } else { objNull } };
	if (isNull _gearTarget) then { _gearTarget = createVehicle ['B_CargoNet_01_ammo_F', player modelToWorld [0,2,0], [], 0, 'NONE']; if (missionNamespace getVariable ['var_dropAmmo', false]) then { _gearTarget setPos (player modelToWorld [0,1, 150]); [objNull, _gearTarget] call BIS_fnc_curatorObjectEdited; }; };
	[_gearType, _gearTarget, side group player] remoteExec ['f_fnc_assignGear', owner _gearTarget];
	systemChat format['Gear: Filled %1 (%2)', typeOf _gearTarget, _gearType];
"">Large Cargo Net</execute><br/>
<br/>
";

if ("acre_main" in activatedAddons) then {

	private _missionGear = "<font size='16' color='#80FF00'>ACRE</font><br/>Clicking any of the below will automatically add the item to your uniform inventory.<br/><br/>";

	{ 
		if (isClass (configFile >> "CfgWeapons" >> _x)) then {
			_missionGear = _missionGear + format["<img image='%4' height='64'/> <execute expression=""uniformContainer player addItemCargoGlobal ['%1', 1]; systemChat 'Added %2';"">%3</execute><br/><br/><br/>", 
				_x,
				getText (configFile >> "CfgWeapons" >> _x >> "displayName"),
				getText (configFile >> "CfgWeapons" >> _x >> "descriptionShort"),
				getText (configFile >> "CfgWeapons" >> _x >> "picture")
			];
		};
	} forEach ["ACRE_PRC343","ACRE_PRC148","ACRE_PRC152","ACRE_PRC77","ACRE_PRC117F"];
};

player createDiaryRecord ["ZeuAdmin", ["Gear",_missionGear]];

// ====================================================================================

// TRIGGER SECTION
_missionTrigger = "<font size='18' color='#80FF00'>TRIGGER OPTIONS</font><br/><br/>This details all triggers in the mission and will allow them to be force-completed, deleted or resulting code executed on the server. Special syntax such as 'thisTrigger' when used in activation code, WILL NOT be functional if executing the code manually - The trigger should be force Activated instead.<br/>";

_encodeText = {
	private _specialChars = [38, 60, 62, 34, 39]; //  & < > " '
	private _convertTo = [[38,97,109,112,59], [38,108,116,59], [38,103,116,59], [38,113,117,111,116,59], [38,97,112,111,115,59]]; //  &amp; &lt; &gt; &quot; &apos;
	private _chars = [];
	private "_i";

	{
		_i = _specialChars find _x;
		if (_i isEqualTo -1) then { _chars pushBack _x } else { _chars append (_convertTo select _i) };
	} forEach toArray param [0,"",[""]];

	toString _chars
};

{	// Trigger Check
	//diag_log text format["[F3] INFO (fn_moduleCheck.sqf): Checking Trigger %1 - %2",_x,typeOf _x];
	_missionTrigger = _missionTrigger + format["<br/><font size='16' color='#FF0080'>%1</font> - 
	<font color='#80FF00'><execute expression=""if !(triggerActivated %1) then { { if (!isNil '%1') then { %1 setTriggerStatements ['true',(triggerStatements %1)#1, (triggerStatements %1)#2] };} remoteExec ['BIS_fnc_spawn',2]; hintSilent 'Trigger %1 already Activated'; } else { hintSilent 'Trigger %1 is already enabled' };"">Activate</execute></font> 
	| <font color='#CF142B'><execute expression=""if (simulationEnabled %1) then {{ if (!isNil '%1') then { %1 enableSimulationGlobal false };} remoteExec ['BIS_fnc_spawn',2]; hintSilent 'Trigger %1 Disabled'} else { hintSilent 'Trigger %1 is already Disabled' };"">Disable</execute></font> 
	| <font color='#808800'><execute expression=""if !(simulationEnabled %1) then { if (!isNil '%1') then { %1 enableSimulationGlobal true };} remoteExec ['BIS_fnc_spawn',2]; hintSilent 'Trigger %1 Enabled' } else { hintSilent 'Trigger %1 is already Enabled' };"">Enable</execute></font>:<br/>", vehicleVarName _x];
	if (triggerType _x != "NONE") then { _missionTrigger = _missionTrigger + format["Type: <font color='#888888'>%1</font>", triggerType _x] };
	if !(triggerActivation _x isEqualTo ["NONE","PRESENT",false]) then { _missionTrigger = _missionTrigger + format["Activation: <font color='#888888'>%1</font><br/>", triggerActivation _x] };
	if ((triggerStatements _x)#0 != "true") then { _missionTrigger = _missionTrigger + format["Condition: <font color='#8888BB'>%1</font><br/>", [(triggerStatements _x)#0] call _encodeText] };
	if ((triggerStatements _x)#1 != "") then { _missionTrigger = _missionTrigger + format["On Activation - 
	<execute expression=""{ call compile ((triggerStatements %2)#1); } remoteExec ['BIS_fnc_spawn',2]; hintSilent '%2 Code Executed (Server)';"">Exec Server</execute> 
	| <execute expression=""{ call compile ((triggerStatements %2)#1); } remoteExec ['BIS_fnc_spawn',0]; hintSilent '%2 Code Executed (Global)';"">Exec Global</execute>:<br/>
	<font color='#88BB88'>%1</font><br/>", [(triggerStatements _x)#1] call _encodeText, _x] };
	if ((triggerStatements _x)#2 != "") then { _missionTrigger = _missionTrigger + format["On Deactivation - 
	<execute expression=""{ call compile ((triggerStatements %2)#2); } remoteExec ['BIS_fnc_spawn',2]; hintSilent '%2 Code Executed (Server)';"">Exec Server</execute> 
	| <execute expression=""{ call compile ((triggerStatements %2)#2); } remoteExec ['BIS_fnc_spawn',0]; hintSilent '%2 Code Executed (Global)';"">Exec Global</execute>:<br/>
	<font color='#BB8888'>%1</font><br/>", [(triggerStatements _x)#2] call _encodeText, _x] };
	
} forEach (allMissionObjects "EmptyDetector" select { vehicleVarName _x != "" });

player createDiaryRecord ["ZeuAdmin", ["Triggers",_missionTrigger]];

// ====================================================================================

// FRAMEWORK SECTION
_missionFramework = "<font size='18' color='#80FF00'>FRAMEWORK CONTROL</font><br/><br/>
Lists the core features of the framework and allows for forced-start, re-runs or termination core components.<br/>
<br/>
Enhanced Logging: <font color='#80FF00'><execute expression=""f_param_debugMode = 1; publicVariable 'f_param_debugMode';hintSilent 'Logging: On';"">On</execute></font> | 
<font color='#CF142B'><execute expression=""f_param_debugMode = 0; publicVariable 'f_param_debugMode';hintSilent 'Logging: Off';"">Off</execute></font><br/>
Toggles the internal F3 Debug feature, which logs actions within the framework into the report log.<br/><br/>";

// Framework Scripts
_missionFramework = _missionFramework + "<font size='16' color='#FF0080'>VARIABLES</font><br/>Allows the termination and re-running of core variables.<br/><br/>";

{
	_x params ["_title", "_variable", "_message"];
	_missionFramework = _missionFramework + format["%1: <font color='#80FF00'>On <execute expression="" %2 = true; publicVariable '%2'; hintSilent '%3: On (Global)';"">(Global)</execute> <execute expression=""%2 = true; hintSilent '%3: On (Local)';"">(Local)</execute></font> | <font color='#CF142B'>Off <execute expression=""%2 = false; publicVariable '%2'; hintSilent '%3: Off (Global)';"">(Global)</execute> <execute expression=""%2 = false; hintSilent '%3: Off (Local)';"">(Local)</execute></font><br/>", _title, _variable, _message];
} forEach [
	["Markers - Team Tracking","f_var_ShowFTMarkers","Team Tracking"],
	["Markers - Display Injured","f_var_ShowInjured","Display Injured"]
];

// Framework Scripts
_missionFramework = _missionFramework + "<br/><font size='16' color='#FF0080'>SCRIPTS</font><br/>Allows the termination and re-running of core scripts.<br/><br/>";

{
	_x params ["_title", "_variable", "_location"];
	_missionFramework = _missionFramework + format["
	%1: <font color='#80FF00'><execute expression=""{%2 = execVM '%3';} remoteExec ['BIS_fnc_spawn', 0];"">Run</execute></font> | <font color='#CF142B'><execute expression=""[%2] remoteExec ['terminate',0]"">Terminate</execute></font><br/>",_title, _variable, _location];
} forEach [
	["Briefing - Core Texts","f_sqf_brief", "f\briefing\briefing.sqf"],
	["Briefing - ORBAT","f_sqf_orbat", "f\briefing\f_showOrbat.sqf"],
	["Briefing - Gear Selection","f_sqf_gearSel", "f\briefing\f_showLoadoutSelect.sqf"],
	["Group - Team Colors","f_sqf_ftmk", "f\setTeamColours\f_setTeamColours.sqf"],
	["Group - Group Markers","f_sqf_grpm", "f\groupMarkers\f_setLocGroupMkr.sqf"],
	["Group - Team Markers","f_sqf_ftmrk", "f\FTMemberMarkers\f_initFTMarkers.sqf"],
	["Map - AO Border","f_sqf_draw","f\briefing\f_drawAO.sqf"],
	["Misc - Intro","f_sqf_intro","f\common\f_clientIntro.sqf"],
	["Misc - Third Person","f_sqf_third", "f\thirdPerson\f_thirdPerson.sqf"],
	["Misc - VAS Crate","f_sqf_vas", "f\misc\f_vas.sqf"],
	["Misc - JIP Teleport Flag/Action","f_sqf_jip", "f\JIP\f_teleportOption.sqf"],
	["Misc - Earplugs","f_sqf_earp", "f\earplug\f_earplugs.sqf"],
	["Misc - Nametags","f_sqf_names", "f\nametag\f_nametags.sqf"],
	["Misc - Safe Start","f_sqf_safe", "f\safeStart\f_safeStart.sqf"],
	["Misc - Unit Caching","f_sqf_cache", "f\cache\f_cInit.sqf"]
];

if (missionNamespace getVariable ["f_var_medical_level", 0] == 1) then {
	_missionFramework = _missionFramework + "<br/>Medical - FAROOQ: <font color='#80FF00'><execute expression=""{missionNamespace setVariable ['f_var_medical_level', 1, true]; _nul = [] execVM 'f\medical\FAR_revive\FAR_revive_init.sqf'; hintSilent 'FAR Medical: Enabled';} remoteExec ['BIS_fnc_spawn', 0];"">Enable</execute></font> | <font color='#CF142B'><execute expression=""{[player] call FAR_fnc_unitRemove} remoteExec ['BIS_fnc_spawn',0]; hintSilent 'FAR Medical: Disabled';"">Disable</execute></font><br/>";
};

player createDiaryRecord ["ZeuAdmin", ["Framework",_missionFramework]];

// ====================================================================================

// WEATHER CONTROL
f_var_trans = 300; // Transiton time in seconds
_missionWeather = "<font size='18' color='#80FF00'>TIME / WEATHER / VIEW</font><br/>
<br/><font color='#80FF00'>TIME</font>
<br/>Instantly skip time forward a given number of hours/minutes:
<br/>
<execute expression=""0.5 remoteExec ['skipTime', 2]; hintSilent 'Time: +30 Minutes';"">+30 Minutes</execute> | 
<execute expression=""1 remoteExec ['skipTime', 2]; hintSilent 'Time: +1 hour';"">+1 Hour</execute> | 
<execute expression=""6 remoteExec ['skipTime', 2]; hintSilent 'Time: +6 hours';"">+6 Hours</execute> | 
<execute expression=""12 remoteExec ['skipTime', 2]; hintSilent 'Time: +12 hours';"">+12 Hours</execute> | 
<execute expression=""24 remoteExec ['skipTime', 2]; hintSilent 'Time: +24 hours';"">+24 Hours</execute>
<br/>
<br/><font color='#80FF00'>DELAY</font>
<br/>The following applies to both WIND and CLOUD/RAIN settings. Use the below to adjust the delay to allow for gradual weather changes (e.g thick fog forms in 10 minutes):
<br/>
<execute expression=""f_var_trans = 0; hintSilent format['Delay set to: %1',f_var_trans];"">Reset to Zero</execute> | 
<execute expression=""f_var_trans = 300; hintSilent format['Delay set to: %1',f_var_trans];"">Reset to 5 Minutes</execute> | 
<execute expression=""f_var_trans = f_var_trans + 60; hintSilent format['Delay increased to %1',f_var_trans];"">+60 Secs</execute> | 
<execute expression=""if (f_var_trans <= 60) then { f_var_trans = 0; } else { f_var_trans = f_var_trans - 60; }; hintSilent format['Delay decreased to %1',f_var_trans];"">-60 Secs</execute>
<br/>
<br/><font color='#80FF00'>FOG</font>
<br/>Fog is applied across the server according to the DELAY chosen above (default: 5 minutes). A zero delay means the change will be instant.
<br/>
<br/>Any value greater than a delay of 0 will gradually adjust the conditions and appear more natural:<br/>
<execute expression=""[-1, 0, [0,0,0]] remoteExec ['f_fnc_setFog',2]; hintSilent format['Removing Fog', f_var_trans];"">Disable Fog (Instant)</execute>
<br/>
<br/>
<execute expression=""publicVariable 'f_var_trans'; [-1, f_var_trans, [0,0,0]] remoteExec ['f_fnc_setFog',2]; hintSilent format['Fog: None (%1 secs)', f_var_trans];"">None</execute> | 
<execute expression=""publicVariable 'f_var_trans'; [-1, f_var_trans, [0.1,0,0]] remoteExec ['f_fnc_setFog',2]; hintSilent format['Fog: Very Light (%1 secs)', f_var_trans];"">Very Light</execute> | 
<execute expression=""publicVariable 'f_var_trans'; [-1, f_var_trans, [0.2,0,0]] remoteExec ['f_fnc_setFog',2]; hintSilent format['Fog: Light (%1 secs)', f_var_trans];"">Light</execute> | 
<execute expression=""publicVariable 'f_var_trans'; [-1, f_var_trans, [0.4,0,0]] remoteExec ['f_fnc_setFog',2]; hintSilent format['Fog: Medium (%1 secs)', f_var_trans];"">Medium</execute> | 
<execute expression=""publicVariable 'f_var_trans'; [-1, f_var_trans, [0.6,0,0]] remoteExec ['f_fnc_setFog',2]; hintSilent format['Fog: Thick (%1 secs)', f_var_trans];"">Thick</execute> | 
<execute expression=""publicVariable 'f_var_trans'; [-1, f_var_trans, [0.8,0,0]] remoteExec ['f_fnc_setFog',2]; hintSilent format['Fog: Very Thick (%1 secs)', f_var_trans];"">Very Thick</execute> | 
<execute expression=""publicVariable 'f_var_trans'; [-1, f_var_trans, [1,0,0]] remoteExec ['f_fnc_setFog',2]; hintSilent format['Fog: Full (%1 secs)', f_var_trans];"">Full</execute>
<br/>
<br/><execute expression=""hintSilent format['Fog is: %1',fog];"">Check Fog Setting</execute>
<br/>
<br/><font color='#80FF00'>CLOUDS/RAIN</font>
<br/>Weather is applied across the server according to the DELAY chosen above (default: 5 minutes). If a delay is selected, the engine will take UP TO ONE HOUR to fully change conditions. 
<br/>
<br/>If the delay is set to zero, weather settings will INSTANTLY be applied:
<br/>
<execute expression=""publicVariable 'f_var_trans'; [1, f_var_trans] remoteExec ['f_fnc_setWeather',2]; hintSilent format['Weather: Clear (%1 secs)', f_var_trans];"">Clear</execute> | 
<execute expression=""publicVariable 'f_var_trans'; [2, f_var_trans] remoteExec ['f_fnc_setWeather',2]; hintSilent format['Weather: Light Cloud (%1 secs)', f_var_trans];"">Light</execute> | 
<execute expression=""publicVariable 'f_var_trans'; [3, f_var_trans] remoteExec ['f_fnc_setWeather',2]; hintSilent format['Weather: Overcast (%1 secs)', f_var_trans];"">Overcast</execute> | 
<execute expression=""publicVariable 'f_var_trans'; [4, f_var_trans] remoteExec ['f_fnc_setWeather',2]; hintSilent format['Weather: Light Rain (%1 secs)', f_var_trans];"">Rain</execute> | 
<execute expression=""publicVariable 'f_var_trans'; [5, f_var_trans] remoteExec ['f_fnc_setWeather',2]; hintSilent format['Weather: Rainy (%1 secs)', f_var_trans];"">Heavy Rain</execute> | 
<execute expression=""publicVariable 'f_var_trans'; [6, f_var_trans] remoteExec ['f_fnc_setWeather',2]; hintSilent format['Weather: Stormy (%1 secs)', f_var_trans];"">Storm</execute>
<br/>
<br/><execute expression=""hintSilent format['Clouds are: %1',overcast];"">Check Cloud Setting</execute><br/>
<br/>
<font color='#80FF00'>WIND</font>
<br/>The wind settings below will override those determined by the Cloud/Rain settings. Altering any cloud settings will reset all wind values:
<br/>
<execute expression=""[0] remoteExec ['f_fnc_setWind',2]; hintSilent 'Wind: None';"">None</execute> | 
<execute expression=""[2] remoteExec ['f_fnc_setWind',2]; hintSilent 'Wind: Very Low';"">Very Low</execute> | 
<execute expression=""[4] remoteExec ['f_fnc_setWind',2]; hintSilent 'Wind: Low';"">Low</execute> | 
<execute expression=""[6] remoteExec ['f_fnc_setWind',2]; hintSilent 'Wind: Medium';"">Medium</execute> | 
<execute expression=""[8] remoteExec ['f_fnc_setWind',2]; hintSilent 'Wind: High';"">Strong</execute> | 
<execute expression=""[10] remoteExec ['f_fnc_setWind',2]; hintSilent 'Wind: Very High';"">Very Strong</execute> | 
<execute expression=""[20] remoteExec ['f_fnc_setWind',2]; hintSilent 'Wind: Hurricane';"">Hurricane</execute>
<br/>
<br/><execute expression=""hintSilent format['Wind Speed is: %1',wind];"">Check Wind Speed</execute>
<br/>
<br/>
<font color='#80FF00'>GLOBAL VIEW DISTANCE</font>
<br/>The view distance settings below will override all those connecting and connected to the server:
<br/>
<execute expression=""{setViewDistance 600; setObjectViewDistance 500} remoteExec ['BIS_fnc_spawn',0,'z_viewDist']; hintSilent 'View Distance: 500m';"">500m</execute> | 
<execute expression=""{setViewDistance 1500; setObjectViewDistance 1000} remoteExec ['BIS_fnc_spawn',0,'z_viewDist']; hintSilent 'View Distance: 1000m';"">1000m</execute> | 
<execute expression=""{setViewDistance 2000; setObjectViewDistance 1500} remoteExec ['BIS_fnc_spawn',0,'z_viewDist']; hintSilent 'View Distance: 1500m';"">1500m</execute> | 
<execute expression=""{setViewDistance 2500; setObjectViewDistance 2000} remoteExec ['BIS_fnc_spawn',0,'z_viewDist']; hintSilent 'View Distance: 2000m';"">2000m</execute> | 
<execute expression=""{setViewDistance 3000; setObjectViewDistance 2500} remoteExec ['BIS_fnc_spawn',0,'z_viewDist']; hintSilent 'View Distance: 2500m';"">2500m</execute> | 
<execute expression=""{setViewDistance 3500; setObjectViewDistance 3000} remoteExec ['BIS_fnc_spawn',0,'z_viewDist']; hintSilent 'View Distance: 3000m';"">3000m</execute> | 
<execute expression=""{setViewDistance 5500; setObjectViewDistance 5000} remoteExec ['BIS_fnc_spawn',0,'z_viewDist']; hintSilent 'View Distance: 5000m';"">5000m</execute>
<br/>
";

player createDiaryRecord ["ZeuAdmin", ["Time & Weather",_missionWeather]];

// ====================================================================================

// ENDINGS SECTION
// This block of code collects all valid endings and formats them properly

private _missionEndings = "<font size='18' color='#80FF00'>ENDINGS</font><br/><br/>These endings are available. To trigger an ending click on its link - It will take a few seconds to synchronise across all clients.<br/><br/>";

for "_i" from 1 to 15 do {
	private _eID = format ["end%1",_i];

	if (getText (getMissionConfig "CfgDebriefing" >> _eID >> "Title") != "") then {	
		_missionEndings = _missionEndings + format [
			"%4<br/><execute expression=""['f_briefing_admin.sqf','End%1 called by %5','INFO'] remoteExec ['f_fnc_logIssue',2]; 'End%1' remoteExec ['BIS_fnc_endMission'];"">Ending #%1</execute> - %2:<br/>%3<br/><br/>",
			_i,
			getText (getMissionConfig "CfgDebriefing" >> _eID >> "title"),
			getText (getMissionConfig "CfgDebriefing" >> _eID >> "description"),
			format["<img image='%1' height='32'/>", getText (getMissionConfig "CfgDebriefing" >> _eID >> "picture")],
			name player
		];	
	};
};

// Create the briefing section to display the endings
player createDiaryRecord ["ZeuAdmin", ["Endings",_missionEndings]];

// Tasking
// Tasks take time to initialise, so this must be ran in-game
fnc_AdminTasking = {
	_taskText = "<font size='18' color='#80FF00'>TASKS</font><br/><br/>These tasks are present in the mission. To complete a task click on its link.<br/>";
	_taskList = [];

	_fnc_processTask = {
		params ["_taskID"];
		
		_task = _x;
		_children = _x call BIS_fnc_taskChildren;
		
		_taskList pushBackUnique _task;
		
		// Does this have children?
		if (count _children > 0) then {
			{ [_x] call _fnc_processTask } forEach _children;
		};
	};

	// Process all tasks with no parents.
	{
		[_x] call _fnc_processTask;
	} forEach ((player call BIS_fnc_tasksUnit) select {(_x call BIS_fnc_taskParent) == ""});


	_lastParent = "";
	
	{
		private _parent = _x call BIS_fnc_taskParent;
		//private _children = _x call BIS_fnc_taskChildren;
		
		_taskText = _taskText + format [
			"%6%5<img image='\A3\ui_f\data\igui\cfg\simpleTasks\types\%2_ca.paa' height='16'/> <font color='#80FF00'>%3</font> [<font color='#0080ff'><execute expression=""['%1','ASSIGNED'] remoteExec ['BIS_fnc_taskSetState',0];"">Assign</execute></font>] [<font color='#80FF00'><execute expression=""['%1','SUCCEEDED'] remoteExec ['BIS_fnc_taskSetState',0];"">Complete</execute></font>] [<font color='#CF142B'><execute expression=""['%1','FAILED'] remoteExec ['BIS_fnc_taskSetState',0];"">Fail</execute></font>] [<font color='#CCCCCC'><execute expression=""['%1','CANCELED'] remoteExec ['BIS_fnc_taskSetState',0];"">Cancel</execute></font>]<br/>%5%4<br/>",
			_x,
			_x call BIS_fnc_taskType,
			(_x call BIS_fnc_taskDescription)#1#0,
			(_x call BIS_fnc_taskDescription)#0#0,
			if (_parent != "") then { "       " } else {""},
			if (_parent == "") then { "<br/>" } else { "" } 
		];
		
		//_lastParent = _parent;
	} forEach _taskList;

	player createDiaryRecord ["ZeuAdmin", ["Tasks",_taskText]];
};

// MISSION-MAKER NOTES
// This section displays notes made by the mission-maker for the ADMIN

if (f_var_CustomNotes != "") then {
	_missionNotes = "<br/><font size='18' color='#80FF00'>MISSION-MAKER NOTES</font><br/>";
	_missionNotes = _missionNotes + f_var_CustomNotes + "<br/><br/>";
	
	player createDiaryRecord ["ZeuAdmin", ["Mission Notes",_missionNotes]];
};

// ADMIN BRIEFING
// This is a generic section displayed only to the ADMIN
_adminIntro ="<br/><font size='18' color='#80FF00'>ADMIN SECTION</font><br/><br/>This briefing section can only be seen by server administrators.<br/><br/>";

player createDiaryRecord ["ZeuAdmin", ["Admin Menu",_adminIntro]];