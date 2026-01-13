local ITEM = {}

ITEM.UniqueID = "ammo_deagle"
ITEM.Name = ".50 AE Ammunition"
ITEM.Desc =  "Large, powerful ammunition that can be loaded into the Desert Eagle."
ITEM.Category = "Ammo"
ITEM.Model = Model("models/props_lab/box01a.mdl")
ITEM.FOV = 11.396848137536
ITEM.CamPos = Vector(-24.068767547607, 59.025787353516, 20.630373001099)
ITEM.NoCenter = true
ITEM.Weight = 0.3

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 3

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.UseName = "Load"

local AmmoAmount = 12
local AmmoType = "AirboatGun"

function ITEM:OnUse(ply)
	ply:GiveAmmo(AmmoAmount, AmmoType)
	ply:GiveInventoryItem("empty"..ITEM.UniqueID)
	return true
end

impulse.RegisterItem(ITEM)


--[[
	Hey! You found my empty ammo box code! Literally just slap this chunk of code into any
	existing ammobox item file and it'll work like a charm. Just remember, you need to specify
	these two variables, else the EMPTYBOX won't work.

	local AmmoAmount = 12
	local AmmoType = "357"

	AmmoAmount is the amount given to the player on use.
	AmmoType is the ID for the ammo, you can find this in the ply:GiveAmmo() function.

 	You also need to give the player the empty ammo box item, but as seen on ln 26 it's simple
	as adding "empty" to the original item's UniqueID. Sorry for the massive word dump.


	If you need any help with this, please reach out to dyln (mage.tearz).
]]
EMPTYBOX = {} 

EMPTYBOX.UniqueID = "empty"..ITEM.UniqueID
EMPTYBOX.Name = "Empty "..AmmoType.." Box"
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