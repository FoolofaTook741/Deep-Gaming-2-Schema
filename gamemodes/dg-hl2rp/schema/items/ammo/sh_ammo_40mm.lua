local ITEM = {}

ITEM.UniqueID = "ammo_40mm"
ITEM.Name = "40mm Explosive Round"
ITEM.Desc =  "A large grenade for use in the M320 GL."
ITEM.Category = "Ammo"
ITEM.Model = Model("models/Items/AR2_Grenade.mdl")
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

local AmmoAmount = 1
local AmmoType = "SMG1_Grenade"

function ITEM:OnUse(ply)
	ply:GiveAmmo(AmmoAmount, AmmoType)
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