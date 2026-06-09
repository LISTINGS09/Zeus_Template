// TRIGGER SECTION
private _zqrfText = "<font size='18' color='#80FF00'>Zeus QRF (ZQRF)</font><br/>";

_zqrfText = _zqrfText + format["Version: %1", (missionNamespace getVariable  ["ZQR_version","Not Running!"])] + "<br/><br/>";

if (!isNil "TR_QRF") then {
	// Execute script on server;
};

/*
_zqrfText = _zqrfText + "<br/><font color='#80FF00'>AI SKILL</font><br/>Set Unit Skill<br/>
<execute expression=""systemChat 'ZAU - Script Disabled'; { ZAU_Loop = false } remoteExec ['BIS_fnc_spawn', 0];"">Disable ZAU</execute> | 
<execute expression=""systemChat 'ZAU - Script Starting'; { [] execVM 'scripts\z_ambientUnits.sqf' } remoteExec ['BIS_fnc_spawn', 0];"">Enable ZAU</execute><br/>
<execute expression=""if (isNil 'ZAU_UnitsActive') then { { missionNamespace setVariable ['ZAU_UnitsActive', 0, true] } remoteExec ['BIS_fnc_spawn', 0]; } else { systemChat format['ZAU Active Units: %1',ZAU_UnitsActive] };"">Count Active Units</execute><br/>
";*/

player createDiaryRecord ["ZeuAdmin", ["Script - QRF",_zqrfText]];