CLASS_UNION    = 1
CLASS_HELIX    = 2
CLASS_GRID     = 3
CLASS_SWORD    = 4
CLASS_GHOST    = 5
CLASS_DISPATCH = 6

cptagtable = {"UNION", "HELIX", "GRID", "SWORD", "GHOST", "ERROR"}

-- change body groups here
local CLASS_BG = {
    [CLASS_UNION]    = { [1]=0, [3]=0, [4]=0, [5]=1, [6]=0, [7]=0, [8]=0 },
    [CLASS_HELIX]    = { [1]=0, [2]=4, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0, [8]=1 },
    [CLASS_GRID]     = { [1]=0, [2]=12,[3]=0, [4]=0, [5]=0, [6]=0, [7]=0, [8]=0 },
    [CLASS_SWORD]    = { [1]=0, [2]=2,[3]=0, [4]=0, [5]=1, [6]=1, [7]=0, [8]=0 },
    [CLASS_GHOST]    = { [1]=1, [2]=8, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0, [8]=0 },
    [CLASS_DISPATCH] = { [1]=1, [3]=0, [4]=0, [5]=1, [6]=0, [7]=0, [8]=0 },
}

local SHOULDERPAD_BG = {
    [CLASS_HELIX] = { [2]=6 },
    [CLASS_GRID]  = { [2]=14 },
    [CLASS_GHOST] = { [2]=10 },
    [CLASS_SWORD] = { [2]=16 },
}


local function applyBodygroups(ply, bgs)
    for index, value in pairs(bgs) do
        ply:SetBodygroup(index, value)
    end
end

local function setupDispatch(ply)
    ply:SetModel("models/wn7new/metropolice/male_0" .. math.random(1,9) .. ".mdl")
    ply:SetMaxArmor(0)
    applyBodygroups(ply, CLASS_BG[CLASS_DISPATCH])
    ply:SetBodygroup(ply:FindBodygroupByName("beard"), ply.impulseData.beard or 0)
    ply:SetBodygroup(ply:FindBodygroupByName("hair"),  ply.impulseData.hair  or 0)
    ply:SetRPName("Operator " .. ply:GetSavedRPName())
end

--   isJunior = true   | skips pistol for i4
--   isCommand = true  | overrides bg[1] to 1 for all classes
--   bgOverride        | is a per-class BG, just union and vcmd rn
--   model             | per-class model override
--   submat            | per-class submaterial
--   globalSubmat = "" | same submaterial applied to all classes
--   noItems = true    | skips GiveInventoryItem, rank uses itemsAdd instead
local function makeOnBecome(rankName, opts)
    opts = opts or {}
    return function(ply, rank)
        local class = ply:GetTeamClass()

        if class == CLASS_DISPATCH then
            setupDispatch(ply)
            return
        end

        ply:SetModel(
            (opts.model and opts.model[class])
            or ("models/wn7new/metropolice/male_0" .. math.random(1,9) .. ".mdl")
        )

        ply:SetMaxArmor(0)

        local bgs = {}
        for k, v in pairs(CLASS_BG[class]) do bgs[k] = v end
        if opts.bgOverride and opts.bgOverride[class] then
            for k, v in pairs(opts.bgOverride[class]) do bgs[k] = v end
        end
        if opts.isCommand then bgs[1] = 1 end
        applyBodygroups(ply, bgs)

        if not opts.noItems then
            if not opts.isJunior then
                ply:GiveInventoryItem("wep_pistol", 1, true)
            end
            ply:GiveInventoryItem("wep_stunstick", 1, true)
            ply:GiveInventoryItem("clo_cphelmet",  1, true)
            --ply:GiveInventoryItem("item_vocoder",  1, true)
        end

        if class == CLASS_GRID then
            ply:Give("weapon_lvsrepair")
        end

        if opts.submat and opts.submat[class] then
            ply:SetSubMaterial(2, opts.submat[class])
        elseif opts.globalSubmat then
            ply:SetSubMaterial(2, opts.globalSubmat)
        end

        ply:SetRPName("MPF:" .. rankName .. "." .. cptagtable[class] .. "-" .. math.random(10, 999))
    end
end

TEAM_CP = impulse.Teams.Define({
    name = "Metro Police Force",
    color = Color(65, 105, 200, 255),
    description = [[The M.P.F. are the Combine's human police force. They are responsible for the enforcement of the Combine's laws, and controlling the population. The M.P.F. consists of multiple divisions, each with a specific role. Many join the M.P.F. in hopes of getting better rations, or simply for the power it brings over their fellow citizens.]],
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
		handbook = "https://docs.google.com/document/d/1ELXJhWy782W8SqdiqwuZ4iciNbwZT36apBG2_ne1EOQ/edit?usp=sharing",
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
				{"51b & 99, Arrest", false},
				{"None of the above", false}
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
				{"Intention 1.", true}
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
			question = "Do CTA have any authority over MPF personnel?",
			answers = {
				{"Yes", true},
				{"No", false},
				{"CTA Supervisors only", false},
				{"CTA Supervisors only in the absence of any equal or higher rank MPF Supervisors", true}
			}
		},
		{
			id = 14,
			question = "A citizen is calling you names such as idiot after you have arrested them what do you do?",
			answers = {
				{"Ask a supervisor to increase their sentence", true},
				{"Do nothing", false},
				{"Ask CTA to increase their sentence", false},
				{"Go to nexus and kill them", false}
			}
		},
		{
			id = 15,
			question = "What do you do if there is no PT to interlock into?",
			answers = {
				{"Wait for a PT team to become available", false},
				{"Go patrol with someone and make a makeshift PT.", true},
				{"Patrol by yourself", false},
				{"None of the above", false}
			}
		},
		{
			id = 16,
			question = "There is an i5 in nexus who is untrained what do you do?",
			answers = {
				{"Train them yourself.", false},
				{"Fine the appropriate rank to train them i1+", true},
				{"Do nothing", false}
			}
		},
		{
			id = 17,
			question = "What is the primary purpose of the MPF?",
			answers = {
				{"Policing the civic populous.", true},
				{"Enforcing the rules of the server", false},
				{"Patrolling the Outlands", false},
				{"Selling permits for building construction and weapons.", false}
			}
		},
		{
			id = 18,
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
            onBecome = makeOnBecome("i4", {
                isJunior = true,
                bgOverride = {
                    [CLASS_UNION] = { [7]=0 }, -- no shoulder lamp at i4
                },
            }),
        },
        {
            name = "i3",
            description = "i3",
            xp = 500,
            onBecome = makeOnBecome("i3"),
        },
        {
            name = "i2",
            description = "i2",
            doorGroup = {1, 2, 3, 6, 7},
            xp = 1000,
            whitelistFailMessage = "You must be promoted to use this rank.",
            onBecome = makeOnBecome("i2"),
        },
        {
            name = "i1",
            description = "i1",
            doorGroup = {1, 2, 3, 6, 7},
            xp = 0,
            whitelistLevel = 1,
            whitelistFailMessage = "You must be promoted to use this rank.",
            onBecome = makeOnBecome("i1"),
        },
        {
            name = "OfC",
            description = "OfC",
            doorGroup = {1, 2, 3, 6, 7},
            xp = 0,
            whitelistLevel = 2,
            whitelistFailMessage = "You must be promoted to use this rank.",
            onBecome = makeOnBecome("OfC", {
		        bgOverride = SHOULDERPAD_BG,
		    }),
        },
        {
            name = "SqL",
            description = "SqL",
            doorGroup = {1, 2, 3, 4, 6, 7},
            xp = 0,
            whitelistLevel = 3,
            whitelistFailMessage = "You must be promoted to use this rank.",
            onBecome = makeOnBecome("SqL", {
		        bgOverride = SHOULDERPAD_BG,
		    }),
        },
        {
            name = "DvL",
            description = "DvL",
            doorGroup = {1, 2, 3, 4, 6, 7},
            xp = 0,
            whitelistLevel = 4,
            whitelistFailMessage = "You must be promoted to use this rank.",
            limit = 5,
            onBecome = makeOnBecome("DvL", {
            	bgOverride = SHOULDERPAD_BG,
                model = {
                    [CLASS_UNION] = "models/wn7new/metropolice/male_07.mdl",
                },
                submat = {
                    [CLASS_UNION] = "horizons_submats/union_dvl.vmt",
                    [CLASS_HELIX] = "horizons_submats/xray_dvl.vmt",
                    [CLASS_GRID]  = "horizons_submats/defender_dvl.vmt",
                    [CLASS_SWORD] = "horizons_submats/union_dvl.vmt",
                },
            }),
        },
        {
            name = "DcO",
            description = "DcO",
            doorGroup = {1, 2, 3, 4, 5, 6, 7},
            xp = 0,
            whitelistLevel = 5,
            whitelistFailMessage = "You must be promoted to use this rank.",
            limit = 3,
            onBecome = makeOnBecome("DcO", {
            	bgOverride = {
                    [CLASS_UNION] = { [2]=16, [5]=0, [7]=0 },
                    [CLASS_HELIX]  = { [2]=16 },
		            [CLASS_GRID]   = { [2]=16 },
		            [CLASS_SWORD]  = { [2]=16 },
		            [CLASS_GHOST]  = { [2]=16 },
		        },
                globalSubmat = "horizons_submats/dco.vmt",
            }),
        },
        {
            name = "VCmD",
            description = "VCmD",
            itemsAdd = {
                {class = "wep_sw500",    amount = 1},
                {class = "wep_stunstick",amount = 1},
                {class = "clo_cphelmet", amount = 1},
                {class = "item_vocoder", amount = 1},
            },
            doorGroup = {1, 2, 3, 4, 5, 6, 7},
            xp = 0,
            whitelistLevel = 6,
            whitelistFailMessage = "You must be promoted to use this rank.",
            limit = 1,
            onBecome = makeOnBecome("VCmD", {
                isCommand = true,
                noItems = true,
                globalSubmat = "horizons_submats/cmd.vmt",
                bgOverride = {
                    [CLASS_UNION] = { [2]=16, [5]=0, [7]=0 },
                    [CLASS_HELIX]  = { [2]=16 },
		            [CLASS_GRID]   = { [2]=16 },
		            [CLASS_SWORD]  = { [2]=16 },
		            [CLASS_GHOST]  = { [2]=16 },
		        },
            }),
        },
        {
            name = "CmD",
            description = "CmD",
            doorGroup = {1, 2, 3, 4, 5, 6, 7},
            xp = 0,
            whitelistLevel = 7,
            whitelistFailMessage = "You must be promoted to use this rank.",
            limit = 1,
            onBecome = makeOnBecome("CmD", {
                isCommand = true,
                globalSubmat = "horizons_submats/cmd.vmt",
                bgOverride = {
		            [CLASS_UNION] = { [2]=16, [5]=0, [7]=0 },
	                [CLASS_HELIX]  = { [2]=16 },
		            [CLASS_GRID]   = { [2]=16 },
		            [CLASS_SWORD]  = { [2]=16 },
		            [CLASS_GHOST]  = { [2]=16 },
		        }
            }),
        },
    }
})

RANK_I4   = 1
RANK_I3   = 2
RANK_I2   = 3
RANK_I1   = 4
RANK_OFC  = 5
RANK_SQL  = 6
RANK_DVL  = 7
RANK_DCO  = 8
RANK_VCMD = 9
RANK_CMD  = 10

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
