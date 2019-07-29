//////////////////////////////
//    Dynamic-AI-Creator    //
//    Version 3.1b - 2014   //
//--------------------------//
//    DAC_New_Waypoints     //
//--------------------------//
//    Script by Silola      //
//    silola@freenet.de     //
//////////////////////////////

private [
			"_DAC_WP_Typ","_wpConfig","_CheckRadius1","_CheckRadius2","_checkAreaH","_checkNear","_checkObjH2",
			"_checkMaxH","_checkMinH","_checkCount","_DAC_Typ_Nr","_MTemp","_TempArray","_DAC_MColor","_checkObjH1",
			"_ScriptArray","_DAC_WP_Basic","_m3","_countairwp","_DumyA","_DumyB","_Null","_PosNull","_zonr","_tempList",
			"_wpnr","_chnr","_hz","_DAC_Count_WP","_DAC_SelectZone","_DAC_EditZone","_DAC_ZoneRadiusX","_rx","_ry",
			"_DAC_ZoneRadiusY","_DAC_ActivZoneX","_DAC_ActivZoneY","_RandomX","_RandomY","_PosMin","_PosMax","_ellipsResult",
			"_nr","_cv","_cr","_np","_cd","_allObjects","_relObjects","_DPos","_ma","_run","_go","_mm1","_m1","_checkwp",
			"_mm2","_m2","_m3","_mm3","_m4","_mm4","_DAC_WP_Nr","_AirData","_entry","_id","_rsin","_rcos","_wn","_dist","_log"
		];		
			_DAC_WP_Typ = _this select 0;_wpConfig = [];_id = 0;_AirData = 0;_entry = [];_rx = 0,_ry = 0;_rsin = [];_rcos = [];_ellipsResult = [];
			_DAC_Typ_Nr = ["S","V","T","A","C"];_MTemp = [];_TempArray = [];_ScriptArray = [2,3,4,5];_DAC_WP_Basic = "";_tempList = [];
			_DAC_MColor = ["ColorBlue","ColorYellow","ColorRed","ColorGreen","ColorBlack"];_m3 = "";_mm1 = "";_mm2 = "";_countairwp = 0;
			_run = 1;_go = 0;_DAC_WP_Nr = 0;_zone = _this select 1;_pos = _this select 2;_size = _this select 3;_wc = _this select 4;
			_wn = 0;_dist = 100000;_log = objNull;_checkwp = [];

if(isServer) then
{
	while {_run > 0} do
	{
		switch (_run) do
		{
			case 1:	{
						if(!(_DAC_WP_Typ == 1)) then
						{
							sleep (0.1 + (random 0.5));
							_DAC_EditZone = _zone;
							_DAC_ZoneRadiusX = _size select 0;
							_DAC_ZoneRadiusY = _size select 1;
							_run = 3;
						}
						else
						{
							if((DAC_Com_Values select 0) > 0) then {systemChat format["Process DAC_Change_Zone was started > Zone [%1]",round (getPosATL _zone select 0)]};
							DAC_Init_Counter = [2,2,2,2,2];
							_zone setPos _pos;_DAC_EditZone = _zone;
							_DAC_ZoneRadiusX = _size select 0;_DAC_ZoneRadiusY = _size select 1;
							sleep 1;
							_zone settriggerArea [(_size select 0), (_size select 1), (_size select 2), ((triggerArea _zone) select 3)];
							{[_x,_zone,_pos,_size,_wc] spawn DAC_fNewWaypoints} forEach _ScriptArray;
							sleep 0.1;
							_run = 3;
						};
					};
			case 2:	{
						//disabled;
					};
			case 3:	{
						_DumyA = "logic" createVehicleLocal [0,0,0];
						_DumyB = "logic" createVehicleLocal [0,0,0];
						_Null = "EmptyDetector" createVehicleLocal [0,0,0];
						_PosNull = 0;_zonr = 0;_wpnr = 0;_chnr = 0;_hz = 0;_DAC_Count_WP = 0;
						if(DAC_Marker > 0) then
						{
							if((DAC_Marker_Val select 1) > 0) then
							{
								_m1 = format["m%1%2%3",_zonr,0,_DAC_WP_Typ];_mm1 = createMarkerLocal [_m1, position _DumyA];
								_mm1 setMarkerShapelocal "ELLIPSE";_mm1 setMarkerSizelocal [1,1];
								_mm1 setMarkerColorlocal (_DAC_MColor select (_DAC_WP_Typ - 1));
								_m2 = format["p%1%2%3",_zonr,0,_DAC_WP_Typ];_mm2 = createMarkerLocal [_m2, position _DumyA];
								_mm2 setMarkerShapelocal "ELLIPSE";_mm2 setMarkerSizelocal [4,4];
								_mm2 setMarkerColorlocal "ColorBlack";
							};
						};
						sleep (random 0.5);
						_run = 4;
					};
			case 4:	{
						_go = 0;
						while {_go == 0} do
						{
							_wpnr = 0;_chnr = 0;_hz = 0;_DAC_WP_Nr = 0;
							_wpConfig = [(_DAC_WP_Typ - 1),_wc] call DAC_fConfigWP;
							_CheckRadius1 = ((_wpConfig select 0) select 0);_CheckRadius2 = ((_wpConfig select 0) select 1);
							_checkAreaH = _wpConfig select 1;_checkNear = _wpConfig select 2;
							_checkObjH1 = ((_wpConfig select 3) select 0);_checkObjH2 = ((_wpConfig select 3) select 1);
							_checkMaxH = _wpConfig select 4;_checkMinH = _wpConfig select 5;_checkCount = _wpConfig select 6;
							if(_DAC_WP_Typ > 3) then
							{
								if(_DAC_WP_Typ == 5) then
								{
									//_DAC_WP_Nr = 0;_run = 20;
									_i = 0;
									while {_i < count DAC_Zones} do
									{
										_DAC_SelectZone = DAC_Zones select _i;
										if((call compile (_DAC_SelectZone select 0)) == _zone) then
										{
											_DAC_SelectZone set [1,_DAC_ZoneRadiusX];
											_DAC_SelectZone set [2,_DAC_ZoneRadiusY];
											_AirData = _DAC_SelectZone select 7;_id = (_i + 1);
											if((count _AirData == 0) || (count _AirData < 6)) then
											{
												_i = ((count DAC_Zones) + 1);_go = 1;_run = 20;
											}
											else
											{
												_DAC_WP_Basic = "DAC_WP_Pool_C";
												_DAC_WP_Nr = _AirData select 0;
												_countairwp = _AirData select 2;
												_i = _i + 1;
											};
										}
										else
										{
											_i = _i + 1;
										};
									};
								}
								else
								{
									_i = 0;
									while {_i < count DAC_Zones} do
									{
										_DAC_SelectZone = DAC_Zones select _i;
										if((call compile (_DAC_SelectZone select 0)) == _zone) then
										{
											_DAC_SelectZone set [1,_DAC_ZoneRadiusX];
											_DAC_SelectZone set [2,_DAC_ZoneRadiusY];
											_AirData = _DAC_SelectZone select 7;_id = (_i + 1);
											if((count _AirData < 2) || (count _AirData > 4)) then
											{
												_i = ((count DAC_Zones) + 1);_go = 1;_run = 20;
											}
											else
											{
												_DAC_WP_Basic = "DAC_WP_Pool_A";
												if(count _AirData == 1) then
												{
													_DAC_WP_Nr = 0;_hz = 1;
													_countairwp = _AirData select 0;
													_i = _i + 1;
												}
												else
												{
													_DAC_WP_Nr = _AirData select 0;
													_countairwp = _AirData select 2;
													_i = _i + 1;
												};
											};
										}
										else
										{
											_i = _i + 1;
										};
									};
								};
							}
							else
							{
								_i = 0;_go = 0;_DAC_WP_Basic = format["DAC_WP_Pool_%1",(_DAC_Typ_Nr select (_DAC_WP_Typ - 1))];
								while {_i < count (call compile _DAC_WP_Basic)} do
								{
									_DAC_SelectZone = ((call compile _DAC_WP_Basic) select _i);
									if((count _DAC_SelectZone) > 2) then
									{
										if((_DAC_SelectZone select 0) == _zone) then
										{
											_id = (_i + 1);
											while {_go == 0} do
											{
												_i = _i + 1;
												if(_i < count (call compile _DAC_WP_Basic)) then
												{
													_DAC_SelectZone = ((call compile _DAC_WP_Basic) select _i);
													if((count _DAC_SelectZone) == 2) then
													{
														_DAC_WP_Nr = _DAC_WP_Nr + 1;
													}
													else
													{
														_go = 1;
													};
												}
												else
												{
													_go = 1;
												};
											};
										}
										else
										{
											_i = _i + 1;
										};
									}
									else
									{
										_i = _i + 1;
									};
								};
								if(_DAC_WP_Nr == 0) then
								{
									_run = 20;
								};
							};
							if(_run == 20) then
							{
								_run = 13;_go = 1;
							}
							else
							{
								if(_DAC_WP_Typ == 4) then
								{
									_run = 6;_go = 1;
								}
								else
								{
									_run = 6;_go = 1;
								};
							};
						};
					};
			case 5:	{
						//disabled
					};
			case 6:	{
						_DAC_ActivZoneX  = ((getPosATL _DAC_EditZone select 0) - _DAC_ZoneRadiusX);
						_DAC_ActivZoneY  = ((getPosATL _DAC_EditZone select 1) - _DAC_ZoneRadiusY);
						_tempList = List _DAC_EditZone;
						if(count _tempList == 0) then
						{
							_run = 7;
						}
						else
						{
							_wn = 0;_dist = 100000;_log = objNull;
							{
								if((format["%1",typeOf _x] == "Logic")
								&& (format["%1",direction _x] == format["%1",_DAC_WP_Typ])
								&& ((count waypoints _x) > 1)) then
								{
									if(format["%1",_x getVariable "Link"] != "<NULL>") then
									{
										if((_x getVariable "Link") == _DAC_EditZone) then
										{
											_log = _x;_dist = 0;
										};
									}
									else
									{
										if((getwppos[_x,0] distance _DAC_EditZone) < _dist) then
										{
											_log = _x;_dist = (getwppos[_x,0] distance _DAC_EditZone);
										};
									};
								};
							}forEach _tempList;
							
							if(isNull _log) then
							{
								_run = 7;
							}
							else
							{
								while{(((getwppos[_log,_wn + 1]) select 0)+((getwppos[_log,_wn + 1]) select 1) != 0)} do
								{
									_checkwp = getwppos[_log,_wn + 1];
									_TempArray pushBack [_checkwp select 0,_checkwp select 1];
									_wn = _wn + 1;_wpnr = _wpnr + 1;_chnr = 0;
									if(DAC_Marker > 0) then
									{
										if(((DAC_Marker_Val select 1) > 0) && (_DAC_WP_Nr > 0)) then
										{
											_m = format["m%1%2%3",_wpnr,_DAC_WP_Typ,((position _zone) select 0)];
											_ma = createMarkerLocal [_m, [_checkwp select 0,_checkwp select 1]];
											_ma setMarkerShapelocal "ELLIPSE";_ma setMarkerSizelocal [_CheckRadius2, _CheckRadius2];
											_ma setMarkerBrushlocal "BORDER"; 
											_ma setMarkerColorlocal (_DAC_MColor select (_DAC_WP_Typ - 1));
											if((DAC_Marker_Val select 1) == 1) then {_MTemp pushBack _ma};
										};
									};
								};
								if(_wpnr >= _DAC_WP_Nr) then
								{
									_run = 12;
								}
								else
								{
									_run = 7;
								};
							};
						};
					};
			case 7:	{
						_go = 1;
						while {_go > 0} do
						{
							if(_chnr > _checkCount) then
							{
								_run = 11;_go = 0;
							}
							else
							{
								if((triggerArea _DAC_EditZone) select 3) then
								{
									_rx = random (_DAC_ZoneRadiusX * 2);_ry = random (_DAC_ZoneRadiusY * 2);
									if(_DAC_ZoneRadiusX > _DAC_ZoneRadiusY) then
									{
										_rsin = [(position _DAC_EditZone Select 0) + (Sin (((triggerArea _DAC_EditZone) select 2) + 90) * ((-_DAC_ZoneRadiusX) + _rx)),(position _DAC_EditZone Select 1) + (Cos (((triggerArea _DAC_EditZone) select 2) + 90) * ((-_DAC_ZoneRadiusX) + _rx))];
										_rcos = [(_rsin Select 0) + (Sin (((triggerArea _DAC_EditZone) select 2) + 0) * ((-_DAC_ZoneRadiusY) + _ry)),(_rsin Select 1) + (Cos (((triggerArea _DAC_EditZone) select 2) + 0) * ((-_DAC_ZoneRadiusY) + _ry))];
									}
									else
									{
										_rsin = [(position _DAC_EditZone Select 0) + (Sin (((triggerArea _DAC_EditZone) select 2) + 0) * ((-_DAC_ZoneRadiusX) + _rx)),(position _DAC_EditZone Select 1) + (Cos (((triggerArea _DAC_EditZone) select 2) + 0) * ((-_DAC_ZoneRadiusX) + _rx))];
										_rcos = [(_rsin Select 0) + (Sin (((triggerArea _DAC_EditZone) select 2) + 90) * ((-_DAC_ZoneRadiusY) + _ry)),(_rsin Select 1) + (Cos (((triggerArea _DAC_EditZone) select 2) + 90) * ((-_DAC_ZoneRadiusY) + _ry))];
									};
									_RandomX = (_rcos Select 0);_RandomY = (_rcos Select 1);
								}
								else
								{
									_ellipsResult = [_DAC_EditZone,_DAC_ZoneRadiusX,_DAC_ZoneRadiusY] call DAC_fFindEllipsPos;
									_RandomX = (_ellipsResult Select 0);_RandomY = (_ellipsResult Select 1);
								};
								if(_checkMinH >= 0) then
								{
									if(surfaceIsWater [_RandomX, _RandomY]) then
									{
										_chnr = _chnr + 1;
									}
									else
									{
										_Null setPos [_RandomX,_RandomY,0];_DumyA setPos [_RandomX,_RandomY,0];
										_mm1 setMarkerPosLocal [_RandomX,_RandomY];_mm1 setMarkerSizelocal [_CheckRadius2, _CheckRadius2];
										if((getPosASL _Null select 2 > _checkminh) && (getPosASL _Null select 2 < _checkmaxh)) then
										{
											_run = 8;_go = 0;
										}
										else
										{
											_chnr = _chnr + 1;
										};
									};
								}
								else
								{
									if(!(surfaceIsWater [_RandomX, _RandomY])) then
									{
										_chnr = _chnr + 1;
									}
									else
									{
										_Null setPos [_RandomX,_RandomY,0];_DumyA setPos [_RandomX,_RandomY,0];
										_mm1 setMarkerPosLocal [_RandomX,_RandomY];_mm1 setMarkerSizelocal [_CheckRadius2, _CheckRadius2];
										if((getPosASL _Null select 2 > _checkminh) && (getPosASL _Null select 2 < _checkmaxh)) then
										{
											_run = 8;_go = 0;
										}
										else
										{
											_chnr = _chnr + 1;
										};
									};
								};
							};
						};
					};
			case 8:	{
						_PosMin = (getPosASL _Null select 2);_PosMax = _PosMin;_nr = 0;_cv = 0;
						_DumyA setPos [_RandomX,_RandomY,0];_DumyA setdir 0;_cr = _CheckRadius2;_go = 1;
						while {_go > 0} do
						{
							if(_nr > 360) then
							{
								_go = 0;_run = 9;
							}
							else
							{
								if(_cv == 0) then {_cv = 1;_cr = _CheckRadius2} else {_cv = 0;_cr = (_CheckRadius2 / 2)};
								_np = 	[
											((getPosATL _DumyA Select 0) + (Sin ((getDir _DumyA) + _nr) * _cr)),
											((getPosATL _DumyA Select 1) + (Cos ((getDir _DumyA) + _nr) * _cr)),0
										];
								_Null setPos _np;
								if(_checkMinH >= 0) then
								{
									if(getPosASL _Null select 2 > _PosMax) then {_PosMax = (getPosASL _Null select 2)} else {if(getPosASL _Null select 2 < _PosMin) then {_PosMin = (getPosASL _Null select 2)}};
								}
								else
								{
									if(!(surfaceIsWater (position _Null))) then {_PosMax = (_checkAreaH * 10);_nr = 360};
								};
								_nr = _nr + 36;
								_mm2 setMarkerPosLocal _np;
							};
						};
					};
			case 9:	{
						if((_PosMax - _PosMin) > _checkAreaH) then
						{
							_chnr = _chnr + 1;_run = 7;
						}
						else
						{
							if(_CheckRadius1 == 0) then
							{
								_run = 10;
							}
							else
							{
								_relObjects = [];
								_allObjects = [];

								// 2600K - If its on a road we'll assume it's a good way-point.
								if (!isOnRoad [_RandomX,_RandomY,0] || _DAC_WP_Typ in [4,5]) then {
									_allObjects = nearestObjects [[_RandomX,_RandomY], [], _CheckRadius2];
								};
								{
									//diag_log text format["DAC_New_Waypoints9 [%3] Type: (%1) %2", _x, typeOf _x, _DAC_WP_Typ];	
									if(((format["%1",typeOf _x]) != "LOGIC")
									&& ((format["%1",typeOf _x]) != "EmptyDetector")
									&& ((format["%1",typeOf _x]) == "" && _DAC_WP_Typ != 1) // If infantry we don't care about non-specific terrain features (trees etc)
									&& (speed _x == 0)) then
									{
										if(canMove _x) then
										{
											if(((boundingBox _x select 1) select 2) > _checkObjH1) then
											{
												_relObjects pushBack _x;
											};
										}
										else
										{
											if(((position _x) select 2) > _checkObjH1) then
											{
												_relObjects pushBack _x;
											};
										};
									};
								} 	forEach _allObjects;
								if(count _relObjects > 0) then
								{
									if(({((([_RandomX,_RandomY] distance _x) - ((((boundingBox _x select 1) select 0) + ((boundingBox _x select 1) select 1)) / 4)) < _CheckRadius1)} count _relObjects) > 0) then
									{
										_chnr = _chnr + 1;_run = 7;
									}
									else
									{
										_run = 10;
									};
								}
								else
								{
									_run = 10;
								};
							};
						};
					};
			case 10:{
						_relObjects = [];
						_allObjects = [];

						// 2600K - If its on a road we'll assume it's a good way-point.
						if (!isOnRoad [_RandomX,_RandomY,0] || _DAC_WP_Typ in [4,5]) then {
							_allObjects = nearestObjects [[_RandomX,_RandomY], [], _CheckRadius2];
						};
						{
							//diag_log text format["DAC_New_Waypoints10 [%3] Type: (%1) %2", _x, typeOf _x, _DAC_WP_Typ];	
							if(((format["%1",typeOf _x]) != "LOGIC")
							&& ((format["%1",typeOf _x]) != "EmptyDetector")
							&& ((format["%1",typeOf _x]) == "" && _DAC_WP_Typ != 1) // If infantry we don't care about non-specific terrain features (trees etc)
							&& (speed _x == 0)) then
							{
								if(canMove _x) then
								{
									if((((position _x) select 2) > _checkObjH2) && ((_x distance _DumyA) < _CheckRadius2)) then
									{
										_relObjects pushBack _x;
									};
								}
								else
								{
									if((((boundingBox _x select 1) select 2) > _checkObjH2) && ((_x distance _DumyA) < _CheckRadius2)) then
									{
										_relObjects pushBack _x;
									};
								};
							};
						} 	forEach _allObjects;
						if(count _relObjects > 0) then
						{
							_chnr = _chnr + 1;_run = 7;
						}
						else
						{
							if(_checkNear > 0) then
							{
								_cd = 0;
								while {_cd < count _TempArray} do
								{
									_DPos = _TempArray select _cd;
									if(count _DPos > 2) then
									{
										_cd = _cd + 1;
									}
									else
									{
										_DumyB setPos [(_DPos select 0),(_DPos select 1),0];
										if((_DumyB distance _DumyA) < _checkNear) then
										{
											_cd = ((count _TempArray) + 1);
											_chnr = _chnr + 1;_run = 7;
										}
										else
										{
											_cd = _cd + 1;
										};
									};
								};
							};
							if(_run != 7) then
							{
								if(DAC_Marker > 0) then
								{
									if(((DAC_Marker_Val select 1) > 0) && (_DAC_WP_Nr > 0)) then
									{
										_m = format["m%1%2%3",_wpnr,_DAC_WP_Typ,((position _zone) select 0)];
										_ma = createMarkerLocal [_m, position _DumyA];
										_ma setMarkerShapelocal "ELLIPSE";_ma setMarkerSizelocal [_CheckRadius2, _CheckRadius2];
										_ma setMarkerColorlocal (_DAC_MColor select (_DAC_WP_Typ - 1));
										if((DAC_Marker_Val select 1) == 1) then {_MTemp pushBack _ma};
									};
								};
								sleep DAC_WP_Speed;
								_TempArray pushBack [_RandomX,_RandomY];
								_wpnr = _wpnr + 1;_chnr = 0;
								if(_wpnr >= _DAC_WP_Nr) then
								{
									_run = 12;
								}
								else
								{
									_run = 7;
								};
							};
						};
					};
			case 11:{
						if((DAC_Com_Values select 0) > 0) then
						{
							systemChat format["Bad zone position for waypoint type %1",_DAC_WP_Typ];
						};
						sleep 1;
						{deleteVehicle _x} forEach [_DumyA,_DumyB,_Null];
						deleteMarkerLocal _mm1;deleteMarkerLocal _mm2;
						if(count _MTemp > 0) then {{deleteMarkerLocal _x} forEach _MTemp};
						if(!(_DAC_WP_Typ == 1)) then
						{
							_run = 0;
							DAC_Init_Counter set[(_DAC_WP_Typ - 1),1];
						}
						else
						{
							
							sleep 0.1;
							waitUntil {((({_x == 1} count DAC_Init_Counter) == 4))};
							DAC_Init_Counter set[(_DAC_WP_Typ - 1),1];
							_zone settriggertext "stop";
							_run = 0;
						};
					};
			case 12:{
						if(count _TempArray > 0) then
						{
							_i = 0;_go = 0;_id = 0;
							while {_go == 0} do
							{
								if(_id < count (call compile _DAC_WP_Basic)) then
								{
									_DAC_SelectZone = ((call compile _DAC_WP_Basic) select _id);
									if((count _DAC_SelectZone) > 2) then
									{
										if((_DAC_SelectZone select 0) == _zone) then
										{
											_id = _id + 1;
											while {_i < count _TempArray} do
											{
												_wp = _TempArray select _i;
												(call compile _DAC_WP_Basic) set [_id, [(_wp select 0),(_wp select 1)]];
												_i = _i + 1;_id = _id + 1;
											};
											_id = (count (call compile _DAC_WP_Basic));
										}
										else
										{
											_id = _id + 1;
										};
									}
									else
									{
										_id = _id + 1;
									};
								}
								else
								{
									_go = 1;
								};
							};
							if(_DAC_WP_Typ == 4) then
							{
								_run = 14;
							}
							else
							{
								if(_DAC_WP_Typ == 5) then
								{
									_run = 15;
								}
								else
								{
									_run = 13;
								};
							};
						}
						else
						{
							_run = 13;
						};
					};
			case 13:{
						sleep 0.1;
						deleteMarkerLocal _mm1;deleteMarkerLocal _mm2;
						{deleteVehicle _x} forEach [_DumyA,_DumyB,_Null];
						if(count _MTemp > 0) then {[_MTemp]execVM "scripts\DAC\Marker\DAC_deleteMarker.sqf"};
						if((DAC_Com_Values select 0) > 0) then
						{
							systemChat format["%1 new waypoints type [%2] created.",(count _TempArray),_DAC_WP_Typ];
						};
						if(!(_DAC_WP_Typ == 1)) then
						{
							_run = 0;
							DAC_Init_Counter set[(_DAC_WP_Typ - 1),1];
						}
						else
						{
							
							sleep 0.1;
							waitUntil {((({_x == 1} count DAC_Init_Counter) == 4))};
							DAC_Init_Counter set[(_DAC_WP_Typ - 1),1];
							_zone settriggertext "stop";
							_run = 0;
						};
					};
			case 14:{
						_i = 0;
						while {_i < count DAC_WP_Pool_H} do
						{
							_entry = DAC_WP_Pool_H select _i;
							if(count _entry < 5) then
							{
								_i = _i + 1;
							}
							else
							{
								if(!((_entry select 0) == _zone)) then
								{
									_i = _i + 1;
								}
								else
								{
									((DAC_WP_Pool_H select _i) select 1) set [3,_DAC_ZoneRadiusX];
									((DAC_WP_Pool_H select _i) select 1) set [4,_DAC_ZoneRadiusY];
									_i = _i + 1;
									(DAC_WP_Pool_H select _i) set [0,_zone];
									(DAC_WP_Pool_H select _i) set [1,_DAC_ZoneRadiusX];
									(DAC_WP_Pool_H select _i) set [2,_DAC_ZoneRadiusY];
								};
							};
						};	
						_run = 13;
					};
			case 15:{
						_i = 0;
						while {_i < count DAC_WP_Pool_B} do
						{
							_entry = DAC_WP_Pool_B select _i;
							if(count _entry < 5) then
							{
								_i = _i + 1;
							}
							else
							{
								if(!((_entry select 0) == _zone)) then
								{
									_i = _i + 1;
								}
								else
								{
									((DAC_WP_Pool_B select _i) select 1) set [3,_DAC_ZoneRadiusX];
									((DAC_WP_Pool_B select _i) select 1) set [4,_DAC_ZoneRadiusY];
									_i = _i + 1;
									((DAC_WP_Pool_B select _i) select 0) set [0,getPosATL _zone select 0];
									((DAC_WP_Pool_B select _i) select 0) set [1,getPosATL _zone select 1];
									(DAC_WP_Pool_B select _i) set [1,_DAC_ZoneRadiusX];
									(DAC_WP_Pool_B select _i) set [2,_DAC_ZoneRadiusY];
								};
							};
						};	
						_run = 13;
					};
			Default	{};
		};
	};
};