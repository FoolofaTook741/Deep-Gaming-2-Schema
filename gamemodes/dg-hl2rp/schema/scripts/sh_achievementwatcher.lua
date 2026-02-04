if SERVER then
	util.AddNetworkString("impulseAchPUTCWin")

	hook.Add("PlayerDeath", "impulseAchDeath", function(victim, wep, attacker)
		if not victim.beenSetup or not attacker.beenSetup then
			return
		end

		attacker = attacker or (((wep:GetClass() or "") == "env_fire") and wep:GetOwner())-- hacky fix for molotov fire

		if not IsValid(attacker) or not attacker:IsPlayer() then
			return
		end

		if not attacker:Alive() then
			attacker:AchievementGive("ach_fromthegrave")
		end

		if (attacker:Team() == TEAM_CP and attacker:GetTeamRank() == RANK_I4 and wep:GetClass() == "plutonic_stunstick") and (victim.HasTier3Vest or victim.HasEliteOTAVest) then
			attacker:AchievementGive("ach_chadi5")
		end

		if (attacker:IsCP() and victim.UsedEnrichedVortessence) then
			attacker:AchievementGive("ach_vort")
		end

		if not attacker:IsCP() and (victim:Team() == TEAM_CP and victim.IsAugmented) then
			attacker:AchievementGive("ach_scar")
		end

		if attacker:Team() == TEAM_CP and (victim.HasTier3Vest or victim.HasEliteOTAVest) then
			attacker:AchievementGive("ach_cpgod") 
		end

		if (not attacker:IsCP()) and (victim:Team() == TEAM_OTA and victim:GetTeamRank() != RANK_OSC and victim:GetTeamClass() == CLASS_FIST) then
			attacker:AchievementGive("ach_elite") 
		end

		local invWeight = victim.InventoryWeight or 0

		if invWeight >= 15 then
			victim:AchievementGive("ach_deadweight")
		end

		if wep and IsValid(wep) and victim:GetPos():DistToSqr(attacker:GetPos()) >= 15500047.7401 then -- 100m in unrooted src units
			attacker:AchievementGive("ach_quickshot")
		end

		if victim:SteamID64() == "76561198207757255" then  -- thrawn
			attacker:AchievementGive("ach_vin")
		end

		if victim:Team() == TEAM_ZOMBIE then
			attacker:AchievementGive("ach_entity")
		end

		if victim:IsSuperAdmin() and victim:SteamID64() == "76561199123350968" or victim:SteamID64() == "76561198207757255" then -- thrawn and jake
			attacker:AchievementGive("ach_sd")
		end

		if victim:SteamID64() == "76561198207757255" then -- jake is gay
			attacker:AchievementGive("ach_gay")
		end

		if not attacker:IsCP() then
			if victim:Team() == TEAM_CP then
				attacker:AchievementGive("ach_unknownkiller")
			end

			if attacker:Health() == 1 and victim:Team() == TEAM_OTA and victim:GetTeamClass() then
				attacker:AchievementGive("ach_closeshave")
			end

			if victim:Team() == TEAM_CP and victim:GetTeamRank() == RANK_CMD then
				attacker:AchievementGive("ach_kingpin")
			end

			if victim:Team() == TEAM_OTA and victim:GetTeamRank() == RANK_OSC then
				attacker:AchievementGive("ach_takeover")
			end
		end

		if victim:GetXP() <= 30 then
			attacker:AchievementGive("ach_bambikiller")
		end

		if victim:GetMoney() >= 1000 then
			victim:AchievementGive("ach_costlydeath")
		end

		if wep and IsValid(wep) and wep:GetClass() == "plutonic_pickaxe" and victim:Team() == TEAM_OTA then
			attacker:AchievementGive("ach_clobberer")
		end
	end)

	hook.Add("PlayerPickupItem", "impulseAchCheckWitchTea", function(ply, itemClass)
		if itemClass == "food_witchtea" and not ply:AchievementHas("ach_teaparty") then
			ply:AchievementGive("ach_teaparty")
		end
	end)	

	hook.Add("PlayerAddSkillXP", "impulseAchXP", function(ply)
		ply:AchievementCheck("ach_jackofalltrades")
	end)

	hook.Add("PlayerAddUserToDoor", "impulseAchDoor", function(ply, owners)
		if table.Count(owners) == 9 then
			ply:AchievementGive("ach_ourhouse")
		end
	end)

	local dancers = {}
	hook.Add("PlayerShouldTaunt", "impulseAchTaunt", function(ply, act)
		if act == 1642 then
			local pos = table.insert(dancers, ply)

			timer.Simple(12, function()
				dancers[pos] = nil
			end)

			if table.Count(dancers) > 14 then
				for v,k in pairs(dancers) do
					if IsValid(k) then
						k:AchievementGive("ach_party")
					end
				end

				dancers = {}
			end
		end
	end)

	hook.Add("PlayerCraftItem", "impulseAchCraft", function(ply, class)
		if class == "wep_axe" then
			ply:AchievementGive("ach_axe")
		end
		if class == "wep_tau" then
			ply:AchievementGive("ach_tau")
		end
	end)

	hook.Add("PlayerGetXP", "impulseAchXP", function(ply, amount)
		ply:AchievementCheck("ach_addict")
	end)

	net.Receive("impulseAchPUTCWin", function(len, ply)
		if not ply.OWOUSoWarm and ply.beenSetup then
			ply.OWOUSoWarm = true
			ply:AchievementGive("ach_pickupthatcan")
		end
	end)
else
	hook.Add("PickUpThatCanWin", "impulseAchPUTC", function()
		net.Start("impulseAchPUTCWin")
		net.SendToServer()
	end)
end
