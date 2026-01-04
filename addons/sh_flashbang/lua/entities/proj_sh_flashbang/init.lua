AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("SH_FLASHBANG")

function ENT:Initialize()
	self.m_fDieTime = CurTime() + self.LifeTime

	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	local phys = self:GetPhysicsObject()
	if (IsValid(phys)) then
		phys:SetMass(1)
	end

	self:SetElasticity(2)
end

function ENT:PhysicsCollide(data, phys)
	local ent = data.HitEntity
	if (IsValid(ent)) then
		local cls = ent:GetClass()
		local breakthrough = false

		if (cls == "func_breakable_surf" or cls == "func_breakable") then
			breakthrough = true
		end

		if (breakthrough) then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker(IsValid(self.Owner) and self.Owner or self)
			dmginfo:SetInflictor(self)
			dmginfo:SetDamage(10)
			dmginfo:SetDamageType(DMG_CLUB)
			dmginfo:SetDamagePosition(data.HitPos)
			dmginfo:SetDamageForce(self:GetVelocity())

			local tr = util.TraceLine({start = self:GetPos(), endpos = data.HitPos, filter = self})
			ent:DispatchTraceAttack(dmginfo, tr)

			if (IsValid(phys)) then
				local speed = tr.Normal * self:GetVelocity():Length() * 0.4

				phys:EnableMotion(false)
				phys:Sleep()

				timer.Simple(0.01, function()
					if (!IsValid(phys)) then
						SafeRemoveEntity(self)
						return
					end

					phys:EnableMotion(true)
					phys:Wake()
					phys:SetVelocityInstantaneous(speed)
					phys:ApplyForceCenter(speed)
				end)
			end

			return
		end
	end

	if (20 < data.Speed and 0.25 < data.DeltaTime) then
		self:EmitSound(self.BounceSound)
	end
end

function ENT:Think()
	if (self.m_bExploded) then
		self:Remove()
	elseif (self.m_fDieTime and self.m_fDieTime <= CurTime()) then
		self:Explode()
	end
end

function ENT:Explode(cooked)
	if (self.m_bExploded) then
		return end

	self.m_bExploded = true
	self:FlashExplode()
end

function ENT:FlashExplode()
	local mypos = self:LocalToWorld(self:OBBCenter())

	local tbl = FLASHBANG_SETTINGS.HitNPCs and ents.GetAll() or player.GetAll()

	for _, ent in ipairs (tbl) do
		if (ent:IsPlayer() and ent:Alive()) then
			if ent:Team() != TEAM_OTA and ent.FlashSafe != true then
				local sp = ent:GetShootPos()
				local dir = (mypos - sp):GetNormal()

				local t = {
					start = sp,
					endpos = mypos,
					filter = ent,
				}
				local dist = t.start:Distance(t.endpos)
				if (dist > FLASHBANG_SETTINGS.Range) then
					continue end

				local tr = util.TraceLine(t)

				if (tr.Entity == self) then
					local endtime = math.Clamp(FLASHBANG_SETTINGS.Range / (dist * 2), 0, FLASHBANG_SETTINGS.MaxFlashTime)
					if (endtime == 0) then
						continue end

					local simpendtime = math.floor(endtime)
					local tenthendtime = math.floor((endtime - simpendtime) * 10)

					local mult = 1

					-- Am I looking at the flash directly?
					local dot = ent:GetAimVector():Dot(dir)
					if (dot < 0) then
						mult = math.Clamp(1 - math.abs(dot), 0.1, 1)
					end

					net.Start("SH_FLASHBANG")
						net.WriteFloat(endtime * mult)
					net.Send(ent)
					ent:SetSyncVar(SYNC_FLASHED, true, true)
					timer.Simple(endtime * mult, function()
						if (IsValid(ent)) then
							ent:SetSyncVar(SYNC_FLASHED, false, true)
						end
					end)

					ent:SetDSP(34, false)
				end
			end
		elseif (ent:IsNPC()) then
			local sp = ent:EyePos()
			local dir = (mypos - sp):GetNormal()

			local t = {
				start = sp,
				endpos = mypos,
				filter = ent,
			}
			local dist = t.start:Distance(t.endpos)
			if (dist > FLASHBANG_SETTINGS.Range) then
				continue end

			local tr = util.TraceLine(t)

			if (tr.Entity == self) then
				local endtime = math.Clamp(FLASHBANG_SETTINGS.Range / (dist * 2), 0, FLASHBANG_SETTINGS.MaxFlashTime)
				if (endtime == 0) then
					continue end

				local simpendtime = math.floor(endtime)
				local tenthendtime = math.floor((endtime - simpendtime) * 10)

				local mult = 1

				-- Am I looking at the flash directly?
				local dot = ent:GetForward():Dot(dir)
				if (dot < 0) then
					mult = math.Clamp(1 - math.abs(dot), 0.1, 1)
				end

				local oldrel = ent:Disposition(player.GetAll()[1])
				if (oldrel ~= D_LI) then
					ent:AddRelationship("player D_LI 98")
					ent:SetEnemy(NULL)
					ent:ClearEnemyMemory()
					ent:ClearGoal()

					timer.Simple(endtime * mult, function()
						if (IsValid(ent)) then
							local t = {
								[0] = "D_ER",
								[1] = "D_HT",
								[2] = "D_FR",
								[4] = "D_NU",
							}

							ent:AddRelationship("player " .. t[oldrel] .. " 99")
						end
					end)
				end
			end
		end
	end

	sound.Play("shenesis/flashbang_explode" .. math.random(2) .. ".ogg", mypos, 155)

	if (FLASHBANG_SETTINGS.CreateDecal) then
		local trs = util.TraceLine({start = mypos + Vector(0, 0, 64), endpos = mypos + Vector(0, 0, -128), filter = self})
		util.Decal("SmallScorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)
	end

	local effdata = EffectData()
	effdata:SetOrigin(mypos)
	util.Effect("flashbangexplode", effdata, true, true)

	self:Remove()
end