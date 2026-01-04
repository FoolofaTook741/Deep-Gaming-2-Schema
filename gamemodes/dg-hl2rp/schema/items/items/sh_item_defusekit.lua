local ITEM = {}

ITEM.UniqueID = "item_defusekit"
ITEM.Name = "I.E.D. Defuse Kit"
ITEM.Desc =  "Used to defuse armed Improvised Explosive Devices."
ITEM.Category = "Combine Tools"
ITEM.Model = Model("models/props_junk/cardboard_box003a.mdl")
ITEM.FOV = 10.308022922636
ITEM.CamPos = Vector(-0.57306587696075, -91.117477416992, 98.567337036133)
ITEM.NoCenter = true
ITEM.Weight = 1.5

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = false

ITEM.UseName = "Defuse"
ITEM.UseWorkBarTime = 3
ITEM.UseWorkBarName = "Defusing..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "physics/metal/metal_box_strain3.wav"

function ITEM:OnUse(ply, target)
    if IsValid(target) and target:GetClass() == "impulse_usable" and target:GetModel() == "models/weapons/w_c4_planted.mdl" then
        target:Remove()
        ply:Notify("I.E.D. defused.")
        return true
    else
        ply:Notify("This can only be used to defuse an I.E.D.")
        return false
    end
end

function ITEM:ShouldTraceUse(ply, ent)
    if IsValid(ent) and ent:GetClass() == "impulse_usable" and ent:GetModel() == "models/weapons/w_c4_planted.mdl" then
        return true
    end
    return false
end

impulse.RegisterItem(ITEM)
