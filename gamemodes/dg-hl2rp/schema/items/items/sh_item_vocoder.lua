local ITEM = {}

ITEM.UniqueID = "item_vocoder"
ITEM.Name = "Combine Vocoder"
ITEM.Desc =  "A small device that allows you to guise your voice as something else. This will add an effect to your voice, it is recommended to make your own since this one is very basic, but this is an option for those who don't want to."
ITEM.Category = "Tools"
ITEM.Model = Model("models/bo/weapons/radio.mdl")
ITEM.FOV = 15.338108882521
ITEM.CamPos = Vector(-10, 25, 9)
ITEM.Weight = 0
ITEM.ConfiscateReward = 5

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "radio"
ITEM.CanStack = true   

function ITEM:CanEquip(ply)
	return ply:Team() == TEAM_CP or ply:Team() == TEAM_OTA
end

function ITEM:OnEquip(ply)
    ply:AddVoiceFX("Combine")
    ply:Notify("Vocoder engaged.")
end

function ITEM:UnEquip(ply)
	ply:RemoveVoiceFX("Combine")
    ply:Notify("Vocoder removed.")
end


impulse.RegisterItem(ITEM)
