// F3 - Add TFR Radios Function
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================

// DECLARE VARIABLES
private["_radio1", "_radio2", "_radio3"];
private _typeofUnit = player getVariable ["f_var_assignGear", "NIL"];

// DEFINE THE RADIOS THAT WILL BE USED
switch (playerSide) do { //longrange, shortrange, rifradio
    case (west): {
      _radio1 = TFAR_DefaultRadio_Backpack_West;
      _radio2 = TFAR_DefaultRadio_Personal_West;	// Configurable
      _radio3 = TFAR_DefaultRadio_Rifleman_West;};	// Basic
    case (east): {
      _radio1 = TFAR_DefaultRadio_Backpack_East;
      _radio2 = TFAR_DefaultRadio_Personal_East;	// Configurable
      _radio3 = TFAR_DefaultRadio_Rifleman_East;};	// Basic
    default {
      _radio1 = TFAR_DefaultRadio_Backpack_Independent;
      _radio2 = TFAR_DefaultRadio_Personal_Independent;	// Configurable
      _radio3 = TFAR_DefaultRadio_Rifleman_Independent;};	// Basic
};

// ASSIGN RADIOS TO UNITS
// Depending on the loadout used in the assignGear component, each unit is assigned
// a set of radios.
private _fRadiosPersonal = missionNamespace getVariable ["f_radios_settings_personalRadio",["leaders"]];
private _fRadiosRifleman = missionNamespace getVariable ["f_radios_settings_riflemanRadio",["all"]];
private _fRadiosLongRange = missionNamespace getVariable ["f_radios_settings_longRangeUnits",["leaders"]];
private _isLeader = if (leader player == player) then [{true},{false}];

if(_typeofUnit != "NIL") then {
	// If radios are enabled...
	if (!f_radios_settings_disableAllRadios) then {
		private _hasRadio = false;
			
		// Assign radios by type (leaders always get good radio if enabled)
		if (_typeofUnit in _fRadiosPersonal || "all" in _fRadiosPersonal || (_isLeader && "leaders" in _fRadiosPersonal)) then {
			player linkItem _radio2;
			_hasRadio = true;
		} else {
			if (_typeofUnit in _fRadiosRifleman || "all" in _fRadiosRifleman || (_isLeader && "leaders" in _fRadiosRifleman)) then {
				player linkItem _radio3;
				_hasRadio = true;
			};
		};

		// Give out LR backpacks according to radios.sqf.
		if (_typeofUnit in _fRadiosLongRange || "all" in _fRadiosLongRange || (_isLeader && "leaders" in _fRadiosLongRange)) then {
			if (_isLeader) then {
				private _backpackItems = backpackItems player;
				private _config = configFile >> "CfgVehicles" >> (backpack player);
				
				// Only remove the backpack if it isn't a portable weapon. 
				if (getNumber (_config >> "maximumLoad") > 0) then { removeBackpack player; };
				player addBackpack _radio1;
				{ player addItemToBackpack _x; } forEach _backpackItems;
			};
		};
	  
		// SET DEFAULT RADIO CHANNEL
		// Was the radio assigned and configured in briefing?
		if (_hasRadio && !isNil "f_tfar_localSRfreq") then {
			[] spawn {
				waitUntil { uiSleep 0.5; player call TFAR_fnc_haveSwRadio; };
				
				uiSleep 0.1;
				
				[(call TFAR_fnc_activeSwRadio), str f_tfar_localSRfreq] call TFAR_fnc_setSwFrequency;
				player groupChat format[ "Radio Channel #1 set to %1Mhz (%2)", f_tfar_localSRfreq, groupId (group player)];
			};
		};
	};
};