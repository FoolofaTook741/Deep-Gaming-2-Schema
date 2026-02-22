local ITEM = {}

ITEM.UniqueID = "item_hairdye"
ITEM.Name = "Hair Dye"
ITEM.Desc =  "A bucket of hair dye."
ITEM.Model = Model("models/props_junk/metal_paintcan001a.mdl")
ITEM.FOV = 38.644699140401
ITEM.CamPos = Vector(0, 25, 18.91117477417)
ITEM.NoCenter = true
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = false

ITEM.UseName = "Dye hair"
ITEM.UseWorkBarTime = 1
ITEM.UseWorkBarName = "Dyeing hair..."

function ITEM:OnUse(ply)
    net.Start("impulse.HairDye")
    net.Send(ply)

    return false
end

impulse.RegisterItem(ITEM)
