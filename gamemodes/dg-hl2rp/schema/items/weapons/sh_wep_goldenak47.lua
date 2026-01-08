local ITEM = {}

ITEM.UniqueID = "wep_goldenak47"
ITEM.Name = "Golden AK-47"
ITEM.Desc =  "A cheap yet reliable high powered rifle for medium range combat. Kicks as hard as it hits. This one is covered in gold."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_akm_inss.mdl")
ITEM.Material = "gold_tool/australium"
ITEM.FOV = 6.6332378223496
ITEM.CamPos = Vector(160, -160, -15.128939628601)
ITEM.Colour = Color(255, 255, 0)
ITEM.NoCenter = true
ITEM.Weight = 7.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 120

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true

ITEM.EquipTime = 3
ITEM.UnEquipTime = 3

ITEM.WeaponClass = "plutonic_goldenak47"





function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
