util.AddNetworkString("DeepAdjustDistrict")
util.AddNetworkString("DeepUpdateDistricts")

DISTRICT_2_STATUS = "OPEN"
DISTRICT_3_STATUS = "OPEN"
DISTRICT_4_STATUS = "OPEN"
DISTRICT_57_STATUS = "OPEN"

local status = "open"

local nextUpdate = 0
local nextDistrict = 0

net.Receive("DeepAdjustDistrict", function(len, ply)
    if CurTime() < nextDistrict then
        ply:Notify("Please wait " .. string.NiceTime(nextDistrict - CurTime()) .. " before using this function.")
    end
    if ply:IsCPCommand() and game.GetMap() == "rp_city17_futuristic_cloudy" and CurTime() > nextDistrict then
        local district = net.ReadUInt(8)
        if district == 2 then
            if DISTRICT_2_STATUS == "OPEN" then 
                DISTRICT_2_STATUS = "CLOSED"
                status = "closed"
            else
                DISTRICT_2_STATUS = "OPEN"
                status = "open"
            end
            net.Start("DeepUpdateDistricts")
            net.WriteString(DISTRICT_2_STATUS)
            net.WriteUInt(2,8)
            net.Broadcast()
        elseif district == 3 then
            if DISTRICT_3_STATUS == "OPEN" then 
                DISTRICT_3_STATUS = "CLOSED"
                status = "closed"
            else
                DISTRICT_3_STATUS = "OPEN"
                status = "open"
            end
            net.Start("DeepUpdateDistricts")
            net.WriteString(DISTRICT_3_STATUS)
            net.WriteUInt(3,8)
            net.Broadcast()
        elseif district == 4 then
            if DISTRICT_4_STATUS == "OPEN" then 
                DISTRICT_4_STATUS = "CLOSED"
                status = "closed"
            else
                DISTRICT_4_STATUS = "OPEN"
                status = "open"
            end
            net.Start("DeepUpdateDistricts")
            net.WriteString(DISTRICT_4_STATUS)
            net.WriteUInt(4,8)
            net.Broadcast()
        elseif district == 57 then
            if DISTRICT_57_STATUS == "OPEN" then 
                DISTRICT_57_STATUS = "CLOSED"
                status = "closed"
            else
                DISTRICT_57_STATUS = "OPEN"
                status = "open"
            end
            net.Start("DeepUpdateDistricts")
            net.WriteString(DISTRICT_57_STATUS)
            net.WriteUInt(57,8)
            net.Broadcast()
        end
        local msg1 = "Attention please, District " .. district .. " will be " .. status .. " to non residents in approximately 3 minutes. Cooperate with protection officers and your safety is assured."
        local msg2 = "Attention please, District " .. district .. " is now " .. status .. "."
        net.Start("DeepPlaySound")
        net.WriteString("ambient/cmb_alarm.mp3")
        net.WriteUInt(0, 10)
        net.Broadcast()
        for k,v in pairs(player.GetAll()) do
            v:SendChatClassMessage(75, msg1, ply )
        end
        net.Start("DeepPlaySound")
        net.WriteString("ambient/cmb_alarm.mp3")
        net.WriteUInt(180, 10)
        net.Broadcast()
        timer.Simple(180, function()
            for k,v in pairs(player.GetAll()) do
                v:SendChatClassMessage(75, msg2, ply )
            end
        end)
        nextDistrict = CurTime() + 180
    end
end)

function PLUGIN:Think()
    if CurTime() > nextUpdate and game.GetMap() == "rp_city17_futuristic_cloudy" then
        net.Start("DeepUpdateDistricts")
        net.WriteString(DISTRICT_2_STATUS)
        net.WriteUInt(2,8)
        net.Broadcast()
        net.Start("DeepUpdateDistricts")
        net.WriteString(DISTRICT_3_STATUS)
        net.WriteUInt(3,8)
        net.Broadcast()
        net.Start("DeepUpdateDistricts")
        net.WriteString(DISTRICT_4_STATUS)
        net.WriteUInt(4,8)
        net.Broadcast()
        nextUpdate = CurTime() + 360
    end
end

