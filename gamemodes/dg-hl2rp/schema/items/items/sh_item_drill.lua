local ITEM = {}

ITEM.UniqueID = "item_drill"
ITEM.Name = "Drill"
ITEM.Desc =  "A heavy-duty mechanical drill. Good at cracking safes and heavy locks."
ITEM.Category = "Tools"
ITEM.Model = Model("models/pd2_drill/drill.mdl")
ITEM.FOV = 13.372492836676
ITEM.CamPos = Vector(-68.767906188965, -67.851005554199, 9)
ITEM.NoCenter = true
ITEM.Weight = 7

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 120

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.UseName = "Use"
ITEM.UseWorkBarTime = 7
ITEM.UseWorkBarName = "Setting up drill..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "npc/sniper/reload1.wav"

function ITEM:OnUse(ply, ent)
	local pc = GetPlayerCount()
	local cc = GetCombineCount()
	if GetPlayerCount() < 24 and !ply:IsSuperAdmin() then
		ply:Notify("There are not enough players online.")
		return false
	elseif GetCombineCount() >= 8 then
		if ply:IsCP() and !ply:IsSuperAdmin() then
			return true
		end

		ply:AchievementGive("ach_drill")

		if ent.Drilling then
			ply:Notify("This ammo box is already being drilled...")
			return
		end

		if ent.LastRaided and ent.LastRaided > CurTime() then
			ply:Notify("This ammo box has already been raided recently...")
			return
		end

		local jam = false

		if ply:IsNearSignalJammer() then
			jam = true
		end

		ent:StartDrill(jam, ply)
		ply:Notify("You have started drilling the ammo box.")
		if jam == true then
			timer.Simple(60, function()
				net.Start("DeepSociostabilityScore")
        		net.WriteUInt(100, 8)
        		net.Broadcast()
			end)
		else
			net.Start("DeepSociostabilityScore")
        	net.WriteUInt(100, 8)
        	net.Broadcast()
		end
		return true
	elseif ply:IsSuperAdmin() then
		ply:AchievementGive("ach_drill")
		if ent.Drilling then
			ply:Notify("This ammo box is already being drilled...")
			return
		end

		if ent.LastRaided and ent.LastRaided > CurTime() then
			ply:Notify("This ammo box has already been raided recently...")
			return
		end

		ent:StartDrill(jam, ply)
		ply:Notify("You have started drilling the ammo box.")
		if jam == true then
			timer.Simple(60, function()
				net.Start("DeepSociostabilityScore")
        		net.WriteUInt(100, 8)
        		net.Broadcast()
			end)
		else
			net.Start("DeepSociostabilityScore")
        	net.WriteUInt(100, 8)
        	net.Broadcast()
		end
		return true
	else
		ply:Notify("There must be at least 8 Combine personnel active.")
	end
end

function ITEM:ShouldTraceUse(ply, ent)
	return (ent:GetClass() == "impulse_hl2rp_ammobox" or ent:GetClass() == "impulse_hardpointbox") and ent.GetDrillEndTime and ent:GetDrillEndTime() and ent:GetDrillEndTime() == 0
end

impulse.RegisterItem(ITEM)
