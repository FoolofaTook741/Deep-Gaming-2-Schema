local ITEM = {}

ITEM.UniqueID = "item_mine"
ITEM.Name = "Hopper Mine"
ITEM.Desc =  "Deploy a hopper mine to kill any combatants moving through illegal areas."
ITEM.Category = "Combine Tools"
ITEM.Model = Model("models/props_combine/combine_mine01.mdl")
ITEM.FOV = 60.379656160458
ITEM.CamPos = Vector(-57.306591033936, -25.21489906311, 8.5959882736206)
ITEM.NoCenter = true
ITEM.Weight = 6

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Deploy"
ITEM.UseWorkBarTime = 6
ITEM.UseWorkBarName = "Deploying Hopper Mine..."
ITEM.UseWorkBarFreeze = true

function ITEM:OnUse(ply)
	local pos = ply:GetPos()
	ply:Notify("Mine is deploying, clear the area!")
	timer.Simple(5, function()
		local crate = ents.Create("combine_mine")
		crate:SetModel("models/props_combine/combine_mine01.mdl")
		crate:SetPos(pos)
		crate:Spawn()
		ply:Notify("You have deployed a hopper mine. Note: Mines target all players including C.T.A.")
	end)
	return true
end

impulse.RegisterItem(ITEM)

