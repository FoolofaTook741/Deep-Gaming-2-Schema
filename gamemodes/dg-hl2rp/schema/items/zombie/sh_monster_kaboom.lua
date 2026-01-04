local ITEM = {}

ITEM.UniqueID = "monster_kamikaze"
ITEM.Name = "Ability: Kamikaze"
ITEM.Desc =  "Blow yourself up to win the war! (You need to have less than 75 HP to activate. It is near instant.)"
ITEM.Category = "Monsters"
ITEM.Model = Model("models/Items/grenadeAmmo.mdl")
ITEM.FOV = 7.8252148997135
ITEM.CamPos = Vector(100, 91.690544128418, 100)
ITEM.Colour = Color(75, 0, 0)
ITEM.NoCenter = true
ITEM.Weight = 30

ITEM.Droppable = false
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "KABOOM"
ITEM.UseWorkBarTime = 0.5
ITEM.UseWorkBarName = "Exploding..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = ""
 
function ITEM:OnUse(ply)
	if ply:Health() < 75 then
        ply:EmitSound("npc/zombine/zombine_readygrenade1.wav")
        timer.Simple(2, function() 
            util.BlastDamage(ply, ply, ply:GetPos(), 240, 120)
            ply:EmitSound("ambient/explosions/explode_1.wav")
            ply:Kill()
        end)
        return true
    else
        ply:Notify("You must have less than 75 HP to use this.")
    end
end

impulse.RegisterItem(ITEM)
