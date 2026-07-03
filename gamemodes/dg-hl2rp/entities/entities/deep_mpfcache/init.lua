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
    if not activator:IsCP() then
        return activator:Notify("This cache appears to contain MPF supplies, we might need something break it open...")
    end
    if self.cooldown > CurTime() then return end
    self.cooldown = CurTime() + 1.2

    if not activator:IsCP() then
        return activator:Notify("The box is locked. You'll need something more powerful to open it...")
    elseif self.Drilling then
        return activator:Notify("You can't use the ammo box right now.")
    end

    --self:ResetSequence(self.openSequence)
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

    local hasPulseOrbWeapon = activator:HasWeapon("plutonic_xar2_orb")
    if hasPulseOrbWeapon then
        local currentOrbAmmo = activator:GetAmmoCount("AR2AltFire")
        if currentOrbAmmo < 1 and activator:Team() == TEAM_OTA and activator:GetTeamClass() == CLASS_FIST then
            activator:SetAmmo(1, game.GetAmmoID("AR2AltFire"))
            activator:Notify("AR Energy Orb Ammunition replenished.")
        end
    end

    for _, weapon in pairs(activator:GetWeapons()) do
        local ammoName = game.GetAmmoName(weapon:GetPrimaryAmmoType())
        if ammoName == "AR2AltFire" then continue end

        if impulse.Dispatch.GetCityCode() >= CODE_AJ or RES_BANDOLIERS == true then
            if ammoValues[ammoName] then
                local ammoCount = activator:GetAmmoCount(ammoName)
                if ammoCount and ammoCount < ammoValues[ammoName] * 3 then
                    activator:SetAmmo(math.floor(ammoValues[ammoName] * 3), weapon:GetPrimaryAmmoType())
                end
            end
        elseif self.Enhanced == true then
            if ammoValues[ammoName] then
                local ammoCount = activator:GetAmmoCount(ammoName)
                if ammoCount and ammoCount < ammoValues[ammoName] * 1.5 then
                    activator:SetAmmo(math.floor(ammoValues[ammoName] * 1.5), weapon:GetPrimaryAmmoType())
                end
            end
        else
            if ammoValues[ammoName] then
                local ammoCount = activator:GetAmmoCount(ammoName)
                if ammoCount and ammoCount < ammoValues[ammoName] then
                    activator:SetAmmo(ammoValues[ammoName], weapon:GetPrimaryAmmoType())
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

function ENT:StartThermite(jam)
    self.Drilling = true
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

        self.Drilling = false
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