// F3 - Casualties Update
// Updates the respawn marker with colour-code or counter
// [group _this] remoteExecCall ["f_fnc_updateCas", 2];
// [east] remoteExecCall ["f_fnc_updateCas", 2];
params [["_group", civilian]];

{
	_x params ["_sideVar", "_markerVar"];

	// If only side was passed, correct the variables
	private _side = if (_group isEqualType west) then { _group } else { side _group };
	
	if (_side == _sideVar) exitWith {
		private _casVar = (missionNamespace getVariable [format["f_var_casualtyCount_%1",_sideVar], 0]) + 1;
		private _casCap = missionNamespace getVariable["f_param_CasualtiesCap", 80];
		missionNamespace setVariable [format["f_var_casualtyCount_%1", _sideVar], _casVar, true];
		
		// Change the respawn marker to reflect # of casualties.
		if (_casVar > _casCap * 0.5) then { _markerVar setMarkerColor "ColorOrange" };
		if (_casVar > _casCap * 0.7) then { _markerVar setMarkerColor "ColorRed" };
		
		if (missionNamespace getVariable["f_param_CasualtiesShow", false]) then { _markerVar setMarkerText format["Casualties: %1", _casVar] };
		
		if (_group isEqualType grpNull) then { _group setVariable ["f_var_casualtyCount", (_group getVariable ["f_var_casualtyCount",0]) + 1, true]; };
		
		true
	};
} forEach [
	[west, "respawn_west"],
	[east, "respawn_east"],
	[independent, "respawn_guerrila"],
	[civilian, "respawn_civilian"]
];

false