local ITEM = {}

ITEM.UniqueID = "wep_m60"
ITEM.Name = "M60 Machine Gun"
ITEM.Desc =  "A powerful machine gun wielded by the United States army. This weapon serves as the warhorse of all armored vehicles acting as a support gun."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_dm60.mdl")
ITEM.Mass = 1
ITEM.FOV = 20.75787965616
ITEM.CamPos = Vector(100, 91.690544128418, 100)
ITEM.Weight = 12

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 35

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true
ITEM.EquipTime = 4
ITEM.UnEquipTime = 4


ITEM.WeaponClass = "plutonic_m60"





function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
