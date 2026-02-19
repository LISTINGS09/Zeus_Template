// 	Zeus - Virtual Garage Option
//  f_sqf_vg = execVM "f\misc\f_virtualGarage.sqf";
if !hasInterface exitWith {};

if (isNil "ZEU_VG_LocalObject") then { 
	ZEU_VG_LocalObject = "Land_HelipadEmpty_F" createVehicleLocal [0,0,0]; 
	 
	if !(isNil "ZEU_VG_Object") then { 
		ZEU_VG_LocalObject setPos getPos ZEU_VG_Object;
	} else {
		ZEU_VG_LocalObject setVehiclePosition [player, [], 0, "NONE"];
	};
};

if (isNil "ZEU_VG_Marker") then {
	private _mkr = createMarkerLocal ["ZEU_VG_Marker", getPos ZEU_VG_LocalObject];
	_mkr setMarkerTypeLocal "b_maint";
	_mkr setMarkerColorLocal ([side (group player), true] call BIS_fnc_sideColor);
};

if (isNil "ZEU_fnc_StartVirtualGarage") then {
	ZEU_fnc_StartVirtualGarage = {
		private _spawnTarget = if (isNil "ZEU_VG_LocalObject") then { (nearestObjects [player, ["Land_HelipadEmpty_F"], 2000]) select 0 } else { ZEU_VG_LocalObject };
		
		if (isNil "_spawnTarget") exitWith { systemChat "No valid spawn point found, create one in Virtual Garage briefing!" }; 

		{ if !(isPlayer _x || typeOf _x == "Land_HelipadEmpty_F") then { deleteVehicle _x } } forEach (_spawnTarget nearEntities 5); 

		sleep 1; 
			
		BIS_fnc_garage_center = "Land_HelipadEmpty_F" createVehicleLocal getPos _spawnTarget;
		["Open", [true]] call BIS_fnc_garage; 

		_spawnTarget spawn { 
			private _lastPos = getPos player;
			waitUntil { uiSleep 1; isNull (uiNamespace getVariable["BIS_fnc_arsenal_cam", objNull]) }; 

			if (typeOf BIS_fnc_garage_center == "Land_HelipadEmpty_F") exitWith {};
			if (vehicle player isEqualTo BIS_fnc_garage_center) then { moveOut player };

			private _obj = BIS_fnc_garage_center; 
			private _type = typeOf BIS_fnc_garage_center; 
			private _call = [BIS_fnc_garage_center, ""] call BIS_fnc_exportVehicle; 

			BIS_fnc_garage_center setPos [0,0,0];
			deleteVehicleCrew BIS_fnc_garage_center;
			deleteVehicle BIS_fnc_garage_center; 

			sleep 0.1; 

			BIS_fnc_garage_center = createVehicle [_type, getPos _this, [], 0, "NONE"]; 
			BIS_fnc_garage_center setDir getDir _this; 
			BIS_fnc_garage_center call compile _call;
		};
	};
};

if !(player diarySubjectExists "** Virtual Garage **") then {
	private _VGtext = "<font size='18' color='#FF7F00'>Virtual Garage</font><br/>A local marker will spawn your vehicle at the defined locaton, if no marker is defined the nearest invisible helipad will be used.<br/><br/><marker name='ZEU_VG_Marker'>Check Position</marker>
		<br/><br/>Change Garage Spawn Direction: <execute expression=""ZEU_VG_LocalObject setDir 0; systemChat format['[VG] Vehicle Spawn Dir: %1', getDir ZEU_VG_LocalObject];"">North</execute> | 
		<execute expression=""ZEU_VG_LocalObject setDir 90; systemChat format['[VG] Vehicle Spawn Dir: %1', getDir ZEU_VG_LocalObject];"">East</execute> | 
		<execute expression=""ZEU_VG_LocalObject setDir 180; systemChat format['[VG] Vehicle Spawn Dir: %1', getDir ZEU_VG_LocalObject];"">South</execute> | 
		<execute expression=""ZEU_VG_LocalObject setDir 270; systemChat format['[VG] Vehicle Spawn Dir: %1', getDir ZEU_VG_LocalObject];"">West</execute>
		<br/>Change Garage Spawn Location to: <execute expression=""ZEU_VG_LocalObject setPos getPos player; 'ZEU_VG_Marker' setMarkerPosLocal (getPos player); systemChat format['[VG] Vehicle Spawn Position Set To: %1', getPos ZEU_VG_LocalObject];"">Player Location</execute> | <execute expression=""systemChat '[VG] Click map to set Vehicle Spawn position!'; ZEU_VG_SpawnClick = addMissionEventHandler ['MapSingleClick', { ZEU_VG_LocalObject setPos (_this#1); 'ZEU_VG_Marker' setMarkerPosLocal (_this#1); systemChat format['[VG] Vehicle Spawn Position Set To: %1', getPos ZEU_VG_LocalObject]; removeMissionEventHandler ['MapSingleClick', ZEU_VG_SpawnClick]; }];"">Map Location</execute><br/>
		<br/><execute expression=""[] spawn ZEU_fnc_StartVirtualGarage;"">Open Virtual Garage</execute><br/>";

	player createDiaryRecord ["diary", ["** Virtual Garage **", _VGtext]];
};