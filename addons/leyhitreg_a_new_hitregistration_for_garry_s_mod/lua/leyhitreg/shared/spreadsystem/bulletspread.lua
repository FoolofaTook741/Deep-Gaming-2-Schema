local Vector = Vector
local mathmodf = math.modf
local mathrandomseed = math.randomseed
local mathrandom = math.random
local mathsqrt = math.sqrt
local isnumber = isnumber
local vector_origin = vector_origin

function LeyHitreg:ApplyBulletSpread(ply, wep, dir, spread)
	if (LeyHitreg.NoSpread) then
		return true, dir, vector_origin
	end
	
	if wep and (wep.IsShotgun or (wep.Primary and wep.Primary.NumShots and wep.Primary.NumShots > 1)) then 
		return true, dir, vector_origin -- spread is applied to the bullet itself, not a directional offset
	end 

	if (not spread or spread == vector_origin or LeyHitreg.BrokenSpread) then
		return false
	end

	if (isnumber(spread)) then
		spread = Vector(spread, spread, spread)
	end

	local ang = dir:Angle()

	local appliedSpread, rgt, up = Vector(), ang:Right(), ang:Up()

	local x, y, z
    local rand = 10

	repeat
		x = util.SharedRandom("spreadX", 0, 1, rand) + util.SharedRandom("spreadX_2", 0, 1, rand) - 1
		y = util.SharedRandom("spreadY", 0, 1, rand) + util.SharedRandom("spreadY_2", 0, 1, rand) - 1

		z = x * x + y * y
        rand = rand + 10
	until z <= 1

	for i = 1, 3 do
		appliedSpread[i] = x * spread.x * rgt[i] + y * spread.y * up[i]
	end

	dir = dir + appliedSpread

	return true, dir, appliedSpread
end
