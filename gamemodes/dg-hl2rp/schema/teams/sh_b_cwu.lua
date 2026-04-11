TEAM_CWU = impulse.Teams.Define({
	name = "Civic Workforce",
	color = Color(123, 147, 163, 255),
	-- Description should be on one single line or the formatting will die
	description = [[A citizen who has been recruited or signed up to work for the Combine. Civic Workforce employees receive many benefits, with access to better food and medical supplies. Most Civic Workforce employees operate business in the city, selling resources to other citizens in return for tokens, and some may be hired by the City Administrator to work for him. Most Civic Workforce employees believe that the goal of the Combine is good and do their best to support it.]],
	loadout = {"impulse_hands"},
	spawnLoc = false,
	salary = 150,
	doorGroup = {1},
	xp = 10,
	cp = false,
	canAdvert = true,

	classes = {
		{
			name = "Maintenance",
			description = "Maintenance workers assist the city by handling civilian laundry and refilling vending machines.",
			model = "models/hlvr/characters/worker/worker_player.mdl",
			xp = 10,
			noMenu = true
		},
		{
			name = "Commercial",
			description = "Commercial Employees serve as the few people who can sell luxuries and goods to members of the civic populace.",
			bodygroups = {
				{2, 2},
				{3,0}
			},
			xp = 10,
			noMenu = true
		},
		{
			name = "Medical Employee",
			description = "Medical staff assist injured civilians with their problems and aim to keep the city healthy.",
			xp = 300,
			bodygroups = {
				{2, 3},
				{3,0}
			},
			noMenu = true
		},
		{
			name = "Refinery Worker",
			description = "Refinery workers mine various minerals and turn them into metal for the gain of the city.",
			bodygroups = {
				{2, 6},
				{3,0}
			},
			xp = 800,
			percentLimit = false,
			noMenu = true
		},
		{
			name = "Infestation Control Team Worker",
			description = "Infestation Control Teams work with Combine units to contain various outbreaks.",
			skin = 0,
			model = "models/hlvr/characters/hazmat_worker/hazmat_worker_player.mdl",
			xp = 500,
			noMenu = true,
		},
		{
			name = "Research & Development Team",
			description = "Researchers work on Xen Fauna and creatures to harness their resources for the Combine.",
			bodygroups = {
				{2, 5},
				{3,0}
			},
			xp = 0,
			noMenu = true,
			whitelistUID = "CW_Research",
			whitelistLevel = 1,
            whitelistFailMessage = "You must be specially whitelisted for the Research Team."
		},
	},

	ranks = {
		{
			name = "Intern",
			description = "intern",
			doorGroup = {1},
			xp = 0,
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_MEDIC then
					ply:SetBodygroup(2,3)
					ply:SetBodygroup(3,0)
					ply:SetBodygroup(5,3)
				elseif ply:GetTeamClass() == CLASS_INDUST then
					ply:SetModel("models/hlvr/characters/worker/worker_player.mdl")
					ply:GiveInventoryItem("item_ictvocoder", 1, true)
					ply:GiveInventoryItem("util_nvgs", 1, true)
				elseif ply:GetTeamClass() == CLASS_COMMERCE then
					ply:SetBodygroup(2,2)
					ply:SetBodygroup(3,0)
					if ply.BuyableTeamRemove then
					    for v,k in pairs(ply.BuyableTeamRemove) do
					        if k and IsValid(k) and k.BuyableOwner == ply and k:GetClass() == "impulse_hl2rp_brewingbarrel" then
					            k:Remove()
					        end
					    end
					end
				elseif ply:GetTeamClass() == CLASS_REFINERY then
					ply:SetBodygroup(2,6)
					ply:SetBodygroup(3,0)
				elseif ply:GetTeamClass() == CLASS_RESEARCH then
					ply:SetBodygroup(2,5)
					ply:SetBodygroup(3,0)
				else
					if ply:IsCharacterFemale() then
						ply:SetModel("models/hlvr/characters/hazmat_worker/hazmat_worker_female_player.mdl")
					else
						ply:SetModel("models/hlvr/characters/hazmat_worker/hazmat_worker_male_player.mdl")
					end
					ply:SetSkin(0)
				end
				if ply:GetTeamClass() != CLASS_ICT and ply:GetTeamClass() != CLASS_MEDIC and ply:GetTeamClass() != CLASS_RESEARCH then
					ply:SetRPName("Intern " .. ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_MEDIC then
					ply:SetRPName("Nurse " .. ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_RESEARCH then
					ply:SetRPName("Apprentice " .. ply:GetSavedRPName())
					table.insert(ply.DoorGroups, 7) -- Add Research Doorgroup
				else
					ply:SetRPName("ICT:INT." .. math.random(1,99))
					ply:GiveInventoryItem("item_ictvocoder", 1, true)
				end
			end
		},
		{
			name = "Employee",
			description = "ows",
			doorGroup = {1},
			xp = 5,
			whitelistLevel = 1,
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_MEDIC then
					ply:SetBodygroup(2,3)
					ply:SetBodygroup(3,0)
					ply:SetBodygroup(5,3)
				elseif ply:GetTeamClass() == CLASS_INDUST then
					ply:SetModel("models/hlvr/characters/worker/worker_player.mdl")
					ply:GiveInventoryItem("item_ictvocoder", 1, true)
					ply:GiveInventoryItem("util_nvgs", 1, true)
				elseif ply:GetTeamClass() == CLASS_COMMERCE then
					ply:SetBodygroup(2,2)
					ply:SetBodygroup(3,0)
					if ply.BuyableTeamRemove then
					    for v,k in pairs(ply.BuyableTeamRemove) do
					        if k and IsValid(k) and k.BuyableOwner == ply and k:GetClass() == "impulse_hl2rp_brewingbarrel" then
					            k:Remove()
					        end
					    end
					end
				elseif ply:GetTeamClass() == CLASS_REFINERY then
					ply:SetBodygroup(2,6)
					ply:SetBodygroup(3,0)
				elseif ply:GetTeamClass() == CLASS_RESEARCH then
					ply:SetBodygroup(2,5)
					ply:SetBodygroup(3,0)
					table.insert(ply.DoorGroups, 7) -- Add Research Doorgroup
				else
					if ply:IsCharacterFemale() then
						ply:SetModel("models/hlvr/characters/hazmat_worker/hazmat_worker_female_player.mdl")
					else
						ply:SetModel("models/hlvr/characters/hazmat_worker/hazmat_worker_male_player.mdl")
					end
					ply:SetSkin(0)
				end
				if ply:GetTeamClass() != CLASS_ICT and ply:GetTeamClass() != CLASS_MEDIC and ply:GetTeamClass() != CLASS_RESEARCH then
					ply:SetRPName("Employee " .. ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_MEDIC then
					ply:SetRPName("Resident " .. ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_RESEARCH then
					ply:SetRPName("Researcher " .. ply:GetSavedRPName())
				else
					ply:SetRPName("ICT:EMP." .. math.random(1,99))
					ply:GiveInventoryItem("item_ictvocoder", 1, true)
				end
			end
		},
		{
			name = "Supervisor",
			description = "eow",
			doorGroup = {1},
			xp = 5,
			whitelistLevel = 2,
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_MEDIC then
					ply:SetBodygroup(2,3)
					ply:SetBodygroup(3,0)
					ply:SetBodygroup(5,3)
				elseif ply:GetTeamClass() == CLASS_INDUST then
					ply:SetModel("models/hlvr/characters/worker/worker_player.mdl")
					ply:SetBodygroup(0,1)
					ply:GiveInventoryItem("item_ictvocoder", 1, true)
					ply:GiveInventoryItem("util_nvgs", 1, true)
				elseif ply:GetTeamClass() == CLASS_COMMERCE then
					ply:SetBodygroup(2,2)
					ply:SetBodygroup(3,0)
					if ply.BuyableTeamRemove then
					    for v,k in pairs(ply.BuyableTeamRemove) do
					        if k and IsValid(k) and k.BuyableOwner == ply and k:GetClass() == "impulse_hl2rp_brewingbarrel" then
					            k:Remove()
					        end
					    end
					end
				elseif ply:GetTeamClass() == CLASS_REFINERY then
					ply:SetBodygroup(2,6)
					ply:SetBodygroup(3,0)
				elseif ply:GetTeamClass() == CLASS_RESEARCH then
					ply:SetBodygroup(2,5)
					ply:SetBodygroup(3,0)
					table.insert(ply.DoorGroups, 7) -- Add Research Doorgroup
				else
					ply:SetBodygroup(1,1)
					ply:SetBodygroup(2,0)
					if ply:IsCharacterFemale() then
						ply:SetModel("models/hlvr/characters/hazmat_worker/hazmat_worker_female_player.mdl")
					else
						ply:SetModel("models/hlvr/characters/hazmat_worker/hazmat_worker_male_player.mdl")
					end
					ply:SetSkin(1)
				end
				if ply:GetTeamClass() != CLASS_ICT and ply:GetTeamClass() != CLASS_MEDIC and ply:GetTeamClass() != CLASS_RESEARCH then
					ply:SetRPName("Supervisor " .. ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_MEDIC then
					ply:SetRPName("Dr. " .. ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_RESEARCH then
					ply:SetRPName("Branch Overseer " .. ply:GetSavedRPName())
				else
					ply:SetRPName("ICT:SV." .. math.random(1,99))
					ply:GiveInventoryItem("item_ictvocoder", 1, true)
				end
			end
		},
		{
			name = "Director",
			description = "captain",
			xp = 5,
			doorGroup = {1},
			whitelistLevel = 3,
			--[[canPromote = {
				[RANK_CGR] = true
			},]]
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_MEDIC then
					ply:SetBodygroup(2,3)
					ply:SetBodygroup(3,0)
					ply:SetBodygroup(5,3)
				elseif ply:GetTeamClass() == CLASS_INDUST then
					ply:GiveInventoryItem("item_ictvocoder", 1, true)
					ply:GiveInventoryItem("util_nvgs", 1, true)
					ply:SetModel("models/hlvr/characters/worker/worker_player.mdl")
					ply:SetBodygroup(0,1)
				elseif ply:GetTeamClass() == CLASS_COMMERCE then
					ply:SetBodygroup(2,2)
					ply:SetBodygroup(3,0)
					if ply.BuyableTeamRemove then
					    for v,k in pairs(ply.BuyableTeamRemove) do
					        if k and IsValid(k) and k.BuyableOwner == ply and k:GetClass() == "impulse_hl2rp_brewingbarrel" then
					            k:Remove()
					        end
					    end
					end
				elseif ply:GetTeamClass() == CLASS_REFINERY then
					ply:SetBodygroup(2,6)
					ply:SetBodygroup(3,0)
				elseif ply:GetTeamClass() == CLASS_RESEARCH then
					ply:SetBodygroup(2,5)
					ply:SetBodygroup(3,0)
					table.insert(ply.DoorGroups, 7) -- Add Research Doorgroup
				else

					if ply:IsCharacterFemale() then
						ply:SetModel("models/hlvr/characters/hazmat_worker/hazmat_worker_female_player.mdl")
					else
						ply:SetModel("models/hlvr/characters/hazmat_worker/hazmat_worker_male_player.mdl")
					end
					ply:SetSkin(2)
				end
				if ply:GetTeamClass() != CLASS_ICT and ply:GetTeamClass() != CLASS_MEDIC and ply:GetTeamClass() != CLASS_RESEARCH then
					ply:SetRPName("Director " .. ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_MEDIC then
					ply:SetRPName("Department Head Dr. " .. ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_RESEARCH then
					ply:SetRPName("Project Manager " .. ply:GetSavedRPName())
					table.insert(ply.DoorGroups, 7) -- Add Research Doorgroup
				else
					ply:SetRPName("ICT:DIR." .. math.random(1,99))
					ply:GiveInventoryItem("item_ictvocoder", 1, true)
				end
			end
		},
		{
			name = "Minister",
			description = "ldr",
			xp = 5,
			doorGroup = {1, 2, 7},
			whitelistLevel = 4,
			--[[canPromote = {
				[RANK_CGR] = true,
				[RANK_OWS] = true,
			},]]
			onBecome = function(ply, rank)
				if ply:GetTeamClass() == CLASS_INDUST then
					ply:GiveInventoryItem("item_ictvocoder", 1, true)
					ply:GiveInventoryItem("util_nvgs", 1, true)
					ply:SetModel("models/hlvr/characters/worker/worker_player.mdl")
					ply:SetBodygroup(0,1)
				elseif ply:GetTeamClass() == CLASS_REFINERY then
					if ply:IsCharacterFemale() then
						ply:SetBodygroup(4,5)
					else
						ply:SetBodygroup(4,3)
					end
					ply:SetBodygroup(2,28)
					ply:SetBodygroup(3,5)
					ply:SetBodygroup(5,1)
				elseif ply:GetTeamClass() == CLASS_MEDIC then
					if ply:IsCharacterFemale() then
						ply:SetBodygroup(4,5)
					else
						ply:SetBodygroup(4,3)
					end
					ply:SetBodygroup(2,5)
					ply:SetBodygroup(3,7)
					ply:SetBodygroup(5,3)
				elseif ply:GetTeamClass() == CLASS_COMMERCE then
					if ply.BuyableTeamRemove then
					    for v,k in pairs(ply.BuyableTeamRemove) do
					        if k and IsValid(k) and k.BuyableOwner == ply and k:GetClass() == "impulse_hl2rp_brewingbarrel" then
					            k:Remove()
					        end
						end 
					end
					if ply:IsCharacterFemale() then
						ply:SetBodygroup(4,5)
					else
						ply:SetBodygroup(4,3)
					end
					ply:SetBodygroup(2,20)
					ply:SetBodygroup(3,1)
				elseif ply:GetTeamClass() == CLASS_RESEARCH then
					if ply:IsCharacterFemale() then
						ply:SetBodygroup(4,5)
					else
						ply:SetBodygroup(4,3)
					end
					ply:SetBodygroup(2,5)
					ply:SetBodygroup(3,5)
				else
					if ply:IsCharacterFemale() then
						ply:SetModel("models/hlvr/characters/hazmat_worker/hazmat_worker_female_player.mdl")
					else
						ply:SetModel("models/hlvr/characters/hazmat_worker/hazmat_worker_male_player.mdl")
					end
					ply:SetSkin(2)
				end
				if ply:GetTeamClass() != CLASS_ICT and ply:GetTeamClass() != CLASS_RESEARCH then
					ply:SetRPName("Minister " .. ply:GetSavedRPName())
				elseif ply:GetTeamClass() == CLASS_RESEARCH then
					ply:SetRPName("Head Researcher " .. ply:GetSavedRPName())
				else
					ply:SetRPName("ICT:MNTR." .. math.random(1,99))
					ply:GiveInventoryItem("item_ictvocoder", 1, true)
					ply:GiveInventoryItem("util_nvgs", 1, true)
				end
			end
		},
	}
})

CLASS_INDUST = 1
CLASS_COMMERCE = 2
CLASS_MEDIC = 3
CLASS_REFINERY = 4
CLASS_ICT = 5
CLASS_RESEARCH = 6

RANK_INTERN = 1
RANK_EMPLOYEE = 2
RANK_SUPERVISOR = 3
RANK_DIRECTOR = 4
RANK_MINISTER = 5
