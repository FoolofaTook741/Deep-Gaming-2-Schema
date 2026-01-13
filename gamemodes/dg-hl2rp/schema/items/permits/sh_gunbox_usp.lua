local ITEM = {}

ITEM.UniqueID = "gunbox_usp"
ITEM.Name = "H&K USP Gun Box"
ITEM.Desc =  "A box distributed by the OCA for lawful concealed carry."
ITEM.Category = "Permits"
ITEM.Model = Model("models/props/de_prodigy/ammo_can_02.mdl")
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
    if ply:IsCP() or ply:Team() == TEAM_VORT then
        ply:Notify("You cannot use this on your current team.")
        return
    end
    ply:GiveInventoryItem("wep_pistol", 1)

    ply:Notify("You have opened the gun box.")
	return true
end

impulse.RegisterItem(ITEM)
