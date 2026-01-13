local ITEM = {}

ITEM.UniqueID = "ammo_darkenergy"
ITEM.Name = "AR Energy Orb Ammo"
ITEM.Desc =  "Compact containment cell holding a condensed plasma sphere. Restores one alt-fire charge for the AR2. Handle with care unstable under impact."
ITEM.Category = "Ammo"
ITEM.Model = Model("models/Items/combine_rifle_ammo01.mdl")
ITEM.FOV = 16.461318051576
ITEM.CamPos = Vector(-29.340974807739, -24.756446838379, 34.040115356445)
ITEM.NoCenter = true
ITEM.Weight = 0.3

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.UseName = "Load"

local AmmoAmount = 1
local AmmoType = "DarkEnergy"
ITEM.ConfiscateReward = 3

function ITEM:OnUse(ply)
    local currentAmmo = ply:GetAmmoCount("ar2altfire")
    
    if currentAmmo >= 2 then
        ply:Notify("You are already at maximum AR2 Alt-Fire ammo!")
        return false
    end
    
    ply:GiveAmmo(1, "ar2altfire")
    --ply:GiveInventoryItem("empty"..ITEM.UniqueID)
    return true
end

impulse.RegisterItem(ITEM)