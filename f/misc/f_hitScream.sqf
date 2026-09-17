/*
	Author: 2600K / whoever made EF
	v0.2
	Description:
	AI Screaming - Dead units will scream according o their speaker type.
*/
if !isServer exitWith {};

// DISABLE FOR SOG - Already Implemented!
if (isClass (configFile >> "CfgPatches" >> "data_f_vietnam")) exitWith {};

if (isNil "ZSC_ScreamChance") then { ZSC_ScreamChance = 0.65; };
if !(isNil "ZSC_fnc_playHitScream") exitWith {};
											
ZSC_fnc_playHitScream = {
	params ["_victim"];

	private _speaker = speaker _victim;
	if (_speaker == "NoVoice") exitWith {};
	if (getText (configOf _victim >> "simulation") != "soldier") exitWith {};
	if (random 1 > ZSC_ScreamChance) exitWith {};
	if (alive _victim) exitWith {};
	if (isPlayer _victim) exitWith {};

	private _play = {
		playSound3D [
			selectRandom _this,
			objNull,
			insideBuilding _victim > 0.5,
			eyePos _victim,
			2.5,
			random [0.8,1,1.2],
			150
		];
	};
	
	private _directory = getArray (configFile >> "CfgVoice" >> _speaker >> "directories");
	if (count _directory == 0) then {
		private _rn = selectRandom [1, 2, 3];
		_speaker = switch (side group _victim) do {
			case WEST: { format["MALE0%1ENG", _rn] };
			case EAST: { format["MALE0%1RUS", _rn] };
			default { format["MALE0%1GRE", _rn] };
		};
		
		_directory = getArray (configFile >> "CfgVoice" >> _speaker >> "directories");
	};
	
	if (count _directory == 0) exitWith {};
	_directory = (_directory#0) splitString "\" joinString "\";

	private _screams = getArray (configFile >> getText (configFile >> "CfgVoice" >> _speaker >> "protocol") >> "Words" >> "ScreamingE");
	_screams = _screams select {fileExists format ["%1\%2",_directory,_x splitString "\" joinString "\"]}; // same trick

	// if it can't find the scream in the first iteration, try another directories
	if (count _screams == 0) then {
		{
			_screams = (getArray (_x >> "screamingE")) apply {_x splitString "\" joinString "\"};
			_screams = _screams select {fileExists format ["%1\%2",_directory,_x splitString "\" joinString "\"]};
			if (count _screams != 0) exitWith {};
		} forEach ("true" configClasses (configFile >> getText (configFile >> "CfgVoice" >> _speaker >> "protocol") >> "Words"));
	};

	if (count _screams == 0) exitWith {};
	(_screams apply {format ["%1\%2",_directory,_x splitString "\" joinString "\"]}) call _play;
};

{
    if (
        !isPlayer _x &&
        local _x &&
        {_x isKindOf "Man"}
    ) then {

        if !(_x getVariable ["TAG_hitScreamEH_added", false]) then {

            _x setVariable ["TAG_hitScreamEH_added", true];

            _x addEventHandler ["Killed", {
                params ["_unit"];
                [_unit] call ZSC_fnc_playHitScream;
            }];
        };
    };
} forEach allUnits;

addMissionEventHandler ["EntityCreated", {
    params ["_entity"];

    if (isPlayer _entity || !local _entity || !(_entity isKindOf "Man")) exitWith {};

    if (_entity getVariable ["TAG_hitScreamEH_added", false]) exitWith {};

    _entity setVariable ["TAG_hitScreamEH_added", true];
	
	_entity addEventHandler ["Killed", {
		params ["_unit"];
		[_unit] call ZSC_fnc_playHitScream;
	}];
}];