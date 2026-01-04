AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_PLAYER","monster_bm_scientist")
ENT.NPCFaction = NPC_FACTION_PLAYER
ENT.iClass = CLASS_PLAYER_ALLY
util.AddNPCClassAlly(CLASS_PLAYER_ALLY,"monster_bm_scientist")
ENT.sModel = "models/half-life/scientist.mdl"
ENT.bGuard = false
ENT.bHeal = true
ENT.fFollowDistance = 110

ENT.skName = "scientist"
ENT.skHealth = "sk_scientist_health"

ENT.iBloodType = BLOOD_COLOR_RED
ENT.sSoundDir = "npc/scientist/"

ENT.m_tbSounds = {
	["Foot"] = "sci_step[1-4].wav",
	["Pain"] = "sci_pain[1-10].wav",
	["Death"] = "sci_die[1-4].wav"
}

ENT.sentences = {
	["Follow"] = "!SC_OK[0-8]",
	["Wait"] = "!SC_WAIT[0-6]",
	["Idle"] = "!SC_IDLE[0-13]",
	["Hear"] = "!SC_HEAR[0-2]",
	["Smell"] = "!SC_SMELL[0-3]",
	["Question"] = "!SC_QUESTION[0-26]",
	["AnswerChatter"] = "!SC_ANSWER[0-29]",
	["AnswerAllyShot"] = "!SC_SCARED[0-2]",
	["PlayerHealthLow"] = {"!SC_CUREA", "!SC_CUREB", "!SC_CUREC"},
	["Stop"] = "!SC_STOP[0-3]",
	["Hello"] = "!SC_HELLO[0-8]",
	["Mortal"] = {"!SC_MORTAL0"},
	["Wound"] = "!SC_WOUND[0-1]",
	["Shot"] = "!OT_SHOT[0-5]",
	["Mad"] = "!OT_MAD[0-3]",
	["Scream"] = "!SC_SCREAM[0-14]",
	["Fear"] = "!SC_FEAR[0-12]",
	["Heal"] = "!SC_HEAL[0-7]"
}

local schdHide = ai_schedule_slv.New("Hide") 
schdHide:EngTask("TASK_FIND_COVER_FROM_ENEMY", 0)
schdHide:AddTask("TASK_CUSTOM_MOVE_PATH", ACT_RUN_SCARED)
schdHide:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
schdHide:EngTask("TASK_PLAY_SEQUENCE", ACT_CROUCH)

function ENT:_Init()
	local iBodyGroup = math.random(0,3)
	self:SetBodygroup(1,iBodyGroup)
	if iBodyGroup == 2 then self:SetSkin(1) end
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if self:GetBehavior() == 1 then return end
	if(disp == D_HT || disp == D_FR) then
		if !self:CanSee(self.entEnemy) then return end
		self.delayHide = CurTime() +math.Rand(8,20)
		self:StartSchedule(schdHide)
		self.bInSchedule = true
	end
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "crouchidle") then
		if CurTime() >= self.delayHide || self:GetBehavior() > 0 || (IsValid(self.entEnemy) && self:CanSee(self.entEnemy)) then
			self.delayHide = nil
			self:PlayActivity(ACT_STAND,false,function()
				self.bInSchedule = false
				self:TaskComplete()
			end)
			return true
		end
		self:PlayActivity(ACT_CROUCHIDLE,false)
		return true
	elseif(event == "mattack") then
		local atk = select(2,...)
		local bNeedlePulled = atk == "needlepulled"
		local bShotGiven = atk == "shotgiven"
		local bGiveShot = !bNeedlePulled && !bShotGiven
		if bNeedlePulled then
			if self.bPossessed then return true end
			if self:GetBehavior() != 1 || !IsValid(self.entFollow) then self:PlayActivity(ACT_DISARM, true); return true end
			local fDist = self:OBBDistance(self.entFollow)
			if fDist <= self:OBBMaxs().y +40 then
				self:PlayActivity(ACT_MELEE_ATTACK1, true)
				self.nextHeal = CurTime() +math.Rand(20,80)
				return true
			end
			self:PlayActivity(ACT_DISARM, true)
		elseif bGiveShot then
			if (self:GetBehavior() != 1 || !IsValid(self.entFollow) || self.entFollow:OBBDistance(self) > self:OBBMaxs().y +40) && !self.bPossessed then return true end
			local ply
			if self.bPossessed then
				for k, v in pairs(ents.FindInSphere(self:GetPos(), 60)) do
					if IsValid(v) && v:IsPlayer() && v:Alive() then
						local ang = self:GetAngleToPos(v:GetPos())
						if ang.y <= 55 || ang.y >= 305 then
							ply = v
							break
						end
					end
				end
				if !IsValid(ply) then return true end
			else ply = self.entFollow end
			local iHealth = ply:Health()
			local iHealthMax = ply:GetMaxHealth()
			if iHealth >= iHealthMax then return true end
			local iHealthAdd = 25
			if iHealth +iHealthAdd > iHealthMax then
				iHealthAdd = iHealthMax -iHealth
			end
			ply:SetHealth(iHealth +iHealthAdd)
		elseif bShotGiven then
			if self.bPossessed then return true end
			self:PlayActivity(ACT_DISARM, true)
		end
		return true
	end
end