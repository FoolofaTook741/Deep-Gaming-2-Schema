AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_PLAYER","monster_rosenberg")
ENT.NPCFaction = NPC_FACTION_PLAYER
ENT.sModel = "models/decay/scientist_rosenberg.mdl"
ENT.bGuard = false
ENT.bHeal = false
ENT.bCanAnswerChatter = true
ENT.skHealth = "sk_scientist_health"
ENT.sSoundDir = "npc/rosenberg/"
ENT.fFollowDistance = 100

ENT.m_tbSounds = {
	["Foot"] = "sci_step[1-4].wav",
	["Pain"] = "ro_pain[0-8].wav",
	["Death"] = "ro_pain[0-8].wav"
}

ENT.sentences = {
	["Follow"] = "!RO_OK[0-7]",
	["Wait"] = "!RO_WAIT[0-4]",
	["Question"] = "!SC_QUESTION[0-26]",
	["AnswerAllyShot"] = "!RO_SCARED[0-2]",
	["PlayerHealthLow"] = {"!RO_CUREA", "!RO_CUREB", "!RO_CUREC"},
	["Stop"] = "!RO_STOP[0-4]",
	["Mortal"] = {"!RO_MORTAL1"},
	["Wound"] = "!RO_WOUND[0-1]",
	["Scream"] = "!RO_PLFEAR[0-4]",
	["Fear"] = "!RO_FEAR[0-5]",
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
	self._PossReload = nil
	self._PossPrimaryAttack = nil
	self._PossSecondaryAttack = nil
	self.AnswerChatter = nil
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if self:GetBehavior() == 1 then return end
	if disp == D_HT || disp == D_FR then
		if !self:CanSee(enemy) then return end
		self.delayHide = CurTime() +math.Rand(8,20)
		self:StartSchedule(schdHide)
		self.bInSchedule = true
	end
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if event == "crouchidle" then
		if CurTime() >= self.delayHide || self:GetBehavior() > 0 || (IsValid(self.entEnemy) && self:CanSee(self.entEnemy)) then
			self.bInSchedule = false
			self.delayHide = nil
			self:PlayActivity(ACT_STAND,false,function()
				self.bInSchedule = false
				self:TaskComplete()
			end)
			return
		end
		self:PlayActivity(ACT_CROUCHIDLE,false)
		return
	end
end