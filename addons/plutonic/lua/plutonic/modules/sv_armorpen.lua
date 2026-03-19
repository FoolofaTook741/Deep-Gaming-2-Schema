-- Armor Penetration
Plutonic.Hooks.Add(
	"ScalePlayerDamage",
	"ArmorPen",
	function(ply, hitgroup, dmg)
		if ply:Armor() == 0 then 
			return 
		end
		
		local attacker = dmg:GetAttacker()
		
		if IsValid(attacker) and attacker:IsPlayer() then
			local wep = attacker:GetActiveWeapon()
			
			if IsValid(wep) then
				if wep.Primary and wep.Primary.PenetrationScale then
					local scale = wep.Primary.PenetrationScale
					dmg:ScaleDamage(scale)
				end
			end
		end
	end
)