local ITEM = {}

ITEM.UniqueID = "item_jammer"
ITEM.Name = "Signal Jammer"
ITEM.Desc =  "An electronic device configured to obstruct comms taps and biosignal locations of anyone nearby."
ITEM.Category = "Tools"
ITEM.Model = Model("models/bo/weapons/signal jammer.mdl")
ITEM.FOV = 32.379656160458
ITEM.CamPos = Vector(-57.306591033936, -25.21489906311, 8.5959882736206)
ITEM.NoCenter = true
ITEM.Weight = 2.5

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Deploy"
ITEM.UseWorkBarTime = 3
ITEM.UseWorkBarName = "Deploying..."
ITEM.UseWorkBarFreeze = true

function ITEM:CanUse(ply)
	if ply:Team() == TEAM_CITIZEN then
	    return true
    end
end

function ITEM:OnUse(ply)

	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 85
	trace.filter = ply

    local tr = util.TraceLine(trace)

	for k,v in pairs(ents.FindByClass("deep_signaljammer")) do
		if v:CPPIGetOwner() == ply then
			v:Remove()
		end
	end

	local motionsensor = ents.Create("deep_signaljammer")
	motionsensor:SetModel("models/bo/weapons/signal jammer.mdl")
	motionsensor:SetPos(tr.HitPos)
	motionsensor:SetAngles(ply:GetAngles())
	motionsensor:Spawn()
	motionsensor:CPPISetOwner(ply)

	ply:Notify("You have deployed a signal jammer.")
	return true
end

impulse.RegisterItem(ITEM)
