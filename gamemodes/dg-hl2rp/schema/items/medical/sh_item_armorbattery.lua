local ITEM = {}

ITEM.UniqueID = "item_armorbat"
ITEM.Name = "Armor Battery"
ITEM.Desc =  "Can be used to increase armor by 30 one time."
ITEM.Category = "Medical"
ITEM.Model = Model("models/Items/battery.mdl")
ITEM.FOV = 5
ITEM.CamPos = Vector(100, 100, 0)
ITEM.NoCenter = true
ITEM.Weight = 0.5

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Apply"
ITEM.UseWorkBarTime = 1
ITEM.UseWorkBarName = "Applying..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "items/battery_pickup.wav"

function ITEM:OnUse(ply, target)
    if ply:Armor() + 15 <= ply:GetMaxArmor() then
	    ply:SetArmor(ply:Armor() + 15)
        ply:Notify("You have used the armor battery.")
    else
        ply:SetArmor(ply:Armor() + ((ply:GetMaxArmor() + 15) - ply:Armor()))
        ply:Notify("You have used the armor battery.")
    end

	return true
end

impulse.RegisterItem(ITEM)
