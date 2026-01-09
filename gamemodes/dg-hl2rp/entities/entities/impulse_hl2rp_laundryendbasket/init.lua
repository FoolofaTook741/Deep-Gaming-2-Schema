AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
--AddCSLuaFile("entities/thrawn_3d2d_terminal/cl_init.lua")

include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props_wasteland/laundry_cart002.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
end

function ENT:Think()
    local pos = self:GetPos()

    for _, ent in ipairs(ents.FindInSphere(pos, 20)) do
        if ent:GetClass() ~= "impulse_hl2rp_laundryitem" then continue end
        if not ent.isFolded then continue end

        local workers = ent.workers
        if not istable(workers) then
            ent:Remove()
            continue
        end

        local totalWorkers = table.Count(workers)
        if totalWorkers <= 0 then
            ent:Remove()
            continue
        end

        local baseReward = math.floor(impulse.Config.FactoryLaundryReward / totalWorkers)

        local pay = baseReward
        local msg = "You have received " .. impulse.Config.CurrencyPrefix .. baseReward .. " for working in the factory."

        if WORKSHIFT_LAUNDRY == true then
            pay = math.floor(baseReward * 1.75)
            msg = "You have received " .. impulse.Config.CurrencyPrefix .. pay .. " for working in the laundromat."
        end

        for ply, _ in pairs(workers) do
            if IsValid(ply) and ply:IsPlayer()
            and ply:Team() == TEAM_CWU
            and ply:GetTeamClass() == CLASS_INDUST then
                ply:GiveBankMoney(pay)
                ply:Notify(msg)
            end
        end

        ent:Remove()
    end

    self:NextThink(CurTime() + 2)
    return true
end
