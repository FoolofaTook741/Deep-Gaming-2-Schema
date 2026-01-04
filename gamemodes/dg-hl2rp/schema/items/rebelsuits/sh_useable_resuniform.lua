local ITEM = {}

ITEM.UniqueID = "useable_resuniform"
ITEM.Name = "Rebel Uniform"
ITEM.Desc =  "Used for deep cover infiltration into enemy territory. Once equipped it cannot be taken off. It's heavy for balancing purposes."
ITEM.Category = "Clothing"
ITEM.Model = Model("models/willardnetworks/clothingitems/torso_rebel_torso_2.mdl")
ITEM.FOV = 30.303724928367
ITEM.CamPos = Vector(35.1690540313721, 35.002865791321, 2)
ITEM.Weight = 15.0

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 5

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.UseName = "Equip [Single Use]"
ITEM.UseWorkBarTime = 6
ITEM.UseWorkBarName = "Wearing..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "cloth"

function ITEM:OnUse(ply)
	if ply:Team() == TEAM_CITIZEN then
        ply:Say("/me puts on a rebel outfit.")
        ply:SetBodygroup(2,8)
        ply:EmitSound("physics/cardboard/cardboard_box_impact_bullet2.wav")
        ply.IsARebel = true
        return true
    end
end

impulse.RegisterItem(ITEM)