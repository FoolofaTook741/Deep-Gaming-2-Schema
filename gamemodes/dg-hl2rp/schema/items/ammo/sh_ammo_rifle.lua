game.AddAmmoType({
	name = "Rifle",
	dmgtype = DMG_BULLET,
	tracer = TRACER_LINE_AND_WHIZ,
	force = 5000,
	minsplash = 10,
	maxsplash = 100
})

local ITEM = {}

ITEM.UniqueID = "ammo_rifle"
ITEM.Name = "Rifle Ammunition"
ITEM.Desc =  "A box full of large rounds that can penetrate armour, commonly used in heavier weapons."
ITEM.Category = "Ammo"
ITEM.Model = Model("models/kali/weapons/m60 ammo box.mdl")
ITEM.FOV = 18.988538681948
ITEM.CamPos = Vector(-10.888252258301, 26.934097290039, 16.618911743164)
ITEM.NoCenter = true
ITEM.Weight = 0.3

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.UseName = "Load"

local AmmoAmount = 60
local AmmoType = "Rifle"
ITEM.ConfiscateReward = 3

function ITEM:OnUse(ply)
	ply:GiveAmmo(60, "Rifle")
	ply:GiveInventoryItem("empty"..ITEM.UniqueID)
	return true
end

impulse.RegisterItem(ITEM)


EMPTYBOX = {} 

EMPTYBOX.UniqueID = "empty"..ITEM.UniqueID
EMPTYBOX.Name = "Empty "..AmmoType.." Ammunition Box"
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