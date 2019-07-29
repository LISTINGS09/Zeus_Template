/*
    Author: Karel Moricky
    Enhanced by Robalo
	Stolen by 2600K
    Description:
    Return all compatible weapon attachments
    
    Parameter(s):
        0: STRING - weapon class
        1: STRING - optional, accessory type: number (101 - muzzle, 201 - optic, 301 - pointer, 302 - bipod)
    Returns:
        ARRAY of STRINGs
    Examples:
        _acclist = ["LMG_Mk200_F"] call f_fnc_compatibleItems;
        _muzzleacclist = ["LMG_Mk200_F", 101] call f_fnc_compatibleItems;
*/

params [["_weapon", "", [""]], ["_typefilter", 0]];
if (_weapon == "") exitWith {[]};

private _cfgWeapon = configFile >> "CfgWeapons" >> _weapon;

if (isClass _cfgWeapon) then {
    private _compatibleItems = [];
    {
        private _cfgCompatibleItems = _x >> "compatibleItems";
        if (isArray _cfgCompatibleItems) then {
            {
                if !(_x in _compatibleItems) then {_compatibleItems pushBack configName (configFile >> "CfgWeapons" >> _x);};
            } forEach getArray _cfgCompatibleItems;
        } else {
            if (isClass _cfgCompatibleItems) then {
                {
                    if (getNumber _x > 0 && {!((configName _x) in _compatibleItems)}) then {_compatibleItems pushBack configName (configFile >> "CfgWeapons" >> (configName _x))};
                } forEach configProperties [_cfgCompatibleItems, "isNumber _x"];
            };
        };
    } forEach configProperties [_cfgWeapon >> "WeaponSlotsInfo","isClass _x"];
    if (_typefilter == 0) then {_compatibleItems} else {[_compatibleItems, {_typefilter == getNumber(configFile >> "CfgWeapons" >> _x >> "itemInfo" >> "type")}] call BIS_fnc_conditionalSelect};
};