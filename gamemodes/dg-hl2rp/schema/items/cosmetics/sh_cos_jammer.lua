local ITEM = {}

ITEM.UniqueID = "cos_portablejammer"
ITEM.Name = "Portable Signal Jammer"
ITEM.Desc =  "A smaller jammer used for mobility, but has a smaller range."
ITEM.Category = "Tools"
ITEM.Model = Model("models/bo/weapons/signal jammer.mdl")
ITEM.FOV = 50
ITEM.NoCenter = true
ITEM.Weight = 2

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 10

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "tool"
ITEM.CanStack = true

function ITEM:CanEquip(ply)
	return ply:Team() == TEAM_CITIZEN
end

function ITEM:OnEquip(ply)
	ply:EmitSound("scramble/ui_motiontracker_pong2.wav")
	timer.Create(ply:SteamID() .. "jammerbeeps", 6, 0, function()
		ply:EmitSound("scramble/ui_motiontracker_pong2.wav")
	end)
	ply.IsAJammer = true
end

function ITEM:UnEquip(ply)
	timer.Remove(ply:SteamID().."jammerbeeps")
	ply.IsAJammer = false
end


impulse.RegisterItem(ITEM)
