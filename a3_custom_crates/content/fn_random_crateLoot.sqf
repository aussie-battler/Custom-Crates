//Random Loot Crates by Darth_Rogue & Chisel (tdwhite)  
//HUGE thanks to deadeye & Robio for helping work out the last bugs!
// Modified by Ghostrider-DBD- for better random loot distribution and adding vehicle crashes
//fn_random_crateLoot.sqf
//To be run server side via addon PBO


//*****************************LOOT LISTS************************
/*
	Loot types:
	0 = randomly selected loadout from the list below
	1 = building materials, sledges, hatchets and chainsaws.
	2 = weapons, mines, NVG, range finder, radios
	3 = misc loot, multiguns, other utility items.
	4 = weapons, vests, backpacks and headgear.
*/
diag_log "Loading Static Loot Container Spawning System";

_lootBoxes = [];

_worldName = toLower format ["%1", worldName];

_smokeNearCrate = true;  //turns on or off wrecks near crates  Recommended to turn this off if you need crates spawning in specific positions

switch (_worldName) do {
	case "altis":{
		diag_log "Altis-specific settings loaded";
			[[3748,11660,0],0],
			[[3924,11493,0],0],
			[[3681,11530,0],0],
			[[3816,11774,0],0]
	}; 
	case "stratis":{
		
	}; 
	case "chernarus":{
		diag_log "Chernarus-specific settings loaded";
	};
	case "chernarus_summer":{
	}; 
	case "bornholm":{
		// Setup for Bornholm AI controlled sector		
		_lootBoxes = [  // format as [_position, _lootType (range 1-4)] or [_position, 0] for randomly selected loot.
			[[7093.73,12145.4,0],0],
			[[7093.73,12140.4,0],0],
			[[7291.69,12044.5,0],0],
			[[7295.69,12044.5,0],0],	
			[[19288.5,22358.8,1.2],0],
			[[19633.8,22128.8,0],0], 
			[[11068.9,7125.94,0],0]	// ** Note that there is no comma after the last entry.
			]; 
	};
	case "tavi":{
	};
};
diag_log format["[crateLoot.sqf] --- >>> worldname is %1",_worldName]; 


//////////////////////////
// Uniforms //////////////
//////////////////////////
_loot_uniforms = [

// Civillian Clothing
"U_C_Journalist",
"U_C_Poloshirt_blue",
"U_C_Poloshirt_burgundy",
"U_C_Poloshirt_salmon",
"U_C_Poloshirt_stripped",
"U_C_Poloshirt_tricolour",
"U_C_Poor_1",
"U_C_Poor_2",
"U_C_Poor_shorts_1",
"U_C_Scientist",
"U_OrestesBody",
"U_Rangemaster",
"U_NikosAgedBody",
"U_NikosBody",
"U_Competitor",

// Soldier Uniforms
"U_B_CombatUniform_mcam",
"U_B_CombatUniform_mcam_tshirt",
"U_B_CombatUniform_mcam_vest",
"U_B_CombatUniform_mcam_worn",
"U_B_CTRG_1",
"U_B_CTRG_2",
"U_B_CTRG_3",
"U_I_CombatUniform",
"U_I_CombatUniform_shortsleeve",
"U_I_CombatUniform_tshirt",
"U_I_OfficerUniform",
"U_O_CombatUniform_ocamo",
"U_O_CombatUniform_oucamo",
"U_O_OfficerUniform_ocamo",
"U_B_SpecopsUniform_sgg",
"U_O_SpecopsUniform_blk",
"U_O_SpecopsUniform_ocamo",
"U_I_G_Story_Protagonist_F",

// Guerilla Uniforms
"U_C_HunterBody_grn",
"U_IG_Guerilla1_1",
"U_IG_Guerilla2_1",
"U_IG_Guerilla2_2",
"U_IG_Guerilla2_3",
"U_IG_Guerilla3_1",
"U_BG_Guerilla2_1",
"U_IG_Guerilla3_2",
"U_BG_Guerrilla_6_1",
"U_BG_Guerilla1_1",
"U_BG_Guerilla2_2",
"U_BG_Guerilla2_3",
"U_BG_Guerilla3_1",
"U_BG_leader",
"U_IG_leader",
"U_I_G_resistanceLeader_F",

// Ghillie Suits
"U_B_FullGhillie_ard",
"U_B_FullGhillie_lsh",
"U_B_FullGhillie_sard",
"U_B_GhillieSuit",
"U_I_FullGhillie_ard",
"U_I_FullGhillie_lsh",
"U_I_FullGhillie_sard",
"U_I_GhillieSuit",
"U_O_FullGhillie_ard",
"U_O_FullGhillie_lsh",
"U_O_FullGhillie_sard",
"U_O_GhillieSuit",

// Wet Suits
"U_I_Wetsuit",
"U_O_Wetsuit",
"U_B_Wetsuit",
"U_B_survival_uniform"
];

//////////////////////////
// Pistols ///////////////
//////////////////////////
_loot_pistols = [
["hgun_ACPC2_F","9Rnd_45ACP_Mag"],
["hgun_Rook40_F","16Rnd_9x21_Mag"],
["hgun_P07_F","16Rnd_9x21_Mag"],
["hgun_Pistol_heavy_01_F","11Rnd_45ACP_Mag"],
["hgun_Pistol_heavy_02_F","6Rnd_45ACP_Cylinder"]
];

//////////////////////////
// Rifles ////////////////
//////////////////////////
_loot_rifles = [
["arifle_Katiba_F","30Rnd_65x39_caseless_green"],
["arifle_Katiba_C_F","30Rnd_65x39_caseless_green"],
["arifle_Katiba_GL_F","30Rnd_65x39_caseless_green"],
["arifle_MXC_F","30Rnd_65x39_caseless_mag"],
["arifle_MX_F","30Rnd_65x39_caseless_mag"],
["arifle_MX_GL_F","30Rnd_65x39_caseless_mag"],
["arifle_MXM_F","30Rnd_65x39_caseless_mag"],
["arifle_SDAR_F","20Rnd_556x45_UW_mag"],
["arifle_TRG21_F","30Rnd_556x45_Stanag_Tracer_Red"],
["arifle_TRG20_F","30Rnd_556x45_Stanag_Tracer_Red"],
["arifle_TRG21_GL_F","30Rnd_556x45_Stanag_Tracer_Red"],
["arifle_Mk20_F","30Rnd_556x45_Stanag_Tracer_Green"],
["arifle_Mk20C_F","30Rnd_556x45_Stanag_Tracer_Green"],
["arifle_Mk20_GL_F","30Rnd_556x45_Stanag_Tracer_Green"],
["arifle_Mk20_plain_F","30Rnd_556x45_Stanag_Tracer_Yellow"],
["arifle_Mk20C_plain_F","30Rnd_556x45_Stanag_Tracer_Yellow"],
["arifle_Mk20_GL_plain_F","30Rnd_556x45_Stanag_Tracer_Yellow"],
["arifle_MXM_Black_F","30Rnd_65x39_caseless_mag_Tracer"],
["arifle_MX_GL_Black_F","30Rnd_65x39_caseless_mag_Tracer"],
["arifle_MX_Black_F","30Rnd_65x39_caseless_mag"],
["arifle_MXC_Black_F","30Rnd_65x39_caseless_mag"],
["Rollins_F","5Rnd_rollins_mag"]
];

//////////////////////////
// Sniper Rifles /////////
//////////////////////////
_loot_snipers = [
["srifle_EBR_F","20Rnd_762x51_Mag"],
["srifle_GM6_F","5Rnd_127x108_Mag"],
["srifle_LRR_F","7Rnd_408_Mag"],
["srifle_DMR_01_F","10Rnd_762x51_Mag"],
["srifle_DMR_02_camo_F","10Rnd_338_Mag"],
["srifle_DMR_02_F","10Rnd_338_Mag"],
["srifle_DMR_02_sniper_F","10Rnd_338_Mag"],
["srifle_DMR_03_F","10Rnd_338_Mag"],
["srifle_DMR_03_tan_F","10Rnd_338_Mag"],
["srifle_DMR_04_Tan_F","10Rnd_338_Mag"],
["srifle_DMR_05_hex_F","10Rnd_338_Mag"],
["srifle_DMR_05_tan_F","10Rnd_338_Mag"],
["srifle_DMR_06_camo_F","10Rnd_338_Mag"],
["srifle_DMR_04_F","10Rnd_127x54_Mag"],
["srifle_DMR_05_blk_F","10Rnd_93x64_DMR_05_Mag"],
["srifle_DMR_06_olive_F","20Rnd_762x51_Mag"]
];

//////////////////////////
// LMG ///////////////////
//////////////////////////
_loot_LMG = [
["LMG_Zafir_F","150Rnd_762x51_Box_Tracer"],
["MMG_01_hex_F","150Rnd_93x64_Mag"],
["MMG_01_tan_F","150Rnd_93x64_Mag"],
["MMG_02_black_F","150Rnd_93x64_Mag"],
["MMG_02_camo_F","150Rnd_93x64_Mag"],
["MMG_02_sand_F","150Rnd_93x64_Mag"],
["LMG_Mk200_F","200Rnd_65x39_cased_Box_Tracer"]
];

//////////////////////////
// SMG ///////////////////
//////////////////////////
_loot_SMG = [
["SMG_01_F","30Rnd_45ACP_Mag_SMG_01_tracer_green"],
["SMG_02_F","30Rnd_9x21_Mag"],
["hgun_PDW2000_F","30Rnd_9x21_Mag"]
];

//////////////////////////
// Explosives ////////////
//////////////////////////
_loot_explosives = [
"HandGrenade",
"MiniGrenade",
"B_IR_Grenade",
"O_IR_Grenade",
"I_IR_Grenade",
"1Rnd_HE_Grenade_shell",
"3Rnd_HE_Grenade_shell",
"APERSBoundingMine_Range_Mag",
"APERSMine_Range_Mag",
"APERSTripMine_Wire_Mag",
"ClaymoreDirectionalMine_Remote_Mag",
"DemoCharge_Remote_Mag",
"IEDLandBig_Remote_Mag",
"IEDLandSmall_Remote_Mag",
"IEDUrbanBig_Remote_Mag",
"IEDUrbanSmall_Remote_Mag",
"SatchelCharge_Remote_Mag",
"SLAMDirectionalMine_Wire_Mag"
];

//////////////////////////
// Smokes ////////////////
//////////////////////////
_loot_smokes = [
"SmokeShell",
"SmokeShellBlue",
"SmokeShellGreen",
"SmokeShellOrange",
"SmokeShellPurple",
"SmokeShellRed",
"SmokeShellYellow",
"1Rnd_Smoke_Grenade_shell",
"1Rnd_SmokeBlue_Grenade_shell",
"1Rnd_SmokeGreen_Grenade_shell",
"1Rnd_SmokeOrange_Grenade_shell",
"1Rnd_SmokePurple_Grenade_shell",
"1Rnd_SmokeRed_Grenade_shell",
"1Rnd_SmokeYellow_Grenade_shell",
"3Rnd_Smoke_Grenade_shell",
"3Rnd_SmokeBlue_Grenade_shell",
"3Rnd_SmokeGreen_Grenade_shell",
"3Rnd_SmokeOrange_Grenade_shell",
"3Rnd_SmokePurple_Grenade_shell",
"3Rnd_SmokeRed_Grenade_shell",
"3Rnd_SmokeYellow_Grenade_shell"
];

//////////////////////////
// Flares ////////////////
//////////////////////////
_loot_flares = [
"Chemlight_blue",
"Chemlight_green",
"Chemlight_red",
"FlareGreen_F",
"FlareRed_F",
"FlareWhite_F",
"FlareYellow_F",
"UGL_FlareGreen_F",
"UGL_FlareRed_F",
"UGL_FlareWhite_F",
"UGL_FlareYellow_F",
"3Rnd_UGL_FlareGreen_F",
"3Rnd_UGL_FlareRed_F",
"3Rnd_UGL_FlareWhite_F",
"3Rnd_UGL_FlareYellow_F"
];

//////////////////////////
// Silencers /////////////
//////////////////////////
_loot_silencers = [
"muzzle_snds_H",
"muzzle_snds_M",
"muzzle_snds_L",
"muzzle_snds_B",
"muzzle_snds_H_MG",
"muzzle_snds_acp",
"muzzle_snds_93mmg",
"muzzle_snds_93mmg_tan",
"muzzle_snds_338_black",
"muzzle_snds_338_greenmuzzle_snds_338_sand",
"muzzle_snds_338_black",
"muzzle_snds_338_green",
"muzzle_snds_338_sand",
"muzzle_snds_93mmg",
"muzzle_snds_93mmg_tan",
"muzzle_snds_acp",
"muzzle_snds_H_SW"

];

//////////////////////////
// Optics //////////////// 
//////////////////////////
_loot_optics = [
"optic_NVS",
"optic_tws",
"optic_tws_mg",
"optic_SOS",
"optic_LRPS",
"optic_DMS",
"optic_Arco",
"optic_Hamr",
"optic_MRCO",
"optic_Holosight",
"optic_Holosight_smg",
"optic_Aco",
"optic_ACO_grn",
"optic_Aco_smg",
"optic_ACO_grn_smg",
"optic_Yorris",
"optic_MRD",
"optic_AMS",
"optic_AMS_khk",
"optic_AMS_snd",
"optic_KHS_blk",
"optic_KHS_hex",
"optic_KHS_old",
"optic_KHS_tan",
"optic_Nightstalker"
];

//////////////////////////
// Pointers ////////////// 
//////////////////////////
_loot_pointers = [
"acc_flashlight",
"acc_pointer_IR"
];

//////////////////////////
// Backpacks /////////////
//////////////////////////
_loot_backpacks = [
"B_AssaultPack_blk",
"B_AssaultPack_cbr",
"B_AssaultPack_dgtl",
"B_AssaultPack_khk",
"B_AssaultPack_mcamo",
"B_AssaultPack_rgr",
"B_AssaultPack_sgg",
"B_FieldPack_blk",
"B_FieldPack_cbr",
"B_FieldPack_ocamo",
"B_FieldPack_oucamo",
"B_TacticalPack_blk",
"B_TacticalPack_rgr",
"B_TacticalPack_ocamo",
"B_TacticalPack_mcamo",
"B_TacticalPack_oli",
"B_Kitbag_cbr",
"B_Kitbag_mcamo",
"B_Kitbag_sgg",
"B_Carryall_cbr",
"B_Carryall_khk",
"B_Carryall_mcamo",
"B_Carryall_ocamo",
"B_Carryall_oli",
"B_Carryall_oucamo",
"B_Bergen_blk",
"B_Bergen_mcamo",
"B_Bergen_rgr",
"B_Bergen_sgg",
"B_HuntingBackpack",
"B_OutdoorPack_blk",
"B_OutdoorPack_blu",
"B_OutdoorPack_tan"
];

//////////////////////////
// Bitpod ////////////////
//////////////////////////
_loot_bipods = [
"bipod_01_F_blk",
"bipod_01_F_mtp",
"bipod_01_F_snd",
"bipod_02_F_blk",
"bipod_02_F_hex",
"bipod_02_F_tan",
"bipod_03_F_blk",
"bipod_03_F_oli"
];

//////////////////////////
// UAVS //////////////////
//////////////////////////
_loot_uavs = [
"I_UavTerminal",
"I_UAV_01_backpack_F"
];

//////////////////////////
// Static MGs ////////////
//////////////////////////
_loot_static_mgs = [
"O_HMG_01_weapon_F",
"O_HMG_01_support_F"
];

//////////////////////////
//Vests///////////////////
//////////////////////////
_loot_vests = [
"V_Press_F",
"V_Rangemaster_belt",
"V_TacVest_blk",
"V_TacVest_blk_POLICE",
"V_TacVest_brn",
"V_TacVest_camo",
"V_TacVest_khk",
"V_TacVest_oli",
"V_TacVestCamo_khk",
"V_TacVestIR_blk",
"V_I_G_resistanceLeader_F"
];

//////////////////////////
// Chestrigs /////////////
//////////////////////////
_loot_chestrigs = [
"V_Chestrig_blk",
"V_Chestrig_khk",
"V_Chestrig_oli",
"V_Chestrig_rgr"
];

//////////////////////////
// Harnesses /////////////
//////////////////////////
_loot_harnesses = [
"V_HarnessO_brn",
"V_HarnessO_gry",
"V_HarnessOGL_brn",
"V_HarnessOGL_gry",
"V_HarnessOSpec_brn",
"V_HarnessOSpec_gry"
];

//////////////////////////
// Plate Carriers ////////
//////////////////////////
_loot_plate_carriers = [
"V_PlateCarrier1_blk",
"V_PlateCarrier1_rgr",
"V_PlateCarrier2_rgr",
"V_PlateCarrier3_rgr",
"V_PlateCarrierGL_blk",
"V_PlateCarrierGL_mtp",
"V_PlateCarrierGL_rgr",
"V_PlateCarrierH_CTRG",
"V_PlateCarrierIA1_dgtl",
"V_PlateCarrierIA2_dgtl",
"V_PlateCarrierIAGL_dgtl",
"V_PlateCarrierIAGL_oli",
"V_PlateCarrierL_CTRG",
"V_PlateCarrierSpec_blk",
"V_PlateCarrierSpec_mtp",
"V_PlateCarrierSpec_rgr"
];

//////////////////////////
// Head Gear /////////////
//////////////////////////
_loot_headgear = [	
// Bandannas
"H_Bandanna_camo",
"H_Bandanna_cbr",
"H_Bandanna_gry",
"H_Bandanna_khk",
"H_Bandanna_khk_hs",
"H_Bandanna_mcamo",
"H_Bandanna_sgg",
"H_Bandanna_surfer",

// Boonie Hats
"H_Booniehat_dgtl",
"H_Booniehat_dirty",
"H_Booniehat_grn",
"H_Booniehat_indp",
"H_Booniehat_khk",
"H_Booniehat_khk_hs",
"H_Booniehat_mcamo",
"H_Booniehat_tan",

// Hats
"H_Hat_blue",
"H_Hat_brown",
"H_Hat_camo",
"H_Hat_checker",
"H_Hat_grey",
"H_Hat_tan",
"H_StrawHat",
"H_StrawHat_dark",

// Berets
"H_Beret_02",
"H_Beret_blk",
"H_Beret_blk_POLICE",
"H_Beret_brn_SF",
"H_Beret_Colonel",
"H_Beret_grn",
"H_Beret_grn_SF",
"H_Beret_ocamo",
"H_Beret_red",

// Shemags
"H_Shemag_khk",
"H_Shemag_olive",
"H_Shemag_olive_hs",
"H_Shemag_tan",
"H_ShemagOpen_khk",
"H_ShemagOpen_tan",
"H_TurbanO_blk",

// Light Helmets
"H_HelmetB_light",
"H_HelmetB_light_black",
"H_HelmetB_light_desert",
"H_HelmetB_light_grass",
"H_HelmetB_light_sand",
"H_HelmetB_light_snakeskin",

// Helmets
"H_HelmetIA",
"H_HelmetIA_camo",
"H_HelmetIA_net",
"H_HelmetB",
"H_HelmetB_black",
"H_HelmetB_camo", // This one is awesome!
"H_HelmetB_desert",
"H_HelmetB_grass",
"H_HelmetB_paint",
"H_HelmetB_plain_blk",
"H_HelmetB_sand",
"H_HelmetB_snakeskin",

// Spec Ops Helmets
"H_HelmetSpecB",
"H_HelmetSpecB_blk",
"H_HelmetSpecB_paint1",
"H_HelmetSpecB_paint2",

// Super Helmets
"H_HelmetO_ocamo",
"H_HelmetO_oucamo",
"H_HelmetSpecO_blk",
"H_HelmetSpecO_ocamo",
"H_HelmetLeaderO_ocamo",
"H_HelmetLeaderO_oucamo"
];

//////////////////////////
// Navigation ////////////
//////////////////////////
_loot_navs = [
"ItemWatch",	
"ItemGPS",
"ItemMap",
"ItemCompass",
"ItemRadio",
"Binocular",
"Rangefinder",
"Laserdesignator",
"Laserdesignator_02",
"Laserdesignator_03",
"NVGoggles",
"NVGoggles_INDEP",
"NVGoggles_OPFOR"
];

//////////////////////////
// Rebreather ////////////
//////////////////////////
_loot_rebreathers = [
"V_RebreatherB",
"V_RebreatherIA",
"V_RebreatherIR"
];

//////////////////////////
// Pilot Stuff ////////////
//////////////////////////
_loot_pilot_stuff = [
"B_Parachute",
"H_CrewHelmetHeli_B",
"H_CrewHelmetHeli_I",
"H_CrewHelmetHeli_O",
"H_HelmetCrew_I",
"H_HelmetCrew_B",
"H_HelmetCrew_O",
"H_PilotHelmetHeli_B",
"H_PilotHelmetHeli_I",
"H_PilotHelmetHeli_O",
"U_B_HeliPilotCoveralls",
"U_B_PilotCoveralls",
"U_I_HeliPilotCoveralls",
"U_I_pilotCoveralls",
"U_O_PilotCoveralls",
"H_PilotHelmetFighter_B",
"H_PilotHelmetFighter_I",
"H_PilotHelmetFighter_O"
];

//////////////////////////
// Food //////////////////
//////////////////////////
_loot_food = [
"Exile_Item_Catfood",
"Exile_Item_PlasticBottleEmpty",
"Exile_Item_Surstromming",
"Exile_Item_BBQSandwich",
"Exile_Item_ChristmasTinner",
"Exile_Item_SausageGravy",
"Exile_Item_GloriousKnakworst",
"Exile_Item_CookingPot",
"Exile_Item_PlasticBottleFreshWater",
"Exile_Item_Beer",
"Exile_Item_Energydrink",
"Exile_Item_BBQSandwich_Cooked",
"Exile_Item_Surstromming_Cooked",
"Exile_Item_ChristmasTinner_Cooked",
"Exile_Item_GloriousKnakworst_Cooked",
"Exile_Item_SausageGravy_Cooked",
"Exile_Item_Catfood_Cooked"
];

//////////////////////////
// Misc //////////////////
//////////////////////////
_loot_Misc = [
"Exile_Item_JunkMetal",
"Exile_Item_LightBulb",
"Exile_Magazine_Battery",
"Exile_Item_MetalBoard",
"Exile_Item_DuctTape",
"Exile_Melee_Axe",
"Exile_Item_FuelCanisterEmpty",
"Exile_Item_FuelCanisterFull",
"Exile_Item_ExtensionCord",
"Exile_Item_JunkMetal",
"Exile_Item_Rope",
"Exile_Item_PortableGeneratorKit",
"Exile_Item_FloodLightKit",
"Exile_Item_CamoTentKit",
"Exile_Item_Matches",
"Exile_Item_TreasureMap",
"Exile_Item_InstaDoc"
];

//////////////////////////
// Construction //////////
//////////////////////////
_loot_build = [
"Exile_Item_WoodLog",
"Exile_Item_WoodPlank",
"Exile_Item_CampFireKit",
"Exile_Item_WoodDoorwayKit",
"Exile_Item_WoodFloorKit",
"Exile_Item_WoodFloorPortKit",
"Exile_Item_WoodGateKit",
"Exile_Item_WoodStairsKit",
"Exile_Item_WoodSupportKit",
"Exile_Item_WoodWallKit",
"Exile_Item_WoodWallHalfKit",
"Exile_Item_WoodWindowKit",
"Exile_Item_WorkBenchKit",
"Exile_Item_WoodDoorKit",
"Exile_Item_WoodFloorPortKit",
"Exile_Item_MetalPole",
"Exile_Item_StorageCrateKit"
];

//////////////////////////
// Define functions //////
//////////////////////////

// allows a visible cue to be spawned near the crate
_fn_smokeAtCrate = { // adapted from Ritchies heli crash addon
	private ["_pos","_smokeSource","_smokeTrail","_fire","_posFire","_smoke"];

	// Use the Land_Fire_burning item if you want a bright visual cue at night but be forewarned that the flames are blinding with NVG at close range
	// http://www.antihelios.de/EK/Arma/index.htm
	
	_wrecks = [
	"Land_Wreck_Car2_F",
	"Land_Wreck_Car3_F",
	"Land_Wreck_Car_F",
	"Land_Wreck_Offroad2_F",
	"Land_Wreck_Offroad_F",
	"Land_Tyres_F",
	"Land_Pallets_F",
	"Land_MetalBarrel_F"
	];
	
	_smokeSource = _wrecks call BIS_fnc_selectRandom;  //other choices might be "Land_CanisterPlastic_F",
"Land_MetalBarrel_F","Land_Pallets_F","Land_Tyres_F","Land_Wreck_Car2_F","Land_HumanSkeleton_F","Land_Wreck_Car2_F";

	_smokeTrail = "test_EmptyObjectForFireBig"; // "optiosn are "test_EmptyObjectForFireBig","test_EmptyObjectForSmoke"
	_pos = _this select 0;
	_posFire = [_pos, 5, 15, 10, 0, 20, 0] call BIS_fnc_findSafePos;  // find a safe spot near the location passed in the call
	_fire = createVehicle [_smokeSource, _posFire, [], 0, "can_collide"];
	_fire setVariable ["LAST_CHECK", (diag_tickTime + 14400)];
	_fire setPos _pos;
	_fire setDir floor(random(360));
	_smoke = createVehicle [_smokeTrail, _posFire, [], 0, "can_collide"];  // "test_EmptyObjectForSmoke" createVehicle _posFire;  
	_smoke setVariable ["LAST_CHECK", (diag_tickTime + 14400)];
	_smoke attachto [_fire, [0,0,-1]]; 
};
  
// fill the crate with something
_fn_spawnCrate = {

	private["_crate1","_lootType","_cratePos","_minDistfromCenter","_maxDistfromCenter","_clossestObj","_spawnOnWater","_spawnAtShore","_pos","_noItemTypes","_partToAdd"];
	
	_lootType = [_this, 1, 0] call BIS_fnc_param; // if a loot type is passed us this otherwise use a randomly selected loot type.
	_cratePos = _this select 0;	
	
	// Spawn an Empty a Crate
	_crate_1 = objNull;

	// find a safe location for the crate
	_minDistfromCenter = 0;  //should be 0 if you want specific crate positions
	_maxDistfromCenter = 0;		//should be 0 if you want specific crate positions
	_clossestObj = 0;			//should be 0 if you want specific crate positions
	_spawnOnWater = 0; // water mode 0: cannot be in water , 1: can either be in water or not , 2: must be in water
	_spawnAtShore = 0; // 0: does not have to be at a shore , 1: must be at a shore
	_pos = [_cratePos,_minDistfromCenter,_maxDistfromCenter,_clossestObj,_spawnOnWater,20,_spawnAtShore] call BIS_fnc_findSafePos; // find a random loc 

	// create a crate
	_crate_1 = createVehicle ["Land_CratesWooden_F", _pos, [], 0, "CAN_COLLIDE"];
	_crate_1 setPos _pos;
	_crate_1 setDir round(random(36));
	_crate_1 setVariable ["LAST_CHECK", (diag_tickTime + 14400)];  // prevent the crate from being cleaned up

	//Remove whatever the crate spawned with.
	clearWeaponCargoGlobal _crate_1;
	clearMagazineCargoGlobal _crate_1;
	clearBackpackCargoGlobal _crate_1;
	clearItemCargoGlobal _crate_1;	
/*
	Loot types:
	0 = randomly selected loadout from the list below
	1 = building materials, sledges, hatchets and chainsaws.
	2 = weapons, mines, NVG, range finder, radios
	3 = misc loot, other utility items.
	4 = weapons, vests, backpacks and headgear.
*/
	// a _lootType == 0 means randomly select a crate loadout so lets pick a random number
	if (_lootType == 0) then
	{
		_lootType = floor(random(4)) + 1;
		diag_log format["[random loot selects] _lootType = %1",_lootType];
	};
	
	//diag_log format["--->>> starting crate loader with loottype of %1",_lootType];
	
////////////////////////////////////////////////////////////////
///// 1 = building materials, hatchets. ////////////////////////
////////////////////////////////////////////////////////////////
	if (_lootType == 1) then
	{
		_noItemTypes = 10;
		for "_i" from 1 to _noItemTypes do
		{
			_items = round((_noItemTypes - _i)/2) + floor(random 20 + floor(_i/2));   //change the value '(random X....' to determine the number of items of this type to be in the crate
			_crate_1 addMagazineCargoGlobal [_loot_build call BIS_fnc_selectRandom, _items];
		};
		_crate_1 addWeaponCargoGlobal ["Exile_Melee_Axe",2];
	};
	
////////////////////////////////////////////////////////////////
///// 2 = weapons, mines, NVG, range finder, radios ////////////
////////////////////////////////////////////////////////////////
	if (_lootType == 2) then
		{
		
		_noRifles = 3;
		for "_i" from 1 to _noRifles do
		{
			//diag_log format[" ---- <<<< _loot_rifles is %1",_loot_rifles];
			_rifle = _loot_rifles call BIS_fnc_selectRandom;
			//diag_log format["--->>> parameter _rifle is %1",_rifle];
			_crate_1 addWeaponCargoGlobal [_rifle select 0, 1];
			_crate_1 addMagazineCargoGlobal [_rifle select 1, (6 + floor(random 3))];  //change the value '(X + floor( random....' to determine X number of items of this type to be in the crate
		};		
		
		_noPistols = 3;
		for "_i" from 1 to _noPistols do
		{
			_pistol = _loot_pistols call BIS_fnc_selectRandom;
			_crate_1 addWeaponCargoGlobal [_pistol select 0,1];
			_crate_1 addMagazineCargoGlobal [_pistol select 1, (3 + floor(random 3))];  //change the value '(X + floor( random....' to determine X number of items of this type to be in the crate
		};
				
		_noLMG = 3;
		for "_i" from 1 to _noLMG do
		{
			_LMG = _loot_LMGs call BIS_fnc_selectRandom;
			_crate_1 addWeaponCargoGlobal [_LMG select 0,1];
			_crate_1 addMagazineCargoGlobal [_LMG select 1, (1 + floor(random 3))];  //change the value '(X + floor( random....' to determine X number of items of this type to be in the crate
		};	

		_noSMG = 3;
		for "_i" from 1 to _noSMG do
		{
			_LMG = _loot_SMGs call BIS_fnc_selectRandom;
			_crate_1 addWeaponCargoGlobal [_SMG select 0,1];
			_crate_1 addMagazineCargoGlobal [_SMG select 1, (1 + floor(random 3))];  //change the value '(X + floor( random....' to determine X number of items of this type to be in the crate
		};			
		
		_noSniper = 2;
		for "_i" from 1 to _noSniper do
		{
			_sniper = _loot_snipers call BIS_fnc_selectRandom;
			_crate_1 addWeaponCargoGlobal [_sniper select 0,1];
			_crate_1 addMagazineCargoGlobal [_sniper select 1, (3 + floor(random 3))];  //change the value '(X + floor( random....' to determine X number of items of this type to be in the crate
		};
			
		_noSilencers = 2;
		for "_i" from 1 to _noSilencers do
		{
			_crate_1 addItemCargoGlobal [(_loot_silencers call BIS_fnc_selectRandom),(1 + floor(random 1))]; //change the value '(X + floor( random....' to determine X number of items of this type to be in the crate
		};
				
		_noOptics = 3;
		for "_i" from 1 to _noOptics do
		{
			_crate_1 additemCargoGlobal [(_loot_optics call BIS_fnc_selectRandom), (2 + floor(random 1))];  //change the value '(X + floor( random....' to determine X number of items of this type to be in the crate
		};
		
		_noNavs = 2;
		for "_i" from 1 to _noNavs do
		{
			_crate_1 addItemCargoGlobal [(_loot_navs call BIS_fnc_selectRandom),(1 + floor(random 1))]; //change the value '(X + floor( random....' to determine X number of items of this type to be in the crate
		};
			
		_noPointers = 2;
		for "_i" from 1 to _noPointers do
		{
			_crate_1 addItemCargoGlobal [(_loot_pointers call BIS_fnc_selectRandom),(1 + floor(random 1))]; //change the value '(X + floor( random....' to determine X number of items of this type to be in the crate
		};
					
		_noBipods = 2;
		for "_i" from 1 to _noBipods do
		{
			_crate_1 addItemCargoGlobal [(_loot_bipods  call BIS_fnc_selectRandom),(1 + floor(random 1))]; //change the value '(X + floor( random....' to determine X number of items of this type to be in the crate
		};
					
		_noExplosives = 2;
		for "_i" from 1 to _noExplosives do
		{
			_crate_1 addItemCargoGlobal [(_loot_explosives call BIS_fnc_selectRandom),(1 + floor(random 1))]; //change the value '(X + floor( random....' to determine X number of items of this type to be in the crate
		};
					
		_noSmokes = 2;
		for "_i" from 1 to _noSmokes do
		{
			_crate_1 addItemCargoGlobal [(_loot_smokes call BIS_fnc_selectRandom),(1 + floor(random 1))]; //change the value '(X + floor( random....' to determine X number of items of this type to be in the crate
		};
					
		_noFlares = 2;
		for "_i" from 1 to _noFlares do
		{
			_crate_1 addItemCargoGlobal [(_loot_flares call BIS_fnc_selectRandom),(1 + floor(random 1))]; //change the value '(X + floor( random....' to determine X number of items of this type to be in the crate
		};
					
		_noUAVs = 2;
		for "_i" from 1 to _noUAVs do
		{
			_crate_1 addItemCargoGlobal [(_loot_uavs call BIS_fnc_selectRandom),(1 + floor(random 1))]; //change the value '(X + floor( random....' to determine X number of items of this type to be in the crate
		};
							
		_noStatic_MGs = 2;
		for "_i" from 1 to _noStatic_MGs do
		{
			_crate_1 addItemCargoGlobal [(_loot_static_mgs call BIS_fnc_selectRandom),(1 + floor(random 1))]; //change the value '(X + floor( random....' to determine X number of items of this type to be in the crate
		};
		
		_crate_1 addItemCargoGlobal ["ItemRadio",2];
		_crate_1 additemCargoGlobal ["NVGoggles",2];
		_crate_1 additemCargoGlobal ["ItemGPS",2];
		_crate_1 addWeaponCargoGlobal ["Rangefinder",2];
		_crate_1 addMagazineCargoGlobal ["SatchelCharge_Remote_Mag",2];
		_crate_1 addMagazineCargoGlobal ["DemoCharge_Remote_Mag",1];
		_crate_1 addMagazineCargoGlobal ["ClaymoreDirectionalMine_Remote_Mag",2];
	};

////////////////////////////////////////////////////////////////
///// 3 = misc loot, other utility items. //////////////////////
////////////////////////////////////////////////////////////////
	if (_lootType == 3) then
	{
		_noMisc = 10;
		for "_i" from 1 to _noMisc do
		{
			_items = (_noMisc - floor(i/2)) + floor(random _i);
			_partToAdd = _loot_misc call BIS_fnc_selectRandom;
			diag_log format["<<<<--- for loot type 3 number of parts is %1 and part is %2",_items,_partToAdd];
			_crate_1 addMagazineCargoGlobal [_partToAdd,_items];
		};
		
		_noFood = 10;
		for "_i" from 1 to _noMisc do
		{
			_items = (_noMisc - floor(i/2)) + floor(random _i);
			_partToAdd = _loot_food call BIS_fnc_selectRandom;
			diag_log format["<<<<--- for loot type 3 number of parts is %1 and part is %2",_items,_partToAdd];
			_crate_1 addMagazineCargoGlobal [_partToAdd,_items];
		};
		
		
		_crate_1 addMagazineCargoGlobal ["EnergyPack",2];
		_crate_1 addMagazineCargoGlobal ["EnergyPackLg",1];
		_crate_1 addMagazineCargoGlobal ["Exile_Item_StorageCrateKit",2];
		_crate_1 addMagazineCargoGlobal ["ItemGoldBar10oz",2];
		_crate_1 addMagazineCargoGlobal ["ItemSilverBar",4];
 
	};
	
////////////////////////////////////////////////////////////////
///// 4 = weapons, vests, backpacks and headgear. //////////////
////////////////////////////////////////////////////////////////
	if (_lootType == 4) then
	{
		_noUniforms = 3;
		for "_i" from 1 to _noUniforms do
		{
			_crate_1 addItemCargoGlobal [(_loot_uniforms call BIS_fnc_selectRandom),1];
		};
		_noVests = 2;
		for "_i" from 1 to _noVests do
		{
			_crate_1 addItemCargoGlobal [(_loot_vests call BIS_fnc_selectRandom),(1 + floor(random 1))];
		};
		_noHeadgear = 4;
		for "_i" from 1 to _noHeadgear do
		{
			_crate_1 addItemCargoGlobal [(_loot_headgear call BIS_fnc_selectRandom),1];
		};
		_noChestRigs = 3;
		for "_i" from 1 to _noChestRigs do
		{
			_crate_1 addBackpackCargoGlobal [(_loot_chestrigs call BIS_fnc_selectRandom),(1 + floor(random 1))];
		};
		_noHarnesses = 3;
		for "_i" from 1 to _noHarnesses do
		{
			_crate_1 addBackpackCargoGlobal [(_loot_harnesses call BIS_fnc_selectRandom),(1 + floor(random 1))];
		};
		_noPlateCarriers = 3;
		for "_i" from 1 to _noPlateCarriers do
		{
			_crate_1 addBackpackCargoGlobal [(_loot_plate_carriers call BIS_fnc_selectRandom),(1 + floor(random 1))];
		};
		_noPilotStuff = 3;
		for "_i" from 1 to _noPilotStuff do
		{
			_crate_1 addBackpackCargoGlobal [(_loot_pilot_stuff call BIS_fnc_selectRandom),(1 + floor(random 1))];
		};
		_noRebreathers = 3;
		for "_i" from 1 to _noRebreathers do
		{
			_crate_1 addBackpackCargoGlobal [(_loot_rebreathers call BIS_fnc_selectRandom),(1 + floor(random 1))];
		};
		
};
// run the above scripts
_fn_Run = {
	
	private ["_cratePos","_lootType","_counter"];
	_counter = 1;
// spawn and load a crate for each location in _lootBoxes
	{
		
		_cratePos = _x select 0;  // get crate position
		_lootType= _x select 1;
		[_cratePos, _lootType] call _fn_spawnCrate;
		if (_smokeNearCrate) then
		{
			[_cratePos] call _fn_smokeAtCrate;
		};
		diag_log format["crateLoot spawning crate %1",_counter];
		_counter = _counter + 1;
	} forEach _lootBoxes;
};
// Start everything up.
[] call _fn_Run;

diag_log "Static crates loaded successfully!";
