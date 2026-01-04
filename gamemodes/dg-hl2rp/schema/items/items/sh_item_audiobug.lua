local ITEM = {}

ITEM.UniqueID = "item_audiobug"
ITEM.Name = "Audio Bugging Device"
ITEM.Desc =  "An electronic device configured to obstruct comms taps and biosignal locations of anyone nearby."
ITEM.Category = "Combine Tools"
ITEM.Model = Model("models/bo/weapons/tactical beacon.mdl")
ITEM.FOV = 20.379656160458
ITEM.CamPos = Vector(-57.306591033936, -25.21489906311, 8.5959882736206)
ITEM.NoCenter = true
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Deploy"
ITEM.UseWorkBarTime = 3
ITEM.UseWorkBarName = "Deploying..."
ITEM.UseWorkBarFreeze = true

function ITEM:CanUse(ply)
	if ply:Team() == TEAM_CP then
	    return true
    end
end

function ITEM:OnUse(ply)

	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 85
	trace.filter = ply

    local tr = util.TraceLine(trace)

	for k,v in pairs(ents.FindByClass("deep_bug")) do
		if v:CPPIGetOwner() == ply then
			v:Remove()
		end
	end


	local motionsensor = ents.Create("deep_bug")
	motionsensor:SetModel("models/bo/weapons/tactical beacon.mdl")
	motionsensor:SetPos(tr.HitPos)
	motionsensor:SetAngles(ply:GetAngles())
	motionsensor:Spawn()
	motionsensor:CPPISetOwner(ply)


	ply:Notify("You have deployed an audio bugging device.")
	return true
end

impulse.RegisterItem(ITEM)