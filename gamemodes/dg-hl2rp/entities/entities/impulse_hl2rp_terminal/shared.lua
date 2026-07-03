ENT.Base            = "base_gmodentity"
ENT.Type            = "anim"
ENT.PrintName       = "Combine Terminal"
ENT.Author          = "vin"
ENT.Purpose         = ""
ENT.Instructions    = "Press E"
ENT.Category        = "impulse"

ENT.Spawnable       = true
ENT.AdminOnly       = true
ENT.Editable        = true 

ENT.HUDName         = "Combine Terminal"
ENT.HUDDesc         = "This can be used by Combine personnel."
ENT.Emped           = false

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "NetworkedUser")

    self:NetworkVar("Bool", 0, "ConvictIndex", { 
        KeyName = "Manage Prisoners", 
        Edit = { type = "Boolean", order = 1 } 
    })

    self:NetworkVar("Bool", 1, "OverwatchIndex", { 
        KeyName = "Manage City Code", 
        Edit = { type = "Boolean", order = 2 } 
    })
end

function ENT:IsEMPed()
    if SERVER then
        return self.Emped == true
    else
        return self:GetNWBool("TerminalEmped", false) 
    end
end