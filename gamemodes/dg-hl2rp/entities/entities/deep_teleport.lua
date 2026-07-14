AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Teleport"
ENT.Category = "impulse"
ENT.Spawnable = false

TP_ENTRY = 0
TP_EXIT = 1

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "TeleportID")
    self:NetworkVar("Int", 1, "TeleportType")
end 

function ENT:GetPairedTeleport()
    if not self.cachedTP then 
        for i, v in ipairs(ents.FindByClass("deep_teleport")) do 
            if v:GetTeleportID() ~= self:GetTeleportID() or v == self then continue end 

            self.cachedTP = v
        end 
    end 

    return self.cachedTP
end 

function ENT:CheckIDAllocated(id)
    local t = false

    for i, v in ipairs(ents.FindByClass("deep_teleport")) do 
        if v:GetTeleportID() ~= id or v == self then continue end 

        t = true
    end 

    return t
end 

local tpId = 0

function ENT:AllocateID()
    tpId = tpId + 1

    local isUsed = self:CheckIDAllocated(tpId)

    if isUsed then 
        self:AllocateID() -- tpId auto-increments
    end 

    self:SetTeleportID(tpId)
end 

-- This will be called on both the Client and Server realms
function ENT:Initialize()
	-- Ensure code for the Server realm does not accidentally run on the Client
	if SERVER then
	    self:SetModel( "models/hunter/plates/plate2x4.mdl" ) -- Sets the model for the Entity.
	    self:PhysicsInit( SOLID_VPHYSICS ) -- Initializes physics for the Entity, making it solid and interactable.
	    --self:SetMoveType( MOVETYPE_VPHYSICS ) -- Sets how the Entity moves, using physics.
	    self:SetSolid( SOLID_VPHYSICS ) -- Makes the Entity solid, allowing for collisions.
	    local phys = self:GetPhysicsObject() -- Retrieves the physics object of the Entity.
	    if phys:IsValid() then -- Checks if the physics object is valid.
	        phys:Wake() -- Activates the physics object, making the Entity subject to physics (gravity, collisions, etc.).
	    end

        self:AllocateID()
        self:SetTeleportType(TP_ENTRY)  

        self.nocollideId = AddTeleportEntity(self)

        self:CallOnRemove("cleanupNocollide", function(s)
            RemoveTeleportEntity(s.nocollideId)
        end)
	end
end

function ENT:Touch(target)
    if !target or !target:IsPlayer() then return end
    if self:GetTeleportType() == TP_EXIT then return end

    local pair = self:GetPairedTeleport()

    if !IsValid(pair) then return end 

    target:SetPos(pair:GetPos() + pair:GetAngles():Up() * 50)
    --target:SetPos(pair:GetPos() + pair:GetAngles():Forward() * 50)
end 

-- This is a common technique for ensuring nothing below this line is executed on the Server
if not CLIENT then return end

-- Client-side draw function for the Entity
function ENT:Draw()
    self:DrawModel() -- Draws the model of the Entity. This function is called every frame.
end