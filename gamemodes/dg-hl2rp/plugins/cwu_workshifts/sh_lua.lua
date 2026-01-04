function meta:IsCWSupervisor()
    if self:Team() == TEAM_CWU and self:GetTeamRank() and self:GetTeamRank() >= RANK_SUPERVISOR then
        return true
    else
        return false
    end
end
GL_MED_DISC = 1
GL_ICT_MULT = 1

WORKSHIFT_MINING = false
WORKSHIFT_LAUNDRY = false
WORKSHIFT_OUTLANDS = false
WORKSHIFT_ICT = false
WORKSHIFT_MEDICAL = false

net.Receive("DeepStartWorkshift", function(len, ply)
    if not ply:IsCWSupervisor() then
        return
    end
    if timer.Exists("WorkshiftCooldown") then
        ply:Notify("Please wait " .. string.NiceTime(timer.TimeLeft("WorkshiftCooldown")) .. " before calling another workshift.")
        return
    end
    local sound
    local message
    local wsendstring = "The work cycle has concluded. All workers are now authorized to return to nominal labor duties."
    local workshift = net.ReadString()

    if workshift == "mining" then
        message = "Attention Please. Mandatory work cycle is now in progress, please relocate to the Industrial District for Refinery work cycle completion. Participation is mandatory."
        sound = "pa_speaker/workforce_startshift.wav"
        WORKSHIFT_MINING = true
        timer.Create("MiningWorkshift", 1800, 1, function()
            WORKSHIFT_MINING = false
            net.Start("DeepPlaySound")
            net.WriteString("ambient/cmb_alarm.mp3")
            net.WriteUInt(0, 10)
            net.Broadcast()
            for k,v in pairs(player.GetAll()) do
                v:SendChatClassMessage(71, wsendstring)
            end
        end)
    elseif workshift == "medical" then
        message = "Attention Please. Mandatory work cycle is now in progress, please relocate to Residential District 1 for Medical work cycle completion. Participation is mandatory."
        sound = "pa_speaker/workforce_startshift.wav"
        WORKSHIFT_MEDICAL = true
        GL_MED_DISC = 1
        timer.Create("MedicalWorkshift", 1800, 1, function()
            WORKSHIFT_MEDICAL = false
            GL_MED_DISC = 0.5
            net.Start("DeepPlaySound")
            net.WriteString("ambient/cmb_alarm.mp3")
            net.WriteUInt(0, 10)
            net.Broadcast()
            for k,v in pairs(player.GetAll()) do
                v:SendChatClassMessage(71, wsendstring)
            end
        end)
    elseif workshift == "ict" then
        message = "Attention Please. Mandatory work cycle is now in progress, please relocate to Residential District 1 for I.C.T. work cycle completion. Participation is mandatory."
        sound = "pa_speaker/workforce_startshift.wav"
        WORKSHIFT_ICT = true
        GL_ICT_MULT = 1.5
        timer.Create("ICTWorkshift", 1800, 1, function()
            WORKSHIFT_ICT = false
            GL_ICT_MULT = 1
            net.Start("DeepPlaySound")
            net.WriteString("ambient/cmb_alarm.mp3")
            net.WriteUInt(0, 10)
            net.Broadcast()
            for k,v in pairs(player.GetAll()) do
                v:SendChatClassMessage(71, wsendstring)
            end
        end)
    elseif workshift == "outlands" then
        message = "Attention Please. Mandatory work cycle is now in progress, please relocate to Alderwood Street for Outlands Cleanup work cycle completion. Participation is mandatory."
        sound = "pa_speaker/workforce_startshift.wav"
        WORKSHIFT_OUTLANDS = true
        timer.Create("OutlandsWorkshift", 1800, 1, function()
            WORKSHIFT_OUTLANDS = false
            net.Start("DeepPlaySound")
            net.WriteString("ambient/cmb_alarm.mp3")
            net.WriteUInt(0, 10)
            net.Broadcast()
            for k,v in pairs(player.GetAll()) do
                v:SendChatClassMessage(71, wsendstring)
            end
        end)
    elseif workshift == "laundry" then
        message = "Attention Please. Mandatory work cycle is now in progress, please relocate to Residential District 1 for Laundromat work cycle completion. Participation is mandatory."
        sound = "pa_speaker/workforce_startshift.wav"
        WORKSHIFT_LAUNDRY = true
        timer.Create("OutlandsWorkshift", 1800, 1, function()
            WORKSHIFT_LAUNDRY = false
            net.Start("DeepPlaySound")
            net.WriteString("ambient/cmb_alarm.mp3")
            net.WriteUInt(0, 10)
            net.Broadcast()
            for k,v in pairs(player.GetAll()) do
                v:SendChatClassMessage(71, wsendstring)
            end
        end)
    end

    timer.Create("WorkshiftCooldown", 5400, 1, function()
        for k,v in pairs(player.GetAll()) do
            if v:IsCWSupervisor() then
                v:Notify("The workshift cooldown has expired. A workshift can now be called.")
            end
        end
    end)

    net.Start("DeepPlaySound")
    net.WriteString(sound)
    net.WriteUInt(0, 10)
    net.Broadcast()

    for k,v in pairs(player.GetAll()) do
        v:SendChatClassMessage(71, message)
    end
end) 

CWU_RESIN = 0
CWU_RP = 0
CWU_FUNDING = 0
CWU_WEPTECHLVL = 0
CWU_TECHRESLVL = 0
CWU_ECORESLVL = 0
CWU_RAF = 1

function CalculateRP()
    local gain = 1
    for k,v in pairs(ents.FindByClass("deep_lgrc")) do
        gain = gain + 1
    end
    for k,v in pairs(ents.FindByClass("deep_mgrc")) do
        gain = gain + 4
    end
    for k,v in pairs(ents.FindByClass("deep_hgrc")) do
        gain = gain + 10
    end
    return gain
end


-- Global bools for research projects
RES_IF = false
RES_TAX = false
RES_VENDOR = false
RES_OCAAB = false
RES_ACF = false

RES_RECYCLER = false
RES_MGRC = false
RES_FABRICATOR = false
RES_HGRC = false

RES_BANDOLIERS = false
RES_SLAMS = false
RES_MASSPRODUCTION = false
RES_SYNTH = false

function meta:CWUSquadCanMake()
	local t = self:Team()

	if t != TEAM_CWU then
		return false
	end

	local rank = self:GetTeamRank()
	if not rank or rank == 0 then
		return false
	end

	if t == TEAM_CWU and rank < RANK_SUPERVISOR then
		return false
	end
	if self:GetSyncVar(SYNC_CWU_SQUAD) then
		return false
	end

	local c = 0
	local known = {}
	for v,k in pairs(team.GetPlayers(t)) do
		local sid = k:GetSyncVar(SYNC_CWU_SQUAD)
		if sid and not known[sid] then
			c = c + 1
			known[sid] = true
		end
	end
	return c < (self:Team() == TEAM_CWU and 4)
end

function meta:CWUSquadCanJoin(squadId)
	local t = self:Team()

	if t != TEAM_CWU then
		return false
	end

	local rank = self:GetTeamRank()

	if not rank then
		return false
	end

	if self:GetSyncVar(SYNC_CWU_SQUAD) then
		return false
	end

	local c = 0
	for v,k in pairs(team.GetPlayers(t)) do
		local id = k:GetSyncVar(SYNC_CWU_SQUAD)
		if id and id == squadId then
			c = c + 1
		end
	end

	if c == 0 then
		return false
	end
	return c < (self:Team() == TEAM_CWU and 10)
end

function meta:CWUSquadCanClaim()
	local t = self:Team()

	if t != TEAM_CWU then
		return false
	end

	local rank = self:GetTeamRank()

	if not rank then
		return false
	end

	local squad = self:GetSyncVar(SYNC_CWU_SQUAD)

	if not squad then
		return false
	end

	if t == TEAM_CWU and rank < RANK_SUPERVISOR then
		return false
	end

	local highestRank = 0
	local hasLeader = false
	for v,k in pairs(team.GetPlayers(t)) do
		local sqd = k:GetSyncVar(SYNC_CWU_SQUAD)

		if sqd and sqd == squad then
			if k:GetSyncVar(SYNC_CWU_SQUADLEAD) then
				hasLeader = true
			end

			local r = k:GetTeamRank()

			if r and r != 0 and r > highestRank then
				highestRank = r
			end
		end
	end

	if hasLeader then
		return false
	end

	if rank < highestRank then
		return false
	end

	return true
end

function meta:CWUGetSquad()
	local t = self:Team()

	if t != TEAM_CWU then
		return false
	end

	local rank = self:GetTeamRank()

	if not rank then
		return false
	end

	local squad = self:GetSyncVar(SYNC_CWU_SQUAD)

	if not squad then
		return false
	end

	return true, squad
end