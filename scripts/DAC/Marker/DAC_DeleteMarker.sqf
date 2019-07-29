//////////////////////////////
//    Dynamic-AI-Creator    //
//    Version 3.1b - 2014   //
//--------------------------//
//    DAC_deleteMarker      //
//--------------------------//
//    Script by Silola      //
//    silola@freenet.de     //
//////////////////////////////

private ["_mArray"];		

_mArray  = _this select 0;

//waitUntil {DAC_Basic_Value == 1};

sleep 3; 

{deleteMarker _x}forEach _mArray;