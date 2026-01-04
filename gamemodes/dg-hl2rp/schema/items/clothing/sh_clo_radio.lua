local ITEM = {}

ITEM.UniqueID = "item_radio"
ITEM.Name = "Radio Transmitter"
ITEM.Desc =  "A small device that allows you to connect to rebel frequencies. To change frequencies use /frequency (1-10)"
ITEM.Category = "Tools"
ITEM.Model = Model("models/bo/weapons/radio.mdl")
ITEM.FOV = 12.213467048711
ITEM.CamPos = Vector(46.418338775635, 20.630373001099, 32.091690063477)
ITEM.NoCenter = true
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "radio"
ITEM.CanStack = true   

function ITEM:CanEquip(ply)
	return ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU or ply:Team() == TEAM_VORT
end

function ITEM:OnEquip(ply)
    ply.Frequency = 1
    ply.HasRadio = true
end

function ITEM:UnEquip(ply)
	ply.HasRadio = false
end

impulse.RegisterItem(ITEM)
