local ITEM = {}

ITEM.UniqueID = "ammo_buckshot"
ITEM.Name = "Buckshot Ammunition"
ITEM.Desc =  "A box contaning large buckshot rounds. Can be loaded into most shotguns."
ITEM.Category = "Ammo"
ITEM.Model = Model("models/items/boxbuckshot.mdl")
ITEM.FOV = 39.434097421203
ITEM.CamPos = Vector(-10.315186500549, 21.203437805176, 10.315186500549)
ITEM.NoCenter = true
ITEM.Weight = 0.4

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.UseName = "Load"
ITEM.ConfiscateReward = 3

local AmmoAmount = 18
local AmmoType = "Buckshot"

function ITEM:OnUse(ply)
	ply:GiveAmmo(18, "Buckshot")
	ply:GiveInventoryItem("empty"..ITEM.UniqueID)
	return true
end

impulse.RegisterItem(ITEM)



EMPTYBOX = {} 

EMPTYBOX.UniqueID = "empty"..ITEM.UniqueID
EMPTYBOX.Name = "Empty "..AmmoType.." Box"
EMPTYBOX.Desc = "An empty container, made to fit ".. tostring(AmmoAmount) .." rounds of ".. AmmoType .." ammunition."
EMPTYBOX.Category = "EmptyAmmo"
EMPTYBOX.Illegal = true
EMPTYBOX.Weight = 0
EMPTYBOX.Model = ITEM.Model
EMPTYBOX.ConfiscateReward = 1

EMPTYBOX.FOV = ITEM.FOV
EMPTYBOX.CamPos = ITEM.CamPos
EMPTYBOX.NoCenter = ITEM.NoCenter

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
	else
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