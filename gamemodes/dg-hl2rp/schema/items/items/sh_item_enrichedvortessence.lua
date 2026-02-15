local ITEM = {}

ITEM.UniqueID = "item_enrichedvortessence"
ITEM.Name = "Enriched Vortessence"
ITEM.Desc = "A special version of vortessence that allows for vortigaunts to harness their complete power."
ITEM.Category = "Vort"
ITEM.Model = Model("models/spitball_medium.mdl")
ITEM.ItemColour = Color(0, 225, 0)
ITEM.FOV = 15.338108882521
ITEM.CamPos = Vector(-10, 25, 9)
ITEM.Weight = 0.1

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.UseName = "Use"

function ITEM:CanUse(ply)
    if not ply:IsDonator() then
        ply:Notify("Only donators can use this item.")
        return false
    end
    if ply:Team() == TEAM_VORT then
        return true
    end
    return false
end	

function ITEM:OnUse(ply, door)
    if not ply:IsDonator() then
        ply:Notify("Only donators can use this item.")
        return false
    end

    if ply:Team() ~= TEAM_VORT then
        ply:Notify("You cannot use this unless you are an unshackled vortigaunt.")
        return false
    end
    if ply:GetModel() == "models/willardnetworks/vortigaunt.mdl" and ply:GetBodygroup(7) == 1 then
        ply:Notify("Your shackles prevent you from being able to harness the powers of the Vortessence.")
        return false
    end

    if ply.UsedEnrichedVortessence then
        ply:Notify("You have already used the enriched vortessence.")
        return false
    end

    ply.UsedEnrichedVortessence = true
    ply.UsedVortessence = false
    local color = Color(0, 255, 0, 255)
    ply:Give("weapon_bugbait") 
    ply:SetColor(color)
    ply:SetSkin(1)
	
    local vortSkillData = ply:vortSkillCalculate()
    local enduringMultiplier = vortSkillData.enduring_essence or 1
    local vortessenceTime = impulse.Config.VortessenceTime * enduringMultiplier

    net.Start("impulseHL2RPVortessenceStart")
    net.WriteFloat(vortessenceTime) 
    net.Send(ply)

    timer.Create(ply:SteamID() .. "enrichedvortessence", vortessenceTime, 1, function()
        if not IsValid(ply) then
            return
        end

        ply.UsedEnrichedVortessence = false
        local clearcolor = Color(255, 255, 255, 255)
        ply:SetColor(clearcolor)

        if ply:Team() ~= TEAM_VORT then
            return
        end

        ply:SetSkin(0)
        ply:Notify("The effects of the enriched vortessence have worn off...")
    end)

    return true
end

impulse.RegisterItem(ITEM)