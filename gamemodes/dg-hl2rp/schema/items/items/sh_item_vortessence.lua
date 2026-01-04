local ITEM = {}

ITEM.UniqueID = "item_vortessence"
ITEM.Name = "Vortessence"
ITEM.Desc = "A small nugget containing vortessence, said to induce supernatural powers to those that wield it."
ITEM.Category = "Tools"
ITEM.Model = Model("models/spitball_medium.mdl")
ITEM.ItemColour = Color(144, 0, 255)
ITEM.FOV = 15.338108882521
ITEM.CamPos = Vector(-10, 25, 9)
ITEM.Weight = 0.1
ITEM.ConfiscateReward = 5

ITEM.Droppable = true
ITEM.DropOnDeath = false

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
        ply:Notify("You are not sure how to use this...")
        return false
    end

    if ply:GetModel() == "models/willardnetworks/vortigaunt.mdl" and ply:GetBodygroup(7) == 1 then
        ply:Notify("Your shackles prevent you from being able to harness the powers of the Vortessence.")
        return false
    end

    if ply.UsedVortessence then
        ply:Notify("You have already used the vortessence.")
        return false
    end

    ply.UsedEnrichedVortessence = false
    ply.UsedVortessence = true
    ply:SetSkin(1)
	
    local vortSkillData = ply:vortSkillCalculate()
    local enduringMultiplier = vortSkillData.enduring_essence or 1
    local vortessenceTime = impulse.Config.VortessenceTime * enduringMultiplier

    net.Start("impulseHL2RPVortessenceStart")
    net.WriteFloat(vortessenceTime) 
    net.Send(ply)

    timer.Create(ply:SteamID() .. "vortessence", vortessenceTime, 1, function()
        if not IsValid(ply) then return end

        ply.UsedVortessence = false

        if ply:Team() ~= TEAM_VORT then return end

        if ply:GetModel() ~= "models/vortiblue1.mdl" then return end

        ply:SetModel("models/vortigaunt.mdl")
        ply:Notify("The effects of the vortessence have worn off...")
    end)

    return true
end

impulse.RegisterItem(ITEM)