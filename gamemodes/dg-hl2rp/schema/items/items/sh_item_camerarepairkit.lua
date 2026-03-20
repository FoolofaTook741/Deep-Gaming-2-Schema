local ITEM = {}

ITEM.UniqueID = "item_camerarepairkit"
ITEM.Name = "Repair Kit"
ITEM.Desc = "This kit contains replacement parts and tools to repair damaged electronics."
ITEM.Category = "Combine Tools"
ITEM.Model = Model("models/combine_turrets/floor_turret_gib1.mdl")
ITEM.FOV = 20.379656160458
ITEM.CamPos = Vector(-57.306591033936, -25.21489906311, 8.5959882736206)
ITEM.NoCenter = true
ITEM.Weight = 0.2

ITEM.Droppable = true
ITEM.DropOnDeath = false
ITEM.Illegal = false
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Repair Appliances"

local CAMERA_REPAIR_COOLDOWN = 120
local CAMERA_POSITION_TOLERANCE = 100

impulse.CameraRepairCooldowns = impulse.CameraRepairCooldowns or {}

local function repairForcefield(ply, pos, class)
    for _, ff in pairs(ents.FindByClass(class)) do
        if ff:GetPos():DistToSqr(pos) < (500 ^ 2) and ff.EMPd == true then
            local remaining = math.ceil((ff.EMPdTime + 120) - CurTime())
            if remaining > 0 then
                ply:Notify(string.format("The forcefield is still too damaged to repair. Try again in %d second(s).", remaining))
                return false
            end
            ply:EmitSound("ambient/energy/weld2.wav")
            ff.EMPd = false
            ff.EMPdTime = nil
            ff.Active = true
            ff.NextActivation = 0
            ply:Notify("You have repaired a damaged forcefield.")
            if ply:Team() == TEAM_CWU then
                ply:GiveMoney(150)
                ply:Notify("You have received 150 credits for repairing the forcefield.")
                ply:AddSkillXP("metabolism", math.random(10, 30))
            end
            return true
        end
    end
end

function ITEM:OnUse(ply)
    local pos = ply:GetPos()
    local now = CurTime()

    for _, cam in pairs(ents.FindByClass("npc_combine_camera")) do
        if cam:GetPos():DistToSqr(pos) < (500 ^ 2) then
            local camPos = cam:GetPos()

            for _, data in pairs(impulse.CameraRepairCooldowns) do
                if camPos:DistToSqr(data.pos) <= CAMERA_POSITION_TOLERANCE then
                    local elapsed = now - data.time

                    if elapsed < CAMERA_REPAIR_COOLDOWN then
                        local remaining = math.ceil(CAMERA_REPAIR_COOLDOWN - elapsed)
                        local minutes = math.floor(remaining / 60)
                        local seconds = remaining % 60

                        if minutes > 0 then
                            ply:Notify(string.format(
                                "This camera has massive faults. Wait %d minute(s) and %d second(s).",
                                minutes,
                                seconds
                            ))
                        else
                            ply:Notify(string.format(
                                "This camera has massive faults. Wait %d second(s).",
                                seconds
                            ))
                        end

                        return false
                    end
                end
            end

            if not cam:IsCameraEnabled() then
                table.insert(impulse.CameraRepairCooldowns, {
                    pos = camPos,
                    time = now
                })

                ply:EmitSound("ambient/energy/weld2.wav")
                ply:Notify("You have repaired a broken camera.")

                cam:RepairCombineCamera()

                if ply:Team() == TEAM_CWU then
                    ply:GiveMoney(200)
                    ply:Notify("You have received 200 credits for repairing this camera.")
                    ply:AddSkillXP("metabolism", math.random(5, 15))
                end

                return true
            end
        end
    end

    for _, uplink in pairs(ents.FindByClass("deep_commsuplink")) do
        if uplink:GetPos():DistToSqr(pos) < (500 ^ 2) and impulse.CommsNetWorkOn != true then
            impulse.CommsNetWorkOn = true

            if timer.Exists("emphackcooldown") then
                timer.Remove("emphackcooldown")
            end

            ply:EmitSound("ambient/energy/weld2.wav")
            ply:Notify("You have repaired the Combine Comms Uplink.")

            for _, v in pairs(player.GetAll()) do
                v:SendCombineMessage(
                    "COMBINE COMMS NETWORK REPAIRED BY " .. ply:Name(),
                    Color(0, 150, 0)
                )
            end

            if ply:Team() == TEAM_CWU then
                ply:GiveMoney(400)
                ply:Notify("You have received 400 credits for repairing the comms network.")
                ply:AddSkillXP("metabolism", math.random(20, 100))
            end

            return true
        end
    end

    for _, term in pairs(ents.FindByClass("impulse_hl2rp_terminal")) do
        if term:GetPos():DistToSqr(pos) < (500 ^ 2) and term.Emped == true then
            ply:EmitSound("ambient/energy/weld2.wav")

            term.Emped = false
            ply:Notify("You have repaired a broken terminal.")

            if ply:Team() == TEAM_CWU then
                ply:GiveMoney(200)
                ply:Notify("You have received 200 credits for repairing a terminal.")
                ply:AddSkillXP("metabolism", math.random(10, 30))
            end

            return true
        end
    end

    local ffResult = repairForcefield(ply, pos, "deep_forcefield")
    if ffResult ~= nil then return ffResult end

    local ffResult = repairForcefield(ply, pos, "deep_forcefield_small")
    if ffResult ~= nil then return ffResult end

    ply:Notify("No broken devices found nearby.")
    return false
end

impulse.RegisterItem(ITEM)