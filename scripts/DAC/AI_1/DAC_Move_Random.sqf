//////////////////////////////
//    Dynamic-AI-Creator    //
//    Version 3.1b - 2014   //
//--------------------------//
//    DAC_Move_Random       //
//--------------------------//
//    Script by Silola      //
//    silola@freenet.de     //
//////////////////////////////

private [
			"_garray","_group","_marker","_wparray","_groupid","_heloarray","_vehcargo","_leader","_helo","_EventList","_groupzone","_maxrad",
			"_exgroup","_nextpos","_target","_zonepos","_knowsabout","_landmodus","_maxwps","_hcrew","_rd","_flypos","_rdir","_id","_allZones",
			"_driver","_gunner","_zskill","_DAC_Arrays","_wait","_run","_go","_crew","_man","_dist","_jArray","_grouponfire","_posarray","_numarray",
			"_unitwait1","_unitwait2","_patrolon","_unitcombat","_unitbehav","_unitspeed","_unitheight","_maxweather","_oldskill","_wpCheck","_aTime",
			"_patrolX","_patrolY","_ActivZoneX","_ActivZoneY","_RandomX","_RandomY","_NewHeight","_movepos","_eventid","_newtarget","_mz",
			"_speedselect","_combatselect","_behavselect","_homepos","_callg","_call","_hport","_helip","_temppos","_sum","_inflight",
			"_rx","_ry","_rsin","_rcos","_allZones","_cdi","_firstwait","_chute"
		];

			_garray = _this select 0;_group = _garray select 0;_marker = _garray select 1;_posarray = _this select 1;_wparray = (_posarray select 0);_numarray = (_posarray select 1);
			_groupid = _this select 2;_heloarray = _this select 3;_vehcargo = _this select 4;_leader = leader _group;_helo = _this select 5;_exgroup = _group;_call = [];
			_movepos = position _leader;_nextpos = "logic" createVehicleLocal [0,0,0];_target = objNull;_zonepos = [];_eventid = _garray select 2;_wpCheck = [];_aTime = time;
			_knowsabout = ((DAC_KnowsAbout + 2) - ((skill _leader * 2) + 0.01));_temppos = position _leader;_landmodus = 0;_maxwps = 0;_RandomX = 0;_firstwait = 1;
			_hcrew = crew _helo;_driver = _leader;_gunner = objNull;_crew = [];_man = _leader;_jArray = [];_RandomY = 0;_patrolX = 0;_maxrad = (300 * (skill _leader));
			_zskill = [((getMarkerPos (_marker select 2)) select 1)] call DAC_fConfigBehav;_run = 1;_go = 1;_wait = 1;_unitwait1 = 0;_patrolY = 0;_chute = objNull;_patrolon = 0;
			_oldskill = ((getMarkerPos (_marker select 2)) select 1);_dist = 0;_unitwait2 = 0;_rdir = 0;_EventList = [];_newtarget = objNull;_NewHeight = 0;_mz = (_posarray select 3);
			_DAC_Arrays = ["DAC_Help_Groups","DAC_Hit_Groups","DAC_Fire_Groups","DAC_Radio_Groups","DAC_Cover_Groups","DAC_Call_Groups"];_hport = 0;_id = 0;_allZones = (_posarray select 2);
			_rd = 0;_callg = [];_helip = objNull;_sum = 0;_grouponfire = _group;_flypos = [0,0,0];_inflight = 0;_groupzone = call compile (_this select 6);_homepos = call compile (_wparray select 0);
			if(count _hcrew > 1) then {_gunner = gunner _helo};
			_rx = 0,_ry = 0;_rsin = [];_rcos = [];_speedselect = 0;_combatselect = 0;_behavselect = 0;_cdi = 0;

_group setVariable ["dacData",[0,(position _leader)],false];
		
while {_run > 0} do
{
	switch (_run) do
	{
		case 1:	{
					//-----------------------------
					//#start
					//-----------------------------
					if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case1",time]};
					if(_vehcargo == 1) then
					{
						waitUntil {((count crew _helo) > (count units _group))};
						sleep 0.1;
						{if(!(group _x == _group)) then {_exgroup = group _x}} forEach crew _helo;
					};
					sleep 3;
					waitUntil {((getDir DAC_StartDummy) > 170)};
					if(((getMarkerSize (_marker select 0)) select 0) <= 4) then
					{
						_run = 0;
					}
					else
					{
						if(_eventid > 0) then {_EventList = ((([_eventid] call DAC_fConfigEvents) select 3) select 1)};
						/*
						if(count _heloarray == 1) then
						{
							_zonepos = call compile (_heloarray select 0);
							_groupzone = call compile (_this select 6);
						}
						else
						{
							if((random 100) < _mz) then
							{
								_id = (random ((count _heloarray) - 1));_zonepos = call compile (_heloarray select _id);
							}
							else
							{
								_id = (1 + (random ((count _heloarray) - 2)));_zonepos = call compile (_heloarray select _id);
							};
							_groupzone = (_zonepos select 0);
						};
						*/
						waitUntil{DAC_NewZone == 0};
						sleep (random 1);
						_wpCheck = [[_wparray,_numarray,_allZones],_groupid] call DAC_fSumWaypoints;
						_sum = (_wpCheck select 1);_posarray = (_wpCheck select 0);_allZones = ((_wpCheck select 0) select 2);
						_wparray = ((_wpCheck select 0) select 0);
						if(((((_zskill select 7) select 5) select 0) + (((_zskill select 7) select 5) select 1)) == 0) then
						{
							_firstwait = 1;
						}
						else
						{
							_firstwait = ((((_zskill select 7) select 5) select 0) + random (((_zskill select 7) select 5) select 1));
						};
						if(((_zskill select 11) select 0) == 0) then {if(!(_group in DAC_No_Support)) then {DAC_No_Support pushBack _group}};
						_unitcombat = _zskill select 1;_unitbehav = _zskill select 2;_unitspeed = _zskill select 3;
						_unitheight = _zskill select 6;_maxweather = ((_zskill select 6) select 2);_hport = ((_zskill select 6) select 3);
						_unitwait1 = "(((_zskill select 7) select (_groupid - 1)) select 2)";
						_unitwait2 = "((((_zskill select 7) select (_groupid - 1)) select 0) + (random (((_zskill select 7) select (_groupid - 1)) select 1)))";
						{call compile format["if(_group in %1) then {%1 = %1 - [_group]}",_x]}forEach _DAC_Arrays;
						if(_hport == 1) then {_helip = "Land_HelipadEmpty_F" createVehicle [0,0,0]};
						_helo setfuel 1;
						{unassignVehicle _x;[_x] allowGetIn false;[_x] orderGetIn false}forEach [_driver,_gunner];[2,(leader _group)] spawn DAC_fAIRadio;
						sleep 3;
						_leader move [(position _helo Select 0) + (Sin (direction _helo) * 15),(position _helo Select 1) + (Cos (direction _helo) * 15),0];
						{_x setUnitPos "auto"}forEach [_driver,_gunner];_run = 2;
						sleep _firstwait;
					};
				};
		case 2:	{
					//-----------------------------
					//#firstwait
					//-----------------------------
					if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case2",time]};
					_go = 1;_wait = (time + (call compile _unitwait2));_patrolon = 0;
					while {_go > 0} do
					{
						if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case2 - while1",time]};
						sleep (1 + (random 1));
						if(((getMarkerSize (_marker select 0)) select 0) <= 4) then
						{
							deleteVehicle _nextpos;_run = 0;_go = 0;
						}
						else
						{
							_call = [_group,_leader,_marker,_helo,1] call DAC_fOtherConditions;
							if((count _call) > 0) then
							{
								_run = (_call select 0);_target = (_call select 1);_go = 0;
							}
							else
							{
								if((_vehcargo == 1) && (_go > 0)) then
								{
									if(_group in DAC_Cover_Groups) then {_go = 0;_wait = 0};
								};
								if(time > _wait) then {_go = 0};
								waitUntil{DAC_NewZone == 0};
								_wpCheck = [[_wparray,_numarray,_allZones],_groupid] call DAC_fSumWaypoints;
								_posarray = (_wpCheck select 0);_allZones = ((_wpCheck select 0) select 2);
								_wparray = ((_wpCheck select 0) select 0);
								if(_sum != (_wpCheck select 1)) then
								{
									_sum = (_wpCheck select 1);_numarray = _wparray call DAC_fWritePosition;
									[37,_groupid,_group,"P",player distance _leader] spawn DAC_fShowRadio;_go = 0;
								};
							};
						};
					};
					if(_run == 2) then
					{
						if(count _heloarray == 1) then
						{
							_zonepos = call compile (_heloarray select 0);
							_groupzone = call compile (_this select 6);
						}
						else
						{
							if((random 100) < _mz) then
							{
								_id = (random ((count _heloarray) - 1));_zonepos = call compile (_heloarray select _id);
							}
							else
							{
								_id = (1 + (random ((count _heloarray) - 2)));_zonepos = call compile (_heloarray select _id);
							};
							_groupzone = (_zonepos select 0);
						};
						{if(_x == _driver) then {_x assignAsDriver _helo;[_x] allowGetIn true;[_x] orderGetIn true} else {if(_x == _gunner) then {_x assignAsGunner _helo;[_x] allowGetIn true;[_x] orderGetIn true}}}forEach _hcrew;_run = 3;
						[1,(leader _group)] spawn DAC_fAIRadio;
						sleep 5;
					};
				};
		case 3:	{
					//-----------------------------
					//#RandomZone
					//-----------------------------
					if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case3",time]};
					_go = 1;if(_hport == 1) then {_helip setPos [0,0,0]};
					while {_go > 0} do
					{
						if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case3 - while1",time]};
						_patrolX = _zonepos select 1;_patrolY = _zonepos select 2;_maxwps = _zonepos select 3;
						if((triggerArea _groupzone) select 3) then
						{
							_rx = random (_patrolX * 2);_ry = random (_patrolY * 2);
							_rsin = [(position _groupzone Select 0) + (Sin (((triggerArea _groupzone) select 2) + 90) * ((-_patrolX) + _rx)),(position _groupzone Select 1) + (Cos (((triggerArea _groupzone) select 2) + 90) * ((-_patrolX) + _rx))];
							_rcos = [(_rsin Select 0) + (Sin ((triggerArea _groupzone) select 2) * ((-_patrolY) + _ry)),(_rsin Select 1) + (Cos ((triggerArea _groupzone) select 2) * ((-_patrolY) + _ry))];
							_RandomX = (_rcos Select 0);_RandomY = (_rcos Select 1);
						}
						else
						{
							_rx = random _patrolX;_ry = random 360;
							_rsin = [(position _groupzone Select 0) + (Sin (_ry) * (_rx)),(position _groupzone Select 1) + (Cos (_ry) * (_rx))];
							_RandomX = (_rsin Select 0);_RandomY = (_rsin Select 1);
						};
						_NewHeight = ((_unitheight select 0) + random ((_unitheight select 1) - (_unitheight select 0)));
						_nextpos setPos [_RandomX,_RandomY,0];
						if(([((getPosATL vehicle _leader) select 0),((getPosATL vehicle _leader) select 1),0] distance _nextpos) > 100) then {_go = 0;_run = 4};
						sleep 0.01;
					};
				};
		case 4:	{
					//-----------------------------
					//#setBehaviour
					//-----------------------------
					if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case4",time]};
					{_x setCombatMode (selectRandom _unitcombat)} forEach units _group;
					{_x setBehaviour (selectRandom _unitbehav)} forEach units _group;
					{_x setSpeedMode (selectRandom _unitspeed)} forEach units _group;
					if(!(isNull _gunner)) then {_gunner assignAsGunner _helo};
					_go = 1;
					while {_go > 0} do
					{
						if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case4 - while1 - %2 - %3",time,_helo,_driver]};
						sleep (1 + (random 1));
						if(({alive _x} count units _group) == 0) then {_run = 15;_go = 0};
						if(({_x in _helo} count units _group) == (count units _group)) then
						{
							_run = 5;_go = 0;
						}
						else
						{
							if(!(alive _driver)) then
							{
								{_x leaveVehicle _helo;unassignVehicle _x} forEach crew _helo;
								_run = 18;_go = 0;
							}
							else
							{
								if((speed _driver) < 1) then
								{
									_driver domove [(position _helo Select 0) + (Sin (direction _helo) * 15),(position _helo Select 1) + (Cos (direction _helo) * 15),0];
									sleep 1;
									_driver assignAsDriver _helo;[_driver] orderGetIn true;[_driver] allowGetIn true;
								};
							};
						};
					};
				};
		case 5:	{
					//-----------------------------
					//#dynamicmove
					//-----------------------------
					if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case5",time]};
					_group setVariable ["dacData",[0,position _nextpos],false];
					vehicle _leader flyinheight _NewHeight;
					vehicle _leader move position _nextpos;
					_go = 1;
					while {_go > 0} do
					{
						if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case5 - while1 - %2",time,_vehcargo]};
						sleep (1 + (random 1));
						_call = [_group,_leader,_marker,_helo,0] call DAC_fOtherConditions;
						if((count _call) > 0) then
						{
							_run = (_call select 0);_target = (_call select 1);_go = 0;
						}
						else
						{
							if(_vehcargo == 1) then
							{
								if(({alive _x} count units _group) > 0) then
								{
									if(_exgroup in DAC_Cover_Groups) then
									{
										_go = 0;_run = 11;
									}
									else
									{
										if(_group in DAC_Cover_Groups) then {_go = 0;_run = 11};
									};
								};
							};
							if(_go > 0) then
							{
								waitUntil{DAC_NewZone == 0};
								_wpCheck = [[_wparray,_numarray,_allZones],_groupid] call DAC_fSumWaypoints;
								_posarray = (_wpCheck select 0);_allZones = ((_wpCheck select 0) select 2);
								_wparray = ((_wpCheck select 0) select 0);
								if(_sum != (_wpCheck select 1)) then
								{
									_sum = (_wpCheck select 1);_numarray = _wparray call DAC_fWritePosition;
									[37,_groupid,_group,"P",player distance _leader] spawn DAC_fShowRadio;
									_go = 0;_run = 3;
								};
							};
							if((_group in DAC_Cover_Groups) && (_go > 0)) then {_go = 0;_run = 11};
							if((unitReady vehicle _leader) && (_go > 0)) then {_go = 0};
						};
					};
					if(_run == 5) then
					{
						if(overcast > _maxweather) then {_patrolon = _maxwps};
						_patrolon = _patrolon + 1;_run = 6;
					};
				};
		case 6:	{
					//-----------------------------
					//#waiting
					//-----------------------------
					if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case6",time]};
					if((count _EventList) > 0) then {call compile (_EventList select 0)};
					if(_patrolon > _maxwps) then
					{
						_run = 7;_inflight = 0;
					}
					else
					{
						_wait = time + random (call compile _unitwait1);_go = 1;
						_zskill = [((getMarkerPos (_marker select 2)) select 1)] call DAC_fConfigBehav;
						while {_go > 0} do
						{
							if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case6 - while1",time]};
							sleep (1 + (random 1));
							_call = [_group,_leader,_marker,_helo,0] call DAC_fOtherConditions;
							if((count _call) > 0) then
							{
								_run = (_call select 0);_target = (_call select 1);_go = 0;
							}
							else
							{
								if(_vehcargo == 1) then
								{
									if(({alive _x} count units _group) > 0) then
									{
										if(_exgroup in DAC_Cover_Groups) then {_go = 0;_run = 11};
									};
								};
								if(_go > 0) then
								{
									waitUntil{DAC_NewZone == 0};
									_wpCheck = [[_wparray,_numarray,_allZones],_groupid] call DAC_fSumWaypoints;
									_posarray = (_wpCheck select 0);_allZones = ((_wpCheck select 0) select 2);
									_wparray = ((_wpCheck select 0) select 0);
									if(_sum != (_wpCheck select 1)) then
									{
										_sum = (_wpCheck select 1);_numarray = _wparray call DAC_fWritePosition;
										[37,_groupid,_group,"P",player distance _leader] spawn DAC_fShowRadio;
										_go = 0;_run = 3;
									};
								};
								if((_group in DAC_Cover_Groups) && (_go > 0)) then {_go = 0;_run = 11};
								if((time > _wait) && (_go > 0)) then
								{
									if(_oldskill != ((getMarkerPos (_marker select 2)) select 1)) then
									{
										_zskill = [((getMarkerPos (_marker select 2)) select 1)] call DAC_fConfigBehav;_oldskill = ((getMarkerPos (_marker select 2)) select 1);
										_unitcombat = _zskill select 1;_unitbehav = _zskill select 2;_unitspeed = _zskill select 3;
										_unitheight = _zskill select 6;_maxweather = ((_zskill select 6) select 2);_hport = ((_zskill select 6) select 3);
										_unitwait1 = "(((_zskill select 7) select (_groupid - 1)) select 2)";
										_unitwait2 = "((((_zskill select 7) select (_groupid - 1)) select 0) + (random (((_zskill select 7) select (_groupid - 1)) select 1)))";
										{_x setCombatMode (selectRandom _unitcombat)} forEach units _group;
										{_x setBehaviour (selectRandom _unitbehav)} forEach units _group;
										{_x setSpeedMode (selectRandom _unitspeed)} forEach units _group;
									};
									_go = 0;_run = 3;_inflight = 1;
								};
							};
						};
					};
				};
		case 7:	{
					//-----------------------------
					//#landing
					//-----------------------------
					if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case7",time]};
					_nextpos setPos _homepos;
					if(([((getPosATL vehicle _leader) select 0),((getPosATL vehicle _leader) select 1),0] distance _nextpos) < 50) then
					{
						_nextpos setPos [(_homepos select 0),(_homepos select 1)+55,0];_run = 5;
						_group setVariable ["dacData",[0,position _nextpos],false];
						_helo flyinheight 50;_helo move getPosATL _nextpos;_helo setSpeedMode "normal";
					}
					else
					{
						_group setVariable ["dacData",[0,position _nextpos],false];
						_helo flyinheight 60;_helo move getPosATL _nextpos;_helo setSpeedMode "limited";_go = 1;
						while {_go > 0} do
						{
							if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case7 - while1",time]};
							sleep (1 + (random 1));
							_call = [_group,_leader,_marker,_helo,0] call DAC_fOtherConditions;
							_temppos = [(position _helo select 0),(position _helo select 1),0];
							if((count _call) > 0) then
							{
								_run = (_call select 0);_target = (_call select 1);_go = 0;
							}
							else
							{
								if(_vehcargo == 1) then
								{
									if(({alive _x} count units _group) > 0) then
									{
										if(_exgroup in DAC_Cover_Groups) then  {_go = 0;_run = 11};
									};
								};
								if(_go > 0) then
								{
									waitUntil{DAC_NewZone == 0};
									_wpCheck = [[_wparray,_numarray,_allZones],_groupid] call DAC_fSumWaypoints;
									_posarray = (_wpCheck select 0);_allZones = ((_wpCheck select 0) select 2);
									_wparray = ((_wpCheck select 0) select 0);
									if(_sum != (_wpCheck select 1)) then
									{
										_sum = (_wpCheck select 1);_numarray = _wparray call DAC_fWritePosition;
										[37,_groupid,_group,"P",player distance _leader] spawn DAC_fShowRadio;
										_go = 0;_run = 3;
									};
								};
								if((unitReady _helo) && (_go > 0)) then {_go = 0};
								if((_group in DAC_Cover_Groups) && (_go > 0)) then {_go = 0;_run = 11};
							};
						};
					};
					if(_run == 7) then
					{
						_nextpos setPos [0,0,0];
						if(_hport == 1) then {_helip setPos _homepos};
						sleep 3;
						_helo land "land";_go = 1;
						while {_go > 0} do
						{
							if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case7 - while2",time]};
							sleep (1 + (random 1));
							_call = [_group,_leader,_marker,_helo,0] call DAC_fOtherConditions;
							if((count _call) > 0) then
							{
								_run = (_call select 0);_target = (_call select 1);_go = 0;
							}
							else
							{
								if(_vehcargo == 1) then
								{
									if(({alive _x} count units _group) > 0) then
									{
										if(_exgroup in DAC_Cover_Groups) then  {_go = 0;_run = 11};
									};
								};
								if((getPosATL _helo select 2 < 2) && (_go > 0)) then
								{
									{unassignVehicle _x;[_x] allowGetIn false;[_x] orderGetIn false}forEach [_driver,_gunner];[2,(leader _group)] spawn DAC_fAIRadio;
									sleep 3;
									_leader move [(position _helo Select 0) + (Sin (direction _helo) * 15),(position _helo Select 1) + (Cos (direction _helo) * 15),0];
									{_x setUnitPos "auto"}forEach [_driver,_gunner];_go = 0;_run = 2;
								};
							};
						};
					};
				};
		case 10:{
					//-----------------------------
					//#groupchangemove
					//-----------------------------
					if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case10",time]};
					if(((damage _helo) > 0.6) || (!(canMove _helo))) then {_run = 15};
					if(!(_group in DAC_Radio_Groups)) then {[27,_groupid,_group,"P",player distance _leader] spawn DAC_fShowRadio};
					if(!(_driver in _helo)) then
					{
						if((count (crew _helo)) > 0) then {_group leaveVehicle _helo};
						_run = 16;
					}
					else
					{
						if(((position _driver) select 2) < 5) then
						{
							if((count (crew _helo)) > 0) then {_group leaveVehicle _helo};
							_run = 16;
						}
						else
						{
							_group setCombatMode "yellow";_group setBehaviour "combat";
							_run = 11;_rd = random 360;_dist = (100 / ((0.1 + skill _driver) * DAC_AI_Level));_callg = [];
						};
					};
				};
		case 11:{
					//-----------------------------
					//#groupmovetoenemy
					//-----------------------------
					if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case11",time]};
					if(_group in DAC_Hit_Groups) then
					{
						if(_group in DAC_Cover_Groups) then {DAC_Cover_Groups = DAC_Cover_Groups - [_group]};
						if(_exgroup in DAC_Cover_Groups) then {DAC_Cover_Groups = DAC_Cover_Groups - [_exgroup]};
						{if((!(side _x == side leader _group)) && (alive _x))  then {_callg pushBack _x}} forEach DAC_Fire_Pos;
						if((count _callg) > 0) then
						{
							if((count _callg) > 1) then
							{
								_target = selectRandom _callg;
							}
							else
							{
								_target = _callg select 0;
							};
							_nextpos setPos [(position _target Select 0) + (Sin (_rd) * _dist),(position _target Select 1) + (Cos (_rd) * _dist),0];
							_group setVariable ["dacData",[0,position _nextpos],false];
							_helo flyinheight 200;_helo setSpeedMode "limited";_helo move position _nextpos;_go = 1;
							if(_vehcargo == 1) then {_group setBehaviour "safe"} else {_helo dofire _target;_group setBehaviour "combat"};
							{if(_x != _driver) then {_x reveal _target}}forEach units _group;_gunner commandtarget _target;_aTime = time + 180;
							while {_go > 0} do
							{
								if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case11 - while1",time]};
								sleep (2 + (random 1));
								if(((getMarkerSize (_marker select 0)) select 0) <= 4) then {deleteVehicle _nextpos;_run = 0;_go = 0};
								if((({alive _x} count units _group) == 0) && (_go > 0)) then {_run = 15;_go = 0};
								if((((damage _helo) > 0.6) || (!(canMove _helo))) && (_go > 0)) then {_run = 15;_go = 0};
								if(_vehcargo == 1) then
								{
									if((([((position _helo) select 0),((position _helo) select 1),0] distance _nextpos) < 50) && (((getposATL _helo) select 2) > 100) && (_go > 0)) then
									{
										if(({_x in _helo} count units _exgroup) == 0) then {_run = 12} else {_run = 13};_go = 0;
									}
									else
									{
										_group setBehaviour "safe";_helo flyinheight 200;_helo setSpeedMode "limited";_helo move position _nextpos;
										if(time > _atime) then {_go = 0;_run = 6};
									};
								}
								else
								{
									if((unitReady _helo) && (_go > 0)) then
									{
										_run = 12;_go = 0;
									};
								};
							};
						}
						else
						{
							_target = objNull;_run = 3;
							if(_group in DAC_Hit_Groups) then {DAC_Hit_Groups = DAC_Hit_Groups - [_group]};
							if(_group in DAC_Radio_Groups) then {DAC_Radio_Groups = DAC_Radio_Groups - [_group]};
						};
					}
					else
					{
						if((_group in DAC_Cover_Groups) || (_exgroup in DAC_Cover_Groups)) then
						{
							if(_group in DAC_Cover_Groups) then {DAC_Cover_Groups = DAC_Cover_Groups - [_group]};
							if(!(_exgroup in DAC_Cover_Groups)) then {DAC_Cover_Groups pushBack _exgroup};
							_callg = [];_grouponfire = _group;
							{if(side (leader _x ) == side leader _group) then {_callg pushBack _x}} forEach DAC_Call_Groups;
							if((count _callg) == 0) then
							{
								DAC_Cover_Groups = DAC_Cover_Groups - [_exgroup];_run = 3;
							}
							else
							{
								_grouponfire = selectRandom _callg;
								_nextpos setPos [(position (leader _grouponfire) select 0),(position (leader _grouponfire) select 1),0];
								[21,_groupid,_group,"T",(leader _grouponfire) distance _leader] spawn DAC_fShowRadio;
							};
						}
						else
						{
							_go = 1;_wait = (time + 10);
							while {_go > 0} do
							{
								if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case1 - while2",time]};
								_nextpos setPos [(position _target Select 0) + (Sin (_rd) * _dist),(position _target Select 1) + (Cos (_rd) * _dist),0];
								if(surfaceIsWater (position _nextpos)) then
								{
									sleep 0.1;
									if(time > _wait) then {_go = 0;_run = 3};
								}
								else
								{
									_go = 0;
								};
							};
						};
						if(_run == 11) then
						{
							_group setVariable ["dacData",[0,position _nextpos],false];
							_helo flyinheight 200;_helo setSpeedMode "limited";_helo move position _nextpos;_go = 1;_aTime = time + 180;
							if(_vehcargo == 1) then {_group setBehaviour "safe"} else {_group setBehaviour "combat"};
							while {_go > 0} do
							{
								if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case11 - while3",time]};
								sleep (2 + (random 1));
								if(_group in DAC_Hit_Groups) then {_run = 11;_go = 0};
								if(((getMarkerSize (_marker select 0)) select 0) <= 4) then {deleteVehicle _nextpos;_run = 0;_go = 0};
								if((({alive _x} count units _group) == 0) && (_go > 0)) then {_run = 15;_go = 0};
								if((((damage _helo) > 0.6) || (!(canMove _helo))) && (_go > 0)) then {_run = 15;_go = 0};
								if(_vehcargo == 1) then
								{
									if((([((position _helo) select 0),((position _helo) select 1),0] distance _nextpos) < 50) && (((getposATL _helo) select 2) > 100) && (_go > 0)) then
									{
										if(({_x in _helo} count units _exgroup) == 0) then {_run = 12} else {_run = 13};_go = 0;
									}
									else
									{
										_group setBehaviour "safe";_helo flyinheight 200;_helo setSpeedMode "limited";_helo move position _nextpos;
										if(time > _atime) then {_go = 0;_run = 6};
									};
								}
								else
								{
									if((unitReady _helo) && (_go > 0)) then
									{
										_run = 12;_go = 0;
									};
								};
							};
						};
					};
				};
		case 12:{
					//-----------------------------
					//#cargono
					//-----------------------------
					if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case12",time]};
					if(_group in DAC_Cover_Groups) then
					{
						_landmodus == 0;_run = 19;
					}
					else
					{
						_go = 1;
						while {_go > 0} do
						{
							if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case12 - while1",time]};
							sleep (1 + (random 1));
							if(((getMarkerSize (_marker select 0)) select 0) <= 4) then {deleteVehicle _nextpos;_run = 0;_go = 0};
							if((({alive _x} count units _group) == 0) && (_go > 0)) then {_run = 15;_go = 0};
							if((((damage _helo) > 0.6) || (!(canMove _helo))) && (_go > 0)) then {_run = 15;_go = 0};
							if(_go > 0) then
							{
								if(alive _target) then
								{
									if(({(((_x knowsabout _target) >= _knowsabout)  && ((_x distance _target) < (call compile DAC_Alert_Dist)))} count units _group) > 0) then
									{
										_go = 0;_run = 11;
									}
									else
									{
										_go = 2;
									};
								}
								else
								{
									_go = 2;
								};
								if(_go == 2) then
								{
									_go = 0;_run = 3;
									[38,_groupid,_group,"P",player distance _leader] spawn DAC_fShowRadio;
									if(_group in DAC_Hit_Groups) then {DAC_Hit_Groups = DAC_Hit_Groups - [_group]};
									if(_group in DAC_Radio_Groups) then {DAC_Radio_Groups = DAC_Radio_Groups - [_group]};
								};
							};
						};
					};
				};
		case 13:{
					//-----------------------------
					//#cargoyes
					//-----------------------------
					if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case13",time]};
					_helo flyinheight 200;_helo setSpeedMode "limited";
					sleep 1;
					_group reveal _target;
					{if(alive _x) then {_x action ["EJECT",_helo];unassignVehicle _x;_x setCombatMode "red";_x setBehaviour "aware";sleep 0.5}} forEach units _exgroup;
					if(((getMarkerSize (_marker select 0)) select 0) <= 4) then {deleteVehicle _nextpos;_run = 0;_go = -1};
					[[_exgroup,_marker],_target,_posarray,6,_maxrad,_zskill,[_helo,_group,_heloarray]] spawn DAC_fMoveToEnemy;
					_helo setSpeedMode "full";_helo flyinheight 60;_vehcargo = 0;_run = 7;
				};
		case 15:{
					//-----------------------------
					//#getouthelo
					//-----------------------------
					if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case15",time]};
					if(({alive _x} count units _group) == 0) then
					{
						_run = 0;
					}
					else
					{
						[29,_groupid,_group,"P",player distance _leader] spawn DAC_fShowRadio;
						if(((position _helo) select 2) > 5) then
						{
							if(canMove _helo) then
							{
								_helo flyinheight 150;
								sleep 3;
							};
							{if(alive _x) then {_x action ["EJECT",_helo];unassignVehicle _x;_x setCombatMode "red";_x setBehaviour "aware";sleep 1}} forEach units _group;
						}
						else
						{
							{if(alive _x) then {_x action ["EJECT",_helo];unassignVehicle _x;_x setCombatMode "red";_x setBehaviour "aware";sleep 1}} forEach units _group;
						};
						_run = 18;_go = 1;
					};
				};
		case 16:{
					//-----------------------------
					//#waitforenemy
					//-----------------------------
					if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case15",time]};
					if(({alive _x} count units _group) == 0) then
					{
						_run = 0;
					}
					else
					{
						_go = 1;_waittime = time + 30;
						{_x setCombatMode "red";_x setBehaviour "aware";_x setUnitPos "down"} forEach units _group;
						while {_go > 0} do
						{
							if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - waitforenemy",time]};
							sleep (1 + (random 1));
							if(((getMarkerSize (_marker select 0)) select 0) <= 4) then {deleteVehicle _nextpos;_go = 0;_run = 0};
							if((({alive _x} count units _group) == 0) && (_go == 1)) then {deleteVehicle _nextpos;_run = 0;_go = 0};
							if(time > _waittime) then
							{
								if((isNull(_leader findNearestEnemy (position _leader))) && (_go == 1)) then
								{
									if(_group in DAC_Hit_Groups) then {DAC_Hit_Groups = DAC_Hit_Groups - [_group]};
									_run = 2;_go = 0;
								}
								else
								{
									_waittime = time + 30;
								};
							};
						};
					};
				};
		case 18:{
					//-----------------------------
					//#moveNear
					//-----------------------------
					if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case18",time]};
					[_garray,str(position _helo),1,_maxrad,6] spawn DAC_fMoveAround;_run = 0;
				};
		case 19:{
					//-----------------------------
					//#Alert
					//-----------------------------
					if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case19",time]};
					sleep 1;
					_go = 1;_waittime = time + 60;
					if(!(_driver in _helo)) then
					{
						{_x setCombatMode "red";_x setBehaviour "aware";_x setUnitPos "down"} forEach units _group;
						while {_go > 0} do
						{
							if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case19 - while1",time]};
							sleep (1 + (random 1));
							if(((getMarkerSize (_marker select 0)) select 0) <= 4) then {deleteVehicle _nextpos;_go = 0;_run = 0};
							if((({alive _x} count units _group) == 0) && (_go == 1)) then {deleteVehicle _nextpos;_run = 0;_go = 0};
							if((((damage _helo) > 0.7) || (!(canMove _helo))) && (_go == 1)) then {_run = 15;_go = 0};
							if((isNull(_leader findNearestEnemy (position _leader))) && (_go == 1)) then
							{
								if(_group in DAC_Cover_Groups) then {DAC_Cover_Groups = DAC_Cover_Groups - [_group]};
								_run = 2;_go = 0;
							};
						};
					}
					else
					{
						_go = 1;_helo flyinheight 50;_helo setSpeedMode "limited";
						while {_go > 0} do
						{
							_rdir = random 360;_flypos = [((position _nextpos select 0) + (Sin _rdir * 200)),((position _nextpos select 1) + (Cos _rdir * 200)),0];
							_group setVariable ["dacData",[2,_flypos],false];
							_helo move _flypos;_go = 2;
							while {_go > 1} do
							{
								if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case16 - while3",time]};
								sleep (1 + (random 1));
								if(((getMarkerSize (_marker select 0)) select 0) <= 4) then {deleteVehicle _nextpos;_go = 0;_run = 0};
								if((({alive _x} count units _group) == 0) && (_go == 2)) then {deleteVehicle _nextpos;_run = 0;_go = 0};
								if((((damage _helo) > 0.7) || (!(canMove _helo))) && (_go == 2)) then {_run = 15;_go = 0};
								if((unitReady _helo) && (_go == 2)) then
								{
									if(!(isNull([_leader,_group,_target] call DAC_fEnemyCond))) then
									{
										_target = [_leader,_group,_target] call DAC_fEnemyCond;
										_nextpos setPos (position _target);_waittime = time + 30;_target = objNull;_go = 1;
										_group setVariable ["dacData",[2,position _nextpos],false];
									}
									else
									{
										if(time > _waittime) then
										{
											if(_group in DAC_Cover_Groups) then {DAC_Cover_Groups = DAC_Cover_Groups - [_group]};
											_run = 2;_go = 0;
										}
										else
										{
											_go = 1;
										};
									};
								};
							};
						};
					};
				};
		case 20:{
					if(_group in xCam_Debug_Group) then {xCam_Debug_String = format["%1 - Move_Random - case20",time]};
				};
		Default{};
	};
};
if(_hport == 1) then {deleteVehicle _helip};