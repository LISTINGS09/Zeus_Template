private _zauText = "<font size='18' color='#80FF00'>Zeus Ambient Units (ZAU)</font><br/>";

_zauText = _zauText + format["Version: %1", (missionNamespace getVariable  ["ZAU_version","Not Running!"])] + "<br/><br/>";
_zauText = _zauText + "<br/>
<execute expression=""systemChat 'ZAU - Script Disabled'; { ZAU_Loop = false } remoteExec ['BIS_fnc_spawn', 0];"">Disable ZAU</execute> | 
<execute expression=""systemChat 'ZAU - Script Starting'; { [] execVM 'scripts\z_ambientUnits.sqf' } remoteExec ['BIS_fnc_spawn', 0];"">Enable ZAU</execute><br/>
<execute expression=""if (isNil 'ZAU_UnitsActive') then { { missionNamespace setVariable ['ZAU_UnitsActive', 0, true] } remoteExec ['BIS_fnc_spawn', 0]; } else { systemChat format['ZAU Active Units: %1',ZAU_UnitsActive] };"">Count Active Units</execute><br/>
";

/*	"ZAU_DistMax"
"ZAU_DistMin"
"ZAU_UnitsMax"
"ZAU_UnitsChance"
"ZAU_UnitsGarrison"
"ZAU_SleepTime" */

player createDiaryRecord ["ZeuAdmin", ["Script - ZAU",_zauText]];