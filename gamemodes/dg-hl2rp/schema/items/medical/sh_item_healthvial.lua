local ITEM = {}

ITEM.UniqueID = "item_healthvial"
ITEM.Name = "Health Vial"
ITEM.Desc =  "Can be used to treat minor injuries or wounds."
ITEM.Category = "Medical"
ITEM.Model = Model("models/healthvial.mdl")
ITEM.FOV = 5
ITEM.CamPos = Vector(100, 100, 0)
ITEM.NoCenter = true
ITEM.Weight = 0.15

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Apply"
ITEM.UseWorkBarTime = 2
ITEM.UseWorkBarName = "Applying..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = ""

function ITEM:OnUse(ply, target)
	ply:SetHealth(math.Clamp(ply:Health() + (math.random(10,15) * (1 - (ply.Antiheal or 0))), 0, ply:GetMaxHealth()))
	
	if ply:HasBrokenLegs() then
		ply:FixLegs()
		ply:Notify("Your broken legs have healed.")
	end

	ply:AddSkillXP("medical", math.random(0,2))

	ply:EmitSound("items/smallmedkit1.wav")

	return true
end

impulse.RegisterItem(ITEM)
