--- The core level functionality of Plutonic.
-- @module Framework

--- Fire a bullet from the weapon. This is a wrapper for the SWEP:FireBullets function.
-- @realm shared
-- @param bullet The bullet table to use.
-- @param SuppressHostEvents Whether or not to suppress the host events.
Plutonic.Framework.FireBullets = function(self, bullet, SuppressHostEvents)
	bullet.Callback = function(attacker, tr)
		if attacker.IsDeveloper and attacker:IsDeveloper() then
			debugoverlay.Cross(tr.HitPos, 2, 3, Color(255, 0, 0), true)
		end
	end

	self:GetOwner():FireBullets(bullet, SuppressHostEvents)
end