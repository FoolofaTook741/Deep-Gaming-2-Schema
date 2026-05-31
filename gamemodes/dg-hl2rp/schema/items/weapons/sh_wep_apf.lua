local ITEM = {}

ITEM.UniqueID = "wep_apf"
ITEM.Name = "O.S.I.A.E.R."
ITEM.Desc =  "The Overwatch Standard Issue Antimatter Enforcement Regulator is a powerful weapon weilded by members of the Antibody Protection Force."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/suppressor/w_suppressor.mdl")
ITEM.FOV = 46.239255014327
ITEM.CamPos = Vector(32.664756774902, -19.484241485596, 9.1690540313721)
ITEM.NoCenter = true
ITEM.Weight = 12

ITEM.ScrapClass = "scrap_apf"

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 40

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true
ITEM.EquipTime = 7
ITEM.UnEquipTime = 7

ITEM.WeaponClass = "plutonic_apfgun"
ITEM.CombineWeapon = true

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

impulse.RegisterItem(ITEM)
