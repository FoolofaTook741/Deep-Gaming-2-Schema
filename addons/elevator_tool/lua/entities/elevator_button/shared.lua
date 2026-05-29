if (SERVER) then
	AddCSLuaFile();
end;

DEFINE_BASECLASS("base_entity");

ENT.PrintName		= "Elevator Call Button";
ENT.Category		= "Elevators";
ENT.Spawnable		= false;
ENT.AdminOnly		= true;
ENT.Model			= Model("models/props_combine/combinebutton.mdl");
ENT.RenderGroup 	= RENDERGROUP_BOTH;

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Elevator");
	self:NetworkVar("Bool", 0, "Sender");
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
		self:SetModel(self.Model);
		self:SetSolid(SOLID_VPHYSICS);
		self:PhysicsInit(SOLID_VPHYSICS);

		local phys = self:GetPhysicsObject();

		if (IsValid(phys)) then
			phys:Wake();
		end;
	end;

	function ENT:Use(activator, caller, type, value)
		if (IsValid(self:GetElevator()) and self:GetElevator():GetVelocity():Length() <= 1) then
			self:GetElevator():Fire(self:GetSender() and "Open" or "Close");
		end;
	end;

elseif (CLIENT) then

	function ENT:Initialize()
		self:SetSolid(SOLID_VPHYSICS);
	end;

	function ENT:Draw()
		self:DrawModel();
	end;

end;