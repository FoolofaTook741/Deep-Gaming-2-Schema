local ITEM = {}

ITEM.UniqueID = "item_barrel"
ITEM.Name = "I.C.T. - Anti-Virome Acids"
ITEM.Desc = "I.C.T. barrels have various acids used to clean up biohazards across the sector. It will only work on heavy spores or barnacle spawners at phase 2 or lower."
ITEM.Category = "ICT"
ITEM.Model = Model("models/hlvr/combine_hazardprops/combinehazardprops_barrel_lock.mdl")
ITEM.FOV = 60.929799426934
ITEM.CamPos = Vector(33.237823486328, 25, 9)
ITEM.Weight = 3

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Clean Infestation"
ITEM.UseWorkBarTime = 5
ITEM.UseWorkBarName = "Cleaning..."
ITEM.UseWorkBarSound = "physics/metal/paintcan_impact_hard3.wav"

function ITEM:OnUse(ply, target)
    if not IsValid(target) then
        ply:Notify("No valid target to clean.")
        return false
    end

    local targetClass = target:GetClass()
    local id = target:GetCreationID()
    local phase = target.phase or 1

    if not timer.Exists(id .. "sporecooldown") then
        if targetClass == "deep_spore" then
            if phase >= 3 then
                ply:Notify("You have used the wrong equipment on the spore, causing it to react negatively!")
                local headcrab = ents.Create("npc_headcrab")
                headcrab:SetPos(target:GetPos() + Vector(0, 0, 50))
                if phase < 5 then
                    target.phase = math.Clamp(phase + 1, 0, 5)
                end
                timer.Create(id .. "sporespawn", 3, 3, function()
                    if IsValid(headcrab) then
                        headcrab:Spawn()
                    end
                end)
            else
                ply:Notify("You have sprayed the spore with chemicals to limit its growth.")
                target.phase = math.Clamp(phase - 1, 0, 5)
                timer.Remove(id .. "sporephasechanges")
                timer.Remove(id .. "sporephasethink")
                timer.Create(id .. "sporecooldown", 90, 1, function()
                    timer.Remove(id .. "sporecooldown")
                end)
            end
        elseif targetClass == "deep_barnaclespawner" then
            if phase >= 3 then
                ply:Notify("You have used the wrong equipment on the barnacle spawner, causing it to react negatively!")
                local barnacle = ents.Create("npc_barnacle")
                barnacle:SetPos(target:GetPos() + Vector(0, 0, 100))
                if phase < 5 then
                    target.phase = math.Clamp(phase + 1, 0, 5)
                end
                timer.Create(id .. "barnaclespawn_penalty", 3, 1, function()
                    if IsValid(barnacle) then
                        barnacle:Spawn()
                        barnacle:Activate()
                    end
                end)
            else
                ply:Notify("You have sprayed the barnacle spawner with chemicals to limit its growth.")
                target.phase = math.Clamp(phase - 1, 0, 5)
                timer.Remove(id .. "sporephasechanges")
                timer.Remove(id .. "barnaclespawn")
                timer.Create(id .. "sporecooldown", 90, 1, function()
                    timer.Remove(id .. "sporecooldown")
                end)
            end
        end
    else
        ply:Notify("The " .. (targetClass == "deep_spore" and "spore" or "barnacle spawner") .. " has recently been cleaned. It will be safe to clean again in " .. math.floor(timer.TimeLeft(id .. "sporecooldown")) .. " seconds.")
    end
    return false
end

function ITEM:ShouldTraceUse(ply, ent)
    return ent:GetClass() == "deep_spore" or ent:GetClass() == "deep_barnaclespawner"
end

impulse.RegisterItem(ITEM)