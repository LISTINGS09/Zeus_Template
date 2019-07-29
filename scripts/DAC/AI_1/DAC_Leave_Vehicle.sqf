//////////////////////////////
//    Dynamic-AI-Creator    //
//    Version 3.1b - 2014   //
//--------------------------//
//    DAC_Leave_Vehicle     //
//--------------------------//
//    Script by Silola      //
//    silola@freenet.de     //
//////////////////////////////

private ["_i","_group","_unit","_veh","_crew"];

_group = _this select 0;_i = 0;_unit = objNull;_veh = [];_crew = [];

{if(_x != vehicle _x) then {if(!((vehicle _x) in _veh)) then {_veh pushBack vehicle _x}}} forEach units _group;

if(count _veh > 0) then
{
	while {_i < count _veh} do
	{
		_unit = (_veh select _i);_crew = crew _unit;
		if(format["%1",gunner _unit] == "<NULL-object>") then
		{
			{unassignVehicle _x;[_x] orderGetIn false} forEach _crew;
		}
		else
		{
			{if((_x != gunner _unit) && (_x != driver _unit)) then {unassignVehicle _x;[_x] orderGetIn false}} forEach _crew;
		};
		_i = _i + 1;
	};
	[2,(leader _group)] spawn DAC_fAIRadio;
};