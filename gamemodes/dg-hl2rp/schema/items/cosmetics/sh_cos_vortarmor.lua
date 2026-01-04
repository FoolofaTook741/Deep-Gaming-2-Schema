local ITEM = {}

ITEM.UniqueID = "cos_vortarmor"
ITEM.Name = "Vortigaunt Armor"
ITEM.Desc =  "Single use, reinforced plastic modeled after antlion guard skin armor that gives you protection against 33% of incoming attacks."
ITEM.Category = "Clothing"
ITEM.Model = Model("models/n7/vorti_outfit/armor.mdl")
ITEM.FOV = 40.929799426934
ITEM.CamPos = Vector(33.237823486328, 25, 9)
ITEM.Weight = 4.0

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 15

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.UseName = "Equip"
ITEM.UseWorkBarTime = 3
ITEM.UseWorkBarName = "Wearing..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "cloth"

function ITEM:OnUse(ply)
    if ply:Team() == TEAM_VORT && ply:GetBodygroup(8) != 1 && ply.HasVortArmor != true then
	    ply:SetBodygroup(1, 8)
	    ply.HasVortArmor = true
	    ply:Notify("You have put on the vortigaunt armor.")
		return true
    elseif ply.HasVortArmor == true then
        ply:SetBodygroup(1,0)
        ply.HasVortArmor = false
        ply:Notify("You have taken off the vortigaunt armor.")
		return false
    else
        ply:Notify("You cannot use this item.")
        return false
    end
end

impulse.RegisterItem(ITEM)