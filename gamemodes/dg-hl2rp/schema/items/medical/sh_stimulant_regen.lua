local ITEM = {}

ITEM.UniqueID = "stimulant_regen"
ITEM.Name = "Androstenedione Pills"
ITEM.Desc =  "A set of pills that gradually regenerates lost muscle and tissue."
ITEM.Category = "Medical"
ITEM.Model = Model("models/pills3.mdl")
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
    if !timer.Exists(ply:SteamID() .. "regstimcd") then
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
        local healamount = 2
        if chance < 5 then
            healamount = -2
            ply:Notify("You have taken the Androstenedione Pills and had a negative impact.")
        else
            healamount = 2
            ply:Notify("You have taken the Androstenedione Pills.")
        end
        ply:Notify("You have taken the Androstenedione Pills.")
	    timer.Create(ply:SteamID() .. "regstim", 60, 1, function()
            if ply:Health() + healamount > 0 then
                ply:SetHealth(math.Clamp(ply:Health() + (healamount * (1 - (ply.Antiheal or 0))), 0, ply:GetMaxHealth()))
            else
                ply:Notify("The negative effects of the Androstenedione Pills have worn off.")
                timer.Remove(ply:SteamID() .. "regstim")
                ply.Drugs = math.Clamp(ply.Drugs - 1,0,5) 
            end
        end)
        timer.Create(ply:SteamID() .. "regstimcd", 180, 1, function() 
            if ply.Drugs - 1 < 0 then
                ply.Drugs = 0
            else
                ply.Drugs = math.Clamp(ply.Drugs - 1,0,5) 
            end 
        end)
        ply:AddSkillXP("medical", math.random(3,8))
	    return true
    else
        ply:Notify("You cannot apply this, you would overdose.")
        return false
    end
end

impulse.RegisterItem(ITEM)
