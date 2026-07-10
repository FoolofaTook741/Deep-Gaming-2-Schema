local ITEM = {}

ITEM.UniqueID = "portablecam"
ITEM.Name = "Portable Camera"
ITEM.Category = "Tools"
ITEM.Desc =  "A camera used to spy on things."
ITEM.Model = Model("models/bo/weapons/camera spike.mdl")
ITEM.FOV = 18
ITEM.Weight = 2

ITEM.Colour = Color(255, 0, 0)

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.WorldInteractor = true
ITEM.Placeable = false
ITEM.UseByDrag = true
ITEM.PlayersOnly = true

ITEM.UseTime = 5
ITEM.FreezeOwnerOnUse = true


if not impulse.PCams then
    impulse.PCams = {}
end

function ITEM:OnUse(ply)
    local trace = {}
    trace.start = ply:EyePos()
    trace.endpos = trace.start + ply:GetAimVector() * 85
    trace.filter = ply

    local tr = util.TraceLine(trace)

    --[[
    if ply:GetZoneName() == impulse.Config.RebelZone then
        ply:Notify("You cannot place a camera in the Rebel Zone!", 1)
        return false
    end
    ]]--
    
    local cam = ents.Create("pinnacle_portable_cam")
    if cam.CPPISetOwner then
        cam:CPPISetOwner(ply)
    end
    cam:SetModel(self.Model)
    local spawnPos = tr.HitPos + Vector(0,0,15)
    cam:SetPos(spawnPos)
    cam:SetAngles(ply:GetAngles())
    cam:Spawn()

    local phys = cam:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableGravity(true)
        phys:Wake()
    end

    local sid = ply:SteamID()
    impulse.PCams[sid] = impulse.PCams[sid] or {}
    table.insert(impulse.PCams[sid], cam)

    return true
end

impulse.RegisterItem(ITEM)
