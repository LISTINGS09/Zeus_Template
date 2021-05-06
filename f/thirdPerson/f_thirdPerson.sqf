// No Third Person
// f_param_thirdPerson = 0;
// 0 = Disable, 1 = In Vehicles Only, 2 = Not Allowed (TvT)
if (!hasInterface || (difficultyOption "ThirdPersonView" == 0) || !isMultiplayer) exitWith {};

sleep 5;

// Default to off
if (missionNamespace getVariable["f_param_thirdPerson",0] == 0) exitWith {};

// 3rd in Vehicles Only
if (f_param_thirdPerson == 1) exitWith { 
	(FindDisplay 46) displayAddEventHandler ["keydown",{if (inputAction "personView" > 0 && vehicle player == player && lifeState player != "INCAPACITATED") then { player switchCamera "INTERNAL"; true }}];
};

// 3rd Disabled Everywhere
if (f_param_thirdPerson == 2) exitWith { 
	(FindDisplay 46) displayAddEventHandler ["keydown",{inputAction "tacticalView" > 0}];
	(FindDisplay 46) displayAddEventHandler ["keydown",{inputAction "personView" > 0}];
};