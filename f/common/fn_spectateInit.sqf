params [["_enable", true,[true]]];

if (_enable) then {
	if (toUpper (getText ((getMissionConfig "Header") >> "gameType")) == "COOP") then {
		["Initialize", [player, [], false, true, true, true, true, false, true, true]] call BIS_fnc_EGSpectator; // Disable AI Spectating Until BIS fix performance.
	} else {
		["Initialize", [player, [side group player], false, false, false, true, true, false, true, true]] call BIS_fnc_EGSpectator; // Disable 3P and other side spectating.
	};

	if (missionNamespace getVariable ["f_var_isAdmin",false]) then {
		[] spawn {
			sleep 5;
			systemChat "[ADMIN] Press TeamSwitch key at any time to force respawn and access the Admin Menu";
			(findDisplay 60492) displayAddEventHandler ["keydown", "if((_this select 1) In actionKeys ""TeamSwitch"") then {['Terminate'] call BIS_fnc_EGSpectator; setPlayerRespawnTime 5;};"];
		};
	};
	
	if ("task_force_radio" in activatedAddons) then { [player, true] call TFAR_fnc_forceSpectator; };
	if ("acre_main" in activatedAddons) then { [true] call acre_api_fnc_setSpectator; };
} else {
	["Terminate"] call BIS_fnc_EGSpectator;
	if ("task_force_radio" in activatedAddons) then { [player, false] call TFAR_fnc_forceSpectator; };
	if ("acre_main" in activatedAddons) then { [false] call acre_api_fnc_setSpectator; };
};