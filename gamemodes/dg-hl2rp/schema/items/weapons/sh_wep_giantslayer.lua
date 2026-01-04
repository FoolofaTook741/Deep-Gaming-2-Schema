local ITEM = {}

ITEM.UniqueID = "wep_giantslayer"
ITEM.Name = "The Giant Slayer"
ITEM.Desc = "A powerful sword once weilded by great men, this weapon does 10 + 25% maximum health damage per hit. Meaning targets with more health will take more damage."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/knife_stiletto/w_stiletto.mdl")
ITEM.Colour = Color(255, 150, 0)
ITEM.FOV = 10.462750716332
ITEM.CamPos = Vector(-12.607449531555, 15.472779273987, 61.318050384521)
ITEM.Weight = 2

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "melee"
ITEM.CanStack = true

ITEM.EquipTime = 1
ITEM.UnEquipTime = 1

ITEM.WeaponClass = "plutonic_greatsword"

function ITEM:OnEquip(ply)
    ply:Say("/me equips an " .. ITEM.Name .. ".")
end

function ITEM:UnEquip(ply)
	ply:Say("/me unequips an " .. ITEM.Name .. ".")
end


impulse.RegisterItem(ITEM)
