//////////////////////////////
//    Dynamic-AI-Creator    //
//    Version 3.1b - 2014   //
//--------------------------//
//    DAC_Change_Zone       //
//--------------------------//
//    Script by Silola      //
//    silola@freenet.de     //
//////////////////////////////

if(DAC_Code > 1) exitWith {};

private ["_zone","_pos","_size","_uc","_bc","_wc","_c","_a","_mS","_mP","_mU","_zoneLoc","_action","_dd"];

_zone = _this select 0;_pos = _this select 1;_size = _this select 2;_uc = _this select 3;_action = true;_dd = 0;
_bc = _this select 4;_wc = _this select 5;_c = 0;_mS = [];_mP = [];_mU = [];_a = [];_zoneLoc = objNull;

if(isServer) then
{
	if(DAC_NewZone == 0) then
	{
		DAC_NewZone = 1;
		waitUntil{DAC_Basic_Value > 0};
		if(format["%1",_zone] == scalar) then
		{
			hintc "Error: DAC_Change_Zone > No valid zone";
		}
		else
		{
			while {_c < count DAC_Zones} do
			{
				_a = DAC_Zones select _c;
				if((call compile (_a select 0)) == _zone) then
				{
					_mP = getMarkerPos ((_a select 9) select 0);
					_mS = getMarkerPos ((_a select 9) select 1);
					_mU = getMarkerPos ((_a select 9) select 2);
					_c = ((count DAC_Zones) + 1);
				}
				else
				{
					_c = _c + 1;
				};
			};
			if(count _mP > 0) then
			{
				if(_uc > 0) then
				{
					((_a select 9) select 2) setMarkerPosLocal [_uc,(_mU select 1)];
					_mU = getMarkerPos ((_a select 9) select 2);
					if((DAC_Com_Values select 0) > 0) then
					{
						systemChat format["Set new UnitConfig to zone [%1] = %2",round (getPosATL _zone select 0),_uc];
					};
				};
				if(_bc > 0) then
				{
					((_a select 9) select 2) setMarkerPosLocal [(_mU select 0),_bc];
					if((DAC_Com_Values select 0) > 0) then
					{
						systemChat format["Set new BehaviourConfig to zone [%1] = %2",round (getPosATL _zone select 0),_bc];
					};
				};
				if(((count _pos) < 3) && ((count _size) < 3)) exitWith {};
				if((count _pos) < 3) then {_pos = [((position _zone) select 0),(((position _zone) select 1) + 0.01),0]};
				if((count _size) < 3) then
				{
					_size = [((triggerArea _zone) select 0),((triggerArea _zone) select 1),((triggerArea _zone) select 2)];
				}
				else
				{
					if((triggerArea _zone) select 3) then
					{
						if(((_size select 0) == 0) && ((_size select 1) == 0)) then
						{
							_size set[0, ((triggerArea _zone) select 0)];
							_size set[1, ((triggerArea _zone) select 1)];
						};
					}
					else
					{
						if(((triggerArea _zone) select 0) == ((triggerArea _zone) select 1)) then
						{
							if(((_size select 0) == 0) && ((_size select 1) == 0)) then
							{
								_size set[0, ((triggerArea _zone) select 0)];
								_size set[1, ((triggerArea _zone) select 1)];
							}
							else
							{
								if((_size select 0) == 0) then
								{
									_size set[0, (_size select 1)];
								}
								else
								{
									_size set[1, (_size select 0)];
								};
							};
						}
						else
						{
							if((_size select 0) == 0) then {_size set[0, ((triggerArea _zone) select 0)]};
							if((_size select 1) == 0) then {_size set[1, ((triggerArea _zone) select 1)]};
						};
					};
					if((_size select 2) == 0) then {_size set[2, ((triggerArea _zone) select 2)]};
				};
				((_a select 9) select 1) setMarkerPosLocal [(_size select 0),(_size select 1)];
				_zone settriggerArea [(_size select 0), (_size select 1), (_size select 2), ((triggerArea _zone) select 3)];
				if(format["%1",_zone getVariable "DAC_ZoneLoc"] != "<NULL>") then
				{
					_zoneLoc = _zone getVariable "DAC_ZoneLoc";
					_zoneLoc setdirection (_size select 2);
				};

				[1,_zone,_pos,_size,_wc] spawn DAC_fNewWaypoints;
				_zone settriggertext "action";
				sleep 1;
				waitUntil {((({_x == 1} count DAC_Init_Counter) == 5))};
				DAC_NewZone = 0;
			}
			else
			{
				hintc "Error: DAC_Change_Zone > zone is disabled";
				DAC_NewZone = 0;
			};
		};
	}
	else
	{
		if((DAC_Com_Values select 0) > 0) then {systemChat "Any Zone action in procress. Please try again later."};
	};
};