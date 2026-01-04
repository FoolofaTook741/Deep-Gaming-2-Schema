AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props/de_prodigy/ammo_can_01.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:DrawShadow(false)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:EnableMotion(false)
    end

end

function ENT:OnTakeDamage(dmg)
    return false
end

function ENT:CanPlayerDeposit(ply)
	if not ply:IsInGroup() then
		return ply:Notify("You are not part of any group, so you cannot access group storage.")
	end
	
	if not ply:GroupHasPermission(9) then
		return ply:Notify("You do not have access to deposit into your groups storage.")
	end
	return true
end

function ENT:CanPlayerWithdraw(ply)
	if not ply:IsInGroup() then
		return ply:Notify("You are not part of any group, so you cannot access group storage.")
	end
	
	if not ply:GroupHasPermission(10) then
		return ply:Notify("You do not have access to access to withdraw from your groups storage.")
	end
	return true
end

function ENT:Use(activator, caller)
	if activator:IsPlayer() and activator:Alive() then
		if activator:GetSyncVar(SYNC_ARRESTED, false) then 
			return activator:Notify("You cannot access your group storage when detained.") 
		end

		if activator:IsCP() then
			return activator:Notify("You cannot access your group storage as this team.")
		end

		if not activator:IsInGroup() then
			return activator:Notify("You are not part of any group, so you cannot access group storage.")
		end
		
		if not (activator:GroupHasPermission(9) or activator:GroupHasPermission(10)) then
			return activator:Notify("You do not have access to access your groups storage.")
		end
		
		if not impulse.GroupStorageEnabled then activator:Notify("Group storage is currently disabled") return end

		net.Start("deepGroupStorageOpen")
		net.Send(activator)

		hook.Run("PlayerOpenStorage", activator, self)

		activator.currentStorage = self
	end
end

