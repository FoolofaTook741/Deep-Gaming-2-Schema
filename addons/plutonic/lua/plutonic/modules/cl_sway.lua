--[[local abs = math.abs
Plutonic.Hooks.Add(
	"StartCommand",
	function(ply, ucmd)
		if ply.GetActiveWeapon then
			local wep = ply:GetActiveWeapon()
			if IsValid(wep) and wep.IsPlutonic then
				local x, y = ucmd:GetMouseX(), ucmd:GetMouseY()
				local i = wep.SwayMultiplier or 0.0004
				local n = wep.SwayMultiplier or 0.0056
				local m = wep:GetIronsights() and i or n
				if abs(x) > 0 or abs(y) > 0 then
					wep.VMDeltaX = wep.VMDeltaX + ucmd:GetMouseX() * m
					wep.VMDeltaY = wep.VMDeltaY + ucmd:GetMouseY() * m
					wep.VMDeltaXWeighted = wep.VMDeltaXWeighted + ucmd:GetMouseX() * .01
					wep.VMDeltaYWeighted = wep.VMDeltaYWeighted + ucmd:GetMouseY() * .01
				end
			end
		end
	end
)

Plutonic.Hooks.Add(
	"RenderScreenspaceEffects",
	function()
		local lp = LocalPlayer()
		if not IsValid(lp) then return end
		local wep = lp:GetActiveWeapon()
		if not IsValid(wep) then return end
		if not wep.IsPlutonic then return end
		local ir = wep.VMIronsights or 0
		if ir <= 0 then return end
		DrawToyTown(12 * ir, ScrH() / 2.2)
	end
)]]