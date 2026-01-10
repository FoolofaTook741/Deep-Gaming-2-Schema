local VENDOR = {}

VENDOR.UniqueID = "bmd"
VENDOR.Name = "Black Market Dealer"
VENDOR.Desc = "Sells and trades illegal items."

VENDOR.Model = "models/odessa.mdl"
VENDOR.Skin = 0
VENDOR.Gender = "male" -- male, female, cp
VENDOR.Talk = true

VENDOR.Sell = {
    ["util_bulletcasing"] = {
        Cost = 85
    },
    ["util_cloth"] = {
        Cost = 35
    },
    ["util_gunpowder"] = {
        Cost = 55,
        BuyMax = 6,
        TempCooldown = 1200
    },
    ["util_wood"] = {
        Cost = 30
    },
    ["item_lockpick"] = {
        Cost = 200
    },
    ["ammo_pistol"] = {
        Cost = 150
    },
    ["wep_pistol"] = {
        Cost = 225,
        BuyMax = 1,
        TempCooldown = 600
    },
    ["util_yeast"] = {
        Cost = 40,
        TempCooldown = 600
    },
    ["util_spices"] = {
        Cost = 30,
        BuyMax = 15,
        TempCooldown = 600
    },
    ["wep_axe"] = {
        Cost = 90,
        BuyMax = 1,
        TempCooldown = 600
    },
    ["util_xenextract"] = {
        Cost = 100
    },
    ["util_glue"] = {
        Cost = 20, 
        TempCooldown = 600
    },
    ["util_plastic"] = {
        Cost = 45,
        BuyMax = 8,
        TempCooldown = 1200
    },
    ["util_medicalsupplies"] = {
        Cost = 60,
        BuyMax = 5,
        TempCooldown = 1200,
        CanBuy = function(ply)
			if ply:Team() == TEAM_CWU and ply:GetTeamClass() == CLASS_MEDIC then
				return true
			end

			return false
		end
    },
    ["wep_pm63"] = {
        Desc = "Charisma Level 6+",
        Cost = 425,
        BuyMax = 1, 
        TempCooldown = 1200,
        CanBuy = function(ply)
            if ply:GetSkillLevel("charisma") >= 6 then
                return true
            else 
                return false
            end
        end
    },
    ["wep_mp7"] = {
        Desc = "Charisma Level 8+",
        Cost = 700,
        BuyMax = 1, 
        TempCooldown = 1200,
        CanBuy = function(ply)
            if ply:GetSkillLevel("charisma") >= 8 then
                return true
            else 
                return false
            end
        end
    },
    ["book_chinese"] = {
        Desc = "Charisma Level 10",
        Cost = 2000,
        BuyMax = 1, 
        TempCooldown = 1200,
        CanBuy = function(ply)
            if ply:GetSkillLevel("charisma") >= 10 then
                return true
            else 
                return false
            end
        end
    },
    ["book_hebrew"] = {
        Desc = "Charisma Level 10",
        Cost = 2000,
        BuyMax = 1, 
        TempCooldown = 1200,
        CanBuy = function(ply)
            if ply:GetSkillLevel("charisma") >= 10 then
                return true
            else 
                return false
            end
        end
    },
    ["item_healthvial"] = {
        Desc = "Charisma Level 10",
        Cost = 400,
        BuyMax = 1, 
        TempCooldown = 1200,
        CanBuy = function(ply)
            if ply:GetSkillLevel("charisma") >= 10 then
                return true
            else 
                return false
            end
        end
    },
    ["wep_medkit"] = {
        Desc = "Charisma Level 10",
        Cost = 50000,
        BuyMax = 1, 
        TempCooldown = 1200,
        CanBuy = function(ply)
            if ply:GetSkillLevel("charisma") >= 10 then
                return true
            else 
                return false
            end
        end
    },
}

VENDOR.Buy = {
    ["util_moonshine"] = {
        Cost = 400
    },
}

function VENDOR:CanUse(ply)
    return not ply:IsCP()
end

function VENDOR:Initialize()
    self.Positions = impulse.Config.DealerLocations
    self.NextMove = CurTime() + 10
end

local function moveToNextPosition(ent)
    ent.NextMove = CurTime() + math.random(impulse.Config.DealerTeleportTimeMin, impulse.Config.DealerTeleportTimeMax)
    local newPosition = ent.Positions[math.random(#ent.Positions)]

    if newPosition.pos == ent:GetPos() then
        return moveToNextPosition(ent)
    end

    if impulse.IsEmpty(newPosition.pos) then
        ent:SetPos(newPosition.pos)
        ent:SetAngles(newPosition.ang)
    else
        -- decreases chance of position being built on, however it is intentionally not perfect to stop players from making dupes to force the npc pos
        newPosition = ent.Positions[math.random(#ent.Positions)]
        ent:SetPos(newPosition.pos)
        ent:SetAngles(newPosition.ang)
    end

    ent:RemoveAllDecals()
end

function VENDOR:Think()
    if CurTime() > self.NextMove then
        moveToNextPosition(self)
    end

    self:NextThink(CurTime() + 8)
    return true
end

impulse.RegisterVendor(VENDOR)