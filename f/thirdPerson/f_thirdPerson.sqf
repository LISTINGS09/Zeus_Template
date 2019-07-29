// ----------------------------------------------------------------------------
// 				NO 3RD PERSON - {God-Father} @ 1PARA Community
// ----------------------------------------------------------------------------
// 0 = Disable, 1 = In Vehicles Only, 2 = Not Allowed (TvT)
if (!hasInterface || (difficultyOption "ThirdPersonView" == 0) || !isMultiplayer) exitWith {};

sleep 5;

// Default to off
if (missionNamespace getVariable["f_param_thirdPerson",0] == 0) exitWith {};

// 3rd in Vehicles Only
if (f_param_thirdPerson == 1) exitWith { 
	addMissionEventHandler ["eachFrame", { if (cameraView == "External" && lifeState player != "INCAPACITATED") then { if ((vehicle player) == player) then {  player switchCamera "Internal"; }; }; }]; 
};

// 3rd Disabled Everywhere
if (f_param_thirdPerson == 2) exitWith { 
	(FindDisplay 46) displayAddEventHandler ["keydown",{(_this select 1) in (actionKeys "TacticalView")}];
	addMissionEventHandler ["eachFrame", { if (cameraView == "External") then { if ((vehicle player) == cameraOn) then { (vehicle player) switchCamera "Internal"; }; }; }]; 
};