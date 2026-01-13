local ITEM = {}

ITEM.UniqueID = "ammo_sniper"
ITEM.Name = "Sniper Ammunition"
ITEM.Desc =  "Rounds for use in sniper rifles or anti-tank rifles."
ITEM.Category = "Ammo"
ITEM.Model = Model("models/props_junk/cardboard_box004a.mdl")
ITEM.FOV = 11.396848137536
ITEM.CamPos = Vector(-24.068767547607, 59.025787353516, 20.630373001099)
ITEM.NoCenter = true
ITEM.Weight = 0.3

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.UseName = "Load"

local AmmoAmount = 10
local AmmoType = "SniperPenetratedRound"
ITEM.ConfiscateReward = 5

function ITEM:OnUse(ply)
	ply:GiveAmmo(10, "SniperPenetratedRound")
	ply:GiveInventoryItem("empty"..ITEM.UniqueID)
	return true
end

impulse.RegisterItem(ITEM)


EMPTYBOX = {} 

EMPTYBOX.UniqueID = "empty"..ITEM.UniqueID
EMPTYBOX.Name = "Empty 14.5mm AP Box"
EMPTYBOX.Desc = "An empty container, made to fit ".. tostring(AmmoAmount) .." rounds of 14.5mm AP ammunition."
EMPTYBOX.Category = "EmptyAmmo"
EMPTYBOX.Illegal = true
EMPTYBOX.Weight = 0
EMPTYBOX.Model = ITEM.Model

EMPTYBOX.FOV = ITEM.FOV
EMPTYBOX.CamPos = ITEM.CamPos
EMPTYBOX.NoCenter = ITEM.NoCenter

EMPTYBOX.CanStack = true
EMPTYBOX.Droppable = true
EMPTYBOX.DropOnDeath = true
EMPTYBOX.UseName = "Refill"
EMPTYBOX.ConfiscateReward = 1

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