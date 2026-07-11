local ITEM = {}

ITEM.UniqueID = "item_portablehpcharger"
ITEM.Name = "Portable Biogel Injection Station"
ITEM.Desc =  "Deploy a biogel injection station to your hardpoint for your teammates to use."
ITEM.Category = "Combine Tools"
ITEM.Model = Model("models/dg_models/dg_combine_props/vnl/health_charger002.mdl")

ITEM.FOV = 13.372492836676
ITEM.CamPos = Vector(143.95414733887, -20.171918869019, 93.524353027344)
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Deploy"
ITEM.UseWorkBarTime = 6
ITEM.UseWorkBarName = "Deploying..."
ITEM.UseWorkBarFreeze = true

function ITEM:OnUse(ply)
	local pos = ply:GetPos()

	for k,v in pairs(ents.FindByClass("deep_portablehpcharger")) do
		if v:GetOwner() == ply then
        	v:Remove()
		end
    end

    local charger = ents.Create("deep_portablehpcharger")
	charger:SetModel("models/Items/HealthKit.mdl")
    charger:CPPISetOwner(ply)
	charger:SetPos(pos + Vector(0, 50, 0))
	charger:Spawn()
	ply:Notify("You have deployed a Portable Biogel Injection Station.")
	return true
end

impulse.RegisterItem(ITEM)



