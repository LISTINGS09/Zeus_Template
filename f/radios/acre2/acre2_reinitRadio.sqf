if (time < 1) exitWith {
  systemChat "[ACRE] Wait until the mission has started to reinitialize your radio.";
};

[] execVM "f\radios\acre2\acre2_init.sqf";

systemChat "[ACRE] Radio re-initialised.";