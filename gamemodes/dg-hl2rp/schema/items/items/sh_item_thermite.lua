local ITEM = {}

ITEM.UniqueID = "item_thermite"
ITEM.Name = "Thermite"
ITEM.Desc =  "A tube of thermite that's great for melting metal."
ITEM.Category = "Tools"
ITEM.Model = Model("models/bo/weapons/signal flare.mdl")
ITEM.FOV = 13.372492836676
ITEM.CamPos = Vector(-68.767906188965, -67.851005554199, 9)
ITEM.NoCenter = true
ITEM.Weight = 2.8

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 120

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.UseName = "Use"
ITEM.UseWorkBarTime = 5
ITEM.UseWorkBarName = "Placing and igniting thermite..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "physics/plastic/plastic_box_impact_bullet3.wav"

function ITEM:OnUse(ply, ent)
	local pc = GetPlayerCount()
	--local cc = GetCombineCount()
	if GetPlayerCount() < 30 and GetCPCount() < 8 and ply:IsSuperAdmin() == false then
		ply:Notify("There are not enough players online (30).")
		return false
	elseif GetCPCount() >= 8 then
		if timer.Exists(ent:GetCreationID() .. "DeepMPFCBox") then
			ply:Notify("This cache already being raided...")
			return
		end

		if timer.Exists("MPFCCooldown") then
			ply:Notify("A cache has recently been raided. Please wait " .. math.floor(timer.TimeLeft("MPFCCooldown")) .. " seconds.")
			return
		end

		local jam = false
		if ply:IsNearSignalJammer() then
			jam = true
		end

		ent:StartThermite(jam)
		ply:Notify("You have ignited the thermite.")
		return true
	elseif ply:IsSuperAdmin() then
		--ply:AchievementGive("ach_cache")
		if timer.Exists(ent:GetCreationID() .. "DeepMPFCBox") then
			ply:Notify("This cache already being raided...")
			return
		end

		if ent.LastRaided and ent.LastRaided > CurTime() then
			ply:Notify("This cache has already been raided recently...")
			return
		end

		local jam = false
		if ply:IsNearSignalJammer() then
			jam = true
		end

		ent:StartThermite(jam)
		ply:Notify("You have ignited the thermite.")
		return true
	else
		ply:Notify("There must be at least 10 MPF personnel active.")
	end
end

function ITEM:ShouldTraceUse(ply, ent)
	return ent:GetClass() == "deep_mpfcache" and not timer.Exists(ent:GetCreationID() .. "DeepPWCBox")
end

impulse.RegisterItem(ITEM)
