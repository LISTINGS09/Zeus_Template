// Array of all groups that need IDs/Markers.
// FORMAT: [groupIDVariable,groupName,markerType,markerName,markerColor,createChannelGroup]
// * Markers are NEVER shared between sides.
// * You can edit the RGBA values to change the colours.
// * You can delete any groups you're not using (e.g. remove '_grpBLU = [ ... ];' if you're OPFOR).
// ====================================================================================
private ["_red", "_blue", "_green", "_yellow", "_orange", "_purple", "_black", "_white", "_blufor", "_opfor"];
_red = 		[1,   0,   0,   1	];
_blue = 	[0,   0,   1,   1	];
_green = 	[0,   0.5, 0,   1	];
_yellow = 	[1,   1,   0,   1	];
_orange = 	[1,   0.6, 0,   1	];
_purple	=	[0.5, 0,   0.5, 1 	];
_black =	[0,   0,   0,   1	];
_white =	[1,   1,   1,   1	];
_blufor = 	[0,   0.3, 0.6, 1	];
_opfor = 	[0.5, 0,   0,   1	];

_grpBLU = [
	["GrpBLU_CO","CO","b_hq","CO",_yellow]
	,["GrpBLU_DC","JTAC","b_hq","J",_yellow]
	,["GrpBLU_ASL","Alpha","b_inf","A",_red]
	,["GrpBLU_BSL","Bravo","b_inf","B",_blue]
	,["GrpBLU_CSL","Charlie","b_inf","C",_green]
	,["GrpBLU_DSL","Delta","b_inf","D",_orange]
	,["GrpBLU_ESL","Echo","b_inf","E",_black]
	,["GrpBLU_MMG1","MMG","b_support","MMG",_orange]
	,["GrpBLU_HMG1","HMG","b_support","HMG",_orange]
	,["GrpBLU_MAT1","MAT","b_motor_inf","MAT",_orange]
	,["GrpBLU_HAT1","HAT","b_motor_inf","HAT",_orange]
	,["GrpBLU_MTR1","Mortar","b_mortar","MTR",_orange]
	,["GrpBLU_MSAM1","MSAM","b_motor_inf","MSAM",_orange]
	,["GrpBLU_HSAM1","HSAM","b_motor_inf","HSAM",_orange]
	,["GrpBLU_ST1","Recon","b_recon","REC",_orange]
	,["GrpBLU_DT1","Diver","b_recon","DIV",_orange]
	,["GrpBLU_ENG1","ENG","b_maint","ENG",_orange]
	,["GrpBLU_IFV1","IFV1","b_mech_inf","IFV1",_orange]
	,["GrpBLU_IFV2","IFV2","b_mech_inf","IFV2",_orange]
	,["GrpBLU_IFV3","IFV3","b_mech_inf","IFV3",_orange]
	,["GrpBLU_IFV4","IFV4","b_mech_inf","IFV4",_orange]
	,["GrpBLU_IFV5","IFV5","b_mech_inf","IFV5",_orange]
	,["GrpBLU_TNK1","Thunder","b_armor","THU",_black]
	,["GrpBLU_TH1","Vector1","b_air","V1",_purple]
	,["GrpBLU_TH2","Vector2","b_air","V2",_purple]
	,["GrpBLU_TH3","Vector3","b_air","V3",_purple]
	,["GrpBLU_TH4","Vector4","b_air","V4",_purple]
	,["GrpBLU_TH5","Vector5","b_air","V5",_purple]
	,["GrpBLU_AH1","Hawk","b_air","HWK",_black]
];

_grpOPF = [
	["GrpOPF_CO","CO","o_hq","CO",_yellow]
	,["GrpOPF_DC","JTAC","o_hq","J",_yellow]
	,["GrpOPF_ASL","Alpha","o_inf","A",_red]
	,["GrpOPF_BSL","Bravo","o_inf","B",_blue]
	,["GrpOPF_CSL","Charlie","o_inf","C",_green]
	,["GrpOPF_DSL","Delta","o_inf","D",_orange]
	,["GrpOPF_ESL","Echo","o_inf","E",_black]
	,["GrpOPF_MMG1","MMG","o_support","MMG",_orange]
	,["GrpOPF_HMG1","HMG","o_support","HMG",_orange]
	,["GrpOPF_MAT1","MAT","o_motor_inf","MAT",_orange]
	,["GrpOPF_HAT1","HAT","o_motor_inf","HAT",_orange]
	,["GrpOPF_MTR1","MTR","o_mortar","MTR",_orange]
	,["GrpOPF_MSAM1","MSAM","o_motor_inf","MSAM",_orange]
	,["GrpOPF_HSAM1","HSAM","o_motor_inf","HSAM",_orange]
	,["GrpOPF_ST1","Recon","o_recon","REC",_orange]
	,["GrpOPF_DT1","Diver","o_recon","DIV",_orange]
	,["GrpOPF_ENG1","ENG","o_maint","ENG",_orange]
	,["GrpOPF_IFV1","IFV1","o_mech_inf","I1",_orange]
	,["GrpOPF_IFV2","IFV2","o_mech_inf","I2",_orange]
	,["GrpOPF_IFV3","IFV3","o_mech_inf","I3",_orange]
	,["GrpOPF_IFV4","IFV4","o_mech_inf","I4",_orange]
	,["GrpOPF_IFV5","IFV5","o_mech_inf","I5",_orange]
	,["GrpOPF_TNK1","Thunder","o_armor","THU",_black]
	,["GrpOPF_TH1","Vector1","o_air","V1",_purple]
	,["GrpOPF_TH2","Vector2","o_air","V2",_purple]
	,["GrpOPF_TH3","Vector3","o_air","V3",_purple]
	,["GrpOPF_TH4","Vector4","o_air","V4",_purple]
	,["GrpOPF_TH5","Vector5","o_air","V5",_purple]
	,["GrpOPF_AH1","HAWK","o_air","HWK",_black]
];

_grpIND = [
	["GrpIND_CO","CO","n_hq","CO",_yellow]
	,["GrpIND_DC","JTAC","n_hq","J",_yellow]
	,["GrpIND_ASL","Alpha","n_inf","A",_red]
	,["GrpIND_BSL","Bravo","n_inf","B",_blue]
	,["GrpIND_CSL","Charlie","n_inf","C",_green]
	,["GrpIND_DSL","Delta","n_inf","D",_orange]
	,["GrpIND_ESL","Echo","n_inf","E",_black]
	,["GrpIND_MMG1","MMG","n_support","MMG",_orange]
	,["GrpIND_HMG1","HMG","n_support","HMG",_orange]
	,["GrpIND_MAT1","MAT","n_motor_inf","MAT",_orange]
	,["GrpIND_HAT1","HAT","n_motor_inf","HAT",_orange]
	,["GrpIND_MTR1","MTR","n_mortar","MTR",_orange]
	,["GrpIND_MSAM1","MSAM","n_motor_inf","MSAM",_orange]
	,["GrpIND_HSAM1","HSAM","n_motor_inf","HSAM",_orange]
	,["GrpIND_ST1","Recon","n_recon","REC",_orange]
	,["GrpIND_DT1","Diver","n_recon","DIV",_orange]
	,["GrpIND_ENG1","Engineer","n_maint","ENG",_orange]
	,["GrpIND_IFV1","IFV1","n_mech_inf","I1",_orange]
	,["GrpIND_IFV2","IFV2","n_mech_inf","I2",_orange]
	,["GrpIND_IFV3","IFV3","n_mech_inf","I3",_orange]
	,["GrpIND_IFV4","IFV4","n_mech_inf","I4",_orange]
	,["GrpIND_IFV5","IFV5","n_mech_inf","I5",_orange]
	,["GrpIND_TNK1","Thunder","n_armor","THU",_black]
	,["GrpIND_TH1","Vector1","n_air","V1",_purple]
	,["GrpIND_TH2","Vector2","n_air","V2",_purple]
	,["GrpIND_TH3","Vector3","n_air","V3",_purple]
	,["GrpIND_TH4","Vector4","n_air","V4",_purple]
	,["GrpIND_TH5","Vector5","n_air","V5",_purple]
	,["GrpIND_AH1","Hawk","n_air","HWK",_black]
];