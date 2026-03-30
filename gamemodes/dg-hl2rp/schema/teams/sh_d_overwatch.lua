tagtable = {"ECHO", "MACE", "RANGER", "FIST", "SWEEPER", "NOMAD", "PAYBACK"}

local MDL_GRUNT   = "models/DG_models/DG_combinepack/DG_grunt/combine_grunt.mdl"
local MDL_SOLDIER = "models/DG_models/DG_combinepack/DG_soldier/dg_combine_soldier.mdl"
local MDL_ORDINAL = "models/DG_models/DG_combinepack/DG_ordinal/dg_combine_ordinal.mdl"
local MDL_ELITE   = "models/DG_models/DG_combinepack/DG_elite/dg_elite_soldier.mdl"
local MDL_APF     = "models/DG_models/DG_combinepack/DG_APF/dg_combine_suppresor.mdl"
local MDL_ETL     = "models/DG_models/DG_combinepack/DG_etl/dg_etl.mdl"
local MDL_CHARGER = "models/dg_models/dg_combinepack/dg_charger/syn_combine_heavy.mdl"

local BG_RESET_3 = {{0,0},{1,0},{2,0}}
local BG_CTL = {
    {0,0},{1,1},{2,0},{3,1},{4,1},{5,1},
    {6,1},{7,1},{8,1},{9,1},{10,1},{11,1}
}

-- Fields:
--   model (string)
--   skin (int) default 0
--   armor (int)
--   maxArmor (int) defaults to armor
--   health (int) only set if specified
--   speedMult (float) multiplier of impulse.Config.JogSpeed
--   runSpeed (int) absolute run speed (overrides speedMult)
--   walkSpeed (int) absolute walk speed, defaults to config
--   forceFlags (bool) true means immune to knockback, false means you get knockback
--   bodygroups  (table)   {{id, val}, ...}
--   give (string) gives an item, usually a weapon

local OTA_STATS = {

    -- ECHO
    [1] = { ranks = {
        CGR = { model=MDL_GRUNT,   skin=1, armor=80,  speedMult=1.05, forceFlags=false },
        CSO = { model=MDL_SOLDIER, skin=0, armor=100, speedMult=1.0,  forceFlags=false },
        ECS = { model=MDL_SOLDIER, skin=0, armor=120, speedMult=1.0,  forceFlags=false },
        CCP = { model=MDL_SOLDIER, skin=0, armor=140, speedMult=1.0,  forceFlags=false, bodygroups=BG_RESET_3 },
        CTL = { model=MDL_ORDINAL, skin=0, armor=160, speedMult=1.0,  forceFlags=false, bodygroups=BG_CTL },
        ORD = { model=MDL_ORDINAL, skin=0, armor=200, speedMult=1.0,  forceFlags=false, bodygroups=BG_RESET_3 },
        CSC = { model=MDL_ORDINAL, skin=3, armor=220, speedMult=1.0,  forceFlags=false, bodygroups=BG_RESET_3 },
    }},

    -- MACE
    [2] = { ranks = {
        CGR = { model=MDL_GRUNT,   skin=1, armor=95,  speedMult=1.05, forceFlags=false, bodygroups=BG_RESET_3 },
        CSO = { model=MDL_SOLDIER, skin=1, armor=110, speedMult=1.03, forceFlags=false },
        ECS = { model=MDL_SOLDIER, skin=1, armor=135, speedMult=1.03, forceFlags=false },
        CCP = { model=MDL_SOLDIER, skin=1, armor=150, speedMult=1.06, forceFlags=false },
        CTL = { model=MDL_ORDINAL, skin=1, armor=170, speedMult=1.06, forceFlags=false, bodygroups=BG_CTL },
        ORD = { model=MDL_ORDINAL, skin=1, armor=200, speedMult=1.06, forceFlags=false, bodygroups=BG_RESET_3 },
        CSC = { model=MDL_ORDINAL, skin=3, armor=220, speedMult=1.06, forceFlags=false, bodygroups=BG_RESET_3 },
    }},

    -- RANGER
    [3] = { ranks = {
        CSO = { model=MDL_SOLDIER, skin=4, armor=90,  speedMult=0.95, forceFlags=false },
        ECS = { model=MDL_SOLDIER, skin=4, armor=105, speedMult=0.95, forceFlags=false },
        CCP = { model=MDL_SOLDIER, skin=4, armor=130, speedMult=0.95, forceFlags=false },
        CTL = { model=MDL_ORDINAL, skin=0, armor=150, speedMult=0.95, forceFlags=false, bodygroups=BG_CTL },
        ORD = { model=MDL_ORDINAL, skin=0, armor=170, speedMult=0.95, forceFlags=false, bodygroups=BG_RESET_3 },
        CSC = { model=MDL_ORDINAL, skin=3, armor=190, speedMult=0.95, forceFlags=false, bodygroups=BG_RESET_3 },
    }},

    -- FIST
    [4] = { ranks = {
        CSO = { model=MDL_ELITE, armor=140, speedMult=1, forceFlags=false },
        ECS = { model=MDL_ELITE, armor=160, speedMult=1, forceFlags=false },
        CCP = { model=MDL_ELITE, armor=180, speedMult=1, forceFlags=false },
        CTL = { model=MDL_ELITE, armor=200, speedMult=1.05, forceFlags=false },
        ORD = { model=MDL_ETL,   armor=220, speedMult=1.05, forceFlags=false, bodygroups=BG_RESET_3 },
        CSC = { model=MDL_ETL,   armor=240, speedMult=1.05, forceFlags=false, bodygroups={{1,1},{3,1}} },
    }},

    -- APF (SWEEPER)
    [5] = { ranks = {
        CSO = { model=MDL_APF, skin=1, armor=150, runSpeed=170, forceFlags=true },
        ECS = { model=MDL_APF, skin=1, armor=175, runSpeed=170, forceFlags=true },
        CCP = { model=MDL_APF, skin=1, armor=225, runSpeed=170, forceFlags=true },
        CTL = { model=MDL_APF, skin=2, armor=225, runSpeed=170, forceFlags=true },
        ORD = { model=MDL_APF, skin=2, armor=250, runSpeed=170, forceFlags=true, bodygroups=BG_RESET_3 },
        CSC = { model=MDL_APF, skin=2, armor=270, runSpeed=170, forceFlags=true, bodygroups=BG_RESET_3 },
    }},

    -- NOMAD
    [6] = { ranks = {
        CSO = { model=MDL_SOLDIER, skin=6, armor=100, speedMult=1.0, forceFlags=false, give="weapon_lvsrepair" },
        ECS = { model=MDL_SOLDIER, skin=6, armor=120, speedMult=1.0, forceFlags=false, give="weapon_lvsrepair" },
        CCP = { model=MDL_SOLDIER, skin=6, armor=140, speedMult=1.0, forceFlags=false, give="weapon_lvsrepair", bodygroups={{0,0}} },
        CTL = { model=MDL_SOLDIER, skin=6, armor=160, speedMult=1.0, forceFlags=false, give="weapon_lvsrepair" },
        ORD = { model=MDL_SOLDIER, skin=6, armor=180, speedMult=1.0, forceFlags=false, give="weapon_lvsrepair" },
        CSC = { model=MDL_SOLDIER, skin=6, armor=200, speedMult=1.0, forceFlags=false, give="weapon_lvsrepair" },
    }},


    -- WALLHAMMER (PAYBACK)
    [7] = { ranks = {
        CSO = { model=MDL_CHARGER, skin=0, armor=250, health=150, runSpeed=160, walkSpeed=80, forceFlags=true, give="weapon_wallhammershield" },
        ECS = { model=MDL_CHARGER, skin=0, armor=275, health=160, runSpeed=160, walkSpeed=80, forceFlags=true, give="weapon_wallhammershield" },
        CCP = { model=MDL_CHARGER, skin=0, armor=300, health=170, runSpeed=160, walkSpeed=80, forceFlags=true, give="weapon_wallhammershield" },
        CTL = { model=MDL_CHARGER, skin=1, armor=325, health=175, runSpeed=160, walkSpeed=80, forceFlags=true, give="weapon_wallhammershield" },
        ORD = { model=MDL_CHARGER, skin=1, armor=350, health=200, runSpeed=160, walkSpeed=80, forceFlags=true, bodygroups=BG_RESET_3, give="weapon_wallhammershield" },
        CSC = { model=MDL_CHARGER, skin=1, armor=400, health=210, runSpeed=160, walkSpeed=80, forceFlags=true, bodygroups=BG_RESET_3, give="weapon_wallhammershield" },
    }},
}


local function ApplyOTARank(ply, rankName)
    local classStats = OTA_STATS[ply:GetTeamClass()]
    if not classStats then return end
    local s = classStats.ranks[rankName]
    if not s then return end

    ply:SetModel(s.model)
    ply:SetSkin(s.skin or 0)
    ply:SetModelScale(1)

    local armor    = s.armor or 0
    local maxArmor = s.maxArmor or armor
    ply:SetArmor(armor)
    ply:SetMaxArmor(maxArmor)

    if s.health then
        ply:SetHealth(s.health)
        ply:SetMaxHealth(s.health)
    end

    if s.runSpeed then
        ply:SetRunSpeed(s.runSpeed)
    elseif s.speedMult then
        ply:SetRunSpeed(impulse.Config.JogSpeed * s.speedMult)
    end

    ply:SetWalkSpeed(s.walkSpeed or impulse.Config.WalkSpeed)

    if s.forceFlags then
        ply:AddEFlags(EFL_NO_DAMAGE_FORCES)
    else
        ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
    end

    if s.bodygroups then
        for _, bg in ipairs(s.bodygroups) do
            ply:SetBodygroup(bg[1], bg[2])
        end
    end

    if s.give then
        ply:Give(s.give)
    end

    ply:SetRPName("CTA:" .. rankName .. "." .. tagtable[ply:GetTeamClass()] .. "-" .. math.random(10, 999))
end

TEAM_OTA = impulse.Teams.Define({
	name = "Combine Transhuman Arm",
	color = Color(60, 60, 60, 255),
	description = [[The CTA are the military arm of the Combine forces. They are highly trained and extensively modified super soldiers, far stronger than any normal human. They are entirely without fear or emotion of any kind, called on to the streets only when circumstances are at their most dire. Otherwise, they remain in the Nexus or guarding hardpoints around the city. They are completely obedient to their commander, following orders without regard to their own safety. Operating in small squads, the CTA are a force to be reckoned with, and haunt the dreams of any citizen with common sense.]],
	loadout = {"impulse_hands"},
	spawnLoc = true,
	salary = 50,
	model = "models/player/soldier_stripped.mdl",
	handModel = "models/weapons/c_arms_combine.mdl",
	percentLimit = true,
	limit = 0.125,
	xp = 750,
	cp = true,
	doorGroup = {1, 2, 3, 6, 7},
	blockNameChange = true,

	quiz = {
		enabled = true,
		handbook = "https://docs.google.com/document/d/105Im8kXD8LXiLTFQSFtqMjtR1vSXWIOB_5PEf5ULO0E/edit?tab=t.0",
		{
			id = 1,
			question = "Scenario: Your stabilization team is tasked to perform an outlands sector sweep. You spot an unarmed scavenger looting that is unaware of your presence. How do you proceed?",
			answers = {
				{"Shoot them immediately; confiscate all contraband.", true},
				{"Attempt to detain the individual to escort them back for processing.", false},
				{"Tell them to leave the area, and if they fail to comply shoot them.", false},
				{"Contain them in an area and call in a protection unit to arrest them.", false}
			}
		},
		{
			id = 2,
			question = "As a Grunt, what are the extents of your cognitive faculties?",
			answers = {
				{"Grunts retain partial memories of their past lives and have part of their personality intact. Thus they can express themselves in a multitude of ways.", true},
				{"Being the least augmented transhuman asset, Grunts are effectively the same as a normal human and can express emotions such as empathy.", false},
				{"Since they are of a prior augmentation phase, Grunts are essentially the same as metrocops in terms of emotions.", false},
				{"Grunts are heavily restricted on their faculties and must remain stoic at all times. They are unable to show emotions outside of a select few such as frustration.", true}
			}
		},
		{
			id = 3,
			question = "Define the term: Sundown.",
			answers = {
				{"Called prior to code de-escalation where all units must recall and form divisional lines at the vector.", false},
				{"You are almost done sweeping an area.", false},
				{"The area is clear of all contaminants.", true},
				{"Your team is overrun and needs backup.", false},
			}
		},
		{
			id = 4,
			question = "Scenario: The current city code is MARGINAL, your stabilization team is assigned to ice above the plaza area. In an apartment nearby, protection units begin taking losses due to an anti-civil jackpot. What is your course of action?",
			answers = {
				{"Move in with your team and sterilize the block of all hostiles.", false},
				{"Attach yourself to a PT and move in alongside MPF to clear the building.", false},
				{"Await code escalation, shadow raid, or lockdown activation before intervening.", true},
				{"Ask MPF if they need help before moving in to assist.", false}
			}
		},
		{
			id = 5,
			question = " What other names does the Transhuman Arm go by?",
			answers = {
				{"Overwatch Transhuman Arm, Stabilization Arm", false},
				{"Combine Overwatch, Infestation Response Team", false},
				{"Transhuman Forces, Stabilization Forces", true}
			}
		},
		{
			id = 6,
			question = "What classes are vocoders mandatory for?",
			answers = {
				{"All transhuman assets.", true},
				{"All Half Life: 2 soldiers; Half Life: Alyx units are exempt from the requirement.", false},
				{"All units ranked CSO+.", false}
			}
		},
		{
			id = 7,
			question = "What is the primary purpose of the SWEEPER (APF) division?",
			answers = {
				{"To lay down suppressive fire on opponents.", true},
				{"To provide ammunition for fellow assets with their ammo crate.", false},
				{"To act as close quarters combat specialists.", false},
				{"To push into holdouts and tank damage for their teammates.", false}
			}
		},
		{
			id = 8,
			question = "Scenario: The current city code is AUTONOMOUS JUDGMENT. Your stabilization team has been assigned to containment procedures. What will your team do?",
			answers = {
				{"Deploy to the outlands sector and contain all xenian spores.", false},
				{"Deploy to the city sector and sweep all apartment blocks. After the apartment blocks are swept, ripcord for condition alpha.", false},
				{"Sterilize any active anti-civil incursions within high-priority regions or the city. Then deploy throughout the entire sector and sweep for any hostiles.", true}
			}
		},
		{
			id = 9,
			question = "Which emotion is strictly forbidden from being exhibited on the Transhuman Arm regardless of what class you are playing on?",
			answers = {
				{"Fear", false},
				{"Empathy", true},
				{"Disgust", false}
			}
		},
		{
			id = 10,
			question = "What is the first rank of the command units?",
			answers = {
				{"Enhanced Soldier (ECS)", false},
				{"Team Leader (CTL)", false},
				{"Captain (CCP)", true}
			}
		},
		{
			id = 11,
			question =[[Translate the following radio transmission: "ST-2 going sharp on contaminant jackpot. Prepping extractors"]],
			answers = {
				{"Team is ready to contain the xen infestation. Preparing grenades.", false},
				{"Team is attacking a rebel holdout. Preparing grenades.", true},
				{"Team is extracting high-value contraband from rebels. Ready weapons.", false}
			}
		},
		{
			id = 12,
			question = "Which TAC is CTA radio on?",
			answers = {
				{"TAC-1.", false},
				{"TAC-2.", false},
				{"TAC-3.", true},
				{"TAC-4.", false}
			}
		},
		{
			id = 13,
			question = "Which of the following is NOT a duty of stabilization teams during city code STABLE?",
			answers = {
				{"Conducting sweeps of the outlands sector, amputating any hostiles found.", false},
				{"Performing a strike on an anti-citizen base that intel has been gathered on.", false},
				{"Ensuring the security of the contraband caches.", false},
				{"Deploying to the city and assisting MPF in containing any incursions.", true}
			}
		},
		{
			id = 14,
			question = [[Translate the following radio transmission: "ST-1 is at code: ice at SJ-1. Report all radials free."]],
			answers = {
				{"Team is holding at the Nexus. Nothing to report.", false},
				{"Team is holding at the Outlands Hardpoint. All sightlines are clear.", true},
				{"Team is building fortifications at the Plaza Catwalks. All sightlines are clear.", false},
				{"Team is finding cover at Outlands Hardpoint. Requesting backup!", false}
			}
		},
		{
			id = 15,
			question = "What is the main purpose of the Transhuman Arm?",
			answers = {
				{"To secure and guard the prison area.", false},
				{"To assist MPF in patrolling and securing the city.", false},
				{"To maintain security of high-priority regions and contain high level anti-civil incursions.", true}
			}
		},
		{
			id = 998,
			question = "Do you understand that breaking character on CTA will result in severe punishment?",
			answers = {
				{"Yes.", true},
				{"No.", false}
			}
		},
		{
			id = 999,
			question = " Do you agree to respect and adhere to CTA guidelines while playing the faction?",
			answers = {
				{"Yes.", true},
				{"No", false}
			}
		},
	},

	classes = {
		{
			name = "ECHO",
			description = "ECHO units are highly trained medium-range combat units. ECHO units are a jack of all trades, master of none. They have access to a mix of close and medium range weaponry.",
			model = MDL_GRUNT,
			skin = 1,
			itemsAdd = {
				{class = "wep_osips", amount = 1},
				{class = "item_vocoder", amount = 1}
			},
			xp = 0,
			noMenu = true
		},
		{
			name = "MACE",
			description = "MACE units are close-quaters engagement specialists. They are ineffective at medium and long ranges however they excel at close-quaters due to their SPAS-12 shotgun and heavy armour. MACE units are excellent at performing raids and bruteforcing into enemy strongholds.",
			model = MDL_GRUNT,
			skin = 1,
			itemsAdd = {
				{class = "wep_osisg", amount = 1},
				{class = "item_vocoder", amount = 1}
			},
			xp = 2000,
			noMenu = true
		},
		{
			name = "RANGER",
			description = "RANGER units have a diversified arsenal and the primary skillset in long range engagements. Utilizing your O.M.R. or O.S.R. you can effectively dispatch hostiles at ranges of up to 500 meters.",
			model = MDL_SOLDIER,
			skin = 4,
			itemsAdd = {
				{class = "wep_omr", amount = 1},
				{class = "att_optic", amount = 1},
				{class = "item_vocoder", amount = 1}
			},
			limit = 3,
			xp = 5,
			noMenu = true
		},
		{
			name = "FIST",
			description = "FIST units, also known as Combine Elites, are deployed to high risk situations.",
			model = MDL_ELITE,
			skin = 0,
			itemsAdd = {
				{class = "wep_ar2e", amount = 1},
				{class = "item_vocoder", amount = 1}
			},
			xp = 5,
			percentLimit = false,
			whitelistUID = "CTA_FIST",
			whitelistLevel = 1,
			whitelistFailMessage = "You must be specially whitelisted for the FIST division.",
			limit = 3,
			noMenu = true
		},
		{
			name = "SWEEPER",
			description = "SWEEPER units, also known as APF, specialize in engagements that require significant concentrated fire to lock down an enemy position.",
			model = MDL_APF,
			skin = 1,
			itemsAdd = {
				{class = "wep_apf", amount = 1},
				{class = "item_vocoder", amount = 1}
			},
			xp = 0,
			percentLimit = false,
			limit = 2,
			whitelistUID = "CTA_SLASH",
			whitelistLevel = 1,
			whitelistFailMessage = "You must be specially whitelisted for the SWEEPER division.",
			noMenu = true
		},
		{
			name = "NOMAD",
			description = "NOMAD units serve as vehicle operators of the Combine Transhuman Arm, they utilize Hunters and APCs for their duties.",
			model = MDL_SOLDIER,
			skin = 6,
			itemsAdd = {
				{class = "wep_osips", amount = 1},
				{class = "item_vocoder", amount = 1}
			},
			xp = 0,
			percentLimit = false,
			limit = 3,
			whitelistUID = "CTA_NOMAD",
			whitelistLevel = 1,
			whitelistFailMessage = "You must be specially whitelisted for the NOMAD division.",
			noMenu = true
		},
		{
			name = "PAYBACK",
			description = "PAYBACK units, also known as Wallhammer, they have extremely powerful armor and a close range shotgun.",
			model = MDL_CHARGER,
			skin = 0,
			itemsAdd = {
				{class = "wep_osihs", amount = 1},
				{class = "wep_w_stunstick", amount = 1},
				{class = "item_vocoder", amount = 1}
			},
			xp = 0,
			percentLimit = false,
			limit = 2,
			whitelistUID = "CTA_PAYBACK",
			whitelistLevel = 1,
			whitelistFailMessage = "You must be specially whitelisted for the PAYBACK division.",
			noMenu = true
		},
	},

	ranks = {
		{
			name = "CGR",
			description = "owg",
			xp = 0,
			onBecome = function(ply, rank)
				ApplyOTARank(ply, "CGR")
			end
		},
		{
			name = "CSO",
			description = "ows",
			xp = 0,
			whitelistLevel = 1,
			onBecome = function(ply, rank)
				ApplyOTARank(ply, "CSO")
			end
		},
		{
			name = "ECS",
			description = "eow",
			xp = 0,
			whitelistLevel = 2,
			onBecome = function(ply, rank)
				ApplyOTARank(ply, "ECS")
			end
		},
		{
			name = "CCP",
			description = "captain",
			xp = 0,
			whitelistLevel = 3,
			onBecome = function(ply, rank)
				ApplyOTARank(ply, "CCP")
			end
		},
		{
			name = "CTL",
			description = "ldr",
			xp = 0,
			doorGroup = {1, 2, 3, 4, 6, 7},
			whitelistLevel = 4,
			onBecome = function(ply, rank)
				ApplyOTARank(ply, "CTL")
			end
		},
		{
			name = "ORD",
			description = "ord",
			xp = 0,
			doorGroup = {1, 2, 3, 4, 5, 6, 7},
			whitelistLevel = 5,
			onBecome = function(ply, rank)
				ApplyOTARank(ply, "ORD")
			end
		},
		{
			name = "CSC",
			description = "csc",
			xp = 0,
			doorGroup = {1, 2, 3, 4, 5, 6, 7},
			whitelistLevel = 6,
			onBecome = function(ply, rank)
				ApplyOTARank(ply, "CSC")
			end
		}
	}
})

CLASS_ECHO    = 1
CLASS_MACE    = 2
CLASS_RANGER  = 3
CLASS_FIST    = 4
CLASS_APF     = 5
CLASS_NOMAD   = 6
CLASS_PAYBACK = 7

RANK_OWG = 1
RANK_OWS = 2
RANK_EOS = 3
RANK_OCP = 4
RANK_OSL = 5
RANK_ORD = 6
RANK_OSC = 7

RANK_CGR = RANK_OWG
RANK_CSO = RANK_OWS
RANK_ECS = RANK_EOS
RANK_CCP = RANK_OCP
RANK_CTL = RANK_OSL
RANK_CSC = RANK_OSC

hook.Add("PlayerFootstep", "wallhammerfoot", function(ply, pos, foot, sound)
	if ply:Team() == TEAM_OTA and ply:GetTeamClass() == CLASS_PAYBACK then
		ply:EmitSound("wallhammer/steps/step_layer_clink_0" .. math.random(1, 5) .. ".wav")
		return true
	end
end)