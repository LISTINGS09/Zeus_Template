//////////////////////////////
//    Dynamic-AI-Creator    //
//    Version 3.1b - 2014   //
//--------------------------//
//    DAC_Set_Behaviour     //
//--------------------------//
//    Script by Silola      //
//    silola@freenet.de     //
//////////////////////////////

private ["_group","_target"];

_group = _this select 0;_target = _this select 1;

if(skill leader _group <= 0.3) then
{
	{vehicle _x setCombatMode "white"} forEach units _group;
	{vehicle _x setBehaviour "aware"} forEach units _group;
	{vehicle _x setSpeedMode "limited"} forEach units _group;
}
else
{
	if((skill leader _group > 0.3) && (skill leader _group <= 0.7)) then
	{
		{vehicle _x setCombatMode "yellow"} forEach units _group;
		{vehicle _x setBehaviour "combat"} forEach units _group;
		{vehicle _x setSpeedMode "normal"} forEach units _group;
	}
	else
	{
		{vehicle _x setCombatMode "red"} forEach units _group;
		{vehicle _x setBehaviour "stealth"} forEach units _group;
		{vehicle _x setSpeedMode "full"} forEach units _group;
	};
};
if(!(isNull _target)) then
{
	(units _group) commandTarget _target;
};