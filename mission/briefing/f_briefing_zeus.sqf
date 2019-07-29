// F3 - Briefing - Credits: Please see the F3 online manual http://www.ferstaberinde.com/f3/en/
// <marker name='XXX'>XXX</marker>
// Green #72E500
// Orange #FF7F00
// Blue #0080FF

if (isNil "f_param_CasualtiesCap") then { f_param_CasualtiesCap = 100 }; // Set CasCap if author did not.

// The code below creates the administration sub-section of notes.
_adm = player createDiaryRecord ["Diary", ["Administration",[] call f_fnc_fillAdministration]];

// The code below creates the execution sub-section of notes.
_mis = player createDiaryRecord ["Diary", ["Mission","
<br/><font size='18' color='#FF7F00'>OBJECTIVES</font>
<br/>*** Insert the mission here. ***
<br/>
"]];