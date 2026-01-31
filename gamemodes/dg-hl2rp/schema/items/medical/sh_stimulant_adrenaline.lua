local ITEM = {}

ITEM.UniqueID = "stimulant_adrenaline"
ITEM.Name = "Caffeinated Stimulant Pills"
ITEM.Desc =  "A stimulant packet that grants the user increased mobility."
ITEM.Category = "Medical"
ITEM.Model = Model("models/pills5.mdl")
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
    if !timer.Exists(ply:SteamID() .. "adrstimcd") then
        if ply.HasBackpack == true then
            ply:Notify("Taking adrenaline pills with a backpack has no effects so it has been blocked.")
            return false
        end
        if ply.Drugs then
            ply.Drugs = (ply.Drugs + 1) or 0
        else
            ply.Drugs = 1
        end
        if ply.Drugs > 2 then
            ply:Kill()
            ply.Drugs = ply.Drugs - 1 
            return false
        end
        ply:Notify("You have taken the Caffeinated Stimulant Pills.")
        local speed = ply:GetRunSpeed()
        local class = ply:GetTeamClass()
        local team = ply:Team()
        timer.Create(ply:SteamID() .. "adrrunspeedupdate", 3, 70, function()
            if ply:GetActiveWeapon() then
                if ply:GetActiveWeapon():GetClass() == "plutonic_ptrs" or ply:GetActiveWeapon():GetClass() == "plutonic_m60" or ply:GetActiveWeapon():GetClass() == "plutonic_apfgun" then
                    return
                end
            end
            if ply.HasBackpack == true then
                return
            end
            ply:SetRunSpeed(math.Clamp(speed + 15, 200, 220))
        end)
	    timer.Create(ply:SteamID() .. "adrstim", 240, 1, function()
            if ply:Team() == team and ply:GetTeamClass() == class then
                ply:SetRunSpeed(speed)  -- FIXED: restore original captured speed instead of 200
            end
            ply:Notify("The effects of the Caffeinated Stimulant Pills have worn off.")
            ply.Drugs = math.Clamp(ply.Drugs - 1,0,5) 
        end)
        timer.Create(ply:SteamID() .. "adrstimcd", 480, 1, function() 
            ply:Notify("You may now take stimulant pills again.")
        end)
        ply:SetRunSpeed(math.Clamp(speed + 15, 200, 220))
	    return true
    else
        ply:Notify("You cannot apply this, you would overdose.")
        return false
    end
end

impulse.RegisterItem(ITEM)