local ITEM = {}

ITEM.UniqueID = "item_splint"
ITEM.Name = "Splint"
ITEM.Desc =  "A long wooden rod. Can be used to heal broken bones."
ITEM.Category = "Medical"
ITEM.Model = Model("models/props_junk/wood_crate001a_chunk05.mdl")
ITEM.FOV = 17.303724928367
ITEM.CamPos = Vector(-9.1690540313721, 11.002865791321, -79.426933288574)
ITEM.Weight = 0.6

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Use"
ITEM.UseWorkBarTime = 1
ITEM.UseWorkBarName = "Applying splint..."
ITEM.UseWorkBarFreeze = true

function ITEM:OnUse(ply, target)
	local tr = {}
	tr.start = ply:EyePos()
	tr.endpos = tr.start + ply:GetAimVector() * 90
	tr.filter = ply
	targ = util.TraceLine( tr ).Entity

	-- using sync vars instead of HasBrokenLegs() on other players
	if targ then
		if targ:GetSyncVar( SYNC_BROKENLEGS, false ) then
			targ:SetSyncVar( SYNC_BROKENLEGS, false, true )
			targ:Notify(ply:Name() .. " has fixed your legs.")
			ply:Notify( targ:Name() .. "'s legs have been fixed.")
			return true
		end
	end
	if ply:HasBrokenLegs() then
		ply:Notify("Your broken legs have healed.")
		ply:FixLegs()

		return true
	end

	ply:Notify("Your legs are not broken.")
	return false
end
--[[ be careful with this !
function ITEM:ShouldTraceUse(ply, ent)
	return true
end
]]
impulse.RegisterItem(ITEM)
