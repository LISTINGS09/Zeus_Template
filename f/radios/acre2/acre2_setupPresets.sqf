// F3 - ACRE2 Preset Setup
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================

//Set the names for all the radios properly.
{	
	_x params ["_radioName","_radioField"];
	{
		private _lrSideGroups = missionNamespace getVariable [["f_radios_settings_acre2_lr_groups_%1",_x],[]];
		{			
			[_radioName, format["preset_%1",_side], _forEachIndex + 1, _radioField, _x select 0] call acre_api_fnc_setPresetChannelField;
		} forEach _lrSideGroups;
	} forEach [west, east, independent];
} forEach [["ACRE_PRC148", "label"], ["ACRE_PRC152", "description"], ["ACRE_PRC117F", "name"]];


//Set the names for all the radios properly.
/*{	
	private _radioName = _x select 0;
	private _radioField = _x select 1;

	{
		[_radioName, "default2", _forEachIndex + 1, _radioField, _x select 0] call acre_api_fnc_setPresetChannelField;
	} forEach f_radios_settings_acre2_lr_groups_west;

	{
		[_radioName, "default3", _forEachIndex + 1, _radioField, _x select 0] call acre_api_fnc_setPresetChannelField;
	} forEach f_radios_settings_acre2_lr_groups_east;

	{
		[_radioName, "default4", _forEachIndex + 1, _radioField, _x select 0] call acre_api_fnc_setPresetChannelField;
	} forEach f_radios_settings_acre2_lr_groups_guer;

} forEach [["ACRE_PRC148", "label"], ["ACRE_PRC152", "description"], ["ACRE_PRC117F", "name"]];*/