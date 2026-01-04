AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_HEADCRAB","monster_babyheadcrab")
ENT.NPCFaction = NPC_FACTION_HEADCRAB
ENT.iClass = CLASS_HEADCRAB
util.AddNPCClassAlly(CLASS_HEADCRAB,"monster_babyheadcrab")
ENT.sModel = "models/half-life/baby_headcrab.mdl"
ENT.fRangeDistance	= 235
ENT.bPlayDeathSequence = true

ENT.skName = "babycrab"
ENT.CollisionBounds = Vector(12,12,8)

ENT.iBloodType = BLOOD_COLOR_YELLOW
ENT.sSoundDir = "npc/headcrab/"

ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = ACT_DIESIMPLE
}
ENT.tblAlertAct = {}

ENT.m_tbSounds = {
	["Attack"] = "hc_attack[1-3].wav",
	["Alert"] = "hc_alert[1-2].wav",
	["Death"] = "hc_die[1-2].wav",
	["Idle"] = "hc_idle[1-5].wav",
	["Pain"] = "hc_pain[1-3].wav"
}

local schdBackAway = ai_schedule_slv.New("Back Away")
schdBackAway:EngTask("TASK_GET_PATH_TO_LASTPOSITION")
schdBackAway:EngTask("TASK_WAIT", 0.2)

local schdFaceEnemy = ai_schedule_slv.New("Face Enemy")
schdFaceEnemy:EngTask("TASK_FACE_ENEMY")

function ENT:OnInit()
	self:SetHullType(HULL_TINY)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_MOVE_JUMP))
	self:SetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))

	self:SetSoundPitch(140)
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	self:PlayActivity(ACT_RANGE_ATTACK1,false,fcDone)
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "mattack") then
		local atk = select(2,...)
		local bJumpStart = atk == "jumpstart"
		local bJumpEnd = atk == "jumpend"
		local bJump = !bJumpStart && !bJumpEnd
		if bJumpStart then
			self:EmitSound("npc/headcrab/attack" .. math.random(1,3) .. ".wav", 75, 140)
			local pos 
			if IsValid(self.entEnemy) && !self.bPossessed then
				local posEnemy = self.entEnemy:GetHeadPos()
				local posSelf = self:GetPos()
				local fDistZ = posEnemy.z -posSelf.z
				fDistZ = math.Clamp(fDistZ, 16, 65)
				posEnemy.z = 0
				posSelf.z = 0
				local fDist = posEnemy:Distance(posSelf)
				fDist = math.Clamp(fDist, 10, self.fRangeDistance)
				pos = self:GetForward() *fDist *10 +self:GetUp() *fDistZ *4
			else
				pos = self:GetForward() *1800 +self:GetUp() *220
			end
			self:SetVelocity(pos)
			return true
		end
		if bJumpEnd then
			self.bBitten = false
			return true
		end
		if self.bBitten then return true end
		local fDist = 20
		local iDmg = GetConVarNumber("sk_babycrab_dmg_bite")
		local angViewPunch = Angle(-3,0,0)
		self:DoMeleeDamage(fDist,iDmg,angViewPunch,nil,function()
			self.bBitten = true
		end,nil,false)
		if self.bBitten then self:EmitSound( self.sSoundDir .. "headbite.wav", 75, 120) end
		return true
	end
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if(!self:IsOnGround()) then return end
		if (dist <= 50 || (self.bBackAway && dist < 80)) && (!self.nextRange || CurTime() < self.nextRange) then
			local tr = self:CreateTrace(self:GetCenter() +(self:GetPos() -enemy:GetPos()):GetNormal() *80, nil, self:GetCenter())
			local pos
			if tr.Hit then pos = tr.HitPos -tr.Normal *(self:OBBMaxs().y *2 +20)
			else pos = tr.HitPos end
			if self:GetPos():Distance(pos) > 60 then
				self:SetLastPosition(pos)
				self:StartSchedule(schdBackAway)
				self.bBackAway = true
				self.nextRange = self.nextRange || CurTime() +3
				return
			end
		end
		if self.bBackAway then self:StopMoving(); self:StartSchedule(schdFaceEnemy); self.bBackAway = false; return end
		local ang = self:GetAngleToPos(enemy:GetPos())
		local bRange = dist <= self.fRangeDistance && (ang.y <= 45 || ang.y >= 315) && self:CanSee(enemy)
		if bRange then
			self.nextRange = nil
			self:PlayActivity(ACT_RANGE_ATTACK1, true)
			return
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end
