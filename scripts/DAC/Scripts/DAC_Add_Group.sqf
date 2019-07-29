//////////////////////////////
//    Dynamic-AI-Creator    //
//    Version 3.1b - 2014   //
//--------------------------//
//    DAC_Add_Group         //
//--------------------------//
//    Script by Silola      //
//    silola@freenet.de     //
//////////////////////////////

private ["_group","_art","_sea"];

_group = _this select 0;_art = _this select 1;_sea = _this select 2;

waitUntil{(DAC_Basic_Value > 0)};

if(!(_group in DAC_All_Groups)) then {DAC_All_Groups pushBack _group};
if(format["%1",side (leader _group)] == "WEST") then {{DAC_West_Units pushBack _x} forEach units _group};
if(format["%1",side (leader _group)] == "EAST") then {{DAC_East_Units pushBack _x} forEach units _group};
if(format["%1",side (leader _group)] == "GUER") then
{
	if(DAC_Res_Side == 0) then
	{
		{DAC_East_Units pushBack _x} forEach units _group;
	}
	else
	{
		{DAC_West_Units pushBack _x} forEach units _group;
	};
};
DAC_No_Support pushBack _group;
{_x addEventHandler ["hit",{_this spawn DAC_fHitByEnemy}]} forEach units _group;
[_group,_art,_sea] spawn DAC_fAddBehaviour;
if((DAC_Com_Values select 0) > 0) then {systemChat format["%1 was added to the DAC system",_group]};