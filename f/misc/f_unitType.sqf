// [] execVM "f\misc\f_unitType.sqf";
disableSerialization;

_display = findDisplay 46 createDisplay "RscDisplayEmpty";
uiNamespace setVariable ['Z_RscSwitchType',_display];
_list = _display ctrlCreate ["RscListbox",1500];
_list ctrlSetPosition [-0.1,0.01,0.38793,0.444756]; // viable only for your screen. Try to use safeZone, GUI_GRID and/or pixelGrid variables instead
_list ctrlCommit 0;// no need for the short delay as the controls will start wherever their base defines are set

//_showSide = count (((switchableUnits + playableUnits) apply { side _x }) arrayIntersect ((switchableUnits + playableUnits) apply { side _x })) > 1;

// Icon, Type
_typeList = [
	["iconManOfficer",	 "co", 	"Commander"]
	,["iconManLeader", 	"dc",	"Squad Leader"]
	,["iconManMedic", 	"m",	"Medic"]
	,["iconManLeader", 	"ftl",	"Fire Team Leader"]
	,["iconManMG", 		"ar",	"Automatic rifleman"]
	,["iconMan", 		"aar",	"Ass. Automatic Rifleman"]
	,["iconManAT", 		"rat",	"Rifleman (AT)"]
	,["iconMan", 		"dm", 	"Designated Marksman"]
	,["iconManMG", 		"mmgg", "MG Gunner"]
	,["iconMan", 		"mmgag", "MG Assistant"]
	,["iconManAT",		"matg",  "AT Gunner"]
	,["iconMan", 		"matag", "AT Assistant"]
	,["iconManAT", 		"msamg", "SAM Gunner"]
	,["iconMan", 		"msamag","SAM Assistant"]
	,["iconMan", 		"sn", 	"Sniper"]
	,["iconMan", 		"sp", 	"Spotter"]
	,["iconManLeader", 	"vc", 	"Vehicle Commander"]
	,["iconManEngineer","vd", 	"Vehicle Crewman (Repair)"]
	,["iconManLeader", 	"pp", 	"Air Vehicle Pilot"]
	,["iconManEngineer","pcc", 	"Air Vehicle Crew (Repair)"]
	,["iconManEngineer","eng", 	"Engineer (Demo)"]
	,["iconManExplosive","engm","Engineer (Mines)"]
	,["iconMan", 		"uav", 	"UAV operator"]
	,["iconMan", 		"div", 	"Diver"]
	,["iconMan", 		"r ", 	"Rifleman"]
	,["iconMan", 		"gren", "Grenadier"]
];

{
	_x params ["_icon", "_type", "_name"];
	_index = _list lbAdd _name;
	_list lbSetData [_index, _type];
	_list lbSetPicture  [_index, (_icon call bis_fnc_textureVehicleIcon)];
} forEach _typeList;

_button = _display ctrlCreate ["RscButtonMenu",-1];
_button ctrlSetPosition [-0.1,0.5,0.4,0.07]; // see above
_button	ctrlCommit 0;
_button ctrlSetText "Select Loadout";

ctrlSetFocus _list;

_button ctrlAddEventHandler ["ButtonClick", {
	params ["_ctrl"];
	private _display = ctrlParent _ctrl;
	private _list = (uiNamespace getVariable 'Z_RscSwitchType') displayCtrl 1500;
	[_list lbData (lbCurSel _list), player] call f_fnc_assignGear;
	systemChat format["Loadout Selected: %1", _list lbText (lbCurSel _list)];
	_display closeDisplay 1;
}];