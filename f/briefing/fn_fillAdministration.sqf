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

_diaryText = _diaryText + format["<br/>Framework Version: <font color='#00FFFF'>v%1</font><br/>%2<br/>",
	missionNamespace getVariable ["f_var_version","0.00"],
	if (!isNil "ZMM_Version") then { format["ZMM Version: <font color='#00FFFF'>v%1</font><br/>", missionNamespace getVariable ["ZMM_Version","0.00"]] } else { "" }
];

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

_diaryText = _diaryText + format["<br/>Start Time: <font color='#00FFFF'>%1:%2</font>%7<br/>Sunrise: <font color='#FF0080'>%3:%4</font><br/>Sunset: <font color='#FF0080'>%5:%6</font><br/>",
		if (floor _startTime < 10) then { format["0%1", floor _startTime] } else { floor _startTime },
		if (floor ((_startTime - (floor _startTime)) * 60) < 10) then { format["0%1", floor ((_startTime - (floor _startTime)) * 60)] } else { floor ((_startTime - (floor _startTime)) * 60) },
		if (_sunriseHr < 10) then { format["0%1", _sunriseHr] } else { _sunriseHr },
		if (_sunriseMin < 10) then { format["0%1", _sunriseMin] } else { _sunriseMin },
		if (_sunsetHr < 10) then { format["0%1", _sunsetHr] } else { _sunsetHr },
		if (_sunsetMin < 10) then { format["0%1", _sunsetMin] } else { _sunsetMin },
		if (missionNamespace getVariable ["f_param_timeMultiplier", 1] > 1) then { format[" - Accelerated: 1 Day is %1 Hour(s)", round (24 / f_param_timeMultiplier)] } else { "" }
	];

_diaryText = _diaryText + format["<br/>Fog Density: <font color='#00FFFF'>%1</font> Baseline: <font color='#FF0080'>%2 Meters</font>",
		switch (floor (fog * 10)) do {
			case 0: { "Clear" };
			case 1: { "Light" };
			case 2: { "Medium" };
			case 3: { "Thick" };
			default { "Very Thick" };
		},
		round (fogParams # 2),
		fogParams
	];

_diaryText = _diaryText + format["<br/>Wind Direction: <font color='#00FFFF'>%1</font> Speed: <font color='#FF0080'>%2 mph</font> <font color='#FF0080'>%3 kph</font><br/>",
		["North", "North by North-East", "North-East", "East by North-East", "East", "East by South-East", "South-East", "South by South-East", "South", "South by South-West", "South-West", "West by South-West", "West", "West by North-West", "North-West", "North by North-West"] select (floor ((if (windDir > 360) then { windDir - 360} else { windDir }) + 11.25) / 22.5),
		round ((3.6 * sqrt ((wind#0)*(wind#0) + (wind#1)*(wind#1))) / 1.609344),
		round (3.6 * sqrt ((wind#0)*(wind#0) + (wind#1)*(wind#1))),
		windStr
	];

_diaryText = _diaryText + format["<br/>Forecast: <font color='#00FFFF'>%1</font><br/>",
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

_diaryText = _diaryText + format["View Distance: <font color='#00FFFF'>%1 meters</font>
		[<execute expression=""setViewDistance (viewDistance + 500); setObjectViewDistance (viewDistance + 100); systemChat ('Distance increased to ' + str viewDistance + 'm');"">Increase</execute>]
		[<execute expression=""setViewDistance (viewDistance - 500); setObjectViewDistance (viewDistance + 100); systemChat ('Distance decreased to ' + str viewDistance + 'm');"">Decrease</execute>]<br/>", 
		viewDistance
	];
		
if ((player getVariable ["f_var_assignGear","r"]) in ["pp","ppc","pc","uav"]) then {
	_diaryText = _diaryText + "Map Cover: <execute expression=""{ if (['zao_',_x] call BIS_fnc_inString) then { _x setMarkerAlphaLocal 0.1 } } forEach allMapMarkers;"">Hide</execute><br/>";
};

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
	
	_diaryText = _diaryText + format["<br/>Radio Mode: <font color='#00FFFF'>%1</font><br/>%2", 
		["All Units","Restricted"] select f_param_radioMode,
		["Any unit can join and leave any listed channel in Signals.","Only units with radio backpacks or units inside radio carrying vehicles may join channels listed in Signals."] select f_param_radioMode
	];
};

// RESPAWN / JIP
_diaryText = _diaryText + "<br/><br/><font size='18' color='#80FF00'>JIP / RESPAWN</font>";

if (!isNil "f_param_respawn") then {
	if (f_param_respawn == 0) then {
		_diaryText = _diaryText + format["<br/>Respawn is <font color='#00FFFF'>Disabled</font>%1<br/>", if (missionNamespace getVariable ["FAR_var_RespawnBagTime", 0] > 0) then { ", but you will respawn if your body is recovered by a medic." } else { "" } ];
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

if (missionNamespace getVariable ["f_var_medical_level", 0] > 0 && (getMissionConfigValue ["ReviveMode",0] == 0)) then {
	switch (f_var_medical_level) do {
		case 1: { // FAROOQ
			waitUntil{!isNil "FAR_var_ReviveMode"};
			
			_diaryText = _diaryText + "<br/>Medical Level: <font color='#00FFFF'><b>Zeus Revive</b></font><br/>";
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
			["","A Medic may place a dead player in a <font color='#FF0080'>Body Bag</font color> to respawn that player. "] select (FAR_var_RespawnBagTime > 0),
			["","Units should respawn at the nearest Medical Vehicle (if available). "] select FAR_var_SpawnInMedical];
			
			_diaryText = _diaryText + "<br/>Medical System <execute expression=""if (time > 0) then { call FAR_fnc_unitInit };"">Reinitialise</execute><br/><execute expression=""if (time > 0) then { call FAR_fnc_FixRagdoll };"">Ragdoll Fix</execute><br/>";
		};
		
		case 2: { // ACE
			if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {		
				waitUntil{missionNamespace getVariable ["ace_common_settingsinitfinished",false]};	
			};
		
			_diaryText = _diaryText + "<br/>Medical Level: <font color='#00FFFF'><b>ACE</b></font><br/>";
			_diaryText = _diaryText + format["<br/><font color='#80FF00'>Settings</font>
			<br/>Medic System: <font color='#00FFFF'>%1</font>
			<br/>Wound Reopening: <font color='#00FFFF'>%2</font>
			<br/>Damage Threshold: <font color='#00FFFF'>%3</font>
			<br/>",
			(["Basic","Advanced"] select (missionNamespace getVariable ["ace_medical_treatment_advancedMedication", false])),
			(["Off", "On"] select (missionNamespace getVariable ["ace_medical_treatment_woundReopening", false])),
			missionNamespace getVariable ["ace_medical_playerDamageThreshold", 1]];
			
			// PAK OR NOT
			if ((missionNamespace getVariable ["ace_medical_treatment_locationPAK", 0]) != 4) then {
				_diaryText = _diaryText + format["<br/><font color='#80FF00'>Personal First-Aid Kits (PAK)</font>
				<br/>%1 may use a PAK %2. The PAK %3 be removed upon treatment.<br/>",
				(["Anyone","Any trained Medic","Doctors"] select (missionNamespace getVariable ["ace_medical_treatment_medicPAK", 0])),
				(["anywhere","only in a medical vehicle","only at medical facility","in a medical vehicle/medical facility"] select (missionNamespace getVariable ["ace_medical_treatment_locationPAK", 0])),
				(["will not", "will"] select (missionNamespace getVariable ["ace_medical_treatment_consumePAK", 0]))];
			} else {
				_diaryText = _diaryText + "<br/><font color='#80FF00'>Personal First-Aid Kits (PAK)</font><br/>PAKs are not permitted.";
			};

			// SURGICAL KIT OR NOT
			if (missionNamespace getVariable ["ace_medical_treatment_woundReopening", false]) then {
				_diaryText = _diaryText + format["<br/><font color='#80FF00'>Surgical Kits</font>
				<br/>%1 may use a Surgical Kit %2. The Kit %3 be removed upon treatment.<br/>",
				(["Anyone","Any trained Medic","Doctors"] select (missionNamespace getVariable ["ace_medical_treatment_medicSurgicalKit", 0])),
				(["anywhere","only in a medical vehicle","only at medical facility","in a medical vehicle/medical facility"] select (missionNamespace getVariable ["ace_medical_treatment_locationSurgicalKit", 0])),
				(["will not", "will"] select (missionNamespace getVariable ["ace_medical_treatment_consumeSurgicalKit", 0]))];
			} else {
				_diaryText = _diaryText + "<br/><font color='#80FF00'>Surgical Kits</font><br/>Wounds do not re-open -Surgical Kits are not required.";
			};
		};
	};
} else {
	_diaryText = _diaryText + format["<br/>Medical Level: <font color='#00FFFF'>Vanilla (%1)</font><br/>", (["No Revive", "Revive Enabled", "Custom Revive"] select (getMissionConfigValue ["ReviveMode",0]))];
};

// RETURN
_diaryText;