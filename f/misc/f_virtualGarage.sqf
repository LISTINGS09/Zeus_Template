// 	Zeus - Virtual Garage Option
//  f_sqf_vg = execVM "f\misc\f_virtualGarage.sqf";
if !hasInterface exitWith {};
ZEU_VG_Object = "Land_HelipadEmpty_F" createVehicleLocal [0,0,0];
 
ZEU_fnc_StartVirtualGarage = {
	private _spawnTarget = (nearestObjects [player, ["Land_HelipadEmpty_F"], 2000]) select 0;
	
	if (isNil "_spawnTarget") exitWith { systemChat "No valid spawn point found, create one in Virtual Garage briefing!" }; 

	{ if !(isPlayer _x || typeOf _x == "Land_HelipadEmpty_F") then { deleteVehicle _x } } forEach (_spawnTarget nearEntities 5); 

	sleep 1; 
		
	BIS_fnc_garage_center = "Land_HelipadEmpty_F" createVehicleLocal getPos _spawnTarget;
	["Open", [true]] call BIS_fnc_garage; 

	_spawnTarget spawn { 
		waitUntil { uiSleep 1; isNull (uiNamespace getVariable["BIS_fnc_arsenal_cam", objNull]) }; 

		if (typeOf BIS_fnc_garage_center == "Land_HelipadEmpty_F") exitWith {}; 

		private _obj = BIS_fnc_garage_center; 
		private _type = typeOf BIS_fnc_garage_center; 
		private _call = [BIS_fnc_garage_center, ""] call BIS_fnc_exportVehicle; 

		BIS_fnc_garage_center setPos [0,0,0]; 
		{ BIS_fnc_garage_center deleteVehicleCrew _x } forEach crew BIS_fnc_garage_center;  
		deleteVehicle BIS_fnc_garage_center; 

		sleep 0.1; 

		BIS_fnc_garage_center = createVehicle [_type, getPos _this, [], 0, "NONE"]; 
		BIS_fnc_garage_center setDir getDir _this; 
		BIS_fnc_garage_center call compile _call;
	};
};

private _VGtext = "<font size='18' color='#FF7F00'>Virtual Garage</font><br/>
	Set Vehicle Spawn Location: <execute expression=""ZEU_VG_Object setPos getPos player; systemChat format['[VG] Spawn Position Set To: %1', getPos ZEU_VG_Object];"">At Location</execute> | 
	<execute expression=""systemChat '[VG] Click map to set vehicle spawn position!'; ZEU_VG_SpawnClick = addMissionEventHandler ['MapSingleClick', { ZEU_VG_Object setPos (_this#1); systemChat format['[VG] Spawn Position Set To: %1', getPos ZEU_VG_Object]; removeMissionEventHandler ['MapSingleClick', ZEU_VG_SpawnClick]; }];"">Select Location</execute><br/><br/>
	<execute expression=""[] spawn ZEU_fnc_StartVirtualGarage;"">Open Virtual Garage</execute><br/>";

player createDiaryRecord ["diary", ["Virtual Garage", _VGtext]];