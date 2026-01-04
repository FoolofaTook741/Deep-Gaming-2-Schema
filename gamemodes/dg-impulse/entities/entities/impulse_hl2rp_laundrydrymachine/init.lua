AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

sound.Add({
    name = "laundrysound",
    channel = CHAN_AUTO,
    volume = 1.0,
    level = 80,
    pitch = {95, 110},
    sound = "ambient/atmosphere/pipe1.wav"
})

function ENT:Initialize()
    self:SetModel("models/props_wasteland/laundry_washer003.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetTrigger(true)
    self.isWashing = false
    self:SetLaundry1(LAUNDRYSTATE_EMPTY)
    self:SetLaundry2(LAUNDRYSTATE_EMPTY)
    self:SetLaundry3(LAUNDRYSTATE_EMPTY)
    self:SetLaundry4(LAUNDRYSTATE_EMPTY)
    self.NextUse = CurTime()
end

function ENT:Use()
    if self.NextUse > CurTime() then return end
    self.NextUse = CurTime() + 8
    local laundryTable = {self:GetLaundry1(), self:GetLaundry2(), self:GetLaundry3(), self:GetLaundry4()}
    local dispenseAmount = 0

    for v, k in pairs(laundryTable) do
        if k == LAUNDRYSTATE_DONE then
            dispenseAmount = dispenseAmount + 1
            self:DispenseLaundry(v)

            timer.Simple(2 * dispenseAmount, function()
                self:RemoveLaundry(v)
                self:Dispense()
            end)
        end
    end

    if dispenseAmount == 0 then
        self:EmitBudgetSound("buttons/button2.wav")
    else
        self:EmitBudgetSound("buttons/lever3.wav")
    end
end

function ENT:StartTouch(collider)
    local laundryTable = {self:GetLaundry1(), self:GetLaundry2(), self:GetLaundry3(), self:GetLaundry4()}

    if collider:GetClass() == "impulse_hl2rp_laundryitem" then
        if self.lastTouchTime > CurTime() then return end

        if collider.state == 1 then
            for v, k in pairs(laundryTable) do
                if k == LAUNDRYSTATE_EMPTY then
                    self:AddLaundry(v)
                    self.storedWorkers = collider.workers
                    timer.Simple(0, function() 
                        if IsValid(collider) then
                            collider:Remove()
                        end
                    end)
                    self.lastTouchTime = CurTime() + 2

                    return
                end
            end

            self:EmitSound("items/suitchargeno1.wav")
            self.lastTouchTime = CurTime() + 2
        end
    end
end

function ENT:DispenseLaundry(slot)
    if slot == 1 then
        self:SetLaundry1(LAUNDRYSTATE_DISPENSING)
    elseif slot == 2 then
        self:SetLaundry2(LAUNDRYSTATE_DISPENSING)
    elseif slot == 3 then
        self:SetLaundry3(LAUNDRYSTATE_DISPENSING)
    elseif slot == 4 then
        self:SetLaundry4(LAUNDRYSTATE_DISPENSING)
    end
end

function ENT:RemoveLaundry(slot)
    self:EmitSound("items/ammocrate_open.wav")

    if slot == 1 then
        self:SetLaundry1(LAUNDRYSTATE_EMPTY)
    elseif slot == 2 then
        self:SetLaundry2(LAUNDRYSTATE_EMPTY)
    elseif slot == 3 then
        self:SetLaundry3(LAUNDRYSTATE_EMPTY)
    elseif slot == 4 then
        self:SetLaundry4(LAUNDRYSTATE_EMPTY)
    end

    local laundryTable = {self:GetLaundry1(), self:GetLaundry2(), self:GetLaundry3(), self:GetLaundry4()}

    for _, k in pairs(laundryTable) do
        if k == LAUNDRYSTATE_PROCESSING then return end
    end

    self.isWashing = false
    self:StopSound("laundrysound")
end

function ENT:AddLaundry(slot)
    self:EmitSound("items/ammocrate_close.wav")

    if slot == 1 then
        self:SetLaundry1(LAUNDRYSTATE_PROCESSING)

        timer.Simple(self.DryingTime, function()
            self:SetLaundry1(LAUNDRYSTATE_DONE)
            self:EmitSound("buttons/lever5.wav")
        end)
    elseif slot == 2 then
        self:SetLaundry2(LAUNDRYSTATE_PROCESSING)

        timer.Simple(self.DryingTime, function()
            self:SetLaundry2(LAUNDRYSTATE_DONE)
            self:EmitSound("buttons/lever5.wav")
        end)
    elseif slot == 3 then
        self:SetLaundry3(LAUNDRYSTATE_PROCESSING)

        timer.Simple(self.DryingTime, function()
            self:SetLaundry3(LAUNDRYSTATE_DONE)
            self:EmitSound("buttons/lever5.wav")
        end)
    elseif slot == 4 then
        self:SetLaundry4(LAUNDRYSTATE_PROCESSING)

        timer.Simple(self.DryingTime, function()
            self:SetLaundry4(LAUNDRYSTATE_DONE)
            self:EmitSound("buttons/lever5.wav")
        end)
    end

    if self.isWashing == false then
        self:EmitSound("laundrysound")
        self.isWashing = true
    end
end

function ENT:Dispense()
    self:EmitBudgetSound("physics/cardboard/cardboard_box_impact_hard1.wav")
    local cleanLaundry = ents.Create("impulse_hl2rp_laundryitem")
    local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()
    cleanLaundry:SetPos(self:GetPos() + f * -18 + r * -16 + u * 17)
    cleanLaundry:SetAngles(self:GetAngles() + Angle(-40, -90, 0))
    cleanLaundry:SetStage(2)
    cleanLaundry.workers = self.storedWorkers
    cleanLaundry:Spawn()
    cleanLaundry:SetColor(Color(255, 255, 255))
    cleanLaundry.state = 2
end

function ENT:OnRemove()
    self:StopSound("laundrysound")
end