local ITEM = {}

ITEM.UniqueID = "item_ictbox"
ITEM.Name = "I.C.T. - Spore Containment Toolbox"
ITEM.Desc =  "I.C.T. toolboxes have various items used to clean up biohazards across the sector. It will only work on heavy spores greater than or equal to phase 3."
ITEM.Category = "ICT"
ITEM.Model = Model("models/hlvr/combine_hazardprops/combinehazardprops_container.mdl")
ITEM.FOV = 50.929799426934
ITEM.CamPos = Vector(40.237823486328, 40, 40)
ITEM.Weight = 2

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Clean Infestation"
ITEM.UseWorkBarTime = 8
ITEM.UseWorkBarName = "Cleaning..."
ITEM.UseWorkBarSound = "physics/metal/paintcan_impact_hard3.wav"

function ITEM:OnUse(ply, target)
    local id = target:GetCreationID()
    local phase = target.phase
    if !timer.Exists(id .. "sporecooldown") then
        if phase < 3 then   
            ply:Notify("You have used the wrong equipment on the spore causing it to react negatviely!")
            local antlion = ents.Create("npc_headcrab_fast")
            antlion:SetPos(target:GetPos() + Vector(0, 0, 50)) 
            if phase < 5 then
                target.phase = math.Clamp(phase + 1, 0, 5)
            end
            timer.Create(id .. "sporespawn", 3, 3, function()
                antlion:Spawn()
            end)
        else
            ply:Notify("You have sprayed the contaminated spore with various chemicals to limit its growth.")
            target.phase = math.Clamp(phase - 1, 0, 5)
            timer.Remove(id .. "sporephasechanges")
            timer.Remove(id .. "sporephasethink")
            timer.Create(id .. "sporecooldown", 90, 0, function() 
                timer.Remove(id .. "sporecooldown")
            end)
        end
    else
        ply:Notify("The spore has recently been cleaned, you cannot clean it now or it may burst. It will be safe to clean again in " .. math.floor(timer.TimeLeft(id .. "sporecooldown")) .. " seconds.")
    end
    return false
end

function ITEM:ShouldTraceUse(ply, ent)
	return ent:GetClass() == "deep_spore" or ent:GetClass()=="deep_barnaclespawner"
end

impulse.RegisterItem(ITEM)
