// Zeus - Array Check Returns a random value from array if present.
// Returns a random value from the array, or only the first value.
// If not an array does nothing.
// ====================================================================================
params ["_toCheck",["_first",false]];

if (typeName _toCheck == "ARRAY") then { 
	if (_first) then {_toCheck select 0} else {selectRandom _toCheck};
} else { 
	_toCheck; 
};