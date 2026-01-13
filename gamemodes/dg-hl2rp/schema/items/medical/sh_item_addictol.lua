local ITEM = {}

ITEM.UniqueID = "item_addictol"
ITEM.Name = "Addictol"
ITEM.Desc =  "A small plastic capsule contaning medical pills. Able to remove the negative effects of drugs or cure insanity."
ITEM.Category = "Medical"
ITEM.Model = Model("models/warz/consumables/medicine.mdl")
ITEM.FOV = 5
ITEM.CamPos = Vector(42.406875610352, -5.7306590080261, 12.607449531555)
ITEM.NoCenter = true
ITEM.Weight = 0.2

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Consume"
ITEM.UseWorkBarTime = 8
ITEM.UseWorkBarName = "Consuming..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "items/smallmedkit1.wav"

function ITEM:CanUse(ply)
	if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU or ply:Team() == TEAM_CA then
		return true
	end
end

function ITEM:OnUse(ply)
	ply:StopInsane()
	ply.Drugs = 0
	if timer.Exists(ply:SteamID() .. "steroidstim") then
		timer.Remove(ply:SteamID() .. "steroidstim")
		ply.MeleeMult = 1
	end
	if timer.Exists(ply:SteamID() .. "morphinestim") then
		ply:SetMaxHealth(100)
        if ply:Health() >= 100 then
            ply:SetHealth(100)
        end
		timer.Remove(ply:SteamID() .. "morphinestim")
	end
	if timer.Exists(ply:SteamID() .. "drstim") then
		ply.DR = 0
		timer.Remove(ply:SteamID() .. "drstim")
	end
	if timer.Exists(ply:SteamID() .. "creatinestim") then
		ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
		timer.Remove(ply:SteamID() .. "creatinestim")
	end
	if timer.Exists(ply:SteamID() .. "adrstim") then
		ply:SetRunSpeed(impulse.Config.JogSpeed)
		timer.Exists(ply:SteamID() .. "adrstim")
	end
	if timer.Exists(ply:SteamID() .. "adderrallstim") then
		ply.RecoilMult = 1
		timer.Remove(ply:SteamID() .. "adderrallstim")
	end
	if timer.Exists(ply:SteamID() .. "regstim") then
		timer.Remove(ply:SteamID() .. "regstim")
	end
end
impulse.RegisterItem(ITEM)
