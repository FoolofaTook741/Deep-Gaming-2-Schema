local ITEM = {}

ITEM.UniqueID = "cos_conscriptarmor"
ITEM.Name = "Concscript Armor"
ITEM.Desc =  "A full suit of military armor that offers 50% head and body protection. It also provides immunity to gas and flash attacks. "
ITEM.Category = "Clothing"
ITEM.Model = Model("models/willardnetworks/clothingitems_conscripts/torso_vest_3.mdl")
ITEM.FOV = 50
ITEM.NoCenter = true
ITEM.Weight = 10

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 80

ITEM.EquipTime = 5
ITEM.UnEquipTime = 5
ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "chest"
ITEM.CanStack = false
ITEM.IsVest = true

function ITEM:CanEquip(ply)
	if ply:GetModel():find("conscripts") then return true end
	if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU then
		if ply.IsARebel or ply:GetBodygroup(2) == 26 or (ply:GetBodygroup(2) >= 7 and ply:GetBodygroup(2) <= 12) then
			return true
		end
	end
end

function ITEM:OnEquip(ply)
    ply.HasConscriptArmor = true
    ply.FlashSafe = true
    ply.GasSafe = true
    ply.PreConscriptModel = ply:GetModel()
    ply.PreConscriptBodygroups = {}
    for i = 0, ply:GetNumBodyGroups()-1 do
        ply.PreConscriptBodygroups[i] = ply:GetBodygroup(i)
    end

    local model = ply:GetModel()
    local newModel = model:gsub("wnpm_citizens/", "willardnetworks/conscripts/")
    ply:SetModel(newModel)

    local isFemale = newModel:find("female")
	ply:SetBodygroup(1, 3)  -- headwear
	ply:SetBodygroup(2, 3)  -- torso
	ply:SetBodygroup(3, 1)  -- legs
	ply:SetBodygroup(5, 1)  -- hands
	ply:SetBodygroup(7, 0)	-- patch
	ply:SetBodygroup(8, 0)  -- glasses
	ply:SetBodygroup(9, 1)  -- face

	if not isFemale then
	    ply:SetBodygroup(11, 0) -- beard
	end
end

function ITEM:UnEquip(ply)
    ply.HasConscriptArmor = false
    ply.FlashSafe = false
    ply.GasSafe = false
    if ply.PreConscriptModel then
        ply:SetModel(ply.PreConscriptModel)
        ply.PreConscriptModel = nil
    end

    if ply.PreConscriptBodygroups then
        for i, v in pairs(ply.PreConscriptBodygroups) do
            ply:SetBodygroup(i, v)
        end
        ply.PreConscriptBodygroups = nil
    end
end

impulse.RegisterItem(ITEM)