// F3 - Folk Group Markers
// f_param_groupMarkers = -1;
// 0 = Disable | 1 = On Map | 2 = On Map + Screen | 3 = Map + Squad Stats (Non-ACE Default) | 4 = Commander Map Only (ACE Default) | 5 = Commander Map + Squad Stats
if (!hasInterface || playerSide == sideLogic) exitWith {};

waitUntil{!isNil "f_var_setGroupsIDs"};

if (missionNamespace getVariable["f_param_groupMarkers", -1] == 0) exitWith {}; // If 0 do nothing.

// If -1 automatically pick the correct value (see top)
if (missionNamespace getVariable["f_param_groupMarkers", -1] < 0) then { f_param_groupMarkers = [3, 1] select isClass(configFile >> "CfgPatches" >> "ace_main") };

f_fnc_localGroupMarker = compileFinal preprocessFileLineNumbers "f\groupMarkers\fn_localGroupMarker.sqf";

// If Commander-Only markers are selected, exit here
if ((rank player) in ["PRIVATE", "CORPORAL", "SERGEANT"] && f_param_groupMarkers in [4,5]) exitWith {};

// Process list
{ _x spawn f_fnc_localGroupMarker } forEach (missionNamespace getVariable [format["f_var_groups%1",side group player],[]]);

// Set icons to show in-game also if chosen
if (f_param_groupMarkers == 2) then { 
	setGroupIconsVisible [TRUE,TRUE]; 
} else {
	setGroupIconsVisible [TRUE,FALSE];
};

setGroupIconsSelectable true;

// Wait until in mission
sleep 0.5;

// Used to display fire-team colours.
f_fnc_getIconColor = {
	if (_this select 0 == "RED") exitWith {"FF4646"};
	if (_this select 0 == "GREEN") exitWith {"46FF46"};
	if (_this select 0 == "BLUE") exitWith {"4646FF"};
	if (_this select 0 == "YELLOW") exitWith {"FFFF46"};
	"FFFFFF"
};

if (!isNil "F_EH_GroupEnter") then { removeMissionEventHandler ["GroupIconOverEnter", F_EH_GroupEnter] };
if (!isNil "F_EH_GroupLeave") then { removeMissionEventHandler ["GroupIconOverEnter", F_EH_GroupLeave] };

F_EH_GroupEnter = addMissionEventHandler ["GroupIconOverEnter", {
	params [
		"_is3D", "_group", "_waypointId",
		"_posX", "_posY",
		"_shift", "_control", "_alt"
	];
	
	if ((missionNamespace getVariable ["f_param_groupMarkers",0]) in [1,2,4]) exitWith {};
		
	_iconParams = getGroupIconParams _group;	
		
	_group setGroupIconParams [_iconParams#0, groupId _group, _iconParams#2, true]; 
	
	_text = format["<br/><t size='1.25' font='TahomaB' color='#72E500'>%1 Group</t>",groupId _group];
	_text = _text + format["<br/><t color='#888888'>%1</t><br/>", if (vehicle leader _group != leader _group) then { getText (configFile >> "CfgVehicles" >> (typeOf vehicle leader _group) >> "displayName")} else { "" }];

	_text = _text + "<t align='left'>";
	{	
		_unitIco = (getText (configFile >> "CfgVehicles" >> (typeOf _x) >> "icon") call bis_fnc_textureVehicleIcon);
		_unitType = getText (configFile >> "CfgVehicles" >> (typeOf _x) >> "displayName");
		_unitCol1 = [assignedTeam _x] call f_fnc_getIconColor;
		_unitCol2 = "FFFFFF";
		_unitCol3 = "888888";
		
		if (missionNamespace getVariable ["f_var_ShowInjured",false]) then {
			if ((_x getVariable["ACE_isUnconscious",false]) || lifeState _x == "INCAPACITATED") then {
				_unitIco = ["\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_forceRespawn_ca.paa", "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_revive_ca.paa"] select (_x getVariable ["FAR_var_isStable", false]);
				_unitCol1 = ["990000","FF0080"] select (_x getVariable ["FAR_var_isStable",false]);
				_unitCol2 = _unitCol1;
				_unitCol3 = ["880000","B3005A"] select (_x getVariable ["FAR_var_isStable",false]);
			};
			
			if (!alive _x) then {
				_unitIco = "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_forceRespawn_ca.paa";
				_unitCol1 = "777777";
				_unitCol2 = _unitCol1;
				_unitCol3 = "999999";
			};
		};
		
		_text = _text + format["<br/><t color='#%1'><img image='%2'/></t> <t color='#%3'>%4</t> <t color='#%5'>(%6)</t>", _unitCol1, _unitIco, _unitCol2, name _x, _unitCol3, _unitType];
				
		if (leader _group == _x) then {
			_text = _text + " (<t color='#72E500'>Lead</t>)";
		};
	} forEach (units _group);
	
	_text = _text + "</t><br/><br/>";
	
	if (missionNamespace getVariable ["f_var_ShowScore", false]) then {	
		// Add group score, casualties and sdr
		_pts = 0;

		units _group apply { _pts = _pts + score _x };
		_cas = _group getVariable ["f_var_casualtyCount", 0];

		_text = _text + format["Score: <t color='#46FF46'>%1</t><br/>Casualties: <t color='#FF0000'>%2</t><br/>Ratio: <t color='#FFFF46'>%3</t><br/><br/>",
			_pts,
			_cas,
			if (_cas > 0) then { (_pts / _cas) toFixed 1 } else { _pts }
		];
	};
	
	hintSilent parseText _text;
}];

F_EH_GroupLeave = addMissionEventHandler ["GroupIconOverLeave", {
	params [
		"_is3D", "_group", "_waypointId",
		"_posX", "_posY",
		"_shift", "_control", "_alt"
	];
	
	_iconParams = getGroupIconParams _group;	
	
	_grpInfo = (missionNamespace getVariable [format["f_var_groups%1",side group player],[]]) select { _x#1 == groupId _group };

	_group setGroupIconParams [_iconParams#0, if (count _grpInfo > 0) then { _grpInfo#0#3 } else { groupId _group }, _iconParams#2, TRUE]; 
	hintSilent "";
}];