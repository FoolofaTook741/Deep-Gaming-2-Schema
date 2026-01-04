local ITEM = {}

ITEM.UniqueID = "stimulant_steroids"
ITEM.Name = "Anabolic Steroid Pills"
ITEM.Desc =  "A set of pills makes you RAGE and increases your muscular strength."
ITEM.Category = "Medical"
ITEM.Model = Model("models/pills.mdl")
ITEM.FOV = 5
ITEM.CamPos = Vector(100, 100, 0)
ITEM.NoCenter = true
ITEM.Weight = 0.5

ITEM.Droppable = true
ITEM.DropOnDeath = false

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
    if !timer.Exists(ply:SteamID() .. "steroidcd") then
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
        local meleemult = 2
        if chance < 8 then
            meleemult = 0.5
            ply:Notify("You have taken the Anabolic Steroid Pills, but you had a negative reaction.")
        else
            meleemult = 2
            ply:Notify("You have taken the Anabolic Steroid Pills.")
        end
        ply.MeleeMult = meleemult
	    timer.Create(ply:SteamID() .. "steroidstim", 300, 1, function()
            ply.MeleeMult = 1
            ply:Notify("The effects of the Anabolic Steroid Pills have worn off.")
            ply.Drugs = math.Clamp(ply.Drugs - 1,0,5) 
        end)
        timer.Create(ply:SteamID() .. "steroidcd", 480, 1, function() end)
        ply:AddSkillXP("medical", math.random(3,8))
	    return true
    else
        ply:Notify("You cannot apply this, you would overdose.")
        return false
    end
end

impulse.RegisterItem(ITEM)