// By Dimitri Yuri edited by 2600K
if !hasInterface exitWith {};

["TFAR_AI_Detection", "OnSpeak", {
	params ["_unit","_isSpeaking"];
	
	[_unit] spawn {
		params ["_unit"];
		
		// Exit if unit is isolated or DC'd
		if ((vehicle _unit) call TFAR_fnc_isVehicleIsolated || {isNil "_unit"}) exitWith {};
						
		_nearHostiles = [];
		
		switch (toLower TF_speak_volume_level) do {
			case "normal": { _nearHostiles = _unit nearEntities [["CAManBase"], 20];};
			case "yelling": { _nearHostiles = _unit nearEntities [["CAManBase"], 60];};
		}; 
		
		{
			// TODO: Consider increasing value the more they talk?
			// !(_x knowsAbout _unit >= 4.0))
			// [_x,[_unit,((_x knowsAbout _unit) + 1)]] remoteExec ["reveal",_x];
			
			if (!((vehicle _x) call TFAR_fnc_isVehicleIsolated) && {!isPlayer _x} && {alive _unit} && {_x knowsAbout _unit <= 1.5}) then {
				[_x,[_unit,1.5]] remoteExec ["reveal",2];
				//systemChat format["Revealing %1 to %2 (%3).",_unit,_x,_x knowsAbout _unit];
			};
		} forEach _nearHostiles;
	};
}, player] call TFAR_fnc_addEventHandler;