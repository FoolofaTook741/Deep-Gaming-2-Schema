local ITEM = {}

ITEM.UniqueID = "item_crimescenekit"
ITEM.Name = "Clean Up Kit"
ITEM.Desc =  "Can be used to clean up and dismantle illegal items or illegally placed items."
ITEM.Category = "Combine Tools"
ITEM.Model = Model("models/props_c17/BriefCase001a.mdl")
ITEM.FOV = 40.113180515759
ITEM.CamPos = Vector(-10, 25, 9)
ITEM.NoCenter = true
ITEM.Weight = 0.2

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = false

ITEM.UseName = "Clean Up"
ITEM.UseWorkBarTime = 5
ITEM.UseWorkBarName = "Cleaning..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "physics/metal/metal_box_impact_hard1.wav"

function ITEM:OnUse(ply, trace)
	local owner = trace:CPPIGetOwner()
	if owner and (trace:GetClass() == "prop_physics" or trace:GetClass() == "gb_rp_sign") then
		if (ply:Team() == TEAM_CP and owner:IsCP() and ply:GetTeamRank() >= RANK_OFC) or (ply:Team() == TEAM_OTA and owner:IsCP() and ply:GetTeamRank() >= RANK_CCP) then
			ply:Notify("You have successfully cleaned up the object.")
			trace:Remove()
			return false
		end
		if owner:IsCP() then
			ply:Notify("You cannot remove Combine owned props.")
			return false
		end
		if ply:Team() == TEAM_CP and ply:GetTeamRank() > 2 then
			ply:Notify("You have successfully cleaned up the object.")
			trace:Remove()
			return false
		elseif ply:Team() == TEAM_OTA and ply:GetTeamRank() > 1 then
			ply:Notify("You have successfully cleaned up the object.")
			trace:Remove()
			return false
		else
			ply:Notify("You are not a high enough rank to remove player owned props.")
			return false
		end
	elseif owner and trace:GetClass() == "gmod_wire_expression2" then
		if owner:IsCP() then
			ply:Notify("You cannot remove Combine owned E2's.")
			return false
		end
		if ply:Team() == TEAM_CP and ply:GetTeamRank() > 2 then
			ply:Notify("You have successfully cleaned up the object.")
			trace:Remove()
			return false
		elseif ply:Team() == TEAM_OTA and ply:GetTeamRank() > 1 then
			ply:Notify("You have successfully cleaned up the object.")
			trace:Remove()
			return false
		else
			ply:Notify("You are not a high enough rank to remove player owned props.")
			return false
		end
	elseif owner and trace:GetClass() == "prop_physics" then
		if trace:GetClass() == "prop_physics" and owner:IsPlayer() == false then
			ply:Notify("You cannot remove world props you piece of shit.")
			return false
		end
	elseif not owner and trace:GetClass() == "prop_physics" then
		ply:Notify("You cannot remove world props you piece of shit.")
		return false
	elseif trace:GetClass() != "prop_physics" then
		ply:Notify("You have successfully cleaned up the object.")
		trace:Remove()
		return false
	else
		ply:Notify("You cannot interact with this object.")
		return false
	end
end

function ITEM:ShouldTraceUse(ply, ent)
	return ent:GetClass() == "impulse_bench" or ent:GetClass() == "deep_signaljammer" or ent:GetClass() == "gmod_wire_expression2" or ent:GetClass() == "deep_bulletpress" or ent:GetClass() == "deep_blremovalstation" or ent:GetClass() == "chensammocrate" or ent:GetClass() == "deep_refinery" or ent:GetClass() == "deep_hedgehog" or ent:GetClass() == "impulse_bench" or ent:GetClass() == "impulse_hl2rp_brewingbarrel" or ent:GetClass() == "deep_generator" or ent:GetClass() == "prop_physics" or ent:GetClass() == "gb_rp_sign"
end

impulse.RegisterItem(ITEM)
