AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
util.AddNetworkString("DeepPWCRaid")

function ENT:Initialize()
    self:SetModel("models/props/de_dust/du_crate_64x80.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)


    self.cooldown = 0
end


function ENT:Use(caller, activator)
    if not activator:IsCP() then
        return activator:Notify("This cache appears to contain pre-war weapons, we might need something strong to blow it open...")
    end
end


function ENT:StartC4()
    local id = self:GetCreationID()

    timer.Create(id .. "DeepPWCBox", 2, math.floor(impulse.Config.PreWarCacheTime/2), function()
        self:EmitSound("buttons/button17.wav")
    end)
    timer.Create("PWCCooldown", 900, 1, function()
        timer.Remove("PWCCooldown")
    end)

    local rf = RecipientFilter()

    for v,k in pairs(player.GetAll()) do
       if k:IsCP() then
           rf:AddPlayer(k)
       end 
    end

    if jammer == true then
        timer.Simple(20, function()
            net.Start("DeepPWCRaid")
            net.WriteVector(self:GetPos())
            net.Send(rf)
        end)
    else
        net.Start("DeepPWCRaid")
        net.WriteVector(self:GetPos())
        net.Send(rf)
    end

    timer.Simple(impulse.Config.PreWarCacheTime + 1, function()
        if not IsValid(self) then
            return
        end

        self:EmitBudgetSound("ambient/explosions/explode_1.wav")

        local items, count = impulse.Loot.GenerateFromPool("prewarcache")
        local total = count * 0.9
        local x = 0.5
        local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()
        local pos = self:GetPos() + Vector(0, 25, 50)

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