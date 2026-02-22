AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/props_c17/Lockers001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self.Inventory = {}
	self.LastRaided = 0
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

local Raidables = { ["util_electronics"] = true,
	["util_particleaccelerator"] = true,
	["util_energycore"] = true,
	["util_ceramicplate"] = true,
	["util_heavyceramicplate"] = true, -- hi
	["util_ruinedotavest"] = true,
	["ammo_lmg"] = true,
	["ammo_rifle"] = true,
	["ammo_smg"] = true,
	["ammo_sniper"] = true,
	["ammo_ar2"] = true,
	["ammo_357"] = true,
	["wep_apf"] = true,
	["wep_357"] = true,
	["wep_scarh"] = true,
	["wep_famas"] = true,
	["wep_m249"] = true,
	["wep_ak47u"] = true,
	["wep_ak47ub"] = true, 
	["wep_m134"] = true,
	["util_electronics"] = true,
	["wep_crossbow"] = true,
	["wep_gluon"] = true,
	["wep_ar2"] = true,
	["wep_ar2e"] = true,
	["wep_goldengun"] = true,
	["wep_goldenak47"] = true,
	["wep_goldendeagle"] = true,
	["wep_m500"] = true,
	["wep_tt"] = true,
	["wep_pistol"] = true,
	["wep_mp7"] = true,
	["wep_ppsh41"] = true,
	["wep_ptrs41"] = true,
	["wep_pm63"] = true,
	["wep_omr"] = true,
	["wep_osips"] = true,
	["wep_osisg"] = true,
	["wep_panzerfaust"] = true,
	["wep_pewpew"] = true,
	["wep_shotgun"] = true,
	["wep_skeleton"] = true,
	["wep_sw500"] = true,
	["wep_tau"] = true,
	["wep_osiprmk1"] = true,
	["wep_osiprmk1c"] = true,
	["wep_g3a3"] = true,
	["wep_mg34"] = true,
	["wep_m60"] = true,
	["wep_m4a1"] = true,
	["wep_kar98k"] = true,
	["wep_db"] = true,
	["wep_axe"] = true,
	["wep_pickaxe"] = true,
	["wep_ak47"] = true,
	["cos_yellowfacewrap"] = true,
	["cos_combatgasmask"] = true,
	["cos_ducttapewrap"] = true,
	["cos_vortarmor"] = true,
	["cos_parahelmet"] = true,
	["cos_otavest"] = true,
	["cos_otavest2"] = true,
	["cos_facewrap"] = true,
	["cos_lightvest"] = true,
	["cos_elitevest"] = true,
	["att_slugrounds"] = true,
	["att_huntersight"] = true,
	["att_extendedmag"] = true,
	["att_greasedbelt"] = true,
	["att_dragonsbreath"] = true,
	["wep_molotov"] = true,
}

local EmptyPool = {"wep_pistol", "wep_mp7", "ammo_smg", "wep_shotgun", "util_electronics", "wep_molotov"}

function ENT:Use( activator, caller )
	local ply = activator
	if activator:IsCP() then
		if ply.ConfiscatedInv and #ply.ConfiscatedInv >= 1 then
			local excludedItems = {
				item_scraps = true,
				item_rawmetal = true,
				item_rawmetalbox = true,
				util_metalplate = true,
				util_refinedmetalplate = true,
				util_pipe = true
			}
			local totalItems = 0
			local rewardedItems = 0
			for k,v in pairs(ply.ConfiscatedInv) do
				totalItems = totalItems  + 1
				if not excludedItems[v] then
					rewardedItems = rewardedItems + 1
					OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS + 10
					if Raidables[v] == true then
						table.insert(self.Inventory, v)
					end
				end
			end
			ply.ConfiscatedInv = {}
			if rewardedItems > 0 then
				ply:AdjustSC(rewardedItems * 2, true)
			end
			ply:Notify("You turned in " .. totalItems .. " items. " ..rewardedItems .. " qualified for rewards, contributing " ..(rewardedItems * 10) .. " to the O.C.A.A.B. treasury and earning " ..(rewardedItems * 2) .. " sterilized credits.")
		else
			ply:Notify("You do not have any items to turn in at this time.")
			return
		end
    else
		activator:Notify("You cannot interact with this item.")
		return
	end
	local id = self:GetCreationID()
	if not timer.Exists(id.."clearinv") then
		timer.Create(id.."clearinv", 3600, 0, function()
			if IsValid(self) and self.WipeInventory then
				self:WipeInventory()
			end
		end)
	end
end

function ENT:WipeInventory()
	self.Inventory = {}
end

function ENT:RaidLocker(lockpicker)
	if CurTime() < self.LastRaided + 600 then
		lockpicker:Notify("The evidence locker has recently be raided.")
		return
	end
	local SpawnPos = self:GetPos() + Vector(0,0,25)
	local ply = lockpicker
	local id = self:GetCreationID()
	if GetCPCount() < 4 or GetPlayerCount() < 15 then
		ply:Notify("There are not enough players to steal from the Evidence Locker (Minimum 15 players, 4 MPF).")
		return
	end
	self.LastRaided = CurTime()
	if #self.Inventory >= 1 then
		local index = math.random(1,#self.Inventory)
		impulse.Inventory.SpawnItem(self.Inventory[index], SpawnPos, 120)
		table.remove(self.Inventory, index)
		if !timer.Exists(id.."clearinv") then
			timer.Create(id.."clearinv", 3600, 0, function()
				self:WipeInventory()
			end)
		end
		return
	else
		impulse.Inventory.SpawnItem(table.Random(EmptyPool), SpawnPos, 120)
		return
	end
end
