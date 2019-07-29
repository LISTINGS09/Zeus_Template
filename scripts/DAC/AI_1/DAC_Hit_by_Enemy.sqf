//////////////////////////////
//    Dynamic-AI-Creator    //
//    Version 3.1b - 2014   //
//--------------------------//
//    DAC_Hit_by_Enemy      //
//--------------------------//
//    Script by Silola      //
//    silola@freenet.de     //
//////////////////////////////

private ["_target","_fireman","_egroup"];

_target = _this select 0;_fireman = _this select 1;_egroup = group _target;

if((!(_fireman == _target)) && (!(isNull _fireman)))  then
{
	if((({alive _x} count units _egroup) == 0) || (_egroup in DAC_Radio_Groups) || (format["%1",side _target] == "civ") || ((side _fireman) == (side _target))) exitWith {};
	if(!(_fireman in DAC_Fire_Pos)) then {DAC_Fire_Pos pushBack _fireman};
	if(!(_egroup in DAC_Hit_Groups)) then {DAC_Hit_Groups pushBack _egroup};
	if(_egroup in DAC_Fire_Groups) then {DAC_Fire_Groups = DAC_Fire_Groups - [_egroup]};
	if(_egroup in DAC_Help_Groups) then {DAC_Help_Groups = DAC_Help_Groups - [_egroup]};
	if(({alive _x} count units _egroup) >= (DAC_AI_Level * 2)) exitWith {};
	if(!(_egroup in DAC_Radio_Groups)) then {DAC_Radio_Groups pushBack _egroup};
	[_target,_egroup,_fireman] spawn DAC_fCallHelp;
};