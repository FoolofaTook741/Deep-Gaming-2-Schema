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
					local hitMultiplier = 1
					if hitgroup == HITGROUP_HEAD then
						hitMultiplier = 2
					elseif hitgroup == HITGROUP_RIGHTLEG or hitgroup == HITGROUP_LEFTLEG then
						hitMultiplier = 0.25
					end
					local effectiveDamage = baseDamage * hitMultiplier
					local bonusDamage = effectiveDamage * scale - effectiveDamage
					local cappedBonus = math.min(bonusDamage, ply:Armor())
					local preHeadshotBonus = cappedBonus / hitMultiplier
					local finalScale = (baseDamage + preHeadshotBonus) / baseDamage
					dmg:ScaleDamage(finalScale)
				end
			end
		end
	end
)