local ITEM = {}

ITEM.UniqueID = "toolbox_pickaxe"
ITEM.Name = "Toolbox (Pickaxe)"
ITEM.Desc =  "A toolbox containing an axe for lawful loyalist/CW mining."
ITEM.Category = "Permits"
ITEM.Model = Model("models/Items/item_item_crate.mdl")
ITEM.FOV = 90
ITEM.Weight = 2

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Unpack"
ITEM.UseWorkBarTime = 2
ITEM.UseWorkBarName = "Opening..."
ITEM.UseWorkBarSound = "impulse/bone2.wav"

function ITEM:CanUse(ply)
    if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU then
        return true
    else
        return false
    end
end

function ITEM:OnUse(ply)
    ply:GiveInventoryItem("wep_pickaxe", 1)

    ply:Notify("You have opened the toolbox.")
	return true
end

impulse.RegisterItem(ITEM)
