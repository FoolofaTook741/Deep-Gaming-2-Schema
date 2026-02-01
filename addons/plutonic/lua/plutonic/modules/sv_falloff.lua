Plutonic.Hooks.Add(
	"ScalePlayerDamage",
	"Falloff",
	function(ply, hitgroup, dmg)
		if ply:Team() == 10 then
			local attacker = dmg:GetAttacker()
			if IsValid(attacker) and attacker:IsPlayer() then
				local wep = attacker:GetActiveWeapon()
				if wep.IsPlutonic and wep.Primary and wep.Primary.Falloff then
					local dist = ply:GetPos():DistToSqr(attacker:GetPos())
					local falloff = wep.Primary.Falloff ^ 2
					local startFalloff = wep.Primary.StartFalloff ^ 2
					if dist > startFalloff then
						local v = math.Clamp((dist - startFalloff) / (falloff - startFalloff), 0, 1)
						dmg:ScaleDamage(1 - v)
					end
				end
			end
		end
	end
)