local ITEM = {}

ITEM.UniqueID = "resin_ak47"
ITEM.Name = "AK-47 (Modified)"
ITEM.Desc =  "A cheap yet reliable high powered rifle for medium range combat. Kicks as hard as it hits."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_akm_inss.mdl")
ITEM.FOV = 6.6332378223496
ITEM.CamPos = Vector(160, -160, -15.128939628601)
ITEM.NoCenter = true
ITEM.Weight = 5
ITEM.Colour = Color(180, 180, 0)

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 20

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true

ITEM.WeaponClass = "plutonic_resin_ak47"





function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
