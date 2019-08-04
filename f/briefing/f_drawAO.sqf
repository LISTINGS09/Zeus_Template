// Function by TinfoilHate rework by 2600K
// [] execVM "f_drawAO.sqf"
params [["_baseMarker","AOmarker",[""]], ["_coverSize",100,[0]], ["_colorBack","colorBlack",[""]], ["_colorFore","colorWhite",[""]]];

{ if (toLower _x == toLower _baseMarker) exitWith { _baseMarker = _x } } forEach allMapMarkers;

if (!hasInterface || getMarkerType _baseMarker == "") exitWith {};

private _baseMarkerDir = markerDir _baseMarker;
if (_baseMarkerDir > 360) then {_baseMarkerDir = (_baseMarkerDir mod 360)};
if (_baseMarkerDir < 0) then {_baseMarkerDir = (_baseMarkerDir mod 360) + 360};

// Set grid to nearest whole value
_baseMarkerPos = [(round ((getMarkerPos _baseMarker select 0) / 100)) * 100, (round ((getMarkerPos _baseMarker select 1) / 100)) * 100, 0];
_baseMarker setMarkerPosLocal _baseMarkerPos;
(getMarkerSize _baseMarker) params ["_baseSizeX","_baseSizeY"];

// Marker has missing value - Exit
if (_baseSizeX min _baseSizeY == 0) exitWith {};

private _screenSizeX = 0;
private _screenSizeY = 0;
private _coverHatch = "FDiagonal";

if ((_baseMarkerDir >= 45 && _baseMarkerDir <= 135) || (_baseMarkerDir >= 225 && _baseMarkerDir <= 315)) then {
		_screenSizeX = _baseSizeY + _coverSize;
		_screenSizeY = _baseSizeX + _coverSize;
	} else {
		_screenSizeX = _baseSizeX + _coverSize;
		_screenSizeY = _baseSizeY + _coverSize;
	};
if ((_baseMarkerDir >= 45 && _baseMarkerDir <= 90) || (_baseMarkerDir >= 225 && _baseMarkerDir <= 270)) then {_coverHatch = "BDiagonal"};

private _makeBorder = {
	params ["_mkrName","_mkrSizeX","_mkrSideY","_mkrPos"];
	private _tmpMkr = createMarkerLocal [_mkrName,_mkrPos];
	_tmpMkr setMarkerShapeLocal "RECTANGLE";
	_tmpMkr setMarkerSizeLocal [_mkrSizeX,_mkrSideY];
};

["zao_coverU",(_coverSize * 2) + _baseSizeX, _coverSize, _baseMarkerPos vectorAdd [0, (_baseSizeY + _coverSize), 0]] call _makeBorder;
["zao_coverD",(_coverSize * 2) + _baseSizeX, _coverSize, _baseMarkerPos vectorAdd [0, (_baseSizeY + _coverSize) * -1, 0]] call _makeBorder;
["zao_coverL",_coverSize, _baseSizeY, _baseMarkerPos vectorAdd [(_baseSizeX + _coverSize), 0, 0]] call _makeBorder;
["zao_coverR",_coverSize, _baseSizeY, _baseMarkerPos vectorAdd [(_baseSizeX + _coverSize) * -1, 0, 0]] call _makeBorder;

{
	_x setMarkerDirLocal _baseMarkerDir;
	_x setMarkerBrushLocal _coverHatch;
	_x setMarkerAlphaLocal 0.5;
	_x setMarkerColorLocal (getMarkerColor _baseMarker);
} forEach ["zao_coverU","zao_coverD","zao_coverL","zao_coverR"];

///// Mostly BIS Stuff Within /////
private _posX = _baseMarkerPos select 0;
private _posY = _baseMarkerPos select 1;
private _dir = 0;
private _sizeOut = 50000;
private _sizeBorder = (_screenSizeX max _screenSizeY) / 50;
private _colors = ["colorBlack","colorBlack",_colorBack,_colorFore,_colorBack,"colorBlack",_colorBack,_colorBack];

for "_i" from 0 to 270 step 90 do {
	private _sizeMarker = [_screenSizeX,_sizeOut] select ((_i / 90) % 2);
	private _dirTemp = _dir + _i;
	private _markerPos = [
		_posX + (sin _dirTemp * (_screenSizeX + _sizeOut)),
		_posY + (cos _dirTemp * (_screenSizeY + _sizeOut))
	];
	for "_m" from 0 to (count _colors - 1) do {
		private _marker = createMarkerLocal [format ["zao_zone_%1_%2",_i,_m],_markerPos];
		_marker setMarkerSizeLocal [_sizeMarker,_sizeOut];
		_marker setMarkerDirLocal _dirTemp;
		_marker setMarkerShapeLocal "rectangle";
		_marker setMarkerBrushLocal "solid";
		_marker setMarkerColorLocal (_colors select _m);
		if (_m == 5) then {
			_marker setMarkerBrushLocal "grid";
			_marker setMarkerSizeLocal [_sizeMarker,_sizeOut];
		};
	};

	//--- White borders
	_sizeMarker = [_screenSizeX,_screenSizeY + _sizeBorder * 2] select ((_i / 90) % 2);
	_sizeBorderTemp = _sizeBorder;
	_markerPos = [
		_posX + (sin _dirTemp * (_screenSizeX + _sizeBorderTemp)),
		_posY + (cos _dirTemp * (_screenSizeY + _sizeBorderTemp))
	];
	for "_m" from 0 to 7 do {
		private _marker = createMarkerLocal [format ["zao_border_%1_%2",_i,_m],_markerPos];
		_marker setMarkerSizeLocal [_sizeMarker,_sizeBorderTemp];
		_marker setMarkerDirLocal _dirTemp;
		_marker setMarkerShapeLocal "rectangle";
		_marker setMarkerBrushLocal "solid";
		_marker setMarkerColorLocal "colorWhite";
	};
};