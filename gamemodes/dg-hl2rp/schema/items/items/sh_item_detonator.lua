local ITEM = {}

ITEM.UniqueID = "item_ieddetonator"
ITEM.Name = "Remote Detonator"
ITEM.Desc =  "Detects all IED's in a 3 mile radius and detonates them all."
ITEM.Category = "Tools"
ITEM.Model = Model("models/bo/weapons/c-4 detonator.mdl")
ITEM.FOV = 10.308022922636
ITEM.CamPos = Vector(-0.57306587696075, -91.117477416992, 98.567337036133)
ITEM.NoCenter = true
ITEM.Weight = 4

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.ConfiscateReward = 5

ITEM.Illegal = true
ITEM.CanStack = false

ITEM.UseName = "Trigger"
ITEM.UseWorkBarTime = 1.5
ITEM.UseWorkBarName = "Triggering..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "weapons/c4/c4_plant.wav"

function ITEM:OnUse(ply, door)
	local ownedieds = 0
	for k, v in pairs(ents.FindByClass("impulse_usable")) do
		if v:GetModel() == "models/weapons/w_c4_planted.mdl" && v.Placer == ply then
			v:Kaboom()
			ownedieds = ownedieds + 1
		end
	end
	if ownedieds == 0 then
		ply:Notify("No I.E.Ds detected.")
	else
		ply:Notify("All I.E.Ds detonated.")
	end
	return false
end

impulse.RegisterItem(ITEM)
