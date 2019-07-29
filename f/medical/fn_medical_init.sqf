// F3 - Medical Systems Support initialisation
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================

// Wait for parameter to be initialised - NOTE: Not handled like other params!!
// f_param_medical - Chosen via Params
// f_var_medical_level - Sets the ACE3 Level (if any)
// We MUST wait for it in case ACE is running.
waitUntil{!isNil "f_var_setParams" && !isNil "f_var_medical_level"};

["fn_medical_init.sqf",format["Started for %1 (%2)", [player,"Server"] select isServer, f_var_medical_level],"DEBUG"] call f_fnc_logIssue;

// Vanilla.
if (f_var_medical_level == 0) exitWith {}; 

// Farooq Revive.
if (f_var_medical_level == 1) exitWith { 
	execVM "f\medical\FAR_revive\FAR_revive_init.sqf";
}; 	

// ACE
if (f_var_medical_level == 2) exitWith { 
	if hasInterface then {
		execVM "mission\ace\ace_clientInit.sqf"; 
		execVM "f\medical\ace\zeu_dogtagRespawn.sqf";
	};
	if isServer then { 
		// Iterate all the missions vehicles and convert their gear.
		{
			private _unit = _x;
			if (!(_unit getVariable ["f_var_assignGear_done", false]) && alive _unit) then {
				[_unit] spawn f_fnc_ace_medicalConverter;
				_unit setVariable ["f_var_assignGear_done",true];
			};
		} forEach vehicles;
	};
};