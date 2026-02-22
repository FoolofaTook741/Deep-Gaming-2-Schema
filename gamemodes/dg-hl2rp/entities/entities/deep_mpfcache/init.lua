AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
util.AddNetworkString("DeepMPFCRaid")

function ENT:Initialize()
    self:SetModel("models/synapse/props/fabricator.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)


    self.cooldown = 0
end


function ENT:Use(caller, activator)
    if not activator:IsCP() then
        return activator:Notify("This cache appears to contain MPF supplies, we might need something break it open...")
    end
end


function ENT:StartThermite(jam)
    local id = self:GetCreationID()

    timer.Create(id .. "DeepMPFCBox", 2, math.floor(impulse.Config.MPFCacheTime / 2), function()
        self:EmitSound("buttons/button17.wav")
    end)
    timer.Create("MPFCCooldown", 900, 1, function()
        timer.Remove("MPFCCooldown")
    end)

    local rf = RecipientFilter()

    for v,k in pairs(player.GetAll()) do
       if k:IsCP() then
           rf:AddPlayer(k)
       end 
    end

    if jam == true then
        timer.Simple(20, function()
            net.Start("DeepMPFCRaid")
            net.WriteVector(self:GetPos())
            net.Send(rf)
        end)
    else
        net.Start("DeepMPFCRaid")
        net.WriteVector(self:GetPos())
        net.Send(rf)
    end

    timer.Simple(impulse.Config.MPFCacheTime + 1, function()
        if not IsValid(self) then
            return
        end

        self:EmitBudgetSound("ambient/explosions/explode_1.wav")

        local items, count = impulse.Loot.GenerateFromPools({"mpfweaponcache", "mpfammocache", "mpfarmorcache", "mpfmedcache"}) --mpfweaponcache, mpfammocache, mpfarmorcache, mpfmedcache
        local total = count * 0.9
        local x = 0.5
        local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()
        local pos = self:GetPos() + Vector(0, 0, 70)

        for v,k in pairs(items) do
        	for i=1, k do
        		timer.Simple(x, function()
        			if not IsValid(self) then
        				return
        			end

        			local e = impulse.Inventory.SpawnItem(v, pos, nil, 300)
        		end)

        		x = x + 2
        	end
        end
        

        timer.Simple(total, function()
            if not IsValid(self) then
                return
            end

            self.LastRaided = CurTime() + 1500
        end)

    end)
end