tagtable = {"ECHO", "MACE", "RANGER", "FIST", "SWEEPER", "NOMAD", "PAYBACK"}

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
			question = "Translate the following radio transmission: “ST-2 going sharp on contaminant jackpot. Prepping extractors”",
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
			question = "Translate the following radio transmission: “ST-1 is at code: ice at SJ-1. Report all radials free.”",
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
			model = "models/DG_models/DG_combinepack/DG_grunt/combine_grunt.mdl",
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
			model = "models/DG_models/DG_combinepack/DG_grunt/combine_grunt.mdl",
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
			model = "models/DG_models/DG_combinepack/DG_soldier/dg_combine_soldier.mdl",
			skin = 2,
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
			model = "models/DG_models/DG_combinepack/DG_elite/dg_elite_soldier.mdl",
			skin = 0,
			itemsAdd = {
				{class = "wep_ar2e", amount = 1},
				--{class = "wep_ar2orb", amount = 1},
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
			model = "models/DG_models/DG_combinepack/DG_APF/dg_combine_suppresor.mdl",
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
			model = "models/DG_models/DG_combinepack/DG_soldier/dg_combine_soldier.mdl",
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
			model = "models/DG_models/DG_combinepack/DG_charger/dg_combine_charger.mdl",
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
				ply:SetModel("models/DG_models/DG_combinepack/DG_grunt/combine_grunt.mdl")
				ply:SetRPName("CTA:CGR." .. tagtable[ply:GetTeamClass()] .. "-" ..math.random(10, 999))
				if ply:GetTeamClass() == CLASS_ECHO then
					ply:SetSkin(1)
					ply:SetArmor(80)
					ply:SetMaxArmor(80)
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_MACE then
					ply:SetSkin(1)
					ply:SetArmor(95)
					ply:SetMaxArmor(95)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetRunSpeed(impulse.Config.JogSpeed* 1.05)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,0)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				end
			end
		},
		{
			name = "CSO",
			description = "ows",
			xp = 0,
			whitelistLevel = 1,
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_ECHO then
					ply:SetModel("models/DG_models/DG_combinepack/DG_soldier/dg_combine_soldier.mdl")
					ply:SetSkin(0)
					ply:SetArmor(100)
					ply:SetMaxArmor(100)
					ply:SetRunSpeed(impulse.Config.JogSpeed)
					ply:SetModelScale(1)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_MACE then
					ply:SetModel("models/DG_models/DG_combinepack/DG_soldier/dg_combine_soldier.mdl")
					ply:SetSkin(1)
					ply:SetArmor(110)
					ply:SetMaxArmor(110)
					ply:SetRunSpeed(impulse.Config.JogSpeed * 0.95)
					ply:SetModelScale(1)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,0)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_APF then
					ply:SetModel("models/DG_models/DG_combinepack/DG_APF/dg_combine_suppresor.mdl")
					ply:SetSkin(1)
					ply:AddEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetArmor(150)
					ply:SetMaxArmor(150)
					ply:SetRunSpeed(170)
					ply:SetModelScale(1)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_RANGER then
					ply:SetModel("models/DG_models/DG_combinepack/DG_soldier/dg_combine_soldier.mdl")
					ply:SetArmor(90)
					ply:SetMaxArmor(90)
					ply:SetRunSpeed(impulse.Config.JogSpeed * 0.95)
					ply:SetModelScale(1)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,0)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_FIST then
					ply:SetModel("models/DG_models/DG_combinepack/DG_elite/dg_elite_soldier.mdl")
					ply:SetArmor(140)
					ply:SetMaxArmor(140)
					ply:SetRunSpeed(impulse.Config.JogSpeed)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetModelScale(1)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,0)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_NOMAD then
					ply:SetModel("models/DG_models/DG_combinepack/DG_soldier/dg_combine_soldier.mdl")
					ply:SetSkin(6)
					ply:SetArmor(100)
					ply:SetMaxArmor(100)
					ply:SetRunSpeed(impulse.Config.JogSpeed)
					ply:SetModelScale(1)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
					ply:Give("weapon_lvsrepair")
				elseif ply:GetTeamClass() == CLASS_PAYBACK then
					ply:SetModel("models/DG_models/DG_combinepack/DG_charger/dg_combine_charger.mdl")
					ply:SetHealth(150)
					ply:SetMaxHealth(150)
					ply:SetModelScale(1.1)
					ply:SetArmor(250)
					ply:SetMaxArmor(250)
					ply:AddEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetRunSpeed(160)
					ply:SetWalkSpeed(80)
				end
				ply:SetRPName("CTA:CSO." .. tagtable[ply:GetTeamClass()] .. "-" .. math.random(10, 999))
			end
		},
		{
			name = "ECS",
			description = "eow",
			xp = 0,
			whitelistLevel = 2,
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_ECHO then
					ply:SetModel("models/DG_models/DG_combinepack/DG_soldier/dg_combine_soldier.mdl")
					ply:SetSkin(0)
					ply:SetArmor(120)
					ply:SetRunSpeed(impulse.Config.JogSpeed)
					ply:SetMaxArmor(120)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetModelScale(1)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_MACE then
					ply:SetModel("models/DG_models/DG_combinepack/DG_soldier/dg_combine_soldier.mdl")
					ply:SetSkin(1)
					ply:SetArmor(135)
					ply:SetRunSpeed(impulse.Config.JogSpeed * 0.95)
					ply:SetMaxArmor(135)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetModelScale(1)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_RANGER then
					ply:SetModel("models/DG_models/DG_combinepack/DG_soldier/dg_combine_soldier.mdl")
					ply:SetArmor(105)
					ply:SetMaxArmor(105)
					ply:SetRunSpeed(impulse.Config.JogSpeed * 0.95)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetModelScale(1)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_APF then
					ply:SetModel("models/DG_models/DG_combinepack/DG_APF/dg_combine_suppresor.mdl")
					ply:SetSkin(1)
					ply:SetArmor(175)
					ply:SetMaxArmor(175)
					ply:SetRunSpeed(170)
					ply:AddEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetModelScale(1)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_FIST then
					ply:SetModel("models/DG_models/DG_combinepack/DG_elite/dg_elite_soldier.mdl")
					ply:SetArmor(160)
					ply:SetMaxArmor(160)
					ply:SetRunSpeed(impulse.Config.JogSpeed)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetModelScale(1)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,0)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_NOMAD then
					ply:SetModel("models/DG_models/DG_combinepack/DG_soldier/dg_combine_soldier.mdl")
					ply:SetSkin(6)
					ply:SetArmor(120)
					ply:SetMaxArmor(120)
					ply:SetRunSpeed(impulse.Config.JogSpeed)
					ply:SetModelScale(1)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:Give("weapon_lvsrepair")
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_PAYBACK then
					ply:SetModel("models/DG_models/DG_combinepack/DG_charger/dg_combine_charger.mdl")
					ply:SetHealth(150)
					ply:SetMaxHealth(150)
					ply:SetModelScale(1.1)
					ply:SetArmor(250)
					ply:SetMaxArmor(250)
					ply:SetRunSpeed(160)
					ply:AddEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetWalkSpeed(80)
				end
				ply:SetRPName("CTA:ECS." .. tagtable[ply:GetTeamClass()] .. "-" .. math.random(10, 999))
			end
		},
		{
			name = "CCP",
			description = "captain",
			xp = 0,
			--[[canPromote = {
				[RANK_OWG] = true
			},]]
			whitelistLevel = 3,
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_ECHO then
					ply:SetModel("models/DG_models/DG_combinepack/DG_soldier/dg_combine_soldier.mdl")
					ply:SetSkin(0)
					ply:SetArmor(140)
					ply:SetMaxArmor(140)
					ply:SetRunSpeed(impulse.Config.JogSpeed)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetModelScale(1)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,0)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_MACE then
					ply:SetModel("models/DG_models/DG_combinepack/DG_soldier/dg_combine_soldier.mdl")
					ply:SetSkin(1)
					ply:SetArmor(150)
					ply:SetMaxArmor(150)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetRunSpeed(impulse.Config.JogSpeed * 0.95)
					ply:SetModelScale(1)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,0)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_APF then
					ply:SetModel("models/DG_models/DG_combinepack/DG_APF/dg_combine_suppresor.mdl")
					ply:SetSkin(1)
					ply:SetArmor(225)
					ply:SetMaxArmor(225)
					ply:AddEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetRunSpeed(170)
					ply:SetModelScale(1)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,0)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_RANGER then
					ply:SetModel("models/DG_models/DG_combinepack/DG_soldier/dg_combine_soldier.mdl")
					ply:SetSkin(0)
					ply:SetArmor(130)
					ply:SetMaxArmor(130)
					ply:SetRunSpeed(impulse.Config.JogSpeed * 0.95)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetModelScale(1)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,0)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_FIST then
					ply:SetModel("models/DG_models/DG_combinepack/DG_elite/dg_elite_soldier.mdl")
					ply:SetArmor(180)
					ply:SetMaxArmor(180)
					ply:SetRunSpeed(impulse.Config.JogSpeed)
					ply:SetModelScale(1)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,0)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_NOMAD then
					ply:SetModel("models/DG_models/DG_combinepack/DG_soldier/dg_combine_soldier.mdl")
					ply:SetSkin(6)
					ply:SetArmor(140)
					ply:SetMaxArmor(140)
					ply:SetRunSpeed(impulse.Config.JogSpeed)
					ply:SetModelScale(1)
					ply:SetBodygroup(0,0)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,0)
					ply:Give("weapon_lvsrepair")
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_PAYBACK then
					ply:SetModel("models/DG_models/DG_combinepack/DG_charger/dg_combine_charger.mdl")
					ply:SetHealth(150)
					ply:SetMaxHealth(150)
					ply:SetModelScale(1.1)
					ply:SetArmor(300)
					ply:AddEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetMaxArmor(300)
					ply:SetRunSpeed(160)
					ply:SetWalkSpeed(80)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,0)
				end
				ply:SetRPName("CTA:CCP." .. tagtable[ply:GetTeamClass()] .. "-" .. math.random(10, 999))
			end
		},
		{
			name = "CTL",
			description = "ldr",
			xp = 0,
			doorGroup = {1, 2, 3, 4, 6, 7},
			--[[canPromote = {
				[RANK_OWG] = true,
				[RANK_OWS] = true,
			},]]
			whitelistLevel = 4,
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_ECHO then
					ply:SetModel("models/DG_models/DG_combinepack/DG_soldier/dg_combine_soldier.mdl")
					ply:SetSkin(0)
					ply:SetArmor(160)
					ply:SetMaxArmor(160)
					ply:SetRunSpeed(impulse.Config.JogSpeed)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetModelScale(1)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,0)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_MACE then
					ply:SetModel("models/DG_models/DG_combinepack/DG_soldier/dg_combine_soldier.mdl")
					ply:SetSkin(1)
					ply:SetArmor(170)
					ply:SetMaxArmor(170)
					ply:SetRunSpeed(impulse.Config.JogSpeed * 0.95)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetModelScale(1)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,0)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_RANGER then
					ply:SetModel("models/DG_models/DG_combinepack/DG_soldier/dg_combine_soldier.mdl")
					ply:SetSkin(0)
					ply:SetArmor(150)
					ply:SetMaxArmor(150)
					ply:SetRunSpeed(impulse.Config.JogSpeed * 0.95)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,0)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_APF then
					ply:SetModel("models/DG_models/DG_combinepack/DG_APF/dg_combine_suppresor.mdl")
					ply:SetSkin(1)
					ply:SetArmor(225)
					ply:SetMaxArmor(225)
					ply:SetRunSpeed(170)
					ply:AddEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetModelScale(1)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,0)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_FIST then
					ply:SetModel("models/DG_models/DG_combinepack/DG_elite/dg_elite_soldier.mdl")
					ply:SetArmor(200)
					ply:SetMaxArmor(200)
					ply:SetRunSpeed(impulse.Config.JogSpeed)
					ply:SetModelScale(1)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,0)
				elseif ply:GetTeamClass() == CLASS_NOMAD then
					ply:SetModel("models/DG_models/DG_combinepack/DG_soldier/dg_combine_soldier.mdl")
					ply:SetSkin(6)
					ply:SetArmor(160)
					ply:SetMaxArmor(160)
					ply:SetRunSpeed(impulse.Config.JogSpeed)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetModelScale(1)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,0)
					ply:Give("weapon_lvsrepair")
				elseif ply:GetTeamClass() == CLASS_PAYBACK then
					ply:SetModel("models/DG_models/DG_combinepack/DG_charger/dg_combine_charger.mdl")
					ply:SetHealth(150)
					ply:SetMaxHealth(150)
					ply:SetModelScale(1.1)
					ply:SetArmor(300)
					ply:SetMaxArmor(300)
					ply:AddEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetRunSpeed(160)
					ply:SetWalkSpeed(80)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,0)
				end
				ply:SetRPName("CTA:CTL." .. tagtable[ply:GetTeamClass()] .. "-" .. math.random(10, 999))
			end
		},
		{
			name = "ORD",
			description = "ord",
			xp = 0,
			doorGroup = {1, 2, 3, 4, 5, 6, 7},
			whitelistLevel = 5,
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_ECHO then
					ply:SetModel("models/DG_models/DG_combinepack/DG_ordinal/dg_combine_ordinal.mdl")
					ply:SetSkin(0)
					ply:SetArmor(200)
					ply:SetMaxArmor(200)
					ply:SetRunSpeed(impulse.Config.JogSpeed)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetModelScale(1)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,1)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_MACE then
					ply:SetModel("models/DG_models/DG_combinepack/DG_ordinal/dg_combine_ordinal.mdl")
					ply:SetSkin(0)
					ply:SetArmor(200)
					ply:SetMaxArmor(200)
					ply:SetRunSpeed(impulse.Config.JogSpeed * 0.95)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetModelScale(1)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,1)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_RANGER then
					ply:SetModel("models/DG_models/DG_combinepack/DG_ordinal/dg_combine_ordinal.mdl")
					ply:SetSkin(0)
					ply:SetArmor(170)
					ply:SetMaxArmor(170)
					ply:SetRunSpeed(impulse.Config.JogSpeed * 0.95)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetModelScale(1)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,1)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_APF then
					ply:SetModel("models/DG_models/DG_combinepack/DG_APF/dg_combine_suppresor.mdl")
					ply:SetSkin(1)
					ply:SetArmor(250)
					ply:SetMaxArmor(250)
					ply:AddEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetRunSpeed(170)
					ply:SetModelScale(1)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,0)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_FIST then
					ply:SetModel("models/DG_models/DG_combinepack/DG_etl/dg_etl.mdl")
					ply:SetArmor(220)
					ply:SetMaxArmor(220)
					ply:SetRunSpeed(impulse.Config.JogSpeed)
					ply:SetModelScale(1)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,1)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_NOMAD then
					ply:SetModel("models/DG_models/DG_combinepack/DG_soldier/dg_combine_soldier.mdl")
					ply:SetSkin(6)
					ply:SetArmor(180)
					ply:SetMaxArmor(180)
					ply:SetRunSpeed(impulse.Config.JogSpeed)
					ply:SetModelScale(1)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:Give("weapon_lvsrepair")
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_PAYBACK then
					ply:SetModel("models/DG_models/DG_combinepack/DG_charger/dg_combine_charger.mdl")
					ply:SetHealth(200)
					ply:SetMaxHealth(200)
					ply:SetModelScale(1.1)
					ply:SetArmor(350)
					ply:SetMaxArmor(350)
					ply:AddEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetRunSpeed(160)
					ply:SetWalkSpeed(80)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,0)
				end
				ply:SetRPName("CTA:ORD." .. tagtable[ply:GetTeamClass()] .. "-" .. math.random(10, 999))
			end
		},
		{
			name = "CSC",
			description = "csc",
			xp = 0,
			doorGroup = {1, 2, 3, 4, 5, 6, 7},
			whitelistLevel = 6,
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_ECHO then
					ply:SetModel("models/DG_models/DG_combinepack/DG_ordinal/dg_combine_ordinal.mdl")
					ply:SetSkin(3)
					ply:SetArmor(220)
					ply:SetMaxArmor(220)
					ply:SetRunSpeed(impulse.Config.JogSpeed)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetModelScale(1)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,1)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_MACE then
					ply:SetModel("models/DG_models/DG_combinepack/DG_ordinal/dg_combine_ordinal.mdl")
					ply:SetSkin(3)
					ply:SetArmor(220)
					ply:SetMaxArmor(220)
					ply:SetRunSpeed(impulse.Config.JogSpeed * 0.95)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetModelScale(1)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,1)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_RANGER then
					ply:SetModel("models/DG_models/DG_combinepack/DG_ordinal/dg_combine_ordinal.mdl")
					ply:SetSkin(3)
					ply:SetArmor(190)
					ply:SetMaxArmor(190)
					ply:SetRunSpeed(impulse.Config.JogSpeed * 0.95)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetModelScale(1)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,1)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_APF then
					ply:SetModel("models/DG_models/DG_combinepack/DG_APF/dg_combine_suppresor.mdl")
					ply:SetSkin(1)
					ply:SetArmor(270)
					ply:SetMaxArmor(270)
					ply:AddEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetRunSpeed(170)
					ply:SetModelScale(1)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,0)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_FIST then
					ply:SetModel("models/DG_models/DG_combinepack/DG_etl/dg_etl.mdl")
					ply:SetArmor(220)
					ply:SetMaxArmor(240)
					ply:SetRunSpeed(impulse.Config.JogSpeed)
					ply:SetModelScale(1)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,1)
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_NOMAD then
					ply:SetModel("models/DG_models/DG_combinepack/DG_soldier/dg_combine_soldier.mdl")
					ply:SetSkin(6)
					ply:SetArmor(200)
					ply:SetMaxArmor(200)
					ply:SetRunSpeed(impulse.Config.JogSpeed)
					ply:SetModelScale(1)
					ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
					ply:Give("weapon_lvsrepair")
					ply:SetWalkSpeed(impulse.Config.WalkSpeed)
				elseif ply:GetTeamClass() == CLASS_PAYBACK then
					ply:SetModel("models/DG_models/DG_combinepack/DG_charger/dg_combine_charger.mdl")
					ply:SetHealth(200)
					ply:SetMaxHealth(200)
					ply:SetModelScale(1.1)
					ply:SetArmor(400)
					ply:SetMaxArmor(400)
					ply:AddEFlags(EFL_NO_DAMAGE_FORCES)
					ply:SetRunSpeed(160)
					ply:SetWalkSpeed(80)
					ply:SetBodygroup(0,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(2,0)
				end
				ply:SetRPName("CTA:CSC." .. tagtable[ply:GetTeamClass()] .. "-" .. math.random(10, 999))
			end
		}
	}
})

CLASS_ECHO = 1
CLASS_MACE = 2
CLASS_RANGER = 3
CLASS_FIST = 4
CLASS_APF = 5
CLASS_NOMAD = 6
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
    if ply:Team() == TEAM_OTA && ply:GetTeamClass() == CLASS_PAYBACK then
        ply:EmitSound("wallhammer/steps/step_layer_clink_0" .. math.random(1,5) .. ".wav")
        return true
    end
end)
