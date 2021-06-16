FAR_fnc_unitInit = {
	params [["_unit", player]];
	
	if (!isNil "FAR_EHID_HandleDeath") then { _unit removeEventHandler ["Killed", FAR_EHID_HandleDeath] };
	FAR_EHID_HandleDeath = _unit addEventHandler ["Killed", FAR_fnc_HandleDeath]; // Used in instant death
	
	_unit setVariable ["FAR_var_isDragged", false, true];
	_unit setVariable ["FAR_var_isDragging", false, true];
	_unit setVariable ["FAR_var_isStable", false, true];
	_unit setVariable ["FAR_var_markerName", profileName, true];
	if (getMarkerType format["FAR_MKR_%1", profileName] != "") then { deleteMarker format["FAR_MKR_%1", profileName] };
	FAR_var_timer = FAR_var_BleedOut;
	
	if !(isPlayer _unit) exitWith {};
	
	if (!isNil "FAR_EHID_Respawn") then { _unit removeEventHandler ["Respawn", FAR_EHID_Respawn] };
	FAR_EHID_Respawn = _unit addEventHandler ["Respawn", { [] spawn FAR_fnc_unitInit; if (captive player) then { player setCaptive false }; if (FAR_var_SpawnInMedical) then { [] spawn FAR_fnc_TeleportNearestVehicle }; }];
	
	[_unit] spawn FAR_fnc_PlayerActions;
};

FAR_fnc_unitRemove = {
	params [["_unit", player]];
	
	// Remove Actions
	{
		if ((missionNamespace getVariable [_x,""]) isEqualType 0) then { _unit removeAction (missionNamespace getVariable _x) } 
	} forEach ["FAR_act_Revive", "FAR_act_Bag", "FAR_act_Stabilise", "FAR_act_Dragging", "FAR_act_Carry", "FAR_act_Release", "FAR_act_UnitLoad", "FAR_act_UnitUnload"];
	
	// Remove Effects
	{ _x ppEffectEnable false } forEach [FAR_eff_ppVig, FAR_eff_ppBlur];
	
	if !(isNil "FAR_EHID_HandleDamage") then { _unit removeEventHandler ["Killed", FAR_EHID_HandleDamage] };
	if !(isNil "FAR_EHID_HandleDeath") then { _unit removeEventHandler ["Killed", FAR_EHID_HandleDeath] };
	if !(isNil "FAR_EHID_Respawn") then { _unit removeEventHandler ["Respawn", FAR_EHID_Respawn] };
	
	if isMultiplayer exitWith {};
	
	removeMissionEventHandler ["TeamSwitch", FAR_EHID_TeamSwitch];

	{
		_x removeAllEventHandlers "Killed";
		_x removeAllEventHandlers "Respawn";
		_x removeAllEventHandlers "HandleDamage";
	} forEach (switchableUnits - [_unit]);
};

FAR_fnc_PlayerActions = {
	params ["_unit", "_newUnit"];
	
	// SP Team Switch Fix
	if (!isNil "_newUnit") then {
		{
			if ((missionNamespace getVariable [_x,""]) isEqualType 0) then { _unit removeAction (missionNamespace getVariable _x) } 
		} forEach ["FAR_act_Revive", "FAR_act_Bag", "FAR_act_Stabilise", "FAR_act_Dragging", "FAR_act_Carry", "FAR_act_Release", "FAR_act_UnitLoad", "FAR_act_UnitUnload"];
		
		{ _x ppEffectEnable false } forEach [FAR_eff_ppVig, FAR_eff_ppBlur];
		
		_unit = _newUnit; 
	}; 
	
	if (alive _unit && _unit isKindOf "CAManBase") then {	
		// Revive
		if (!isNil "FAR_act_Revive") then { _unit removeAction FAR_act_Revive };
		FAR_act_Revive = _unit addAction ["Revive", FAR_fnc_Revive,[], 11, true, true, "", "call FAR_fnc_CheckRevive && {(cursorTarget distance _target) <= 3}"];
				
		// Bagging
		if (!isNil "FAR_act_Bag") then { _unit removeAction FAR_act_Bag };		
		FAR_act_Bag = _unit addAction ["Bag Body", FAR_fnc_Bag, [], 8, false, true, "", "(call FAR_fnc_CheckBag) && {(cursorObject distance _target) <= 2.5}"];
		
		// If everyone can revive so skip extended actions.
		if (FAR_var_ReviveMode != 1) then {
			// Stabilising
			if (!isNil "FAR_act_Stabilise") then { _unit removeAction FAR_act_Stabilise };
			FAR_act_Stabilise = _unit addAction ["Stabilize", FAR_fnc_Stabilize, [], 10, true, true, "", "(call FAR_fnc_CheckStabilize) && {(cursorTarget distance _target) <= 3}"];
			
			// Dragging
			if (!isNil "FAR_act_Dragging") then { _unit removeAction FAR_act_Dragging };
			FAR_act_Dragging = _unit addAction ["Drag", FAR_fnc_UnitMove, ["drag"], 9, false, true, "", "(call FAR_fnc_CheckDragging) && {(cursorTarget distance _target) <= 2.5}"];
		
			// Carrying
			if (!isNil "FAR_act_Carry") then { _unit removeAction FAR_act_Carry };
			FAR_act_Carry = _unit addAction ["Carry", FAR_fnc_UnitMove, ["carry"], 8, false, true, "", "(call FAR_fnc_CheckUnitCarry) && {(cursorTarget distance _target) <= 2.5}"];
			
			// Loading
			if (!isNil "FAR_act_UnitLoad") then { _unit removeAction FAR_act_UnitLoad };
			FAR_act_UnitLoad = _unit addAction ["Load", FAR_fnc_UnitLoad, [], 10, false, true, "", "(call FAR_fnc_CheckUnitLoad)"];
		};
	};
};

FAR_fnc_RagDoll = {
	params[["_unit", player]];
	
	if ((eyePos _unit)#2 <= 0.4 || isPlayer _unit || vehicle _unit != _unit) exitWith { _unit setUnconscious true  };
	
	[_unit, [missionNamespace, "f_var_savedGear"]] call BIS_fnc_saveInventory;
	
	private _tempMan = (createGroup [side group _unit, true]) createUnit ["C_man_1", [0,0,0], [], 0, "NONE"];
	
	_unit hideObjectGlobal true;
	
	if (!isNull _tempMan) then {
		[_tempMan, [missionNamespace, "f_var_savedGear"]] call BIS_fnc_loadInventory;
		[_tempMan, animationState _unit] remoteExec ["switchMove"];
		_tempMan setposASL getPosASL _unit;
		_tempMan setDir getDir _unit;
		_tempMan setVelocity velocity _unit;
		_tempMan setUnconscious true;
		
		_unit setUnconscious true;
		[_unit, "UnconsciousReviveDefault"] remoteExec ["switchMove"];
		
		if (_unit isEqualTo player) then { _tempMan switchCamera cameraView };
		
		for "_i" from 1 to 50 do {
			if (((_tempMan selectionPosition "Neck")#2) < 0.2) exitWith {};
			sleep 0.1;
		};
		
		uiSleep 4;
		
		_unit setVelocity [0,0,0];
		_unit setposASL getPosASL _tempMan;
		_unit setDir getDir _tempMan;
		_unit hideObjectGlobal false;
		
		if (_unit isEqualTo player) then { player switchCamera cameraView };
		
		_tempMan setPos [0,0,0];
		deleteVehicle _tempMan;
	};
};

FAR_fnc_DeathMessage = {
	params ["_killed", ["_killer", objNull], ["_type", "killed"]];
	
	// Are DMs enabled?
	if (isNull _killer || !(missionNamespace getVariable ["FAR_var_DeathMessages",false])) exitWith {};
	
	// Death message
	if (_killer != _killed) then {	
		
		// Never announce enemy or Zeus kills.
		if (
			!([side (group _killed), side (group _killer)] call BIS_fnc_sideIsEnemy) && 
			!([getAssignedCuratorLogic _killer] call BIS_fnc_isCurator) &&
			((isPlayer _killed && isPlayer _killer) || !isMultiPlayer)
		) then {
			if (vehicle _killer != _killer) then {
				format["<TeamKill> %1 was %4 by %2 (%3)", name _killed, name _killer, getText(configFile >> "CfgVehicles" >> typeOf vehicle _killer >> "displayName"), _type] remoteExecCall ["systemChat"];
			} else {
				format["<TeamKill> %1 was %3 by %2", name _killed, name _killer, _type] remoteExecCall ["systemChat"];
			};
		};
	};
};

FAR_fnc_FixRagdoll = {
	private _view = cameraView;
	private _oldMan = player;
	
	if (vehicle _oldMan != _oldMan) exitWith { systemChat "[REVIVE] Error - Cannot fix while in vehicle!" };
	if (lifeState _oldMan != "HEALTHY") exitWith { systemChat "[REVIVE] Error - Cannot fix while injured!" };
	
	private _newMan = (group _oldMan) createUnit [typeOf _oldMan, [0,0,0], [], 0, "NONE"];
	
	if (!isNull _newMan) then {
		_newMan setDir getDir _oldMan;
				
		{ _x params ["_varId","_varVal"]; _newMan setVariable [_varId, _varVal] } forEach (allVariables _oldMan);
		
		_newMan assignTeam (assignedTeam _oldMan);
		
		[_oldMan, [missionNamespace, "f_var_savedGear"]] call BIS_fnc_saveInventory;
		[_newMan, [missionNamespace, "f_var_savedGear"]] call BIS_fnc_loadInventory;

		{ 
			if !(((getObjectTextures _newMan) select _forEachIndex) isEqualTo _x) then { _newMan setObjectTextureGlobal [_forEachIndex, _x] };
		} forEach (getObjectTextures _oldMan);
				
		_oldMan hideObjectGlobal true;
		_newMan setposASL getPosASL _oldMan;
		
		selectPlayer _newMan;

		waitUntil { _newMan == player };
		
		_newMan switchCamera _view;

		[_newMan, animationState _oldMan] remoteExec ["switchMove"];
		[_newMan, name _oldMan] remoteExec ["setName"];	
		
		if (leader _oldMan == _oldMan) then { group _newMan selectLeader _newMan };

		_oldMan setDamage 1;
		
		deleteVehicle _oldMan;
		
		f_sqf_brief = execVM "f\briefing\briefing.sqf";
		[player] spawn FAR_fnc_unitInit;
		_oldMan removeEventHandler ["HandleDamage", FAR_EHID_HandleDamage];
		FAR_EHID_HandleDamage = player addEventHandler ["HandleDamage", FAR_fnc_HandleDamage]; 
				
		systemChat format["[REVIVE] Ragdoll - Migrated %1 to a new unit", name player];
	};
};

FAR_fnc_HandleDamage = {
	params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];

	if (alive _unit && 
		_damage >= 1 && 
		!(lifeState _unit == "INCAPACITATED") && 
		_selection in ["","head","face_hub","neck","spine1","spine2","spine3","pelvis","body"]
	) then {
		// systemChat format["U: %1  S: %2  D: %3  K1: %4  P: %5  I: %6  K2: %7  H: %8", _unit, _selection, _damage, _source, _projectile, _hitIndex, _instigator, _hitPoint];
		// If not instant death check allowed values, otherwise just make them unconscious
		if ((random 100 < FAR_var_DeathChance  && (_damage < FAR_var_DeathDmgHead && _selection in ["head", "face_hub"] || _damage < FAR_var_DeathDmgBody && _selection == "")) || { !FAR_var_InstantDeath }) then {
			_unit allowDamage false;
			[_unit, if (isNull _instigator) then { _source } else { _instigator }] spawn FAR_fnc_SetUnconscious;
			0
		};
	};
};

FAR_fnc_HandleDeath = {
	params ["_unit", "_killer", "_instigator"];
	
	_target = if (_instigator == objNull) then { _killer } else { _instigator };
	
	// Player EH won't fire for AI so increase casualty counter.
	if !(isPlayer _unit) then {
		_unit spawn {
			if (time < 30) exitWith {};
	
			sleep random 5;
			
			[group _this] remoteExecCall ["f_fnc_updateCas", 2];
		};
	};
	
	if (isPlayer _target) then { [_unit, _target] spawn FAR_fnc_DeathMessage };
};

FAR_fnc_SetUnconscious = {
	params ["_unit", ["_killer", objNull]];
		
	_rand = (floor random 18) + 1;
	playSound3D [format["A3\sounds_f\characters\human-sfx\P%1\Hit_Max_%2.wss", format["0%1",_rand] select [(count format["0%1",_rand]) - 2,2], ceil random 5], _unit, false, getPosASL _unit, 1.5, 1, 50];
	
	_unit setCaptive true;
	_unit setDamage 0.35;
	
	if (missionNamespace getVariable ["FAR_var_safeRagDoll", false]) then { 
		[_unit] call FAR_fnc_RagDoll;
	} else {
		_unit setUnconscious true;
		uiSleep 6;
	};
		
	// Allow the downed unit to be damaged?
	if (FAR_var_InstantDeath) then { _unit allowDamage true } else { _unit allowDamage false };
	
	// Eject unit if inside vehicle and is destroyed
	if (vehicle _unit != _unit && !alive vehicle _unit) then {
		moveOut _unit;
		_unit action ["getOut", vehicle _unit];
		uiSleep 0.5;
	} else {
		[_unit, "UnconsciousReviveDefault"] remoteExecCall ["switchMove"];
	};
	
	// If the unit was killed (instant death) exit.
	if (!alive _unit) exitWith {};
	
	if (FAR_var_AICanHeal && !isMultiPlayer) then { [_unit] spawn FAR_fnc_AIHeal };
	
	// Casualty Count Update.
	_unit spawn {
		if (time < 30) exitWith {};
	
		sleep random 5;
			
		[group _this] remoteExecCall ["f_fnc_updateCas", 2];
	};
	
	// Apply visual effects.
	if (isPlayer _unit) then {
		disableUserInput true;
		titleText ["", "BLACK FADED"];
		disableUserInput false;
		disableUserInput true;
		disableUserInput false;
		
		FAR_eff_ppVig ppEffectAdjust [1,1,0,[0.15,0,0,1],[1.0,0.5,0.5,1],[0.587,0.199,0.114,0],[1,1,0,0,0,0.2,1]];
		FAR_eff_ppBlur ppEffectAdjust [0];
		
		{
			_x ppEffectCommit 0;
			_x ppEffectEnable true;
			_x ppEffectForceInNVG true;
		} forEach [FAR_eff_ppVig, FAR_eff_ppBlur];
		
		[100] call BIS_fnc_bloodEffect;
	};
	
	// Announce Message.
	[_unit, _killer, ["killed", "injured"] select FAR_var_InstantDeath] spawn FAR_fnc_DeathMessage;
	
	if !([_unit] call FAR_fnc_isUnderwater) then {
		private _bPool = createSimpleObject [selectRandom ["BloodSpray_01_New_F","BloodSplatter_01_Medium_New_F"], getPosWorld _unit]; 
		_bPool setDir random 360; 
		_bPool setVectorUp surfaceNormal getPosWorld _unit;
	};
    
	if (isPlayer _unit) then {
		titleText ["", "BLACK IN", 1];
		
		if (FAR_var_BleedOut > 600) then {
			["Initialize", [_unit, [playerSide], false, false]] call BIS_fnc_EGSpectator;
		};
	};
		
	_bleedOut = time + FAR_var_timer;
	
	// Deduct 1m from bleed-out timer.
	if (FAR_var_timer > 60) then {
		if (FAR_var_timer <= 600) then { FAR_var_timer = FAR_var_timer - 60 };
		// Do nothing if we're over 600 (fixed respawn values)
	} else {
		FAR_var_timer = 60;
	};
	
	private _tick = 0;
	
	while { alive _unit && 
			(lifeState _unit == "INCAPACITATED") &&
			!(_unit getVariable ["FAR_var_isStable",false]) && 
			(FAR_var_timer < 0 || time < _bleedOut) 
	} do {
		if (isPlayer _unit) then  {
			if (FAR_var_timer > 600) then {
				hintSilent format["Waiting for a medic\n\n%1", call FAR_fnc_CheckFriendlies];
			} else { 
				hintSilent format["Bleedout in %1 seconds\n\n%2", round (_bleedOut - time), call FAR_fnc_CheckFriendlies];
			};
		};
			
		// Bleeding and sounds
		if (_tick % ((round random 5) + 5) == 0) then { if (isPlayer _unit) then { [100] call BIS_fnc_bloodEffect}; };
		if (_tick % ((round random 15) + 15) == 0) then {  
			_scream = selectRandom [
				["Person0", ["P0_moan_13_words.wss", "P0_moan_14_words.wss", "P0_moan_15_words.wss", "P0_moan_16_words.wss", "P0_moan_17_words.wss", "P0_moan_18_words.wss", "P0_moan_19_words.wss", "P0_moan_20_words.wss"]],
				["Person1", ["P1_moan_19_words.wss", "P1_moan_20_words.wss", "P1_moan_21_words.wss", "P1_moan_22_words.wss","P1_moan_23_words.wss", "P1_moan_24_words.wss", "P1_moan_25_words.wss", "P1_moan_26_words.wss","P1_moan_27_words.wss", "P1_moan_28_words.wss", "P1_moan_29_words.wss", "P1_moan_30_words.wss","P1_moan_31_words.wss", "P1_moan_32_words.wss", "P1_moan_33_words.wss"]],
				["Person2", ["P2_moan_14_words.wss", "P2_moan_15_words.wss", "P2_moan_16_words.wss", "P2_moan_17_words.wss","P2_moan_18_words.wss", "P2_moan_19_words.wss", "P2_moan_20_words.wss", "P2_moan_21_words.wss"]],
				["Person3", ["P3_moan_10_words.wss", "P3_moan_11_words.wss", "P3_moan_12_words.wss", "P3_moan_13_words.wss","P3_moan_14_words.wss", "P3_moan_15_words.wss", "P3_moan_16_words.wss", "P3_moan_17_words.wss","P3_moan_18_words.wss", "P3_moan_19_words.wss", "P3_moan_20_words.wss"]]
			];
			
			playSound3D [format["a3\sounds_f\characters\human-sfx\%1\%2", _scream select 0, selectRandom (_scream select 1)], _unit, false, getPosASL _unit, 1.5, 1, 50];	
		};
		
		// Handle stuck dragging player D/C
		if ((_unit getVariable ["FAR_var_isDragged", false]) &&
			!isNull (attachedTo _unit) &&
			!alive (attachedTo _unit)
		) then {
			detach _unit;
			[_unit, "UnconsciousReviveDefault"] remoteExecCall ["switchMove"];
			_unit setVariable ["FAR_var_isDragged", false, true];
		};
		
		// Check unit is in correct animation.
		if (objectParent _unit isEqualTo _unit && 
			(animationState _unit) select [0,3] != "unc" && 
			(animationState _unit) != "amovppnemstpsnonwnondnon_amovppnemstpsraswrfldnon" &&
			!(_unit getVariable ["FAR_var_isDragged", false]) &&
			isNull (attachedTo _unit)
		) then {
			systemChat format["[ERROR] animationState incorrect!", animationState _unit];
			diag_log text format["[ERROR] animationState was incorrect: %1", animationState _unit];
			[_unit, "UnconsciousReviveDefault"] remoteExecCall ["switchMove"];
		};
		
		_tick = _tick + 0.5;
		uiSleep 0.5;
	};
	
	//Unit has been stabilized. Disregard bleedout timer.
	if (_unit getVariable ["FAR_var_isStable",false]) then {
		while { 
			alive _unit && lifeState _unit == "INCAPACITATED"
		} do {
			if (isPlayer _unit) then  {		
				hintSilent format["You have been stabilized\n\n%1", call FAR_fnc_CheckFriendlies];	
			};
			// Handle stuck dragging player D/C
			if ((_unit getVariable ["FAR_var_isDragged", false]) &&
				!isNull (attachedTo _unit) &&
				!alive (attachedTo _unit)
			) then { 
				detach _unit;
				[_unit, "UnconsciousReviveDefault"] remoteExecCall ["switchMove"];
				_unit setVariable ["FAR_var_isDragged", false, true];
			};
			
			uiSleep 0.5;
		};
	};
	
	// Disable effects if set.
	{ _x ppEffectEnable false } forEach [FAR_eff_ppVig, FAR_eff_ppBlur];
	
	// Bled out
	if (FAR_var_timer > 0 && 
			{time > _bleedOut} && 
			(lifeState _unit == "INCAPACITATED") &&
			!(_unit getVariable ["FAR_var_isStable",false])
	) then {
		// Kill player, stop the camera.
		["Terminate"] call BIS_fnc_EGSpectator;
		
		if (FAR_var_RespawnBagTime > 0) then {
			[[format["FAR_MKR_%1", profileName], [0,0,0]]] remoteExecCall ["createMarkerLocal", side group _unit];
			[format["FAR_MKR_%1", profileName], position _unit] remoteExecCall ["setMarkerPosLocal", side group _unit];
			[format["FAR_MKR_%1", profileName], "KIA"] remoteExecCall ["setMarkerTypeLocal", side group _unit];
			[format["FAR_MKR_%1", profileName], "ColorYellow"] remoteExecCall ["setMarkerColorLocal", side group _unit];
			[format["FAR_MKR_%1", profileName], [0.3,0.3]] remoteExecCall ["setMarkerSizeLocal", side group _unit];
		};
		
		_unit setCaptive false;
		_unit allowDamage true;
		_unit setDamage 1;
	} else {	
		// Player got revived		
		["Terminate"] call BIS_fnc_EGSpectator;
		uiSleep 3;
		
		// Clear the "medic nearby" hint
		hintSilent "";
		_unit setDamage 0;
		_unit allowDamage true;
		_unit setCaptive false;
		_unit setUnconscious false;
		_unit playAction "Stop";
		
		if ({ currentWeapon _unit == _x } count ["", binocular _unit] > 0) then { 
			_unit playAction "Civil"
		} else {
			_unit action ["SwitchWeapon", _unit, _unit, 0]
		};
	};
	
	// Reset variables
	_unit setVariable ["FAR_var_isStable", false, true];
	_unit setVariable ["FAR_var_isDragged", false, true];
};

FAR_fnc_ReviveUnit = {
	params[["_unit", player]];
	
	//if (!isPlayer _unit) exitWith { _unit setUnconscious false };
		
	private _view = cameraView;
	private _oldMan = _unit;
	private _newMan = (group _oldMan) createUnit [typeOf _oldMan, [0,0,0], [], 0, "NONE"];
	
	_newMan disableAI "ALL";
		
	_newMan setUnconscious true;
	_newMan switchMove "UnconsciousReviveDefault";
	_newMan setDir getDir _oldMan;
	
	// Migrate Info
	{ _x params ["_varId", "_varVal"]; if (!isNil "_varVal") then { _newMan setVariable [_varId, _varVal] } } forEach (allVariables _oldMan);  // Variables
	{ _newMan setUnitTrait [_x#0, _x#1] } forEach (getAllUnitTraits _oldMan);  // Traits
	_newMan assignTeam (assignedTeam _oldMan); // Team Colour
		
	_oldMan hideObjectGlobal true;
	_newMan setposASL getPosASL _oldMan;
	
	[_oldMan, [missionNamespace, "f_var_savedGear"]] call BIS_fnc_saveInventory; // Gear
		
	selectPlayer _newMan;

	waitUntil { _newMan == player };
	
	[_newMan, [missionNamespace, "f_var_savedGear"]] call BIS_fnc_loadInventory; // Gear
		
	_newMan switchCamera _view;
	_newMan setUnconscious false;
	[_newMan, name _oldMan] remoteExec ["setName"];	
		
	if (leader _oldMan == _oldMan) then { group _newMan selectLeader _newMan };
	
	deleteVehicle _oldMan;
		
	_newMan setCaptive false;
	_newMan setUnconscious false;
	
	[] call FAR_fnc_unitInit;
	
	[_unit, "AmovPpneMstpSnonWnonDnon"] remoteExec ["switchMove"];

	if (currentWeapon _unit == secondaryWeapon _unit && {currentWeapon _unit != ""}) then {
		[_unit, "AmovPknlMstpSrasWlnrDnon"] remoteExec ["switchMove"];
	};
};

FAR_fnc_CheckRevive = {
	private _caller = _originalTarget;
	private _cursorTarget = cursorTarget; // Can't be passed in addAction arguments!

	if (isNull _cursorTarget) exitWith { false };
	
	// Variable for CASVAC Missions etc...
	if !(_cursorTarget getVariable ["FAR_var_AllowRevive", true]) exitWith {};
	
	// format["REVIVE: %1 | %2 | %3 | %4 | %5", !(player getVariable ["FAR_var_isDragging", false]), cursorTarget in (playableUnits + switchableUnits), !([side group cursorTarget, side group player] call BIS_fnc_sideIsEnemy), ( (player getUnitTrait "Medic" && FAR_var_ReviveMode == 0) || ((count (FAR_FAK arrayIntersect (items player))) > 0 && FAR_var_ReviveMode == 1) || ((count (FAR_Medkit arrayIntersect (items player + items cursorTarget))) > 0 && FAR_var_ReviveMode == 2)),{lifeState _cursorTarget == 'INCAPACITATED'}];
		
	if (!(_caller getVariable ["FAR_var_isDragging", false]) && 
		_cursorTarget in (playableUnits + switchableUnits) && 
		!([side group _cursorTarget, side group _caller] call BIS_fnc_sideIsEnemy) && 
		(
			(_caller getUnitTrait "Medic" && FAR_var_ReviveMode == 0) ||
			((count (FAR_var_FAK arrayIntersect (items _caller))) > 0 && FAR_var_ReviveMode == 1) ||
			((count (FAR_var_Medkit arrayIntersect (items _caller + items _cursorTarget))) > 0 && FAR_var_ReviveMode == 2)
		) &&
		{lifeState _cursorTarget == 'INCAPACITATED'})
	exitWith { 
		_caller setUserActionText [FAR_act_Revive , format["<t color='#FF0000'>Revive<img image='%2'/>(%1)</t>", name _cursorTarget, (getText (configFile >> "CfgVehicles" >> (typeOf _cursorTarget) >> "icon") call bis_fnc_textureVehicleIcon)], "<img size='3' image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa'/>"];
		true
	};

	false
};

FAR_fnc_Revive = {
	params ["_target", "_caller", "_actionId", "_arguments"];
	
	private _cursorTarget = cursorTarget; // Can't be passed in addAction arguments!
	private _underwater = [_caller] call FAR_fnc_isUnderwater;
	
	if (!_underwater) then {
		_caller playMove format["AinvP%1MstpSlayW%2Dnon_medicOther", ["knl","pne"] select (stance _caller == "PRONE"), [["rfl","pst"] select (currentWeapon _caller isEqualTo handgunWeapon _caller), "non"] select (currentWeapon _caller isEqualTo "")];
	};
	_cursorTarget setVariable ["FAR_var_isDragged", false, true];
	
	/*
	// Play sound
	if (isArray (_config >> "sounds")) then {
		selectRandom getArray (_config >> "sounds") params ["_sound", ["_volume", 1], ["_pitch", 1], ["_distance", 10]];
		playSound3D [_sound, objNull, false, getPosASL _caller, _volume, _pitch, _distance];
	};
	*/
			
	uiSleep 4;
			
	if (lifeState _cursorTarget == "INCAPACITATED") then {
		if (!_underwater) then {
			private _simpleObj = createSimpleObject [selectRandom [ "MedicalGarbage_01_1x1_v1_F", "MedicalGarbage_01_1x1_v2_F", "MedicalGarbage_01_1x1_v3_F" ], getPosWorld _caller];
			_simpleObj setDir random 360;
			_simpleObj setVectorUp surfaceNormal getPosWorld _caller;
		};
		
		if (count (FAR_var_Medkit arrayIntersect (items _caller)) == 0) then { _caller removeItem "FirstAidKit" };
		
		[_cursorTarget, false] remoteExecCall ["setUnconscious", _cursorTarget];
		uiSleep 1;
		[[format["<t color='#FF0080' size='1.5'>Revived</t><t size='1.5'> by %1</t>", name player], "PLAIN DOWN", -1, true, true]] remoteExecCall ["TitleText", _cursorTarget];
		_cursorTarget forceWalk false;
	};
};

FAR_fnc_CheckStabilize = {
	private _caller = _originalTarget;
	private _cursorTarget = cursorTarget; // Can't be passed in addAction arguments!
	
	if (isNull _cursorTarget) exitWith { false };
	
	// format["STABLE: %1 | %2 | %3 | %4 | %5 | %6 | %7", (cursorTarget getVariable ["FAR_var_isDragging", false]), cursorTarget in (playableUnits + switchableUnits),  !([side group cursorTarget, side group player] call BIS_fnc_sideIsEnemy), !(cursorTarget getVariable ["FAR_var_isDragged",false]), !(cursorTarget getVariable ['FAR_var_isStable',false]), ('FirstAidKit' in (items player) || 'Medikit' in (items player) || 'FirstAidKit' in (items cursorTarget)), {lifeState cursorTarget == 'INCAPACITATED'} ];
	
	if (!(_caller getVariable ["FAR_var_isDragging", false]) && 
		_cursorTarget in (playableUnits + switchableUnits) && 
		!([side group _cursorTarget, side group _caller] call BIS_fnc_sideIsEnemy) && 
		!( _cursorTarget getVariable ["FAR_var_isDragged",false]) && 
		!(_cursorTarget getVariable ['FAR_var_isStable',false]) && 
		((count (FAR_var_FAK arrayIntersect (items _caller + items _cursorTarget))) > 0 || ((count (FAR_var_Medkit arrayIntersect (items _caller))) > 0)) &&
		{lifeState _cursorTarget == 'INCAPACITATED'}) 
	exitWith { 
		_caller setUserActionText [FAR_act_Stabilise, format["<t color='#FF0000'>Stabilize<img image='%2'/>(%1)</t>", name _cursorTarget, (getText (configFile >> "CfgVehicles" >> (typeOf _cursorTarget) >> "icon") call bis_fnc_textureVehicleIcon)], "<img size='3' image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_revive_ca.paa'/>"];
		true };
	
	false
};

FAR_fnc_Stabilize = {
	params ["_target", "_caller", "_actionId", "_arguments"];
	
	private _cursorTarget = cursorTarget; // Can't be passed in addAction arguments!
	private _underwater = [_caller] call FAR_fnc_isUnderwater;
	
	if (!_underwater) then {
		_caller playMove format["AinvP%1MstpSlayW%2Dnon_medicOther", ["knl","pne"] select (stance _caller == "PRONE"), [["rfl","pst"] select (currentWeapon _caller isEqualTo handgunWeapon _caller), "non"] select (currentWeapon _caller isEqualTo "")];
	};
	playSound3D [
		selectRandom ["a3\sounds_f\characters\ingame\AinvPknlMstpSlayWpstDnon_medic.wss","a3\sounds_f\characters\ingame\AinvPknlMstpSlayWrflDnon_medic.wss","a3\sounds_f\characters\ingame\AinvPpneMstpSlayWpstDnon_medic.wss","a3\sounds_f\characters\ingame\AinvPpneMstpSlayWrflDnon_medic.wss"],
		objNull,
		false,
		getPos _caller,
		1,
		1,
		50
	];
		
	if (lifeState _cursorTarget == "INCAPACITATED" && !(_cursorTarget getVariable ["FAR_var_isStable",false])) then {
		if (!_underwater) then {
			private _simpleObj = createSimpleObject ["MedicalGarbage_01_FirstAidKit_F", getPosWorld _caller];
			_simpleObj setDir random 360;
			_simpleObj setVectorUp surfaceNormal getPosWorld _caller;
		};


		if (count (FAR_var_Medkit arrayIntersect (items _caller)) == 0) then {
			if (count (FAR_var_FAK arrayIntersect (items _caller)) == 0) then {
				_cursorTarget removeItem "FirstAidKit";
				[[format["<t color='#FF0080' size='1.5'>Stabilised</t><t size='1.5'> by %1 using a FAK from your inventory</t>", name _caller], "PLAIN DOWN", -1, true, true]] remoteExecCall ["TitleText", _cursorTarget];
			} else {
				_caller removeItem "FirstAidKit";
			};
		};
		
		_cursorTarget setVariable ["FAR_var_isStable", true, true];
	};
};

FAR_fnc_CheckDragging = {
	private _caller = _originalTarget;
	private _cursorTarget = cursorTarget; // Can't be passed in addAction arguments!
	
	if (isNull _cursorTarget) exitWith { false };
	
	// format["DRAG: %1 | %2 | %3 | %4 | %5", !(player getVariable ["FAR_var_isDragging", false]),!(cursorTarget getVariable ["FAR_var_isDragged",false]),!([player] call FAR_fnc_isUnderwater),!([cursorTarget] call FAR_fnc_isUnderwater),{lifeState cursorTarget == 'INCAPACITATED'} ];

	if (!(_caller getVariable ["FAR_var_isDragging", false]) && 
		!( _cursorTarget getVariable ["FAR_var_isDragged",false]) && 
		!([_caller] call FAR_fnc_isUnderwater) &&
		!([_cursorTarget] call FAR_fnc_isUnderwater) &&
		{lifeState _cursorTarget == 'INCAPACITATED'}) 
	exitWith { 
		_caller setUserActionText [FAR_act_Dragging, format["<t color='#FF0000'>Drag<img image='%2'/>(%1)</t>",name _cursorTarget, (getText (configFile >> "CfgVehicles" >> (typeOf _cursorTarget) >> "icon") call bis_fnc_textureVehicleIcon)], "<img size='3' image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_takeOff1_ca.paa'/>"];
		true };
		
	false
};

FAR_fnc_CheckBag = {
	private _caller = _originalTarget;
	private _cursorTarget = cursorObject; // Can't be passed in addAction arguments!	
	
	if (isNull _cursorTarget) exitWith { false };
	
	// format["BAG: %1 | %2 | %3 | %4", !(player getVariable ["FAR_var_isDragging", false]),!([player] call FAR_fnc_isUnderwater),!(player nearObjects ["CAManBase", 2.5] select { lifeState _x in ['DEAD','DEAD-RESPAWN'] && !(isObjectHidden _x) } isEqualTo []),{"Medikit" in (items player)} ];
	
	if (!(_caller getVariable ["FAR_var_isDragging", false]) && 
		!([_caller] call FAR_fnc_isUnderwater) &&
		!(_caller nearObjects ["CAManBase", 2.5] select { lifeState _x in ['DEAD','DEAD-RESPAWN'] && !(isObjectHidden _x) } isEqualTo []) && 
		{count (FAR_var_Medkit arrayIntersect (items _caller)) > 0}) 
	exitWith { 
		_caller setUserActionText [FAR_act_Bag , format["<t color='#FF0000'>Bag Body%1</t>", if (name _cursorTarget != "Error: No unit" && lifeState _cursorTarget in ['DEAD','DEAD-RESPAWN']) then { format[" (%1)", name _cursorTarget] } else {""}], "<img size='3' image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_forceRespawn_ca.paa'/>"];
		true 
	};
	
	false
};

FAR_fnc_Bag = {
	params ["_target", "_caller", "_actionId", "_arguments"];
	
	private _cursorTarget = cursorObject; // Can't be passed in addAction arguments!
	
	// Looking at weapons holder - Find the body.
	if !(lifeState _cursorTarget in ['DEAD','DEAD-RESPAWN'] && !(_cursorTarget isKindOf "CAManBase")) then {
		_cursorTarget = (_caller nearObjects ["CAManBase", 2.5] select { lifeState _x in ['DEAD','DEAD-RESPAWN'] }) # 0;
	};
	
	// Exit if we lost the body!
	if !(_cursorTarget isKindOf "CAManBase") exitWith {};
	
	_caller playMove format["AinvP%1MstpSlayW%2Dnon_medicOther", ["knl","pne"] select (stance _caller == "PRONE"), [["rfl","pst"] select (currentWeapon _caller isEqualTo handgunWeapon _caller), "non"] select (currentWeapon _caller isEqualTo "")];

	private _simpleObj = createSimpleObject [switch (getNumber(configFile >> "CfgVehicles" >> typeOf _cursorTarget >> "side")) do { case 0: { "Land_Bodybag_01_black_F" }; case 1: { "Land_Bodybag_01_blue_F" }; default { "Land_Bodybag_01_white_F" } }, getPosWorld _cursorTarget];
	_simpleObj setDir getDir _cursorTarget;
	_simpleObj setVectorUp surfaceNormal getPosWorld _cursorTarget;
	
	if (getMarkerType format["FAR_MKR_%1", _cursorTarget getVariable ["FAR_var_markerName", profileName]] != "") then { deleteMarker format["FAR_MKR_%1", _cursorTarget getVariable ["FAR_var_markerName", profileName]] };

	if (FAR_var_RespawnBagTime > 0 && isPlayer _cursorTarget && !([side group _cursorTarget, side group _caller] call BIS_fnc_sideIsEnemy)) then {
		{ 
			if (!alive player && (playerRespawnTime > FAR_var_RespawnBagTime || playerRespawnTime < 0)) then { 
				setPlayerRespawnTime FAR_var_RespawnBagTime;
				
				private _layer = "BIS_fnc_respawnCounter" call bis_fnc_rscLayer; 
				RscRespawnCounter_Custom = FAR_var_RespawnBagTime; 
				RscRespawnCounter_description = "";
				_layer cutRsc ["RscRespawnCounter","PLAIN"];
				
				titleText [format["<t size='2'>Your body was recovered. Respawn in %1 Minutes<br/>", round FAR_var_RespawnBagTime / 60],"PLAIN DOWN", 2, true, true];
			};
		} remoteExecCall ["BIS_fnc_spawn", _cursorTarget];
	};

	[_cursorTarget, true] remoteExecCall ["hideObjectGlobal", 2];
};

FAR_fnc_IsFriendlyMedic = {
	private _unit = _this;
				
	if ((_unit getUnitTrait "Medic" || (getNumber (configFile >> "CfgVehicles" >> typeOf _unit >> "attendant") == 1)) &&
		alive _unit && 
		(isPlayer _unit || !isMultiPlayer) && 
		side (group _unit) == playerSide && 
		!(lifeState _unit == "INCAPACITATED")
	) exitWith { true };
	
	false
};

FAR_fnc_CheckFriendlies = {
	private ["_unit", "_units", "_medics", "_hintMsg"];

	_units = (position player) nearEntities [["Man", "Air", "Car"], 300];
	//_units = nearestObjects [getPos player, ["Man", "Car", "Air", "Ship"], 300];
	_medics = [];
	_dist = 300;
	_hintMsg = "";
	
	// Find nearby friendly medics
	if (count _units > 1) then {
		{
			if (_x isKindOf "Car" || _x isKindOf "Air" || _x isKindOf "Ship") then {
				if (alive _x && count (crew _x) > 0) then {
					{
						if (_x call FAR_fnc_IsFriendlyMedic) then {
							_medics = _medics + [_x];
							
							if (true) exitWith {};
						};
					} forEach crew _x;
				};
			} else {
				if (_x call FAR_fnc_IsFriendlyMedic) then {
					_medics = _medics + [_x];
				};
			};
		} forEach _units;
	};
	
	// Sort medics by distance
	if (count _medics > 0) then {
		{
			if (player distance _x < _dist) then {
				_unit = _x;
				_dist = player distance _x;
			};
		
		} forEach _medics;
		
		if (!isNull _unit) then {
			_unitName	= name _unit;
			_distance	= floor (player distance _unit);
			
			_hintMsg = format["Nearby Medic:\n%1 is %2m away.", _unitName, _distance];
		};
	} else {
		_hintMsg = "No medics within 300m.";
	};
	
	_hintMsg
};

FAR_fnc_getMedicalVehicles = {
	_allUnits = [];
	_vehicles = [];
	
	// Get all units from allied groups.
	{
		if ((side _x getFriend side group player >= 0.6) && ({_x in playableUnits + switchableUnits} count units _x) > 0) then { _allUnits append units _x };
	} forEach allGroups;

	// Find nearby medical vehicles within 100m.
	{
		_veh = _x;
		if (_allUnits findIf { _x distance2D _veh < 50 } >= 0) then { _vehicles pushBackUnique _veh };
	} forEach (vehicles select { 
		locked _x < 2 && 
		fuel _x > 0 && 
		_x isKindOf "AllVehicles" &&
		getNumber (configFile >> "CfgVehicles" >> (typeOf _x) >> "attendant") == 1
	});
	
	_vehicles
};

FAR_fnc_TeleportNearestVehicle = {
	params [["_unit", player], ["_foundVehs",([] call FAR_fnc_getMedicalVehicles)]];
		
	if !(isPlayer _unit) exitWith {};
	
	_target = objNull;
	
	{
		if (_unit distance2d _x < _unit distance2d _target) then { _target = _x };
	} forEach (((missionNamespace getVariable ["FAR_var_MedicalVehs",[]]) + _foundVehs) select { alive _x });
	
	if (isNull _target) exitWith {};
	
	[0, "BLACK", 3, 1] call BIS_fnc_fadeEffect;
	
	uiSleep random 4;
	
	_unit moveInCargo _target;
	
	if (_unit distance2D _target > 50) then { _unit setVehiclePosition [_target, [], 5, "NONE"] };
	
	[1, "BLACK", 3, 1] call BIS_fnc_fadeEffect; 
};

FAR_fnc_AIHeal = {
	params [["_unit", player]];
	
	if (isNil "_unit") exitWith {};
	
	_units = (units _unit) select { lifeState _x in ["HEALTHY","INJURED"] && !isPlayer _x && ('Medikit' in (items _x))};

	// No nearby medics, so get any near units.
	if (count _units == 0) then {
		_friendSides = [side group _unit] call BIS_fnc_friendlySides;
		_units = (_unit nearEntities ["Man", 50]) select { side _x in _friendSides && lifeState _x in ["HEALTHY","INJURED"] && !isPlayer _x };
	};
	
	_ai = objNull;
	
	// Find the closest AI
	{
		if (_unit distance2D _x < _unit distance2D _ai) then { _ai = _x };
	} forEach _units;
	
	if (isNull _ai || _ai distance _unit > 150) exitWith {
		if (isPlayer _unit && local _unit) then {
			_drone = createVehicle ["C_IDAP_UAV_06_medical_F", _unit getPos [100, random 360], [], 0, "FLY"];		
			createVehicleCrew _drone;
			
			_drone setVariable ["var_target",_unit];
			_drone allowDamage false;
			_drone flyInHeight 20;
			
			[_unit, format["Medical UAV En-route to %1 (%2)", name _unit, mapGridPosition _unit]] remoteExecCall ["GroupChat", side group _unit];
			
			_wp = (group _drone) addWaypoint [_unit, 0];
			_wp setWaypointType "SCRIPTED";
			_wp setWaypointScript "A3\functions_f\waypoints\fn_wpLand.sqf";
			_wp setWaypointStatements ["true", "
				_injured = (vehicle this) getVariable ['var_target',objNull];
				if (alive _injured) then {
					[_injured, format['Medical UAV located %1 (%2)', name _injured, mapGridPosition _injured]] remoteExecCall ['GroupChat', side group _injured];
					[_injured, false] remoteExecCall ['setUnconscious', _injured];
					_tempSmoke = SmokeShell' createVehicle _injured;
				};
				vehicle this flyInHeight 100;
			"];
					
			_wp = (group _drone) addWaypoint [_unit getPos [200, random 360], 0];
			_wp setWaypointType "MOVE";
			_wp setWaypointStatements ["true", "deleteVehicle (vehicle this); {deleteVehicle _x} forEach thisList; deleteGroup (group this);"];
		} else {
			[_unit, format["Man Down! No available units near %1", mapGridPosition _unit]] remoteExecCall ["SideChat", side group _unit];
		};
	};
	
	[[_ai, _unit], { 
		params ["_medic","_target"];
		
		//BIS_fnc_showSubtitle
		[_medic, format["Man down! Attending to %1 (%2m)", name _target, round (_medic distance2D _target)]] remoteExecCall ["GroupChat", side group _target];
		
		_medic allowDamage false;
		
		{ _medic disableAI _x } forEach ["AUTOCOMBAT", "AUTOTARGET", "TARGET", "SUPPRESSION"];
		
		if (_medic distance2D _target < 25) then { _medic setUnitPos "MIDDLE" };
		
		doStop _medic;
		waitUntil { uiSleep 1; _medic doMove (getPos _target); (_medic distance2D _target < 3 || lifeState _target != "INCAPACITATED"); };
		
		if (lifeState _target == "INCAPACITATED") then {
			_medic playMove format["AinvP%1MstpSlayW%2Dnon_medicOther", ["knl","pne"] select (stance _medic == "PRONE"), [["rfl","pst"] select (currentWeapon _medic isEqualTo handgunWeapon _medic), "non"] select (currentWeapon _medic isEqualTo "")];
			_medic lookAt _target;
			
			uiSleep 1;
			
			private _simpleObj = createSimpleObject [selectRandom [ "MedicalGarbage_01_1x1_v1_F", "MedicalGarbage_01_1x1_v2_F", "MedicalGarbage_01_1x1_v3_F" ], getPosWorld _medic];
			_simpleObj setDir random 360;
			_simpleObj setVectorUp surfaceNormal getPosWorld _medic;
			
			uiSleep 3;
			
			[_target, false] remoteExecCall ["setUnconscious", _target];
		};

		{ _medic enableAI _x } forEach ["AUTOCOMBAT", "AUTOTARGET", "TARGET", "SUPPRESSION"];
		
		_medic setUnitPos "AUTO";
		_medic allowDamage true;	
		//doStop _medic;
		_medic doFollow (leader group _medic);
	}] remoteExecCall ["BIS_fnc_spawn", _ai];	
};

FAR_fnc_isUnderwater = {
	params [["_man", objNull]];
	(((animationState _man) select [1, 3]) in ["bdv","bsw","dve","sdv","ssw","swm"])
};

FAR_fnc_CheckUnitCarry = {
	private _caller = _originalTarget;
	private _cursorTarget = cursorTarget;
	
	if (isNull _cursorTarget) exitWith { false };
	
	if ((_cursorTarget getVariable ["FAR_var_isStable", false]) &&
		!(_caller getVariable ["FAR_var_isDragging", false]) && 
		!( _cursorTarget getVariable ["FAR_var_isDragged", false]) && 
		!([_caller] call FAR_fnc_isUnderwater) &&
		!([_cursorTarget] call FAR_fnc_isUnderwater) &&
		{lifeState _cursorTarget == 'INCAPACITATED'}) 
	exitWith { 
		_caller setUserActionText [FAR_act_Carry , format["<t color='#FF0000'>Carry<img image='%2'/>(%1)</t>", name _cursorTarget, (getText (configFile >> "CfgVehicles" >> (typeOf _cursorTarget) >> "icon") call bis_fnc_textureVehicleIcon)], "<img size='3' image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_takeOff2_ca.paa'/>"];
		true
	};
		
	false
};

FAR_fnc_CheckUnitLoad = { 
	private _caller = _originalTarget;
	private _cursorTarget = if (_caller getVariable ["FAR_var_isDragging", false]) then {(attachedObjects _caller) # 0} else { cursorTarget };
	private _nearVehs = (nearestObjects [_caller, ["Car", "Air", "Tank", "Ship_F"], 8]) select { locked _x < 2 && _x emptyPositions "cargo" > 0 };

	if (_nearVehs isEqualTo [] || isNil "_cursorTarget" || isNull _cursorTarget) exitWith {};
	
	_veh = _nearVehs # 0;
	
	if (vehicle _caller == _caller &&
		(_cursorTarget getVariable ["FAR_var_isStable", false]) &&
		(lifeState _caller in ["HEALTHY","INJURED"]) &&
		{lifeState _cursorTarget == 'INCAPACITATED'})
	exitWith { 
		_caller setUserActionText [FAR_act_UnitLoad , format["<t color='#FF0000'>Load<img image='%3'/>(%1) [%2]</t>", name _cursorTarget, getText (configFile >> "CfgVehicles" >> (typeOf _veh) >> "displayName"), (getText (configFile >> "CfgVehicles" >> (typeOf _cursorTarget) >> "icon") call bis_fnc_textureVehicleIcon)], "<img size='3' image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_takeOff2_ca.paa'/>"];
		true
	};
	
	false
};

FAR_fnc_UnitLoad = {
	params ["_target", "_caller", "_actionId", "_arguments"];
	
	private _cursorTarget = if (_caller getVariable ["FAR_var_isDragging", false]) then {(attachedObjects _caller) # 0} else { cursorTarget };
	private _nearVehs = (nearestObjects [_cursorTarget, ["Car", "Air", "Tank", "Ship_F"], 15]) select { locked _x < 2 && _x emptyPositions "cargo" > 0 };
	
	if (_nearVehs isEqualTo [] || isNil "_cursorTarget" || isNull _cursorTarget) exitWith {};
	
	_veh = _nearVehs # 0;
	
	[[format["Loaded %1 into %2 (%3m)", name _cursorTarget, getText (configFile >> "CfgVehicles" >> (typeOf _veh) >> "displayName"), round (_cursorTarget distance _veh)], "PLAIN DOWN", 2]] remoteExecCall ["TitleText", [_caller, _cursorTarget]];
	
	[_cursorTarget, _veh] remoteExecCall ["moveInCargo",_cursorTarget];	
	
	_cursorTarget setVariable ["FAR_var_isDragged", false, true];
	
	[_cursorTarget, "Unconscious"] remoteExecCall ["playActionNow", _cursorTarget];
};

FAR_fnc_UnitMove = {
	params ["_target", "_caller", "_actionId", "_arguments"];
	
	_arguments params [["_type","drag"]];
		
	private _cursorTarget = cursorTarget;
	private _animList = ["acinpercmstpsnonwnondnon", "acinpknlmstpsraswrfldnon", "acinpknlmstpsnonwpstdnon", "acinpknlmstpsnonwnondnon", "acinpknlmwlksraswrfldb", "acinpknlmwlksnonwnondb"];
	
	_caller selectWeapon primaryWeapon _caller;	
	_caller setVariable ["FAR_var_isDragging", true, false];
	_cursorTarget setVariable ["FAR_var_isDragged", true, true];
	
	if (_type == "drag") then {
		_caller forceWalk true;
		_caller playActionNow "CROUCH";
		uiSleep 0.5;
		[_caller, "grabDrag"] remoteExecCall ["playActionNow", _caller];
		
		_cursorTarget attachTo [_caller, [0, 1.1, 0.092]];
		[_cursorTarget,180] remoteExecCall ["setDir",_cursorTarget];
		
		[_cursorTarget, "AinjPpneMrunSnonWnonDb_still"] remoteExecCall ["switchMove"];
	} else {
		[_caller, 1.5] remoteExecCall ["setAnimSpeedCoef"];
		[_cursorTarget, 1.5] remoteExecCall ["setAnimSpeedCoef"];
		[_caller, "AcinPknlMstpSnonWnonDnon_AcinPercMrunSnonWnonDnon"] remoteExecCall ["switchMove"];
		[_cursorTarget, "AinjPfalMstpSnonWrflDnon_carried_Up"] remoteExecCall ["switchMove"];
		_caller forceWalk true;
		_caller setDir (getDir _cursorTarget + 180);
		_caller setPosASL (getPosASL _cursorTarget vectorAdd (vectorDir _cursorTarget));
	};
	
	private _time = time + 10;
	waitUntil { uiSleep 0.5; (!(lifeState _caller in ["HEALTHY","INJURED"]) || time > _time || (((animationState _caller) select [1, 3]) != "cin" && ((animationState _caller) select [26, 3]) != "cin") || animationState _caller in _animList) };
	
	// Reset anim speed
	if (_type != "drag") then {
		[_caller, 1] remoteExecCall ["setAnimSpeedCoef"];
		[_cursorTarget, 1] remoteExecCall ["setAnimSpeedCoef"];
	};
	
	// Unit was injured before completing animation so exit
	if ((!(lifeState _caller in ["HEALTHY","INJURED"])) || lifeState _cursorTarget != "INCAPACITATED" || (((animationState _caller) select [1, 3]) != "cin" && ((animationState _caller) select [26, 3]) != "cin")) exitWith {
		detach _cursorTarget;
		if (lifeState _caller in ["HEALTHY","INJURED"]) then { [_caller, ""] remoteExecCall ["switchMove"]; };
		[_cursorTarget, "UnconsciousReviveDefault"] remoteExecCall ["switchMove"];
		_cursorTarget setVariable ["FAR_var_isDragged", false, true];
		_caller setVariable ["FAR_var_isDragging", false, false];
		_caller forceWalk false;
	};

	if (_type != "drag") then { 
		[_cursorTarget, "AinjPfalMstpSnonWnonDf_carried_dead"] remoteExecCall ["switchMove"];
		_cursorTarget attachTo [_caller, [0.4, -0.1, -1.25], "LeftShoulder"];
		[_cursorTarget, 180] remoteExecCall ["setDir", _cursorTarget];
	};
			
	// Add release action for carrier
	FAR_act_Release = _caller addAction ["Release", {
		params ["_target", "_caller", "_actionId", "_arguments"];
		_injured = (attachedObjects _caller) select { _x getVariable ["FAR_var_isDragged", false] };		
		_caller setVariable ["FAR_var_isDragging", false, false];
		if (count _injured > 0) then { [(_injured#0), "UnconsciousReviveDefault"] remoteExecCall ["switchMove"] };
		[_caller, ""] remoteExecCall ["switchMove"];
		_caller removeAction _actionId;
	}, [], 10, true, true, "", "true"];
	
	_caller setUserActionText [FAR_act_Release, format["<t color='#FF0000'>Drop<img image='%2'/>(%1)</t>", name _cursorTarget, (getText (configFile >> "CfgVehicles" >> (typeOf _cursorTarget) >> "icon") call bis_fnc_textureVehicleIcon)], "<img size='3' image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa'/>"];
		
	// Wait until anim changes
	waitUntil { 
		uiSleep 0.5;
		(((animationState _caller) select [1, 3]) != "cin" && ((animationState _caller) select [26, 3]) != "cin") ||
		_caller distance _cursorTarget > 5 ||
		!(lifeState _caller in ["HEALTHY","INJURED"]) ||
		!(lifeState _cursorTarget == "INCAPACITATED") ||
		!(_caller getVariable ["FAR_var_isDragging", false]) ||
		!(_cursorTarget getVariable ["FAR_var_isDragged",false])
	};
	
	detach _cursorTarget;
	
	_caller forceWalk false;

	// Target was dropped by other means, so cancel the dragging animation
	if (_caller getVariable ["FAR_var_isDragging", false]) then {
		if (lifeState _caller in ["HEALTHY","INJURED"]) then { [_caller,""] remoteExecCall ["switchMove"] };
		if (vehicle _cursorTarget == _cursorTarget && alive _cursorTarget) then { [_cursorTarget, "UnconsciousReviveDefault"] remoteExecCall ["switchMove"] };
	};

	_cursorTarget setVariable ["FAR_var_isDragged", false, true];
	
	_caller setVariable ["FAR_var_isDragging", false, false];
	_caller removeAction FAR_act_Release;
};