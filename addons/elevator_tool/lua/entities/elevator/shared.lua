if (SERVER) then
	AddCSLuaFile();

	function ENT:SetupOwner(player)
	    self:SetCreator(player)
	    if self.CPPISetOwner then self:CPPISetOwner(player) end

	    if IsValid(self.door) then
	        self.door:SetCreator(player)
	        if self.door.CPPISetOwner then self.door:CPPISetOwner(player) end

	        if IsValid(self.door.child) then
	            self.door.child:SetCreator(player)
	            if self.door.child.CPPISetOwner then self.door.child:CPPISetOwner(player) end
	        end
	    end
	end
end;

DEFINE_BASECLASS("base_entity");

ENT.PrintName		= "Elevator";
ENT.Category		= "Elevators";
ENT.Spawnable		= false;
ENT.AdminOnly		= true;
ENT.Model			= Model("models/hunter/plates/plate2x2.mdl");
ENT.RenderGroup 	= RENDERGROUP_BOTH;

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Door");
end;

if (SERVER) then

	function ENT:SpawnFunction(player, trace, class)
		if (!trace.Hit) then return; end;
		local entity = ents.Create(class);

		entity:SetPos(trace.HitPos + trace.HitNormal * 1.5);
		entity:Spawn();

		return entity;
	end;

	function ENT:Initialize()
		self.door = ents.Create("func_movelinear");
		self.door:SetPos(self:GetPos());
		self.door:SetAngles(self:GetAngles());
		self.door:SetModel(self.Model);
		self.door:Spawn();
		self.door:SetMoveType(MOVETYPE_PUSH);
		self.door:SetNoDraw(true);
		self.door.parent = self;
		self.door:SetName("zelevator_" .. self:EntIndex());

		self:SetName("zelevator_parent_" .. self:EntIndex());

		self.door:SetKeyValue("OnFullyOpen", self:GetName() .. ",Shake");
		self.door:SetKeyValue("OnFullyClosed", self:GetName() .. ",Shake");

		self:SetDoor(self.door);

		self.door.child = ents.Create("prop_dynamic");
		self.door.child:SetModel(self.Model);
		self.door.child:Spawn();
		self.door.child:SetParent(self.door);
		self.door.child:SetLocalPos(vector_origin);
		self.door.child:SetLocalAngles(angle_zero);
		self.door.child:SetNotSolid(true);
		self.door.child:SetRenderMode(1);

		self:SetParent(door);
		self:SetNotSolid(true);
		self:SetNoDraw(true);
		self:SetColor(Color(0, 0, 0, 0));
	end;

	function ENT:AcceptInput(name, act, caller, data)
		if (name == "Shake" and self.door.shake) then
			local info = self.door.movespeed / 120;
			util.ScreenShake(self.door:GetPos(), info, info, 0.5, self.door.movespeed * 3.5);
		end;
	end;

	function ENT:Think()
		if (IsValid(self.door.child)) then
			self.door.child:SetColor(self.door:GetColor());
			self.door.child:SetMaterial(self.door:GetMaterial());
		end;

		if (IsValid(self.door)) then
			self.door:SetNoDraw(true);
		end;
	end;

	function ENT:Use(activator, caller, type, value)

	end;

	function ENT:OnRemove()
		if (IsValid(self.door)) then
			self.door:StopSound(self.door.movesound or "");
		end;

		SafeRemoveEntity(self.door);
	end;

	function ENT:SetStart(pos)
		if (IsValid(self.door)) then
			self.door:SetSaveValue("m_vecPosition1", tostring(pos));
			self.door.startPos = self.door:WorldToLocal(pos);
			self.door.worldStartPos = pos;
		end;
	end;

	function ENT:SetEnd(pos)
		if (IsValid(self.door)) then
			self.door:SetSaveValue("m_vecPosition2", tostring(pos));
			self.door.endPos = self.door:WorldToLocal(pos);
			self.door.worldEndPos = pos;
		end;
	end;

	function ENT:SetMoveSpeed(speed)
		if (IsValid(self.door)) then
			self.door:Fire("SetSpeed", tostring(speed));
			self.door.movespeed = tonumber(speed);
		end;
	end;

	function ENT:SetMoveSound(snd)
		if (IsValid(self.door)) then
			self.door:SetKeyValue("StartSound", tostring(snd));
			self.door.movesound = tostring(snd);
		end;
	end;

	function ENT:SetStopSound(snd)
		if (IsValid(self.door)) then
			self.door:SetKeyValue("StopSound", tostring(snd));
			self.door.stopsound = tostring(snd);
		end;
	end;

	function ENT:SetShake(bShake)
		self.door.shake = tobool(bShake);
	end;

	function ENT:ChangeModel(model)
		if (IsValid(self.door)) then
			self.door:SetModel(model);
			self.door:Activate();
		end;

		if (IsValid(self.door.child)) then
			self.door.child:SetModel(model);
		end;
	end;

	function ENT:SetBlockDamage(dmg)
		self.door:SetKeyValue("BlockDamage", tonumber(dmg));
		self.door.blockdamage = dmg;
	end;

	function ENT:SetAllowUse(bUse)
		self.door.allowuse = tobool(bUse);
	end;

	hook.Add("KeyPress", "elevator_useHandler", function(player, key)
		if (key != IN_USE) then return; end;
		local entity = player:GetEyeTrace().Entity;

		if (!IsValid(entity)) then return; end;
		if (player:GetEyeTrace().HitPos:Distance(player:EyePos()) >= 85) then return; end;

		if (entity:GetClass() == "func_movelinear") then
			if (entity.allowuse) then
				local startPos = entity.worldStartPos;
				local endPos = entity.worldEndPos;
				if (entity:GetPos():Distance(startPos) <= 10) then
					entity:Fire("Open");
					return true;
				elseif (entity:GetPos():Distance(endPos) <= 10) then
					entity:Fire("Close");
					return true;
				end;
			end;
		elseif (IsValid(entity:GetParent())) then
			if (entity:GetParent():GetClass() == "func_movelinear") then
				entity = entity:GetParent();
				if (entity.allowuse) then
					local startPos = entity.worldStartPos;
					local endPos = entity.worldEndPos;
					if (entity:GetPos():Distance(startPos) <= 10) then
						entity:Fire("Open");
						return true;
					elseif (entity:GetPos():Distance(endPos) <= 10) then
						entity:Fire("Close");
						return true;
					end;
				end;
			end;
		end;
	end);

	hook.Add("AllowPlayerPickup", "elevator_pickupHandler", function(player, entity)
		if (IsValid(entity:GetParent())) then
			return false;
		end;
	end);

elseif (CLIENT) then

	function ENT:Initialize()
		self:SetSolid(SOLID_VPHYSICS);
	end;

	function ENT:Draw()

	end;

end;

duplicator.RegisterEntityClass("func_movelinear", function(player, data, startPos, endPos, speed, moveSound, stopSound, blockDamage, bAllowUse, startButton, returnButton, parts, worldStartPos, bShake)
	local ent = ents.Create("elevator");
	ent:SetPos(data.Pos);
	ent:SetAngles(data.Angle);
	ent.Model = data.Model;
	ent:Spawn();

	ent:SetStart(ent:GetDoor():LocalToWorld(startPos));
	ent:SetEnd(ent:GetDoor():LocalToWorld(endPos));

	ent:SetMoveSpeed(speed);
	ent:SetMoveSound(moveSound);
	ent:SetStopSound(stopSound);

	ent:SetBlockDamage(blockDamage);
	ent:SetAllowUse(bAllowUse);
	ent:SetShake(bShake);

	ent:GetDoor().StartButton = numpad.OnDown(player, startButton, "ElevatorStart", ent:GetDoor());
	ent:GetDoor().ReturnButton = numpad.OnDown(player, returnButton, "ElevatorReturn", ent:GetDoor());

	table.Add(ent:GetTable(), data);

	if (parts) then
		for k, v in pairs(parts) do
			local prop = ents.Create("prop_physics");
			prop:SetPos(ent:GetDoor():LocalToWorld(v.origin));
			prop:SetAngles(ent:GetDoor():LocalToWorldAngles(v.angles));
			prop:SetModel(v.model);
			prop:SetMaterial(v.material);
			prop:SetRenderMode(v.rendermode);
			prop:SetColor(v.color);
			prop:Spawn();
			prop:SetParent(ent:GetDoor());
			prop:GetPhysicsObject():EnableMotion(false);
		end;
	end;

	return ent;
end, "Data", "startPos", "endPos", "movespeed", "movesound", "stopsound", "blockdamage", "allowuse", "b1", "b2", "parts", "material", "worldStartPos", "shake");