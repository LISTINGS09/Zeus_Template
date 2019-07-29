//////////////////////////////
//    Dynamic-AI-Creator    //
//    Version 3.1b - 2014   //
//--------------------------//
//    DAC_Config_Camps      //
//--------------------------//
//    Script by Silola      //
//    silola@freenet.de     //
//////////////////////////////

private [
			"_CampTyp","_campBasic","_campAmmo","_campStatic","_campWall","_campObjInit",
			"_campUserObj","_campAddUnit","_campRandomObj","_Unit_Pool_C","_array"
		];

			_CampTyp = _this select 0;_array = [];

// CSAT 0, 2 
// NATO 1, 3
// FIA 	4
// IND	5
			
switch (_CampTyp) do
{
//-------------------------------------------------------------------------------------------------------------------------
	case 0:		// OPFOR 3 mortars
	{
		_campBasic     = ["Flag_CSAT_F",["FirePlace_burning_f",15,10,0],["Land_BagBunker_Tower_F",10,0,0],["Logic",10,15,0],0];
		_campAmmo      = [];
		_campStatic    = [["O_Mortar_01_F",-7,25,0,"O_Soldier_F"],["O_Mortar_01_F",25,25,0,"O_Soldier_F"],["O_Mortar_01_F",25,-20,180,"O_Soldier_F"]];
		_campAddUnit   = [];
		_campUserObj   = [];
		_campRandomObj = [];
		_campWall      = [];
		_campObjInit   = [[],[],[],[],[],[],[]];
	};
//-------------------------------------------------------------------------------------------------------------------------
	case 1:		// NATO 3 mortars
	{
		_campBasic     = ["Flag_NATO_F",["FirePlace_burning_f",15,10,0],["Land_BagBunker_Tower_F",10,0,0],["Logic",10,15,0],0];
		_campAmmo      = [];
		_campStatic    = [["B_Mortar_01_F",-7,25,0,"B_Soldier_F"],["B_Mortar_01_F",25,25,0,"B_Soldier_F"],["B_Mortar_01_F",25,-20,180,"B_Soldier_F"]];
		_campAddUnit   = [];
		_campUserObj   = [];
		_campRandomObj = [];
		_campWall      = [];
		_campObjInit   = [[],[],[],[],[],[],[]];
	};
//-------------------------------------------------------------------------------------------------------------------------
	case 2:		// AAF 3 mortars
	{
		_campBasic     = ["Flag_AAF_F",["FirePlace_burning_f",15,10,0],["Land_BagBunker_Tower_F",10,0,0],["Logic",10,15,0],0];
		_campAmmo      = [];
		_campStatic    = [["I_Mortar_01_F",-7,25,0,"I_Soldier_F"],["I_Mortar_01_F",25,25,0,"I_Soldier_F"],["I_Mortar_01_F",25,-20,180,"I_Soldier_F"]];
		_campAddUnit   = [];
		_campUserObj   = [];
		_campRandomObj = [];
		_campWall      = [];
		_campObjInit   = [[],[],[],[],[],[],[]];
	};
//-------------------------------------------------------------------------------------------------------------------------	
	case 3:		// FIA HMG as one static with 2 mortars
	{
		_campBasic     = ["Flag_FIA_F",["FirePlace_burning_f",15,10,0],["Land_BagBunker_Tower_F",10,0,0],["Logic",10,15,0],0];
		_campAmmo      = [];
		_campStatic    = [["B_G_Mortar_01_F",-7,25,0,"B_G_Soldier_F"],["B_G_Mortar_01_F",25,25,0,"B_G_Soldier_F"],["B_G_Mortar_01_F",25,-20,180,"B_G_Soldier_F"]];
		_campAddUnit   = [];
		_campUserObj   = [];
		_campRandomObj = [];
		_campWall      = [];
		_campObjInit   = [[],[],[],[],[],[],[]];
	};
//-------------------------------------------------------------------------------------------------------------------------
	case 4:		// OPFOR MRAP as one static with 2 mortars
	{
		_campBasic     = ["Flag_CSAT_F",["Land_WaterTank_F",10,10,0],["Land_Cargo_HQ_V1_F",10,0,180],["Logic",22,-22,0],0];
		_campAmmo      = [];
		_campStatic    = [["O_MRAP_02_hmg_F",-7,15,45,"O_crew_F"],["O_Mortar_01_F",15,-10,180,"O_crew_F"],["O_Mortar_01_F",-7,-10,180,"O_crew_F"]];
		_campAddUnit   = [];
		_campUserObj   = [["Land_LampHarbour_F",8,-8,0]];
		_campRandomObj = [];
		_campWall      = [];
		_campObjInit   = [[],[],[],[],[],[],[]];
	};
//-------------------------------------------------------------------------------------------------------------------------
	case 5:		// BLUFOR MRAP as one static with 2 mortars
	{
		_campBasic     = ["Flag_NATO_F",["Land_WaterTank_F",10,10,0],["Land_Cargo_HQ_V1_F",10,0,180],["Logic",22,-22,0],0];
		_campAmmo      = [];
		_campStatic    = [["B_MRAP_01_hmg_F",-7,15,45,"B_crew_F"],["B_Mortar_01_F",15,-10,180,"B_crew_F"],["B_Mortar_01_F",-7,-10,180,"B_crew_F"]];
		_campAddUnit   = [];
		_campUserObj   = [["Land_LampHarbour_F",8,-8,0]];
		_campRandomObj = [];
		_campWall      = [];
		_campObjInit   = [[],[],[],[],[],[],[]];
	};
//-------------------------------------------------------------------------------------------------------------------------
	case 6:		// AAF MRAP as one static with 2 mortars
	{
		_campBasic     = ["Flag_AAF_F",["Land_WaterTank_F",10,10,0],["Land_Cargo_HQ_V1_F",10,0,180],["Logic",22,-22,0],0];
		_campAmmo      = [];
		_campStatic    = [["I_MRAP_03_hmg_F",-7,15,45,"I_crew_F"],["I_Mortar_01_F",15,-10,180,"I_crew_F"],["I_Mortar_01_F",-7,-10,180,"I_crew_F"]];
		_campAddUnit   = [];
		_campUserObj   = [["Land_LampHarbour_F",8,-8,0]];
		_campRandomObj = [];
		_campWall      = [];
		_campObjInit   = [[],[],[],[],[],[],[]];
	};
//-------------------------------------------------------------------------------------------------------------------------	
	case 7:		// FIA HMG as one static with 2 mortars
	{
		_campBasic     = ["Flag_FIA_F",["Land_WaterTank_F",10,10,0],["Land_Cargo_HQ_V1_F",10,0,180],["Logic",22,-22,0],0];
		_campAmmo      = [];
		_campStatic    = [["B_G_Offroad_01_armed_F",-7,15,45,"B_G_Soldier_F"],[" B_G_Mortar_01_F ",15,-10,180,"B_G_Soldier_F"],[" B_G_Mortar_01_F ",-7,-10,180,"B_G_Soldier_F"]];
		_campAddUnit   = [];
		_campUserObj   = [["Land_LampHarbour_F",8,-8,0]];
		_campRandomObj = [];
		_campWall      = [];
		_campObjInit   = [[],[],[],[],[],[],[]];
	};
//-------------------------------------------------------------------------------------------------------------------------
	case 8:		// OPFOR  HQ with 4 x towers 2 x mortar    big walls closed on N side large opening S side 
	{
		_campBasic     = ["Flag_CSAT_F",["Land_WaterTank_F",8,5,0],["Land_Cargo_HQ_V1_F",9,1,180],["Logic",8,-36,0],0];
		_campAmmo      = [];
		_campStatic    = [["O_Mortar_01_F",0,12,0,"O_crew_F"],["O_Mortar_01_F",14,12,0,"O_crew_F"]];
		_campAddUnit   = [];
		_campUserObj   = [
			["Land_Cargo_Patrol_V3_F",-7,26,180],["Land_Cargo_Patrol_V3_F",25,26,180],["Land_Cargo_Patrol_V3_F",24,-23,270],["Land_Cargo_Patrol_V3_F",-9,-23,90],
			["Land_Cargo_House_V3_F",2,20,0],["Land_Cargo_House_V3_F",9,20,0],
			["Land_Mil_ConcreteWall_F",-2,12,90],["Land_Mil_ConcreteWall_F",17,12,90],
			["Land_ClutterCutter_large_F",1,12,90],["Land_ClutterCutter_large_F",13,12,90],["Land_ClutterCutter_large_F",4,-7,0]
		];
		_campRandomObj = [];
		_campWall      = ["Land_Mil_WallBig_4m_F",[-10,30],[40,56,0],[0,2,4,2],[1,0.1],[0,0]];
		_campObjInit   = [[],[],[],[],[],[],[]];
	};
//-------------------------------------------------------------------------------------------------------------------------
	case 9:		// BLUFOR  HQ with 4 x towers 2 x mortar 	big walls closed on N side large opening S side 
	{
		_campBasic     = ["Flag_NATO_F",["Land_WaterTank_F",8,5,0],["Land_Cargo_HQ_V1_F",9,1,180],["Logic",8,-36,0],0];
		_campAmmo      = [];
		_campStatic    = [["B_Mortar_01_F",0,12,0,"B_crew_F"],["B_Mortar_01_F",14,12,0,"B_crew_F"]]; //between HQ and houses N
		_campAddUnit   = [];
		_campUserObj   = [ //topleft, topright, bottomright, bottomleft (or clockwise from top left quadrant)
			["Land_Cargo_Patrol_V1_F",-7,26,180],["Land_Cargo_Patrol_V2_F",25,26,180],["Land_Cargo_Patrol_V1_F",24,-23,270],["Land_Cargo_Patrol_V1_F",-9,-23,90],
			["Land_Cargo_House_V1_F",2,20,0],["Land_Cargo_House_V1_F",9,20,0],
			["Land_Mil_ConcreteWall_F",-2,12,90],["Land_Mil_ConcreteWall_F",17,12,90], // beside mortars
			["Land_ClutterCutter_large_F",1,12,90],["Land_ClutterCutter_large_F",13,12,90],["Land_ClutterCutter_large_F",4,-7,0], // grasscutters
			["Box_NATO_Ammo_F",5,6,0]
		];
		_campRandomObj = [];
		_campWall      = ["Land_Mil_WallBig_4m_F",[-10,30],[40,56,0],[0,2,4,2],[1,0.1],[0,0]];
						//["Land_Mil_ConcreteWall_F",[-10,30],[40,56,0],[5,5,5,5],[1,0.2],[0,0]];
		_campObjInit   = [[],[],[],[],[],[],[]];
	};
//-------------------------------------------------------------------------------------------------------------------------
	case 10:		// AAF  HQ with 4 x towers 2 x mortar    big walls closed on N side large opening S side 
	{
		_campBasic     = ["Flag_AAF_F",["Land_WaterTank_F",8,5,0],["Land_Cargo_HQ_V1_F",9,1,180],["Logic",8,-36,0],0];
		_campAmmo      = [];
		_campStatic    = [["I_Mortar_01_F",0,12,0,"I_crew_F"],["I_Mortar_01_F",14,12,0,"I_crew_F"]];
		_campAddUnit   = [];
		_campUserObj   = [
			["Land_Cargo_Patrol_V2_F",-7,26,180],["Land_Cargo_Patrol_V1_F",25,26,180],["Land_Cargo_Patrol_V1_F",24,-23,270],["Land_Cargo_Patrol_V1_F",-9,-23,90],
			["Land_Cargo_House_V2_F",2,20,0],["Land_Cargo_House_V1_F",9,20,0],
			["Land_Mil_ConcreteWall_F",-2,12,90],["Land_Mil_ConcreteWall_F",17,12,90],
			["Land_ClutterCutter_large_F",1,12,90],["Land_ClutterCutter_large_F",13,12,90],["Land_ClutterCutter_large_F",4,-7,0]
		];
		_campRandomObj = [];
		_campWall      = ["Land_Mil_WallBig_4m_F",[-10,30],[40,56,0],[0,2,4,2],[1,0.1],[0,0]];
		_campObjInit   = [[],[],[],[],[],[],[]];
	};
//-------------------------------------------------------------------------------------------------------------------------
	case 11:		// FIA  HQ with 4 x towers 2 x mortar    big walls closed on N side large opening S side 
	{
		_campBasic     = ["Flag_FIA_F",["Land_WaterTank_F",8,5,0],["Land_Cargo_HQ_V1_F",9,1,180],["Logic",8,-36,0],0];
		_campAmmo      = [["Box_NATO_Ammo_F",7,-6,90]];
		_campStatic    = [["B_G_Mortar_01_F",0,12,0,"B_G_crew_F"],["B_G_Mortar_01_F",14,12,0,"B_G_crew_F"]]; //between HQ and houses N
		_campAddUnit   = [];
		_campUserObj   = [ //topleft, topright, bottomright, bottomleft (or clockwise from top left quadrant)
			["Land_Cargo_Patrol_V2_F",-7,26,180],["Land_Cargo_Patrol_V2_F",25,26,180],["Land_Cargo_Patrol_V2_F",24,-23,270],["Land_Cargo_Patrol_V1_F",-9,-23,90],
			["Land_Cargo_House_V1_F",2,20,0],["Land_Cargo_House_V2_F",9,20,0],
			["Land_Mil_ConcreteWall_F",-2,12,90],["Land_Mil_ConcreteWall_F",17,12,90], // beside mortars
			["Land_ClutterCutter_large_F",1,12,90],["Land_ClutterCutter_large_F",13,12,90],["Land_ClutterCutter_large_F",4,-7,0] // grasscutters
		];
		_campRandomObj = [];
		_campWall      = ["Land_Mil_ConcreteWall_F",[-10,30],[40,56,0],[5,5,5,5],[1,0.2],[0,0]];
		_campObjInit   = [[],[],[],[],[],[],[]];
	};
	Default {
				if(DAC_Basic_Value != 5) then
				{
					DAC_Basic_Value = 5;publicVariable "DAC_Basic_Value";
					//hintc "Error: DAC_Config_Camps > No valid config number";
					["[x] Error: DAC_Config_Camps > No valid config number"] call BIS_fnc_error;
				};
				if(true) exitWith {};
			};
};

_array = [_campBasic,_campAmmo,_campStatic,_campAddUnit,_campUserObj,_campRandomObj,_campWall,_campObjInit];
_array