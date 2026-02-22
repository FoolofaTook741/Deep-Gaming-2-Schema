--[[
local ITEM = {}

ITEM.UniqueID = "util_radio"
ITEM.Name = "Voice Communications Radio"
ITEM.Desc =  "A useful tool to communicate with the team."
ITEM.Category = "Equipment"
ITEM.Model = Model("models/radio/w_radio.mdl")
ITEM.FOV = 17.113180515759
ITEM.CamPos = Vector(-25.21489906311, 34.957019805908, 0.57306587696075)
ITEM.NoCenter = true

ITEM.Weight = 0

ITEM.Droppable = true
ITEM.DropOnDeath = false
ITEM.ConfiscateReward = 10

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.UseName = "Toggle"
ITEM.CanStack = false
ITEM.WeaponClass = "weapon_simple_radio"

ITEM.EquipMessage = "/me turns on their radio."
ITEM.UnequipMessage = "/me turns off their radio."

function ITEM:CanEquip(ply)
	return ply:Team() == TEAM_CP or ply:Team() == TEAM_OTA
end

function ITEM:OnEquip(ply)
    ply:Notify("Equip the SWEP and press 'R' to Cycle through the radio's Channels, use the LMB to speak on the channel.")
    ply:SetSyncVar(SYNC_RADIO_LISTEN, true, true)
	ply:SetSyncVar(SYNC_RADIO_CHANNEL, 1, true)
end

function ITEM:UnEquip(ply)
    ply:SetSyncVar(SYNC_RADIO_LISTEN, false, true)
    ply:SetSyncVar(SYNC_RADIO_TALK, false, true)
end

impulse.RegisterItem(ITEM)
--]]