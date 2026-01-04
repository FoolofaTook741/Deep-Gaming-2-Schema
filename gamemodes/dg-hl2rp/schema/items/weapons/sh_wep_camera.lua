local ITEM = {}

ITEM.UniqueID = "wep_camera"
ITEM.Name = "Broadcast Camera"
ITEM.Desc =  "The broadcast camera transmits silent images to televisions across the city."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/dav0r/camera.mdl")
ITEM.FOV = 12.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "cam"
ITEM.CanStack = false

ITEM.WeaponClass = "rt_camswep"

function ITEM:OnEquip(ply)
    ply:Say("/me equips a " .. ITEM.Name .. ".")
end

function ITEM:UnEquip(ply)
	ply:Say("/me unequips a " .. ITEM.Name .. ".")
end


impulse.RegisterItem(ITEM)
