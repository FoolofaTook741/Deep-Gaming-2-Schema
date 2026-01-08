local ITEM = {}

ITEM.UniqueID = "wep_ptrs41"
ITEM.Name = "PTRS-41"
ITEM.Desc =  "The PTRS-41 is a Soviet World War 2 era anti-tank rifle. By design it fires powerful munitions to penetrate modern vehicular armor and mechanized vehicles. This weapon could easily do significant damage to both vehicles and soldiers."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_grub_ptrs.mdl")
ITEM.FOV = 13.65329512894
ITEM.CamPos = Vector(-68.767906188965, 160, 71.862464904785)
ITEM.Weight = 11

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 50

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = false
ITEM.EquipTime = 4
ITEM.UnEquipTime = 4

ITEM.WeaponClass = "plutonic_ptrs"





function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
