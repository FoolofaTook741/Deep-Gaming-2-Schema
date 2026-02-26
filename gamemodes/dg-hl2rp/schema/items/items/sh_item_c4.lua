local ITEM = {}

ITEM.UniqueID = "item_c4"
ITEM.Name = "C4 Charge"
ITEM.Desc =  "A large explosive used for various demolitions."
ITEM.Category = "Tools"
ITEM.Model = Model("models/bo/weapons/c-4 explosive.mdl")
ITEM.FOV = 13.372492836676
ITEM.CamPos = Vector(-68.767906188965, -67.851005554199, 9)
ITEM.NoCenter = true
ITEM.Weight = 4

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 120

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.UseName = "Use"
ITEM.UseWorkBarTime = 4
ITEM.UseWorkBarName = "Planting C4..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "weapons/c4/c4_disarm.wav"

function ITEM:OnUse(ply, ent)
	local pc = GetPlayerCount()
	local cc = GetCombineCount()
	if GetPlayerCount() < 30 and GetOTACount() < 5 and ply:IsSuperAdmin() == false then
		ply:Notify("There are not enough players online (30).")
		return false
	elseif GetOTACount() >= 5 then
		ply:AchievementGive("ach_cache")
		if timer.Exists(ent:GetCreationID() .. "DeepPWCBox") then
			ply:Notify("This cache already being blown open...")
			return
		end

		if timer.Exists("PWCCooldown") then
			ply:Notify("A cache has recently been raided. Please wait " .. math.floor(timer.TimeLeft("PWCCooldown")) .. " seconds.")
			return
		end

		local jam = false
		if ply:IsNearSignalJammer() then
			jam = true
		end

		ent:StartC4(jam)
		ply:Notify("You have started the C4 sequence.")
		return true
	elseif ply:IsSuperAdmin() then
		ply:AchievementGive("ach_cache")
		if timer.Exists(ent:GetCreationID() .. "DeepPWCBox") then
			ply:Notify("This cache already being blown open...")
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

		ent:StartC4(jam)
		ply:Notify("You have started the C4 sequence.")
		return true
	else
		ply:Notify("There must be at least 7 CTA personnel active.")
	end
end

function ITEM:ShouldTraceUse(ply, ent)
	return ent:GetClass() == "deep_prewarcache" and not timer.Exists(ent:GetCreationID() .. "DeepPWCBox")
end

impulse.RegisterItem(ITEM)
