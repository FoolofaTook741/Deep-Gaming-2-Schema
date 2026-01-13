local ITEM = {}

ITEM.UniqueID = "stimulant_morphine"
ITEM.Name = "Morphine Pills"
ITEM.Desc =  "A set of pills that increases your vitality against attacks, high chance for misuse."
ITEM.Category = "Medical"
ITEM.Model = Model("models/pills6.mdl")
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
ITEM.UseWorkBarTime = 8
ITEM.UseWorkBarName = "Consuming..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "items/smallmedkit1.wav"

function ITEM:CanUse(ply)
	if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU then
	    return true
    end
end

function ITEM:OnUse(ply)
    if !timer.Exists(ply:SteamID() .. "morphinestimcd") then
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
        local maxhealth = 150
        local addhealth = 50 
        if chance < 20 then
            maxhealth = 75
            addhealth = -25
            ply:Notify("You have taken the Morphine Pills, but they had a negative impact.")
        else
            addhealth = 50
            maxhealth = 150
            ply:Notify("You have taken the Morphine Pills.")
        end
        ply:SetHealth(math.Clamp(ply:Health() + addhealth, 1, 150))
        ply:SetMaxHealth(maxhealth)
	    timer.Create(ply:SteamID() .. "morphinestim", 300, 1, function()
            if (ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU) and ply:IsCharacterFemale() then
                ply:SetMaxHealth(impulse.Config.DefaultFemaleHealth)
                if ply:Health() > impulse.Config.DefaultFemaleHealth then
                    ply:SetHealth(impulse.Config.DefaultFemaleHealth)
                end
                ply:Notify("The effects of the Morphine Pills have worn off.")
                ply.Drugs = math.Clamp(ply.Drugs - 1,0,5) 
            else
                ply:SetMaxHealth(impulse.Config.DefaultMaleHealth)
                if ply:Health() > impulse.Config.DefaultMaleHealth then
                    ply:SetHealth(impulse.Config.DefaultMaleHealth)
                end
                ply:Notify("The effects of the Morphine Pills have worn off.")
                ply.Drugs = math.Clamp(ply.Drugs - 1,0,5) 
            end
        end)
        timer.Create(ply:SteamID() .. "morphinestimcd", 600, 1, function() end)
        ply:AddSkillXP("medical", math.random(3,8))
	    return true
    else
        ply:Notify("You cannot apply this, you would overdose.")
        return false
    end
end

impulse.RegisterItem(ITEM)