// 	Zeus - Fireteam Member Markers
if (!hasInterface || playerSide == sideLogic) exitWith {};

// Disable these by default if we're running ACE.
if (isNil "f_var_ShowFTMarkers") then { f_var_ShowFTMarkers = !(isClass(configFile >> "CfgPatches" >> "ace_main")) };

// MAKE SURE THE PLAYER INITIALIZES PROPERLY
if (!isNil "f_eh_ftmap") then { findDisplay 12 displayCtrl 51 ctrlRemoveEventHandler ["Draw", f_eh_ftmap] };
//if (!isNil "f_eh_ftgps") then { ((uiNamespace getVariable ["RscCustomInfoMiniMap", displayNull]) displayCtrl 13301) controlsGroupCtrl 101 ctrlRemoveEventHandler ["Draw", f_eh_ftgps] };

waitUntil {sleep 0.1; !isNull player};

f_fnc_drawFTMarker = {
	{
		// Allow display to be controlled in-mission
		if !(f_var_ShowFTMarkers) exitWith {};
		
		_iconDir = getDir vehicle _x;
		_iconSize = (0.5 / ctrlMapScale (_this#0)) min 20;
		_iconShape = getText (configFile >> "CfgVehicles" >> typeOf (vehicle _x) >> "icon");

		// Switch color according a team
		_iconColor = switch (assignedTeam _x) do {
			case "RED": { [1,0,0,0.7] };
			case "GREEN": { [0,1,0,0.7] };
			case "BLUE": { [0,0.5,1,0.7] };
			case "YELLOW": { [1,1,0,0.7] };
			default { [1,1,1,1] };
		};
		
		_text = format ["%1",name _x];

		if (!isPlayer _x) then { 
			_text = "AI";
			_iconColor set [3,0.5];
		};
		
		// Check if we're allowed to show the injured icons
		if (missionNamespace getVariable ["f_var_ShowInjured",true]) then {
			// Show incapacitated units if allowed
			if ((_x getVariable["ACE_isUnconscious",false]) || lifeState _x == "INCAPACITATED") then {
				_iconShape = "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_forceRespawn_ca.paa";
				_iconColor = [1,0.1,0.1,0.7];
				_text = format ["%1 (Injured)", name _x];
				_iconDir = 0;
			};
			
			// Show stabilised units if allowed
			if (_x getVariable "FAR_var_isStable") then { 
				_iconShape = "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_revive_ca.paa";
				_iconColor = [0.7,0.0,0.6,0.7];
				_text = format ["%1 (Stable)", name _x];
				_iconDir = 0;
			};
		};
		
		// Hide the leaders icon if group markers are being used
		if  (leader _x == _x && (missionNamespace getVariable ["f_param_groupMarkers",0]) > 0) then { _iconShape = "" };
		
		// No text if we're zoomed out.
		if (ctrlMapScale (_this#0) > 0.02) then { _text = "" };

		if (_iconShape != "") then {
			_this select 0 drawIcon
			[
				_iconShape,
				_iconColor,
				visiblePosition vehicle _x,
				_iconSize,
				_iconSize,
				_iconDir,
				_text,
				1,
				0.035,
				(missionNamespace getVariable ["F_FONT_NAMETAGS","PuristaBold"]),
				'right'
			]
		};
	} forEach (units player) select { alive _x };
};

f_eh_ftmap = findDisplay 12 displayCtrl 51 ctrlAddEventHandler ["Draw", f_fnc_drawFTMarker];

/*
private _display = uiNamespace getVariable ["RscCustomInfoMiniMap", displayNull];
private _miniMapControlGroup = _display displayCtrl 13301;
private _miniMap = _miniMapControlGroup controlsGroupCtrl 101;

f_eh_ftgps = _miniMap ctrlAddEventHandler ["Draw", f_fnc_drawFTMarker];
*/