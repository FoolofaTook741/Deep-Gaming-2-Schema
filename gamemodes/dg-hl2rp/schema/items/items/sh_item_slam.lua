local ITEM = {}

ITEM.UniqueID = "item_slam"
ITEM.Name = "S.L.A.M."
ITEM.Desc =  "A proximity mine that explodes once a laser is tripped."
ITEM.Category = "Grenades"
ITEM.Model = Model("models/Items/grenadeAmmo.mdl")
ITEM.FOV = 16.179083094556
ITEM.CamPos = Vector(-13.753582000732, 36.676216125488, 17.191976547241)
ITEM.NoCenter = true
ITEM.Weight = 2.0

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.UseName = "Equip [Single Use]"

function ITEM:CanUse(ply)
	if ply:Team() != TEAM_VORT then
	    return true
    end
end	

function ITEM:OnUse(ply)
	ply:Give("weapon_slam")
	return true
end

impulse.RegisterItem(ITEM)
