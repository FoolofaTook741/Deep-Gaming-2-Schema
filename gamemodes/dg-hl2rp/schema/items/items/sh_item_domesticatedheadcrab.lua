local ITEM = {}

ITEM.UniqueID = "item_domesticatedheadcrab"
ITEM.Name = "Specimen Crate [Domesticated Headcrab]"
ITEM.Desc =  "A specimen crate with a live domesticated Headcrab inside. Turn it over to the supplier for reward so it can be studied or use it for research."
ITEM.Category = "ICT"
ITEM.Model = Model("models/hlvr/combine_hazardprops/combinehazardprops_crate.mdl")
ITEM.FOV = 80.929799426934
ITEM.CamPos = Vector(-5, -50, -5)
ITEM.Weight = 2.0

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Release"
ITEM.UseWorkBarTime = 5
ITEM.UseWorkBarName = "Releasing..."
ITEM.UseWorkBarSound = "physics/cardboard/cardboard_box_impact_bullet3.wav"

function ITEM:OnUse(ply, target)
    local pos = ply:GetPos()
    ply:Notify("The cage is open, he will wake up in 5 seconds! Clear the area!")
    local hc = ents.Create("npc_headcrab")
    hc:SetModel("models/headcrabclassic.mdl")
    hc:SetPos(pos)
    timer.Simple(5, function() 
        hc:Spawn() 
    end)
    for k, v in pairs(player.GetAll()) do 
        hc:AddEntityRelationship(v, D_LI, 99) -- be nice by default :)
    end
    ply:GiveInventoryItem("item_emptyspecimencrate")
    return true
end

impulse.RegisterItem(ITEM)
