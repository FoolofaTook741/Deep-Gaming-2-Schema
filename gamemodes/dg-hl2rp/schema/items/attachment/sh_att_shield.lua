local ITEM = {}

ITEM.UniqueID = "att_assault_shield"
ITEM.Name = "Wallhammer Assault Shield [Experimental]"
ITEM.Desc =  "A high tech shield that blocks incoming (and outgoing) rounds (This is an in progress)."
ITEM.Category = "Attachments"
ITEM.Model = Model("models/props_lab/box01a.mdl")
ITEM.FOV = 20.392550143266
ITEM.CamPos = Vector(22.005731582642, 25, 9)
ITEM.Weight = 0.5

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 5

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary_attachment"
ITEM.CanStack = true

function ITEM:CanEquip(ply)
	return ply:Team() == TEAM_OTA and ply:GetTeamClass() == CLASS_PAYBACK
end

function ITEM:OnEquip(ply)
    ply:EmitSound("pshotgun/wpn_shotgun_foley_close_tube_01.wav")
	ply.ShieldActive = true
end

function ITEM:UnEquip(ply)
    ply:EmitSound("pshotgun/wpn_shotgun_foley_close_chamber_01.wav")
	ply.ShieldActive = false
	if IsValid(ply.shield) then
		ply.shield:Remove()
	end
end


impulse.RegisterItem(ITEM)
