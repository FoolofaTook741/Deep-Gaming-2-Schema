local ITEM = {}

ITEM.UniqueID = "item_emptyspecimencrate"
ITEM.Name = "Empty Specimen Crate"
ITEM.Desc =  "Specimen crates are used to capture live headcrabs and grubs to be turned over for research."
ITEM.Category = "ICT"
ITEM.Model = Model("models/hlvr/combine_hazardprops/combinehazardprops_crate.mdl")
ITEM.FOV = 80.929799426934
ITEM.CamPos = Vector(-5, -50, -5)
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Capture"
ITEM.UseWorkBarTime = 0.25
ITEM.UseWorkBarName = "Capturing..."
ITEM.UseWorkBarSound = "physics/cardboard/cardboard_box_impact_bullet3.wav"

function ITEM:OnUse(ply, target)
    if target:GetClass() == "npc_headcrab" then
        ply:AchievementGive("ach_headcrab")
        ply:Notify("You have bagged the contaminant.")
        target:Remove()
        ply:GiveInventoryItem("item_headcrabcrate")
        return true
    elseif target:GetClass() == "npc_headcrab_fast" then
        ply:AchievementGive("ach_headcrab")
        ply:Notify("You have bagged the contaminant.")
        target:Remove()
        ply:GiveInventoryItem("item_fastheadcrabcrate")
        return true
    elseif target:GetClass() == "npc_barnacle" then
        ply:Notify("You have bagged the contaminant.")
        target:Remove()
        ply:GiveInventoryItem("item_barnaclecrate")
        return true
    elseif target:GetClass() == "npc_headcrab_black" then
        ply:AchievementGive("ach_headcrab")
        ply:Notify("You have bagged the contaminant.")
        target:Remove()
        ply:GiveInventoryItem("item_poisioneadcrabcrate")
        return true
    else
        ply:Notify("You have bagged the contaminant.")
        target:Remove()
        ply:GiveInventoryItem("item_grubcrate")
        return false
    end
end

function ITEM:ShouldTraceUse(ply, ent)
	return ent:GetClass() == "npc_headcrab" or ent:GetClass() == "npc_barnacle" or ent:GetClass() == "npc_headcrab_black" or ent:GetClass() == "npc_headcrab_fast" or ent:GetClass() == "npc_antlion_larva"  
end

impulse.RegisterItem(ITEM)
