local ITEM = {}

ITEM.UniqueID = "util_radioold"
ITEM.Name = "Voice Communication Radio"
ITEM.Desc =  "This is an old radio used to communicate over long distances."
ITEM.Category = "Utilities"
ITEM.Model = Model("models/props_lab/box01a.mdl")
ITEM.FOV = 20.392550143266
ITEM.CamPos = Vector(22.005731582642, 25, 9)
ITEM.Weight = 0.4

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 5

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "tool"
ITEM.CanStack = false


function ITEM:CanEquip(ply)
	return ply:IsCP() and (ply:GetSyncVar(SYNC_SQUAD_LEADER) or ply:GetTeamRank() >= RANK_OFC)
end

function ITEM:OnEquip(ply)
    ply:SetSyncVar(SYNC_RADIO_ACTIVE, true)
    ply:Notify("You have turned on your Command radio.")
end

function ITEM:UnEquip(ply)
    ply:SetSyncVar(SYNC_RADIO_ACTIVE, false)
    ply:Notify("You have turned off your Command radio.")
end

impulse.RegisterItem(ITEM)
