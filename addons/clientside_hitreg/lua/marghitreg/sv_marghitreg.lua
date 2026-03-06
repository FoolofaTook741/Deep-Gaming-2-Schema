AddCSLuaFile("cl_marghitreg.lua")

local clhr_tolerance = CreateConVar(
	"clhr_tolerance", "8", FCVAR_ARCHIVE,
	"hitpos tolerance for lag-compensated entities"
)
local clhr_tolerance_nolc = CreateConVar(
	"clhr_tolerance_nolc", "128", FCVAR_ARCHIVE,
	"hitpos tolerance for entities that are not lag-compensated"
)
local clhr_tolerance_ping = CreateConVar(
	"clhr_tolerance_ping", "100", FCVAR_ARCHIVE,
	"when calculating hitpos tolerance, clamps ping to this max value"
)
local clhr_supertolerant = CreateConVar(
	"clhr_supertolerant", "0", FCVAR_ARCHIVE,
	"the client is always right (not recommended for public servers)"
)
local clhr_nofirebulletsincallback = CreateConVar(
	"clhr_nofirebulletsincallback", "0", FCVAR_ARCHIVE,
	"prevent bullets from being fired inside the callbacks of client-registered hits"
)
local clhr_printshots = CreateConVar(
	"clhr_printshots", "0"
)
local clhr_subtick = GetConVar("clhr_subtick")

util.AddNetworkString("CLHR")

local CLHR = CLHR

local TICKINTERVAL = engine.TickInterval()
local TICKRATE = 1 / TICKINTERVAL

local GETDMGINFOS = {}

for _, v in ipairs{
	"AmmoType",
	--"Attacker",
	"BaseDamage",
	"Damage",
	"DamageBonus",
	"DamageCustom",
	"DamageForce",
	--"DamagePosition",
	"DamageType",
	"Inflictor",
	"MaxDamage",
	"ReportedPosition",
} do
	GETDMGINFOS["Get" .. v] = "Set" .. v
end

local function printshot(msg, ply, vic, info)
	return print((
		"[CLHR] %s (%s, [%d]%s, %d)"
	):format(
		msg,
		ply:Nick(),
		IsValid(vic) and vic:EntIndex() or 0,
		IsValid(vic) and (vic:IsPlayer() and vic:Nick() or vic:GetClass()) or "NULL",
		isnumber(info) and info or info.cmd
	))
end

local function isfrozenphys(e)
	if e:GetNoDraw() or e:GetInternalVariable("m_takedamage") == 0 then
		-- ignore invisible and invincible stuff
		return true
	elseif e:GetInternalVariable"m_flNextAttack" == nil then
		-- no m_flNextAttack means it's not based on CBaseCombatCharacter
		local phys = e:GetPhysicsObject()

		if IsValid(phys) then
			-- ignore physics props that haven't moved in a while
			return phys:IsAsleep() --or not phys:IsMotionEnabled()
		elseif e:GetSolid() == SOLID_VPHYSICS or e:GetMoveType() == MOVETYPE_VPHYSICS then
			-- solid vphys entity with no physobj can't be shot
			return true
		end
	end
end

local function isdead(e)
	if e:IsPlayer() then
		if not e:Alive()
			-- spectators in ttt are "alive"
			or GAMEMODE_NAME == "terrortown" and not e:IsTerror()
		then
			return true
		end
	elseif e:Health() <= 0
		-- some stuff don't take damage but still have damage events
		and e:GetInternalVariable("m_takedamage") == 2
	then
		return true
	end
end

local max = math.max

local function getinterp(p)
	return max(
		p:GetInfoNum("cl_interp", 0.1),
		p:GetInfoNum("cl_interp_ratio", 2) / p:GetInfoNum("cl_updaterate", 20)
	)
end

local function calctolerance(e, hbox, set, bone)
	if set and e:IsPlayer() then
		local crt = CurTime()

		local hitgroup = e:GetHitBoxHitGroup(hbox, set)

		if hitgroup == HITGROUP_RIGHTLEG then
			if TTT_FOF and crt < e:GetNW2Float("TTT_FOF_Kicking") then
				-- kick anim in fot uses clientside bone manips, so let's be very generous
				return 64
			end
		elseif hitgroup == HITGROUP_HEAD
			or hitgroup == HITGROUP_CHEST
			or hitgroup == HITGROUP_LEFTARM
			or hitgroup == HITGROUP_RIGHTARM
		then
			if crt < (e.CLHR_TTTRadioGestureTime or 0) then
				-- ttt radio gestures are clientside for some reason
				return 64
			end
		end

		if crt < (e.CLHR_AirDuckTime or 0) then
			return 36
		end
	end

	if e:HasBoneManipulations() and (
		e:GetManipulateBonePosition(bone) ~= vector_origin
		or e:GetManipulateBoneAngles(bone) ~= angle_zero
		or e:GetManipulateBoneScale(bone) ~= vector_origin
		or e:GetManipulateBoneJiggle(bone) ~= 0
	) then
		-- serverside bone manips are not lag-compensated
		return 64
	end
	-- todo: should we care about GetBoneParent?
end

local sqrt, ceil = math.sqrt, math.ceil

local tracedata = {
	mask = MASK_SHOT,
	output = {},
}

local function validate(ply, whit, lc)
	local info, vic = whit.info, whit.vic

	if not IsValid(vic) then
		if clhr_printshots:GetBool() then
			printshot("Fail: Invalid victim", ply, vic, info)
		end

		return
	end

	local shotinfo = whit.shotinfo

	if vic == shotinfo.origvic then
		if clhr_printshots:GetBool() and clhr_printshots:GetInt() == 2 then
			printshot("Fail: Already hit victim", ply, vic, info)
		end

		return
	end

	local tbl = shotinfo.targets[vic]

	if not tbl then
		if clhr_printshots:GetBool() then
			printshot("Fail: Bad victim", ply, vic, info)
		end

		return
	end

	if isdead(vic) then
		if clhr_printshots:GetBool() then
			printshot("Fail: Dead victim", ply, vic, info)
		end

		return
	end

	if not IsValid(shotinfo.dmginfo.SetInflictor) then
		if clhr_printshots:GetBool() then
			printshot("Fail: Invalid weapon", ply, vic, info)
		end

		return
	end

	local mdl = vic:GetModel()

	if mdl ~= tbl.mdl then
		if clhr_printshots:GetBool() then
			printshot("Fail: Victim changed model", ply, vic, info)
		end

		return
	end

	local hbox = whit.hbox

	local pos, ang = tbl.pos[1 + hbox], tbl.ang[1 + hbox]

	if not (pos and ang) then
		if clhr_printshots:GetBool() then
			printshot("Fail: Hitbox "..hbox.." is non-solid", ply, vic, info)
		end

		return
	end

	local rag = vic:IsRagdoll()

	local vphy = vic:GetMoveType() == MOVETYPE_VPHYSICS and vic:GetSolid() == SOLID_VPHYSICS

	local phys, set, bone, mins, maxs

	local vec = whit.normdist and whit.norm * whit.normdist

	if rag or vphy then
		if rag then
			bone = vic:TranslatePhysBoneToBone(hbox)

			if not bone or bone == -1 then
				if clhr_printshots:GetBool() then
					printshot("Fail: PhysObj "..hbox.." out of range", ply, vic, info)
				end

				return
			end
		else
			bone = 0
		end

		phys = rag and vic:GetPhysicsObjectNum(hbox) or vic:GetPhysicsObject()

		if not IsValid(phys) then
			if clhr_printshots:GetBool() then
				printshot("Fail: Invalid PhysObj", ply, vic, info)
			end

			return
		end

		local pc = CLHR.GetPhysCollides(mdl, rag and hbox + 1 or nil)

		if not pc then
			if clhr_printshots:GetBool() then
				printshot("Fail: Invalid PhysCollides", ply, vic, info)
			end

			return
		end

		mins, maxs = phys:GetAABB()

		vec = vec or pc:TraceBox(
			vector_origin, angle_zero, whit.norm * (
				1 + sqrt(max(mins:LengthSqr(), maxs:LengthSqr()))
			), vector_origin, vector_origin, vector_origin
		)
	else
		set = vic:GetHitboxSet()

		if not set then
			if clhr_printshots:GetBool() then
				printshot("Fail: No hitbox set", ply, vic, info)
			end

			return
		end

		bone = vic:GetHitBoxBone(hbox, set)

		if not bone then
			if clhr_printshots:GetBool() then
				printshot("Fail: Hitbox "..hbox.." out of range", ply, vic, info)
			end

			return
		end

		mins, maxs = vic:GetHitBoxBounds(hbox, set)

		if not (mins and maxs) then
			if clhr_printshots:GetBool() then
				printshot("Fail: Hitbox "..hbox.." has no bounds", ply, vic, info)
			end

			return
		end

		local raydelt = whit.norm * (
			-- get distance to farthest corner
			1000 + sqrt(max(mins:LengthSqr(), maxs:LengthSqr()))
		)

		vec = vec or util.IntersectRayWithOBB( -- im lazy
			raydelt, -raydelt, vector_origin, angle_zero, mins, maxs
		)
	end

	if not vec then
		if clhr_printshots:GetBool() then
			printshot("Fail: Hitpos unreproducible", ply, vic, info)
		end

		return
	end

	if set then
		-- nudge the hitpos 1 unit closer to the hitbox's centre, just to be sure

		-- for now, only do this for non-vphys stuff since they might not be convex

		local mid = mins + maxs
		mid:Mul(0.5)

		vec:Sub(mid)

		local len = vec:Length()

		if len > 1 then
			vec:Mul((1 / len) * max(1, len - 1))
		end

		vec:Add(mid)
	end

	local start = shotinfo.trace.StartPos

	if whit.subtick then
		local vel = ply:GetVelocity()

		-- maybe use distance from last shootpos so cheaters can't just shoot around corners?
		local maxdist = TICKINTERVAL * (
			vel:LengthSqr() > 1024 ^ 2 and vel:Length() or 1024
		)

		local td = tracedata

		td.start = start
		td.endpos = whit.subtick

		if td.start:DistToSqr(td.endpos) > maxdist * maxdist then
			td.endpos = td.endpos - td.start
			td.endpos:Normalize()
			td.endpos:Mul(maxdist)
			td.endpos:Add(start)
		end

		td.filter = ply

		-- probably should use a hull trace instead of a line trace
		start = util.TraceLine(td).HitPos
	end

	local hitpos = LocalToWorld(vec, angle_zero, pos, ang)

	local tol, distsqr, lerp

	local viclagcomp = vic:IsLagCompensated()

	if not (clhr_supertolerant:GetBool() or clhr_subtick:GetBool()) then
		if start:DistToSqr(hitpos) > info.distsqr then
			if clhr_printshots:GetBool() then
				printshot((
					"Fail: Hitpos too far %s > %s"
				):format(
					math.Round(start:Distance(hitpos), 2),
					math.Round(info.distance, 2)
				), ply, vic, info)
			end

			return
		end

		if viclagcomp then
			if vic:IsNPC() then
				local lerp1, lerp2 = getinterp(ply), ply:GetInfoNum("cl_interp_npcs", 0)

				lerp = max(lerp1, lerp2)

				-- source engine lagcomp doesn't account for cl_interp_npcs for some reason
				if ceil(lerp2 * TICKRATE) <= ceil(lerp1 * TICKRATE) then
					tol = true
				end
			else
				tol = true
			end
		end

		tol = tol and clhr_tolerance:GetFloat() or clhr_tolerance_nolc:GetFloat()

		tol = max(tol, calctolerance(vic, hbox, set, bone) or tol)
	end

	local dolagcomp = viclagcomp

	if dolagcomp and not lc then
		-- we're off by 1-tick, but we should lagcomp anyway to be as close as possible
		ply:LagCompensation(true)
	end

	local bpos, bang

	if phys and not rag then
		bpos, bang = vic:GetPos(), vic:GetAngles()
	else
		bpos, bang = vic:GetBonePosition(bone)
	end

	if not (bpos and bang) then
		bpos, bang = pos, ang
	end

	local endpos = LocalToWorld(vec, angle_zero, bpos, bang)

	if tol then
		local planehit = util.IntersectRayWithPlane(
			start, shotinfo.trace.Normal, hitpos, -shotinfo.trace.Normal
		)

		if not planehit then
			if clhr_printshots:GetBool() then
				printshot("Fail: Hitpos is behind startpos", ply, vic, info)
			end

			return dolagcomp
		end

		distsqr = planehit:DistToSqr(hitpos) -- cylinder check

		if distsqr > tol * tol then
			if not lerp then
				lerp = getinterp(ply)

				if vic:IsNPC() then
					lerp = max(lerp, ply:GetInfoNum("cl_interp_npcs", 0))
				end
			end

			-- adjust tolerance based on how far the bone moved since last tick
			tol = tol + endpos:Distance(hitpos) * (math.Clamp(
				info.ping, 1, TICKRATE * clhr_tolerance_ping:GetFloat() * 0.001
			) + TICKRATE * max(0.1, lerp))

			if distsqr > tol * tol then
				if clhr_printshots:GetBool() then
					printshot((
						"Fail: Exceeded tolerance check %s > %s"
					):format(
						math.Round(sqrt(distsqr), 2),
						math.Round(tol, 2)
					), ply, vic, info)
				end

				return dolagcomp
			end
		end
	end

	local td = tracedata

	td.start = start

	td.endpos = endpos - start
	td.endpos:Normalize()
	td.endpos:Mul(info.distance)
	td.endpos:Add(start)

	if IsValid(info.ignore) and info.ignore ~= ply then
		td.filter = {ply, info.ignore}
	else
		td.filter = ply
	end

	local trace = util.TraceLine(td)

	if vic ~= trace.Entity then
		if trace.HitNonWorld and trace.Hit then
			-- prevent ragdolls, dropped guns, and dropped hats from blocking shots

			local tent = trace.Entity

			if tent:IsRagdoll()
				or tent:IsWeapon()
				or tent.Base == "base_ammo_ttt"
				or tent.Wearer == vic
				and tent.GetBeingWorn
				and not tent:GetBeingWorn()
			then
				if istable(td.filter) then
					table.insert(td.filter, tent)
				else
					td.filter = {ply, tent}
				end

				if vic == util.TraceLine(td).Entity then
					goto skip
				end
			end
		end

		-- idk why this can sometimes fail without anything obstructing the trace
		-- even while debugoverlays show that an intersection should happen
		-- todo: i need to look into this

--[[
		ply:SendLua((
			"debugoverlay.Line(Vector'%s', Vector'%s', 10, Color(255,0,0), true)"
		):format(
			trace.StartPos, trace.HitPos
		))
		ply:SendLua((
			"debugoverlay.BoxAngles(Vector'%s', Vector'%s', Vector'%s', Angle'%s', 10, Color(0,255,0,20))"
		):format(
			bpos, mins, maxs, bang
		))
--]]

		if dolagcomp then
			ply:LagCompensation(false)

			-- try the trace again with lagcomp disabled
			-- this is probably unnecessary, i might get rid of this

			dolagcomp = false

			bpos, bang = vic:GetBonePosition(bone)

			if bpos and bang then
				endpos = LocalToWorld(vec, angle_zero, bpos, bang)

				td.endpos = endpos - start
				td.endpos:Normalize()
				td.endpos:Mul(info.distance)
				td.endpos:Add(start)

				if vic == util.TraceLine(td).Entity then
					goto skip
				end
			end
		end

		if clhr_printshots:GetBool() then
			local e = trace.Entity
			printshot(
				start:DistToSqr(trace.HitPos) > start:DistToSqr(endpos) and "Fail: Trace missed"
				or trace.HitWorld and "Fail: Trace obstructed by world"
				or trace.Hit and ("Fail: Trace obstructed by [%d]%s"):format(
					e:EntIndex(), e:IsPlayer() and e:Nick() or e:GetClass()
				)
				or "Fail: Trace hit nothing",
				ply, vic, info
			)
		end

		do return dolagcomp end

		::skip::
	end

	shotinfo.dmginfo.SetDamagePosition = trace.HitPos

	shotinfo.newtrace = trace

	shotinfo.info = info

	if not info.lasthit then
		info.lasthit = {}
	end

	if not info.lasthit[vic] then
		info.lasthit[vic] = shotinfo
	end

	if clhr_printshots:GetBool() then
		printshot(distsqr and (
			"Success! %s < %s"
		):format(
			math.Round(sqrt(distsqr), 2),
			math.Round(tol, 2)
		) or "Success!", ply, vic, info)
	end

	return dolagcomp, shotinfo
end

local function getpossibletargets(ply, start, dir)
	local out = {}

	local ndir = -dir

	local supertol = clhr_supertolerant:GetBool() or clhr_subtick:GetBool()

	for _, v in ipairs(ents.FindInPVS(ply)) do
		if v == ply
			or not v:IsSolid()
			or isfrozenphys(v)
			or not CLHR.PassesTargetBits(v)
			or bit.band(v:GetSolidFlags(), FSOLID_NOT_SOLID) ~= 0
		then
			goto cont
		end

		if isdead(v) then
			goto cont
		end

		local wspos = v:WorldSpaceCenter()

		local planehit = util.IntersectRayWithPlane(start, dir, wspos, ndir)

		if not planehit then
			goto cont
		end

		if not supertol then
			local tol = max(128, v:BoundingRadius()) -- maybe 128 is too generous
			tol = v:IsLagCompensated() and tol * tol or tol * tol * 4

			if planehit:DistToSqr(wspos) > tol then -- cylinder check
				goto cont
			end
		end

		local set = v:GetHitboxSet()

		if not set then
			goto cont
		end

		local hcount = v:GetHitBoxCount(set)

		if not hcount or hcount == 0 then
			goto cont
		end

		local yes

		local tbl = {
			pos = {},
			ang = {},
		}

		if v:IsRagdoll() then
			for i = 1, v:GetPhysicsObjectCount() do
				local pos, ang

				local phys = v:GetPhysicsObjectNum(i - 1)

				if IsValid(phys) and bit.band(phys:GetContents(), MASK_SHOT) ~= 0 then
					yes = true

					pos, ang = phys:GetPos(), phys:GetAngles()
				else
					pos, ang = false, false
				end

				tbl.pos[i], tbl.ang[i] = pos, ang
			end
		elseif v:GetMoveType() == MOVETYPE_VPHYSICS and v:GetSolid() == SOLID_VPHYSICS then
			yes = true

			tbl.pos[1], tbl.ang[1] = v:GetPos(), v:GetAngles()
		else
			for i = 1, v:GetHitBoxCount(set) do
				local pos, ang

				local bone = v:GetHitBoxBone(i - 1, set)

				if bone and bit.band(v:GetBoneContents(bone), MASK_SHOT) ~= 0 then
					pos, ang = v:GetBonePosition(bone)
				end

				if pos and ang then
					yes = true
				else
					pos, ang = false, false
				end

				tbl.pos[i], tbl.ang[i] = pos, ang
			end
		end

		if not yes then
			goto cont -- none of its hitboxes are solid
		end

		tbl.mdl = v:GetModel()

		out[v] = tbl

		::cont::
	end

	return out
end

local function setwanthit(ply, info, shots, vic, hbox, norm, normdist, subtick)
	local shotinfo = info[shots]

	info[shots] = nil

	local whit = ply.CLHR_ClientWantsHit

	local count = whit and whit.count or 0

	if count > 32 then
		if clhr_printshots:GetBool() then
			printshot("Fail: Too many wanted hits", ply, vic, info)
		end

		return
	end

	ply.CLHR_ClientWantsHit = {
		tick = engine.TickCount(),
		info = info,
		shotinfo = shotinfo,
		vic = vic,
		hbox = hbox,
		norm = norm,
		normdist = normdist,
		nxt = ply.CLHR_ClientWantsHit,
		count = count + 1,
		subtick = subtick,
	}
end

local function callback(ply, trace, dmginfo, info)
	if hook.Run("CLHR_PostShouldApplyToBullet", ply, trace, dmginfo, info) == false then
		return
	end

	if trace.StartPos ~= info.src then
--[[ this is for ignoring source's serverside glass penetration
		local td = tracedata

		td.start = trace.StartPos - trace.Normal
		td.endpos = trace.StartPos
		td.filter = ply

		local trace2 = util.TraceLine(td)
		local glass = trace2.Entity

		if not trace2.Hit or trace2.HitNonWorld
			and glass:GetClass() == "func_breakable"
			and not glass:HasSpawnFlags(2048)
			and glass:GetMaterialType() == MAT_GLASS
		then
			return
		end
--]]
		return
	end

	info.shots = info.shots + 1

	if trace.HitNonWorld
		and bit.band(trace.Contents, CONTENTS_HITBOX) ~= 0
		and not isfrozenphys(trace.Entity)
		--and CLHR.PassesTargetBits(trace.Entity)
		or ply ~= GetPredictionPlayer()
	then
		return
	end

	local shotinfo = {}

	info[info.shots] = shotinfo

	shotinfo.origvic = trace.Entity

	shotinfo.targets = getpossibletargets(ply, trace.StartPos, trace.Normal)

	shotinfo.origtrace = trace

	shotinfo.trace = {}

	for k, v in pairs(trace) do
		shotinfo.trace[k] = isvector(v) and Vector(v) or v
	end

	shotinfo.dmginfo = {SetAttacker = ply}

	for k, v in pairs(GETDMGINFOS) do
		shotinfo.dmginfo[v] = dmginfo[k](dmginfo)
	end

	if shotinfo.dmginfo.SetInflictor == ply
		and IsValid(info.wep)
		and info.wep:GetOwner() == ply
	then
		shotinfo.dmginfo.SetInflictor = info.wep
	end

	if info.damage == 0 and not (info.ammotype and info.ammotype ~= "") then
		shotinfo.dmginfo.SetDamage = 0
	end

	local ehit, prev = ply.CLHR_EarlyClientHit

	while ehit do
		if ehit.shots == info.shots and ehit.cmd == info.cmd then
			if prev then
				prev.nxt = ehit.nxt
			end

			setwanthit(ply, info, info.shots, ehit.vic, ehit.hbox, ehit.norm, ehit.normdist, ehit.subtick)
		end

		prev = ehit
		ehit = ehit.nxt
	end
end

function CLHR.EntityFireBullets(ply, data, wep, fixedshotgun, cmd, lastcmd, tick)
	local crt = CurTime()

	local info = ply.CLHR_LastBulletInfo

	if fixedshotgun then
		if info and info.crt == crt and (
			info.cmd ~= cmd
			or info.wep ~= wep
			or info.src ~= data.Src
		) then
			return true
		end
	else
		if info then
			if info.crt == crt then
				return true
			end

			info = nil
		end

		if cmd == lastcmd then
			return true
		end
	end

	info = info or {
		cmd = cmd,
		crt = crt,
		wep = wep,
		src = data.Src or Vector(),
		cb = fixedshotgun ~= 2 and data.Callback,
		distance = data.Distance or 56756,
		distsqr = data.Distance and data.Distance * data.Distance or 56756 ^ 2,
		ignore = data.IgnoreEntity,
		damage = data.Damage,
		ammotype = data.AmmoType,
		shots = -1,
		ping = engine.TickCount() - tick,
	}

	ply.CLHR_LastBulletInfo = info

	data.Callback = CLHR.ReplaceCallback(data.Callback, callback, info)

	return true
end

hook.Add("PlayerPostThink", "CLHR_PlayerPostThink", function(ply)
	if ply.CLHR_LastBulletInfo
		-- if the net message takes longer than 1 tick to arrive then just ignore it
		and ply.CLHR_LastBulletInfo.crt < CurTime()
	then
		ply.CLHR_LastExpiredCommandNumber = ply.CLHR_LastBulletInfo.cmd

		ply.CLHR_LastBulletInfo = nil
	end

	if ply.CLHR_EarlyClientHit
		-- if it arrived any earlier than 100 ms then they're probably attempting to exploit
		and ply.CLHR_EarlyClientHit.crt < CurTime() - 0.1
	then
		ply.CLHR_EarlyClientHit = nil
	end
end)

net.Receive("CLHR", function(_, ply)
	local cmd = net.ReadUInt(31)

	local info = ply.CLHR_LastBulletInfo

	local vic, lastidx, lasthbox

	local subtick

	if clhr_subtick:GetBool() and net.ReadBool() then
		subtick = net.ReadVector()
	end

	for _ = 1, 32 do
		local shots = net.ReadBool() and 1 + net.ReadUInt(5) or 0

		local idx = lastidx and net.ReadBool() and lastidx
			or 1 + net.ReadUInt(net.ReadBool() and 16 or CLHR.maxply_bits)

		local hbox = lasthbox and net.ReadBool() and lasthbox
			or net.ReadUInt(net.ReadBool() and 31 or 5)

		local norm = net.ReadNormal()

		local normdist = idx > CLHR.maxplayers and net.ReadBool() and net.ReadFloat() or nil

		vic = vic and idx == lastidx and vic or Entity(idx)

		if not IsValid(vic) or isdead(vic) then
			goto cont
		end

		if not (info and info[shots] and info.cmd == cmd) then
			if not info and cmd <= (ply.CLHR_LastExpiredCommandNumber or 0) then
				if clhr_printshots:GetBool() then
					printshot("Fail: Message arrived too late", ply, vic, cmd)
				end

				goto cont
			end

			local ehit = ply.CLHR_EarlyClientHit

			local count = ehit and ehit.count or 0

			if count > 32 then
				if clhr_printshots:GetBool() then
					printshot("Fail: Too many early hits", ply, vic, cmd)
				end

				goto cont
			end

			ply.CLHR_EarlyClientHit = {
				cmd = cmd,
				shots = shots,
				crt = CurTime(),
				vic = vic,
				hbox = hbox,
				norm = norm,
				normdist = normdist,
				nxt = ehit,
				count = count + 1,
				subtick = subtick,
			}

			goto cont
		end

		setwanthit(ply, info, shots, vic, hbox, norm, normdist, subtick)

		::cont::

		if net.ReadBool() then
			lastidx = idx
			lasthbox = hbox
		else
			break
		end
	end
end)

local storeinfo

hook.Add("EntityTakeDamage", "CLHR_EntityTakeDamage", function(vic, dmginfo)
	local info = storeinfo

	if not info then
		return
	end

	storeinfo = nil

	if vic ~= info.vic
		or dmginfo:GetAttacker() ~= info.ply
		or dmginfo:GetInflictor() ~= info.infl
		or CurTime() ~= info.crt
	then
		return
	end

	if info.add then
		info.add = nil

		info.multidmg = (info.multidmg or 0) + dmginfo:GetDamage()

		local frc = dmginfo:GetDamageForce()

		if info.multifrc then
			info.multifrc:Add(frc)
		else
			info.multifrc = frc
		end

		return true
	end

	if info.multidmg then
		dmginfo:AddDamage(info.multidmg)

		info.multidmg = nil
	end

	if info.multifrc then
		info.multifrc:Add(dmginfo:GetDamageForce())

		dmginfo:SetDamageForce(info.multifrc)

		info.multifrc = nil
	end
end)

local function dohits(ply, hit, lc)
	if not hit then
		if lc then
			ply:LagCompensation(false)
		end

		return
	end

	if clhr_nofirebulletsincallback:GetBool() then
		CLHR.IgnoreBulletPlayer = ply
		CLHR.IgnoreBulletTime = CurTime()
	end

	SuppressHostEvents(ply)

	while hit do
		local h = hit
		hit = h.nxt

		local dmginfo = DamageInfo()

		for k, v in pairs(h.dmginfo) do
			dmginfo[k](dmginfo, v)
		end

		local trace = h.newtrace

		local info = h.info

		trace.CLHR_CommandNumber = info.cmd

		trace.CLHR_StoredData = h.origtrace and h.origtrace.CLHR_StoredData

		if info.cb then
			-- pcall is slower than just calling this function directly
			-- but it's out of my control if some other addon's bullet callback has an error
			-- and having an error halt execution right here is really really bad
			-- because SuppressHostEvents and LagCompensation won't be disabled

			local yes, err = pcall(info.cb, ply, trace, dmginfo)

			if not yes and err then
				ErrorNoHaltWithStack(err)
			end
		end

		local vic = trace.Entity

		info.ply = ply
		info.infl = dmginfo:GetInflictor()
		info.crt = CurTime()
		info.vic = vic
		info.add = h ~= info.lasthit[vic]

		storeinfo = info

		vic:DispatchTraceAttack(dmginfo, trace)

		storeinfo = nil
	end

	CLHR.IgnoreBulletPlayer = nil
	CLHR.IgnoreBulletTime = nil

	SuppressHostEvents(NULL)

	if lc then
		ply:LagCompensation(false)
	end
end

function CLHR.SetupMove(ply, mv)
	if mv:KeyPressed(IN_DUCK) and not ply:OnGround() then
		local crt = CurTime()

		ply.CLHR_AirDuckTime = math.Clamp(
			crt + 0.5, (ply.CLHR_AirDuckTime or 0) + 0.5, crt + 2
		)
	end

	local wanthit = ply.CLHR_ClientWantsHit

	ply.CLHR_ClientWantsHit = nil

	local hit, lagcomp

	while wanthit do
		local whit = wanthit
		wanthit = whit.nxt

		local tick = engine.TickCount()

		if whit.tick ~= tick - 1 and whit.tick ~= tick then
			if clhr_printshots:GetBool() then
				printshot("Fail: Bad tick count", ply, whit.vic, whit.info)
			end

			goto cont
		end

		local lc, h = validate(ply, whit, lagcomp)

		if lc then
			lagcomp = true
		end

		if h then
			h.nxt = hit
			hit = h
		end

		::cont::
	end

	if hit or lagcomp then
		return dohits(ply, hit, lagcomp)
	end
end

local samepc = {}

for k, v in pairs{
{"arctic", "barney", "breen", "charple", "corpse1", "gasmask", "gman_high", "Group01/male_01", "Group01/male_02", "Group01/male_03", "Group01/male_04", "Group01/male_05", "Group01/male_06", "Group01/male_07", "Group01/male_08", "Group01/male_09", "Group02/male_02", "Group02/male_04", "Group02/male_06", "Group02/male_08", "Group03/male_01", "Group03/male_02", "Group03/male_03", "Group03/male_04", "Group03/male_05", "Group03/male_06", "Group03/male_07", "Group03/male_08", "Group03/male_09", "Group03m/male_01", "Group03m/male_02", "Group03m/male_03", "Group03m/male_04", "Group03m/male_05", "Group03m/male_06", "Group03m/male_07", "Group03m/male_08", "Group03m/male_09", "guerilla", "kleiner", "leet", "magnusson", "monk", "odessa", "phoenix", "riot", "skeleton", "swat", "urban"},
{"Group01/female_01", "Group01/female_02", "Group01/female_03", "Group01/female_04", "Group01/female_05", "Group01/female_06", "Group03/female_01", "Group03/female_02", "Group03/female_03", "Group03/female_04", "Group03/female_05", "Group03/female_06", "Group03m/female_01", "Group03m/female_02", "Group03m/female_03", "Group03m/female_04", "Group03m/female_05", "Group03m/female_06", "mossman", "mossman_arctic", "p2_chell"},
{"hostage/hostage_01", "hostage/hostage_02", "hostage/hostage_03", "hostage/hostage_04"},
{"combine_soldier", "combine_soldier_prisonguard", "combine_super_soldier"},
{"dod_american", "dod_german"},
} do
	for _, name in ipairs(v) do
		samepc["models/player/" .. name .. ".mdl"] = k
	end
end

CLHR.PhysCollides = CLHR.PhysCollides or {}

local function newpc(mdl)
	local pc = CreatePhysCollidesFromModel(mdl)

	if not pc then
		return
	end

	if #pc == 1 then
		pc = pc[1]
	end

	CLHR.PhysCollides[samepc[mdl] or mdl] = pc

	return pc
end

function CLHR.GetPhysCollides(mdl, num)
	local pc = CLHR.PhysCollides[samepc[mdl] or mdl]

	if not pc then
		pc = newpc(mdl)

		if not pc then
			return
		end
	end

	if istable(pc) then
		if not num then
			return
		end

		pc = pc[num]

		if not IsValid(pc) then
			pc = newpc(mdl)

			if not istable(pc) then
				return
			end

			pc = pc[num]

			if not IsValid(pc) then
				return
			end
		end
	elseif not IsValid(pc) then
		pc = newpc(mdl)

		if not IsValid(pc) then
			return
		end
	end

	return pc
end

local gesturetimes = {
	quick_yes = 3,
	quick_no = 3,
	quick_see = 4,
	quick_check = 2,
	quick_suspect = 2,
}

hook.Add("TTTPlayerRadioCommand", "CLHR_TTTPlayerRadioCommand", function(ply, msg)
	local gtime = gesturetimes[msg]

	if gtime then
		ply.CLHR_TTTRadioGestureTime = CurTime() + gtime
	end
end)
