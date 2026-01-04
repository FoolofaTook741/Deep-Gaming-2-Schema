local beltData = {
	["plutonic_minigun"] = {
		Bone = "ValveBiped.Bip01_Spine2",
		Data = {
			model = "models/minigun_model/weapons/w_minigun.mdl",
			pos = Vector(5, 3, 4.2),
			ang = Angle(0, 96, 20),
			scale = 0.88
		}
	},
	["plutonic_m249"] = {
		Bone = "ValveBiped.Bip01_Spine2",
		Data = {
			model = "models/weapons/arccw_go/v_mach_m249para.mdl",
			pos = Vector(-3, -26, -2),
			ang = Angle(0, 0, 20),
			scale = 0.88
		}
	},
	["plutonic_357"] = {
		Bone = "ValveBiped.Bip01_Pelvis",
		Data = {
			model = "models/weapons/w_357.mdl",
			pos = Vector(-1.2, -8, -0),
			ang = Angle(-66, -90, 65),
			scale = 0.8
		}
	},
}

local LocalPlayer = LocalPlayer
local pairs = pairs
local IsValid = IsValid
local function beltCheck(ent, isPanel)
	local ply = isPanel and LocalPlayer() or ent
	local weps = ply.GetWeapons(ply)
	local active = ply.GetActiveWeapon(ply)
	local activeClass = IsValid(active) and active:GetClass() or nil
	ply.CivBeltCos = ply.CivBeltCos or {}

	for v,k in pairs(ply.CivBeltCos) do
		if not ply:HasWeapon(v) then
			RemoveCosmetic(ply, ply, "belt_"..v)
			ply.CivBeltCos[v] = nil
		end
	end

	for v,k in pairs(weps) do
		local class = k.GetClass(k)
		local beltId = "belt_"..class

		if not beltData[class] then
			continue
		end

		if activeClass and activeClass == class then
			if ply.Cosmetics and ply.Cosmetics[beltId] then
				RemoveCosmetic(ply, ply, beltId)
				ply.CivBeltCos[class] = nil
			end

			continue
		end

		--if not ply.Cosmetics or not ply.Cosmetics[beltId] then
			MakeCosmetic(ply, nil, beltData[class].Bone, beltData[class].Data, beltId)
			ply.CivBeltCos[class] = true
		--end
	end
end

hook.Add("PostPlayerDraw", "impulseWeaponsOnBody", function(ply)
	if not ply.Alive(ply) or (ply.Team(ply) != TEAM_WORKER and ply.Team(ply) != TEAM_CITIZEN) then
		if ply.CivBeltCos then
			for v,k in pairs(ply.CivBeltCos) do
				RemoveCosmetic(ply, ply, "belt_"..v)
			end

			ply.CivBeltCos = nil
		end

		return
	end

	beltCheck(ply)
end)