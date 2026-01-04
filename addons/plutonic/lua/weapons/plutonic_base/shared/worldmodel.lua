function SWEP:DrawWorldModel()
	if self.ExtraDrawWorldModel then
		self.ExtraDrawWorldModel(self)
	else
		self:DrawModel()
	end
end

hook.Add(
	"PostPlayerDraw",
	"PlutonicDrawWorldAttachment",
	function()
		local wep = LocalPlayer():GetActiveWeapon()
		if not IsValid(wep) then return end
		if IsValid(wep.worldAttachment) then
			wep.worldAttachment:DrawModel()
			wep.worldAttachment:SetRenderOrigin()
			wep.worldAttachment:SetRenderAngles()
		end
	end
)