// F3 - Process ParamsArray
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================
if !isServer exitWith {};

_paramsLoaded = false;

// Iterate the parameters and compile/run any necessary code.
if (isNil "f_var_setParams") then {
	if (isNil "paramsArray") then {
		if (isClass(missionConfigFile >> "Params")) then {
			{
				_paramName = (configName _x);
				_paramValue = (getNumber (missionConfigFile >> "Params" >> _paramName >> "default"));
				diag_log text format["[F3] INFO (fn_processParamsArray.sqf): paramsArray (defaults) parsing %1 (%2).",_paramName,_paramValue];
				_paramCode = (getText (missionConfigFile >> "Params" >> _paramName >> "code"));
				_code = format[_paramCode, _paramValue];
				try {
					call compile _code;
				} catch {
					diag_log text format["[F3] ERROR (fn_processParamsArray.sqf): Error compiling code in %1.",_paramName];
				};
				missionNamespace setVariable [_paramName,_paramValue];
				publicVariable _paramName;
				_paramsLoaded = true;
			} forEach ("true" configClasses (missionConfigFile >> "Params"));
		};
	} else {
		diag_log text "[F3] INFO (fn_processParamsArray.sqf): Parameters Array is not Nil";
		{
			_paramName =(configName ((missionConfigFile >> "Params") select _forEachIndex));
			diag_log text format["[F3] INFO (fn_processParamsArray.sqf): paramsArray parsing %1 (%2).",_paramName,_x];
			_paramCode = (getText (missionConfigFile >> "Params" >> _paramName >> "code"));
			_code = format[_paramCode, _x];
			try {
				call compile _code;
			} catch {
				diag_log text format["[F3] ERROR (fn_processParamsArray.sqf): Error compiling code in %1.",_paramName];
			};
			missionNamespace setVariable [_paramName,_x];
			publicVariable _paramName;
			_paramsLoaded = true;
		} forEach paramsArray;
	};

	// Did the parameters get processed?
	if (_paramsLoaded) then {
		// Mission authors get automatic debug mode in single-player.
		if isNil "f_param_debugMode" then { missionNamespace setVariable ["f_param_debugMode",0, true] };
		if (profileName == missionNamespace getVariable["f_debugProfile","2600K"]) then { missionNamespace setVariable ["f_param_debugMode",1]; };
			
		// Medical Settings
		private _medicalVar = missionNamespace getVariable["f_param_medical",-1];
		
		// ACE overrides all if present
		if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {
			missionNamespace setVariable ["f_var_medical_level",2,true];
		} else {
			switch (_medicalVar) do {
				case 0: {
					// Vanilla Selected
					missionNamespace setVariable ["f_var_medical_level",0,true];
				};
				case 1: {
					// Farooq Revive Selected
					if (getMissionConfigValue ["ReviveMode",0] != 0) then {
						diag_log text "[F3] ERROR (fn_processParamsArray.sqf): BIS Revive is enabled, cannot enable Farooq.";
						missionNamespace setVariable ["f_var_medical_level",0,true];
					} else {
						missionNamespace setVariable ["f_var_medical_level",1,true];
					};
				};
				default {
					// Use Vanilla if not a coop mission or using BIS Revive.
					if ((toUpper (getText ((getMissionConfig "Header") >> "gameType")) == "COOP") && (getMissionConfigValue ["ReviveMode",0] == 0)) then {
						missionNamespace setVariable ["f_var_medical_level",1,true];
					} else {
						missionNamespace setVariable ["f_var_medical_level",0,true];
					};
				};
			};
		};
		
		// Auto-detect Radio Type
		if (isNil "f_param_radios") then {
			if ("task_force_radio" in activatedAddons) then {
				missionNamespace setVariable ["f_param_radios",1,true]; // TFAR Radio
			} else { 
				if ("acre_main" in activatedAddons) then {
					missionNamespace setVariable ["f_param_radios",2,true]; // ACRE Radio
				} else { 
					missionNamespace setVariable ["f_param_radios",0,true]; // Vanilla Radio
				};
			};
		};
			
		// Add Zeus administrators for client-side comparison
		if (!isNil "ZEU_ADMIN_fGetPlayerRegister") then {
			_playerRegister = [] call ZEU_ADMIN_fGetPlayerRegister;
		
			// Make sure array was returned
			if (_playerRegister isEqualType []) then {
				if (count _playerRegister > 1) then {
					missionNamespace setVariable ["f_zeusAdminNames",(_playerRegister select 1),true];
				};
			};
		};
		
		// Load and send all groups to clients
		#include "..\..\mission\groups.sqf";
		
		// Older FW Support
		if (!isNil "_grpBLU") then { f_var_groupsWEST = _grpBLU };
		if (!isNil "_grpOPF") then { f_var_groupsEAST = _grpOPF };
		if (!isNil "_grpIND") then { f_var_groupsGUER = _grpIND };
		if (!isNil "_grpCIV") then { f_var_groupsCIVILIAN = _grpCIV };
		
		{ missionNamespace setVariable [format["f_var_groups%1", _x], missionNamespace getVariable [format["f_var_groups%1", _x],[]], true] } forEach [west, east, independent, civilian];
		
		// Let the client know params are set.
		if (_paramsLoaded) then {
			missionNamespace setVariable ["f_var_setParams",true,true]; 
			
			if (missionNamespace getVariable["f_param_debugMode",0] == 1) then { 
				diag_log text format["[F3] DEBUG (fn_processParamsArray.sqf): f_var_setParams: %1",f_var_setParams];
			};
		};
	};
};