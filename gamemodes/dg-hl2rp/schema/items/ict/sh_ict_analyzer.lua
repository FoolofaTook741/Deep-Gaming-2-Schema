local ITEM = {}

ITEM.UniqueID = "item_sporeanalyzer"
ITEM.Name = "Spore Analyzer"
ITEM.Desc =  "Spore analyzers help I.C.T. members determine which gear to use on a spore."
ITEM.Category = "ICT"
ITEM.Model = Model("models/hlvr/combine_hazardprops/combinehazardprops_detector.mdl")
ITEM.FOV = 17.929799426934
ITEM.CamPos = Vector(33.237823486328, 25, 9)
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Analyze Spore"
ITEM.UseWorkBarTime = 1
ITEM.UseWorkBarName = "Analyzing..."
ITEM.UseWorkBarSound = "buttons/combine_button_locked.wav"

function ITEM:OnUse(ply, target)
    local phase = target.phase
    ply:Notify("The spore appears to be in Phase: " .. phase .. ".")
    local id = target:GetCreationID()
end

function ITEM:ShouldTraceUse(ply, ent)
	return ent:GetClass() == "deep_spore" or ent:GetClass() == "deep_barnaclespawner"
end

impulse.RegisterItem(ITEM)
