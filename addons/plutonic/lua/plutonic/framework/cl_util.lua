--- The core level functionality of Plutonic.
-- @perlin Framework
--- Rotates a point around another point.
-- @realm client
-- @vector pos The position of the point to rotate.
-- @angle ang The angle of the point to rotate.
-- @vector point The point to rotate around.
-- @vector offset The offset of the point to rotate.
-- @angle offset_ang The angle of the offset of the point to rotate.
-- @treturn vector The rotated position.
-- @treturn angle The rotated angle.
function Plutonic.Framework.RotateAroundPoint(pos, ang, point, offset, offset_ang)
    local mat = Matrix()
    mat:SetTranslation(pos)
    mat:SetAngles(ang)
    mat:Translate(point)
    local rot_mat = Matrix()
    rot_mat:SetAngles(offset_ang)
    rot_mat:Invert()
    mat:Mul(rot_mat)
    mat:Translate(-point)
    mat:Translate(offset)

    return mat:GetTranslation(), mat:GetAngles()
end

Plutonic.Noise = Plutonic.Noise or {}
--- Generates a 2D simplex noise value.
-- @realm client
-- @number x The x coordinate.
-- @number y The y coordinate.
-- @number scale The scale of the noise.
-- @number octaves The number of octaves.
-- @number persistence The persistence of the noise.
-- @number lacunarity The lacunarity of the noise.
-- @number seed The seed of the noise.
-- @treturn number The noise value.
function Plutonic.Noise.Simplex2D(x, y, scale, octaves, persistence, lacunarity, seed)
    local noise = 0
    local frequency = scale
    local amplitude = 1
    local max_value = 0
    local total_amplitude = 0
    for i = 1, octaves do
        noise = noise + util.SimplexNoise(x * frequency, y * frequency, seed) * amplitude
        max_value = max_value + amplitude
        total_amplitude = total_amplitude + amplitude
        amplitude = amplitude * persistence
        frequency = frequency * lacunarity
    end

    return noise / max_value
end

perlin = {}
perlin.p = {}
-- Hash lookup table as defined by Ken Perlin
-- This is a randomly arranged array of all numbers from 0-255 inclusive
local permutation = {151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225, 140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23, 190, 6, 148, 247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32, 57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175, 74, 165, 71, 134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111, 229, 122, 60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244, 102, 143, 54, 65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169, 200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64, 52, 217, 226, 250, 124, 123, 5, 202, 38, 147, 118, 126, 255, 82, 85, 212, 207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42, 223, 183, 170, 213, 119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9, 129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104, 218, 246, 97, 228, 251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241, 81, 51, 145, 235, 249, 14, 239, 107, 49, 192, 214, 31, 181, 199, 106, 157, 184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254, 138, 236, 205, 93, 222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180}
-- p is used to hash unit cube coordinates to [0, 255]
for i = 0, 255 do
    -- Convert to 0 based index table
    perlin.p[i] = permutation[i + 1]
    -- Repeat the array to avoid buffer overflow in hash function
    perlin.p[i + 256] = permutation[i + 1]
end

-- Return range: [-1, 1]
function perlin:noise(x, y, z)
    y = y or 0
    z = z or 0
    -- Calculate the "unit cube" that the point asked will be located in
    local xi = bit.band(math.floor(x), 255)
    local yi = bit.band(math.floor(y), 255)
    local zi = bit.band(math.floor(z), 255)
    -- Next we calculate the location (from 0 to 1) in that cube
    x = x - math.floor(x)
    y = y - math.floor(y)
    z = z - math.floor(z)
    -- We also fade the location to smooth the result
    local u = self.fade(x)
    local v = self.fade(y)
    local w = self.fade(z)
    -- Hash all 8 unit cube coordinates surrounding input coordinate
    local p = self.p
    local A, AA, AB, AAA, ABA, AAB, ABB, B, BA, BB, BAA, BBA, BAB, BBB
    A = p[xi] + yi
    AA = p[A] + zi
    AB = p[A + 1] + zi
    AAA = p[AA]
    ABA = p[AB]
    AAB = p[AA + 1]
    ABB = p[AB + 1]
    B = p[xi + 1] + yi
    BA = p[B] + zi
    BB = p[B + 1] + zi
    BAA = p[BA]
    BBA = p[BB]
    BAB = p[BA + 1]
    BBB = p[BB + 1]
    -- Take the weighted average between all 8 unit cube coordinates

    return self.lerp(w, self.lerp(v, self.lerp(u, self:grad(AAA, x, y, z), self:grad(BAA, x - 1, y, z)), self.lerp(u, self:grad(ABA, x, y - 1, z), self:grad(BBA, x - 1, y - 1, z))), self.lerp(v, self.lerp(u, self:grad(AAB, x, y, z - 1), self:grad(BAB, x - 1, y, z - 1)), self.lerp(u, self:grad(ABB, x, y - 1, z - 1), self:grad(BBB, x - 1, y - 1, z - 1))))
end

-- Gradient function finds dot product between pseudorandom gradient vector
-- and the vector from input coordinate to a unit cube vertex
perlin.dot_product = {
    [0x0] = function(x, y, z) return x + y end,
    [0x1] = function(x, y, z) return -x + y end,
    [0x2] = function(x, y, z) return x - y end,
    [0x3] = function(x, y, z) return -x - y end,
    [0x4] = function(x, y, z) return x + z end,
    [0x5] = function(x, y, z) return -x + z end,
    [0x6] = function(x, y, z) return x - z end,
    [0x7] = function(x, y, z) return -x - z end,
    [0x8] = function(x, y, z) return y + z end,
    [0x9] = function(x, y, z) return -y + z end,
    [0xA] = function(x, y, z) return y - z end,
    [0xB] = function(x, y, z) return -y - z end,
    [0xC] = function(x, y, z) return y + x end,
    [0xD] = function(x, y, z) return -y + z end,
    [0xE] = function(x, y, z) return y - x end,
    [0xF] = function(x, y, z) return -y - z end
}

function perlin:grad(hash, x, y, z)
    return self.dot_product[bit.band(hash, 0xF)](x, y, z)
end

-- Fade function is used to smooth final output
function perlin.fade(t)
    return t * t * t * (t * (t * 6 - 15) + 10)
end

function perlin.lerp(t, a, b)
    return a + t * (b - a)
end

--- Generates a 3D perlin noise value.
-- @realm client
-- @number x The x coordinate.
-- @number y The y coordinate.
-- @number z The z coordinate.
Plutonic.Noise.Perlin = function(x, y, z) return perlin:noise(x, y, z) end
_Plutonic.BenchmarkCVar = CreateConVar("plutonic_benchmark", "0", FCVAR_ARCHIVE, "Benchmark plutonic functions.")
_Plutonic.BenchmarkData = _Plutonic.BenchmarkData or {}
_Plutonic.FirstBenchmark = 0
_Plutonic.LastBenchmark = 0
Plutonic.Benchmark = function() return _Plutonic.BenchmarkCVar:GetBool() end
Plutonic.BenchmarkStart = function(name)
    if not Plutonic.Benchmark() then return end
    _Plutonic.BenchmarkData[name] = _Plutonic.BenchmarkData[name] or {0, {}, false}
    if _Plutonic.BenchmarkData[name][3] then return end -- Benchmark already started
    _Plutonic.BenchmarkData[name][3] = true
    _Plutonic.BenchmarkData[name][1] = _Plutonic.BenchmarkData[name][1] + 1
    table.insert(_Plutonic.BenchmarkData[name][2], {SysTime(), SysTime()})
end

Plutonic.BenchmarkEnd = function(name)
    if not Plutonic.Benchmark() then return end
    local data = _Plutonic.BenchmarkData[name]
    if not data then return end
    if not data[3] then return end -- Benchmark not started
    data[3] = false
    data[2][#data[2]][2] = SysTime()
    data[2][#data[2]][3] = data[2][#data[2]][2] - data[2][#data[2]][1]
end

Plutonic.BenchmarkPrint = function()
    if not Plutonic.Benchmark() then return end
    for k, v in pairs(_Plutonic.BenchmarkData) do
        print("\nBenchmark: " .. k)
        print("Runs: " .. v[1])
        local total = 0
        for i = 1, #v[2] do
            local time = v[2][i][3]
            total = total + time
            if v[1] > 0 and v[1] <= 50 then
                print("\tRun " .. i .. ": " .. time .. "s")
            end
        end

        print("Total: " .. math.Round(total * 1000, 8) .. "ms")
        print("Average: " .. math.Round((total / #v[2]) * 1000, 8) .. "ms")
    end
end

Plutonic.BenchmarkClear = function()
    if not Plutonic.Benchmark() then return end
    _Plutonic.BenchmarkData = {}
end

local function Benchmark()
    Plutonic.BenchmarkPrint()
    Plutonic.BenchmarkClear()
end

concommand.Add("plutonic_benchmark_print", Benchmark)
local flipFloppa = 0
Plutonic.Sounds = {
    ["Plutonic.Sprint"] = {"weapons/movement/weapon_movement_sprint1.wav", "weapons/movement/weapon_movement_sprint2.wav", "weapons/movement/weapon_movement_sprint3.wav", "weapons/movement/weapon_movement_sprint4.wav", "weapons/movement/weapon_movement_sprint5.wav", "weapons/movement/weapon_movement_sprint6.wav", "weapons/movement/weapon_movement_sprint7.wav", "weapons/movement/weapon_movement_sprint8.wav", "weapons/movement/weapon_movement_sprint9.wav"},
    ["Plutonic.Walk"] = {"weapons/movement/weapon_movement_walk1.wav", "weapons/movement/weapon_movement_walk2.wav", "weapons/movement/weapon_movement_walk3.wav", "weapons/movement/weapon_movement_walk4.wav", "weapons/movement/weapon_movement_walk5.wav", "weapons/movement/weapon_movement_walk6.wav", "weapons/movement/weapon_movement_walk7.wav", "weapons/movement/weapon_movement_walk8.wav", "weapons/movement/weapon_movement_walk9.wav"}
}

Plutonic.Hooks.Add(
    "PlayerFootstep",
    function(ply, pos, foot, sound, volume, filter)
        if ply == LocalPlayer() then
            local wep = ply:GetActiveWeapon()
            if not IsValid(wep) then return end
            if not wep.IsPlutonic then return end
            flipFloppa = flipFloppa + 1
            if flipFloppa > 8 then
                flipFloppa = 0
            end

            local snd = ply:IsSprinting() and "Plutonic.Sprint" or "Plutonic.Walk"
            ply:EmitSound(table.Random(Plutonic.Sounds[snd]), 45, math.random(95, 105), math.random(0.4, 0.45), CHAN_USER_BASE + 10 + flipFloppa, SND_DELAY, 0)
        end
    end
)