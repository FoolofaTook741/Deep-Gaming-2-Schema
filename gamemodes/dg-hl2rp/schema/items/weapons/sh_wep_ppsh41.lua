local ITEM = {}

ITEM.UniqueID = "wep_ppsh41"
ITEM.Name = "PPSh-41"
ITEM.Desc =  "The PPSh-41 is a lightweight sub-machine gun chambered in 7.62x25. This Soviet era sub-machine gun prides itself in its service against fascism in the second World War. Surely a fascist killing machine could be repurposed on modern fascists, right?"
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/syndod/w_ppsh1941.mdl")
ITEM.FOV = 12.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 10

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true
ITEM.EquipTime = 2
ITEM.UnEquipTime = 2

ITEM.WeaponClass = "plutonic_ppsh"





function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
