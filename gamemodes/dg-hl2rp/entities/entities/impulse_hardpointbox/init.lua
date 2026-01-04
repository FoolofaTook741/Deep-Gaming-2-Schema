AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
util.AddNetworkString("impulseHL2RPAmmoRaid")

function ENT:Initialize()
    self:SetModel("models/items/ammocrate_smg1.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    self.Driling = false
    self.Enhanced = false

    self.openSequence = self:LookupSequence("Open")
    self.cooldown = 0
end

local ammoValues = {
    ["Pistol"] = 250,
    ["357"] = 36,
    ["SniperRound"] = 160,
    ["AirboatGun"] = 90,
    ["Rifle"] = 300,
    ["SMG1"] = 500,
    ["slam"] = 3,
    ["Grenade"] = 1,
    ["AR2"] = 450,
    ["Buckshot"] = 52,
    ["SniperPenetratedRound"] = 20,
    ["AlyxGun"] = 600,
    ["XBowBolt"] = 45,
    ["AR2AltFire"] = 1,
    ["SMG1_Grenade"] = 2,
}

function ENT:Use(caller, activator)
    if self.cooldown > CurTime() then return end
    self.cooldown = CurTime() + 1.2

    if not activator:IsCP() then 
        return activator:Notify("The box is locked. You'll need something more powerful to open it...")
    elseif self.Drilling then
        return activator:Notify("You can't use the ammo box right now.")
    end

    self:ResetSequence(self.openSequence)
    self:EmitBudgetSound("items/ammocrate_open.wav")

    timer.Simple(self:SequenceDuration(self.openSequence), function()
        if not IsValid(self) then return end
        self:ResetSequence(0)
        self:EmitBudgetSound("items/ammocrate_close.wav")
    end)

    timer.Simple(0.1, function()
        if not IsValid(self) or not IsValid(activator) then return end
        activator:EmitBudgetSound("items/ammo_pickup.wav")
    end)

    for v,k in pairs(activator:GetWeapons()) do
        local ammoName = game.GetAmmoName(k:GetPrimaryAmmoType())
        if impulse.Dispatch.GetCityCode() >= CODE_AJ or RES_BANDOLIERS == true and ammoName ~= "AR2AltFire" then
            if ammoValues[ammoName] then
                local ammoCount = activator:GetAmmoCount(ammoName)

                if ammoCount and ammoCount < ammoValues[ammoName] * 3 then
                    activator:SetAmmo(math.floor(ammoValues[ammoName] * 3), k:GetPrimaryAmmoType())
                end
            end
        elseif self.Enhanced == true then
            if ammoValues[ammoName] then
                local ammoCount = activator:GetAmmoCount(ammoName)

                if ammoCount and ammoCount < ammoValues[ammoName] * 1.5 then
                    activator:SetAmmo(math.floor(ammoValues[ammoName] * 1.5), k:GetPrimaryAmmoType())
                end
            end
        else
            if ammoValues[ammoName] then
                local ammoCount = activator:GetAmmoCount(ammoName)

                if ammoCount and ammoCount < ammoValues[ammoName] then
                    activator:SetAmmo(ammoValues[ammoName], k:GetPrimaryAmmoType())
                end
            end
        end
    end
    
    if self.Enhanced == true then
        activator:Notify("Your ammo has been restocked, due to O.C.A. funding you have received additional rounds.")
    else
        activator:Notify("Your ammo has been restocked.")
    end
end

function ENT:IsNearSignalJammerEntity()
	local result = false
	for k,v in pairs(ents.FindByClass("deep_signaljammer")) do
		if self:GetPos():Distance(v:GetPos()) < 900 then
			result = true
			break
		end
	end
	if result != true then
		for k,v in pairs(player.GetAll()) do
			if v.IsAJammer and v.IsAJammer == true then
				if v:GetPos():Distance(self:GetPos()) < 450 then
					result = true
					break
				end
			end
		end
	end
	return result
end


function ENT:StartDrill(jammer)
    self.Drilling = true
    self:SetDrillEndTime(CurTime() + impulse.Config.AmmoDrillTime)
    self:EmitSound("vehicles/digger_grinder_loop1.wav", 75, 120)

    local rf = RecipientFilter()

    for v,k in pairs(player.GetAll()) do
       if k:IsCP() then
           rf:AddPlayer(k)
       end 
    end

    if jammer == true then
        timer.Simple(60, function()
            net.Start("impulseHL2RPAmmoRaid")
            net.WriteVector(self:GetPos())
            net.Send(rf)
            if impulse.Dispatch.GetCityCode() < CODE_JW then
                impulse.Dispatch.SetCityCode(CODE_JW)
                impulse.Dispatch.SetupCityCode(CODE_JW)
            end
        end)
    else
        net.Start("impulseHL2RPAmmoRaid")
        net.WriteVector(self:GetPos())
        net.Send(rf)
        if impulse.Dispatch.GetCityCode() < CODE_JW then
            impulse.Dispatch.SetCityCode(CODE_JW)
            impulse.Dispatch.SetupCityCode(CODE_JW)
        end
    end

    timer.Simple(impulse.Config.AmmoDrillTime + 1, function()
        if not IsValid(self) then
            return
        end

        self:StopSound("vehicles/digger_grinder_loop1.wav")
        self:SetDrillEndTime(0)
        self.Drilling = false

        self:ResetSequence(self.openSequence)
        self:EmitBudgetSound("items/ammocrate_open.wav")

        local items, count = impulse.Loot.GenerateFromPool("hardpointammobox")
        local total = count * 0.9
        local x = 0.5
        local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()
        local pos = self:GetPos() + Vector(0, 0, 19)

        for v,k in pairs(items) do
        	for i=1, k do
        		timer.Simple(x, function()
        			if not IsValid(self) then
        				return
        			end

        			local e = impulse.Inventory.SpawnItem(v, pos, nil, 300)
        		end)

        		x = x + 0.9
        	end
        end
        

        timer.Simple(total, function()
            if not IsValid(self) then
                return
            end

            self:ResetSequence(0)
            self.LastRaided = CurTime() + 600
        end)

        local spawnpos = self:GetPos() + Vector(0,0,25)
		impulse.Inventory.SpawnItem("item_drill", spawnpos, nil, 300)
    end)
end