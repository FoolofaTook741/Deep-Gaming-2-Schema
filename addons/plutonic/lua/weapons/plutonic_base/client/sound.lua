--      Copyright (c) 2022-2023, sophie S. All rights reserved      --
-- Plutonic is a project built for L̶a̶n̶d̶i̶s̶ ̶G̶a̶m̶e̶s̶. (opensrc updated by zachun). --
local passthroughMaterials = {
	[MAT_GRATE] = true,
	[MAT_GLASS] = true,
	[MAT_FLESH] = true
}

net.Receive(
	"Longsword.EmitSound",
	function()
		local entity = net.ReadEntity()
		local owner = net.ReadEntity()
		local snd = net.ReadString()
		local pitch = net.ReadUInt(8) -- Read the pitch value
		local dsp = 0
		if not IsValid(entity) then return end -- Edge case where entity is invalid
		if owner == LocalPlayer() then
			local shouldPlay = impulse and impulse.GetSetting("view_thirdperson", false)
			if shouldPlay then
				entity:EmitSound(snd, nil, nil, nil, nil, pitch, dsp) -- Use the pitch parameter
			end
		else
			if not IsValid(owner) then return end
			local tr = util.TraceLine(
				{
					start = LocalPlayer():EyePos(),
					endpos = LocalPlayer():EyePos() + Vector(0, 0, 10000),
					filter = function(ent)
						if ent:IsPlayer() then return false end
						return true
					end
				}
			)

			local inside = true
			if tr.HitSky and not passthroughMaterials[tr.MatType] then
				inside = false
			end

			-- trace to the owner
			tr = util.TraceLine(
				{
					start = LocalPlayer():EyePos(),
					endpos = owner:EyePos(),
					mask = MASK_BLOCKLOS
				}
			)

			local rHit = tr.Hit
			if tr.HitEntity == owner then
				rHit = false
			end

			if tr.Hit == LocalPlayer() then
				rHit = false
			end

			local sourceInSameRoom = false
			local rtr = util.TraceLine(
				{
					start = owner:EyePos(),
					endpos = owner:EyePos() + Vector(0, 0, 10000),
					mask = MASK_BLOCKLOS
				}
			)

			if rtr.HitSky and (not inside) then
				sourceInSameRoom = true
			end

			if rHit and not sourceInSameRoom and owner:GetPos():DistToSqr(LocalPlayer():GetPos()) < 900 ^ 2 then
				rHit = false
			end

			if rHit and inside then
				dsp = 31
			elseif inside then
				dsp = 0
			elseif rHit then
				dsp = 124
			else
				dsp = 0
			end

			entity:EmitSound(snd, nil, nil, nil, nil, pitch, dsp) -- Use the pitch parameter
		end
	end
)

net.Receive(
	"Longsword.Echo",
	function()
		local _ = net.ReadBool()
		local __ = net.ReadVector()
		local srcEntity = net.ReadUInt(16)
		local snd = net.ReadString()
		local tr = util.TraceLine(
			{
				start = LocalPlayer():EyePos(),
				endpos = LocalPlayer():EyePos() + Vector(0, 0, 10000),
				filter = function(ent)
					if ent:IsPlayer() then return false end

					return true
				end
			}
		)

		local inside = true
		if tr.HitSky then
			inside = false
		end

		local shouldPlay = true
		if shouldPlay and inside then
			Entity(srcEntity):EmitSound(snd, 140, 100, 0.4, CHAN_WEAPON, SND_NOFLAGS, 1)
		elseif shouldPlay and not inside then
			local ent = Entity(srcEntity)
			if ent:GetPos():DistToSqr(LocalPlayer():GetPos()) > 6000 ^ 2 then
				Entity(srcEntity):EmitSound(snd, 140, 100, 1, CHAN_WEAPON, SND_NOFLAGS, 1)
			end
		end
	end
)

function SWEP:InternalEchoHandle()
	--if not self.Reverb.Primary.Enabled then return end
	if not IsValid(self:GetOwner()) then return end
	local tr = util.TraceLine(
		{
			start = self:GetOwner():EyePos(),
			endpos = self:GetOwner():EyePos() + Vector(0, 0, 10000),
			filter = function(ent)
				if ent:IsPlayer() then return false end

				return true
			end
		}
	)

	local inside = true
	if tr.HitSky then
		inside = false
	end

	self:PrimaryEcho(inside)
end

function SWEP:PrimaryEcho(inside)
	if inside then
		self:EmitSound(self.Primary.Sound, 140, 100, 1, CHAN_WEAPON, SND_NOFLAGS, 104)
	else
		self:EmitSound(self.Primary.Sound, 140, 100, 1, CHAN_WEAPON, SND_NOFLAGS, 21)
	end
end