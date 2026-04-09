local ITEM = {}

ITEM.UniqueID = "wep_ar2e_eq"
ITEM.Name = "O.S.I.P.R. MK. II-E (Unlinked) DEPRECATED"
ITEM.Desc =  "This variant of the Mark 2 Pulse Rifle is given to units that have completed elite grade augmentation. It fires more quickly and allows the user to install the pulse orb launcher attachment."
ITEM.Colour = Color(75, 0, 0)
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_irifle.mdl")
ITEM.FOV = 46.239255014327
ITEM.CamPos = Vector(32.664756774902, -19.484241485596, 9.1690540313721)
ITEM.NoCenter = true
ITEM.Weight = 0

ITEM.ScrapClass = "scrap_ar2e"

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 80

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true

ITEM.WeaponClass = "plutonic_xar2e"
ITEM.CombineWeapon = false

ITEM.EquipTime = 3
ITEM.UnEquipTime = 3

ITEM.UseName = "Convert to AR2"
function ITEM:OnUse(ply)
	ply:GiveInventoryItem("wep_ar2", 1)
	return true
end

--[[
function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end ]]--

impulse.RegisterItem(ITEM)