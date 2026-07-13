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


	customCheck = function(plr, teamId)
		local canJoin = plr:GetTeamWhitelist("TEAM_CA") >= RANK_INTERN

		if !canJoin then 
			plr:Notify("You are not whitelisted for this faction!")
			return false
		end 

		return true 
	end,

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
			xp = 750,
			whitelistLevel = 1,
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_BASE then
					ply:SetModel(ply.defaultModel)
					ply:SetBodygroup(2,32)
					ply:SetBodygroup(3,9)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(4,0)
					ply:SetBodygroup(5,0)
					ply:SetBodygroup(6,0)
					ply:SetBodygroup(7,0)
					ply:SetBodygroup(8,0)
					ply:SetRPName("Assistant " .. ply:GetSavedRPName())
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
			name = "Councilor",
			description = "councilor",
			doorGroup = {1, 2, 3, 4, 6, 7},
			xp = 900,
			whitelistLevel = 2,
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_BASE then
					ply:SetModel(ply.defaultModel)
					ply:SetBodygroup(2,4)
					ply:SetBodygroup(3,6)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(4,0)
					ply:SetBodygroup(5,0)
					ply:SetBodygroup(6,0)
					ply:SetBodygroup(7,0)
					ply:SetBodygroup(8,0)
					ply:SetRPName("Councilor " .. ply:GetSavedRPName())
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
			name = "City Administrator",
			description = "ca",
			xp = 1200,
			doorGroup = {1, 2, 3, 4, 5, 6, 7},
			whitelistLevel = 3,
			--[[canPromote = {
				[RANK_OWG] = true
			},]]
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_BASE then
					ply:SetModel(ply.defaultModel)
					ply:SetBodygroup(2,34)
					ply:SetBodygroup(3,7)
					ply:SetBodygroup(1,0)
					ply:SetBodygroup(4,0)
					ply:SetBodygroup(5,0)
					ply:SetBodygroup(6,0)
					ply:SetBodygroup(7,0)
					ply:SetBodygroup(8,0)
					ply:Give("plutonic_357")
					ply:SetRPName("City Administrator " .. ply:GetSavedRPName())
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