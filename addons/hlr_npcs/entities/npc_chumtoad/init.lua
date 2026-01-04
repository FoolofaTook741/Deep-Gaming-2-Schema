AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.sModel = "models/half-life/chumtoad.mdl"
ENT.bPlayDeathSequence = true

ENT.skName = "chumtoad"
ENT.CollisionBounds = Vector(12,12,24)

ENT.iBloodType = BLOOD_COLOR_YELLOW
ENT.sSoundDir = "npc/chumtoad/"

ENT.tblDeathActivities = {
	[HITBOX_GENERIC] = ACT_DIESIMPLE
}
ENT.tblAlertAct = {}

ENT.m_tbSounds = {
	["Hunt"] = "toad_hunt[1-3].wav",
	["Death"] = "toad_die1.wav",
	["Idle"] = "toad_idle1.wav"
}

function ENT:OnInit()
	self:SetHullType(HULL_TINY)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_MOVE_JUMP))
	self:SetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	
	self:SetSkin(math.random(0,3))
	self:SetState(NPC_STATE_ALERT)
end

function ENT:OnStateChanged(old, new)
	if new == NPC_STATE_IDLE then self:SetState(NPC_STATE_ALERT) end
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	timer.Simple(1, function()
		if !IsValid(self) || !self:IsPossessed() then return end
		fcDone(true)
	end)
	self:PlaySound("Hunt")
end

function ENT:OnCondition(iCondition)
end

function ENT:HearEnemy()
	return false
end

function ENT:OnWander()
	self:PlaySound("Hunt")
end

function ENT:OnThink()
	if self.bDead || self.bPossessed || tobool(GetConVarNumber("ai_disabled")) || self:PercentageFrozen() >= 80 then return end
	for k, v in pairs(player.GetAll()) do
		if IsValid(v) && self:OBBDistance(v) <= 40 && !v:IsPossessing() then
			if !v:HasWeapon("weapon_chumtoad") then
				v:Give("weapon_chumtoad")
				local wep = v:GetWeapon("weapon_chumtoad")
				table.insert(wep.tblChumtoads, self:GetSkin())
				self:Remove()
				return
			else
				local iAmmo = v:GetAmmunition("chumtoad")
				if iAmmo < 5 then
					v:AddAmmunition("chumtoad", 1)
					v:EmitSound("items/ammo_pickup.wav", 75, 100)
					local wep = v:GetWeapon("weapon_chumtoad")
					if iAmmo == 0 then
						if wep == v:GetActiveWeapon() then
							v:GetViewModel():SetSkin(self:GetSkin())
							wep:SetSkin(self:GetSkin())
							wep:Deploy()
						end
					end
					table.insert(wep.tblChumtoads, self:GetSkin())
					local rp = RecipientFilter() 
					rp:AddPlayer(v)
					
					local ammoName = util.GetAmmoName("chumtoad")
					umsg.Start("HLR_HUDItemPickedUp", rp)
						umsg.String(ammoName .. "," .. 1)
					umsg.End()
					self:Remove()
				end
			end
		end
	end
end
