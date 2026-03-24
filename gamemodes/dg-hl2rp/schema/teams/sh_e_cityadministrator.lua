TEAM_CA = impulse.Teams.Define({
	name = "Office of City Administration",
	color = Color(100, 0, 220, 255),
	description = [[The District Administrator is a figurehead put in place by the Combine leadership to diminish dissidents and suppress rebel instances via propaganda. They do have minor legislation power, but overall are a puppet on a string.]],
	loadout = {"impulse_hands"},
	salary = 250,
	spawnLoc = true,
	limit = 8,
	percentLimit = false,
	xp = 750,
	cp = true,
	doorGroup = {1, 2, 6, 7},

	classes = {
		{
			name = "Administration Branch",
			description = "O.C.A. members serve as the politcal leadership within the city, although given very limited power, they do have the authority to make minor decisions.",
			xp = 0,
			noMenu = true
		},
	},

	ranks = {
		{
			name = "Assistant",
			description = "intern",
			doorGroup = {2},
			xp = 0,
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_BASE then
					ply:SetModel("models/nada/pms/male/bridgecrew.mdl")
					ply:Give("rw_sw_se14r")
					ply:SetBodygroup(2,0)
					ply:SetBodygroup(3,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(4,0)
					ply:SetBodygroup(5,0)
					ply:SetBodygroup(6,0)
					ply:SetBodygroup(7,0)
					ply:SetBodygroup(8,0)
					ply:SetRPName("Petty Officer " .. ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_INTELLIGENCE then
					ply:SetModel(ply.defaultModel)
					ply:SetBodygroup(2,34)
					ply:SetBodygroup(3,9)
					ply:SetBodygroup(1,10)
					ply:SetBodygroup(4,5)
					ply:SetBodygroup(5,0)
					ply:SetBodygroup(6,0)
					ply:SetBodygroup(7,0)
					ply:SetBodygroup(8,0)
					ply:SetRPName("Junior Agent " .. ply:GetSavedRPName())
				else
					ply:SetModel(ply.defaultModel)
					ply:SetBodygroup(2,44)
					ply:SetBodygroup(3,9)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(4,0)
					ply:SetBodygroup(5,0)
					ply:SetBodygroup(6,0)
					ply:SetBodygroup(7,0)
					ply:SetBodygroup(8,0)
					ply:SetRPName("Reporter " .. ply:GetSavedRPName())
				end
			end
		},
		{
			name = "Representative",
			description = "rep",
			doorGroup = {1, 2, 3, 4, 5, 6, 7},
			xp = 5,
			whitelistLevel = 1,
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_BASE then
					ply:SetModel("models/nada/pms/male/black_naval_officer.mdl")
					ply:Give("rw_sw_se14r")
					ply:SetBodygroup(2,0)
					ply:SetBodygroup(3,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(4,0)
					ply:SetBodygroup(5,0)
					ply:SetBodygroup(6,0)
					ply:SetBodygroup(7,0)
					ply:SetBodygroup(8,0)
					ply:SetRPName("Lieutenant " .. ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_INTELLIGENCE then
					ply:SetModel(ply.defaultModel)
					ply:SetBodygroup(2,34)
					ply:SetBodygroup(3,9)
					ply:SetBodygroup(1,10)
					ply:SetBodygroup(4,5)
					ply:SetBodygroup(5,0)
					ply:SetBodygroup(6,0)
					ply:SetBodygroup(7,0)
					ply:SetBodygroup(8,0)
					ply:SetRPName("Agent " .. ply:GetSavedRPName())
				else
					ply:SetModel(ply.defaultModel)
					ply:SetBodygroup(2,44)
					ply:SetBodygroup(3,9)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(4,0)
					ply:SetBodygroup(5,0)
					ply:SetBodygroup(6,0)
					ply:SetBodygroup(7,0)
					ply:SetBodygroup(8,0)
					ply:SetRPName("Reporter " .. ply:GetSavedRPName())
				end
			end
		},
		{
			name = "Coordinator",
			description = "coordinator",
			doorGroup = {1, 2, 3, 4, 5, 6, 7},
			xp = 5,
			whitelistLevel = 2,
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_BASE then
					ply:SetModel("models/nada/pms/male/grey_admiral.mdl")
					ply:Give("rw_sw_se14r")
					ply:SetBodygroup(2,0)
					ply:SetBodygroup(3,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(4,0)
					ply:SetBodygroup(5,0)
					ply:SetBodygroup(6,0)
					ply:SetBodygroup(7,0)
					ply:SetBodygroup(8,0)
					ply:SetRPName("Major " .. ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_INTELLIGENCE then
					ply:SetModel("models/nada/pms/male/grey_admiral.mdl")
					ply:SetBodygroup(2,34)
					ply:SetBodygroup(3,9)
					ply:SetBodygroup(1,10)
					ply:SetBodygroup(4,5)
					ply:SetBodygroup(5,0)
					ply:SetBodygroup(6,0)
					ply:SetBodygroup(7,0)
					ply:SetBodygroup(8,0)
					ply:SetRPName("Senior Agent " .. ply:GetSavedRPName())
				else
					ply:SetModel(ply.defaultModel)
					ply:SetBodygroup(2,44)
					ply:SetBodygroup(3,9)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(4,0)
					ply:SetBodygroup(5,0)
					ply:SetBodygroup(6,0)
					ply:SetBodygroup(7,0)
					ply:SetBodygroup(8,0)
					ply:SetRPName("Producer " .. ply:GetSavedRPName())
				end
			end
		},
		{
			name = "Councilor",
			description = "councilor",
			doorGroup = {1, 2, 3, 4, 6, 7},
			xp = 5,
			whitelistLevel = 3,
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_BASE then
					ply:SetModel("models/nada/pms/male/admiral.mdl")
					ply:Give("rw_sw_se14r")
					ply:SetBodygroup(2,0)
					ply:SetBodygroup(3,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(4,0)
					ply:SetBodygroup(5,0)
					ply:SetBodygroup(6,0)
					ply:SetBodygroup(7,0)
					ply:SetBodygroup(8,0)
					ply:SetRPName("Colonel " .. ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_INTELLIGENCE then
					ply:SetModel(ply.defaultModel)
					ply:SetBodygroup(2,34)
					ply:SetBodygroup(3,9)
					ply:SetBodygroup(1,10)
					ply:SetBodygroup(4,5)
					ply:SetBodygroup(5,0)
					ply:SetBodygroup(6,0)
					ply:SetBodygroup(7,0)
					ply:SetBodygroup(8,0)
					ply:SetRPName("Supervisory Agent " .. ply:GetSavedRPName())
				else
					ply:SetModel(ply.defaultModel)
					ply:SetBodygroup(2,44)
					ply:SetBodygroup(3,9)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(4,0)
					ply:SetBodygroup(5,0)
					ply:SetBodygroup(6,0)
					ply:SetBodygroup(7,0)
					ply:SetBodygroup(8,0)
					ply:SetRPName("Assistant Media Director " .. ply:GetSavedRPName())
				end
			end
		},
		{
			name = "Minister",
			description = "Minister",
			doorGroup = {1, 2, 3, 4, 5, 6, 7},
			xp = 5,
			whitelistLevel = 4,
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_BASE then
					ply:SetModel("models/nada/pms/male/admiral_esb.mdl")
					ply:Give("rw_sw_se14r")
					ply:SetBodygroup(2,0)
					ply:SetBodygroup(3,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(4,0)
					ply:SetBodygroup(5,0)
					ply:SetBodygroup(6,0)
					ply:SetBodygroup(7,0)
					ply:SetBodygroup(8,0)
					ply:SetRPName("Vice Admiral " .. ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_INTELLIGENCE then
					ply:SetModel(ply.defaultModel)
					ply:SetBodygroup(2,34)
					ply:SetBodygroup(3,9)
					ply:SetBodygroup(1,10)
					ply:SetBodygroup(4,5)
					ply:SetBodygroup(5,0)
					ply:SetBodygroup(6,0)
					ply:SetBodygroup(7,0)
					ply:SetBodygroup(8,0)
					ply:SetRPName("Supervisory Agent " .. ply:GetSavedRPName())
				else
					ply:SetModel(ply.defaultModel)
					ply:SetBodygroup(2,44)
					ply:SetBodygroup(3,9)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(4,0)
					ply:SetBodygroup(5,0)
					ply:SetBodygroup(6,0)
					ply:SetBodygroup(7,0)
					ply:SetBodygroup(8,0)
					ply:SetRPName("Assistant Media Director " .. ply:GetSavedRPName())
				end
			end
		},
		{
			name = "Deputy City Administrator",
			description = "ca",
			xp = 5,
			doorGroup = {1, 2, 3, 4, 5, 6, 7},
			whitelistLevel = 5,
			--[[canPromote = {
				[RANK_OWG] = true
			},]]
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_BASE then
					ply:SetModel("models/nada/pms/male/grandadmiral.mdl")
					ply:Give("rw_sw_se14r")
					ply:SetModelScale(1.1)
					ply:SetHealth(100)
					ply:SetMaxHealth(100)
					ply:SetBodygroup(2,0)
					ply:SetBodygroup(3,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(4,0)
					ply:SetBodygroup(5,0)
					ply:SetBodygroup(6,0)
					ply:SetBodygroup(7,0)
					ply:SetBodygroup(8,0)
					ply:SetRPName("Admiral " .. ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_INTELLIGENCE then
					ply:SetModel(ply.defaultModel)
					ply:SetBodygroup(2,43)
					ply:SetBodygroup(3,12)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(4,1)
					ply:SetBodygroup(5,0)
					ply:SetBodygroup(6,0)
					ply:SetBodygroup(7,0)
					ply:SetBodygroup(8,0)
					ply:SetRPName("S.A.I.C. " .. ply:GetSavedRPName())
				else
					ply:SetModel(ply.defaultModel)
					ply:SetBodygroup(2,44)
					ply:SetBodygroup(3,9)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(4,0)
					ply:SetBodygroup(5,0)
					ply:SetBodygroup(6,0)
					ply:SetBodygroup(7,0)
					ply:SetBodygroup(8,0)
					ply:SetRPName("Media Director " .. ply:GetSavedRPName())
				end
			end
		},
		{
			name = "City Administrator",
			description = "ca",
			xp = 5,
			doorGroup = {1, 2, 3, 4, 5, 6, 7},
			whitelistLevel = 6,
			--[[canPromote = {
				[RANK_OWG] = true
			},]]
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_BASE then
					ply:SetModel("models/nada/pms/male/grandadmiral.mdl")
					ply:Give("rw_sw_se14r")
					ply:SetBodygroup(2,0)
					ply:SetBodygroup(3,0)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(4,0)
					ply:SetBodygroup(5,0)
					ply:SetBodygroup(6,0)
					ply:SetBodygroup(7,0)
					ply:SetBodygroup(8,0)
					ply:SetRPName("Grand Admiral " .. ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_INTELLIGENCE then
					ply:SetModel(ply.defaultModel)
					ply:SetBodygroup(2,34)
					ply:SetBodygroup(3,9)
					ply:SetBodygroup(1,10)
					ply:SetBodygroup(4,0)
					ply:SetBodygroup(5,0)
					ply:SetBodygroup(6,0)
					ply:SetBodygroup(7,0)
					ply:SetBodygroup(8,0)
					ply:SetRPName("City Administrator " .. ply:GetSavedRPName())
				else
					ply:SetModel(ply.defaultModel)
					ply:SetBodygroup(2,44)
					ply:SetBodygroup(3,9)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(4,0)
					ply:SetBodygroup(5,0)
					ply:SetBodygroup(6,0)
					ply:SetBodygroup(7,0)
					ply:SetBodygroup(8,0)
					ply:SetRPName("Media Director " .. ply:GetSavedRPName())
				end
			end
		},
	}
})

CLASS_BASE = 1
CLASS_INTELLIGENCE = 2

RANK_INTERN = 1 -- Assistant
RANK_REPRESENTATIVE = 2 -- Representative
RANK_COUNCILMAN = 3 -- Coordinator/Councilman
RANK_DEPUTY = 4 -- Councilor/Executive
RANK_MINISTER = 5 -- Minister
RANK_CA = 6 -- Deputy City Administrator
RANK_EA = 7 -- City Administrator
