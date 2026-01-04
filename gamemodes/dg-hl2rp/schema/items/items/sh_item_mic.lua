local ITEM = {}

ITEM.UniqueID = "item_microphone"
ITEM.Name = "Microphone"
ITEM.Desc =  "A small little microphone that'll make your voice sound like you're speaking through a speaker."
ITEM.Category = "Tools"
ITEM.Model = Model("models/props_se/propper/power_audio_microphone.mdl")
ITEM.FOV = 15.338108882521
ITEM.CamPos = Vector(-10, 25, 9)
ITEM.Weight = 0
ITEM.ConfiscateReward = 5

ITEM.Droppable = false
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "radio"
ITEM.CanStack = false   

function ITEM:CanEquip(ply)
    return ply:Team() == TEAM_CA and ply:GetTeamClass() >= CLASS_REPRESENTATIVE
end

function ITEM:OnEquip(ply)
    ply:AddVoiceFX("Public Address System") -- i dunno if this is the right ID but gg
    ply:Notify("Microphone enabled.")
end

function ITEM:UnEquip(ply)
	ply:RemoveVoiceFX("Public Address System")
    ply:Notify("Microphone Disabled.")
end


impulse.RegisterItem(ITEM)