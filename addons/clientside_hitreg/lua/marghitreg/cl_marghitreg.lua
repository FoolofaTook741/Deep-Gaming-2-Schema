local CLHR = CLHR

local clhr_subtick = GetConVar("clhr_subtick")

local function send2server(msg)
	net.Start("CLHR", true)

	net.WriteUInt(msg.cmd, 31)

	if clhr_subtick:GetBool() then
		if msg.subtick then
			net.WriteBool(true)

			net.WriteVector(msg.subtick)
		else
			net.WriteBool(false)
		end
	end

	local lastvic, lasthbox

	::loop::

	if msg.shots == 0 then
		net.WriteBool(false)
	else
		net.WriteBool(true)

		net.WriteUInt(msg.shots - 1, 5)
	end

	local vic = msg.vic

	if lastvic then
		net.WriteBool(vic == lastvic)
	end

	local isply = vic < CLHR.maxplayers

	if vic ~= lastvic then
		if isply then
			net.WriteBool(false)

			net.WriteUInt(vic, CLHR.maxply_bits)
		else
			net.WriteBool(true)

			net.WriteUInt(vic, 16)
		end

		lastvic = vic
	end

	local hbox = msg.hbox

	if lasthbox then
		net.WriteBool(hbox == lasthbox)
	end

	if hbox ~= lasthbox then
		if hbox < 32 then -- default playermodels typically have 17 hitboxes
			net.WriteBool(false)

			net.WriteUInt(hbox, 5)
		else
			net.WriteBool(true)

			net.WriteUInt(hbox, 31)
		end

		lasthbox = hbox
	end

	net.WriteNormal(msg.norm)

	if not isply then
		if msg.dist then
			net.WriteBool(true)

			net.WriteFloat(msg.dist)
		else
			net.WriteBool(false)
		end
	end

	msg = msg.nxt

	if msg then
		net.WriteBool(true)

		goto loop
	end

	net.WriteBool(false)

	return net.SendToServer()
end

local msg2send

local function s2s()
	if msg2send then
		local msg = msg2send
		msg2send = nil

		return send2server(msg)
	end
end

hook.Add("SetupMove", "CLHR_SendToServer", s2s)
hook.Add("StartCommand", "CLHR_SendToServer", s2s)
hook.Add("CreateMove", "CLHR_SendToServer", s2s)
hook.Add("PreRender", "CLHR_SendToServer", s2s)
hook.Add("Think", "CLHR_SendToServer", s2s)

local function processtrace(trace, nonorm)
	if trace.HitWorld or not trace.Hit then
		return
	end

	local vic = trace.Entity

	if not CLHR.PassesTargetBits(trace.Entity) then
		return
	end

	local rag = vic:IsRagdoll()

	if not rag and bit.band(trace.Contents, CONTENTS_HITBOX) == 0 then
		return
	end

	local convex = true

	local hbox, pos, ang

	if rag then
		hbox = trace.PhysicsBone

		local bone = vic:TranslatePhysBoneToBone(hbox)

		if not (bone and bone ~= -1) then
			return
		end

		local mat = vic:GetBoneMatrix(bone)

		if not mat then
			return
		end

		pos, ang = mat:GetTranslation(), mat:GetAngles()
	elseif vic:GetMoveType() == MOVETYPE_VPHYSICS and vic:GetSolid() == SOLID_VPHYSICS then
		convex = nil

		hbox = 0

		pos, ang = vic:GetPos(), vic:GetAngles()
	else
		local set = vic:GetHitboxSet()

		if not set then
			return
		end

		hbox = trace.HitBox

		local bone = vic:GetHitBoxBone(hbox, set)

		-- calling GetBonePosition before GetBoneMatrix fixes some issues for some reason
		if not (bone and vic:GetBonePosition(bone)) then
			return
		end

		local mat = vic:GetBoneMatrix(bone)

		if not mat then
			return
		end

		pos, ang = mat:GetTranslation(), mat:GetAngles()
	end

	local norm = WorldToLocal(trace.HitPos, angle_zero, pos, ang)

	if nonorm then
		return vic, hbox, norm
	end

	local dist

	if convex then
		-- send the hitpos's direction from the hitbox origin to save some bits
		norm:Normalize()
	else
		-- we don't know if the vphys collision mesh is convex or not

		dist = norm:Length()

		norm:Div(dist)
	end

	return vic, hbox, norm, dist
end

local function callback(ply, trace, dmginfo, info)
	if hook.Run("CLHR_PostShouldApplyToBullet", ply, trace, dmginfo, info) == false then
		return
	end

	if trace.StartPos ~= info.src or ply ~= GetPredictionPlayer() then
		return
	end

	info.shots = info.shots + 1

	local vic, hbox, norm, dist = processtrace(trace)

	if not vic then
		return
	end

	local msg = {
		cmd = info.cmd,
		shots = info.shots,
		vic = vic:EntIndex() - 1,
		hbox = hbox,
		norm = norm,
		dist = dist,
		subtick = info.subtick,
	}

	if info.shotgun then
		msg.nxt = msg2send
		msg2send = msg
	else
		return send2server(msg)
	end
end

local info

function CLHR.EntityFireBullets(ply, data, wep, fixedshotgun, cmd, lastcmd)
	if cmd == lastcmd then
		if not fixedshotgun
			or not info
			or info.cmd ~= cmd
			or info.wep ~= wep
			or info.src ~= data.Src
		then
			return true
		end
	else
		info = {
			cmd = cmd,
			shots = -1,
			wep = wep,
			src = data.Src or Vector(),
			shotgun = fixedshotgun ~= nil,
		}
	end

	if data.CLHR_Subtick then
		info.subtick = data.CLHR_Subtick
	end

	data.Callback = CLHR.ReplaceCallback(data.Callback, callback, info)

	return true
end

local TICKINTERVAL = engine.TickInterval()

local attackdown = false
local subcrt, subaim, subpos, subdata = 0

local tracedata = {
	mask = MASK_SHOT,
	output = {},
}

hook.Add("CreateMove", "CLHR_CreateMove", function(cmd)
	if not clhr_subtick:GetBool() then
		return
	end

	if not cmd:KeyDown(IN_ATTACK) then
		attackdown = false

		return
	end

	local attackheld = attackdown

	attackdown = true

	local ply = LocalPlayer()

	if not (
		IsValid(ply)
		and ply:Alive()
	) then
		return
	end

	local wep = ply:GetActiveWeapon()

	if not IsValid(wep)
		or wep.CLHR_Disabled
		or CLHR.Exceptions[wep:GetClass()]
		or wep:Clip1() <= 0
		or wep.Primary and not wep.Primary.Automatic and attackheld
	then
		return
	end

	local crt = CurTime()

	if crt < subcrt + TICKINTERVAL then
		return
	end

	-- unfortunately prevents this from working with automatic fire
	-- i need to figure out a way to do this more elegantly
	if wep:GetNextPrimaryFire() > crt then
		return
	end

	subcrt = crt
	subpos = ply:GetShootPos()
	subaim = cmd:GetViewAngles():Forward()

	local td = tracedata
	td.start = subpos
	td.endpos = subpos + subaim * 56756
	td.filter = ply

	local vic, hbox, hpos = processtrace(util.TraceLine(td), true)

	if vic then
		subdata = {
			vic = vic,
			hbox = hbox,
			hpos = hpos,
		}
	else
		subdata = nil
	end
end)

local host_timescale = GetConVar("host_timescale")

function CLHR.PreEntityFireBullets(ply, data)
	if not IsFirstTimePredicted() or ply ~= LocalPlayer() then
		return
	end

	local scrt, spos, saim, sdata = subcrt, subpos, subaim, subdata
	subcrt, subpos, subaim, subdata = 0, nil, nil, nil

	if scrt == 0
		or data.Src ~= ply:GetShootPos()
		or data.Dir ~= ply:GetAimVector()
		or spos == data.Src and saim == data.Dir and not sdata
		or UnPredictedCurTime() > scrt + TICKINTERVAL / (host_timescale:GetFloat() * game.GetTimeScale())
	then
		return
	end

	data.CLHR_Subtick = spos
	data.Src = spos
	data.Dir = saim

	if not sdata then
		return
	end

	local vic = sdata.vic

	if not IsValid(vic) or vic:IsPlayer() and not vic:Alive() then
		return
	end

	local hbox = sdata.hbox

	local pos, ang

	if vic:IsRagdoll() then
		local bone = vic:TranslatePhysBoneToBone(hbox)

		if not (bone and bone ~= -1) then
			return
		end

		local mat = vic:GetBoneMatrix(bone)

		if not mat then
			return
		end

		pos, ang = mat:GetTranslation(), mat:GetAngles()
	elseif vic:GetMoveType() == MOVETYPE_VPHYSICS and vic:GetSolid() == SOLID_VPHYSICS then
		pos, ang = vic:GetPos(), vic:GetAngles()
	else
		local set = vic:GetHitboxSet()

		if not set then
			return
		end

		local bone = vic:GetHitBoxBone(hbox, set)

		if not (bone and vic:GetBonePosition(bone)) then
			return
		end

		local mat = vic:GetBoneMatrix(bone)

		if not mat then
			return
		end

		pos, ang = mat:GetTranslation(), mat:GetAngles()
	end

	local lookat = LocalToWorld(sdata.hpos, angle_zero, pos, ang)

	lookat:Sub(data.Src)
	lookat:Normalize()

	data.Dir = lookat
end
