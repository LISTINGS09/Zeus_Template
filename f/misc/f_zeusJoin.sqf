// [] execVm "f\misc\f_zeusJoinButtons.sqf";
if ("task_force_radio" in activatedAddons || "acre_main" in activatedAddons) exitWith {};

player createDiarySubject ["ZEU_TS","* JOIN US *"];

f_fnc_displayZeusButtons = {	
	disableSerialization;
	params[ "_ctrl", "_index" ];
	
	private _display = ctrlParent _ctrl;
	private _diarySubList = _display displayCtrl 1002;
	
	//systemChat format["M: %1 %2", _ctrl lbText _index, _index];

	if ((_ctrl lbText _index) isEqualTo "* JOIN US *") then {
		if (isNull (_display displayCtrl 10101)) then {
			ctrlPosition _diarySubList params[ "_entryX", "_entryY", "_entryW", "_entryH" ];
			
			private _btn = _display ctrlCreate [ "ZEU_TS_BTN1", 10101 ];			
			_btn ctrlSetPosition [ _entryX, _entryY ];
			_btn ctrlCommit 0;
			
			_btn = _display ctrlCreate [ "ZEU_TS_BTN2", 10102 ];
			_btn ctrlSetPosition[ _entryX, _entryY + 0.05 ];
			_btn ctrlCommit 0;
		};
	} else {
		if !(isNull (_display displayCtrl 10101)) then { { ctrlDelete (_display displayCtrl _x) } forEach [10101,10102] };
	};
};

// Create initial EH
((uiNamespace getVariable "RscDiary") displayCtrl 1001) ctrlAddEventHandler [ "LBSelChanged", "_this call f_fnc_displayZeusButtons"];

if (time > 1) exitWith {};

[] spawn { 
	// Wait until we're in-game to create IDD 12 EH
	waitUntil { uiSleep 0.5; !isNull findDisplay 12 };

	((uiNamespace getVariable "RscDiary") displayCtrl 1001) ctrlAddEventHandler [ "LBSelChanged", "_this call f_fnc_displayZeusButtons"];
};