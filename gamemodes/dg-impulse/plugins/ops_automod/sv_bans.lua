impulse.Ops = impulse.Ops or {}
impulse.Ops.AutoMod = impulse.Ops.AutoMod or {}


function impulse.Ops.AutoMod.Ban(ply, reason, risk, details, length)
    local steamid = ply:SteamID64()
    length = length or "0"

    for v,k in pairs(player.GetAll()) do
        if k:IsAdmin() then
            k:AddChatText(Color(0, 163, 118), "[AutoMod] "..steamid.." issued ban for suspected "..reason.." (risk score "..risk..")")
        end
    end

    VyHub.Ban:create(ply:SteamID64(), length, reason, "76561198066038219")

	if IsValid(ply) then
		ply:Kick("Automatic punishment issued")
	end
end

function meta:AutoModLogAdd(msg)
    self.AutoModLog = self.AutoModLog or {}

    table.insert(self.AutoModLog, "["..os.date("%H:%M:%S", os.time()).."] "..msg)
end

function meta:AutoModLogGet()
    local o = ""
    for v,k in pairs(self.AutoModLog or {}) do
        o = o.."\n"..k
    end

    return o
end