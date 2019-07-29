*** NEVER OVERWRITE YOUR 'mission.sqm' FILE - THIS FILE CONTAINS ALL YOUR MISSION INFO! ***

Creating a Template Mision:
A template mission is used to copy/paste the frameork data to your own mission, you should already be familair with moving/editing mission files as part of mission development in Arma.
1. In Arma Eden Editor create and save an empty mission on the VR Map (we will overwrite this).
2. Go to: 'Scenario' > 'Open Scenario Folder' - This will minimise Arma and show your mission folder in windows.
3. Download and extract all the template files into this folder that pops up.
4. You should be prompted to overwrite 'mission.sqm'
5. Go back to Arma and re-open the mission, you should now see the template with groups and other bits.
6. Test the mission if needed.

Getting Started:
The template contains three folders;
'f' - Contains all the core framework files - You should never need to edit or even look at anything in here.
'mission' - Contains all files specific to the mission - You will need to make changes to these files (for briefing and scripts etc).
'scripts' - Contains extra common scripts (Gear/AI/QRF etc) that are optional for your mission, but is not required - You'll want to delete anything you don't use in here.

Arma does not support 'checking if a file exists' and will just crash if it is missing a file! Take care when deleting files.

FAQ:
Q: Can I access Zeus to test my mission?
A: Edit the 'mission\scripts.sqf' file; include your Player GUID against f_var_AuthorUID and Zeus will automatically be setup for you. or use the * ADMIN * menu from the map to assign a curator to yourself.

Q: None of my groups have markers showing on the map?
Q: My ORBAT shows Alpha1-1, Alpha1-2 etc for my groups?
A: Look in the 'mission\groups.sqf' file. A groups variable in Eden must match the variable name in this file. You have most likely not used the template groups and no group varialbe is set against your groups in Eden. 
For example, the BLUFOR CO will need a group variable (NOT a unit variable!) set to 'GrpBLU_CO' in Eden, this will give them an icon and show them correctly in the ORBAT. You can change the icon, color and even callsign of the group in this file too.

Q: How do I change the mission parameters (Setting time of day to Night etc).
A: Edit the 'mission\parameters.hpp' file; You can set the 'default' to match the corresponding 'values' in that list. 'Mission Default' parameter will always use the Eden Editor settings.

Q: How do I set Custom Radio Channels?
A: Edit the 'mission\radios.sqf' file; 'f_radios_settings_longRangeGroups' will list the names of all radio groups.

Q: How do I only give certain units radios?
A: Edit the 'mission\radios.sqf' file; 'f_radios_settings_longRangeUnits', 'f_radios_settings_personalRadio', 'f_radios_settings_riflemanRadio' all can be used to give radios to specific types of units (personal and rifleman radios are the same type in ACE)

Q: Extra ACE Items are being given to units I have not told them to have?
A: Edit the 'mission\ace\ace_clientInit.sqf' file. This script always gives players basic ACE equipment and common items for their roles.