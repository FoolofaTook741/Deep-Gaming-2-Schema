local ITEM = {}

-- currently unobtainable (conversion kits removed)
ITEM.UniqueID = "wep_rsass"
ITEM.Name = "R11 RSASS (Silenced)"
ITEM.Desc =  "The R11 RSASS is a modern semi-automatic sniper system designed by Remington Arms for long range target disposal."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/RSASummit/w_snip_sg550.mdl")
ITEM.FOV = 11.396848137536
ITEM.CamPos = Vector(52.722061157227, -100, 1.1461317539215)
ITEM.Weight = 9
ITEM.Colour = Color(0, 150, 0)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 15
ITEM.EquipTime = 4
ITEM.UnEquipTime = 4

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = true

ITEM.WeaponClass = "plutonic_rsass"





function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end


impulse.RegisterItem(ITEM)
