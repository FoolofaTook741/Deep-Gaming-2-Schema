local ITEM = {}

ITEM.UniqueID = "disguise_generic"
ITEM.Name = "Citizen Disguise"
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

local excludedBodygroups = {
    torso = {
        8, 9, 10, 11, 12, 13, 38, 39, -- rebel torso
        4, 5, 28, 29, 30, 31, 32, 33, 34, 35, 43, 44 -- Non citizen shirts
    },
    legs = {
        6, 7, 8, -- rebel legs
        9, 10, 11, 12, 13, 14 -- Non citizen pants
    }
}

local function toSet(tbl)
    local set = {}
    for _, v in ipairs(tbl) do
        set[v] = true
    end
    return set
end

local excludedTorso = toSet(excludedBodygroups.torso)
local excludedLegs = toSet(excludedBodygroups.legs)

local function getRandomBodygroup(max, excluded)
    local bg
    repeat
        bg = math.random(0, max)
    until not excluded[bg]
    return bg
end

function ITEM:OnEquip(ply)
    ply.LastBodygroup3 = ply:GetBodygroup(2)
    ply.LastBodygroup4 = ply:GetBodygroup(3)

    local torsobg = getRandomBodygroup(44, excludedTorso)
    local legsbg = getRandomBodygroup(14, excludedLegs)

    ply:SetBodygroup(1, 0)
    ply:SetBodygroup(2, torsobg)
    ply:SetBodygroup(3, legsbg)
end

function ITEM:UnEquip(ply)
    ply:SetBodygroup(1,10)
	ply:SetBodygroup(2, ply.LastBodygroup3)
    ply:SetBodygroup(3, ply.LastBodygroup4)
end

impulse.RegisterItem(ITEM)
