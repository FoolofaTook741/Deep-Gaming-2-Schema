AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/jq/hlvr/props/xenpack/xen_flat_blob01_barrel_mush01.mdl")
    self:SetNoDraw(true)
    self:DrawShadow(false)

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    
    self:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
    
    self:SetTrigger(true)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end
end

function ENT:StartTouch(ent)
    if ent:IsPlayer() and ent:Team() == TEAM_VORT then
        if ent.vortPortalCooldown and ent.vortPortalCooldown > CurTime() then return end

        local used, unused, total = ent:vortSkillPoints()

        if ent:GetBodygroup(8) ~= 1 and total >= VORTMAXSKILLS then
            ent:Notify("No further power can be drawn from Xen. You have gained the maximum number of skill points.")
			 ent.vortPortalCooldown = CurTime() + 10
            return
        end

        if ent:GetBodygroup(8) ~= 1 then
            ent:Notify("Your bond with Xen deepens")
            ent:vortAddSkillPoints(0.2)
            self:EmitSound("ambient/levels/labs/electric_explosion1.wav", 75, 100)
            self:Remove()
        else
            ent:Notify("Your restraints prevent you from harnessing this power!")
			ent.vortPortalCooldown = CurTime() + 10
        end
    end
end
