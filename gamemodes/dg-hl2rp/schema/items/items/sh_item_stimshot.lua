local ITEM = {}

ITEM.UniqueID = "item_stimshot"
ITEM.Name = "Bio-Gel Stimshot"
ITEM.Desc =  "Injected to help recover wounds quickly."
ITEM.Category = "Medical"
ITEM.Model = Model("models/syringe.mdl")
ITEM.ItemColour = Color(255, 225, 225)
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
ITEM.UseWorkBarTime = 1
ITEM.UseWorkBarName = "Applying..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "items/smallmedkit1.wav"

function ITEM:OnUse(ply, target)
	local sid = target:SteamID64()
	if timer.Exists(sid .. "stimshot") then
		timer.Remove(sid .. "stimshot")
	end
	ply:Notify("You have injected " .. target:Name() .. " with bio-gel.")
	target:Notify(ply:Name() .. " has injected you with bio-gel.")
	timer.Create(sid .. "stimshot", 5, 10, function()
		if target:Health() + 5 >= 100 then
			timer.Remove(sid .. "stimshot")
		else
			target:SetHealth(target:Health() + (5 * (1 - (ply.Antiheal or 0))))
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
