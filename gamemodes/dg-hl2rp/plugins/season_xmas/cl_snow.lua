impulse.DefineSetting("xmas_snow", {name="Snow enabled", category="Christmas", type="tickbox", default=true})
impulse.DefineSetting("xmas_breathfx", {name="Cold breath enabled", category="Christmas", type="tickbox", default=true})
impulse.DefineSetting("xmas_snowlife", {name="Snow render lifetime", category="Christmas", type="slider", default=30, minValue=10, maxValue=120})
impulse.DefineSetting("xmas_snowamount", {name="Snow amount", category="Christmas", type="slider", default=38, minValue=5, maxValue=60})


-- cold breath from stormfox
local m_mats = {
	(Material("particle/smokesprites_0001")),
	(Material("particle/smokesprites_0002")),
	(Material("particle/smokesprites_0003"))
}

local clamp = math.Clamp
local function breath(ply,size)
	if not ply:Alive() then return end
	if size <= 0 then return end
	if ply:WaterLevel() >= 3 then return end

	if not emit then
		emit = ParticleEmitter(LocalPlayer():GetPos(),false)
	else
		emit:SetPos(LocalPlayer():GetPos())
	end

	local mpos
	if GetViewEntity() ~= ply then
		local att = ply:LookupAttachment("mouth")
		if att <= 0 then return end
		mpos = ply:GetAttachment(att)
	else
		local ang,pos = EyeAngles(), ply:EyePos()
		mpos = {Pos = pos + ang:Forward() * 3 - ang:Up() * 2,Ang = ang}
	end

	if not mpos or not mpos.Pos then 
		return
	end

	local p = emit:Add(table.Random(m_mats),mpos.Pos)
	p:SetStartSize(1)
	p:SetEndSize(size)
	p:SetStartAlpha(math.random(25,35))
	p:SetEndAlpha(0)
	p:SetLifeTime(0)
	p:SetGravity(Vector(0,0,4))
	p:SetDieTime(1)
	p:SetLighting(false)
	p:SetRoll(math.random(360))
	p:SetRollDelta(math.Rand(-0.5,0.5))
	p:SetVelocity(mpos.Ang:Forward() * 2 + ply:GetVelocity() / 5)
end

function PLUGIN:PostPlayerDraw(ply)
	if not impulse.GetSetting("xmas_snow") then return end
	if (ply._sf_breath or 0) > SysTime() then return end
	local len = ply:GetVelocity():Length()
	local t = clamp(1 - (len / 100),0.2,1)

	ply._sf_breath = math.Rand(t,t * 2) + SysTime()
	breath(ply,5 + (len / 100))
end

local nextSnow = 0
function PLUGIN:Think()
	if nextSnow < CurTime() and impulse.GetSetting("xmas_snow", true) then
		local tr = util.TraceLine({
			start = LocalPlayer():EyePos(),
			endpos = LocalPlayer():EyePos() + Vector(0, 0, 10000),
			filter = function(ent)
				if ent:IsPlayer() then 
					return false 
				end

				return true
			end
		})
		LocalPlayer().InSnow = true

		if tr.HitSky then
			LocalPlayer().InSnow = true

			local snow = EffectData()
			snow:SetMagnitude(impulse.GetSetting("xmas_snowamount"))
			snow:SetScale(impulse.GetSetting("xmas_snowlife"))
			snow:SetRadius(LocalPlayer():GetPos().z + 400)
			util.Effect("impulse_snow", snow)

			debugoverlay.Sphere(tr.HitPos, 40, 4, Color(0, 255, 0, 90), true)
		else
			LocalPlayer().InSnow = false
			debugoverlay.Sphere(tr.HitPos, 40, 4, Color(255, 0, 0, 90), true)
		end

		nextSnow = CurTime() + 0.15
	end

	if not impulse.GetSetting("xmas_snow") then return end
	if not LocalPlayer() then return end
	if GetViewEntity() ~= LocalPlayer() then return end
	local ply = LocalPlayer()
	if (ply._sf_breath or 0) > SysTime() then return end
	local len = ply:GetVelocity():Length()
	local t = clamp(1 - (len / 400),0.2,1)
	ply._sf_breath = math.Rand(t,t * 2) + SysTime()
	breath(ply,5 - (len / 50))
end

function PLUGIN:PlayerFootstep(ply)
	if LocalPlayer().InSnow then
		ply:EmitSound("player/footsteps/snow"..math.random(1, 10)..".wav")
		return true
	end
end

local mapData = {
	rp_city17_build210 = {
	    ["maps/rp_city17_build210/stone/stonefloor006a_-500_0_170"] = "nature/snow_002",
		["maps/rp_city17_build210/concrete/concretefloor028c_-500_0_170"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/stone/stonefloor006a_761_2328_138"] = "nature/snow_002",
		["maps/rp_city17_build210/stone/stonefloor006b_761_2328_138"] = "nature/snow_002",
		["maps/rp_city17_build210/concrete/concretefloor028c_150_3310_152"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/concrete/concretefloor028c_761_2328_138"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/stone/stonefloor006a_145_1640_153"] = "nature/snow_002",
		["maps/rp_city17_build210/stone/stonefloor006a_572_2_170"] = "nature/snow_002",
		["maps/rp_city17_build210/stone/stonefloor006b_145_1640_153"] = "nature/snow_002",
		["maps/rp_city17_build210/stone/stonefloor006b_572_2_170"] = "nature/snow_002",
		["maps/rp_city17_build210/concrete/concretefloor028c_572_2_170"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/concrete/concretefloor028d_572_2_170"] = "nature/snowfloor003a",
		["nature/grassfloor002a"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/stone/stonefloor006b_-500_0_170"] = "nature/snow_002",
		["maps/rp_city17_build210/nature/red_grass_wvt_patch"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/concrete/concretefloor028c_145_1640_153"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/concrete/concretefloor028d_145_1640_153"] = "nature/snowfloor003a",
		["concrete/concretefloor019b"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/stone/stonefloor006a_-886_-1600_138"] = "nature/snow_002",
		["maps/rp_city17_build210/stone/stonefloor006a_-192_-1347_133"] = "nature/snow_002",
		["maps/rp_city17_build210/stone/stonefloor006b_-192_-1347_133"] = "nature/snow_002",
		["maps/rp_city17_build210/concrete/concretefloor028c_-192_-1347_133"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/concrete/concretefloor028d_-192_-1347_133"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/concrete/concretefloor019a_-192_-1347_133"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/concrete/concretefloor019a_572_2_170"] = "nature/snowfloor003a",
		["props/rubberroof002a"] = "nature/snowfloor003a",
		["building_template/roof_template001b"] = "nature/snowfloor003a",
		["concrete/concretefloor024a"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/tile/tileroof002a_5188_-1839_2354"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/tile/tileroof003a_5188_-1839_2354"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/tile/tileroof003a_145_1640_153"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/tile/tileroof003a_-500_0_170"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/metal/metalroof006a_-500_0_170"] = "nature/snowfloor001a",
		["maps/rp_city17_build210/metal/metalroof006a_145_1640_153"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/metal/metalroof006a_-2878_-2122_146"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/metal/metalroof006a_-886_-1600_138"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/metal/metalroof006a_572_2_170"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/metal/metalroof006a_-192_-1347_133"] = "nature/snowfloor001a",
		["maps/rp_city17_build210/metal/metalroof006a_-1794_-206_219"] = "nature/snowfloor001a",
		["maps/rp_city17_build210/stone/stonefloor006b_-886_-1600_138"] = "nature/snow_002",
		["maps/rp_city17_build210/concrete/concretefloor028c_-886_-1600_138"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/stone/stonefloor006a_-31_-3654_145"] = "nature/snow_002",
		["maps/rp_city17_build210/stone/stonefloor006b_-31_-3654_145"] = "nature/snow_002",
		["maps/rp_city17_build210/concrete/concretefloor028c_-31_-3654_145"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/concrete/concretefloor033y_-500_0_170"] = "nature/snow_002",
		["maps/rp_city17_build210/concrete/concretefloor028d_-886_-1600_138"] = "nature/snowfloor001a",
		["maps/rp_city17_build210/stone/stonefloor006b_-2409_-3687_132"] = "nature/snow_002",
		["maps/rp_city17_build210/concrete/concretefloor028c_-2409_-3687_132"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/stone/stonefloor006a_-2409_-3687_132"] = "nature/snow_002",
		["concrete/concretefloor036a"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/metal/metalroof006a_-2409_-3687_132"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/metal/metalroof006a_5188_-1839_2354"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/metal/metalroof006a_-2496_-2944_519"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/metal/metalroof006a_-3990_-254_110"] = "nature/snowfloor001a",
		["maps/rp_city17_build210/tile/tileroof002a_-2878_-2122_146"] = "nature/snowfloor001a",
		["maps/rp_city17_build210/concrete/concretefloor028c_-2878_-2122_146"] = "nature/snow_002",
		["maps/rp_city17_build210/stone/stonefloor006b_-2878_-2122_146"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/concrete/concretefloor019a_-2878_-2122_146"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/stone/stonefloor006a_-2878_-2122_146"] = "nature/snowfloor003a",
		["concrete/concretefloor011a"] = "nature/snowfloor001a",
		["maps/rp_city17_build210/tile/tileroof003a_-2496_-2944_519"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/tile/tileroof003b_-2409_-3687_132"] = "nature/snowfloor001a",
		["maps/rp_city17_build210/tile/tileroof003b_5188_-1839_2354"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/tile/tileroof003b_2470_-5131_157"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/stone/stonefloor006a_-2496_-2944_397"] = "nature/snow_002",
		["maps/rp_city17_build210/stone/stonefloor006b_-2496_-2944_397"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/concrete/concretefloor028d_-31_-3654_145"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/concrete/concretefloor019a_-31_-3654_145"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/concrete/concretefloor039a_-31_-3654_145"] = "nature/snowfloor001a",
		["maps/rp_city17_build210/concrete/concretefloor039a_1135_-3929_165"] = "nature/snowfloor001a",
		["maps/rp_city17_build210/concrete/concretefloor039a_1724_-2768_143"] = "nature/snowfloor001a",
		["maps/rp_city17_build210/metal/metalroof005a_5188_-1839_2354"] = "nature/snowfloor001a",
		["maps/rp_city17_build210/metal/metalroof006a_1844_-3854_169"] = "nature/snowfloor001a",
		["maps/rp_city17_build210/metal/metalroof006a_1135_-3929_165"] = "nature/snowfloor001a",
		["maps/rp_city17_build210/metal/metalroof005a_1844_-3854_169"] = "nature/snowfloor001a",
		["maps/rp_city17_build210/metal/metalroof005a_1724_-2768_143"] = "nature/snowfloor001a",
		["maps/rp_city17_build210/metal/metalroof005a_-31_-3654_145"] = "nature/snowfloor001a",
		["maps/rp_city17_build210/metal/metalroof008a_1844_-3854_169"] = "nature/snowfloor001a",
		["maps/rp_city17_build210/metal/metalroof008a_5188_-1839_2354"] = "nature/snowfloor001a",
		["wood/woodwall043a"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/tile/tileroof002a_1724_-2768_143"] = "nature/snowfloor001a",
		["maps/rp_city17_build210/tile/tileroof002a_-192_-1347_133"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/tile/tileroof002a_-500_0_170"] = "nature/snowfloor001a",
		["maps/rp_city17_build210/stone/stonefloor006d_c17_-910_4210_158"] = "nature/snow_002",
		["maps/rp_city17_build210/stone/stonefloor006h_c17_-910_4210_158"] = "nature/snow_002",
		["maps/rp_city17_build210/stone/stonefloor006f_c17_-910_4210_158"] = "nature/snow_002",
		["maps/rp_city17_build210/concrete/concretefloor019a_151_5641_158"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/concrete/concretefloor028c_c17_675_3482_142"] = "nature/snowfloor001a",
		["maps/rp_city17_build210/concrete/concretefloor019a_675_3482_142"] = "nature/snowfloor001a",
		["maps/rp_city17_build210/concrete/concretefloor019a_150_3310_152"] = "nature/snowfloor001a",
		["building_template/building_template010a"] = "nature/snowfloor001a",
		["maps/rp_city17_build210/stone/stonefloor006d_c17_150_3310_152"] = "nature/snow_002",
		["maps/rp_city17_build210/concrete/concretefloor019a_-910_4210_158"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/stone/stonefloor006f_c17_151_5641_158"] = "nature/snow_002",
		["maps/rp_city17_build210/stone/stonefloor006d_c17_151_5641_158"] = "nature/snow_002",
		["maps/rp_city17_build210/stone/stonefloor006f_c17_976_4210_158"] = "nature/snow_002",
		["maps/rp_city17_build210/concrete/concretefloor028c_c17_976_4210_158"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/nature/infblendgrassdirt001a_wvt_patch"] = "nature/snowfloor003a",
		["concrete/concretefloor013a"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/concrete/concretefloor028c_c17_-910_4210_158"] = "nature/snowfloor003a",
		["maps/rp_city17_build210/concrete/concretefloor028c_c17_151_5641_158"] = "nature/snowfloor003a",
		["plaster/plasterwall029a"] = "nature/snowfloor001a",
		["maps/rp_city17_build210/concrete/concretefloor028c_c17_150_3310_152"] = "nature/snowfloor003a"
	},
	rp_c18_dg = {
		["CONCRETE/CONCRETEFLOOR031A"] = "nature/snowfloor003a",
		["STONE/STONEFLOOR006F"] = "nature/snowfloor003a",
		["TOOLS/TOOLSNODRAW"] = "nature/snow_002",
		["CONCRETE/CONCRETE_EXT_07"] = "nature/snowfloor003a",
		["CONCRETE/CONCRETEFLOOR038B"] = "nature/snow_002",
		["TILE/TILEFLOOR018A_C17"] = "nature/snowfloor003a",
		["STONE/STONEFLOOR006F_C17"] = "nature/snow_002",
		["CONCRETE/CONCRETECEILING001A"] = "nature/snow_002",
		["CONCRETE/CONCRETEFLOOR016A"] = "nature/snowfloor003a",
		["CONCRETE/CONCRETECEILING004A"] = "nature/snowfloor003a",
		["STONE/STONEFLOOR006E_C17"] = "nature/snow_002",
		["CONCRETE/HIGHWAY_02"] = "nature/snow_002",
		["STONE/STONEFLOOR006D_C17"] = "nature/snow_002",
		["CONCRETE/CONCRETEFLOOR006A"] = "nature/snow_002",
		["CONCRETE/CONCRETEFLOOR034A"] = "nature/snow_002",
		["CONCRETE/CONCRETEFLOOR039B"] = "nature/snowfloor003a",
		["STONE/STONEFLOOR006E"] = "nature/snow_002",
		["CONCRETE/CONCRETEWALL036A"] = "nature/snow_002",
		["forest/cliff01"] = "nature/snow_002",
		["forest/dirt01"] = "nature/snow_002",
		["forest/grass01"] = "nature/snow_002",
		["forest/gravel01"] = "nature/snow_002",
		["SE_CONCRETE/CONCRETE_FLOOR_02"] = "nature/snow_002",
		["CONCRETE/HIGHWAY_02_INTERSECTION"] = "nature/snow_002"	
	}
}

local function SnowMapLoad()
	if not mapData[game.GetMap()] then
		return print("[impulse] [snow] No snow map texture data found for "..game.GetMap().."!")
	end
	
	for v,k in pairs(mapData[game.GetMap()]) do
		local oldMat = Material(v)

		oldMat:SetTexture("$basetexture", Material(k):GetTexture("$basetexture"))
	end
end

function PLUGIN:InitPostEntity()
	SnowMapLoad()
end

concommand.Add("impulse_xmas_snowload", function()
	SnowMapLoad()
end)
