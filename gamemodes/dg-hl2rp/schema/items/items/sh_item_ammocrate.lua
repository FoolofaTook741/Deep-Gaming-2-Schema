local ITEM = {}

ITEM.UniqueID = "item_ammocrate"
ITEM.Name = "Deployable Ammo Crate"
ITEM.Desc =  "Deploy an ammo box for your allies to use, once deployed it cannot be retrived. Allows up to 24 clip refills."
ITEM.Category = "Combine Tools"
ITEM.Model = Model("models/Items/item_item_crate.mdl")
ITEM.FOV = 60.379656160458
ITEM.CamPos = Vector(-57.306591033936, -25.21489906311, 8.5959882736206)
ITEM.NoCenter = true
ITEM.Weight = 3.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Deploy"
ITEM.UseWorkBarTime = 6
ITEM.UseWorkBarName = "Deploying Ammo Crate..."
ITEM.UseWorkBarFreeze = true

function ITEM:OnUse(ply)
	local pos = ply:GetPos()

    local crate = ents.Create("chensammocrate")
	crate:SetModel("models/Items/item_item_crate.mdl")
	crate:SetPos(pos + Vector(0, 50, 0))
	crate:Spawn()
	ply:Notify("You have deployed an ammo crate.")
	return true
end

impulse.RegisterItem(ITEM)

