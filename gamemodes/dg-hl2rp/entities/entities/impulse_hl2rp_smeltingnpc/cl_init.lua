include("shared.lua")
print("SMELTING NPC CL_INIT LOADED")

ENT.AutomaticFrameAdvance = true

function ENT:Initialize()
	self:SetSequence(2)
	self:SetPlaybackRate(1)
	self:SetCycle(0)
	self:ResetSequenceInfo()
end

function ENT:Think()
	self:FrameAdvance(FrameTime())
	self:SetNextClientThink(CurTime())
	return true
end

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos() + Vector(0, 0, 82)
	local ang = (EyePos() - pos):Angle()
	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), -90)

	cam.Start3D2D(pos, ang, 0.1)
		draw.SimpleTextOutlined("REFINERY FOREMAN", "BudgetLabel", 0, 0, Color(255, 200, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 200))
		draw.SimpleTextOutlined("[ USE to interact ]", "DebugFixed", 0, 22, Color(200, 200, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 180))
	cam.End3D2D()
end

hook.Add("OnEntityCreated", "SmeltingNPCAnimStart", function(ent)
	if ent:GetClass() == "impulse_hl2rp_smeltingnpc" then
		timer.Simple(0.5, function()
			if IsValid(ent) then
				local seqID = ent:LookupSequence("idle_subtle")
				print("SEQ ID: " .. tostring(seqID))
				ent:SetSequence(seqID)
				ent:SetPlaybackRate(1)
				ent:SetCycle(0)
				ent:ResetSequenceInfo()
			end
		end)
	end
end)