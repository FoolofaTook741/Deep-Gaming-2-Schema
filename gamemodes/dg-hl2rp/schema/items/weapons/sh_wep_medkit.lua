local ITEM = {}

ITEM.UniqueID = "wep_medkit"
ITEM.Name = "First Aid Kit"
ITEM.Desc = "A large first aid kit with several pouches. Capable of healing the worst wounds."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/warz/items/medkit.mdl")
ITEM.FOV = 17.6
ITEM.CamPos = Vector(52.148998260498, 25, 9)
ITEM.Weight = 4
 
ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.CanStack = true

function ITEM:OnUse(ply)
	if ply:HasWeapon("plutonic_medkit") then
		ply:Notify("You are already carrying a medkit!")
		return false
	end
	ply:Give("plutonic_medkit")
	return true
end

impulse.RegisterItem(ITEM)
