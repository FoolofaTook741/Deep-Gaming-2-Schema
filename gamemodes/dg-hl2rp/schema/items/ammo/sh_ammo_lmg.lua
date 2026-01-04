local ITEM = {}

ITEM.UniqueID = "ammo_lmg"
ITEM.Name = "Light Machine Gun Ammunition"
ITEM.Desc =  "A box full of extremely large rounds that can penetrate armour, commonly used in heavier weapons."
ITEM.Category = "Ammo"
ITEM.Model = Model("models/Items/item_item_crate.mdl")
ITEM.FOV = 80.600286532951
ITEM.CamPos = Vector(-10.888252258301, 26.934097290039, 16.618911743164)
ITEM.NoCenter = true
ITEM.Weight = 0.7

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.UseName = "Load"
ITEM.ConfiscateReward = 8

local AmmoAmount = 120
local AmmoType = "AlyxGun"

function ITEM:OnUse(ply)
	ply:GiveAmmo(120, "AlyxGun")
	ply:GiveInventoryItem("empty"..ITEM.UniqueID)
	return true
end

impulse.RegisterItem(ITEM)


EMPTYBOX = {} 

EMPTYBOX.UniqueID = "empty"..ITEM.UniqueID
EMPTYBOX.Name = "Empty LMG Ammunition Box"
EMPTYBOX.Desc = "An empty container, made to fit ".. tostring(AmmoAmount) .." rounds of LMG ammunition."
EMPTYBOX.Category = "EmptyAmmo"
EMPTYBOX.Illegal = true
EMPTYBOX.Weight = 0
EMPTYBOX.Model = ITEM.Model

EMPTYBOX.FOV = ITEM.FOV
EMPTYBOX.CamPos = ITEM.CamPos
EMPTYBOX.NoCenter = ITEM.NoCenter
EMPTYBOX.ConfiscateReward = 1

EMPTYBOX.CanStack = true
EMPTYBOX.Droppable = true
EMPTYBOX.DropOnDeath = false
EMPTYBOX.UseName = "Refill"

function EMPTYBOX:CanUse(ply)
	if ply:GetAmmoCount(AmmoType) < AmmoAmount then
		return false
	end

	if (not ply:CanHoldItem(ITEM.UniqueID, 1)) then
		return false
	end

	return true
end

function EMPTYBOX:OnUse(ply)
	if ply:GetAmmoCount(AmmoType) < AmmoAmount then
		return false
	end

	if (not ply:CanHoldItem(ITEM.UniqueID, 1)) then
		return false
	end

	ply:GiveInventoryItem(ITEM.UniqueID)
	ply:RemoveAmmo(AmmoAmount, AmmoType)
	return true
end

impulse.RegisterItem(EMPTYBOX)