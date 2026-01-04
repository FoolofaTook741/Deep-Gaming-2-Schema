local ITEM = {}

ITEM.UniqueID = "item_armorrepairkit"
ITEM.Name = "Armor Repair Kit"
ITEM.Desc =  "Can be used to fully repair your bodypack one time, this takes a significant amount of time and locks you in place."
ITEM.Category = "Medical"
ITEM.Model = Model("models/Items/battery.mdl")
ITEM.FOV = 5
ITEM.CamPos = Vector(100, 100, 0)
ITEM.NoCenter = true
ITEM.Weight = 2.5

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Repair"
ITEM.UseWorkBarTime = 4
ITEM.UseWorkBarName = "Repairing..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = ""

function ITEM:CanUse(ply)
    if ply:Team() == TEAM_OTA then
        return true
    else
        return false
    end
end

function ITEM:OnUse(ply, target)
    if ply:Team() == TEAM_OTA then
        if ply:GetTeamClass() == CLASS_PAYBACK then
            ply:SetArmor(math.Clamp(ply:Armor() + math.floor(ply:GetMaxArmor()/2), 0, ply:GetMaxArmor()))
            ply:EmitSound("items/battery_pickup.wav")
        else
            ply:SetArmor(ply:GetMaxArmor())
            ply:EmitSound("items/battery_pickup.wav")
        end
	    return true
    else
        return false
    end
end

impulse.RegisterItem(ITEM)
