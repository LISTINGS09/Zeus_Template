// Zeus - Client Intro
// Client Intro format ["Test Line 1","Test Line 2"] execVM "f\common\f_clientIntro.sqf";
// If left blank will default to Mission Name and players nearest location.
// ====================================================================================
params [["_lineOne",briefingName],["_lineTwo","Undisclosed Location"]];

sleep 0.1;

titleCut ["", "BLACK IN", 2];
"dynamicBlur" ppEffectEnable true;
"dynamicBlur" ppEffectAdjust [6];
"dynamicBlur" ppEffectCommit 0;
"dynamicBlur" ppEffectAdjust [0.0];
"dynamicBlur" ppEffectCommit 7;

if (_lineTwo == "Undisclosed Location") then {
	private ["_nearLoc"];
	
	// player call BIS_fnc_locationDescription ??
	_nearLoc = (nearestLocations [getPosATL player, ["NameCityCapital","NameCity","NameVillage","NameLocal"], 1000]); 
	
	if (count _nearLoc > 0) then { 
		private ["_dist"];
		
		_dist = position player distance (_nearLoc select 0);
		
		if (_dist < 200) then {
			_lineTwo = format["%1 - %2 %3",toUpper worldName,(selectRandom ["At","On","Beside","Next to","Passing"]),text(_nearLoc select 0)]; 
		} else {
			_lineTwo = format["%1 - %2 %3",toUpper worldName,(selectRandom ["Nearby","Close to","Outside","Near","Not far from","Nearing"]),text(_nearLoc select 0)]; 
		};
	};
};

sleep 15;

private _monthName = switch (date select 1) do {
    case 1: { "Jan" };
    case 2: { "Feb" };
	case 3: { "Mar" };
	case 4: { "Apr" };
	case 5: { "May" };
	case 6: { "Jun" };
	case 7: { "Jul" };
	case 8: { "Aug" };
	case 9: { "Sep" };
	case 10:{ "Oct" };
	case 11:{ "Nov" };
    default { "Dec" };
};

[
	[
		_lineOne  + " by " + getText (getMissionConfig "Author"),
		1, 
		5
	],
	[
		format["%1-%2-%3   %4",date select 2,_monthName,date select 0,[daytime,"HH:MM:SS"] call BIS_fnc_timeToString], 
		1, 
		10
	],
	[
		_lineTwo,
		1, 
		1, 
		10
	]
] spawn BIS_fnc_EXP_camp_SITREP;