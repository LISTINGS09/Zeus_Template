_alphadistance = 20;

{
	if (freelook) then {_alphadistance = 50};
	_dist = (player distance _x) / _alphadistance;
	_color = [1,1,1,1];
	_color2 = [1,0.75,0,1];
	_icon = format ["a3\Ui_f\data\GUI\Cfg\Ranks\%1_gs.paa",rank _x];

	if (_x getvariable "#leader") then
	{
		_color = [1,0.75,0,1];
		_color2 = [1,1,1,1];
		_icon = "a3\Ui_f\data\GUI\Cfg\Ranks\general_gs.paa";
	};

	if (_x getvariable "talking") then
	{
		_icon = selectrandom ["A3\Ui_f\data\GUI\Rsc\RscDisplayArsenal\voice_ca.paa"];
	};

	_trans = 1 - _dist;
	
	if (_trans > 0.1) then {
		_color set [3, _trans];
		_color2 set [3, _trans];

		drawIcon3D [_icon, _color, [( visiblePosition _x) select 0, ( visiblePosition _x) select 1, 2.2] , 1, 1, 2,"", 1, 0.03, "PuristaMedium"];
		drawIcon3D
		[
		"",
		_color,
		[( visiblePosition _x) select 0, ( visiblePosition _x) select 1, 2.2],
		2,
		-1.40,
		0,
		name _x,
		1,
		0.05,
		"PuristaBold",
		"Right"
		];

		drawIcon3D
		[
		"",
		_color2,
		[( visiblePosition _x) select 0, ( visiblePosition _x) select 1, 2.2],
		2,
		0.20,
		0,
		getText (configfile >> "CfgVehicles" >> typeOf (vehicle _x) >> "displayName"),
		2,
		0.03,
		"PuristaBold",
		"Right"
		];
	};
} forEach ((allPlayers - [player]) select {alive _x && side group _x == side group player && (vehicle _x == _x || (effectiveCommander (vehicle _X))== _x)});