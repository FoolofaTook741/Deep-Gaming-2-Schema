local ITEM = {}

ITEM.UniqueID = "item_ied"
ITEM.Name = "Radio Frequency I.E.D."
ITEM.Desc =  "Can cause remotely triggered explosions."
ITEM.Category = "Tools"
ITEM.Model = Model("models/weapons/w_c4_planted.mdl")
ITEM.FOV = 10.308022922636
ITEM.CamPos = Vector(-0.57306587696075, -91.117477416992, 98.567337036133)
ITEM.NoCenter = true
ITEM.Weight = 4

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true
ITEM.ConfiscateReward = 80

ITEM.UseName = "Place"
ITEM.UseWorkBarTime = 1
ITEM.UseWorkBarName = "Placing..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "weapons/c4/c4_plant.wav"

function ITEM:OnUse(ply, door)
	local freqs = {82.4, 87.9, 104.4, 115.4}
	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 85
	trace.filter = ply

	local tr = util.TraceLine(trace)

	impulse.IEDS = impulse.IEDS or {}

	local ied = ents.Create("impulse_usable")
	ied:SetModel(self.Model)
	ied:SetPos(tr.HitPos)
	ied:SetAngles(ply:GetAngles())

	local phys = ied:GetPhysicsObject()

	if phys and IsValid(phys) then
		phys:SetMass(20)	
	end

	local freq = freqs[math.random(1, #freqs)]

	ied.Placer = ply
	ied.Freq = freq

	function ied:Use(ply)
		if self.Placer == ply then
			if ply:IsCP() then
				return
			end
			
			if not ply:CanHoldItem("item_ied") then
				return ply:Notify("You don't have enough space to pickup this item.")
			end
			
			ply:GiveInventoryItem("item_ied")
			ply:Notify("You have disarmed and picked up the IED.")
			table.RemoveByValue(impulse.IEDS, self)

			self:Remove()
		end
	end

	function ied:Kaboom()
		if IED_TRACKING_ENABLED then
			local placerInfo = "Unknown"
			if IsValid(self.Placer) then
				placerInfo = self.Placer:Name() .. " (" .. self.Placer:SteamName() .. " | " .. self.Placer:SteamID() .. ")"
			else
				placerInfo = "Placer no longer online"
			end

			for _, admin in pairs(player.GetAll()) do
				if admin:IsAdmin() then
					admin:AddChatText(Color(255, 0, 0), "[IED TRACKING] IED detonation attempt blocked!")
					admin:AddChatText(Color(255, 0, 0), "[IED TRACKING] Placer: " .. placerInfo)
					admin:AddChatText(Color(255, 0, 0), "[IED TRACKING] Frequency: " .. (self.Freq or "Unknown"))
					admin:AddChatText(Color(255, 0, 0), "[IED TRACKING] Position: " .. tostring(self:GetPos()))
				end
			end
			
			impulse.debugPrint("[IED TRACKING] IED detonation attempt blocked! Placer: " .. placerInfo .. " | Frequency: " .. (self.Freq or "Unknown") .. " | Position: " .. tostring(self:GetPos()))
			
			self:EmitSound("weapons/c4/c4_beep1.wav", 90)
			table.RemoveByValue(impulse.IEDS, self)
			
			timer.Simple(1.5, function()
				if IsValid(self) then
					self:Remove()
				end
			end)
			
			return
		end

		self:EmitSound("weapons/c4/c4_beep1.wav", 90)
		table.RemoveByValue(impulse.IEDS, self)

		timer.Simple(1.5, function()
			if not IsValid(self) then
				return
			end

			local debris = {}

			for i=1,9 do
				local flyer = ents.Create("prop_physics")
				flyer:SetPos(self:GetPos())

				if i > 4 then
					flyer:SetModel("models/props_debris/wood_chunk08b.mdl")
				else
					flyer:SetModel("models/combine_helicopter/bomb_debris_"..math.random(2, 3)..".mdl")
				end

				flyer:Spawn()
				flyer:Ignite(30)

				local phys = flyer:GetPhysicsObject()

				if phys and IsValid(phys) then
					phys:SetVelocity(Vector(math.random(-150, 150), math.random(-150, 150), math.random(-150, 150)))
				end

				table.insert(debris, flyer)
			end

			timer.Simple(40, function()
				for v,k in pairs(debris) do
					if IsValid(k) then
						k:Remove()
					end
				end
			end)

			local explodeEnt = ents.Create("env_explosion")
			explodeEnt:SetPos(self:GetPos())

			if IsValid(self.Placer) then
				explodeEnt:SetOwner(self.Placer)
			end 

			explodeEnt:Spawn()
			explodeEnt:SetKeyValue("iMagnitude", "325")
			explodeEnt:Fire("explode", "", 0)
			util.BlastDamage(self, self.Placer, self:GetPos(), 1280, 10000)
			local pos = self:GetPos()
			timer.Simple(0.1,function()
				for v,k in ipairs(player.GetAll()) do
					if k:GetPos():DistToSqr(pos) < (1800 ^ 2) then
						if k:Alive() then
							net.Start("impulseHL2RPTearGasFX")
							net.WriteFloat(20.6)
							net.Send(k)
						end
					end
				end
			end)

			local fire = ents.Create("env_fire")
			fire:SetPos(self:GetPos())
			fire:Spawn()
			fire:Fire("StartFire")

			timer.Simple(60, function()
				if IsValid(fire) then
					fire:Remove()
				end
			end)

			local effectData = EffectData()
			effectData:SetOrigin(self:GetPos())
			effectData:SetScale(16)
			util.Effect("Explosion", effectData)

			self:EmitSound("weapons/c4/c4_explode1.wav", 500)
			self:EmitSound("weapons/c4/c4_exp_deb1.wav", 125)
			self:EmitSound("weapons/c4/c4_exp_deb2.wav", 125)
			self:EmitSound("ambient/atmosphere/terrain_rumble1.wav", 108)

			for v,k in pairs(player.GetAll()) do
				k:SurfacePlaySound("ambient/levels/streetwar/city_battle7.wav")
			end

			util.ScreenShake(self:GetPos(), 4, 2, 2.5, 100000)

			self:Remove()

			local pos = self:GetPos()

			timer.Simple(1, function()
				for v,k in pairs(ents.FindByClass("prop_ragdoll")) do
					if k:GetPos():DistToSqr(pos) < (1200 ^ 2) then
						k:Ignite(40)
					end
				end
			end)
		end)
	end
	
	ied:Spawn()

	table.insert(impulse.IEDS, ied)

	ply:Notify("IED touch-off frequency is "..freq..".")

	return true
end

impulse.RegisterItem(ITEM)
