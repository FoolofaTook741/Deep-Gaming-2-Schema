local ITEM = {}

ITEM.UniqueID = "wep_mosin"
ITEM.Name = "Mosin Nagant"
ITEM.Desc =  "The Mosin Nagant rifle, originating from Imperial Russia, is a rugged bolt-action firearm chambered in 7.62x54mmR. Remains a symbol of reliability and power."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_grub_mosin.mdl")
ITEM.FOV = 10
ITEM.CamPos = Vector(-82, 144, 90)
ITEM.Weight = 9

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 25

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true
ITEM.EquipTime = 3
ITEM.UnEquipTime = 3

ITEM.WeaponClass = "plutonic_mosin"





function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
