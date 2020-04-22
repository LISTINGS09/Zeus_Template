// Array of all groups that need IDs/Markers.
// FORMAT: [groupIDVariable,groupName,markerType,markerName,markerColor,createChannelGroup]
// * Markers are NEVER shared between sides.
// * You can edit the RGBA values to change the colours.
// * You can delete any groups you're not using (e.g. remove '_grpBLU = [ ... ];' if you're OPFOR).
// ====================================================================================
private ["_red", "_blue", "_green", "_yellow", "_orange", "_purple", "_black", "_white"];
_red = 		[1,   0,   0,   1	];
_blue = 	[0,   0,   1,   1	];
_green = 	[0,   0.5, 0,   1	];
_yellow = 	[1,   1,   0,   1	];
_orange = 	[1,   0.6, 0,   1	];
_purple	=	[0.5, 0,   0.5, 1 	];
_black =	[0,   0,   0,   1	];
_white =	[1,   1,   1,   1	];

_grpBLU = [
	["GrpBLU_CO","CO","b_hq","CO",_yellow]
	,["GrpBLU_DC","JTAC","b_hq","J",_yellow]
	,["GrpBLU_ASL","Alpha","b_inf","A",_red]
	,["GrpBLU_BSL","Bravo","b_inf","B",_blue]
	,["GrpBLU_CSL","Charlie","b_inf","C",_green]
	,["GrpBLU_DSL","Delta","b_inf","D",_orange]
	,["GrpBLU_ESL","Echo","b_inf","E",_black]
	,["GrpBLU_MMG1","MMG","b_support","MMG1",_orange]
	,["GrpBLU_HMG1","HMG","b_support","HMG1",_orange]
	,["GrpBLU_MAT1","MAT","b_motor_inf","MAT1",_orange]
	,["GrpBLU_HAT1","HAT","b_motor_inf","HAT1",_orange]
	,["GrpBLU_MTR1","MTR","b_mortar","MTR1",_orange]
	,["GrpBLU_MSAM1","MSAM","b_motor_inf","MSAM1",_orange]
	,["GrpBLU_HSAM1","HSAM","b_motor_inf","HSAM1",_orange]
	,["GrpBLU_ST1","ST","b_recon","ST1",_orange]
	,["GrpBLU_DT1","DT","b_recon","DT1",_orange]
	,["GrpBLU_ENG1","ENG","b_maint","ENG1",_orange]
	,["GrpBLU_IFV1","IFV1","b_mech_inf","IFV1",_red]
	,["GrpBLU_IFV2","IFV2","b_mech_inf","IFV2",_blue]
	,["GrpBLU_IFV3","IFV3","b_mech_inf","IFV3",_green]
	,["GrpBLU_IFV4","IFV4","b_mech_inf","IFV4",_orange]
	,["GrpBLU_IFV5","IFV5","b_mech_inf","IFV5",_black]
	,["GrpBLU_TNK1","Thunder","b_armor","THU",_red]
	,["GrpBLU_TH1","Vector1","b_air","V1",_red]
	,["GrpBLU_TH2","Vector2","b_air","V2",_blue]
	,["GrpBLU_TH3","Vector3","b_air","V3",_green]
	,["GrpBLU_TH4","Vector4","b_air","V4",_orange]
	,["GrpBLU_TH5","Vector5","b_air","V5",_black]
	,["GrpBLU_AH1","Hawk","b_air","HWK",_red]
];

_grpOPF = [
	["GrpOPF_CO","CO","b_hq","CO",_yellow]
	,["GrpOPF_DC","JTAC","b_hq","J",_yellow]
	,["GrpOPF_ASL","Alpha","b_inf","A",_red]
	,["GrpOPF_BSL","Bravo","b_inf","B",_blue]
	,["GrpOPF_CSL","Charlie","b_inf","C",_green]
	,["GrpOPF_DSL","Delta","b_inf","D",_orange]
	,["GrpOPF_ESL","Echo","b_inf","E",_black]
	,["GrpOPF_MMG1","MMG","b_support","MMG1",_orange]
	,["GrpOPF_HMG1","HMG","b_support","HMG1",_orange]
	,["GrpOPF_MAT1","MAT","b_motor_inf","MAT1",_orange]
	,["GrpOPF_HAT1","HAT","b_motor_inf","HAT1",_orange]
	,["GrpOPF_MTR1","MTR","b_mortar","MTR1",_orange]
	,["GrpOPF_MSAM1","MSAM","b_motor_inf","MSAM1",_orange]
	,["GrpOPF_HSAM1","HSAM","b_motor_inf","HSAM1",_orange]
	,["GrpOPF_ST1","ST","b_recon","ST1",_orange]
	,["GrpOPF_DT1","DT","b_recon","DT1",_orange]
	,["GrpOPF_ENG1","ENG","b_maint","ENG1",_orange]
	,["GrpOPF_IFV1","IFV1","b_mech_inf","IFV1",_red]
	,["GrpOPF_IFV2","IFV2","b_mech_inf","IFV2",_blue]
	,["GrpOPF_IFV3","IFV3","b_mech_inf","IFV3",_green]
	,["GrpOPF_IFV4","IFV4","b_mech_inf","IFV4",_orange]
	,["GrpOPF_IFV5","IFV5","b_mech_inf","IFV5",_black]
	,["GrpOPF_TNK1","Thunder","b_armor","THU",_red]
	,["GrpOPF_TH1","Vector1","b_air","V1",_red]
	,["GrpOPF_TH2","Vector2","b_air","V2",_blue]
	,["GrpOPF_TH3","Vector3","b_air","V3",_green]
	,["GrpOPF_TH4","Vector4","b_air","V4",_orange]
	,["GrpOPF_TH5","Vector5","b_air","V5",_black]
	,["GrpOPF_AH1","HAWK","b_air","HWK",_red]
];

_grpIND = [
	["GrpIND_CO","CO","b_hq","CO",_yellow]
	,["GrpIND_DC","JTAC","b_hq","J",_yellow]
	,["GrpIND_ASL","Alpha","b_inf","A",_red]
	,["GrpIND_BSL","Bravo","b_inf","B",_blue]
	,["GrpIND_CSL","Charlie","b_inf","C",_green]
	,["GrpIND_DSL","Delta","b_inf","D",_orange]
	,["GrpIND_ESL","Echo","b_inf","E",_black]
	,["GrpIND_MMG1","MMG","b_support","MMG1",_orange]
	,["GrpIND_HMG1","HMG","b_support","HMG1",_orange]
	,["GrpIND_MAT1","MAT","b_motor_inf","MAT1",_orange]
	,["GrpIND_HAT1","HAT","b_motor_inf","HAT1",_orange]
	,["GrpIND_MTR1","MTR","b_mortar","MTR1",_orange]
	,["GrpIND_MSAM1","MSAM","b_motor_inf","MSAM1",_orange]
	,["GrpIND_HSAM1","HSAM","b_motor_inf","HSAM1",_orange]
	,["GrpIND_ST1","ST","b_recon","ST1",_orange]
	,["GrpIND_DT1","DT","b_recon","DT1",_orange]
	,["GrpIND_ENG1","ENG","b_maint","ENG1",_orange]
	,["GrpIND_IFV1","IFV1","b_mech_inf","IFV1",_red]
	,["GrpIND_IFV2","IFV2","b_mech_inf","IFV2",_blue]
	,["GrpIND_IFV3","IFV3","b_mech_inf","IFV3",_green]
	,["GrpIND_IFV4","IFV4","b_mech_inf","IFV4",_orange]
	,["GrpIND_IFV5","IFV5","b_mech_inf","IFV5",_black]
	,["GrpIND_TNK1","Thunder","b_armor","THU",_red]
	,["GrpIND_TH1","Vector1","b_air","V1",_red]
	,["GrpIND_TH2","Vector2","b_air","V2",_blue]
	,["GrpIND_TH3","Vector3","b_air","V3",_green]
	,["GrpIND_TH4","Vector4","b_air","V4",_orange]
	,["GrpIND_TH5","Vector5","b_air","V5",_black]
	,["GrpIND_AH1","Hawk","b_air","HWK",_red]
];