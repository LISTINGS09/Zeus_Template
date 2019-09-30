params [["_issueScript","Unknown",[""]], ["_issueText","---",[""]], ["_level","WARNING"]];

if (isNil "f_var_missionLog") then { f_var_missionLog = []; };

if !(toUpper _level in ["INFO","DEBUG"]) then {
	_text = format["<font color='#72E500'>%1</font>: %2",_issueScript,_issueText];
	f_var_missionLog pushBackUnique [_issueScript,_issueText];
};

if (missionNamespace getVariable["f_param_debugMode",0] == 1 || toUpper _level != "DEBUG") then {
	diag_log text format["[F3] %1 (%2) - %3", _level, _issueScript, _issueText];
};
	
true