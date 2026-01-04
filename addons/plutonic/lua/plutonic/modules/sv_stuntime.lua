-- Stuntime, used w/ HL2RP
Plutonic.Hooks.Add(
	"SetupMove",
	function(ply, mvData)
		if ply.StunTime then
			if ply.StunTime < CurTime() then
				ply.StunTime = nil
			else
				local v = math.Clamp((ply.StunStartTime - CurTime()) / (ply.StunStartTime - ply.StunTime), 0, 1)
				mvData:SetMaxClientSpeed(mvData:GetMaxClientSpeed() * v)
			end
		end
	end
)

--[[Plutonic.Hooks.Add(
	"StartCommand",
	function(ply, cmd)
		local wep = ply.GetActiveWeapon and ply:GetActiveWeapon()
		if wep and IsValid(wep) and wep.IsPlutonic and cmd:KeyDown(IN_SPEED) and wep:GetReloading() then
			cmd:RemoveKey(IN_SPEED)
		end
	end
)]]