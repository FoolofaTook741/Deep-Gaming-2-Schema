local ITEM = {}

ITEM.UniqueID = "wep_mp7a8"
ITEM.Name = "H&K MP7A8"
ITEM.Desc =  "A modified MP7 distributed to the members of the SWORD division of the Metro Police Force."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/tfa_misc/w_combine_smg.mdl")
ITEM.FOV = 6.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 3

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.ScrapClass = "scrap_mp7a8"

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 35

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true
ITEM.EquipTime = 2
ITEM.UnEquipTime = 2

ITEM.WeaponClass = "plutonic_mp7a8"





function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
