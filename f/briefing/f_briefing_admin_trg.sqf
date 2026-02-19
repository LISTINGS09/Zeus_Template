// TRIGGER SECTION
_missionTrigger = "<font size='18' color='#80FF00'>TRIGGER OPTIONS</font><br/><br/>This details all triggers in the mission and will allow them to be force-completed, deleted or resulting code executed on the server. Special syntax such as 'thisTrigger' when used in activation code, WILL NOT be functional if executing the code manually - The trigger should be force Activated instead.<br/>";

private _encodeText = {
	private _specialChars = [38, 60, 62, 34, 39]; //  & < > " '
	private _convertTo = [[38,97,109,112,59], [38,108,116,59], [38,103,116,59], [38,113,117,111,116,59], [38,97,112,111,115,59]]; //  &amp; &lt; &gt; &quot; &apos;
	private _chars = [];
	private "_i";

	{
		_i = _specialChars find _x;
		if (_i isEqualTo -1) then { _chars pushBack _x } else { _chars append (_convertTo select _i) };
	} forEach toArray param [0,"",[""]];

	toString _chars
};

	private _triggerList = (allMissionObjects "EmptyDetector" select { vehicleVarName _x != "" }) apply { str _x };
_triggerList = _triggerList select { _x find "_AIPATH_" < 0 };
_triggerList sort true;

{	// Trigger Check
	private _trg = missionNamespace getVariable _x;
	
	//diag_log text format["[F3] INFO (fn_moduleCheck.sqf): Checking Trigger %1 - %2",_x,typeOf _x];
	_missionTrigger = _missionTrigger + format["<br/><font size='16' color='#FF0080'>%1</font> - 
	<font color='#80FF00'><execute expression=""if !(triggerActivated %1) then { { if (!isNil '%1') then { %1 setTriggerStatements ['true',(triggerStatements %1)#1, (triggerStatements %1)#2] };} remoteExec ['BIS_fnc_spawn',2]; hintSilent 'Trigger %1 Activated'; } else { hintSilent 'Trigger %1 already Activated' };"">Activate</execute></font> 
	| <font color='#CF142B'><execute expression=""if (simulationEnabled %1) then {{ if (!isNil '%1') then { %1 enableSimulationGlobal false };} remoteExec ['BIS_fnc_spawn',2]; hintSilent 'Trigger %1 Disabled'} else { hintSilent 'Trigger %1 already Disabled' };"">Disable</execute></font> 
	| <font color='#808800'><execute expression=""if !(simulationEnabled %1) then { if (!isNil '%1') then { %1 enableSimulationGlobal true };} remoteExec ['BIS_fnc_spawn',2]; hintSilent 'Trigger %1 Enabled' } else { hintSilent 'Trigger %1 already Enabled' };"">Enable</execute></font>:<br/>", vehicleVarName _trg];
	if (triggerType _trg != "NONE") then { _missionTrigger = _missionTrigger + format["Type: <font color='#888888'>%1</font>", triggerType _trg] };
	if !(triggerActivation _trg isEqualTo ["NONE","PRESENT",false]) then { _missionTrigger = _missionTrigger + format["Activation: <font color='#888888'>%1</font><br/>", triggerActivation _trg] };
	if ((triggerStatements _trg)#0 != "true") then { _missionTrigger = _missionTrigger + format["Condition: <font color='#8888BB'>%1</font><br/>", [(triggerStatements _trg)#0] call _encodeText] };
	if ((triggerStatements _trg)#1 != "") then { _missionTrigger = _missionTrigger + format["On Activation - 
	<execute expression=""{ call compile ('thisTrigger = %2;' + ((triggerStatements %2)#1)); } remoteExec ['BIS_fnc_spawn',2]; hintSilent '%2 Code Executed (Server)';"">Exec Server</execute> 
	| <execute expression=""{ call compile ('thisTrigger = %2;' + ((triggerStatements %2)#1)); } remoteExec ['BIS_fnc_spawn',0]; hintSilent '%2 Code Executed (Global)';"">Exec Global</execute>:<br/>
	<font color='#88BB88'>%1</font><br/>", [(triggerStatements _trg)#1] call _encodeText, _trg] };
	if ((triggerStatements _trg)#2 != "") then { _missionTrigger = _missionTrigger + format["On Deactivation - 
	<execute expression=""{ call compile ('thisTrigger = %2;' + ((triggerStatements %2)#2)); } remoteExec ['BIS_fnc_spawn',2]; hintSilent '%2 Code Executed (Server)';"">Exec Server</execute> 
	| <execute expression=""{ call compile ('thisTrigger = %2;' + ((triggerStatements %2)#2)); } remoteExec ['BIS_fnc_spawn',0]; hintSilent '%2 Code Executed (Global)';"">Exec Global</execute>:<br/>
	<font color='#BB8888'>%1</font><br/>", [(triggerStatements _trg)#2] call _encodeText, _trg] };
 
} forEach _triggerList;

player createDiaryRecord ["ZeuAdmin", ["Mission Triggers",_missionTrigger]];