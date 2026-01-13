local ITEM = {}

ITEM.UniqueID = "item_healthkit"
ITEM.Name = "Health Kit"
ITEM.Desc =  "Can be used to treat major injuries or wounds of other people."
ITEM.Category = "Medical"
ITEM.Model = Model("models/items/healthkit.mdl")
ITEM.FOV = 7.041547277937
ITEM.CamPos = Vector(100, -100, 73.925498962402)
ITEM.NoCenter = true
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Heal player"
ITEM.UseWorkBarTime = 5
ITEM.UseWorkBarName = "Healing..."
ITEM.UseWorkBarFreeze = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false


function ITEM:OnUse(ply, target)
	local maxHealth = target:GetMaxHealth()
	target:SetHealth(math.Clamp(target:Health() + (60 * (1 - (target.Antiheal or 0))), 0, maxHealth))

	target:Notify("You have been healed by "..ply:Nick()..".")
	ply:Notify("You have healed "..target:Nick()..".")

	ply:AddSkillXP("medical", math.random(30,120))

	target:EmitSound("items/smallmedkit1.wav")

	return true
end

function ITEM:ShouldTraceUse(ply, ent)
	if ent:IsPlayer() then
		return true
	end
end

impulse.RegisterItem(ITEM)
