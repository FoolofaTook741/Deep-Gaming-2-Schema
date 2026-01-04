local ITEM = {}

ITEM.UniqueID = "item_autoturret"
ITEM.Name = "Automatic Sentry Turret"
ITEM.Desc =  "A small turret that fires AR2 ammunition autonomously at nearby attackers, but loses effectiveness at ranges and has trouble finding enemies hiding behind cover."
ITEM.Category = "Combine Tools"
ITEM.Model = Model("models/combine_turrets/ground_turret.mdl")
ITEM.FOV = 160.379656160458
ITEM.CamPos = Vector(-57.306591033936, -25.21489906311, 8.5959882736206)
ITEM.NoCenter = true
ITEM.Weight = 6.5

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
	if ply:Team() == TEAM_OTA or ply:Team() == TEAM_CITIZEN then
	    return true
    end
end

function ITEM:OnUse(ply)

	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 85
	trace.filter = ply

    local tr = util.TraceLine(trace)

	for k,v in pairs(ents.FindByClass("autoturret")) do
		if v:CPPIGetOwner() == ply then
			v:Remove()
		end
	end

	local turret = ents.Create("autoturret")
	turret:SetPos(tr.HitPos)
	turret:SetAngles(ply:GetAngles())
	turret:Spawn()
	turret:CPPISetOwner(ply)
    if ply:Team() == TEAM_CITIZEN then
        turret.Allegiance = "Rebel"
		turret:SetMaterial("atSkin5/turretskin2")
    else
        turret.Allegiance = "Combine"
		turret:SetMaterial("atSkin4/turretskin2")
    end

	ply:Notify("You have deployed an automatic turret.")
	return true
end

impulse.RegisterItem(ITEM)
