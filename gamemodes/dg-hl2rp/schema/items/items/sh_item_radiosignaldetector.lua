local ITEM = {}

ITEM.UniqueID = "cos_radiodetector"
ITEM.Name = "Radio Signal Detector"
ITEM.Desc =  "A small handheld device."
ITEM.Category = "Tools"
ITEM.Model = Model("models/props_lab/keypad.mdl")
ITEM.FOV = 50
ITEM.NoCenter = true
ITEM.Weight = 3.5

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 10

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "tool"
ITEM.CanStack = true

function ITEM:CanEquip(ply)
	return ply:IsCP() 
end

function ITEM:OnEquip(ply)
	ply:EmitSound("scramble/ui_motiontracker_pong2.wav")
	ply.RadioDetector = true
end

function ITEM:UnEquip(ply)
	ply.RadioDetector = false
end


impulse.RegisterItem(ITEM)
