local ITEM = {}

ITEM.UniqueID = "clo_backpack"
ITEM.Name = "Backpack"
ITEM.Desc =  "Useful for carrying more items. This item allows you to carry an additional 10 lbs of weight."
ITEM.Category = "Clothing Accessories"
ITEM.Model = Model("models/willardnetworks/clothingitems/backpack.mdl")
ITEM.FOV = 12.213467048711
ITEM.CamPos = Vector(46.418338775635, 20.630373001099, 32.091690063477)
ITEM.NoCenter = true
ITEM.Weight = 2.0

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "back"
ITEM.CanStack = true   

function ITEM:CanEquip(ply)
	return ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU or ply:Team() == TEAM_CP
end

function ITEM:OnEquip(ply)
    ply:SetBodygroup(6, 1)
    ply.HasBackpack = true
    ply:SetNWBool("HasBackpack", true)
	local timerName = ply:SteamID() .. "BackpackSpeedSet"
    timer.Create(timerName, 3, 0, function()
        if IsValid(ply) then
            if ply.HasBackpack == false then
                timer.Remove(timerName)
                ply:SetRunSpeed(impulse.Config.JogSpeed)
            elseif ply:Alive() then
                ply:SetRunSpeed(170)
            end
        else
            timer.Remove(timerName)
        end
    end)
    ply:Notify("You are now incumbered, you move at a slower rate.")
end

function ITEM:UnEquip(ply)
	ply:SetBodygroup(6, 0)
    ply.HasBackpack = false
    ply:SetNWBool("HasBackpack", false)
	local timerName = ply:SteamID() .. "BackpackSpeedSet"
    timer.Remove(timerName)
    ply:SetRunSpeed(impulse.Config.JogSpeed)
end

impulse.RegisterItem(ITEM)
