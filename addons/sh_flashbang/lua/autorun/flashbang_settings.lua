AddCSLuaFile()

FLASHBANG_SETTINGS = {
	-- Allow cooking? (if flashbang is held unpinned for too long, explode in the player's face)
	-- This is always true in TTT.
	AllowCooking = true,

	-- Fuse time of the flashbang (in seconds) before detonation
	CookTime = 4,

	-- Throw distance in units
	ThrowForce = 1250,

	-- Range of the flashbang in units
	Range = 6000,

	-- Maximum time a player can remain flashed
	MaxFlashTime = 6,

	-- Should the flashbang emit particles?
	EmitParticles = true,

	-- Should the flashbang create a decal on explosion?
	CreateDecal = true,
	
	-- Allow the player to have multiple flashbangs on him?
	AllowAmmo = true,

	-- Should the flashbang blind NPCs (not NextBots)?
	HitNPCs = true,

	-- TTT options!
	TTT = {
		-- Make the flashbang available to traitors?
		-- Toggling this option will disable flashbangs spawning around the map.
		TraitorsGet = false,

		-- Make the flashbang available to detectives?
		-- Toggling this option will disable flashbangs spawning around the map.
		DetectivesGet = false,
		
		-- Make the flashbang stock limited? (purchase once)
		LimitedStock = false,
	},
	
	-- Use Steam Workshop insteaad of FastDL for content?
	UseWorkshop = true,
}

if (SERVER) then
	if (FLASHBANG_SETTINGS.UseWorkshop) then
		resource.AddWorkshop("683563224")
	else
		-- don't need the spawnmenu icon if we're playing TTT
		if (engine.ActiveGamemode() ~= "terrortown") then
			resource.AddSingleFile("materials/entities/weapon_sh_flashbang.png")
			resource.AddSingleFile("materials/weapons/weapon_sh_flashbang.vmt")
			resource.AddSingleFile("materials/weapons/weapon_sh_flashbang.vtf")
		else -- TTT specific content
			resource.AddSingleFile("materials/vgui/ttt/icon_flashbang.vmt")
			resource.AddSingleFile("materials/vgui/ttt/icon_flashbang.vtf")
		end

		resource.AddSingleFile("materials/models/shenesis/flashbang/flash_diffuse.vmt")
		resource.AddSingleFile("materials/models/shenesis/flashbang/m84diffuse.vtf")
		resource.AddSingleFile("materials/models/shenesis/flashbang/m84normal.vtf")
		resource.AddSingleFile("models/shenesis/w_flashbang.dx80.vtx")
		resource.AddSingleFile("models/shenesis/w_flashbang.dx90.vtx")
		resource.AddSingleFile("models/shenesis/w_flashbang.mdl")
		resource.AddSingleFile("models/shenesis/w_flashbang.phy")
		resource.AddSingleFile("models/shenesis/w_flashbang.sw.vtx")
		resource.AddSingleFile("models/shenesis/w_flashbang.vvd")
		resource.AddSingleFile("sound/shenesis/flashbang_explode1.ogg")
		resource.AddSingleFile("sound/shenesis/flashbang_explode2.ogg")
	end
end