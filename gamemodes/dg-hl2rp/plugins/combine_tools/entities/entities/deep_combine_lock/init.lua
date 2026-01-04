AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

if SERVER then

    function ENT:Initialize()
        self:SetModel("models/props_combine/combine_lock01.mdl")
        self:DrawShadow(true)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetCollisionGroup(COLLISION_GROUP_NONE)
		self:CollisionRulesChanged()
		
		self.HP = 100

        self.DoorList   = {}
        self.UnlockOpen = false

        self.locklight = ents.Create("light_dynamic")
        self.locklight:SetPos(self:GetPos())
        self.locklight:SetParent(self)
        self.locklight:Spawn()
        self.locklight:SetKeyValue("_light",   "255 0 0 255")
        self.locklight:SetKeyValue("distance", "50")
    end
		
	function ENT:SpawnFunction(ply, tr)
		if not tr.Hit then return end

		local door = tr.Entity
		if IsValid(door)
		  and (door:GetClass() == "prop_door_rotating"
			or door:GetClass() == "func_door_rotating") then

			for _, lock in ipairs(ents.FindByClass(self.ClassName)) do
				if lock:GetParent() == door then
					ply:ChatPrint("That door already has a lock!")
					return
				end
			end
		end

		local ent = ents.Create(self.ClassName)
		if not IsValid(ent) then return end

		local spawnPos = tr.HitPos + tr.HitNormal * 8
		local ang      = tr.HitNormal:Angle()
		ang:RotateAroundAxis(ang:Right(), -90)

		ent:SetPos(spawnPos)
		ent:SetAngles(ang)
		ent:Spawn()
		ent:Activate()

		ent.Owner = ply

		if IsValid(door)
		  and (door:GetClass() == "prop_door_rotating"
		   or door:GetClass() == "func_door_rotating") then

			table.insert(ent.DoorList, door)
			ent:SnapToDoor(door)
			door:Fire("Lock", "", 0)
		end

		return ent
	end

    function ENT:PhysgunPickup() return false end
	function ENT:GravGunPickupAllowed(ply) if #self.DoorList == 0 then return true end return false end
    function ENT:GravGunPunt() return false end

	function ENT:Use(ply)
		if ply == self.Owner and ply:KeyDown(IN_WALK) then
			ply:ChatPrint("Lock removed.")
			self:EmitSound("buttons/button14.wav")
			return self:Remove()
		end

		local teamOK = ply:Team() == TEAM_CP
					or ply:Team() == TEAM_CA
					or ply:Team() == TEAM_OTA

		if not teamOK then
			self:EmitSound("buttons/combine_button_locked.wav")
			return
		end

		self.UnlockOpen = not self.UnlockOpen
		if self.UnlockOpen then
			self:EmitSound("buttons/combine_button1.wav")
			self.locklight:SetKeyValue("_light", "0 255 0 255")
		else
			self:EmitSound("buttons/button24.wav")
			self.locklight:SetKeyValue("_light", "255 0 0 255")
		end

		for _, door in ipairs(self.DoorList) do
			if IsValid(door) then
				door:Fire(self.UnlockOpen and "Unlock" or "Lock", "", 0)
			end
		end
	end

    function ENT:Touch(ent)
        local cls = ent:GetClass()
        if (cls == "prop_door_rotating" or cls == "func_door_rotating") then

            for _, lock in ipairs(ents.FindByClass(self.ClassName)) do
                if lock:GetParent() == ent then
                    local owner = lock.Owner or lock:GetNWEntity("LockOwner")
                    if IsValid(owner) then
                        owner:ChatPrint("That door already has a lock!")
                    end
                    return
                end
            end

            self:EmitSound("buttons/blip2.wav")
            ent:Fire("Lock", "", 0)
            self:SnapToDoor(ent)
            table.insert(self.DoorList, ent)
        end
    end

    function ENT:SnapToDoor(door)
        if not IsValid(door) then return end
		
        local center = door:LocalToWorld(door:OBBCenter())
        local normal = door:GetForward()
        if (self:GetPos() - center):Dot(normal) < 0 then normal = -normal end

        local depth = 8
        local attachPos = center + normal * depth

        local ang = normal:Angle()
        ang:RotateAroundAxis(ang:Right(), 360)
        ang:RotateAroundAxis(door:GetUp(), -90)
		

        self:SetPos(attachPos)
        self:SetAngles(ang)
        self:SetParent(door)
        self:SetMoveType(MOVETYPE_NONE)
		door._combineLock = self
		
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then phys:EnableMotion(false) end

        self:SetSolid(SOLID_VPHYSICS)
        self:CollisionRulesChanged()
    end
	
	function ENT:OnTakeDamage(dmginfo)
		local dmg = dmginfo:GetDamage()
		self.HP = self.HP - dmg

		local idx = math.random(1, 7)
		local soundPath = "phx/epicmetal_hard" .. idx .. ".wav"
		self:EmitSound(soundPath, 75, 100)

		if self.HP <= 0 then
			self:Destruct()
		end
	end
	
    function ENT:Destruct()
	    for _, door in ipairs(self.DoorList) do
			if IsValid(door) then
				door:Fire("Unlock", "", 0)
				door._combineLock = nil
			end
		end
		local rf = RecipientFilter()
		for v,k in pairs(player.GetAll()) do
		   if k:IsCP() then
			   rf:AddPlayer(k)
		   end 
		end
		net.Start("pinnacle_lockdestroyed")
		net.WriteVector(self:GetPos())
		net.Send(rf)
        local items, count = impulse.Loot.GenerateFromPool("scrapMid")
        local pos = self:GetPos() + Vector(0, 0, 19)
        local delay = 0.5

        for itemName, amt in pairs(items) do
            for i = 1, amt do
                timer.Simple(delay, function()
                    impulse.Inventory.SpawnItem(itemName, pos, nil, 300)
                end)
                delay = delay + 0.9
            end
        end
	self:EmitSound("physics/metal/metal_box_break2.wav")
	self:Remove()
	end

    function ENT:OnRemove()
        if IsValid(self.locklight) then
            self.locklight:Fire("Kill", 1, 0)
        end
    end
	
	hook.Add("playerCanUnlockLock", "combinelock_block", function(ply, doorOwners, doorGroup)
		local tr   = ply:GetEyeTraceNoCursor()
		local door = tr.Entity

		if not IsValid(door)
		  or (door:GetClass() ~= "prop_door_rotating"
			  and door:GetClass() ~= "func_door_rotating") then
			return 
		end

		for _, lock in ipairs(ents.FindByClass("deep_combine_lock")) do
			if IsValid(lock) and lock:GetParent() == door then
				if not lock.UnlockOpen then
					ply:EmitSound("buttons/combine_button_locked.wav")
					return false
				end
			end
		end
	end)
	
	hook.Add("OnPlayerChangedTeam", "combinelock_self_remove", function(ply, oldTeam, newTeam)
		for _, lock in ipairs(ents.FindByClass("deep_combine_lock")) do
			if lock.Owner == ply then
				for _, door in ipairs(lock.DoorList or {}) do
					if IsValid(door) then
						door:Fire("Unlock", "", 0)
					end
				end
				lock:Remove()
			end
		end
	end)
end