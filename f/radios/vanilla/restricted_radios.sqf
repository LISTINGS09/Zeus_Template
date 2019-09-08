// Client Specific restricted radio features - Includes issuing of backpack and EHs for respawn and item interaction
if !hasInterface exitWith {};

waitUntil{ player getVariable ["f_var_assignGear_done", false] };

// Local variable to get default backpack
f_radios_backpack = missionNamespace getVariable [format["f_radios_%1backpack",side group player], missionNamespace getVariable ["f_radios_backpack","B_RadioBag_01_black_F"]];

// Set up player EHs for locked radios
f_fnc_enableRadioEH = {
	params [["_unit", player]];
	
	// Auto join Command Net when taking valid backpack
	if !(isNil "f_eh_takeRadio") then { _unit removeEventHandler ["Take", f_eh_takeRadio] };
	f_eh_takeRadio = _unit addEventHandler ["Take", {
		params ["_unit","_container","_item"];
		
		// If a radio backpack is taken and not already an operator
		if (_item == f_radios_backpack) then {
			private _str = format["(%1)", getText (configFile >> "CfgVehicles" >> _item >> "displayName")];
			// Auto channels
			if (f_radios_activeChID isEqualTo []) then {
				[f_radios_mainChID, true, _str] spawn f_fnc_radioSwitchChannel;
			} else {
				{
					[_x, true, _str] spawn f_fnc_radioSwitchChannel;
				} forEach f_radios_activeChID;
			};
		};
	}];
	
	// Auto leave All Nets when dropping backpack
	if !(isNil "f_eh_putRadio") then { _unit removeEventHandler ["Put", f_eh_putRadio] };
	f_eh_putRadio = _unit addEventHandler ["Put", {
		params ["_unit", "_container", "_item"];
		
		// Check if the RO dropped radio
		if (_unit getVariable ["f_radios_isOperator", false]) then { 
			if !([] call f_fnc_hasUsableRadio) then { 
				_unit setVariable ["f_radios_isOperator", false];
				
				{
					[_x#1, false, "(Dropped Radio)"] spawn f_fnc_radioSwitchChannel;
				} forEach (missionNamespace getVariable [format["f_var_ch%1", side group _unit], []]);
				
				setCurrentChannel 3;
			};
		};
	}];
	
	// Auto leave All Nets when leaving vehicle
	if !(isNil "f_eh_getOutRadio") then { _unit removeEventHandler ["GetOutMan", f_eh_getOutRadio] };
	f_eh_getOutRadio = _unit addEventHandler ["GetOutMan", {
		params ["_unit", "_role", "_vehicle", "_turret"];
		//systemChat format["R: %1 V: %2 T: %3", _role, _vehicle, _turret];
		
		// Check if the RO left vehicle
		if (_unit getVariable ["f_radios_isOperator", false]) then { 
			if !([] call f_fnc_hasUsableRadio) then { 
				_unit setVariable ["f_radios_isOperator", false];
				
				{
					[_x#1, false, "(Left Vehicle)"] spawn f_fnc_radioSwitchChannel;
				} forEach (missionNamespace getVariable [format["f_var_ch%1", side group _unit], []]);
				
				setCurrentChannel 3;
			};
		};
	}];

	// Auto join channel if player didn't manually leave it
	if !(isNil "f_eh_getInRadio") then { _unit removeEventHandler ["GetInMan", f_eh_getInRadio] };
	f_eh_getOutRadio = _unit addEventHandler ["GetInMan", {
		params ["_unit", "_role", "_vehicle", "_turret"];
		//systemChat format["R: %1 V: %2 T: %3", _role, _vehicle, _turret];
		
		// If a last channel was set, automatically rejoin
		if ([] call f_fnc_hasUsableRadio) then {
			{
				[_x, true, "(Vehicle Radio)"] spawn f_fnc_radioSwitchChannel;
			} forEach f_radios_activeChID;
		};
	}];
	
	if !(isNil "f_eh_respawnRadio") then { _unit removeEventHandler ["Respawn", f_eh_respawnRadio] };
	f_eh_respawnRadio = _unit addEventHandler ["Respawn", {
		params ["_unit", "_corpse"];
		[_unit] spawn f_fnc_enableRadioEH;
		[_unit] spawn f_fnc_giveRadioBackpack;
	}];
	
	if (!isNil "f_act_takeRadio") then { _unit removeAction f_act_takeRadio };
	f_act_takeRadio = _unit addAction [format["Take %1", getText (configFile >> "CfgVehicles" >> f_radios_backpack >> "displayName")], 
		{
			params ["_target", "_caller", "_actionId", "_arguments"];
			_caller playAction "PutDown";
					
			_cursorTarget = cursorTarget;
			_tItems = backpackItems _cursorTarget;
			_pItems = backpackItems _caller;
			_pBackpack = backpack _caller;
			
			// Add targets items to players backpack.
			removeBackpack _caller;
			_caller addBackpack f_radios_backpack;
			{ backpackContainer _caller addItemCargo [_x, 1] } forEach _tItems;

			// Add main channel
			if ([] call f_fnc_hasUsableRadio) then {
				[f_radios_mainChID, true, format["<t size='1.5'>(Radio from <t color='#FF0080'>%2</t>)</t>", 
					getText (configFile >> "CfgVehicles" >> f_radios_backpack >> "displayName"),
					name _cursorTarget]
				] spawn f_fnc_radioSwitchChannel;
			};
			
			// Add players items to players backpack.
			removeBackpackGlobal _cursorTarget;
			_cursorTarget addBackpackGlobal _pBackpack;
			waitUntil { !isNull backpackContainer _cursorTarget };
			{ backpackContainer _cursorTarget addItemCargoGlobal [_x, 1] } forEach _pItems;

			// Remove targets channels remotely
			if !isServer then { // SP Fix
				{ 
					player setVariable ["f_radios_isOperator", false];
					{ [_x#1, false, "(Radio Removed)"] spawn f_fnc_radioSwitchChannel } forEach (missionNamespace getVariable [format["f_var_ch%1", side group player], []]);
					setCurrentChannel 3;
				} remoteExec ["BIS_fnc_spawn", _cursorTarget];
				
				[[format["<t color='#FF0080' size='1.5'>%1</t><t size='1.5'> removed your %2</t>", name _caller, getText (configFile >> "CfgVehicles" >> f_radios_backpack >> "displayName")], "PLAIN DOWN", -1, true, true]] remoteExec ["TitleText", _cursorTarget];
			};
		},
		[],
		7,
		true,
		true,
		"",
		"backpack _originalTarget != backpack cursorTarget && backpack cursorTarget == f_radios_backpack && (cursorTarget distance _originalTarget) <= 3 && {lifeState cursorTarget == 'INCAPACITATED'}",
		1
	];
};

// Remove all Radio EHs for locked radios
f_fnc_disableRadioEH = {
	params [["_unit", player]];
	
	if !(isNil "f_eh_takeRadio") then { _unit removeEventHandler ["Take", f_eh_takeRadio] };
	if !(isNil "f_eh_putRadio") then { _unit removeEventHandler ["Put", f_eh_putRadio] };
	if !(isNil "f_eh_getOutRadio") then { _unit removeEventHandler ["GetOutMan", f_eh_getOutRadio] };
	if !(isNil "f_eh_getInRadio") then { _unit removeEventHandler ["GetInMan", f_eh_getInRadio] };
	if !(isNil "f_eh_respawnRadio") then { _unit removeEventHandler ["Respawn", f_eh_respawnRadio] };
	if (!isNil "f_act_takeRadio") then { _unit removeAction f_act_takeRadio };
};

// Replace the players backpack with a valid radio
f_fnc_giveRadioBackpack = {
	params [["_unit", player], ["_forced",false]];
	
	private _lrUnits = missionNamespace getVariable ["f_radios_settings_longRangeUnits",["leaders"]];
	
	if ((_unit getVariable ["f_var_assignGear", "r"]) in (["ro"] + _lrUnits) || "all" in _lrUnits || ((leader _unit == _unit) && "leaders" in _lrUnits) || _forced) then {
		private _bItems = backpackItems _unit;
		private _config = configFile >> "CfgVehicles" >> (backpack _unit);
		
		// Only remove the backpack if it isn't a portable weapon. 
		if (getNumber (_config >> "maximumLoad") > 0) then { removeBackpack _unit };
		_unit addBackpack f_radios_backpack;
		{ backpackContainer _unit addItemCargo [_x, 1] } forEach _bItems;
		
		_unit setVariable ["f_radios_isOperator", true];
		
		{
			[_x, true, "(New Radio)"] spawn f_fnc_radioSwitchChannel;
		} forEach f_radios_activeChID;
	};
};

// Start
[] call f_fnc_enableRadioEH;
[] call f_fnc_giveRadioBackpack;