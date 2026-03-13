impulse.Business.Define("Cooking Stove", {
	bench = "stove",
	model = "models/props_c17/furnitureStove001a.mdl",
    refund = true,
	price = 50,
    removeOnTeamSwitch = true,
    teams = {TEAM_CWU},
    classes = {CLASS_COMMERCE}
})

impulse.Business.Define("Clothing Workbench", {
	bench = "clothing",
	model = "models/mosi/fallout4/furniture/workstations/weaponworkbench02.mdl",
    refund = true,
	price = 70,
    removeOnTeamSwitch = true,
    customCheck = function(ply)
		if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU or ply:Team() == TEAM_VORT then
			return true
		else
			return false
		end
	end
})

impulse.Business.Define("General Workbench", {
	bench = "general",
	model = "models/mosi/fallout4/furniture/workstations/workshopbench.mdl",
    refund = true,
	price = 70,
    removeOnTeamSwitch = true,
    customCheck = function(ply)
    	if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU or ply:Team() == TEAM_VORT then
			return true
		else
			return false
		end
    end
})

impulse.Business.Define("Tinker Workbench", {
	bench = "scrap",
	model = "models/mosi/fallout76/furniture/workstations/tinkerstation.mdl",
    refund = true,
	price = 80,
    removeOnTeamSwitch = true,
    customCheck = function(ply)
    	if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU or ply:Team() == TEAM_VORT then
			return true
		else
			return false
		end
    end
})
--[[
impulse.Business.Define("Biolink Removal Station", {
	bench = "blremover",
	model = "models/props_c17/TrapPropeller_Engine.mdl",
    refund = true,
	price = 100,
    removeOnTeamSwitch = true,
    customCheck = function(ply)
    	if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU then
			return true
		else
			return false
		end
    end
}
--]]

impulse.Business.Define("Weaponry Workbench", {
	bench = "weapon",
	model = "models/mosi/fallout4/furniture/workstations/armorworkbench.mdl",
    refund = true,
	price = 100,
    removeOnTeamSwitch = true,
    customCheck = function(ply)
    	if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU or ply:Team() == TEAM_VORT then
			return true
		else
			return false
		end
    end
})

impulse.Business.Define("Heavy Weaponry Workbench", {
	bench = "heavyweapon",
	model = "models/mosi/fallout4/furniture/workstations/weaponworkbench01.mdl",
    refund = true,
	price = 200,
    removeOnTeamSwitch = true,
    customCheck = function(ply)
    	if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU or ply:Team() == TEAM_VORT then
			return true
		else
			return false
		end
    end
})

impulse.Business.Define("Attachment Workbench", {
	bench = "attachment",
	model = "models/ammoworkbench.mdl",
    refund = true,
	price = 45,
    removeOnTeamSwitch = true,
    customCheck = function(ply)
    	if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU or ply:Team() == TEAM_VORT then
			return true
		else
			return false
		end
    end
})

impulse.Business.Define("Medicine Workbench", {
	bench = "medical",
	model = "models/mosi/fallout4/furniture/workstations/chemistrystation02.mdl",
    refund = true,
	price = 95,
    removeOnTeamSwitch = true,
    customCheck = function(ply)
    	if ply:Team() == TEAM_CWU and ply:GetTeamClass() == CLASS_MEDIC then
			return true
		else
			return false
		end
    end
})

impulse.Business.Define("Technology Workbench [Tech Level 10+]", {
	bench = "tech",
	model = "models/mosi/fallout4/furniture/workstations/chemistrystation02.mdl",
    refund = true,
	price = 80,
    removeOnTeamSwitch = true,
    customCheck = function(ply)
    	if (ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU) and ply:GetSkillLevel("metabolism") >= 10  then
			return true
		else
			return false
		end
    end
})