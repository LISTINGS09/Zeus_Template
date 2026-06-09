if !(hasInterface) exitWith {};

if (isNil "F3_EHID_AutoChute") then {

	F3_EHID_AutoChute = player addEventHandler ["GetOutMan", {
		params ["_unit", "_role", "_vehicle", "_turret", "_isEject"];

		if !(_isEject) exitWith {};
		if ((position _unit # 2) < 50) exitWith {};

		_unit spawn {
			private _bp = backpack _this;
			private _bpi = backpackItems _this;

			removeBackpackGlobal _this;

			waitUntil { sleep 0.1; backpack _this == "" };

			_this allowDamage false;

			ace_map_mapShake = true;

			"dynamicBlur" ppEffectEnable true;
			"dynamicBlur" ppEffectAdjust [6];
			"dynamicBlur" ppEffectCommit 0;
			"dynamicBlur" ppEffectAdjust [0];
			"dynamicBlur" ppEffectCommit 5;

			_this addBackpackGlobal ( missionNamespace getVariable [ "f_var_chuteType", "B_Parachute" ] );

			waitUntil { sleep 0.1; (position _this # 2) < 125 };

			if ( vehicle _this isEqualTo _this && alive _this ) then { _this action ["OpenParachute", _this] };

			waitUntil { sleep 0.1; (position _this # 2) < 100 };

			_this allowDamage true;

			ace_map_mapShake = false;

			removeBackpackGlobal _this;

			waitUntil { sleep 0.1; backpack _this == "" };

			if (_bp != "") then {

				_this addBackpackGlobal _bp;

				waitUntil { sleep 0.1; backpack _this != "" };

				{ (unitBackpack _this) addItemCargoGlobal [_x, 1] } forEach _bpi;
			};
		};
	}];

	systemChat "Event Handler added, will activate when ejecting from any vehicle above 50m.";

} else {

	systemChat "Event Handler for 'GetOut' is already active!";
};