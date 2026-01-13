local ITEM = {}

ITEM.UniqueID = "item_grenade"
ITEM.Name = "Frag Grenade"
ITEM.Desc =  "A small grenade that fragments around the area of detonation."
ITEM.Category = "Grenades"
ITEM.Model = Model("models/Items/grenadeAmmo.mdl")
ITEM.FOV = 16.179083094556
ITEM.CamPos = Vector(-13.753582000732, 36.676216125488, 17.191976547241)
ITEM.NoCenter = true
ITEM.Weight = 2.0

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.UseName = "Equip [Single Use]"

function ITEM:CanUse(ply)
	if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU then
	    return true
    end
end	

function ITEM:OnUse(ply)
	ply:Give("weapon_frag")
	return true
end

impulse.RegisterItem(ITEM)
