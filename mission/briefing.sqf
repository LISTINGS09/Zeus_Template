// F3 - Briefing - Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// <marker name='XXX'>XXX</marker>
// Green #72E500
// Orange #FF7F00
// Blue #0080FF

if (isNil "f_param_CasualtiesCap") then { f_param_CasualtiesCap = 100 }; // Set CasCap if author did not.

// The code below creates the administration sub-section of notes.
_adm = player createDiaryRecord ["Diary", ["Administration",[] call f_fnc_fillAdministration]];

// Edit the if statement for different faction briefs.

if (side player != CIVILIAN) then {
	// The code below creates the execution sub-section of notes.
	_exe = player createDiaryRecord ["Diary", ["Mission",format["
	<br/><font size='18' color='#FF7F00'>OBJECTIVES</font>
	<br/>*** Insert the mission here. ***
	<br/>
	<br/>Ensure casualties are kept below %1 and %1&#37; of your force is not incapacitated.
	<br/>
	<br/><font size='18' color='#FF7F00'>SPECIAL TASKS</font>
	<br/>*** Insert instructions for specific units here. ***
	<br/>
	<br/><font size='18' color='#FF7F00'>FRIENDLY FORCES</font>
	<br/>*** Insert information about friendly forces here.***
	<br/>
	<br/><font size='18' color='#FF7F00'>ENEMY FORCES</font>
	<br/>*** Insert information about enemy forces here.***
	<br/>
	<br/><font size='18' color='#FF7F00'>CREDITS</font>
	<br/>Created by <font color='#72E500'>?</font color>
	<br/>
	<br/>A custom-made mission for ArmA 3 and Zeus Community
	<br/>http://zeus-community.net/
	<br/>
	",f_param_CasualtiesCap]]];
};