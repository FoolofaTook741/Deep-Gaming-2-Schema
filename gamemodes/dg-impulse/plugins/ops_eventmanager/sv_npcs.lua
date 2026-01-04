function PLUGIN:PlayerSpawnedNPC(ply, npc)
	if npc.SuperAdminOnly == true and !ply:IsSuperAdmin() then
		npc:Remove()
		ply:Notify("This NPC is SuperAdmin Only!")
		return
	end 
	npc:SetSpawnEffect(false)
	npc:SetKeyValue("spawnflags", npc:GetSpawnFlags() + SF_NPC_NO_WEAPON_DROP)

	if ply:GetMoveType() == MOVETYPE_NOCLIP and (ply:IsAdmin() or ply:IsGameMaster()) then
		for v,k in pairs(player.GetAll()) do
 			if k.IsAdmin(k) and k.GetMoveType(k) == MOVETYPE_NOCLIP then
 				npc:AddEntityRelationship(k, D_NU, 99)
 			end
 		end
	end
end