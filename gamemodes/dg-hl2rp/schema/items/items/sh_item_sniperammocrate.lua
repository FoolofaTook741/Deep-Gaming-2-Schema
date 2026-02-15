local ITEM = {}

ITEM.UniqueID = "item_sniperammocrate"
ITEM.Name = "Sniper Ammo Crate"
ITEM.Desc =  "A crate containing boxes of Sniper Ammo."
ITEM.Category = "Ammo"
ITEM.Model = Model("models/Items/item_item_crate.mdl")
ITEM.FOV = 60.379656160458
ITEM.CamPos = Vector(-57.306591033936, -25.21489906311, 8.5959882736206)
ITEM.NoCenter = true
ITEM.Weight = 1.2

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Unpack"
ITEM.UseWorkBarTime = 6
ITEM.UseWorkBarName = "Unpacking Ammo.."
ITEM.UseWorkBarFreeze = true

function ITEM:OnUse(ply)
    for i = 1, 5 do
        ply:GiveInventoryItem("ammo_sniper")
    end
	return true
end

impulse.RegisterItem(ITEM)

