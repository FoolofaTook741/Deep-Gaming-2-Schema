local ITEM = {}

ITEM.UniqueID = "item_hcdomestication"
ITEM.Name = "Domestication Serum"
ITEM.Desc =  "Used to domesticate headcrabs in containment. The headcrab must be contained in a specimen crate."
ITEM.Category = "ICT"
ITEM.Model = Model("models/props_c17/trappropeller_lever.mdl")
ITEM.FOV = 5
ITEM.CamPos = Vector(100, 100, 0)
ITEM.NoCenter = true
ITEM.Material = "phoenix_storms/wire/pcb_blue"
ITEM.Weight = 0.5

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Domesticate"
ITEM.UseWorkBarTime = 5
ITEM.UseWorkBarName = "Domesticating..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "items/smallmedkit1.wav"

function ITEM:OnUse(ply)
	if ply:HasInventoryItem("item_headcrabcrate") then
		ply:TakeInventoryItemClass("item_headcrabcrate")
		ply:GiveInventoryItem("item_domesticatedheadcrab")
		ply:Notify("You have successfully domesticated this headcrab.")
		return true
	else
		ply:Notify("You must have a headcrab in a specimen crate to use this item.")
		return false
	end
end

impulse.RegisterItem(ITEM)
