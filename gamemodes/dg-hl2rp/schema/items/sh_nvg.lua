local ITEM = {}

ITEM.UniqueID = "util_nvgs"
ITEM.Name = "Night Vision Goggles"
ITEM.Desc =  "A useful tool to see in the Dark."
ITEM.Category = "Equipment"
ITEM.Model = Model("models/props_lab/tpplug.mdl")
ITEM.FOV = 17.113180515759
ITEM.CamPos = Vector(-25.21489906311, 34.957019805908, 0.57306587696075)
ITEM.NoCenter = true

ITEM.Weight = 0

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 10

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "headgear"
ITEM.CanStack = false

function ITEM:CanEquip(ply)
	return ply:Team() ~= TEAM_VORT
end

function ITEM:OnEquip(ply)
    ply:Say("/me equips " .. ITEM.Name .. ".")
    if ply:FlashlightIsOn() then
        ply:Flashlight()
    end
    ply:SetNWBool("IsNVGEquipped", true)
end

function ITEM:UnEquip(ply)
	ply:Say("/me unequips " .. ITEM.Name .. ".")
    if ply.DynamicFlashlight then
        ply.DynamicFlashlight:Remove()
        ply.DynamicFlashlight = nil
        LocalPlayer():EmitSound( "ez2/nvg/nvg_off.wav", SNDLVL_NORM)
    end
    ply:SetNWBool("DynamicFlashlight", false)

    ply:SetNWBool("IsNVGEquipped", false)
end

impulse.RegisterItem(ITEM)
