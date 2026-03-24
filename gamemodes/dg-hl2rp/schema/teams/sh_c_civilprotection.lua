cptagtable = {"UNION", "HELIX", "GRID", "SWORD", "GHOST", "ERROR"}

TEAM_CP = impulse.Teams.Define({
	name = "Metro Police Force",
	color = Color(65, 105, 200, 255),
	-- Description should be on one single line or the formatting will die
	description = [[The M.P.F. are the Combine's human police force. They are responsible for the enforcement of the Combine’s laws, and controlling the population. The M.P.F. consists of multiple divisions, each with a specific role. Many join the M.P.F. in hopes of getting better rations, or simply for the power it brings over their fellow citizens.]],
	loadout = {"impulse_hands", "weapon_physgun", "gmod_tool"},
	salary = 250,
	model = "models/wn7new/metropolice/male_0" .. math.random(1,6) .. ".mdl",
	handModel = "models/weapons/c_metrocop_hands.mdl",
	spawnLoc = true,
	percentLimit = true,
	limit = 0.45,
	xp = 150,
	cp = true,
	doorGroup = {1, 2, 6, 7},
	blockNameChange = true,
	runSpeed = 225,
	
	quiz = {
		enabled = true,
		handbook = "https://docs.google.com/document/d/16Ep9L7tQCPm81AAO41TcxHLy4md96m0GgPlGsFhCoCo/edit?tab=t.0",
		{
			id = 1,
			question = "Which radio code indicates that a friendly is down and you're under fire?",
			answers = {
				{"10-99", true},
				{"11-99", false},
				{"10-108", false}
			}
		},
		{
			id = 2,
			question = "You notice a citizen continuously verbally harassing a particular loyalist. What type of violation is it and how do you proceed?",
			answers = {
				{"415, Arrest", true},
				{"10-103m, Re-Education", false},
				{"10-103m, Arrest", false},
				{"51b & 99, Arrest", true},
				{"None of the above", false},
			}
		},
		{
			id = 3,
			question = "Are the Metropolice Force mandated to use a Voice Changer?",
			answers = {
				{"Yes.", true},
				{"No.", false},
				{"Recommended", false}
			}
		},
		{
			id = 4,
			question = "Rebels have manifested the city in Marginal, CTL issues you a direct order to push and contain but an RL ordered you to regroup with other MPF at a location, which do you obey?",
			answers = {
				{"Listen to the CTL and proceed with his orders.", false},
				{"Listen to the RL and regroup.", true},
				{"Stay in the Nexus until the conflict is resolved.", false}
			}
		},
		{
			id = 5,
			question = "Decode this message : PT-1 UTL 505 Suspect, BOL for the NC, 10-51 10-19.",
			answers = {
				{"Patrol Taskforce 1 Unable to Locate resisting suspect, broadcast on local for the suspect. Need transport to Nexus.", false},
				{"Patrol Team 1 Unable to localize resistance member, brief observation list for the suspect, Patrolling for suspect after resupplying.", false},
				{"Protection Team 1 Unable To Locate Evading Arrest Suspect, Be on lookout for the noncitizen, concluding patrol returning to nexus. ", true}
			}
		},
		{
			id = 6,
			question = "From which rank would a person be considered 'Senior Enlisted'",
			answers = {
				{"Rank Leader.", false},
				{"Intention 3.", false},
				{"Intention 2.", true}
			}
		},
		{
			id = 7,
			question = "After going on-duty and gearing up, what is the first thing you should do?",
			answers = {
				{"Radio in 10-8 and interlock into a PT. ", true},
				{"Ask MPF to report in city status before exiting to patrol.", false},
				{"Move to Plaza and report in what you see until you find a group to fall in", false}
			}
		},
		{
			id = 8,
			question = "A Civic Member of the Popualce is acting very suspicious in a gathering, how do you react?",
			answers = {
				{"Radio in to keep close watch on him.", false},
				{"Beat up and detain the civic.", false},
				{"Search the civic and question him.", true},
				{"None of the above.", false}
			}
		},
		{
			id = 9,
			question = "Should you leave the nexus without your mask and vocoder?",
			answers = {
				{"No", true},
				{"You can take it off if there is a small amont of citizens", false},
				{"Yes", false},
				{"None of the above.", false}
			}
		},
		{
			id = 10,
			question = "There is BOL on a citizen while also an incursion happening what do you prioritize?",
			answers = {
				{"BOL if there close", false},
				{"Incursion ", true},
				{"Do both if you have time", false},
				{"None of the above", false}
			}
		},
		{
			id = 11,
			question = "What rank should you prioritize orders from?",
			answers = {
				{"Rank Leader", false},
				{"Squad Leader", true},
				{"i1.", false},
				{"Acting Rank Leader", false}
			}
		},
		{
			id = 12,
			question = "What is the policy for citizens committing level 1 crimes on city code stable?",
			answers = {
				{"Re-Education -> Arrest", false},
				{"Warning -> Arrest", false},
				{"Warning -> Re-Education -> Arrest", true},
				{"Arrest", false}
			}
		},
		{
			id = 13,
			question = "Do OCA have any authority over MPF personnel?",
			answers = {
				{"Yes", false},
				{"No", false},
				{"OCA Sv's only.", false},
				{"OCA Sv's only in the absence of any equal or higher rank MPF SVs.", true}
			}
		},
		{
			id = 14,
			question = "Do CTA have any authority over MPF personnel?",
			answers = {
				{"Yes", true},
				{"No", false},
				{"CTA Supervisors only", false},
				{"CTA Supervisors only in the absence of any equal or higher rank MPF Supervisors", true}
			}
		},
		{
			id = 15,
			question = "A citizen is calling you names such as idiot after you have arrested them what do you do?",
			answers = {
				{"Ask a supervisor to increase their sentence", true},
				{"Do nothing", false},
				{"Ask CTA to increase their sentence", false},
				{"Go to nexus and kill them", false}
			}
		},
		{
			id = 16,
			question = "What do you do if there is no PT to interlock into?",
			answers = {
				{"Wait for a PT team to become available", false},
				{"Go patrol with someone and make a makeshift PT.", true},
				{"Patrol by yourself", false},
				{"None of the above", false}
			}
		},
		{
			id = 17,
			question = "There is an i5 in nexus who is untrained what do you do?",
			answers = {
				{"Train them yourself.", false},
				{"Fine the appropriate rank to train them i1+", true},
				{"Do nothing", false}
			}
		},
		{
			id = 18,
			question = "What is the primary purpose of the MPF?",
			answers = {
				{"Policing the civic populous.", true},
				{"Enforcing the rules of the server", false},
				{"Patrolling the Outlands", false},
				{"Selling permits for building construction and weapons.", false}
			}
		},
		{
			id = 19,
			question = "What is the MPF's primary area of responsibility?",
			answers = {
				{"Nexus", false},
				{"The City", true},
				{"The Sewers", false},
				{"The Outlands", false}
			}
		},
		{
			id = 998,
			question = "Do you understand that breaking character on MPF will result in punishment?",
			answers = {
				{"Yes.", true},
				{"No", false}
			}
		},
		{
			id = 999,
			question = "Do you agree to respect and adhere to MPF guidelines while playing the faction?",
			answers = {
				{"Yes.", true},
				{"No", false}
			}
		}
	},

	classes = {
		{ -- 1
			name = "UNION",
			description = "UNION is the main patrol force of the Civil Protection. UNION is often tasked with block searches, patrolling and general policing. In the event of civil unrest they can act as riot control units. For this reason UNION units are provided the most powerful weaponry out of all divisions.",
			model = "models/wn7new/metropolice/male_04.mdl",
			xp = 0,
			noMenu = true
		},
		{ -- 2
			name = "HELIX",
			description = "HELIX is a specialist medical division. It's members are fully trained officers, however they have received additional medical training. HELIX is often tasked with acting as a supporting officer in a patrol or providing medical assistance to injured officers. Due to these requirements HELIX units carry specialist medical equipment.",
			model = "models/wn7new/metropolice/male_04.mdl",
			xp = 0,
			percentLimit = true,
			limit = 0.2,
			noMenu = true
		},
		{ -- 3
			name = "GRID",
			description = "GRID units serve as the engineering arm of the Metro Police Force. They focus on establishment of hardpoints, repairing of cameras, and maintaining of checkpoints.",
			model = "models/wn7new/metropolice/male_04.mdl",
			xp = 0,
			percentLimit = true,
			noMenu = true
		},
		{ -- 4
			name = "SWORD",
			description = "SWORD is a powerful force of elite Metro Police officers tasked with the containment of significant in city threats. Second only to the transhuman forces, they operate as the final threshold between combatants and Autonomous Judgement.",
			model = "models/wn7new/metropolice/male_04.mdl",
			xp = 0,
			limit = 4,
			noMenu = true,
			noSubMats = true,
			whitelistUID = "CP_SpecOps",
			whitelistLevel = 1,
            whitelistFailMessage = "You must be specially whitelisted for the SWORD division."
		},
		{ -- 5
			name = "GHOST",
			description = "GHOST is a group of Metro Police Force officers that are significantly talented in investigations, interrogations, etc. They are filled with some of the finest minds of the branch.",
			model = "models/wn7new/metropolice/male_04.mdl",
			xp = 0,
			limit = 6,
			noMenu = true,
			noSubMats = true,
			whitelistUID = "CP_Investigator",
			whitelistLevel = 1,
            whitelistFailMessage = "You must be specially whitelisted for the SWORD division."
		},
		{ -- 7
			name = "DISPATCH",
			description = "DISPATCH units are responsible for coordinating and managing field operations.",
			model = "models/wn7new/metropolice/male_0" .. math.random(1,9) .. ".mdl",
			xp = 0,
			limit = 5,
			noMenu = true,
			noSubMats = true,
			whitelistLevel = 1,
			whitelistUID = "MPF_Dispatch",
            whitelistFailMessage = "You must be specially whitelisted for the DISPATCH division."
		}
	},

	ranks = {
		{
			name = "i4",
			description = "i4",
			xp = 0,
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_UNION then
					ply:SetModel("models/player/bunny/imperial_shock/shock_trooper.mdl")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.1)
					ply:Give("rw_sw_stun_e11")
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
				elseif ply:GetTeamClass() == CLASS_GRID then
					ply:SetModel("models/player/bunny/imperial_shock/shock_trooper.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:Give("weapon_lvsrepair")
				elseif ply:GetTeamClass() == CLASS_HELIX then
					ply:SetModel("models/player/bunny/imperial_shock/shock_trooper.mdl")
					ply:SetMaxArmor(0)
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 1)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
				elseif ply:GetTeamClass() == CLASS_SWORD then
					ply:SetModel("models/player/bunny/imperial_shock/shock_lieutenant.mdl")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.1)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(2, 16)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 1)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
				elseif ply:GetTeamClass() == CLASS_GHOST then
					ply:SetModel("models/player/bunny/imperial_shock/shock_lieutenant.mdl")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 1)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 1)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
				elseif ply:GetTeamClass() == CLASS_DISPATCH then
					--ply:SetModel("models/dpfilms/metropolice/playermodels/pm_phoenix_police.mdl")
					ply:SetModel("models/player/bunny/imperial_shock/shock_lieutenant.mdl")
					ply:SetMaxArmor(0)
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 1)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:SetBodygroup(ply:FindBodygroupByName("beard"), ply.impulseData.beard or 0)
    				ply:SetBodygroup(ply:FindBodygroupByName("hair"), ply.impulseData.hair or 0)
					ply:SetRPName("Operator "..ply:GetSavedRPName())
					return
				end
				if ply:GetTeamClass() ~= CLASS_DISPATCH then
					ply:SetRPName("Security Cadet "..ply:GetSavedRPName())
				end
			end
		},
		{
			name = "i3",
			description = "i3",
			xp = 0,
			whitelistLevel = 1,
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_UNION then
					ply:SetModel("models/player/bunny/imperial_shock/shock_trooper.mdl")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.1)
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 1)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
				elseif ply:GetTeamClass() == CLASS_GRID then
					ply:SetModel("models/player/bunny/imperial_shock/shock_trooper.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:Give("weapon_lvsrepair")
				elseif ply:GetTeamClass() == CLASS_HELIX then
					ply:SetModel("models/player/bunny/imperial_shock/shock_trooper.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
				elseif ply:GetTeamClass() == CLASS_SWORD then
					ply:SetModel("models/player/bunny/imperial_shock/shock_lieutenant.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.1)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(2, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 1)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
				elseif ply:GetTeamClass() == CLASS_GHOST then
					ply:SetModel("models/player/bunny/imperial_shock/shock_lieutenant.mdl")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
				elseif ply:GetTeamClass() == CLASS_DISPATCH then
					--ply:SetModel("models/dpfilms/metropolice/playermodels/pm_phoenix_police.mdl")
					ply:SetModel("models/player/bunny/imperial_shock/shock_lieutenant.mdl")
					ply:SetMaxArmor(0)
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:SetBodygroup(ply:FindBodygroupByName("beard"), ply.impulseData.beard or 0)
    				ply:SetBodygroup(ply:FindBodygroupByName("hair"), ply.impulseData.hair or 0)
					ply:SetRPName("Operator "..ply:GetSavedRPName())
				end
				if ply:GetTeamClass() ~= CLASS_DISPATCH then
					ply:SetRPName("Security Officer "..ply:GetSavedRPName())
				end
			end
		},
		{
			name = "i2",
			description = "i2",
			doorGroup = {1, 2, 3, 6, 7},
			xp = 0,
			whitelistLevel = 2,
			whitelistFailMessage = "You must be promoted to use this rank.",
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_UNION then
					ply:SetModel("models/player/bunny/imperial_shock/shock_sergeant.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.1)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 1)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
				elseif ply:GetTeamClass() == CLASS_GRID then
					ply:SetModel("models/player/bunny/imperial_shock/shock_sergeant.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
				elseif ply:GetTeamClass() == CLASS_HELIX then
					ply:SetModel("models/player/bunny/imperial_shock/shock_sergeant.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 1)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
				elseif ply:GetTeamClass() == CLASS_GRID then
					ply:SetModel("models/player/bunny/imperial_shock/shock_sergeant.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:Give("weapon_lvsrepair")
				elseif ply:GetTeamClass() == CLASS_SWORD then
					ply:SetModel("models/player/bunny/imperial_shock/shock_sergeant.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.1)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(2, 16)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 1)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
				elseif ply:GetTeamClass() == CLASS_GHOST then
					ply:SetModel("models/player/bunny/imperial_shock/shock_sergeant.mdl")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetBodygroup(1, 1)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 1)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
				elseif ply:GetTeamClass() == CLASS_DISPATCH then
					--ply:SetModel("models/dpfilms/metropolice/playermodels/pm_phoenix_police.mdl")
					ply:SetModel("models/player/bunny/imperial_shock/shock_lieutenant.mdl")
					ply:SetMaxArmor(0)
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 1)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:SetBodygroup(ply:FindBodygroupByName("beard"), ply.impulseData.beard or 0)
    				ply:SetBodygroup(ply:FindBodygroupByName("hair"), ply.impulseData.hair or 0)
					ply:SetRPName("Operator "..ply:GetSavedRPName())
				end
				if ply:GetTeamClass() ~= CLASS_DISPATCH then
					ply:SetRPName("Security Sergeant "..ply:GetSavedRPName())
				end
			end
		},
		{
			name = "i1",
			description = "i1",
			doorGroup = {1, 2, 3, 6, 7},
			xp = 0,
			whitelistLevel = 3,
			whitelistFailMessage = "You must be promoted to use this rank.",
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_UNION then
					ply:SetModel("models/player/bunny/imperial_shock/shock_sergeant.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.1)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 1)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
				elseif ply:GetTeamClass() == CLASS_GRID then
					ply:SetModel("models/player/bunny/imperial_shock/shock_sergeant.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:Give("weapon_lvsrepair")
				elseif ply:GetTeamClass() == CLASS_HELIX then
					ply:SetModel("models/player/bunny/imperial_shock/shock_sergeant.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 1)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
				elseif ply:GetTeamClass() == CLASS_SWORD then
					ply:SetModel("models/player/bunny/imperial_shock/shock_sergeant.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.1)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(2, 16)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 1)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
				elseif ply:GetTeamClass() == CLASS_GHOST then
					ply:SetModel("models/player/bunny/imperial_shock/shock_sergeant.mdl")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetBodygroup(1, 1)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 1)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
				elseif ply:GetTeamClass() == CLASS_DISPATCH then
					--ply:SetModel("models/dpfilms/metropolice/playermodels/pm_phoenix_police.mdl")
					ply:SetModel("models/player/bunny/imperial_shock/shock_officer.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 1)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:SetBodygroup(ply:FindBodygroupByName("beard"), ply.impulseData.beard or 0)
    				ply:SetBodygroup(ply:FindBodygroupByName("hair"), ply.impulseData.hair or 0)
					ply:SetRPName("Operator "..ply:GetSavedRPName())
				end
				if ply:GetTeamClass() ~= CLASS_DISPATCH then
					ply:SetRPName("Security Staff Sergeant "..ply:GetSavedRPName())
				end
			end
		},
		{
			name = "OfC",
			description = "OfC",
			doorGroup = {1, 2, 3, 6, 7},
			xp = 0,
			whitelistLevel = 4,
			whitelistFailMessage = "You must be promoted to use this rank.",
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_UNION then
					ply:SetModel("models/player/bunny/imperial_shock/shock_officer.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.1)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 1)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:SetRPName("Security CO  "..ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_GRID then
					ply:SetModel("models/player/bunny/imperial_shock/shock_officer.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:SetRPName("Security CO  "..ply:GetSavedRPName())
					ply:Give("weapon_lvsrepair")
				elseif ply:GetTeamClass() == CLASS_HELIX then
					ply:SetModel("models/player/bunny/imperial_shock/shock_officer.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 1)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:SetRPName("Security CO  "..ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_SWORD then
					ply:SetModel("models/player/bunny/imperial_shock/shock_officer.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.1)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(2, 16)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 1)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:SetRPName("Security CO  "..ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_GHOST then
					ply:SetModel("models/player/bunny/imperial_shock/shock_officer.mdl")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetBodygroup(1, 1)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 1)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:SetRPName("Security CO  "..ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_DISPATCH then
					--ply:SetModel("models/dpfilms/metropolice/playermodels/pm_phoenix_police.mdl")
					ply:SetModel("models/player/bunny/imperial_shock/shock_officer.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 1)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:SetBodygroup(ply:FindBodygroupByName("beard"), ply.impulseData.beard or 0)
    				ply:SetBodygroup(ply:FindBodygroupByName("hair"), ply.impulseData.hair or 0)
					ply:SetRPName("Security CO "..ply:GetSavedRPName())
				end
			end
		},
		{
			name = "SqL",
			description = "SqL",
			doorGroup = {1, 2, 3, 4, 6, 7},
			xp = 0,
			whitelistLevel = 5,
			whitelistFailMessage = "You must be promoted to use this rank.",
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_UNION then
					ply:SetModel("models/player/bunny/imperial_shock/shock_officer.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.1)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 1)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:SetRPName("Security 2nd LT  "..ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_GRID then
					ply:SetModel("models/player/bunny/imperial_shock/shock_officer.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:SetRPName("Security 2nd LT  "..ply:GetSavedRPName())
					ply:Give("weapon_lvsrepair")
				elseif ply:GetTeamClass() == CLASS_HELIX then
					ply:SetModel("models/player/bunny/imperial_shock/shock_officer.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 1)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:SetRPName("Security 2nd LT  "..ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_SWORD then
					ply:SetModel("models/player/bunny/imperial_shock/shock_officer.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.1)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(2, 16)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 1)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:SetRPName("Security 2nd LT  "..ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_GHOST then
					ply:SetModel("models/player/bunny/imperial_shock/shock_officer.mdl")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetBodygroup(1, 1)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 1)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:SetRPName("Security 2nd LT  "..ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_DISPATCH then
					--ply:SetModel("models/dpfilms/metropolice/playermodels/pm_phoenix_police.mdl")
					ply:SetModel("models/player/bunny/imperial_shock/shock_officer.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 1)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:SetBodygroup(ply:FindBodygroupByName("beard"), ply.impulseData.beard or 0)
    				ply:SetBodygroup(ply:FindBodygroupByName("hair"), ply.impulseData.hair or 0)
					ply:SetRPName("Security 2nd LT  "..ply:GetSavedRPName())
				end
			end
		},
		{
			name = "DvL",
			description = "DvL",
			doorGroup = {1, 2, 3, 4, 6, 7},
			xp = 0,
			whitelistLevel = 6,
			whitelistFailMessage = "You must be promoted to use this rank.",
			limit = 5,
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_UNION then
					ply:SetModel("models/player/bunny/imperial_shock/shock_lieutenant.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.1)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 1)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:SetSubMaterial(2, "horizons_submats/union_dvl.vmt")
					ply:SetRPName("Security 1st LT  "..ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_GRID then
					ply:SetModel("models/player/bunny/imperial_shock/shock_lieutenant.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:SetSubMaterial(2, "horizons_submats/defender_dvl.vmt")
					ply:SetRPName("Security 1st LT  "..ply:GetSavedRPName())
					ply:Give("weapon_lvsrepair")
				elseif ply:GetTeamClass() == CLASS_HELIX then
					ply:SetModel("models/player/bunny/imperial_shock/shock_lieutenant.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 1)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:SetSubMaterial(2, "horizons_submats/xray_dvl.vmt")
					ply:SetRPName("Security 1st LT  "..ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_SWORD then
					ply:SetModel("models/player/bunny/imperial_shock/shock_lieutenant.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.1)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(2, 16)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 1)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:SetSubMaterial(2, "horizons_submats/union_dvl.vmt")
					ply:SetRPName("Security 1st LT  "..ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_GHOST then
					ply:SetModel("models/player/bunny/imperial_shock/shock_lieutenant.mdl")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetBodygroup(1, 1)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 1)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:SetRPName("Security 1st LT  "..ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_DISPATCH then
					--ply:SetModel("models/dpfilms/metropolice/playermodels/pm_phoenix_police.mdl")
					ply:SetModel("models/player/bunny/imperial_shock/shock_lieutenant.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 1)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:SetBodygroup(ply:FindBodygroupByName("beard"), ply.impulseData.beard or 0)
    				ply:SetBodygroup(ply:FindBodygroupByName("hair"), ply.impulseData.hair or 0)
					ply:SetRPName("Security 1st LT  "..ply:GetSavedRPName())
				end
			end
		},
		{
			name = "DcO",
			description = "DcO",
			doorGroup = {1, 2, 3, 4, 5, 6, 7},
			xp = 0,
			whitelistLevel = 7,
			whitelistFailMessage = "You must be promoted to use this rank.",
			limit = 3,
			onBecome = function(ply, rank)
				ply:SetSubMaterial(2,"horizons_submats/dco.vmt")
				if ply:GetTeamClass() == CLASS_UNION then
					ply:SetModel("models/player/bunny/imperial_shock/shock_lieutenant.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.1)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 1)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:SetRPName("Security Captain "..ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_GRID then
					ply:SetModel("models/player/bunny/imperial_shock/shock_lieutenant.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:SetRPName("Security Captain "..ply:GetSavedRPName())
					ply:Give("weapon_lvsrepair")
				elseif ply:GetTeamClass() == CLASS_HELIX then
					ply:SetModel("models/player/bunny/imperial_shock/shock_lieutenant.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 1)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:SetRPName("Security Captain "..ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_SWORD then
					ply:SetModel("models/player/bunny/imperial_shock/shock_lieutenant.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.1)
					ply:SetBodygroup(1, 0)
					ply:SetBodygroup(2, 16)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 1)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:SetRPName("Security Captain "..ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_GHOST then
					ply:SetModel("models/player/bunny/imperial_shock/shock_lieutenant.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 1)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 1)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:SetRPName("Security Captain "..ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_DISPATCH then
					--ply:SetModel("models/dpfilms/metropolice/playermodels/pm_phoenix_police.mdl")
					ply:SetModel("models/player/bunny/imperial_shock/shock_lieutenant.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 1)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:SetBodygroup(ply:FindBodygroupByName("beard"), ply.impulseData.beard or 0)
    				ply:SetBodygroup(ply:FindBodygroupByName("hair"), ply.impulseData.hair or 0)
					ply:SetRPName("Security Captain "..ply:GetSavedRPName())
				end
			end
		},
		{
			name = "VCmD",
			description = "VCmD",
			itemsAdd = {
				{class = "wep_sw500", amount = 1},
				{class = "wep_stunstick", amount = 1},
				{class = "clo_cphelmet", amount = 1},
				{class = "item_vocoder", amount = 1}
			},
			doorGroup = {1, 2, 3, 4, 5, 6, 7},
			xp = 0,
			whitelistLevel = 8,
			whitelistFailMessage = "You must be promoted to use this rank.",
			limit = 1,
			onBecome = function(ply, rank)
				ply:SetSubMaterial(2,"horizons_submats/cmd.vmt")
				if ply:GetTeamClass() == CLASS_UNION then
					ply:SetModel("models/player/bunny/imperial_shock/shock_lieutenant.mdl")
					ply:SetMaxArmor(0)
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.1)
					ply:SetBodygroup(1, 1)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
				elseif ply:GetTeamClass() == CLASS_GRID then
					ply:SetModel("models/player/bunny/imperial_shock/shock_lieutenant.mdl")
					ply:SetMaxArmor(0)
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 1)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:Give("weapon_lvsrepair")
				elseif ply:GetTeamClass() == CLASS_HELIX then
					ply:SetModel("models/player/bunny/imperial_shock/shock_lieutenant.mdl")
					ply:SetMaxArmor(0)
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 1)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 1)
				elseif ply:GetTeamClass() == CLASS_SWORD then
					ply:SetModel("models/player/bunny/imperial_shock/shock_lieutenant.mdl")
					ply:SetMaxArmor(0)
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.1)
					ply:SetBodygroup(1, 1)
					ply:SetBodygroup(2, 16)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 1)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
				elseif ply:GetTeamClass() == CLASS_DISPATCH then
					--ply:SetModel("models/dpfilms/metropolice/playermodels/pm_phoenix_police.mdl")
					ply:SetModel("models/player/bunny/imperial_shock/shock_lieutenant.mdl")
					ply:SetMaxArmor(0)
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 1)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:SetBodygroup(ply:FindBodygroupByName("beard"), ply.impulseData.beard or 0)
    				ply:SetBodygroup(ply:FindBodygroupByName("hair"), ply.impulseData.hair or 0)
					ply:SetRPName("Operator "..ply:GetSavedRPName())
				end
				ply:SetRPName("MPF:VCmD." .. cptagtable[ply:GetTeamClass()] .. "-" .. math.random(10, 999))
			end
		},
		{
			name = "CmD",
			description = "CmD",
			doorGroup = {1, 2, 3, 4, 5, 6, 7},
			xp = 0,
			whitelistLevel = 9,
			whitelistFailMessage = "You must be promoted to use this rank.",
			limit = 1,
			onBecome = function(ply, rank)
				ply:SetSubMaterial(2,"horizons_submats/cmd.vmt")
				if ply:GetTeamClass() == CLASS_UNION then
					ply:SetModel("models/player/bunny/imperial_shock/shock_commander.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.1)
					ply:SetBodygroup(1, 1)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 1)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:SetRPName("Security Commander "..ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_GRID then
					ply:SetModel("models/player/bunny/imperial_shock/shock_commander.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 1)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:Give("weapon_lvsrepair")
					ply:SetRPName("Security Commander "..ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_HELIX then
					ply:SetModel("models/player/bunny/imperial_shock/shock_commander.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 1)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 1)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:SetRPName("Security Commander "..ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_SWORD then
					ply:SetModel("models/player/bunny/imperial_shock/shock_commander.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.1)
					ply:SetBodygroup(1, 1)
					ply:SetBodygroup(2, 16)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 1)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:SetRPName("Security Commander "..ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_GHOST then
					ply:SetModel("models/player/bunny/imperial_shock/shock_commander.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 1)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 0)
					ply:SetBodygroup(6, 1)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:GiveInventoryItem("wep_pistol", 1, true)
					ply:GiveInventoryItem("wep_stunstick", 1, true)
					ply:GiveInventoryItem("clo_cphelmet", 1, true)
					ply:GiveInventoryItem("item_vocoder", 1, true)
					ply:SetRPName("Security Commander "..ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_DISPATCH then
					--ply:SetModel("models/dpfilms/metropolice/playermodels/pm_phoenix_police.mdl")
					ply:SetModel("models/player/bunny/imperial_shock/shock_commander.mdl")
					ply:SetMaxArmor(0)
					ply:Give("rw_sw_stun_e11")
					ply:Give("rw_sw_e11_noscope")
					ply:SetRunSpeed(impulse.Config.JogSpeed * 1.05)
					ply:SetBodygroup(1, 1)
					ply:SetBodygroup(3, 0)
					ply:SetBodygroup(4, 0)
					ply:SetBodygroup(5, 1)
					ply:SetBodygroup(6, 0)
					ply:SetBodygroup(7, 0)
					ply:SetBodygroup(8, 0)
					ply:SetBodygroup(ply:FindBodygroupByName("beard"), ply.impulseData.beard or 0)
    				ply:SetBodygroup(ply:FindBodygroupByName("hair"), ply.impulseData.hair or 0)
					ply:SetRPName("Security Commander "..ply:GetSavedRPName())
				end
			end
		}
	}
})

CLASS_UNION = 1
CLASS_HELIX = 2
CLASS_GRID = 3
CLASS_SWORD = 4
CLASS_GHOST = 5
CLASS_DISPATCH = 6

RANK_I4 = 1
RANK_I3 = 2
RANK_I2 = 3
RANK_I1 = 4
RANK_OFC = 5
RANK_SQL = 6
RANK_DVL = 7
RANK_DCO = 8
RANK_VCMD = 9
RANK_CMD = 10


impulse.SubmatsConfig = {
	[TEAM_CP] = {
		[CLASS_UNION] = {
			[RANK_I4] = "horizons_submats/union_i4.vmt",
			[RANK_I3] = "horizons_submats/union_i3.vmt",
			[RANK_I2] = "horizons_submats/union_i2.vmt",
			[RANK_I1] = "horizons_submats/union_i1.vmt",
			[RANK_OFC] = "horizons_submats/union_ofc.vmt",
			[RANK_SQL] = "horizons_submats/union_sql.vmt",
			[RANK_DVL] = "horizons_submats/union_dvl.vmt",
			[RANK_DCO] = "horizons_submats/dco.vmt",
			[RANK_VCMD] = "horizons_submats/dco.vmt",
			[RANK_CMD] = "horizons_submats/cmd.vmt"
		},
		[CLASS_HELIX] = {
			[RANK_I4] = "horizons_submats/xray_i4.vmt",
			[RANK_I3] = "horizons_submats/xray_i3.vmt",
			[RANK_I2] = "horizons_submats/xray_i2.vmt",
			[RANK_I1] = "horizons_submats/xray_i1.vmt",
			[RANK_OFC] = "horizons_submats/xray_ofc.vmt",
			[RANK_SQL] = "horizons_submats/xray_sql.vmt",
			[RANK_DVL] = "horizons_submats/xray_dvl.vmt",
			[RANK_DCO] = "horizons_submats/dco.vmt",
			[RANK_VCMD] = "horizons_submats/dco.vmt",
			[RANK_CMD] = "horizons_submats/cmd.vmt"
		},
		[CLASS_GRID] = {
			[RANK_I4] = "horizons_submats/defender_i4.vmt",
			[RANK_I3] = "horizons_submats/defender_i3.vmt",
			[RANK_I2] = "horizons_submats/defender_i2.vmt",
			[RANK_I1] = "horizons_submats/defender_i1.vmt",
			[RANK_OFC] = "horizons_submats/defender_ofc.vmt",
			[RANK_SQL] = "horizons_submats/defender_sql.vmt",
			[RANK_DVL] = "horizons_submats/defender_dvl.vmt",
			[RANK_DCO] = "horizons_submats/dco.vmt",
			[RANK_VCMD] = "horizons_submats/dco.vmt",
			[RANK_CMD] = "horizons_submats/cmd.vmt"
		},
		[CLASS_GHOST] = {
			[RANK_I4] = "horizons_submats/jury_i4.vmt",
			[RANK_I3] = "horizons_submats/jury_i3.vmt",
			[RANK_I2] = "horizons_submats/jury_i2.vmt",
			[RANK_I1] = "horizons_submats/jury_i1.vmt",
			[RANK_OFC] = "horizons_submats/jury_ofc.vmt",
			[RANK_SQL] = "horizons_submats/jury_sql.vmt",
			[RANK_DVL] = "horizons_submats/jury_dvl.vmt",
			[RANK_DCO] = "horizons_submats/dco.vmt",
			[RANK_VCMD] = "horizons_submats/dco.vmt",
			[RANK_CMD] = "horizons_submats/cmd.vmt"
		},
		[CLASS_SWORD] = {
			[RANK_I4] = "horizons_submats/union_i4.vmt",
			[RANK_I3] = "horizons_submats/union_i3.vmt",
			[RANK_I2] = "horizons_submats/union_i2.vmt",
			[RANK_I1] = "horizons_submats/union_i1.vmt",
			[RANK_OFC] = "horizons_submats/union_ofc.vmt",
			[RANK_SQL] = "horizons_submats/union_sql.vmt",
			[RANK_DVL] = "horizons_submats/union_dvl.vmt",
			[RANK_DCO] = "horizons_submats/dco.vmt",
			[RANK_VCMD] = "horizons_submats/dco.vmt",
			[RANK_CMD] = "horizons_submats/cmd.vmt"
		},
		[CLASS_DISPATCH] = {
			[RANK_I4] = "horizons_submats/union_i4.vmt",
			[RANK_I3] = "horizons_submats/union_i3.vmt",
			[RANK_I2] = "horizons_submats/union_i2.vmt",
			[RANK_I1] = "horizons_submats/union_i1.vmt",
			[RANK_OFC] = "horizons_submats/union_ofc.vmt",
			[RANK_SQL] = "horizons_submats/union_sql.vmt",
			[RANK_DVL] = "horizons_submats/union_dvl.vmt",
			[RANK_DCO] = "horizons_submats/dco.vmt",
			[RANK_VCMD] = "horizons_submats/dco.vmt",
			[RANK_CMD] = "horizons_submats/cmd.vmt"
		},
	}
}