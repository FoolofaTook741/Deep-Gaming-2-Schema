local ITEM = {}

ITEM.UniqueID = "clo_cphelmet"
ITEM.Name = "Civil Protection Mask"
ITEM.Desc =  "Your regular Civil Protection masked assigned to every unit."
ITEM.Category = "Clothing Items - Accessories"
ITEM.Model = Model("models/wn7new/metropolice/n7_cp_gasmask1.mdl")
ITEM.FOV = 12.213467048711
ITEM.CamPos = Vector(46.418338775635, 20.630373001099, 32.091690063477)
ITEM.NoCenter = true
ITEM.Weight = 0.2

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "pants"
ITEM.CanStack = true   

function ITEM:CanEquip(ply)
	return ply:Team() == TEAM_CP and not ply.IsAugmented and not ply.IsRogue
end

function ITEM:OnEquip(ply)
    if ply:GetTeamRank() >= RANK_DCO then
        ply:SetBodygroup(3, 3)
    elseif ply:GetTeamClass() == CLASS_SWORD then
        ply:SetBodygroup(3, 2)
    else
        ply:SetBodygroup(3, 1)
    end
    ply.HasCPMask = true
    ply:SetBodygroup(ply:FindBodygroupByName("beard"), 0)
    ply:SetBodygroup(ply:FindBodygroupByName("hair"), 15)
end

function ITEM:UnEquip(ply)
	ply:SetBodygroup(3, 0)
    ply.HasCPMask = false
    ply:SetBodygroup(ply:FindBodygroupByName("beard"), ply.impulseData.beard or 0)
    ply:SetBodygroup(ply:FindBodygroupByName("hair"), ply.impulseData.hair or 0)
end

impulse.RegisterItem(ITEM)
