local ITEM = {}

ITEM.UniqueID = "wep_tau"
ITEM.Name = "XVL1456 Tau Particle Accelerator"
ITEM.Desc =  "A powerful experimental weapon designed at the Black Mesa Research facility. It fires powerful beams of depleted Uranium-235."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_gauss_mp.mdl")
ITEM.FOV = 40.113180515759
ITEM.Colour = Color(255,0,0)
ITEM.CamPos = Vector(-25.21489906311, 34.957019805908, 0.57306587696075)
ITEM.NoCenter = true

ITEM.Weight = 9.0

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 150
ITEM.EquipTime = 3
ITEM.UnEquipTime = 3

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true

function ITEM:OnEquip(ply)
    ply:Say("/me equips an " .. ITEM.Name .. ".")
end

function ITEM:UnEquip(ply)
	ply:Say("/me unequips an " .. ITEM.Name .. ".")
end

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

ITEM.WeaponClass = "weapon_taucannon_wal"

impulse.RegisterItem(ITEM)
