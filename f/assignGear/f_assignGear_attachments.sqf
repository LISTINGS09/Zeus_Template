// Note: Attachments are arrays of array/strings
if (_attachments isEqualType "") then { _attachments = [_attachments] };// Convert to array
if (_hg_attachments isEqualType "") then { _hg_attachments = [_hg_attachments] }; // Convert to array

// Handle primary attachments
if (primaryWeapon _unit != "") then {
	removeAllPrimaryWeaponItems _unit;
	
	{
		private ["_attachment","_attItems","_attType"];
		_attachment = _x;
		_attItems = [];
		_attType = 0;
		
		if (_attachment isEqualType "") then {_attachment = [_attachment]; };// Convert to array
		
		{
			if (getNumber(configFile >> "CfgWeapons" >> _x >> "itemInfo" >> "type") > 0) then {
				private _item = configName (configFile >> "CfgWeapons" >> _x);
				private _allowedArray = [primaryWeapon _unit,getNumber(configFile >> "CfgWeapons" >> _x >> "itemInfo" >> "type")] call f_fnc_compatibleItems;
				_attType = getNumber(configFile >> "CfgWeapons" >> _item >> "itemInfo" >> "type");	

				if (_item in _allowedArray) then { _attItems pushBackUnique _item; };
			} else {
				["f_assignGear_attachments.sqf",format["Invalid attachment for %1_%2: '%3'",_side,_typeofUnit,_x],"ERROR"] call f_fnc_logIssue;
			};
		} forEach _attachment;

		if (count _attItems > 0) then {
			_unit addPrimaryWeaponItem (_attItems select 0);
			if (isPlayer _unit && isNil format["f_var_%1_%2_gear%3",_side,_typeofUnit,_attType]) then { 
				missionNamespace setVariable [format["f_var_%1_%2_gear%3",_side,_typeofUnit,_attType],_attItems,true];
				//diag_log text format["[F3] DEBUG (f_assignGear_attachments.sqf): Setting f_var_%1_%2_gear%3 '%4'",_side,_typeofUnit,_attType,_attItems];
			};
		};
	} forEach _attachments;
};

// Handle handgun attachments
if (handgunWeapon _unit != "") then {
	removeAllHandgunItems _unit;

	// loop trough the attachments and add them to the weapon
	{
		if (isClass (configFile >> "CfgWeapons" >> _x)) then {
			_unit addHandgunItem _x;
		} else {
			["fn_addWeapon.sqf",format["Invalid weapon for %1_%2: '%3'.",_side,_typeofUnit,_x],"ERROR"] call f_fnc_logIssue;
		};
	} forEach _hg_attachments;
};

