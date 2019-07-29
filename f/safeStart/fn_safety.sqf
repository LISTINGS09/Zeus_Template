// F3 - Safe Start, Safety Toggle
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
//=====================================================================================

//Exit if server
if isDedicated exitWith {};

switch (_this select 0) do {
	//Turn safety on
	case true: {
		[] spawn {
			sleep 0.1;
			
			// Put down weapon
			if (vehicle player == player && primaryWeapon player != "") then {
				player switchMove "AmovPercMstpSlowWrflDnon";
			};
		};

		// Make player invincible
		player allowDamage false;
		{ _x allowDamage false; } forEach switchableUnits;
	};

	//Turn safety off
	case false; default {
		// Make player vulnerable
		player allowDamage true;
		{ _x allowDamage true; } forEach switchableUnits;
	};
};