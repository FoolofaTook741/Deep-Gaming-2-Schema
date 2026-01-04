AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_wasteland/laundry_basket001.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then phys:Wake() end
end

function ENT:Use(activator, caller)
    local ply = activator
    local ent = self
    local timerName = "brewery_" .. ent:GetCreationID()
    local dropPos = ent:GetPos() + Vector(0,0,25)

    if not (ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU) then
        ply:Notify("You cannot interact with this item.")
        return
    end

    if timer.Exists(timerName) then
        ply:Notify("The Wine Brewery is already working.")
        return
    end

    if not (ply:HasInventoryItem("ing_sugar") and ply:HasInventoryItem("ing_grapes")) then
        ply:Notify("You need grapes, sugar, and a source of electricity to use this.")
        return
    end

    local hasPower = false
    for _, v in ipairs(ents.FindByClass("deep_outlet")) do
        if ent:GetPos():DistToSqr(v:GetPos()) < 300^2 then
            hasPower = true; break
        end
    end
    if not hasPower then
        for _, v in ipairs(ents.FindByClass("deep_generator")) do
            if v.powered and ent:GetPos():DistToSqr(v:GetPos()) < 300^2 then
                hasPower = true; break
            end
        end
    end

    if not hasPower then
        ply:Notify("You need grapes, sugar, and a source of electricity to use this.")
        return
    end

    ply:Notify("Brewing, return in 150 seconds.")
    ent:EmitSound("physics/metal/metal_canister_impact_soft2.wav")
    ply:TakeInventoryItemClass("ing_sugar")
    ply:TakeInventoryItemClass("ing_grapes")

    timer.Simple(2, function()
        if IsValid(ent) then
            ent:EmitSound("ambient/machines/lab_loop1.wav")
        end
    end)

    timer.Create(timerName, 150, 1, function()
        impulse.Inventory.SpawnItem("food_wine", dropPos)
        if IsValid(ply) then ply:Notify("Brewing complete!") end
        if IsValid(ent) then ent:StopSound("ambient/machines/lab_loop1.wav") end
    end)
end

function ENT:OnRemove()
    if not self.CPPIGetOwner then return end
    local owner = self:CPPIGetOwner()
    if not IsValid(owner) then return end
    owner.Winery = math.max((owner.Winery or 1) - 1, 0)
end