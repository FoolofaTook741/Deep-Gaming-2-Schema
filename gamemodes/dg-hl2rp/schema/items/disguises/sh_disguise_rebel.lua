local ITEM = {}

ITEM.UniqueID = "disguise_rebel"
ITEM.Name = "Rebel Disguise"
ITEM.Desc =  "Changes your clothing to something different."
ITEM.Category = "Deprecated"
ITEM.Model = Model("models/props_c17/SuitCase001a.mdl")
ITEM.FOV = 80.213467048711
ITEM.CamPos = Vector(46.418338775635, 20.630373001099, 32.091690063477)
ITEM.NoCenter = true
ITEM.Weight = 0.2

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true   

ITEM.UseName = "Equip"
ITEM.UseWorkBarTime = 3
ITEM.UseWorkBarName = "Wearing..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "cloth"

function ITEM:CanEquip(ply)
	return ply:Team() == TEAM_CA
end

local rebelbodygroupstorso = {[8] = true, [9] = true, [10] = true, [11] = true, [12] = true, [13] = true, [38] = true, [39] = true}
local rebelbglegs = {[6] = true, [7] = true, [8] = true}

function ITEM:OnEquip(ply)
    ply.LastBodygroup3 = ply:GetBodygroup(2)
    ply.LastBodygroup4 = ply:GetBodygroup(3)
    local torsobg = math.random(8,39)
    local legsbg = math.random(6,8)
    while rebelbodygroupstorso[torsobg] != true do
        torsobg = math.random(8,39)
    end
    ply:SetBodygroup(1,0)
    ply:SetBodygroup(2, torsobg)
    ply:SetBodygroup(3, legsbg)
end

function ITEM:UnEquip(ply)
    ply:SetBodygroup(1,10)
	ply:SetBodygroup(2, ply.LastBodygroup3)
    ply:SetBodygroup(3, ply.LastBodygroup4)
end

impulse.RegisterItem(ITEM)
