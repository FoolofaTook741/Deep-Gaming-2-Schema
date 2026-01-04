AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("impulseHL2RPTerminal")
util.AddNetworkString("impulseHL2RPTerminalConvict")

function ENT:Initialize()
	self:SetModel("models/props_combine/combine_interface001.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetSkin(1)

    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableMotion(false)
	end

	self:SetNetworkedUser(-1)

	if self.impulseSaveKeyValue then
		self:SetConvictIndex(self.impulseSaveKeyValue["convict"])
		self:SetOverwatchIndex(self.impulseSaveKeyValue["overwatch"])
	end
end

function ENT:OnTakeDamage(dmg) 
	return false
end

function ENT:Use(activator, caller)
	if (self.nextTry or 0) > CurTime() then return end
	
	local heightDiff = self:GetPos().z - activator:GetPos().z

	if self.Emped == true then
		activator:Notify("This terminal has been shorted out, have a repair team come fix it to use.")
		return
	end

	if activator:IsPlayer() and activator:Alive() and activator:OnGround() and not activator:Crouching() and (heightDiff > -22 and heightDiff < 18)  then -- make sure they are not jumping or on top of the terminal/below it
		local trace = {}
		trace.start = activator:EyePos()
		trace.endpos = trace.start + activator:GetAimVector() * 45
		trace.filter = activator

		local tr = util.TraceLine(trace)
		local trHitPos = tr.HitPos

		local pos = self:GetPos()
		local ang = self:GetAngles()

		local consolePos1 = pos + (ang:Up() * 55)
		consolePos1 = consolePos1 + (ang:Forward() * -10)
		consolePos1 = consolePos1 + (ang:Right() * 25)

		local consolePos2 = pos + (ang:Up() * 30)
		consolePos2 = consolePos2 + (ang:Forward() * 25)
		consolePos2 = consolePos2 + (ang:Right() * -25)

		if trHitPos:WithinAABox(consolePos1, consolePos2) then -- make sure the player is looking bit of the terminal that has all the controls
			if activator:IsCP() and (activator:Team() == TEAM_CA or activator:GetTeamClass()) then
				if not self.User then
					self:EmitBudgetSound("ambient/machines/keyboard_slow_1second.wav")
					self:SetUser(activator)
				else
					activator:Notify("Terminal already in use.")
				end
			else
				self:EmitBudgetSound("buttons/combine_button_locked.wav")
				activator:Notify("You cannot access this terminal.")
			end
		end
	end

	self.nextTry = CurTime() + 1.5
end

function ENT:Think()
	local user = self.User

	if user then
		if IsValid(user) then
			if user:Alive() and user:IsCP() and (user:Team() == TEAM_CA or user:GetTeamClass()) then
				if (user:GetPos() - self:GetPos()):LengthSqr() > (180 ^ 2) then
					self:RemoveUser(user)
				end
			else
				self.User = nil
				user.Terminal = nil
				user.extraPVS = nil
				self:NetworkedUser(-1)
			end
		else
			self.User = nil
			self:SetNetworkedUser(-1)
		end
	end

	self:NextThink(CurTime() + 1)
end

local useSounds = {
	"ambient/machines/combine_terminal_idle1.wav",
	"ambient/machines/combine_terminal_idle2.wav",
	"ambient/machines/combine_terminal_idle4.wav"
}

function ENT:EmitUseSound()
	self:EmitSound(useSounds[math.random(1, #useSounds)])
end

function ENT:SetUser(ply)
	self:SetNetworkedUser(ply:EntIndex())
	self.User = ply
	ply.Terminal = self

	if ply:Team() == TEAM_OTA then
		ply:ForceSequence("console_type_loop", nil, 0)
	end

	local isConvict = self:GetConvictIndex()
	local netName = (isConvict and "impulseHL2RPTerminalConvict") or "impulseHL2RPTerminal"

	net.Start(netName)

	if ply.ArrestedDragging and IsValid(ply.ArrestedDragging) and ply.ArrestedDragging:IsPlayer() then
		net.WriteUInt(ply.ArrestedDragging:EntIndex(), 8)
	else
		net.WriteUInt(0, 8)
	end

	if isConvict then
		local count = 0
		local netMe = {}

		for v,k in pairs(player.GetAll()) do
			local cell = k.InJail

			if k.InJail then
				local cellData = impulse.Arrest.Prison[cell][k:EntIndex()]

				if cellData then
					count = count + 1

					local dur = cellData.duration

					table.insert(netMe, {k, cell, dur / 60, cellData.start + dur})
				end
			end
		end

		net.WriteUInt(count, 8)

		for v,k in pairs(netMe) do
			net.WriteEntity(k[1])
			net.WriteUInt(k[2], 8)
			net.WriteUInt(k[3], 8)
			net.WriteUInt(k[4], 32)
		end
	end

	net.Send(ply)
end

function ENT:RemoveUser(ply)
	self:SetNetworkedUser(-1)
	self.User = nil
	ply.Terminal = nil
	ply.extraPVS = nil

	if ply:Team() == TEAM_OTA then
		ply:leaveSequence()
	end
end