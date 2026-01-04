local ITEM = {}

ITEM.UniqueID = "stimulant_adderall"
ITEM.Name = "Adderall Pills"
ITEM.Desc =  "A set of pills that increases your focus."
ITEM.Category = "Medical"
ITEM.Model = Model("models/pills2.mdl")
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
    if !timer.Exists(ply:SteamID() .. "adderrallcd") then
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
        local recoilmult = 0.75
        if chance < 4 then
            recoilmult = 1.25
            ply:Notify("You have taken the Adderall Pills and had a negative impact.")
        else
            recoilmult = 0.75
            ply:Notify("You have taken the Adderall Pills.")
        end
        ply.RecoilMult = recoilmult
	    timer.Create(ply:SteamID() .. "adderrallstim", 600, 1, function()
            ply.RecoilMult = 1
            ply:Notify("The effects of the Adderall Pills have worn off.")
            ply.Drugs = math.Clamp(ply.Drugs - 1,0,5) or 0
        end)
        timer.Create(ply:SteamID() .. "adderrallcd", 900, 1, function() end)
        ply:AddSkillXP("medical", math.random(3,8))
	    return true
    else
        ply:Notify("You cannot apply this, you would overdose.")
        return false
    end
end

impulse.RegisterItem(ITEM)