local ITEM = {}

ITEM.UniqueID = "item_morphine"
ITEM.Name = "Morphine Stim-Shot"
ITEM.Desc =  "Gives people a slight pain resistance for a brief period."
ITEM.Category = "Medical"
ITEM.Model = Model("models/syringe.mdl")
ITEM.ItemColour = Color(225, 255, 225)
ITEM.FOV = 5
ITEM.CamPos = Vector(100, 100, 0)
ITEM.NoCenter = true
ITEM.Weight = 0.5

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Apply"
ITEM.UseWorkBarTime = 2
ITEM.UseWorkBarName = "Applying..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "items/smallmedkit1.wav"

function ITEM:OnUse(ply, target)
	local sid = ply:SteamID64()
	target:SetHealth(math.Clamp(target:Health() + 50, 1, target:GetMaxHealth() + 50))
	if timer.Exists(sid .. "morphine") then
		timer.Remove(sid .. "morphine")
	end
	ply:Notify("You have injected " .. target:Name() .. " with Morphine.")
	target:Notify(ply:Name() .. " has injected you with Morphine.")
	timer.Create(sid .. "morphine", 15, 10, function()
		if target:Health() - 5 <= 10 or not target:Alive() then
			timer.Remove(sid .. "morphine")
		else
			target:SetHealth(target:Health() - 5)
			if target:Health() < 1 and target:Alive() then
				target:Kill()
				timer.Remove(sid .. "morphine")
			end
		end
	end)

	return true
end

function ITEM:ShouldTraceUse(ply, ent)
	if ent:IsPlayer() then
		return true
	end
end

impulse.RegisterItem(ITEM)
