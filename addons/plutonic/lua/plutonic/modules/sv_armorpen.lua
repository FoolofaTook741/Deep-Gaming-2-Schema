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
					local baseDamage = dmg:GetDamage()
					local bonusDamage = baseDamage * scale - baseDamage
					local armorThreshold = ply:Armor() / 0.8
					local cappedBonus = math.min(bonusDamage, armorThreshold)
					local finalScale = (baseDamage + cappedBonus) / baseDamage
					dmg:ScaleDamage(finalScale)
				end
			end
		end
	end
)