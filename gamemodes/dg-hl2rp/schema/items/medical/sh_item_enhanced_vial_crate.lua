local ITEM = {}

ITEM.UniqueID = "item_enhancedvialcrate"
ITEM.Name = "Enhanced Health Vials Crate"
ITEM.Desc =  "A box of Enhanced Health Vials."
ITEM.Category = "Medical"
ITEM.Model = Model("models/hls/alyxports/cardboard_box_1.mdl")
ITEM.FOV = 60.379656160458
ITEM.CamPos = Vector(-57.306591033936, -25.21489906311, 8.5959882736206)
ITEM.NoCenter = true
ITEM.Weight = .9
ITEM.CraftTime = 1

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Unpack"
ITEM.UseWorkBarTime = 4
ITEM.UseWorkBarName = "Unpacking Vials.."
ITEM.UseWorkBarFreeze = true

function ITEM:OnUse(ply)
    for i = 1, 3 do
        ply:GiveInventoryItem("item_enhancedvial")
    end
	return true
end

impulse.RegisterItem(ITEM)

