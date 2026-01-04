local VENDOR = {}

VENDOR.UniqueID = "converter"
VENDOR.Name = "Tech Exchange Officer"
VENDOR.Desc = "I'm fucking useless!"

VENDOR.Model = "models/Humans/Group03/male_09.mdl"
VENDOR.Skin = 0
VENDOR.Gender = "male" -- male, female, cp
VENDOR.Talk = true

VENDOR.Sell = {
}

VENDOR.Buy = {
}

function VENDOR:CanUse(ply)
    return not ply:IsCP()
end

function VENDOR:Initialize()
    self.Positions = impulse.Config.ConverterLocations or impulse.Config.DealerLocations
    self.NextMove = CurTime() + 10
end

local function moveToNextPosition(ent)
    ent.NextMove = CurTime() + math.random(impulse.Config.DealerTeleportTimeMax, impulse.Config.DealerTeleportTimeMax * 2)
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
