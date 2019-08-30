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
			// Auto join company channel
			[f_radios_mainChID, true, getText (configFile >> "CfgVehicles" >> _item >> "displayName")] spawn f_fnc_radioSwitchChannel;
		};
	}];
	
	// Add action to take radio for downed units
	if !(isNil "f_eh_openRadio") then { _unit removeEventHandler ["Take", f_eh_openRadio] };
	f_eh_openRadio = _unit addEventHandler ["InventoryOpened", {
		params ["_unit","_container","_item"];
		
		// If a radio backpack is taken and not already an operator
		if (_item == f_radios_backpack) then {									
			// Auto join company channel
			[f_radios_mainChID, true, getText (configFile >> "CfgVehicles" >> _item >> "displayName")] spawn f_fnc_radioSwitchChannel;
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
	
	//if (!isNil "f_act_takeRadio") then { _unit removeAction f_act_takeRadio };
	//f_act_takeRadio = _unit addAction ["Take Backpack (Radio)", {  params ["_target", "_caller", "_actionId", "_arguments"]; systemChat format["Target: %1 Caller: %2", backpack _target, backpack _caller]},[], 11, true, true, "", "lifeState cursorTarget [] && backpack cursorTarget == }",2];
	
	
    //_target: Object - the object to which action is attached or, if the object is a unit inside of vehicle, the vehicle
    //_this: Object - caller person to whom the action is shown (or not shown if condition returns false)
    //_originalTarget: Object - the original object to which the action is attached, regardless if the object/unit is in a vehicle or not

	
	
};

// Remove all Radio EHs for locked radios
f_fnc_disableRadioEH = {
	params [["_unit", player]];
	
	if !(isNil "f_eh_takeRadio") then { _unit removeEventHandler ["Take", f_eh_takeRadio] };
	if !(isNil "f_eh_putRadio") then { _unit removeEventHandler ["Put", f_eh_putRadio] };
	if !(isNil "f_eh_getOutRadio") then { _unit removeEventHandler ["GetOutMan", f_eh_getOutRadio] };
	if !(isNil "f_eh_getInRadio") then { _unit removeEventHandler ["GetInMan", f_eh_getInRadio] };
	if !(isNil "f_eh_respawnRadio") then { _unit removeEventHandler ["Respawn", f_eh_respawnRadio] };
};

// Replace the players backpack with a valid radio
f_fnc_giveRadioBackpack = {
	params [["_unit", player]];
	
	private _lrUnits = missionNamespace getVariable ["f_radios_settings_longRangeUnits",["leaders"]];
	
	if ((_unit getVariable ["f_var_assignGear", "r"]) in (["ro"] + _lrUnits) || "all" in _lrUnits || ((leader _unit == _unit) && "leaders" in _lrUnits)) then {
		private _backpackItems = backpackItems _unit;
		private _config = configFile >> "CfgVehicles" >> (backpack _unit);
		
		// Only remove the backpack if it isn't a portable weapon. 
		if (getNumber (_config >> "maximumLoad") > 0) then { removeBackpack _unit };
		_unit addBackpack f_radios_backpack;
		{ _unit addItemToBackpack _x } forEach _backpackItems;
		
		_unit setVariable ["f_radios_isOperator", true];
		
		{
			[_x, true, "(New Radio)"] spawn f_fnc_radioSwitchChannel;
		} forEach f_radios_activeChID;
	};
};

// Start
[] call f_fnc_enableRadioEH;
[] call f_fnc_giveRadioBackpack;