// Functions such as medical and radios are called directly since postInit didn't seem to be completing on Altis map?
class F
{
	class common
	{
		file = "f\common";
		class logIssue{};
		class processParamsArray{ preInit = 1; postInit = 1; };
		class spectateInit{};
	};
	class missionConditions
	{
		file = "f\missionConditions";
		class setConditions{ preInit = 1; };
	};
	class assignGear
    {
        file = "f\assignGear";
        class assignGear{};
    };
	class ace3
	{
		file = "mission\ace";
		class ace_medicalConverter{};
	};
	class medical_init
	{
		file = "f\medical";
		class medical_init{ postInit = 1; };
	};
	class radio_init
	{
		file = "f\radios";
		class radio_init{ postInit = 1; };
	};
    class zeus
	{
		file = "f\zeus";
		class zeusInit{ postInit = 1; };
	};
};