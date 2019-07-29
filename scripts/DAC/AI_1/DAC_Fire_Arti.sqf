//////////////////////////////
//    Dynamic-AI-Creator    //
//    Version 3.1b - 2014   //
//--------------------------//
//    DAC_Fire_Arti         //
//--------------------------//
//    Script by Silola      //
//    silola@freenet.de     //
//////////////////////////////

sleep 5;
deleteVehicle (_this select 6);
(_this select 0) removeEventHandler ["fired", (_this select 0) getVariable "dac_event"];