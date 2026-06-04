local ActiveRappels = ActiveRappels or {}

local ropeMat = Material("cable/cable2")

net.Receive("landisRappelStart", function()

	local ply = net.ReadEntity()
	local anchor = net.ReadVector()
	local boneName = net.ReadString()
	local length = net.ReadFloat()

	if not IsValid(ply) then return end

	ActiveRappels[ply] = {
		anchor = anchor,
		boneName = boneName,
		length = length
	}

end)

net.Receive("landisRappelStop", function()

	local ply = net.ReadEntity()

	if IsValid(ply) then
		ActiveRappels[ply] = nil
	end

end)

net.Receive("landisRappelUpdate", function()

	local ply = net.ReadEntity()
	local length = net.ReadFloat()

	if not IsValid(ply) then return end
	if not ActiveRappels[ply] then return end

	ActiveRappels[ply].length = length

end)

hook.Add("PostDrawTranslucentRenderables", "DrawRappelRopes", function()

	render.SetMaterial(ropeMat)

	for ply, data in pairs(ActiveRappels) do

		if not IsValid(ply) or not ply:Alive() then
			ActiveRappels[ply] = nil
			continue
		end

		local boneI = ply:LookupBone(data.boneName)
		if not boneI then continue end

		local bonePos = ply:GetBonePosition(boneI)
		if not bonePos then continue end

		local distance = bonePos:Distance(data.anchor)
		local textureEnd = distance / 64

		render.DrawBeam(
			bonePos,
			data.anchor,
			2,
			0,
			textureEnd,
			color_black
		)

	end

end)