AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_c17/woodbarrel001.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:DrawShadow(false)

    local physObj = self:GetPhysicsObject()

    if (IsValid(physObj)) then
        physObj:Wake()
    end

    self:SetHealth(20)
    self.Percentage = 0
    self.FinishedProducts = {}
end

function ENT:Use(caller, activator)
    if self:GetEndTime() < CurTime() and self:GetEndTime() ~= 0 then
        if activator:IsCP() then
            return
        end
        
        if activator:CanHoldItem("util_moonshine", 1) then
            activator:GiveInventoryItem("util_moonshine")
            activator:Notify("Moonshine bottle added to inventory.")
            --[[]
            if activator.CurrentQuest == QUEST_MOONSHINE then
                activator:CompleteQuest()
            end
            --]]
            self:EmitBudgetSound("impulse/craft/water/" .. math.random(1, 3) .. ".wav")
            self:SetEndTime(0)
        else
            activator:Notify("You dont have enough space.")
        end
    end
end

function ENT:PhysicsCollide(colData, collider)
    if colData.HitEntity:GetClass() ~= "impulse_hl2rp_brewingingredient" then return end
    local ingredient = colData.HitEntity

    if self:AddIngredient(ingredient.Type, 35) then
        ingredient:Remove()
    end
end

function ENT:OnRemove()
    if not self.CPPIGetOwner then return end
    local owner = self:CPPIGetOwner()
    if not IsValid(owner) then return end
    owner.BarrelCount = math.max((owner.BarrelCount or 1) - 1, 0)
end

function ENT:AllIngredientsPresent()
    for v, k in pairs(self.Ingredients) do
        if not k.isPresent then return false end
    end

    return true
end

function ENT:AddIngredient(name)
    for v, k in pairs(self.Ingredients) do
        if k.name == name and k.isPresent == false then
            self.Ingredients[v].isPresent = true

            if self:AllIngredientsPresent() then
                self:StartBrewing()
            end
            return true
        end
    end

    return false
end

function ENT:StartBrewing()
    self:SetStartTime(CurTime())
    self:SetEndTime(CurTime() + impulse.Config.BrewingTime)

    for v, k in pairs(self.Ingredients) do
        k.isPresent = false
    end
end

function ENT:Think()
    self:NextThink(CurTime() + 1)

    if self:WaterLevel() == 3 and self:GetEndTime() != 0 then
        self:SetEndTime(0)
    end
    
    if (self.nextSound or 0) < CurTime() then
        self.nextSound = CurTime() + math.random(15, 36)

        self:EmitSound("ambient/levels/canals/toxic_slime_sizzle"..math.random(1, 4)..".wav", 70)
    end

    return true
end

function ENT:OnTakeDamage(damage)
    self:SetHealth(self:Health() - damage:GetDamage())

    if self:Health() < 25 and not self.IsIgnited then
        self.IsIgnited = true
        self:Ignite(15)

        timer.Simple(15, function()
            if not IsValid(self) then return end
            self:Explode()
        end)
    end

    if self:Health() < 0 and not self.IsExploding then
        self:Explode()
    end
end

function ENT:Explode()
    self.IsExploding = true
    local explosion = ents.Create("env_explosion")
    explosion:SetKeyValue("spawnflags", 144)
    explosion:SetKeyValue("iMagnitude", 15)
    explosion:SetKeyValue("iRadiusOverride", 256)
    explosion:SetPos(self:GetPos())
    explosion:Spawn()


    explosion:Fire("explode", "", 0)
    self:Remove()
end
