local ITEM = {}

ITEM.UniqueID = "ammo_ar2"
ITEM.Name = "AR2 Ammunition"
ITEM.Desc =  "A cartridge for use in the AR-2 pulse rifle."
ITEM.Category = "Ammo"
ITEM.Model = Model("models/Items/BoxMRounds.mdl")
ITEM.FOV = 47.600286532951
ITEM.CamPos = Vector(25.67335319519, 25, 9)
ITEM.NoCenter = true
ITEM.Weight = 0.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.UseName = "Load"
ITEM.ConfiscateReward = 5

local AmmoAmount = 75
local AmmoType = "AR2"

function ITEM:OnUse(ply)
	ply:GiveAmmo(75, "AR2")
	ply:GiveInventoryItem("empty"..ITEM.UniqueID)
	return true
end

impulse.RegisterItem(ITEM)


EMPTYBOX = {} 

EMPTYBOX.UniqueID = "empty"..ITEM.UniqueID
EMPTYBOX.Name = "Empty "..AmmoType.." Cartridge"
EMPTYBOX.Desc = "An empty container, made to fit ".. tostring(AmmoAmount) .." rounds of ".. AmmoType .." ammunition."
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
EMPTYBOX.DropOnDeath = true
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