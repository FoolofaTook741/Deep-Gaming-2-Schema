AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

include('shared.lua')

sound.Add( {
	name = "washsound",
	channel = CHAN_AUTO,
	volume = 0.5,
	level = 80,
	pitch = { 95, 110 },
	sound = "ambient/machines/laundry_machine1_amb.wav"
} )

function ENT:Initialize()
	self:SetModel("models/props_wasteland/laundry_dryer002.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetTrigger(true)

	self:SetWashing(false)
end

function ENT:StartTouch(collider)
	if collider:GetClass() == "impulse_hl2rp_laundryitem" and self:GetWashing() == false then
		if collider.state == 0 then
			self:EmitSound("washsound")
			self.storedWorkers = collider.workers
			timer.Simple(0, function()
				if IsValid(collider) then
					collider:Remove()
				end
			end)
			self:SetWashing(true)
			timer.Simple(20, function()
				if IsValid(self) then
					self:Dispense()
					self:SetWashing(false)
					self:StopSound("washsound")
				end
			end)
		end
	end
end

function ENT:Dispense()
	self:StopSound("washsound")
	
	local cleanLaundry = ents.Create("impulse_hl2rp_laundryitem")
	local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()
	cleanLaundry:SetPos(self:GetPos() + f*30 + r*1 + u*15)
	cleanLaundry:SetStage(1)
	cleanLaundry.workers = self.storedWorkers
	cleanLaundry:Spawn()
	cleanLaundry:SetColor(Color(164, 164, 164))
	cleanLaundry.state = 1
end

function ENT:OnRemove()
	self:StopSound("washsound")
end
