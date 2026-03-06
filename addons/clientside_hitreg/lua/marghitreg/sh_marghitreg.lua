AddCSLuaFile()

local clhr_shotguns = CreateConVar(
	"clhr_shotguns", "1", FCVAR_ARCHIVE + FCVAR_REPLICATED,
	"allow shotguns to use clientside hitreg"
)
local clhr_targetbits = CreateConVar(
	"clhr_targetbits", "255", FCVAR_ARCHIVE + FCVAR_REPLICATED,
	"1 = players, 2 = npcs, 4 = nextbots, 8 = vehicles, 16 = weapons, 32 = ragdolls, 64 = props, 128 = other"
)
local clhr_subtick = CreateConVar(
	"clhr_subtick", "0", FCVAR_ARCHIVE + FCVAR_REPLICATED,
	"subtick hitreg simulation (very experimental, not recommended)"
)

local CLHR = CLHR

CLHR.maxply_bits = math.ceil(math.log(game.MaxPlayers()) / math.log(2))
CLHR.maxplayers = 2 ^ CLHR.maxply_bits

function CLHR:PassesTargetBits()
	return bit.band(clhr_targetbits:GetInt(), CLHR.GetTargetBit(self)) ~= 0
end

local propclasses = {
	prop_physics = true,
	prop_physics_multiplayer = true,
	func_physbox = true,
	func_physbox_multiplayer = true,
	physics_cannister = true,
	combine_mine = true,
	gib = true,
}

function CLHR:GetTargetBit()
	return self:IsPlayer() and 1
		or self:IsNPC() and 2
		or self:IsNextBot() and 4
		or self:IsVehicle() and 8
		or self:IsWeapon() and 16
		or self:IsRagdoll() and 32
		or propclasses[self:GetClass()] and 64
		or 128
end

function CLHR.ReplaceCallback(old, new, arg)
	return old and function(ply, trace, dmginfo)
		new(ply, trace, dmginfo, arg)

		return old(ply, trace, dmginfo)
	end or function(ply, trace, dmginfo)
		return new(ply, trace, dmginfo, arg)
	end
end

-- overriding the hook library functions is fucked up
-- but there isn't really any other way to do this
-- because EntityFireBullets allows only one single hook to modify the table
-- and hooks are executed in arbitrary order

CLHR.hookAdd = CLHR.hookAdd or hook.Add
CLHR.hookRem = CLHR.hookRem or hook.Remove
CLHR.hooks = CLHR.hooks or {}

function hook.Add(ev, nm, fn, pr)
	if ev == "EntityFireBullets" and nm ~= "CLHR_EntityFireBullets" then
		CLHR.hooks[nm] = fn

		return
	end

	return CLHR.hookAdd(ev, nm, fn, pr)
end

function hook.Remove(ev, nm)
	if ev == "EntityFireBullets" then
		CLHR.hooks[nm] = nil
	end

	return CLHR.hookRem(ev, nm)
end

local tbl = hook.GetTable().EntityFireBullets

if tbl then
	for k, v in pairs(tbl) do
		if isstring(k) or IsValid(k) then
			CLHR.hookRem("EntityFireBullets", k)
		else
			v = nil
		end

		CLHR.hooks[k] = v
	end
end

CLHR.hookAdd("EntityFireBullets", "CLHR_EntityFireBullets", function(ply, data)
	local yes, wep, fixedshotgun, cmd, lastcmd, tick

	if ply == GetPredictionPlayer() and not ply:IsBot() then
		if CLHR.IgnoreBulletPlayer == ply and CLHR.IgnoreBulletTime == CurTime() then
			return false
		end

		if CLHR.PreEntityFireBullets and clhr_subtick:GetBool() then
			CLHR.PreEntityFireBullets(ply, data)
		end

		if ply.CLHR_FixedShootPos then
			-- ValveSoftware/source-sdk-2013#442
			if ply:Alive() and data.Src == ply:GetShootPos() then
				data.Src = ply.CLHR_FixedShootPos
			end
		end

		if not IsFirstTimePredicted() then
			goto skip
		end

		local ucmd = ply:GetCurrentCommand()

		if not ucmd then
			goto skip
		end

		cmd = ucmd:CommandNumber()

		lastcmd = ply.CLHR_LastShotCommandNumber or 0.1

		if cmd < lastcmd then
			--if SERVER then
			--	ply:LagCompensation(false)
			--end

			goto skip
		end

		ply.CLHR_LastShotCommandNumber = cmd

		if SERVER and cmd < (ply.CLHR_LastCommandNumber or 0.1) then
			-- should only happen when a player gets a massive freeze
			-- like when they change certain graphics settings mid-game
			goto skip
		end

		ply.CLHR_LastCommandNumber = cmd

		tick = ucmd:TickCount()

		if tick < (ply.CLHR_LastTickCount or 0.1) then
			if SERVER then
				ply:LagCompensation(false) -- trolled

				print((
					"[CLHR] Player sent a tick count lower than previous %d < %d (%s %s)"
				):format(
					tick, ply.CLHR_LastTickCount or 0, ply:SteamID(), ply:Nick()
				))
			end

			goto skip
		end

		ply.CLHR_LastTickCount = tick

		if (data.HullSize or 0) ~= 0 then
			-- todo: add support for bullets that use hull traces
			goto skip
		end

		if (data.Num or 1) ~= 1 then
			if data.Num > 32 or not clhr_shotguns:GetBool() then
				goto skip
			end

			fixedshotgun = false
		end

		-- it's possible that this might not be the same weapon used to fire the shot
		-- there isn't really any actual way to be 100% sure
		wep = ply:GetActiveWeapon()

		if IsValid(wep) then
			if wep.CLHR_Disabled or CLHR.Exceptions[wep:GetClass()] then
				goto skip
			end

			if (data.Num or 1) == 1 then
				if wep.Base == "weapon_ttt_fof_base" then -- fot shotguns
					if (wep.Primary and wep.Primary.NumShots or 1) ~= 1 then
						fixedshotgun = 1
					end
				elseif wep.Base == "weapon_tttbase" then -- tttwr shotguns
					if wep.ShotgunNumShots and wep.ShotgunSpread then
						fixedshotgun = 2
					end
				end

				if fixedshotgun and not clhr_shotguns:GetBool() then
					goto skip
				end
			end
		end

		if hook.Run("CLHR_PreShouldApplyToBullet", ply, data) == false then
			goto skip
		end

		yes = true

		::skip::
	end

	for k, v in pairs(CLHR.hooks) do
		if k ~= "CLHR_EntityFireBullets" then
			if isstring(k) then
				if v(ply, data) == false then
					return false
				end
			elseif IsValid(k) then
				if v(k, ply, data) == false then
					return false
				end
			else
				CLHR.hooks[k] = nil
			end
		end
	end

	if GAMEMODE.EntityFireBullets
		and GAMEMODE:EntityFireBullets(ply, data) == false
	then
		return false
	end

	if yes then
		return CLHR.EntityFireBullets(
			ply, data, wep, fixedshotgun, cmd, lastcmd, tick
		)
	end

	return true
end)

hook.Add("StartCommand", "CLHR_StartCommand", function(ply, ucmd)
	if ply:IsBot() then
		return
	end

	local cmd = ucmd:CommandNumber()

	if cmd > (ply.CLHR_LastCommandNumber or 0) then
		ply.CLHR_LastCommandNumber = cmd
	end

	local tick = ucmd:TickCount()

	if tick > (ply.CLHR_LastTickCount or 0) then
		ply.CLHR_LastTickCount = tick
	end
end)

hook.Add("SetupMove", "CLHR_SetupMove", function(ply, mv, ucmd)
	if ply:IsBot() then
		return
	end

	if ply:Alive() then
		ply.CLHR_FixedShootPos = ply:GetShootPos()
	end

	if CLHR.SetupMove then
		return CLHR.SetupMove(ply, mv, ucmd)
	end
end)

include(CLIENT and "marghitreg/cl_marghitreg.lua" or "marghitreg/sv_marghitreg.lua")
