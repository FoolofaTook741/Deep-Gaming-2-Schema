AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_junk/PushCart01a.mdl")
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:DrawShadow(false)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
		phys:Sleep()
	end
end

function ENT:SpawnFunction(ply, trace, class)
	local ent = ents.Create(class)
	ent:SetPos(trace.HitPos)
	local ang = (trace.HitPos - ply:GetPos()):Angle()
	ang.p = 0
	ang.r = 0
	ang.y = ang.y + 180
	ent:SetAngles(ang)
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Touch(ent)
	if not IsValid(ent) then return end
	if ent:GetClass() ~= "impulse_item" then return end
	if not ent.Item then return end
	if ent.Item.UniqueID ~= "item_steelbar" then return end
	if ent.SmeltingDelivered then return end
	local ws = impulse.SmeltingWorkshift
	if not ws or not ws.active then return end
	ent.SmeltingDelivered = true
	ent:Remove()
	ws.refinedCount = (ws.refinedCount or 0) + 1
	self:EmitSound("physics/metal/metal_box_impact_hard1.wav")
	local deliverer = ent.ItemOwner
	if IsValid(deliverer) then
		deliverer:AddChatText("[REFINERY] Steel bars delivered: " .. ws.refinedCount .. " / " .. ws.refinedGoal)
	end
	if ws.refinedCount >= ws.refinedGoal then
		local now = CurTime()
		if not ws.lastGoalNotify or now - ws.lastGoalNotify > 60 then
			ws.lastGoalNotify = now
			for _, ply in ipairs(player.GetAll()) do
				if ply:SteamID64() == tostring(ws.supervisorID) then
					ply:AddChatText("[REFINERY] Smelting workshift refined goal reached! Report to the Refinery Foreman to collect your payout.")
					break
				end
			end
		end
	end
	if impulse.SmeltingPushUpdate then
		impulse.SmeltingPushUpdate()
	end
end
