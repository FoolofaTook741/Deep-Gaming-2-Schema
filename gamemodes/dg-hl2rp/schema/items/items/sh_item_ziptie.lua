local ITEM = {}

ITEM.UniqueID = "item_ziptie"
ITEM.Name = "Ziptie"
ITEM.Desc =  "Can be used to restrain the less cooperative members of society."
ITEM.Category = "Tools"
ITEM.Model = Model("models/Items/CrossbowRounds.mdl")
ITEM.FOV = 7.3137535816619
ITEM.CamPos = Vector(41.260746002197, -86.53295135498, 41.833812713623)
ITEM.Weight = 0.1

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Use"
ITEM.UseWorkBarTime = 0.3
ITEM.UseWorkBarName = "Restraining..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "npc/vort/claw_swing2.wav"

function ITEM:CanRestrain(ply, target)
	if not IsValid(target) or not target:IsPlayer() then return false end
	if not ply:CanArrest(target) then return false end
	if target:GetSyncVar(SYNC_ARRESTED, false) then return false end
	return true
end

function ITEM:DoRestrain(ply, target)
	target:Arrest()

	ply:Notify("You have detained "..target:Name()..".")
	target:Notify("You have been detained.")

	hook.Run("PlayerArrested", target, ply)
end

function ITEM:OnUse(ply, target)
	if self:CanRestrain(ply, target) then
		self:DoRestrain(ply, target)
		return true
	else
		ply:Notify("Target already detained.")
	end
end

function ITEM:ShouldTraceUse(ply, ent)
	return self:CanRestrain(ply, ent)
end

impulse.RegisterItem(ITEM)
