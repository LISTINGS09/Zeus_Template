// Dog Tag Respawn - v1.2 by 2600K
// Players must bring ACE Dog Tags back to any medical vehicle in order to respawn dead players.
// Set 'f_param_dogTagRespawn = true' in scritps.sqf to enable.

if (isNil "f_param_dogTagRespawn") then { f_param_dogTagRespawn = false };	// Should Dog Tag respawn be enabled? Disabled by default.

// Exit if you're not one of the chosen.
if (!f_param_dogTagRespawn || !(isClass(configFile >> "CfgPatches" >> "ace_main"))) exitWith {};

// Event Handler to set respawn position.
player addEventHandler [
	"Respawn", { 
		_targetPos = missionNamespace getVariable ["f_var_dogTagRespawnPos",[]];
		if (_targetPos isEqualType [] && count _targetPos > 0) then { player setPos (_targetPos findEmptyPosition [1,25]) };
	}
];

player createDiaryRecord ["Diary", ["Dog Tags", format["
	<br/><font size='18' color='#80FF00'>Dog Tag Recovery</font>
	<br/>Dog Tag respawn is active - Dog Tags can be collected from bodies and handed in at the nearest <font color='#00FFFF'>Medical Facility</font color>.<br/><br/>If no medical building or vehicle is nearby, you will be required to be less than <font color='#00FFFF'>150m</font color> from the <marker name='%1'>Starting Position</marker> to recover any Dog Tags.",
	[format["respawn_%1", side group player], "respawn_guerrila"] select (side group player == INDEPENDENT)]
]];

// Main function
zeu_dog_check = {
	params [["_unit", player]];
	
	if (isNull _unit) exitWith {};
	
	// Are we near a medical building/vehicle?
	private _inReviveArea = count (_unit nearObjects 25 select { ((_x getVariable ["ace_medical_isMedicalVehicle", false]) || (_x getVariable ["ace_medical_isMedicalFacility", false]) || (getNumber (configFile >> "CfgVehicles" >> typeOf _x >> "attendant")) > 0) && !(_x isKindOf "Man") }) > 0;

	// Check we're not at spawn, which allows up to 150m
	if !_inReviveArea then {
		private _respawnMkr = [format["respawn_%1", side group _unit], "respawn_guerrila"] select (side group _unit == INDEPENDENT);
		private _distance = if (getMarkerColor _respawnMkr != "") then { _unit distance2D getMarkerPos _respawnMkr } else { 999 };
		_inReviveArea = _distance < 150;
	};

	// We're not in the right place, so exit.
	if !_inReviveArea exitWith { TitleText ["<t size='1.5'>Error: No nearby medical facility!</t>", "PLAIN DOWN", 2, true, true] };

	// Ran on server only due to local ACE missionNamespace variables.
	[[_unit],{
		params ["_unit"];
		
		if (isNil "_unit") exitWith {};

		private _tagCount = 0;
		private _items = items _unit select { _x find "dogtag" > 0 };
		
		if (count _items == 0) exitWith { [["<t size='1.5'>Error: No tags in inventory!</t>","PLAIN DOWN", 2, true, true]] remoteExec ["TitleText", _unit] };
		
		// Find player from dog tag name from matching dog tag item index.
		{
			private _tagIndex = (missionNamespace getVariable ["ace_dogtags_alldogtags", []]) find _x;
			if (_tagIndex >= 0) then {
				private _foundPlayer = allPlayers select {!alive _x && (((missionNamespace getVariable "ace_dogtags_alldogtagdatas") select _tagIndex) select 0) == name _x};
				
				if (count _foundPlayer > 0) then {
					_target = _foundPlayer#0;
					f_var_dogTagRespawnPos = getPos _unit;
					(owner _target) publicVariableClient "f_var_dogTagRespawnPos";
					[5 + random 5] remoteExec ["setPlayerRespawnTime", _target]; 
					[_target] remoteExec ["hideBody", _target];
					
					[[format["<t size='2'>Your Dog Tag was recovered by %1</t>",name _unit],"PLAIN DOWN", 2, true, true]] remoteExec ["TitleText", _target];
					_tagCount = _tagCount + 1;
				};
			};
			
			_unit removeItem _x;
		} forEAch _items;
		
		[[format["<t size='1.5'>Tags Recovered: %1</t>", _tagCount],"PLAIN DOWN", 2, true, true]] remoteExec ["TitleText", _unit];
	}] remoteExec ["BIS_fnc_spawn", 2]; 
};

// Create the action for the player to initiate spawning players.
zeu_dog_action = ['ZEUDOG',"Hand in Dog Tags",'\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\help_ca.paa',{[player] spawn zeu_dog_check},{true}] call ace_interact_menu_fnc_createAction;

// Add the client action
if !hasInterface exitWith {};
[player, 1, ["ACE_SelfActions","ACE_Equipment","ZEUDOG"]] call ace_interact_menu_fnc_removeActionFromObject;
[player, 1, ["ACE_SelfActions","ACE_Equipment"], zeu_dog_action] call ace_interact_menu_fnc_addActionToObject;