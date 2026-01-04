include("shared.lua")
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:DrawTranslucent()
	self:DrawModel()

	local white = Color(255,255,255)
	local red = Color (255,100,100)
	local dzialko = self:GetNWEntity("dzialko")
	local laser = Material("sprites/bluelaser1")

	--if self:GetNWBool("RedAlert",false) then dzialko:EmitSound("npc/scanner/combat_scan_loop1.wav")	hhhhmmmmm
	--end
	
	if dzialko:IsValid() && self:GetNWBool("RedAlert",true) then
			local tr = util.TraceLine({start = dzialko:GetAttachment(1).Pos,endpos = dzialko:GetForward() * 99999999})
			render.SetMaterial(laser)
			render.DrawBeam(dzialko:GetAttachment(1).Pos,tr.HitPos,0.8,0,0,self:GetLaserColor():ToColor())
	end

	if dzialko:IsValid() then
	  	if self:GetNWBool("RedAlert",false) then
			    render.SetMaterial(Material("sprites/glow04_noz"))
			    render.DrawSprite( dzialko:GetPos() + dzialko:GetUp() * 3.5 + dzialko:GetForward() * 7 + dzialko:GetRight() * -2.9,2.7,2.7,red)
	   		else
			    render.SetMaterial(Material("sprites/glow04_noz"))
			    render.DrawSprite( dzialko:GetPos() + dzialko:GetUp() * 3.5 + dzialko:GetForward() * 7 + dzialko:GetRight() * -2.9,2.7,2.7,white)
		end
	end
end