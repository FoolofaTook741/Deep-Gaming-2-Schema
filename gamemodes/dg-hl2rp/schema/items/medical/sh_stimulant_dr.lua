local ITEM = {}

ITEM.UniqueID = "stimulant_dr"
ITEM.Name = "Ibuprofen Pills"
ITEM.Desc =  "A stimulant packet that increases your damage resistance."
ITEM.Category = "Medical"
ITEM.Model = Model("models/pills1.mdl")
ITEM.FOV = 5
ITEM.CamPos = Vector(100, 100, 0)
ITEM.NoCenter = true
ITEM.Weight = 0.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Consume"
ITEM.UseWorkBarTime = 2
ITEM.UseWorkBarName = "Consuming..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "items/smallmedkit1.wav"

function ITEM:OnUse(ply)
    if !timer.Exists(ply:SteamID() .. "drstimcd") then
        if ply.Drugs then
            ply.Drugs = (ply.Drugs + 1) or 0
        else
            ply.Drugs = 1
        end
        if ply.Drugs > 2 then
            ply:Kill()
            ply.Drugs = math.Clamp(ply.Drugs - 1,0,5) 
            return false
        end
        local chance = math.random(0,15) + ply:GetSkillLevel("medical")
        if chance > 5 then
            ply.DR = 5
            ply:Notify("You have taken the Ibuprofen Pills you now have an additional 5% damage reduction to all parts for 10 minutes.")
        else
            ply.DR = -5
            ply:Notify("You have taken the Ibuprofen Pills but had a negative reaction, you now take 5% more damage to all parts.")
        end
	    timer.Create(ply:SteamID() .. "drstim", 600, 1, function()
            if not IsValid(ply) then return end
            ply.DR = 0
            ply:Notify("The effects of the Ibuprofen Pills have worn off.")
        end)
        timer.Create(ply:SteamID() .. "drstimcd", 900, 1, function() end)
        ply:AddSkillXP("medical", math.random(3,8))
	    return true
    else
        ply:Notify("You cannot apply this, you would overdose.")
        return false
    end
end

impulse.RegisterItem(ITEM)
