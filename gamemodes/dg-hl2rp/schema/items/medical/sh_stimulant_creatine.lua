local ITEM = {}

ITEM.UniqueID = "stimulant_creatine"
ITEM.Name = "Creatine Pills"
ITEM.Desc =  "A set of pills that removes the effects of incoming force."
ITEM.Category = "Medical"
ITEM.Model = Model("models/pills7.mdl")
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
    if !timer.Exists(ply:SteamID() .. "creatinecd") then
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
        ply:Notify("You have consumed creatine pills.")
        ply:AddEFlags(EFL_NO_DAMAGE_FORCES)
	    timer.Create(ply:SteamID() .. "creatinestim", 600, 1, function()
            ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
            ply:Notify("The effects of the Creatine Pills have worn off.")
            ply.Drugs = math.Clamp(ply.Drugs - 1,0,5) 
        end)
        timer.Create(ply:SteamID() .. "creatinecd", 900, 1, function() end)
        ply:AddSkillXP("medical", math.random(3,8))
	    return true
    else
        ply:Notify("You cannot apply this, you would overdose.")
        return false
    end
end

impulse.RegisterItem(ITEM)