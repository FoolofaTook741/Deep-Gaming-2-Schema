local ITEM = {}

ITEM.UniqueID = "resin_box"
ITEM.Name = "Shipment of Resin"
ITEM.Desc =  "Contains resin to be used at fabricators."
ITEM.Category = "Tools"
ITEM.Model = Model("models/Items/item_item_crate.mdl")
ITEM.FOV = 32.568767908309
ITEM.CamPos = Vector(-17.191976547241, 16.618911743164, 100)
ITEM.Weight = 4.0

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.UseName = "Open"
ITEM.UseWorkBarTime = 12
ITEM.UseWorkBarName = "Opening..."
ITEM.UseWorkBarFreeze = false
ITEM.UseWorkBarSound = "physics/cardboard/cardboard_box_break2.wav"

function ITEM:OnUse(ply)
	local amount = math.random(10,30)
	local shib = 0
	while shib <= amount do
		ply:GiveInventoryItem("util_resin", 1)
		shib = shib + 1
	end
	ply:Notify("You have received " .. amount .. " containers of resin.")
	return true
end

impulse.RegisterItem(ITEM)
