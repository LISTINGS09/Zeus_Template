// By: 2600K
// Simple, fair mortar script. Only engages known targets.
// Usage - Put in INIT of artillery unit:
// _nul = [this] execVM "scripts\mortar.sqf";
params [["_mortar", objNull]];

if !(local _mortar) exitWith {};

sleep 1;

_minDelay = 200; // Minimum delay between missions (maximum is 2x value).
_closeDispersion = 50; // Target dispersion when < 300m from mortar.
_maxDispersion = 150; // Maximum target dispersion in meters.

while {alive _mortar && canFire _mortar} do {
	// Get target that is alive, in distance, known as enemy and not flying.
	_targetArr = (playableUnits + switchableUnits) select {alive _x && _x distance2D _mortar < 3500 && (side _mortar knowsAbout _x) >= 1 && isTouchingGround _x};
	_sleepTime = 5;
		
	// Fire rounds if we have targets.
	if (count _targetArr > 0) then {
	
		_target = selectRandom _targetArr;
	
		_tempSmoke = "SmokeShellRed" createVehicle (_target getPos [random 5, random 360]); 
		
		sleep 30;
	
		_dispersion = if (_mortar distance2D _target < 200) then {_closeDispersion} else {_maxDispersion};
		
		for "_i" from 0 to (6 + random 4) do {
			_firePos = _target getPos [random _dispersion, random 360];
			(effectiveCommander _mortar) commandArtilleryFire [_firePos, ((getArtilleryAmmo [vehicle _mortar])#0), 1];
			sleep 5;
		};
		
		// Mission complete, so wait a while.	
		_sleepTime = _minDelay + random _minDelay;
	};
	
	// Refill any spent ammo.
	_mortar setVehicleAmmo 1;
	
	// Wait for next mission.
	sleep _sleepTime;
};