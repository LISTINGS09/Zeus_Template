// [] execVm "f\misc\f_teleportPlayer.sqf";
disableSerialization;

_display = findDisplay 46 createDisplay "RscDisplayEmpty";
uiNamespace setVariable ['Z_RscTeleport',_display];
_list = _display ctrlCreate ["RscListbox",1500];
_list ctrlSetPosition [-0.3,0.02,0.48793,0.744756]; // viable only for your screen. Try to use safeZone, GUI_GRID and/or pixelGrid variables instead
_list ctrlCommit 0;// no need for the short delay as the controls will start wherever their base defines are set

//_showSide = count (((switchableUnits + playableUnits) apply { side _x }) arrayIntersect ((switchableUnits + playableUnits) apply { side _x })) > 1;

_units = (switchableUnits + playableUnits) apply { [str side group _x, groupId group _x, name _x, getPlayerUID _x] };
_units sort true;

{
	_x params ["_side", "_group", "_name", "_id"];
	_index = _list lbAdd format["%1: %2", _group, _name];
	_list lbSetData [_index, _id];

	switch (_side) do {
		case "WEST": {
			_list lbSetPicture  [_index, "\a3\Ui_f\data\Map\Markers\NATO\o_unknown.paa"];
			_list lbSetPictureColor [_index, [0, 0.3, 0.6, 1]];
		};
		case "EAST": {
			_list lbSetPicture  [_index, "\a3\Ui_f\data\Map\Markers\NATO\b_unknown.paa"];
			_list lbSetPictureColor [_index, [0.5, 0, 0, 1]];
		
		};
		case "GUER": {
			_list lbSetPicture  [_index, "\a3\Ui_f\data\Map\Markers\NATO\n_unknown.paa"];
			_list lbSetPictureColor [_index, [0, 0.5, 0, 1]];
		};
		default {
			_list lbSetPicture  [_index, "\a3\Ui_f\data\Map\Markers\NATO\n_unknown.paa"];
			_list lbSetPictureColor [_index, [0.5, 0, 0.5, 1]];
		};
	};
} forEach _units;

_button = _display ctrlCreate ["RscButtonMenu",-1];
_button ctrlSetPosition [0.625,0.2,0.423497,0.276817]; // see above
_button	ctrlCommit 0;
_button ctrlSetText "Name of player";
_button ctrlAddEventHandler ["ButtonClick",{
	params ["_button"];
	_list = (uiNamespace getVariable 'Z_RscTeleport') displayCtrl 1500;
	_name = _list lbText (lbCurSel _list);
	_object = _list lbData (lbCurSel _list);
	hint format["Name: %1 ID: %2", _name, _object];
}];
