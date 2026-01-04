AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")


include("Shared.lua")

function ENT:Initialize()

	self:SetModel("models/props_pipes/pipe03_90degree01.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType( SIMPLE_USE )
	self.useDelay = 0

	local phys = self:GetPhysicsObject()
	if(phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use(caller, activator)
	if self.useDelay < CurTime() and caller:Team() == TEAM_CWU and caller:GetTeamClass() == CLASS_INDUST then
		self.useDelay = CurTime() + 2

		local dirtyLaundryCount = #ents.FindByClass("impulse_hl2rp_laundryitem")
		if dirtyLaundryCount > 5 then
			activator:Notify("Please wash more laundry before requesting more dirty laundry.")
			return
		end

		self:EmitSound("buttons/lever5.wav")
		timer.Simple(0.8, function()
			local laundry = ents.Create("impulse_hl2rp_laundryitem")
			laundry:SetPos(self:GetPos() + Vector(0, 0, -17))
			laundry:SetStage(0)
			laundry:Spawn()
			laundry.state = 0
		end)
	end
end
