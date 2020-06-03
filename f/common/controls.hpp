class ZEU_TS_BTN {
	deletable = 0;
	fade = 0;
	access = 0;
	idc = -1;
	type = 1;
	url = "";
	style = 0x02;
	x = 0;
	y = 0;
	w = 0.5;
	h = 0.039216;
	text = "";
	shadow = 2;
	sizeEx = 0.05;
	font = "RobotoCondensed";
	offsetX = 0;
	offsetY = 0;
	offsetPressedX = 0;
	offsetPressedY = 0;
	borderSize = 0;
	colorText[] = {0,1,1,1};
	colorDisabled[] = {1,1,1,0.25};
	colorBackground[] = {0.275,0.275,0.408,0.5};
	colorBackgroundDisabled[] = {0,0,0,0.5};
	colorBackgroundActive[] = {0.275,0.275,0.408,1};
	colorFocused[] = {0,0,0,1};
	colorShadow[] = {1,0,1,0};
	colorBorder[] = {0,1,0,1};
	colorSelect[] = {0,1,0,1};
	soundSelect[] = {};
	soundEnter[] = { "\A3\ui_f\data\sound\RscButton\soundEnter", 0.09, 1 };
	soundPush[] = { "\A3\ui_f\data\sound\RscButton\soundPush", 0.09, 1 };
	soundClick[] = { "\A3\ui_f\data\sound\RscButton\soundClick", 0.09, 1 };
	soundEscape[] = { "\A3\ui_f\data\sound\RscButton\soundEscape", 0.09, 1 };
};

class ZEU_TS_BTN1 : ZEU_TS_BTN {
	text = "Join Our Teamspeak";
	url = "ts3server://teamspeak.zeus-community.net:9987?addbookmark=ZEUS-COMMUNITY.NET";
};

class ZEU_TS_BTN2 : ZEU_TS_BTN {
	text = "Download Teamspeak";
	url = "https://teamspeak.com/en/downloads/";
};