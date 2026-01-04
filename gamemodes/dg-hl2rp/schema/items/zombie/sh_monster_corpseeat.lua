local ITEM = {}

ITEM.UniqueID = "monster_corpseeat"
ITEM.Name = "Ability: Zombie Corpse Consumption"
ITEM.Desc =  "Look at a dead body and dig in!"
ITEM.Category = "Monsters"
ITEM.Model = Model("models/gibs/antlion_gib_small_1.mdl")
ITEM.FOV = 7.8252148997135
ITEM.CamPos = Vector(100, 91.690544128418, 100)
ITEM.Colour = Color(75, 0, 0)
ITEM.NoCenter = true
ITEM.Weight = 30

ITEM.Droppable = false
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Eat"
ITEM.UseWorkBarTime = 4
ITEM.UseWorkBarName = "Eating corpse..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "impulse/eat.wav"
 
function ITEM:OnUse(ply, target)
	local headBone = target:LookupBone("ValveBiped.Bip01_Head1")
	local pelvisBone = target:LookupBone("ValveBiped.Bip01_Pelvis")
	local pelvisPos = pelvisBone and target:GetBonePosition(pelvisBone)
	local pelvisMatrix = pelvisBone and target:GetBoneMatrix(pelvisBone)
	local headPos = headBone and target:GetBonePosition(headBone)

	target:Remove()

	local function makeGib(ent)
		timer.Simple(300, function()
			if IsValid(ent) then
				ent:Remove()
			end
		end)

		ent.CanConstrain = false
		ent.NoCarry = true

		ent:Spawn()
		ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
	end

	if headPos then
		local m = impulse.Anim.GetModelClass(target:GetModel()) == "metrocop" and "models/dpfilms/metropolice/props/zombie_gasmask.mdl" or "models/gibs/hgibs.mdl"

		local gib = ents.Create("prop_physics")
		gib:SetModel(m)
		gib:SetPos(headPos)
		makeGib(gib)
	end

	if pelvisPos then
		local gib = ents.Create("prop_ragdoll")
		gib:SetModel("models/gibs/fast_zombie_legs.mdl")
		gib:SetPos(pelvisPos)
		gib:SetAngles(pelvisMatrix:GetAngles())
		makeGib(gib)
	end
	
	if ply:Team() == TEAM_ZOMBIE then
		if ply:Health() + 50 <= ply:GetMaxHealth() then
			ply:SetHealth(ply:Health() + (50 * (1 - (ply.Antiheal or 0))) )
			ply:Notify("You have eaten the corpse and gained some strength.")
			ply:FeedHunger(100)
		else
			ply:Notify("You have eaten the corpse, but you are already at maximum strength.")
			ply:FeedHunger(100)
		end
	end
	if ply:HasBrokenLegs() && ply:Team() == TEAM_ZOMBIE then
		ply:FixLegs()
		ply:Notify("Your broken legs have healed.")
	end
end

function ITEM:ShouldTraceUse(ply, ent)
	return ent:GetClass() == "prop_ragdoll" and (ent:GetModel() or "") != "models/gibs/fast_zombie_legs.mdl"
end

impulse.RegisterItem(ITEM)
