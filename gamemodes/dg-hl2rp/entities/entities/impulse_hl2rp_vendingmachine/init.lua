AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

-- set up cooldown and set up color changes
function ENT:Initialize()
    self:SetModel("models/props_interiors/vendingmachinesoda01a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:DrawShadow(false)

    local position = self:GetPos()
    local angles = self:GetAngles()
    self.stock = {}
    self:Refill()
    self.nextDispenseTime = 60
    local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()
end

function ENT:Use(activator)
    if self.nextDispenseTime > CurTime() then return end
    local button = self:GetNearestButton(activator)

    if button == 1 then
        self.nextDispenseTime = CurTime() + 3
        self:EmitSound("buttons/button2.wav")

        if self.stock[1] == 0 then
            activator:Notify("This item is out of stock.")

            return
        end

        if not activator:CanAfford(5) then
            activator:Notify("You can't afford this item.")

            return
        end

        self:BuyItem(activator, 6, 3, 10)
        if self:CPPIGetOwner() and self.stock[1] >= 1  then
            self:CPPIGetOwner():GiveMoney(2)
            self:CPPIGetOwner():Notify("You have received 2 credits from a vending machine sale.")
        end
        self.stock[1] = self.stock[1] - 1

        if self.stock[1] == 0 then
            self:SetStock1(false)
        end
    elseif button == 2 then
        self.nextDispenseTime = CurTime() + 3
        self:EmitSound("buttons/button2.wav")

        if self.stock[2] == 0 then
            activator:Notify("This item is out of stock.")

            return
        end

        if not activator:CanAfford(15) then
            activator:Notify("You can't afford this item.")

            return
        end

        self:BuyItem(activator, 15, 2, 10)
        self.stock[2] = self.stock[2] - 1

        if self:CPPIGetOwner() and self.stock[2] >= 1 then
            self:CPPIGetOwner():GiveMoney(4)
            self:CPPIGetOwner():Notify("You have received 4 credits from a vending machine sale.")
        end

        if self.stock[2] == 0 then
            self:SetStock2(false)
        end
    elseif button == 3 then
        self.nextDispenseTime = CurTime() + 3
        self:EmitSound("buttons/button2.wav")

        if self.stock[3] == 0 then
            activator:Notify("This item is out of stock.")

            return
        end

        if not activator:CanAfford(5) then
            activator:Notify("You can't afford this item.")

            return
        end

        self:BuyItem(activator, 20, 1, 20)
        self.stock[3] = self.stock[3] - 1

        if self:CPPIGetOwner() and self.stock[3] >= 1  then
            self:CPPIGetOwner():GiveMoney(6)
            self:CPPIGetOwner():Notify("You have received 6 credits from a vending machine sale.")
        end

        if self.stock[3] == 0 then
            self:SetStock3(false)
        end
    elseif button == 4 then
        self.nextDispenseTime = CurTime() + 3
        self:EmitSound("buttons/button2.wav")

        if self.stock[4] == 0 then
            activator:Notify("This item is out of stock.")

            return
        end

        if not activator:CanAfford(10) then
            activator:Notify("You can't afford this item.")

            return
        end

        self:BuyItem(activator, 10, 1, 20)
        self.stock[4] = self.stock[4] - 1

        if self:CPPIGetOwner() and self.stock[4] >= 1  then
            self:CPPIGetOwner():GiveMoney(3)
            self:CPPIGetOwner():Notify("You have received 3 credits from a vending machine sale.")
        end

        if self.stock[4] == 0 then
            self:SetStock4(false)
        end
    else
        if activator:Team() == TEAM_CWU and activator:GetTeamClass() == CLASS_INDUST then
            if self:NeedsRefill() then
                tokens = impulse.Config.VendingRefillReward

                self:Refill(activator)
                activator:Notify("You have refilled the machine and received " .. impulse.Config.CurrencyPrefix .. tokens..".")

                activator:GiveMoney(tokens)
            else
                activator:Notify("This machine does not need a refill.")
            end
        end
    end
end

function ENT:BuyItem(ply, cost, mskin, hunger)
    if ply:CanAfford(cost) then
        ply:TakeMoney(cost)
        self:Dispense(mskin, hunger)
        ply:Notify("You have bought a drink for " .. cost .. " tokens.")
    else
        ply:Notify("You are unable to afford this drink.")
    end
end

function ENT:Refill()
    self.stock[1] = 28
    self.stock[2] = 5
    self.stock[3] = 3
    self.stock[4] = 10
    self:SetStock1(true)
    self:SetStock2(true)
    self:SetStock3(true)
    self:SetStock4(true)
    self:EmitSound("ambient/machines/combine_terminal_idle1.wav")
end

function ENT:NeedsRefill()
    if (self.stock[1] + self.stock[2] + self.stock[3]) < 11 or self.stock[1] == 0 or self.stock[2] == 0 or self.stock[3] == 0 or self.stock[4] == 0 then
        return true
    else
        return false
    end
end

function ENT:Dispense(skinnr, food)
    local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()
    local position = self:GetPos()

    timer.Simple(1, function()
        if not IsValid(self) then return end
        local spawnPos = position + f * 19 + r * 4 + u * -26

        if skinnr == 1 then
            impulse.Inventory.SpawnItem("food_waterspecial", spawnPos)
        elseif skinnr == 2 then
            impulse.Inventory.SpawnItem("food_watersparkling", spawnPos)
        elseif skinnr == 3 then
            impulse.Inventory.SpawnItem("food_water", spawnPos)
        elseif skinnr == 4 then
            impulse.Inventory.SpawnItem("food_coffee", spawnPos)
        end
    end)
end

function ENT:OnRemove()
    if not self.CPPIGetOwner then return end
    local owner = self:CPPIGetOwner()
    if not IsValid(owner) then return end
    owner.VendingMachines = math.max((owner.VendingMachines or 1) - 1, 0)
end
