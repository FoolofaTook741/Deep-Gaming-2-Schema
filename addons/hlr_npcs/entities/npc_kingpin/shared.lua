ENT.Base = "npc_creature_base"
ENT.Type = "ai"

ENT.PrintName = "Kingpin"
ENT.Category = "Half-Life NPCs"

if (CLIENT) then
	language.Add("npc_kingpin", "Kingpin")
	usermessage.Hook("Kingpin_SetShieldScale", function(um)
		local ent = um:ReadEntity()
		local scale = um:ReadShort()
		if !IsValid(ent) || !scale then return end
		scale = scale /100
		ent.scale = Vector(scale, scale, scale)
		ent.BuildBonePositions = ent.BuildBonePositions || function(self, NumBones, NumPhysBones)
			local scale = self.scale
			if scale then
				local iBone = self:LookupBone("Bip01")
				local boneMat = self:GetBoneMatrix(iBone)
				boneMat:Scale(scale)
				self:SetBoneMatrix(iBone, boneMat)
			end
		end
	end)
end
