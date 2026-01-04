AddCSLuaFile("shared.lua")

include('shared.lua')

local _R = debug.getregistry()
_R.NPCFaction.Create("NPC_FACTION_PLAYER","monster_g_man")
ENT.NPCFaction = NPC_FACTION_PLAYER
ENT.iClass = CLASS_PLAYER_ALLY
util.AddNPCClassAlly(CLASS_PLAYER_ALLY,"monster_g_man")
ENT.sModel = "models/half-life/gman.mdl"

ENT.bWander = true
ENT.bExplodeOnDeath = true
ENT.bPlayDeathSequence = true

ENT.skName = "gman"
ENT.CollisionBounds = Vector(13,13,45)

ENT.iBloodType = BLOOD_COLOR_RED
ENT.sSoundDir = "npc/gman/"

ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = {ACT_NO, ACT_BIGNO, ACT_DIESIMPLE}
}

ENT.m_tbSounds = {
	["Foot"] = "gman_step[1-4].wav",
	["Death"] = "gman_death[1-2].wav"
}

function ENT:OnInit()
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:CapabilitiesAdd(CAP_MOVE_GROUND)
	self:SetHealth(1200)
	self.nextSpeech = 0
	self:SetMaxYawSpeed(20)
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	if CurTime() < self.nextSpeech then fcDone(true); return end
	local tblSentences = {"!GM_SUIT", "!GM_NASTY", "!GM_POTENTIAL", "!GM_STEPIN", "!GM_OTHERWISE", "!GM_1CHOOSE", "!GM_2CHOOSE", "!GM_WISE", "!GM_REGRET", "!GM_WONTWORK"}
	local sSentence = tblSentences[math.random(1,10)]
	self:SpeakSentence(sSentence, entActivator)
	
	self.nextSpeech = CurTime() +self:GetSentenceLength(sSentence)
	fcDone(true)
end

function ENT:OnUse(activator,caller,type,value)
	if CurTime() < self.nextSpeech then return end
	local tblSentences = {"!GM_SUIT", "!GM_NASTY", "!GM_POTENTIAL", "!GM_STEPIN", "!GM_OTHERWISE", "!GM_1CHOOSE", "!GM_2CHOOSE", "!GM_WISE", "!GM_REGRET", "!GM_WONTWORK"}
	local sSentence = tblSentences[math.random(1,10)]
	MsgN(sSentence)
	self:SpeakSentence(sSentence, activator)
	
	self.nextSpeech = CurTime() +self:GetSentenceLength(sSentence)
end

function ENT:OnCondition( iCondition )
end