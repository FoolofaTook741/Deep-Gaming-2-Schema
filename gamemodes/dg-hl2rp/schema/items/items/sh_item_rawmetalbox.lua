local ITEM = {}

ITEM.UniqueID = "item_rawmetalbox"
ITEM.Name = "Shipment of Raw Metal"
ITEM.Desc =  "Contains raw metal to be used at refineries."
ITEM.Category = "Tools"
ITEM.Model = Model("models/Items/item_item_crate.mdl")
ITEM.FOV = 32.568767908309
ITEM.CamPos = Vector(-17.191976547241, 16.618911743164, 100)
ITEM.Weight = 4.0

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.ConfiscateReward = 0

ITEM.UseName = "Open"
ITEM.UseWorkBarTime = 12
ITEM.UseWorkBarName = "Opening..."
ITEM.UseWorkBarFreeze = false
ITEM.UseWorkBarSound = "physics/cardboard/cardboard_box_break2.wav"

function ITEM:OnUse(ply)
	local amount = 8
	local count = 0
	while count < amount do
		ply:GiveInventoryItem("item_rawmetal", 1)
		count = count + 1
	end
	ply:Notify("You have received " .. amount .. " chunks of raw metal.")
	return true
end

impulse.RegisterItem(ITEM)
