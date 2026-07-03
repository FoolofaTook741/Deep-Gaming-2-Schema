hook.Add("PlayerNoClip", "opsNoclip", function(ply, state)
	if ply:IsAdmin() or ply:IsGameMaster() then
		if SERVER then
			if state then
				impulse.Ops.Cloak(ply)
				ply:GodEnable()
				ply:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
				ply:SetNoTarget(true)
				ply.FlashSafe = true

				if ply:FlashlightIsOn() then
					ply:Flashlight(false)
				end

				ply:AllowFlashlight(false)
			else
				impulse.Ops.Uncloak(ply)
				ply:GodDisable()
				ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
				ply:AllowFlashlight(true)
				ply:SetNoTarget(false)
			
				ply.RecentlyNoclipped = true 

				timer.Simple(60, function()
					ply.RecentlyNoclipped = false
				end)

				if not ply:HasEquippedItem("cos_gp5gasmask") and not ply:HasEquippedItem("cos_conscriptarmor") then
			        ply.FlashSafe = false
			    end
			end
		end

		return true
	end

	return false
end)