// F3 Zeus Support - Add Addons
// Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// ====================================================================================
if !(isServer) exitWith {};

params [["_unit",objNull],["_mode",[],["",true,[]]]];

private _curator = getAssignedCuratorLogic _unit;
if (isNull _curator) then { _curator = _unit; };

if (isNull _curator || typeOf _curator != "ModuleCurator_F") exitWith { format["[Zeus] Invalid Curator for %1", name _unit] remoteExec ["systemChat",_unit] };

// Decide which addons to add based on passed mode
_addons = [];

switch (typeName _mode) do {
	case "ARRAY": { _addons = _mode };
	case "STRING": {	
			if (_mode isEqualType "") then {
				if (_mode == "basic") then {
					// Load predefined basic modules
					_addons = ["A3_Data_F","A3_Data_F_Curator","A3_Functions_F_Curator","A3_Misc_F","A3_Modules_F_EPB","A3_Ui_F_Curator","A3_Modules_F_Curator","A3_Modules_F_Curator_Misc","CuratorOnly_Modules_F_Curator_Chemlights","CuratorOnly_Modules_F_Curator_Environment","CuratorOnly_Modules_F_Curator_Flares","CuratorOnly_Modules_F_Curator_Ordnance","CuratorOnly_Modules_F_Curator_Smokeshells","A3_Modules_F_Bootcamp","A3_Modules_F_Bootcamp_Misc"];
				} else {
					// Convert to array
					_addons = [_mode];
				};
			};
		};
	case "BOOL": {	
		if (_mode) then {
			// If true was passed, add all available addons to curator list
			_addons = "true" configClasses (configFile >> "CfgPatches") apply {configName _x} 
		} else {
			removeAllCuratorAddons _curator;
		};
	};
};

// Nothing to add!
if (count _addons == 0) exitWith {};

// Remove existing addons
if !(_mode isEqualType "") then { removeAllCuratorAddons _curator };
_curator addCuratorAddons (_addons select {isClass (configFile >> "cfgPatches" >> _x)});

format["[Zeus] Added %1 addons",count _addons] remoteExec ["systemChat",_unit];