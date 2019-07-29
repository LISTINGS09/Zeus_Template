params [["_enable", TRUE,[TRUE]]];

if (_enable) then {
	["Initialize", [player, [], FALSE, TRUE, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE]] call BIS_fnc_EGSpectator; // Disable AI Spectating Until BIS fix performance.

	if (missionNamespace getVariable ["f_var_isAdmin",false]) then {
		[] spawn {
			sleep 5;
			systemChat "[ADMIN] Press TeamSwitch key at any time to force respawn and access the Admin Menu";
			(findDisplay 60492) displayAddEventHandler ["keydown", "if((_this select 1) In actionKeys ""TeamSwitch"") then {['Terminate'] call BIS_fnc_EGSpectator; setPlayerRespawnTime 5;};"];
		};
	};
	
	if ("task_force_radio" in activatedAddons) then { [player, TRUE] call TFAR_fnc_forceSpectator; };
	if ("acre_main" in activatedAddons) then { [TRUE] call acre_api_fnc_setSpectator; };
} else {
	["Terminate"] call BIS_fnc_EGSpectator;
	if ("task_force_radio" in activatedAddons) then { [player, false] call TFAR_fnc_forceSpectator; };
	if ("acre_main" in activatedAddons) then { [false] call acre_api_fnc_setSpectator; };
};