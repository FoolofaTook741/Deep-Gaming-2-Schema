include("shared.lua")
include("animations.lua")

SWEP.Slot = 3
SWEP.SlotPos = 0
	
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 75
	
SWEP.VElements = {}
SWEP.ViewModelBoneMods = {
	["CylinderTurn"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
}

function SWEP:DoSpin()
	self.SpinAng = self.SpinAng or 0
	self.SpinSpeed = self.SpinSpeed or 10
		
	if self.SpinAng > 7200 then
		self.SpinAng = -7200
	end
	
	self.SpinAng = self.SpinAng - self.SpinSpeed

	if self.SpinSpeed > 0 then
		self.SpinSpeed = self.SpinSpeed * 0.99
	elseif self.SpinSpeed < 0 then
		self.SpinSpeed = 0
	end
	self.ViewModelBoneMods["CylinderTurn"].angle = Angle(self.SpinAng, 0, 0)
end


function SWEP:OnRemove()
	self:Anim_OnRemove()
end

function SWEP:ViewModelDrawn()
	self:Anim_ViewModelDrawn()
end

function SWEP:DrawWorldModel()
	self:Anim_DrawWorldModel()
end

killicon.Add("weapon_taucannon_wal", "killicons/weapon_taucannon_wal", Color(255,127,39))
