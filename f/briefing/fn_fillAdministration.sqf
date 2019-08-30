/*
Author 2600K

FEATURE
Zeus - Auto-Administration Fill-in - Parses a bunch of parameters and puts them into the briefing,

RETURNS
DIARY HTML STRING

PARAMETERS
None
*/

waitUntil{!isNil "f_var_timeOfDay"; !isNil "f_var_missionLoaded"};

uiSleep 5;

params [["_diaryText", "", [""]]];

if (_diaryText == "") then { _diaryText = _diaryText + "<br/><font size='18' color='#80FF00'>ADMINISTRATION</font><br/>The following text has been auto-generated from the mission modules and parameters.<br/>" };

_diaryText = _diaryText + format["<br/>Framework Version: <font color='#00FFFF'>v%1</font><br/><br/>", missionNamespace getVariable ["f_var_version","0.00"]];

// ENVIRONMENT
_diaryText = _diaryText + "<br/><font size='18' color='#80FF00'>ENVIRONMENT</font>";

private _startTime = missionNamespace getVariable ["f_var_timeOfDay", daytime];
private _sunriseHr = 4;
private _sunriseMin = 40;
private _sunsetHr = 19;
private _sunsetMin = 10;

// CALCULATE SUNSET/SUNRISE
private _sunsetSunrise = date call BIS_fnc_sunriseSunsetTime;

if !(_sunsetSunrise in [[-1,0],[0,-1]]) then {
	_sunriseHr = floor (_sunsetSunrise select 0);
	_sunriseMin = floor (((_sunsetSunrise select 0) % 1) * 60);
	_sunsetHr = floor (_sunsetSunrise select 1);
	_sunsetMin = floor (((_sunsetSunrise select 1) % 1) * 60);
};

_diaryText = _diaryText + format["<br/>Start Time: <font color='#00FFFF'>%1:%2</font><br/>Sunrise: <font color='#FF0080'>%3:%4</font><br/>Sunset: <font color='#FF0080'>%5:%6</font><br/>",
		if (floor _startTime < 10) then { format["0%1", floor _startTime] } else { floor _startTime },
		if (floor ((_startTime - (floor _startTime)) * 60) < 10) then { format["0%1", floor ((_startTime - (floor _startTime)) * 60)] } else { floor ((_startTime - (floor _startTime)) * 60) },
		if (_sunriseHr < 10) then { format["0%1", _sunriseHr] } else { _sunriseHr },
		if (_sunriseMin < 10) then { format["0%1", _sunriseMin] } else { _sunriseMin },
		if (_sunsetHr < 10) then { format["0%1", _sunsetHr] } else { _sunsetHr },
		if (_sunsetMin < 10) then { format["0%1", _sunsetMin] } else { _sunsetMin }
	];

_diaryText = _diaryText + format["<br/>Fog: <font color='#00FFFF'>%1</font> <font color='#777777'>%2</font>",
		switch (floor (fog * 10)) do {
			case 0: { "Clear" };
			case 1: { "Light" };
			case 2: { "Medium" };
			case 3: { "Thick" };
			default { "Very Thick" };
		},
		fogParams
	];

_diaryText = _diaryText + format["<br/>Forecast: <font color='#00FFFF'>%1</font> <font color='#777777'>[%2]</font><br/>",
		switch (floor (overcast * 10)) do {
			case 0; case 1: { "Clear" };
			case 2; case 3: { "Light Cloud" };
			case 4: { "Overcast" };
			case 5: { "Light Rain" };
			case 6; case 7: { "Rain" };
			case 8; case 9: { "Heavy Rain" };
			default { "Storm" };
		},
		overcast
	];

// MARKERS
if (missionNamespace getVariable["f_param_groupMarkers",0] > 0) then {
	switch (f_param_groupMarkers) do {
		case 4;
		case 5: { 
			_diaryText = _diaryText + "<br/><br/><font size='18' color='#80FF00'>MARKERS</font>";
			_diaryText = _diaryText + "<br/>Group markers are displayed on the map for the <font color='#00FFFF'>Commander</font> only.<br/>"; 
		};
	};
};

// RADIOS
if (missionNamespace getVariable["f_param_radioMode", -1] >= 0) then {
	_diaryText = _diaryText + "<br/><br/><font size='18' color='#80FF00'>RADIOS</font>";
	
	_diaryText = _diaryText + format["<br/>Radio Mode: <font color='#00FFFF'>%1</font>", ["All Units","Restricted"] select f_param_radioMode];
	
	_diaryText = _diaryText + format["<br/>", ["Any unit can join and leave any listed channel in Signals.","Only units with radio backpacks or units inside radio carrying vehicles may join channels listed in Signals."] select f_param_radioMode];
};

// RESPAWN / JIP
_diaryText = _diaryText + "<br/><br/><font size='18' color='#80FF00'>JIP / RESPAWN</font>";

if (!isNil "f_param_respawn") then {
	if (f_param_respawn == 0) then {
		_diaryText = _diaryText + "<br/>Respawn is <font color='#00FFFF'>Disabled</font><br/>";
	} else {
		if (f_param_respawn <= 10) then {
			_diaryText = _diaryText + format["<br/>LIMITED TICKETS: <font color='#00FFFF'>%1</font><br/>",f_param_respawn];
		} else {
			if (f_param_respawn in [30,60]) then {
				_diaryText = _diaryText + format["<br/>RESPAWN TIMER: <font color='#00FFFF'>%1</font> Seconds<br/>",f_param_respawn];
			} else {
				_diaryText = _diaryText + format["<br/>WAVE RESPAWN: <font color='#00FFFF'>%1</font> Minutes<br/>",[f_param_respawn,"MM"] call BIS_fnc_secondsToString];
				_diaryText = _diaryText + "<br/>Spectating the game is a privilege, not a right! NEVER inform players of enemy locations in-game/after respawn etc.<br/>";
			};
		};
	};
};

if (missionNamespace getVariable["f_param_jipTeleport",0] > 0) then {
	switch (f_param_jipTeleport) do {
		case 1: { _diaryText = _diaryText + "<br/>JIP players have an <font color='#00FFFF'>Action Menu</font> available to teleport to their squad.<br/>"; };
		case 2: { _diaryText = _diaryText + "<br/>JIP players have a <font color='#00FFFF'>Flag Pole</font> at base to teleport to their squad.<br/>"; };
		case 3: { _diaryText = _diaryText + "<br/>JIP players may use either the <font color='#FF0080'>Action Menu</font> or <font color='#FF0080'>Flag Pole</font> at base to teleport to their squad.<br/>"; };
	};
};

// MEDICAL
_diaryText = _diaryText + "<br/><br/><font size='18' color='#80FF00'>MEDICAL</font>";

if (f_var_medical_level  > 0 && (getMissionConfigValue ["ReviveMode",0] == 0)) then {
	switch (f_var_medical_level) do {
		case 1: { // FAROOQ
			waitUntil{!isNil "FAR_var_ReviveMode"};
			
			_diaryText = _diaryText + "<br/>Medical Level: <font color='#00FFFF'><b>Revive</b></font><br/>";
			_diaryText = _diaryText + format["<br/><font color='#80FF00'>Settings</font>
			<br/>Medic Training: <font color='#00FFFF'>%1</font>
			<br/>Bleedout Timer: <font color='#00FFFF'>%2 Seconds</font>
			<br/>Instant Death: <font color='#00FFFF'>%3</font>
			<br/>
			<br/>A <font color='#FF0080'>FAK</font color> should be used to stabilize the injured and stop the bleed-out timer.
			<br/>%4%5%6
			<br/>",
			(["Medics ONLY","Everyone","Anyone carrying a Medkit"] select FAR_var_ReviveMode),
			FAR_var_BleedOut,
			["Off", "On"] select FAR_var_InstantDeath,
			["","Any critical hit will result in instant death for the player. "] select FAR_var_InstantDeath,
			["","A Medic may place a dead player in a Body Bag to respawn that player. "] select (FAR_var_RespawnBagTime > 0),
			["","Units should respawn at the nearest Medical Vehicle (if available). "] select FAR_var_SpawnInMedical];
			
		};
		
		case 2: { // ACE
			if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {		
				waitUntil{missionNamespace getVariable ["ace_common_settingsinitfinished",false]};	
			};
		
			_diaryText = _diaryText + "<br/>Medical Level: <font color='#00FFFF'><b>ACE</b></font><br/>";
			_diaryText = _diaryText + format["<br/><font color='#80FF00'>Settings</font>
			<br/>Medic Training: <font color='#00FFFF'>%1</font>
			<br/>Prevent Instant Death: <font color='#00FFFF'>%2</font>
			<br/>Damage Threshold: <font color='#00FFFF'>%3</font>
			<br/>",
			(["Anyone","Medic Basic","Medic Advanced"] select ace_medical_medicSetting),
			(["Off", "On"] select ace_medical_preventInstaDeath),
			ace_medical_playerdamagethreshold];
			
			// PAK OR NOT
			if (ace_medical_level == 2) then {
				if (ace_medical_useLocation_PAK != 4) then {
					_diaryText = _diaryText + format["<br/><font color='#80FF00'>Personal First-Aid Kits (PAK)</font>
					<br/>%1 may use a PAK %2, %3. The PAK %4 be removed upon treatment.<br/>",
					(["Anyone","Any trained Medic","Doctors"] select ace_medical_medicSetting_PAK),
					(["anywhere","only in a medical vehicle","only at medical facility","in a medical vehicle/medical facility"] select ace_medical_useLocation_PAK),
					(["in any condition","only when stable"] select ace_medical_useCondition_PAK),
					(["will not", "will"] select ace_medical_consumeItem_PAK)];
				} else {
					_diaryText = _diaryText + "<br/><font color='#80FF00'>Personal First-Aid Kits (PAK)</font><br/>PAKs are not permitted.";
				};

				// SURGICAL KIT OR NOT
				if (ace_medical_useLocation_SurgicalKit != 4 && ace_medical_enableAdvancedWounds) then {
					_diaryText = _diaryText + format["<br/><font color='#80FF00'>Surgical Kits</font>
					<br/>%1 may use a Surgical Kit %2, %3. The Kit %4 be removed upon treatment.<br/>",
					(["Anyone","Any trained Medic","Doctors"] select ace_medical_medicSetting_SurgicalKit),
					(["anywhere","only in a medical vehicle","only at medical facility","in a medical vehicle/medical facility"] select ace_medical_useLocation_SurgicalKit),
					(["in any condition","only when stable"] select ace_medical_useCondition_SurgicalKit),
					(["will not", "will"] select ace_medical_consumeItem_SurgicalKit)];
				} else {
					_diaryText = _diaryText + format["<br/><font color='#80FF00'>Surgical Kits</font><br/>Wounds do not re-open -Surgical Kits are not %1.",(["required","permitted"] select ace_medical_enableAdvancedWounds)];
				};
			};
		};
	};
} else {
	_diaryText = _diaryText + format["<br/>Medical Level: <font color='#00FFFF'>Vanilla (%1)</font><br/>", (["No Revive", "Revive Enabled", "Custom Revive"] select (getMissionConfigValue ["ReviveMode",0]))];
};

// RETURN
_diaryText;