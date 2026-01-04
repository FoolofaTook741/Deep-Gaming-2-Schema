D47_ALLOWZOMBIES = true -- let zambies spawn D:

local function updateLightmaps()
	if SERVER then
		engine.LightStyle(0, "e")
	else
		timer.Simple(1, function()
			render.RedownloadAllLightmaps(true, true)
		end)
	end
end

if SERVER then
	function PLUGIN:InitPostEntity()
		updateLightmaps()
		
		for v,k in pairs(ents.FindByClass("env_sun")) do
			k:Remove()
		end

		RunConsoleCommand("sv_skyname", "painted")

		local ent = ents.FindByClass("env_skypaint") and ents.FindByClass("env_skypaint")[1] or ents.Create("env_skypaint")
		ent:Spawn()
		ent:Activate()
		
		ent:SetTopColor(Vector(0.01, 0.02, 0.01))
		ent:SetBottomColor(Vector(0, 0, 0.02))
		ent:SetFadeBias(0.75)
		ent:SetHDRScale(0.67)
		ent:SetDuskIntensity(1)
		ent:SetDuskColor(Vector(0, 0, 0))
		ent:SetSunColor(Vector(0, 0, 0))

		-- d47 spotlight cols
		for v,k in pairs(ents.FindInSphere(Vector(-49.96382522583, -501.8098449707, 388.03125), 500)) do
			if k:GetClass() == "point_spotlight" then
				k:Fire("SetColor", "255 0 0")
			end
		end
	end
else
	function PLUGIN:GetFrameworkLogoColour()
		return Color(252, 70, 5), Color(148, 1, 148)
	end
end

function PLUGIN:OnSchemaLoaded()
	local bmd = impulse.Vendor.Data["bmd"]

	if bmd then
		bmd.Name = "Dead Market Dealer"
		bmd.Desc = "Can trade contraband items... From the deaddddddddddddddddddd!"
		bmd.Model = "models/zombie/classic.mdl"
		bmd.Bodygroups = "01"
		bmd.Gender = "zombie"

		for v,k in pairs(ents.FindByClass("impulse_vendor")) do
			if k.Vendor and k.Vendor.UniqueID == "bmd" then
				k:SetModel(bmd.Model)
				k:SetIdleSequence("idle01")
				k:SetBodyGroups(bmd.Bodygroups)
			end
		end
	end

	local cpRankGive = ents.FindByClass("impulse_hl2rp_cp_npc")

	for v,k in pairs(cpRankGive) do
		k:SetModel("models/dpfilms/metropolice/zombie_police.mdl")
		k:SetBodygroup(1, 1)
	end
end