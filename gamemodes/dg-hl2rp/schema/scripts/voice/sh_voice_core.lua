impulse.Voice = {}
impulse.Voice.List = {}
impulse.Voice.Checks = impulse.Voice.Checks or {}
impulse.Voice.ChatTypes = {}
impulse.Voice.Cooldowns = impulse.Voice.Cooldowns or {}

function impulse.Voice.DefineClass(class, onCheck, onModify, global)
	impulse.Voice.Checks[class] = {class = class:lower(), onCheck = onCheck, onModify = onModify, isGlobal = global}
end

function impulse.Voice.GetClass(ply)
	local def = {}

	for v,k in pairs(impulse.Voice.Checks) do
		if (k.onCheck(ply)) then
			def[#def + 1] = k
		end
	end

	return def
end

-- jsqo 28.03.2026
-- added the category parameter to the register function, 
-- this allows us to group certain voicelines together for random selection. 
function impulse.Voice.Register(class, key, replacement, source, category)
    class = class:lower()

    impulse.Voice.List[class] = impulse.Voice.List[class] or {}
    impulse.Voice.List[class][key:lower()] = {replacement = replacement, source = source}

    if category then
        local catKey = tostring(category):lower()

        if not impulse.Voice.List[class][catKey] then
            impulse.Voice.List[class][catKey] = { isCategory = true, choices = {} }
        end

        table.insert(impulse.Voice.List[class][catKey].choices, { replacement = replacement, source = source })
    end
end

function impulse.Voice.GetVoiceList(class, text, delay)
	local info = impulse.Voice.List[class]

	if (!info) then
		return
	end

	local output = {}
	local original = string.Explode(" ", text)
	local exploded = string.Explode(" ", text:lower())
	local phrase = ""
	local skip = 0
	local current = 0

	max = max or 10 -- I increased the max to 10, sometimes CTA/MPF larpers having hard time with the 5 voiceline limit.

	for k, v in ipairs(exploded) do
		if (k < skip) then
			continue
		end

		if (current < max) then
			local i = k
			local key = v

			local nextValue, nextKey

			while (true) do
				i = i + 1
				nextValue = exploded[i]

				if (!nextValue) then
					break
				end

				nextKey = key.." "..nextValue

				if (!info[nextKey]) then
					i = i + 1

					local nextValue2 = exploded[i]
					local nextKey2 = nextKey.." "..(nextValue2 or "")

					if (!nextValue2 or !info[nextKey2]) then
						i = i - 1

						break
					end

					nextKey = nextKey2
				end

				key = nextKey
			end

			if (info[key]) then
				local source = info[key].source
				local replacement = info[key].replacement
				
				-- jsqo 28.03.2026
				-- this is for the random voiceline system. 
				if (info[key].isCategory) then
					local picked = table.Random(info[key].choices)
					source = picked.source
					replacement = picked.replacement
				elseif (type(source) == "table") then 
					source = table.Random(source)
				end
				
				source = tostring(source)
				
				output[#output + 1] = {source, delay or 0.1}
				phrase = phrase..replacement.." "
				skip = i
				current = current + 1

				continue
			end
		end

		phrase = phrase..original[k].." "
	end
	
	if (phrase:sub(#phrase, #phrase) == " ") then
		phrase = phrase:sub(1, -2)
	end

	return #output > 0 and output or nil, phrase
end

function impulse.Voice.ChatClassMessageGet(class, message, sender, targets)
	local sounds, message = impulse.Voice.GetVoiceList(class, message)
	
	if (sounds) then
		return message, sounds
	end

	return message
end

impulse.Voice.ChatTypes[1] = true -- says
impulse.Voice.ChatTypes[6] = true -- yells
impulse.Voice.ChatTypes[7] = true -- whisper
impulse.Voice.ChatTypes[8] = true -- radio
impulse.Voice.ChatTypes[9] = true -- cmd radio
impulse.Voice.ChatTypes[10] = true -- sqd radio
impulse.Voice.ChatTypes[54] = true -- vortal bonds
impulse.Voice.ChatTypes[57] = true -- CP radio
impulse.Voice.ChatTypes[58] = true -- CTA radio
impulse.Voice.ChatTypes[59] = true -- CA radio
impulse.Voice.ChatTypes[60] = true -- HC radio

impulse.Voice.DefineClass("ordinal", function(ply)
	if not IsValid(ply) then return false end

	local team = ply:Team()
	if not team then return false end

	local rank = ply:GetTeamRank()
	if not rank then return false end

	local teamClass = ply:GetTeamClass()
	if not teamClass then return false end

	return team == TEAM_OTA and rank >= RANK_ORD and teamClass ~= CLASS_APF and teamClass ~= CLASS_PAYBACK
end, function(client, sounds, chatType)
	if not IsValid(client) then return end

	local beeps = impulse.Config.BeepSounds[client:Team()] or impulse.Config.BeepSounds[TEAM_CP]

	table.insert(sounds, 1, {(table.Random(beeps.on)), 0.25})
	sounds[#sounds + 1] = {(table.Random(beeps.off)), nil, 0.25}
end)

impulse.Voice.DefineClass("apf", function(ply)
	if not IsValid(ply) then return false end

	local team = ply:Team()
	if not team then return false end

	local teamClass = ply:GetTeamClass()
	if not teamClass then return false end

	return team == TEAM_OTA and teamClass == CLASS_APF 
end, function(client, sounds, chatType)
	if not IsValid(client) then return end

	local beeps = impulse.Config.BeepSounds[client:Team()] or impulse.Config.BeepSounds[TEAM_CP]

	table.insert(sounds, 1, {(table.Random(beeps.on)), 0.25})
	sounds[#sounds + 1] = {(table.Random(beeps.off)), nil, 0.25}
end)

impulse.Voice.DefineClass("wallhammer", function(ply)
	if not IsValid(ply) then return false end

	local team = ply:Team()
	if not team then return false end

	local teamClass = ply:GetTeamClass()
	if not teamClass then return false end

	return team == TEAM_OTA and teamClass == CLASS_PAYBACK 
end, function(client, sounds, chatType)
	if not IsValid(client) then return end

	local beeps = impulse.Config.BeepSounds[client:Team()] or impulse.Config.BeepSounds[TEAM_CP]

	table.insert(sounds, 1, {(table.Random(beeps.on)), 0.25})
	sounds[#sounds + 1] = {(table.Random(beeps.off)), nil, 0.25}
end)

impulse.Voice.DefineClass("grunt", function(ply)
	if not IsValid(ply) then return false end

	local team = ply:Team()
	if not team then return false end

	local rank = ply:GetTeamRank()
	if not rank then return false end

	local teamClass = ply:GetTeamClass()
	if not teamClass then return false end

	return (team == TEAM_OTA and rank == RANK_CGR) or (teamClass == CLASS_NOMAD and rank < RANK_ORD)
end, function(client, sounds, chatType)
	if not IsValid(client) then return end

	local beeps = impulse.Config.BeepSounds[client:Team()] or impulse.Config.BeepSounds[TEAM_CP]

	table.insert(sounds, 1, {(table.Random(beeps.on)), 0.25})
	sounds[#sounds + 1] = {(table.Random(beeps.off)), nil, 0.25}
end)

impulse.Voice.DefineClass("vort", function(ply)
	if ply:Team() == TEAM_VORT then
		local steamID = ply:SteamID()
		local lastUse = impulse.Voice.Cooldowns[steamID] or 0
		if CurTime() - lastUse >= 10 then
			impulse.Voice.Cooldowns[steamID] = CurTime()
			return true
		end
		return false
	end
	return false
end)

impulse.Voice.DefineClass("metrocop", function(ply)
	return (ply:Team() == TEAM_CP and !ply.IsAugmented)
end, function(client, sounds, chatType)
	local beeps = impulse.Config.BeepSounds[client:Team()] or impulse.Config.BeepSounds[TEAM_CP]

	table.insert(sounds, 1, {(table.Random(beeps.on)), 0.25})
	sounds[#sounds + 1] = {(table.Random(beeps.off)), nil, 0.25}
end)

impulse.Voice.DefineClass("overwatch", function(ply)
	if not IsValid(ply) then return false end

	local team = ply:Team()
	if not team then return false end

	local rank = ply:GetTeamRank()
	if not rank then return false end

	local teamClass = ply:GetTeamClass()
	if not teamClass then return false end

	return ((team == TEAM_OTA and rank > RANK_CGR and rank < RANK_ORD) and teamClass ~= CLASS_APF and teamClass ~= CLASS_PAYBACK and teamClass ~= CLASS_NOMAD) or (teamClass == CLASS_FIST and team == TEAM_OTA)
end, function(client, sounds, chatType)
	if not IsValid(client) then return end

	local beeps = impulse.Config.BeepSounds[client:Team()] or impulse.Config.BeepSounds[TEAM_CP]

	table.insert(sounds, 1, {(table.Random(beeps.on)), 0.25})
	sounds[#sounds + 1] = {(table.Random(beeps.off)), nil, 0.25}
end)


impulse.Voice.DefineClass("scar", function(ply)
	if not IsValid(ply) then return false end

	local team = ply:Team()
	if not team then return false end

	local isAugmented = ply.IsAugmented

	return (team == TEAM_CP and isAugmented) or ((ply:SteamID() == "STEAM_0:0:104958683" or ply:SteamID() == "STEAM_0:1:123745763") and team == TEAM_CP)
end, function(client, sounds, chatType)
	if not IsValid(client) then return end

	local beeps = impulse.Config.BeepSounds[client:Team()] or impulse.Config.BeepSounds[TEAM_CP]

	table.insert(sounds, 1, {(table.Random(beeps.on)), 0.25})
	sounds[#sounds + 1] = {(table.Random(beeps.off)), nil, 0.25}
end)

sound.Add({name="MaleCitizen.CPs",sound={"vo/npc/male01/cps01.wav","vo/npc/male01/cps02.wav"},channel=CHAN_AUTO})
sound.Add({name="MaleCitizen.Hi",sound={"vo/npc/male01/hi01.wav","vo/npc/male01/hi02.wav"},channel=CHAN_AUTO})
sound.Add({name="MaleCitizen.Scanners",sound={
	"vo/npc/male01/scanners01.wav",
	"vo/npc/male01/scanners02.wav"
},channel=CHAN_AUTO})
sound.Add({name="MaleCitizen.RunForLife",sound={
	"vo/npc/male01/runforyourlife01.wav",
	"vo/npc/male01/runforyourlife02.wav",
	"vo/npc/male01/runforyourlife03.wav"
},channel=CHAN_AUTO})
sound.Add({name="MaleCitizen.Hacks",sound={
	"vo/npc/male01/hacks01.wav",
	"vo/npc/male01/hacks02.wav"
},channel=CHAN_AUTO})
impulse.Voice.DefineClass("citizen_male", function(ply)
	if not ply:IsDonator() then return false end
	if not ply:IsCharacterFemale() then
		if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU or ply:Team() == TEAM_CA then
			local steamID = ply:SteamID()
			local lastUse = impulse.Voice.Cooldowns[steamID] or 0
			if CurTime() - lastUse >= 10 then
				impulse.Voice.Cooldowns[steamID] = CurTime()
				return true
			end
			return false
		end
		return false
	end
	return false
end)
sound.Add({name="FeMaleCitizen.CPs",sound={"vo/npc/female01/cps01.wav","vo/npc/female01/cps02.wav"},channel=CHAN_AUTO})
sound.Add({name="FeMaleCitizen.Hi",sound={"vo/npc/female01/hi01.wav","vo/npc/female01/hi02.wav"},channel=CHAN_AUTO})
sound.Add({name="FeMaleCitizen.No",sound={"vo/npc/female01/no01.wav","vo/npc/female01/no02.wav"},channel=CHAN_AUTO})
sound.Add({name="FeMaleCitizen.Scanners",sound={
	"vo/npc/female01/scanners01.wav",
	"vo/npc/female01/scanners02.wav"
},channel=CHAN_AUTO})
sound.Add({name="FeMaleCitizen.RunForLife",sound={
	"vo/npc/female01/runforyourlife01.wav",
	"vo/npc/female01/runforyourlife02.wav"
},channel=CHAN_AUTO})
sound.Add({name="FeMaleCitizen.Hacks",sound={
	"vo/npc/female01/hacks01.wav",
	"vo/npc/female01/hacks02.wav"
},channel=CHAN_AUTO})
impulse.Voice.DefineClass("citizen_female", function(ply)
	if not ply:IsDonator() then return false end
	if ply:IsCharacterFemale() then
		if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU or ply:Team() == TEAM_CA then
			local steamID = ply:SteamID()
			local lastUse = impulse.Voice.Cooldowns[steamID] or 0
			if CurTime() - lastUse >= 10 then
				impulse.Voice.Cooldowns[steamID] = CurTime()
				return true
			end
			return false
		end
		return false
	end
	return false
end)

impulse.Voice.DefineClass("zombie", function(ply)
	if not ply:IsDonator() then return false end
	if ply:Team() == TEAM_ZOMBIE and ply.RegularZombie then
		return true
	else
		return false
	end
end)

impulse.Voice.DefineClass("fast", function(ply)
	if not ply:IsDonator() then return false end
	if ply:Team() == TEAM_ZOMBIE and ply.FastZombie then
		return true
	else
		return false
	end
end)

impulse.Voice.DefineClass("zombine", function(ply)
	if not ply:IsDonator() then return false end
	if ply:Team() == TEAM_ZOMBIE and ply.Zombine then
		return true
	else
		return false
	end
end)

impulse.Voice.Register("metrocop", "0", "0", "npc/metropolice/vo/zero.wav")
impulse.Voice.Register("metrocop", "1", "1", "npc/metropolice/vo/one.wav")
impulse.Voice.Register("metrocop", "10", "10", "npc/metropolice/vo/ten.wav")
impulse.Voice.Register("metrocop", "10-0 HUNTING", "10-0, 10-0, viscerator is hunting!", "npc/metropolice/vo/tenzerovisceratorishunting.wav")
impulse.Voice.Register("metrocop", "10-103 TAG", "Possible 10-103, my location, alert TAG units.", "npc/metropolice/vo/possible10-103alerttagunits.wav")
impulse.Voice.Register("metrocop", "10-107", "I have a 10-107 here, send AirWatch for tag.", "npc/metropolice/vo/gota10-107sendairwatch.wav")
impulse.Voice.Register("metrocop", "10-108", "We have a 10-108!", "npc/metropolice/vo/wehavea10-108.wav")
impulse.Voice.Register("metrocop", "10-14", "Holding on 10-14 duty, eh, code four.", "npc/metropolice/vo/holdingon10-14duty.wav")
impulse.Voice.Register("metrocop", "10-15", "Prepare for 10-15.", "npc/metropolice/vo/preparefor1015.wav")
impulse.Voice.Register("metrocop", "10-2", "10-2.", "npc/metropolice/vo/ten2.wav")
impulse.Voice.Register("metrocop", "10-25", "Any unit, report in with 10-25 as suspect.", "npc/metropolice/vo/unitreportinwith10-25suspect.wav")
impulse.Voice.Register("metrocop", "10-30", "I have a 10-30, my 10-20, responding, code two.", "npc/metropolice/vo/Ihave10-30my10-20responding.wav")
impulse.Voice.Register("metrocop", "10-4", "10-4.", "npc/metropolice/vo/ten4.wav")
impulse.Voice.Register("metrocop", "10-65", "Unit is 10-65.", "npc/metropolice/vo/unitis10-65.wav")
impulse.Voice.Register("metrocop", "10-78", "Dispatch, I need 10-78, officer in trouble!", "npc/metropolice/vo/dispatchIneed10-78.wav")
impulse.Voice.Register("metrocop", "10-8 standing by", "10-8, standing by.", "npc/metropolice/vo/ten8standingby.wav")
impulse.Voice.Register("metrocop", "10-8", "Unit is on-duty, 10-8.", "npc/metropolice/vo/unitisonduty10-8.wav")
impulse.Voice.Register("metrocop", "10-91D", "10-91d count is...", "npc/metropolice/vo/ten91dcountis.wav")
impulse.Voice.Register("metrocop", "10-97 GOA", "10-97, that suspect is GOA.", "npc/metropolice/vo/ten97suspectisgoa.wav")
impulse.Voice.Register("metrocop", "10-97", "10-97.", "npc/metropolice/vo/ten97.wav")
impulse.Voice.Register("metrocop", "10-99", "Officer down, I am 10-99, I repeat, I am 10-99!", "npc/metropolice/vo/officerdownIam10-99.wav")
impulse.Voice.Register("metrocop", "100", "One-hundred.", "npc/metropolice/vo/onehundred.wav")
impulse.Voice.Register("metrocop", "11-44", "Get that 11-44 inbound, we're cleaning up now.", "npc/metropolice/vo/get11-44inboundcleaningup.wav")
impulse.Voice.Register("metrocop", "11-6", "Suspect 11-6, my 10-20 is...", "npc/metropolice/vo/suspect11-6my1020is.wav")
impulse.Voice.Register("metrocop", "11-99", "11-99, officer needs assistance!", "npc/metropolice/vo/11-99officerneedsassistance.wav")
impulse.Voice.Register("metrocop", "2", "2", "npc/metropolice/vo/two.wav")
impulse.Voice.Register("metrocop", "20", "20", "npc/metropolice/vo/twenty.wav")
impulse.Voice.Register("metrocop", "200", "Two-hundred.", "npc/metropolice/vo/twohundred.wav")
impulse.Voice.Register("metrocop", "3", "3", "npc/metropolice/vo/three.wav")
impulse.Voice.Register("metrocop", "30", "30", "npc/metropolice/vo/thirty.wav")
impulse.Voice.Register("metrocop", "300", "Three-hundred.", "npc/metropolice/vo/threehundred.wav")
impulse.Voice.Register("metrocop", "34S AT", "All units, BOL, we have 34-S at...", "npc/metropolice/vo/allunitsbol34sat.wav")
impulse.Voice.Register("metrocop", "4", "4", "npc/metropolice/vo/four.wav")
impulse.Voice.Register("metrocop", "40", "40", "npc/metropolice/vo/fourty.wav")
impulse.Voice.Register("metrocop", "404", "404 zone.", "npc/metropolice/vo/404zone.wav")
impulse.Voice.Register("metrocop", "408", "I've got a 408 here at location.", "npc/metropolice/vo/Ivegot408hereatlocation.wav")
impulse.Voice.Register("metrocop", "415B", "Is 415b.", "npc/metropolice/vo/is415b.wav")
impulse.Voice.Register("metrocop", "5", "5", "npc/metropolice/vo/five.wav")
impulse.Voice.Register("metrocop", "50", "50", "npc/metropolice/vo/fifty.wav")
impulse.Voice.Register("metrocop", "505", "Dispatch, we need AirWatch, subject is 505!", "npc/metropolice/vo/airwatchsubjectis505.wav")
impulse.Voice.Register("metrocop", "6", "6", "npc/metropolice/vo/six.wav")
impulse.Voice.Register("metrocop", "60", "60", "npc/metropolice/vo/sixty.wav")
impulse.Voice.Register("metrocop", "603", "603, unlawful entry.", "npc/metropolice/vo/unlawfulentry603.wav")
impulse.Voice.Register("metrocop", "63", "63, criminal trespass.", "npc/metropolice/vo/criminaltrespass63.wav")
impulse.Voice.Register("metrocop", "63", "63, criminal trespass.", "npc/metropolice/vo/criminaltrespass63.wav")
impulse.Voice.Register("metrocop", "7", "7", "npc/metropolice/vo/seven.wav")
impulse.Voice.Register("metrocop", "70", "70", "npc/metropolice/vo/seventy.wav")
impulse.Voice.Register("metrocop", "8", "8", "npc/metropolice/vo/eight.wav")
impulse.Voice.Register("metrocop", "80", "80", "npc/metropolice/vo/eighty.wav")
impulse.Voice.Register("metrocop", "9", "9", "npc/metropolice/vo/nine.wav")
impulse.Voice.Register("metrocop", "90", "90", "npc/metropolice/vo/ninety.wav")
impulse.Voice.Register("metrocop", "ACQUIRING", "Acquiring on visual!", "npc/metropolice/vo/acquiringonvisual.wav")
impulse.Voice.Register("metrocop", "ADMINISTER", "Administer.", "npc/metropolice/vo/administer.wav")
impulse.Voice.Register("metrocop", "AFFIRMATIVE", "Affirmative.", "npc/metropolice/vo/affirmative.wav")
impulse.Voice.Register("metrocop", "ALL UNITS MOVE", "All units, move in!", "npc/metropolice/vo/allunitsmovein.wav")
impulse.Voice.Register("metrocop", "AMPUTATE", "Amputate.", "npc/metropolice/vo/amputate.wav")
impulse.Voice.Register("metrocop", "ANTICITIZEN ONE", "Anti-Citizen one.", "npc/combine_soldier/vo/anticitizenone.wav")
impulse.Voice.Register("metrocop", "ANTICITIZEN", "Anti-citizen.", "npc/metropolice/vo/anticitizen.wav")
impulse.Voice.Register("metrocop", "ANTISEPTIC", "Antiseptic.", "npc/combine_soldier/vo/antiseptic.wav")
impulse.Voice.Register("metrocop", "APEX", "Apex.", "npc/combine_soldier/vo/apex.wav")
impulse.Voice.Register("metrocop", "APPLY", "Apply.", "npc/metropolice/vo/apply.wav")
impulse.Voice.Register("metrocop", "ARREST POSITIONS", "All units, move to arrest positions!", "npc/metropolice/vo/movetoarrestpositions.wav")
impulse.Voice.Register("metrocop", "AT CHECKPOINT", "At checkpoint.", "npc/metropolice/vo/atcheckpoint.wav")
impulse.Voice.Register("metrocop", "AT LOCATION REPORT", "Protection-teams at location, report in.", "npc/metropolice/vo/ptatlocationreport.wav")
impulse.Voice.Register("metrocop", "BACK ME UP", "Back me up, I'm out!", "npc/metropolice/vo/backmeupImout.wav")
impulse.Voice.Register("metrocop", "BACKUP", "Backup!", "npc/metropolice/vo/backup.wav")
impulse.Voice.Register("metrocop", "BEARING", "Bearing", "npc/combine_soldier/vo/bearing.wav")
impulse.Voice.Register("metrocop", "BEATS THE SHIT", "Beats the shit outta my last job.", "npc/metropolice/mc1que_lastjob.wav")
impulse.Voice.Register("metrocop", "BELIEVE YOU WANT", "You can believe what you want.", "npc/metropolice/mc1ans_believewhatyouwant.wav")
impulse.Voice.Register("metrocop", "BEST CAREER CHOICE", "Yep, this was definitely the best career choice I've ever made.", "npc/metropolice/mc1que_career.wav")
impulse.Voice.Register("metrocop", "BETTER THINGS", "I have better things to do.", "npc/metropolice/mc1que_betterthings.wav")
impulse.Voice.Register("metrocop", "BLADE", "Blade.", "npc/combine_soldier/vo/blade.wav")
impulse.Voice.Register("metrocop", "BLEEDING", "Suspect is bleeding from multiple wounds!", "npc/metropolice/vo/suspectisbleeding.wav")
impulse.Voice.Register("metrocop", "BLIP", "Catch that blip on the stabilization readout?", "npc/metropolice/vo/catchthatbliponstabilization.wav")
impulse.Voice.Register("metrocop", "BLOCK HOLDING", "Block is holding, cohesive.", "npc/metropolice/vo/blockisholdingcohesive.wav")
impulse.Voice.Register("metrocop", "BLOCK", "Block!", "npc/metropolice/vo/block.wav")
impulse.Voice.Register("metrocop", "BOL 243", "CP, we need AirWatch to BOL for that 243.", "npc/metropolice/vo/cpbolforthat243.wav")
impulse.Voice.Register("metrocop", "BOUNCER", "Bouncer bouncer!", "npc/combine_soldier/vo/bouncerbouncer.wav")
impulse.Voice.Register("metrocop", "BREAK COVER", "Break his cover!", "npc/metropolice/vo/breakhiscover.wav")
impulse.Voice.Register("metrocop", "CALL CONTACT PARASITICS", "Call contact parasitics!", "npc/combine_soldier/vo/callcontactparasitics.wav")
impulse.Voice.Register("metrocop", "CAN1", "Pick up that can.", "npc/metropolice/vo/pickupthecan1.wav")
impulse.Voice.Register("metrocop", "CAN2", "Pick up the can!", "npc/metropolice/vo/pickupthecan2.wav")
impulse.Voice.Register("metrocop", "CAN3", "I said, pick up the can!", "npc/metropolice/vo/pickupthecan3.wav")
impulse.Voice.Register("metrocop", "CAN4", "Now, put it in the trash-can.", "npc/metropolice/vo/putitinthetrash1.wav")
impulse.Voice.Register("metrocop", "CAN5", "I said, put it in the trash-can!", "npc/metropolice/vo/putitinthetrash2.wav")
impulse.Voice.Register("metrocop", "CAN6", "You knocked it over, pick it up!", "npc/metropolice/vo/youknockeditover.wav")
impulse.Voice.Register("metrocop", "CANAL", "Canal.", "npc/metropolice/vo/canal.wav")
impulse.Voice.Register("metrocop", "CANALBLOCK", "Canalblock!", "npc/metropolice/vo/canalblock.wav")
impulse.Voice.Register("metrocop", "CAUTERIZE", "Cauterize.", "npc/metropolice/vo/cauterize.wav")
impulse.Voice.Register("metrocop", "CHECK MISCOUNT", "Check for miscount.", "npc/metropolice/vo/checkformiscount.wav")
impulse.Voice.Register("metrocop", "CHECKPOINTS", "Proceed to designated checkpoints.", "npc/metropolice/vo/proceedtocheckpoints.wav")
impulse.Voice.Register("metrocop", "CITIZEN SUMMONED", "Reporting citizen summoned into voluntary conscription for channel open service detail T94-332.", "npc/metropolice/vo/citizensummoned.wav")
impulse.Voice.Register("metrocop", "CITIZEN", "Citizen.", "npc/metropolice/vo/citizen.wav")
impulse.Voice.Register("metrocop", "CLASSIFY DB", "Classify subject name as 'DB'; this block ready for clean-out.", "npc/metropolice/vo/classifyasdbthisblockready.wav")
impulse.Voice.Register("metrocop", "CLEANED", "Cleaned.", "npc/combine_soldier/vo/cleaned.wav")
impulse.Voice.Register("metrocop", "CLEAR CODE 100", "Clear and code one-hundred.", "npc/metropolice/vo/clearandcode100.wav")
impulse.Voice.Register("metrocop", "CLOSE ON SUSPECT", "All units, close on suspect!", "npc/metropolice/vo/allunitscloseonsuspect.wav")
impulse.Voice.Register("metrocop", "CLOSING", "Closing!", {"npc/combine_soldier/vo/closing.wav", "npc/combine_soldier/vo/closing2.wav"})
impulse.Voice.Register("metrocop", "CODE 100", "Code one-hundred.", "npc/metropolice/vo/code100.wav")
impulse.Voice.Register("metrocop", "CODE 2", "All units, code two!", "npc/metropolice/vo/allunitscode2.wav")
impulse.Voice.Register("metrocop", "CODE 3", "Officer down, request all units, code three to my 10-20!", "npc/metropolice/vo/officerdowncode3tomy10-20.wav")
impulse.Voice.Register("metrocop", "CODE 7", "Code seven.", "npc/metropolice/vo/code7.wav")
impulse.Voice.Register("metrocop", "COME WITH ME", "You, citizen, come with me.", "vo/trainyard/ba_youcomewith.wav")
impulse.Voice.Register("metrocop", "CONDEMNED", "Condemned zone!", "npc/metropolice/vo/condemnedzone.wav")
impulse.Voice.Register("metrocop", "CONFIRMED ADW", "Confirmed as ADW on that suspect, 10-0.", "npc/metropolice/vo/confirmadw.wav")
impulse.Voice.Register("metrocop", "CONTACT 243", "Contact with 243 suspect, my 10-20 is...", "npc/metropolice/vo/contactwith243suspect.wav")
impulse.Voice.Register("metrocop", "CONTACT PRIORITY", "I have contact with a priority two!", "npc/metropolice/vo/contactwithpriority2.wav")
impulse.Voice.Register("metrocop", "CONTACT", "Contact!", "npc/combine_soldier/vo/contact.wav")
impulse.Voice.Register("metrocop", "CONTAINED", "Contained.", "npc/combine_soldier/vo/contained.wav")
impulse.Voice.Register("metrocop", "CONTROL 100", "Control is one-hundred percent this location, no sign of that 647-E.", "npc/metropolice/vo/control100percent.wav")
impulse.Voice.Register("metrocop", "CONTROLSECTION", "Control-section!", "npc/metropolice/vo/controlsection.wav")
impulse.Voice.Register("metrocop", "CONVERGING", "Converging.", "npc/metropolice/vo/converging.wav")
impulse.Voice.Register("metrocop", "COPY THAT", "Copy that.", "npc/combine_soldier/vo/copythat.wav")
impulse.Voice.Register("metrocop", "COPY", "Copy.", "npc/metropolice/vo/copy.wav")
impulse.Voice.Register("metrocop", "COVER ME", "Cover me.", "npc/combine_soldier/vo/coverme.wav")
impulse.Voice.Register("metrocop", "COVER", "Cover!", "npc/combine_soldier/vo/coverhurt.wav")
impulse.Voice.Register("metrocop", "CP COMPROMISED", "CP is compromised, re-establish!", "npc/metropolice/vo/cpiscompromised.wav")
impulse.Voice.Register("metrocop", "CP ESTABLISH", "CP, we need to establish our perimeter at...", "npc/metropolice/vo/cpweneedtoestablishaperimeterat.wav")
impulse.Voice.Register("metrocop", "CP OVERRUN", "CP is overrun, we have no containment!", "npc/metropolice/vo/cpisoverrunwehavenocontainment.wav")
impulse.Voice.Register("metrocop", "DAGGER", "Dagger.", "npc/combine_soldier/vo/dagger.wav")
impulse.Voice.Register("metrocop", "DASH", "Dash.", "npc/combine_soldier/vo/dash.wav")
impulse.Voice.Register("metrocop", "DB COUNT", "DB count is...", "npc/metropolice/vo/dbcountis.wav")
impulse.Voice.Register("metrocop", "DEFENDER", "Defender!", "npc/metropolice/vo/defender.wav")
impulse.Voice.Register("metrocop", "DEGREES", "Degrees", "npc/combine_soldier/vo/degrees.wav")
impulse.Voice.Register("metrocop", "DESERVICED AREA", "Deserviced area.", "npc/metropolice/vo/deservicedarea.wav")
impulse.Voice.Register("metrocop", "DESIGNATE SUSPECT", "Designate suspect as...", "npc/metropolice/vo/designatesuspectas.wav")
impulse.Voice.Register("metrocop", "DESTROY COVER", "Destroy that cover!", "npc/metropolice/vo/destroythatcover.wav")
impulse.Voice.Register("metrocop", "DISLOCATE INTERPOSE", "Fire to dislocate that interpose!", "npc/metropolice/vo/firetodislocateinterpose.wav")
impulse.Voice.Register("metrocop", "DISMOUNTING HARDPOINT", "Dismounting hardpoint.", "npc/metropolice/vo/dismountinghardpoint.wav")
impulse.Voice.Register("metrocop", "DISP APB", "Disp updating APB likeness.", "npc/metropolice/vo/dispupdatingapb.wav")
impulse.Voice.Register("metrocop", "DISPLACE", "Displace!", "npc/combine_soldier/vo/displace.wav")
impulse.Voice.Register("metrocop", "DISTRIBUTION BLOCK", "Distribution block.", "npc/metropolice/vo/distributionblock.wav")
impulse.Voice.Register("metrocop", "DOCUMENT", "Document.", "npc/metropolice/vo/document.wav")
impulse.Voice.Register("metrocop", "DONT GET AWAY", "Don't let him get away!", "npc/metropolice/pointer04.wav")
impulse.Voice.Register("metrocop", "DONT MOVE", "Don't move!", "npc/metropolice/vo/dontmove.wav")
impulse.Voice.Register("metrocop", "DONT WANNA TALK", "I don't wanna talk about it.", "npc/metropolice/mc1ans_dontwannatalk.wav")
impulse.Voice.Register("metrocop", "DROP YOUR WEAPON", "Drop your weapon, get down!", "npc/metropolice/dropweapon.wav")
impulse.Voice.Register("metrocop", "ECHO", "Echo.", "npc/combine_soldier/vo/echo.wav")
impulse.Voice.Register("metrocop", "ENGAGED IN", "engaged in cleanup.", "npc/combine_soldier/vo/engagedincleanup.wav")
impulse.Voice.Register("metrocop", "ENGAGING", "Engaging!", "npc/combine_soldier/vo/engaging.wav")
impulse.Voice.Register("metrocop", "ENLISTING", "Sooo... I been thinking about enlisting.", "npc/metropolice/mc1que_enlisting.wav")
impulse.Voice.Register("metrocop", "ENOUGH OUTTA YOU", "That's enough outta you.", "npc/metropolice/mc1ans_enoughouttayou.wav")
impulse.Voice.Register("metrocop", "ESTABLISH NEW CP", "Fall down, establish a new CP!", "npc/metropolice/vo/establishnewcp.wav")
impulse.Voice.Register("metrocop", "EVERYTHING I HOPED", "This is everything I hoped it would be.", "npc/metropolice/mc1que_everythingihoped.wav")
impulse.Voice.Register("metrocop", "EXPECT ME BELIEVE", "You expect me to believe that?	", "npc/metropolice/mc1ans_youexpectme.wav")
impulse.Voice.Register("metrocop", "EXPIRED", "Expired.", "npc/metropolice/vo/expired.wav")
impulse.Voice.Register("metrocop", "EXPOSE TARGET", "Firing to expose target!", "npc/metropolice/vo/firingtoexposetarget.wav")
impulse.Voice.Register("metrocop", "EXTERNAL", "External jurisdiction.", "npc/metropolice/vo/externaljurisdiction.wav")
impulse.Voice.Register("metrocop", "EXTRACTOR AWAY", "Extractor away!", "npc/combine_soldier/vo/extractoraway.wav")
impulse.Voice.Register("metrocop", "EXTRACTOR IS LIVE", "Extractor is live!", "npc/combine_soldier/vo/extractorislive.wav")
impulse.Voice.Register("metrocop", "FASCINATING", "Fascinating.", "npc/metropolice/mc1ans_fascinating.wav")
impulse.Voice.Register("metrocop", "FEELING GOOD", "I'm feeling good about myself today.", "npc/metropolice/mc1que_feelinggood.wav")
impulse.Voice.Register("metrocop", "FEET ARE KILLIN", "My feet are killin' me.", "npc/metropolice/mc1que_feetkillin.wav")
impulse.Voice.Register("metrocop", "FIGURES", "Figures.", "npc/metropolice/mc1ans_figures.wav")
impulse.Voice.Register("metrocop", "FINAL VERDICT", "Final verdict administered.", "npc/metropolice/vo/finalverdictadministered.wav")
impulse.Voice.Register("metrocop", "FINAL WARNING", "Final warning!", "npc/metropolice/vo/finalwarning.wav")
impulse.Voice.Register("metrocop", "FIRST WARNING", "First warning, move away!", "npc/metropolice/vo/firstwarningmove.wav")
impulse.Voice.Register("metrocop", "FIST", "Fist.", "npc/combine_soldier/vo/fist.wav")
impulse.Voice.Register("metrocop", "FLASH", "Flash.", "npc/combine_soldier/vo/flash.wav")
impulse.Voice.Register("metrocop", "FLATLINE", "Flatline.", "npc/combine_soldier/vo/flatline.wav")
impulse.Voice.Register("metrocop", "FLUSH", "Flush.", "npc/combine_soldier/vo/flush.wav")
impulse.Voice.Register("metrocop", "FREE NECROTICS", "I have free necrotics!", "npc/metropolice/vo/freenecrotics.wav")
impulse.Voice.Register("metrocop", "FREEZE", "Freeze!", "npc/metropolice/freeze.wav")
impulse.Voice.Register("metrocop", "FULL ACTIVE", "Full active.", "npc/combine_soldier/vo/fullactive.wav")
impulse.Voice.Register("metrocop", "GET DOWN", "Get down!", "npc/metropolice/vo/getdown.wav")
impulse.Voice.Register("metrocop", "GET IN", "Get in.", "vo/trainyard/ba_getin.wav")
impulse.Voice.Register("metrocop", "GET ON GROUND", "Stay where you are, get on the ground, do it now!", "npc/metropolice/getonground.wav")
impulse.Voice.Register("metrocop", "GET OUT", "Get out of here!", "npc/metropolice/vo/getoutofhere.wav")
impulse.Voice.Register("metrocop", "GETTING 647E", "Still getting that 647-E from local surveillance.", "npc/metropolice/vo/stillgetting647e.wav")
impulse.Voice.Register("metrocop", "GETTING THE PERKS", "So, you getting the perks they promised you?", "npc/metropolice/mc1que_perks.wav")
impulse.Voice.Register("metrocop", "GHOST", "Ghost.", "npc/combine_soldier/vo/ghost.wav")
impulse.Voice.Register("metrocop", "GO AGAIN", "PT, go again.", "npc/metropolice/vo/ptgoagain.wav")
impulse.Voice.Register("metrocop", "GO SHARP", "Go sharp!", "npc/combine_soldier/vo/gosharp.wav")
impulse.Voice.Register("metrocop", "GO SHARP2", "Go sharp, go sharp.", "npc/combine_soldier/vo/gosharpgosharp.wav")
impulse.Voice.Register("metrocop", "GOING IN", "Cover me, I'm going in!", "npc/metropolice/vo/covermegoingin.wav")
impulse.Voice.Register("metrocop", "GOING TO HELL", "This whole place is going to hell. Well, not this place.", "npc/metropolice/mc1que_goingtohell.wav")
impulse.Voice.Register("metrocop", "GOT A DB", "Uh, we got a DB here, cancel that 11-42.", "npc/metropolice/vo/wegotadbherecancel10-102.wav")
impulse.Voice.Register("metrocop", "GOT HIM AGAIN", "Got him again, suspect is 10-20 at...", "npc/metropolice/vo/gothimagainsuspect10-20at.wav")
impulse.Voice.Register("metrocop", "GOT ONE ACCOMPLICE", "I got one accomplice here!", "npc/metropolice/vo/gotoneaccompliceherea.wav")
impulse.Voice.Register("metrocop", "GOT SUSPECT ONE", "I got suspect one here!", "npc/metropolice/vo/gotsuspect1here.wav")
impulse.Voice.Register("metrocop", "GRENADE", "Grenade!", "npc/metropolice/vo/grenade.wav")
impulse.Voice.Register("metrocop", "GRID", "Grid.", "npc/combine_soldier/vo/grid.wav")
impulse.Voice.Register("metrocop", "HAHA", "Haha.", "npc/metropolice/vo/chuckle.wav")
impulse.Voice.Register("metrocop", "HAMMER", "Hammer.", "npc/combine_soldier/vo/hammer.wav")
impulse.Voice.Register("metrocop", "HANDS UP", "Hands up!", "npc/metropolice/deploy01.wav")
impulse.Voice.Register("metrocop", "HANDS", "Hands!", "npc/metropolice/deploy04.wav")
impulse.Voice.Register("metrocop", "HARDPOINT PROSECUTE", "Is at hardpoint, ready to prosecute!", "npc/metropolice/vo/isathardpointreadytoprosecute.wav")
impulse.Voice.Register("metrocop", "HARDPOINT SCANNING", "Hardpoint scanning.", "npc/metropolice/vo/hardpointscanning.wav")
impulse.Voice.Register("metrocop", "HELIX", "Helix.", "npc/combine_soldier/vo/helix.wav")
impulse.Voice.Register("metrocop", "HELP", "Help!", "npc/metropolice/vo/help.wav")
impulse.Voice.Register("metrocop", "HERO", "Hero!", "npc/metropolice/vo/hero.wav")
impulse.Voice.Register("metrocop", "HES 148", "He's gone 148!", "npc/metropolice/vo/hesgone148.wav")
impulse.Voice.Register("metrocop", "HES GETTING AWAY", "He's getting away!", "npc/metropolice/pointer06.wav")
impulse.Voice.Register("metrocop", "HEY", "Hey!", "npc/metropolice/pointer02.wav")
impulse.Voice.Register("metrocop", "HIGH PRIORITY", "High-priority region.", "npc/metropolice/vo/highpriorityregion.wav")
impulse.Voice.Register("metrocop", "HM", "Hm.", "npc/metropolice/mc1ans_hm.wav")
impulse.Voice.Register("metrocop", "HOLD IT THERE", "Hold it there!", "npc/metropolice/pointer01.wav")
impulse.Voice.Register("metrocop", "HOLD IT", "Hold it right there!", "npc/metropolice/vo/holditrightthere.wav")
impulse.Voice.Register("metrocop", "HOLD POSITION", "Protection-team, hold this position.", "npc/metropolice/vo/holdthisposition.wav")
impulse.Voice.Register("metrocop", "HOLD", "Hold it!", "npc/metropolice/vo/holdit.wav")
impulse.Voice.Register("metrocop", "HUH FIGURES", "Huh, figures.", "npc/metropolice/mc1ans_huhfigures.wav")
impulse.Voice.Register("metrocop", "HUH", "Huh?", "npc/metropolice/surprise2.wav")
impulse.Voice.Register("metrocop", "HUNTER", "Hunter.", "npc/combine_soldier/vo/hunter.wav")
impulse.Voice.Register("metrocop", "HURRICANE", "Hurricane.", "npc/combine_soldier/vo/hurricane.wav")
impulse.Voice.Register("metrocop", "I SAID MOVE", "I said move along.", "npc/metropolice/vo/Isaidmovealong.wav")
impulse.Voice.Register("metrocop", "ICE", "Ice.", "npc/combine_soldier/vo/ice.wav")
impulse.Voice.Register("metrocop", "IN POSITION", "In position.", "npc/metropolice/vo/inposition.wav")
impulse.Voice.Register("metrocop", "INBOUND", "Inbound.", "npc/combine_soldier/vo/inbound.wav")
impulse.Voice.Register("metrocop", "INFECTED", "Infected.", "npc/combine_soldier/vo/infected.wav")
impulse.Voice.Register("metrocop", "INFECTION", "Infection!", "npc/metropolice/vo/infection.wav")
impulse.Voice.Register("metrocop", "INFESTED", "Infested zone.", "npc/metropolice/vo/infestedzone.wav")
impulse.Voice.Register("metrocop", "INJECT", "Inject!", "npc/metropolice/vo/inject.wav")
impulse.Voice.Register("metrocop", "INOCULATE", "Inoculate.", "npc/metropolice/vo/innoculate.wav")
impulse.Voice.Register("metrocop", "INTERCEDE", "Intercede!", "npc/metropolice/vo/intercede.wav")
impulse.Voice.Register("metrocop", "INTERLOCK", "Interlock!", "npc/metropolice/vo/interlock.wav")
impulse.Voice.Register("metrocop", "INVESTIGATE", "Investigate.", "npc/metropolice/vo/investigate.wav")
impulse.Voice.Register("metrocop", "INVESTIGATING", "Investigating 10-103.", "npc/metropolice/vo/investigating10-103.wav")
impulse.Voice.Register("metrocop", "ION", "Ion.", "npc/combine_soldier/vo/ion.wav")
impulse.Voice.Register("metrocop", "IS 10-108", "Is 10-108!", "npc/metropolice/vo/is10-108.wav")
impulse.Voice.Register("metrocop", "IS 10-8", "Unit is 10-8, standing by.", "npc/metropolice/vo/unitis10-8standingby.wav")
impulse.Voice.Register("metrocop", "IS AT CODE", "Is at code", "npc/combine_soldier/vo/isatcode.wav")
impulse.Voice.Register("metrocop", "IS CLOSING", "Is closing on suspect!", "npc/metropolice/vo/isclosingonsuspect.wav")
impulse.Voice.Register("metrocop", "IS DOWN", "Is down!", "npc/metropolice/vo/isdown.wav")
impulse.Voice.Register("metrocop", "IS HOLDING CODE", "Is holding at code", "npc/combine_soldier/vo/isholdingatcode.wav")
impulse.Voice.Register("metrocop", "IS INBOUND", "Unit is inbound.", "npc/combine_soldier/vo/unitisinbound.wav")
impulse.Voice.Register("metrocop", "IS MOVING", "Unit is moving in!", "npc/metropolice/vo/ismovingin.wav")
impulse.Voice.Register("metrocop", "IS PASSIVE", "Is passive.", "npc/metropolice/vo/ispassive.wav")
impulse.Voice.Register("metrocop", "IS READY TO GO", "Is ready to go!", "npc/metropolice/vo/isreadytogo.wav")
impulse.Voice.Register("metrocop", "ISOLATE", "Isolate!", "npc/metropolice/vo/isolate.wav")
impulse.Voice.Register("metrocop", "JET", "Jet.", "npc/combine_soldier/vo/jet.wav")
impulse.Voice.Register("metrocop", "JUDGE", "Judge.", "npc/combine_soldier/vo/judge.wav")
impulse.Voice.Register("metrocop", "JUDGMENT", "Suspect, prepare to receive civil judgment!", "npc/metropolice/vo/prepareforjudgement.wav")
impulse.Voice.Register("metrocop", "JURISDICTION", "Stabilization-jurisdiction.", "npc/metropolice/vo/stabilizationjurisdiction.wav")
impulse.Voice.Register("metrocop", "JURY", "Jury!", "npc/metropolice/vo/jury.wav")
impulse.Voice.Register("metrocop", "KEEP MOVING", "Keep moving!", "npc/metropolice/vo/keepmoving.wav")
impulse.Voice.Register("metrocop", "KILO", "Kilo.", "npc/combine_soldier/vo/kilo.wav")
impulse.Voice.Register("metrocop", "KING", "King!", "npc/metropolice/vo/king.wav")
impulse.Voice.Register("metrocop", "LAST SEEN AT", "Hiding, last seen at range...", "npc/metropolice/vo/hidinglastseenatrange.wav")
impulse.Voice.Register("metrocop", "LEADER", "Leader.", "npc/combine_soldier/vo/leader.wav")
impulse.Voice.Register("metrocop", "LEVEL 3", "I have a level three civil-privacy violator here!", "npc/metropolice/vo/level3civilprivacyviolator.wav")
impulse.Voice.Register("metrocop", "LINE", "Line!", "npc/metropolice/vo/line.wav")
impulse.Voice.Register("metrocop", "LOCATION", "Location?", "npc/metropolice/vo/location.wav")
impulse.Voice.Register("metrocop", "LOCK POSITION", "All units, lock your position!", "npc/metropolice/vo/lockyourposition.wav")
impulse.Voice.Register("metrocop", "LOCK", "Lock!", "npc/metropolice/vo/lock.wav")
impulse.Voice.Register("metrocop", "LOOK OUT", "Look out!", "npc/metropolice/vo/lookout.wav")
impulse.Voice.Register("metrocop", "LOOK", "Look!", "npc/metropolice/pointer03.wav")
impulse.Voice.Register("metrocop", "LOOSE PARASITICS", "Loose parasitics!", "npc/metropolice/vo/looseparasitics.wav")
impulse.Voice.Register("metrocop", "LOST CONTACT", "Lost contact!", "npc/combine_soldier/vo/lostcontact.wav")
impulse.Voice.Register("metrocop", "LOW ON", "Running low on verdicts, taking cover!", "npc/metropolice/vo/runninglowonverdicts.wav")
impulse.Voice.Register("metrocop", "MACE", "Mace.", "npc/combine_soldier/vo/mace.wav")
impulse.Voice.Register("metrocop", "MAINTAIN CP", "All units, maintain this CP!", "npc/metropolice/vo/allunitsmaintainthiscp.wav")
impulse.Voice.Register("metrocop", "MALCOMPLIANCE", "Issuing malcompliance citation.", "npc/metropolice/vo/issuingmalcompliantcitation.wav")
impulse.Voice.Register("metrocop", "MALCOMPLIANT 10-107", "Malcompliant 10-107 at my 10-20, preparing to prosecute.", "npc/metropolice/vo/malcompliant10107my1020.wav")
impulse.Voice.Register("metrocop", "MALIGNANT", "Malignant!", "npc/metropolice/vo/malignant.wav")
impulse.Voice.Register("metrocop", "MATCH ON APB", "I have a match on APB likeness.", "npc/metropolice/vo/matchonapblikeness.wav")
impulse.Voice.Register("metrocop", "METERS", "Meters", "npc/combine_soldier/vo/meters.wav")
impulse.Voice.Register("metrocop", "MIGHT BE", "Might be.", "npc/metropolice/mc1ans_mightbe.wav")
impulse.Voice.Register("metrocop", "MIGHT COULD", "Might could.", "npc/metropolice/mc1ans_mightcould.wav")
impulse.Voice.Register("metrocop", "MIGHT NOT", "Might not.", "npc/metropolice/mc1ans_mightnot.wav")
impulse.Voice.Register("metrocop", "MINOR HITS", "Minor hits, continuing prosecution!", "npc/metropolice/vo/minorhitscontinuing.wav")
impulse.Voice.Register("metrocop", "MOVE ALONG", "Move along!", "npc/metropolice/vo/movealong.wav")
impulse.Voice.Register("metrocop", "MOVE BACK", "Move back, right now!", "npc/metropolice/vo/movebackrightnow.wav")
impulse.Voice.Register("metrocop", "MOVE IN", "Move in!", "npc/combine_soldier/vo/movein.wav")
impulse.Voice.Register("metrocop", "MOVE IT", "Move it!", "npc/metropolice/vo/moveit.wav")
impulse.Voice.Register("metrocop", "MOVE", "Move!", "npc/metropolice/vo/move.wav")
impulse.Voice.Register("metrocop", "MOVING TO COVER", "Moving to cover!", "npc/metropolice/vo/movingtocover.wav")
impulse.Voice.Register("metrocop", "MOVING TO HARDPOINT", "Moving to hardpoint!", "npc/metropolice/vo/movingtohardpoint.wav")
impulse.Voice.Register("metrocop", "NECROTICS", "Necrotics!", "npc/metropolice/vo/necrotics.wav")
impulse.Voice.Register("metrocop", "NEED ANY HELP", "Need any help with this one?", "npc/metropolice/vo/needanyhelpwiththisone.wav")
impulse.Voice.Register("metrocop", "NEEDS ASSISTANCE", "Officer needs assistance, I am 11-99!", "npc/metropolice/vo/officerneedsassistance.wav")
impulse.Voice.Register("metrocop", "NEEDS HELP", "Officer needs help!", "npc/metropolice/vo/officerneedshelp.wav")
impulse.Voice.Register("metrocop", "NO 647", "Clear, no 647, no 10-107.", "npc/metropolice/vo/clearno647no10-107.wav")
impulse.Voice.Register("metrocop", "NO CHANCE ESCAPE", "You have no chance of escape!", "npc/metropolice/hiding03.wav")
impulse.Voice.Register("metrocop", "NO CONTACT", "No contact!", "npc/metropolice/vo/nocontact.wav")
impulse.Voice.Register("metrocop", "NO I'M GOOD", "No, I'm good.", "vo/trainyard/ba_noimgood.wav")
impulse.Voice.Register("metrocop", "NO IM GOOD", "No, I'm good.", "vo/trainyard/ba_noimgood.wav")
impulse.Voice.Register("metrocop", "NO POINT HIDING", "There's no point in hiding!", "npc/metropolice/hiding02.wav")
impulse.Voice.Register("metrocop", "NO VISUAL ON", "No visual on UPI at this time.", "npc/metropolice/vo/novisualonupi.wav")
impulse.Voice.Register("metrocop", "NOMAD", "Nomad.", "npc/combine_soldier/vo/nomad.wav")
impulse.Voice.Register("metrocop", "NONCITIZEN", "Noncitizen.", "npc/metropolice/vo/noncitizen.wav")
impulse.Voice.Register("metrocop", "NONPATROL", "Non-patrol region.", "npc/metropolice/vo/nonpatrolregion.wav")
impulse.Voice.Register("metrocop", "NONTAGGED VIROMES", "Non-tagged viromes here!", "npc/metropolice/vo/non-taggedviromeshere.wav")
impulse.Voice.Register("metrocop", "NOPE", "Nope.", "npc/metropolice/mc1ans_nope.wav")
impulse.Voice.Register("metrocop", "NOPE", "Nope.", "npc/metropolice/mc1ans_nope.wav")
impulse.Voice.Register("metrocop", "NOVA", "Nova.", "npc/combine_soldier/vo/nova.wav")
impulse.Voice.Register("metrocop", "NOW GET OUT", "Now, get out of here!", "npc/metropolice/vo/nowgetoutofhere.wav")
impulse.Voice.Register("metrocop", "NOW", "Now.", "vo/trainyard/ba_thatbeer01.wav")
impulse.Voice.Register("metrocop", "ONE CONTAINED", "One contained!", "npc/combine_soldier/vo/onecontained.wav")
impulse.Voice.Register("metrocop", "ONE DOWN", "One down!", "npc/combine_soldier/vo/onedown.wav")
impulse.Voice.Register("metrocop", "OUTBREAK", "Outbreak!", "npc/combine_soldier/vo/outbreak.wav")
impulse.Voice.Register("metrocop", "OUTLAND BIOTIC", "We got an outland biotic in here!", "npc/metropolice/vo/outlandbioticinhere.wav")
impulse.Voice.Register("metrocop", "OUTLAND ZONE", "Outland zone.", "npc/metropolice/vo/outlandzone.wav")
impulse.Voice.Register("metrocop", "OVERWATCH", "Overwatch.", "npc/combine_soldier/vo/overwatch.wav")
impulse.Voice.Register("metrocop", "PACIFYING", "Pacifying!", "npc/metropolice/vo/pacifying.wav")
impulse.Voice.Register("metrocop", "PAIN1", "Ugh!", "npc/metropolice/pain1.wav")
impulse.Voice.Register("metrocop", "PAIN2", "Uagh!", "npc/metropolice/pain2.wav")
impulse.Voice.Register("metrocop", "PAIN3", "Augh!", "npc/metropolice/pain3.wav")
impulse.Voice.Register("metrocop", "PAIN4", "Agh!", "npc/metropolice/pain4.wav")
impulse.Voice.Register("metrocop", "PATROL", "Patrol!", "npc/metropolice/vo/patrol.wav")
impulse.Voice.Register("metrocop", "PAY CUT", "You wanna bet we'll get a paycut?", "npc/metropolice/mc1que_paycut.wav")
impulse.Voice.Register("metrocop", "PAYBACK", "Payback.", "npc/combine_soldier/vo/payback.wav")
impulse.Voice.Register("metrocop", "PEOPLE SUCK", "People suck. Well, except for us I mean.", "npc/metropolice/mc1que_peoplesuck.wav")
impulse.Voice.Register("metrocop", "PHANTOM", "Phantom.", "npc/combine_soldier/vo/phantom.wav")
impulse.Voice.Register("metrocop", "PICKUP 647E", "Anyone else pick up a, uh... 647-E reading?", "npc/metropolice/vo/anyonepickup647e.wav")
impulse.Voice.Register("metrocop", "POSITION AT HARDPOINT", "In position at hardpoint.", "npc/metropolice/vo/inpositionathardpoint.wav")
impulse.Voice.Register("metrocop", "POSITION TO CONTAIN", "Position to contain.", "npc/metropolice/vo/positiontocontain.wav")
impulse.Voice.Register("metrocop", "POSSIBLE 404", "Possible 404 here!", "npc/metropolice/vo/possible404here.wav")
impulse.Voice.Register("metrocop", "POSSIBLE 647E", "Possible 647-E here, request AirWatch tag.", "npc/metropolice/vo/possible647erequestairwatch.wav")
impulse.Voice.Register("metrocop", "POSSIBLE ACCOMPLICE", "Report sightings of possible accomplice.", "npc/metropolice/vo/reportsightingsaccomplices.wav")
impulse.Voice.Register("metrocop", "POSSIBLE LEVEL 3", "Possible level three civil-privacy violator here!", "npc/metropolice/vo/possiblelevel3civilprivacyviolator.wav")
impulse.Voice.Register("metrocop", "PREPARING TO JUDGE", "Preparing to judge a 10-107, be advised.", "npc/metropolice/vo/preparingtojudge10-107.wav")
impulse.Voice.Register("metrocop", "PRESERVE", "Preserve!", "npc/metropolice/vo/preserve.wav")
impulse.Voice.Register("metrocop", "PRESSURE", "Pressure!", "npc/metropolice/vo/pressure.wav")
impulse.Voice.Register("metrocop", "PRIORITY 1", "Confirm, priority-one sighted.", "npc/metropolice/vo/confirmpriority1sighted.wav")
impulse.Voice.Register("metrocop", "PRIORITY 2", "I have a priority-two anti-citizen here!", "npc/metropolice/vo/priority2anticitizenhere.wav")
impulse.Voice.Register("metrocop", "PRODUCTION BLOCK", "Production-block.", "npc/metropolice/vo/productionblock.wav")
impulse.Voice.Register("metrocop", "PROSECUTE MALCOMPLIANT", "Ready to prosecute malcompliant citizen, final warning issued!","npc/metropolice/vo/readytoprosecutefinalwarning.wav")
impulse.Voice.Register("metrocop", "PROSECUTE", "Prosecute!", "npc/metropolice/vo/prosecute.wav")
impulse.Voice.Register("metrocop", "PROSECUTING", "Prosecuting.", "npc/combine_soldier/vo/procecuting.")
impulse.Voice.Register("metrocop", "PROTECTION COMPLETE", "Protection complete.", "npc/metropolice/vo/protectioncomplete.wav")
impulse.Voice.Register("metrocop", "QUICK", "Quick!", "npc/metropolice/vo/quick.wav")
impulse.Voice.Register("metrocop", "QUICKSAND", "Quicksand.", "npc/combine_soldier/vo/quicksand.wav")
impulse.Voice.Register("metrocop", "QUIT BELLYACHING", "Quit your bellyaching.", "npc/metropolice/mc1ans_bellyaching.wav")
impulse.Voice.Register("metrocop", "RANGE", "Range.", "npc/combine_soldier/vo/range.wav")
impulse.Voice.Register("metrocop", "RANGER", "Ranger.", "npc/combine_soldier/vo/ranger.wav")
impulse.Voice.Register("metrocop", "RATHER NOT THINK", "I'd rather not think about that.", "npc/metropolice/mc1ans_rathernotthink.wav")
impulse.Voice.Register("metrocop", "RAZOR", "Razor.", "npc/combine_soldier/vo/razor.wav")
impulse.Voice.Register("metrocop", "READY AMPUTATE", "Ready to amputate!", "npc/metropolice/vo/readytoamputate.wav")
impulse.Voice.Register("metrocop", "READY JUDGE", "Ready to judge.", "npc/metropolice/vo/readytojudge.wav")
impulse.Voice.Register("metrocop", "READY PROSECUTE", "Ready to prosecute!", "npc/metropolice/vo/readytoprosecute.wav")
impulse.Voice.Register("metrocop", "READY WEAPONS", "Ready weapons!", "npc/combine_soldier/vo/readyweapons.wav")
impulse.Voice.Register("metrocop", "REAPER", "Reaper.", "npc/combine_soldier/vo/reaper.wav")
impulse.Voice.Register("metrocop", "REINFORCEMENT TEAMS", "Reinforcement-teams, code three!", "npc/metropolice/vo/reinforcementteamscode3.wav")
impulse.Voice.Register("metrocop", "REPORT CLEAR", "Reporting clear.", "npc/combine_soldier/vo/reportingclear.wav")
impulse.Voice.Register("metrocop", "REPORT IN", "CP requests all units, uhh... Location report-in.", "npc/metropolice/vo/cprequestsallunitsreportin.wav")
impulse.Voice.Register("metrocop", "REPORT LOCATION", "All units, report location suspect!", "npc/metropolice/vo/allunitsreportlocationsuspect.wav")
impulse.Voice.Register("metrocop", "REPORT STATUS", "Local CP-teams, report status.", "npc/metropolice/vo/localcptreportstatus.wav")
impulse.Voice.Register("metrocop", "REPURPOSED", "Repurposed area.", "npc/metropolice/vo/repurposedarea.wav")
impulse.Voice.Register("metrocop", "REQUEST MEDICAL", "Request medical.", "npc/combine_soldier/vo/requestmedical.wav")
impulse.Voice.Register("metrocop", "REQUEST STIM", "Request stim dose.", "npc/combine_soldier/vo/requeststimdose.wav")
impulse.Voice.Register("metrocop", "RESIDENTIAL BLOCK", "Residential block.", "npc/metropolice/vo/residentialblock.wav")
impulse.Voice.Register("metrocop", "RESPOND CODE 3", "All units at location, responding code three!", "npc/metropolice/vo/allunitsrespondcode3.wav")
impulse.Voice.Register("metrocop", "RESPONDING", "Responding.", "npc/metropolice/vo/responding2.wav")
impulse.Voice.Register("metrocop", "RESTRICT", "Restrict!", "npc/metropolice/vo/restrict.wav")
impulse.Voice.Register("metrocop", "RESTRICTED", "Restricted block.", "npc/metropolice/vo/restrictedblock.wav")
impulse.Voice.Register("metrocop", "RESTRICTION ZONE", "Terminal restriction-zone!", "npc/metropolice/vo/terminalrestrictionzone.wav")
impulse.Voice.Register("metrocop", "RIDICULOUS", "Don't be ridiculous.", "npc/metropolice/mc1ans_dontberidic.wav")
impulse.Voice.Register("metrocop", "ROGER THAT", "Roger that!", "npc/metropolice/vo/rodgerthat.wav")
impulse.Voice.Register("metrocop", "ROLLER", "Roller!", "npc/metropolice/vo/roller.wav")
impulse.Voice.Register("metrocop", "RUNNING", "He's running!", "npc/metropolice/vo/hesrunning.wav")
impulse.Voice.Register("metrocop", "SACRIFICE CODE", "All units, sacrifice code one and maintain this CP!", "npc/metropolice/vo/sacrificecode1maintaincp.wav")
impulse.Voice.Register("metrocop", "SAVAGE", "Savage.", "npc/combine_soldier/vo/savage.wav")
impulse.Voice.Register("metrocop", "SCAR", "Scar.", "npc/combine_soldier/vo/scar.wav")
impulse.Voice.Register("metrocop", "SEARCH", "Search!", "npc/metropolice/vo/search.wav")
impulse.Voice.Register("metrocop", "SEARCHING FOR SUSPECT", "Searching for suspect.", "npc/metropolice/vo/searchingforsuspect.wav")
impulse.Voice.Register("metrocop", "SECOND WARNING", "This is your second warning!", "npc/metropolice/vo/thisisyoursecondwarning.wav")
impulse.Voice.Register("metrocop", "SECTOR NOT SECURE", "Sector is not secure.", "npc/combine_soldier/vo/sectorisnotsecure.wav")
impulse.Voice.Register("metrocop", "SECTOR NOT STERILE", "Confirmed- sector not sterile.", "npc/combine_soldier/vo/confirmsectornotsterile.wav")
impulse.Voice.Register("metrocop", "SECTOR OVERRUN", "Overwatch, sector overrun. Repeat, sector overrun.", "npc/combine_soldier/vo/overwatchsectoroverrun.wav")
impulse.Voice.Register("metrocop", "SECTOR", "Sector", "npc/combine_soldier/vo/sector.wav")
impulse.Voice.Register("metrocop", "SECURE ADVANCE", "Assault-point secured, advance!", "npc/metropolice/vo/assaultpointsecureadvance.wav")
impulse.Voice.Register("metrocop", "SECURE", "Secure.", "npc/combine_soldier/vo/secure.wav")
impulse.Voice.Register("metrocop", "SENTENCE", "Sentence delivered.", "npc/metropolice/vo/sentencedelivered.wav")
impulse.Voice.Register("metrocop", "SERVE", "Serve.", "npc/metropolice/vo/serve.wav")
impulse.Voice.Register("metrocop", "SHADOW", "Shadow.", "npc/combine_soldier/vo/shadow.wav")
impulse.Voice.Register("metrocop", "SHARPZONE", "Sharpzone.", "npc/combine_soldier/vo/sharpzone.wav")
impulse.Voice.Register("metrocop", "SHIT", "Shit!", "npc/metropolice/vo/shit.wav")
impulse.Voice.Register("metrocop", "SHOTS FIRED", "Shots fired, hostile malignants here!", "npc/metropolice/vo/shotsfiredhostilemalignants.wav")
impulse.Voice.Register("metrocop", "SHUT UP", "Shut up about that.", "npc/metropolice/mc1ans_shutup.wav")
impulse.Voice.Register("metrocop", "SLAM", "Slam.", "npc/combine_soldier/vo/slam.wav")
impulse.Voice.Register("metrocop", "SLASH", "Slash.", "npc/combine_soldier/vo/slash.wav")
impulse.Voice.Register("metrocop", "SOCIOCIDE", "Sociocide.", "npc/metropolice/vo/sociocide.wav")
impulse.Voice.Register("metrocop", "SOCIOSTABLE", "We are socio-stable at this location.", "npc/metropolice/vo/wearesociostablethislocation.wav")
impulse.Voice.Register("metrocop", "SPEAR", "Spear.", "npc/combine_soldier/vo/spear.wav")
impulse.Voice.Register("metrocop", "STAB", "Stab.", "npc/combine_soldier/vo/stab.wav")
impulse.Voice.Register("metrocop", "STANDING BY", "Standing by.", "npc/combine_soldier/vo/standingby].wav")
impulse.Voice.Register("metrocop", "STAR", "Star.", "npc/combine_soldier/vo/star.wav")
impulse.Voice.Register("metrocop", "STATIONBLOCK", "Stationblock.", "npc/metropolice/vo/stationblock.wav")
impulse.Voice.Register("metrocop", "STAY ALERT", "Stay alert.", "npc/combine_soldier/vo/stayalert.wav")
impulse.Voice.Register("metrocop", "STERILIZE", "Sterilize!", "npc/metropolice/vo/sterilize.wav")
impulse.Voice.Register("metrocop", "STINGER", "Stinger.", "npc/combine_soldier/vo/stinger.wav")
impulse.Voice.Register("metrocop", "STOMACH KILLING ME", "My stomach is killing me.", "npc/metropolice/mc1que_stomach.wav")
impulse.Voice.Register("metrocop", "STOP WHINING", "Stop whining.", "npc/metropolice/mc1ans_stopwhining.wav")
impulse.Voice.Register("metrocop", "STORM", "Storm.", "npc/combine_soldier/vo/storm.wav")
impulse.Voice.Register("metrocop", "STRIKE", "Striker.", "npc/combine_soldier/vo/striker.wav")
impulse.Voice.Register("metrocop", "SUBJECT 505", "Subject is 505!", "npc/metropolice/vo/subjectis505.wav")
impulse.Voice.Register("metrocop", "SUBJECT HIGH SPEED", "All units, be advised, subject is now high-speed!", "npc/metropolice/vo/subjectisnowhighspeed.wav")
impulse.Voice.Register("metrocop", "SUBJECT HIGH SPEED", "All units, be advised, subject is now high-speed!", "npc/metropolice/vo/subjectisnowhighspeed.wav")
impulse.Voice.Register("metrocop", "SUBJECT", "Subject!", "npc/metropolice/vo/subject.wav")
impulse.Voice.Register("metrocop", "SUNDOWN", "Sundown.", "npc/combine_soldier/vo/sundown.wav")
impulse.Voice.Register("metrocop", "SUSPECT INCURSION", "Disp reports suspect-incursion at location.", "npc/metropolice/vo/dispreportssuspectincursion.wav")
impulse.Voice.Register("metrocop", "SUSPECT MOVED TO", "Suspect has moved now to...", "npc/metropolice/vo/supsecthasnowmovedto.wav")
impulse.Voice.Register("metrocop", "SUSPECT RESTRICTED CANALS", "Suspect is using restricted canals at...", "npc/metropolice/vo/suspectusingrestrictedcanals.wav")
impulse.Voice.Register("metrocop", "SUSPEND", "Suspend!", "npc/metropolice/vo/suspend.wav")
impulse.Voice.Register("metrocop", "SWEEPER", "Sweeper.", "npc/combine_soldier/vo/sweeper.wav")
impulse.Voice.Register("metrocop", "SWEEPING IN", "Sweeping in!", "npc/combine_soldier/vo/sweepingin.wav")
impulse.Voice.Register("metrocop", "SWEEPING SUSPECT", "Sweeping for suspect!", "npc/metropolice/vo/sweepingforsuspect.wav")
impulse.Voice.Register("metrocop", "SWIFT", "Swift.", "npc/combine_soldier/vo/swift.wav")
impulse.Voice.Register("metrocop", "SWORD", "Sword.", "npc/combine_soldier/vo/sword.wav")
impulse.Voice.Register("metrocop", "TAG 10-91D", "Tag 10-91d!", "npc/metropolice/vo/tag10-91d.wav")
impulse.Voice.Register("metrocop", "TAG BUG", "Tag one bug!", "npc/metropolice/vo/tagonebug.wav")
impulse.Voice.Register("metrocop", "TAG NECROTIC", "Tag one necrotic!", "npc/metropolice/vo/tagonenecrotic.wav")
impulse.Voice.Register("metrocop", "TAG PARASITIC", "Tag one parasitic!", "npc/metropolice/vo/tagoneparasitic.wav")
impulse.Voice.Register("metrocop", "TAKE A LOOK", "Going to take a look!", "npc/metropolice/vo/goingtotakealook.wav")
impulse.Voice.Register("metrocop", "TAKE COVER", "Take cover!", "npc/metropolice/vo/takecover.wav")
impulse.Voice.Register("metrocop", "TAKE HIM DOWN", "Take him down!", "npc/metropolice/takedown.wav")
impulse.Voice.Register("metrocop", "TAP", "Tap!", "npc/metropolice/vo/tap.wav")
impulse.Voice.Register("metrocop", "TARGET IS AT", "Target is at", "npc/combine_soldier/vo/targetisat.wav")
impulse.Voice.Register("metrocop", "TARGET", "Target.", "npc/combine_soldier/vo/target.wav")
impulse.Voice.Register("metrocop", "TEAM ADVANCE", "Team in position, advance!.", "npc/metropolice/vo/teaminpositionadvance.wav")
impulse.Voice.Register("metrocop", "THAT'S A GRENADE", "That's a grenade!", "npc/metropolice/vo/thatsagrenade.wav")
impulse.Voice.Register("metrocop", "THERE HE GOES", "There he goes! He's at...", "npc/metropolice/vo/therehegoeshesat.wav")
impulse.Voice.Register("metrocop", "THERE HE IS", "There he is!", "npc/metropolice/vo/thereheis.wav")
impulse.Voice.Register("metrocop", "THERES YOUR PROBLEM", "There's your problem right there.", "npc/metropolice/mc1ans_theresyerproblem.wav")
impulse.Voice.Register("metrocop", "THINK ABOUT THAT", "Ehhh... let me think about that.", "npc/metropolice/mc1ans_letmethink.wav")
impulse.Voice.Register("metrocop", "THINK SO", "Think so.", "npc/metropolice/mc1ans_thinkso.wav")
impulse.Voice.Register("metrocop", "THIS IS RIDICULOUS", "This is ridiculous.", "npc/metropolice/mc1que_thisridiculous.wav")
impulse.Voice.Register("metrocop", "THOUGHT OF SOMETHING", "I just thought of something. Ehh... wait. Maybe not.", "npc/metropolice/mc1que_justthought.wav")
impulse.Voice.Register("metrocop", "TRACKER", "Tracker.", "npc/combine_soldier/vo/tracker.wav")
impulse.Voice.Register("metrocop", "TRANSITBLOCK", "Transit-block.", "npc/metropolice/vo/transitblock.wav")
impulse.Voice.Register("metrocop", "TROUBLE", "Lookin' for trouble?", "npc/metropolice/vo/lookingfortrouble.wav")
impulse.Voice.Register("metrocop", "UNDER FIRE", "Officer under fire, taking cover!", "npc/metropolice/vo/officerunderfiretakingcover.wav")
impulse.Voice.Register("metrocop", "UNIFORM", "Uniform.", "npc/combine_soldier/vo/uniform.wav")
impulse.Voice.Register("metrocop", "UNION", "Union!", "npc/metropolice/vo/union.wav")
impulse.Voice.Register("metrocop", "UNKNOWN", "Suspect location unknown.", "npc/metropolice/vo/suspectlocationunknown.wav")
impulse.Voice.Register("metrocop", "UP THERE", "He's up there!", "npc/metropolice/vo/hesupthere.wav")
impulse.Voice.Register("metrocop", "UPI", "UPI.", "npc/metropolice/vo/upi.wav")
impulse.Voice.Register("metrocop", "UTL SUSPECT", "UTL that suspect.", "npc/metropolice/vo/utlthatsuspect.wav")
impulse.Voice.Register("metrocop", "UTL", "UTL suspect.", "npc/metropolice/vo/utlsuspect.wav")
impulse.Voice.Register("metrocop", "VACATE", "Vacate, citizen!", "npc/metropolice/vo/vacatecitizen.wav")
impulse.Voice.Register("metrocop", "VAMP", "Vamp.", "npc/combine_soldier/vo/vamp.wav")
impulse.Voice.Register("metrocop", "VERDICT", "You want a malcompliance verdict?", "npc/metropolice/vo/youwantamalcomplianceverdict.wav")
impulse.Voice.Register("metrocop", "VICE", "Vice!", "npc/metropolice/vo/vice.wav")
impulse.Voice.Register("metrocop", "VICTOR", "Victor!", "npc/metropolice/vo/victor.wav")
impulse.Voice.Register("metrocop", "VISCON", "Viscon.", "npc/combine_soldier/vo/viscon.wav")
impulse.Voice.Register("metrocop", "VISUAL EXOGEN", "Visual on exogen.", "npc/combine_soldier/vo/visualonexogen.wav")
impulse.Voice.Register("metrocop", "WARNING GIVEN", "Second warning given!", "npc/metropolice/vo/secondwarning.wav")
impulse.Voice.Register("metrocop", "WASTERIVER", "Wasteriver.", "npc/metropolice/vo/wasteriver.wav")
impulse.Voice.Register("metrocop", "WATCH IT", "Watch it!", "npc/metropolice/vo/watchit.wav")
impulse.Voice.Register("metrocop", "WATCH YOUR MOUTH", "Watch your mouth.", "npc/metropolice/mc1ans_watchyermouth.wav")
impulse.Voice.Register("metrocop", "WE GOT HIM", "Affirmative, we got him now.", "npc/combine_soldier/vo/affirmativewegothimnow.wav")
impulse.Voice.Register("metrocop", "WHAT THE HELL", "What the hell?", "npc/metropolice/surprise4.wav")
impulse.Voice.Register("metrocop", "WHAT THE", "What the?", "npc/metropolice/surprise1.wav")
impulse.Voice.Register("metrocop", "WINDER", "Winder.", "npc/combine_soldier/vo/winder.wav")
impulse.Voice.Register("metrocop", "WORKFORCE", "Workforce intake.", "npc/metropolice/vo/workforceintake.wav")
impulse.Voice.Register("metrocop", "WRAP IT UP", "That's it, wrap it up.", "npc/combine_soldier/vo/thatsitwrapitup.wav")
impulse.Voice.Register("metrocop", "XRAY", "XRay!", "npc/metropolice/vo/xray.wav")
impulse.Voice.Register("metrocop", "YEAH", "Yeah.", "npc/metropolice/mc1ans_yeah.wav")
impulse.Voice.Register("metrocop", "YELLOW", "Yellow!", "npc/metropolice/vo/yellow.wav")
impulse.Voice.Register("metrocop", "YEP", "Yep.", "npc/metropolice/mc1ans_yep.wav")
impulse.Voice.Register("metrocop", "YOU BELIEVE THAT", "You really believe that?", "npc/metropolice/mc1ans_youreallybelieve.wav")
impulse.Voice.Register("metrocop", "YOU CAN GO", "Alright, you can go.", "npc/metropolice/vo/allrightyoucango.wav")
impulse.Voice.Register("metrocop", "YOUR WIFE", "Your wife doesn't like me, does she?", "npc/metropolice/mc1que_yourwife.wav")
impulse.Voice.Register("metrocop", "ZONE", "Zone!", "npc/metropolice/vo/zone.wav")
impulse.Voice.Register("metrocop", "GET AGAINST THE WALL", "Get against the wall!", "vo/trainyard/ba_againstwall.wav")
impulse.Voice.Register("metrocop", "GET AWAY FROM THERE", "Get away from there!", "vo/trainyard/ba_awayfrom.wav")
impulse.Voice.Register("metrocop", "BACK OFF", "Back off!", "vo/trainyard/ba_backoff.wav")
impulse.Voice.Register("metrocop", "GET UP THERE", "Get up there!", "vo/trainyard/ba_getupthere.wav")
impulse.Voice.Register("metrocop", "GO ON UP", "Go on up.", "vo/trainyard/ba_goonup.wav")
impulse.Voice.Register("metrocop", "IN HERE", "In here, let's go.", "vo/trainyard/ba_inhere.wav")
impulse.Voice.Register("metrocop", "MOVE", "Move.", "vo/trainyard/ba_move.wav")
impulse.Voice.Register("metrocop", "NOT IN THERE", "Not in there", "vo/trainyard/ba_notthere.wav")
impulse.Voice.Register("metrocop", "OUT OF THE WAY", "Out of the way!", "vo/trainyard/ba_outofway.wav")
impulse.Voice.Register("metrocop", "OVER HERE", "Over here.", "vo/trainyard/ba_overhere.wav")
impulse.Voice.Register("metrocop", "YEAH THATS IT", "Yeah, that's it.", "vo/trainyard/ba_thatsit.wav")
impulse.Voice.Register("metrocop", "CANT COMPLY", "Can't comply.", "vo/metro_police/cantcomply.wav")
impulse.Voice.Register("metrocop", "RETURN TO YOUR HOUSING BLOCK", "Return to your housing block, now.", "vo/metro_police/housingblock.wav")
impulse.Voice.Register("metrocop", "GET ON THE WALL", "Get on the wall.", "vo/metro_police/onthewall1.wav")
impulse.Voice.Register("metrocop", "I SAID GET ON THE WALL", "I said get on the wall.", "vo/metro_police/onthewall2.wav")
impulse.Voice.Register("metrocop", "NO CAN DO", "Uhh, no can do.", "vo/metro_police/uhhnocando.wav")

impulse.Voice.Register("overwatch", "0", "Zero", "npc/combine_soldier/vo/zero.wav")
impulse.Voice.Register("overwatch", "1", "One", "npc/combine_soldier/vo/one.wav")
impulse.Voice.Register("overwatch", "10", "Ten", "npc/combine_soldier/vo/ten.wav")
impulse.Voice.Register("overwatch", "11", "Eleven", "npc/combine_soldier/vo/eleven.wav")
impulse.Voice.Register("overwatch", "100", "One-hundred.", "npc/combine_soldier/vo/onehundred.wav")
impulse.Voice.Register("overwatch", "2", "Two", "npc/combine_soldier/vo/two.wav")
impulse.Voice.Register("overwatch", "12", "Twelve", "npc/combine_soldier/vo/twelve.wav")
impulse.Voice.Register("overwatch", "20", "Twenty", "npc/combine_soldier/vo/twenty.wav")
impulse.Voice.Register("overwatch", "200", "Two-hundred.", "npc/combine_soldier/vo/twohundred.wav")
impulse.Voice.Register("overwatch", "3", "Three", "npc/combine_soldier/vo/three.wav")
impulse.Voice.Register("overwatch", "13", "Thirteen", "npc/combine_soldier/vo/thirteen.wav")
impulse.Voice.Register("overwatch", "30", "Thirty", "npc/combine_soldier/vo/thirty.wav")
impulse.Voice.Register("overwatch", "300", "Three-hundred.", "npc/combine_soldier/vo/threehundred.wav")
impulse.Voice.Register("overwatch", "4", "Four", "npc/combine_soldier/vo/four.wav")
impulse.Voice.Register("overwatch", "14", "Fourteen", "npc/combine_soldier/vo/fourteen.wav")
impulse.Voice.Register("overwatch", "40", "Fourty", "npc/combine_soldier/vo/fourty.wav")
impulse.Voice.Register("overwatch", "404", "404 zone.", "npc/combine_soldier/vo/404zone.wav")
impulse.Voice.Register("overwatch", "5", "Five", "npc/combine_soldier/vo/five.wav")
impulse.Voice.Register("overwatch", "15", "Fifteen", "npc/combine_soldier/vo/fifteen.wav")
impulse.Voice.Register("overwatch", "50", "Fifty", "npc/combine_soldier/vo/fifty.wav")
impulse.Voice.Register("overwatch", "6", "Six", "npc/combine_soldier/vo/six.wav")
impulse.Voice.Register("overwatch", "16", "Sixteen", "npc/combine_soldier/vo/sixteen.wav")
impulse.Voice.Register("overwatch", "60", "Sixty", "npc/combine_soldier/vo/sixty.wav")
impulse.Voice.Register("overwatch", "63", "63, criminal trespass.", "npc/metropolice/vo/criminaltrespass63.wav")
impulse.Voice.Register("overwatch", "7", "Seven", "npc/combine_soldier/vo/seven.wav")
impulse.Voice.Register("overwatch", "17", "Seventeen", "npc/combine_soldier/vo/seventeen.wav")
impulse.Voice.Register("overwatch", "70", "Seventy", "npc/combine_soldier/vo/seventy.wav")
impulse.Voice.Register("overwatch", "8", "Eight", "npc/combine_soldier/vo/eight.wav")
impulse.Voice.Register("overwatch", "18", "Eighteen", "npc/combine_soldier/vo/eighteen.wav")
impulse.Voice.Register("overwatch", "80", "Eighty", "npc/combine_soldier/vo/eighty.wav")
impulse.Voice.Register("overwatch", "9", "Niner", "npc/combine_soldier/vo/niner.wav")
impulse.Voice.Register("overwatch", "19", "Nineteen", "npc/combine_soldier/vo/nineteen.wav")
impulse.Voice.Register("overwatch", "90", "Ninety", "npc/combine_soldier/vo/ninety.wav")
impulse.Voice.Register("overwatch", "ACQUIRING", "Acquiring on visual!", "npc/metropolice/vo/acquiringonvisual.wav")
impulse.Voice.Register("overwatch", "ADMINISTER", "Administer.", "npc/combine_soldier/vo/administer.wav")
impulse.Voice.Register("overwatch", "AFFIRMATIVE", "Affirmative.", {"npc/combine_soldier/vo/affirmative.wav", "npc/combine_soldier/vo/affirmative2.wav"})
impulse.Voice.Register("overwatch", "ALL POSITIONS CLEAR", "Report all positions clear.", "npc/combine_soldier/vo/reportallpositionsclear.wav")
impulse.Voice.Register("overwatch", "ALL RADIALS FREE", "Report all radials free.", "npc/combine_soldier/vo/reportallradialsfree.wav")
impulse.Voice.Register("overwatch", "ALL UNITS MOVE", "All units, move in!", "npc/metropolice/vo/allunitsmovein.wav")
impulse.Voice.Register("overwatch", "AMPUTATE", "Amputate.", "npc/metropolice/vo/amputate.wav")
impulse.Voice.Register("overwatch", "ANTICITIZEN ONE", "Anti-Citizen one.", "npc/combine_soldier/vo/anticitizenone.wav")
impulse.Voice.Register("overwatch", "ANTICITIZEN", "Anti-citizen.", "npc/metropolice/vo/anticitizen.wav")
impulse.Voice.Register("overwatch", "ANTISEPTIC", "Antiseptic.", "npc/combine_soldier/vo/antiseptic.wav")
impulse.Voice.Register("overwatch", "APEX", "Apex.", "npc/combine_soldier/vo/apex.wav")
impulse.Voice.Register("overwatch", "APPLY", "Apply.", "npc/metropolice/vo/apply.wav")
impulse.Voice.Register("overwatch", "BACK ME UP", "Back me up, I'm out!", "npc/metropolice/vo/backmeupImout.wav")
impulse.Voice.Register("overwatch", "BACKUP", "Backup!", "npc/metropolice/vo/backup.wav")
impulse.Voice.Register("overwatch", "BEARING", "Bearing", "npc/combine_soldier/vo/bearing.wav")
impulse.Voice.Register("overwatch", "BLADE", "Blade.", "npc/combine_soldier/vo/blade.wav")
impulse.Voice.Register("overwatch", "BLIP", "Catch that blip on the stabilization readout?", "npc/metropolice/vo/catchthatbliponstabilization.wav")
impulse.Voice.Register("overwatch", "BLOCK", "Block.", "npc/metropolice/vo/block.wav")
impulse.Voice.Register("overwatch", "BODYPACK HOLDING", "Bodypack holding!", "npc/combine_soldier/vo/bodypackholding.wav")
impulse.Voice.Register("overwatch", "BOUNCER", "Bouncer, bouncer!", "npc/combine_soldier/vo/bouncerbouncer.wav")
impulse.Voice.Register("overwatch", "BREAK COVER", "Break his cover!", "npc/metropolice/vo/breakhiscover.wav")
impulse.Voice.Register("overwatch", "CALL CONTACT PARASITICS", "Call contact parasitics.", "npc/combine_soldier/vo/callcontactparasitics.wav")
impulse.Voice.Register("overwatch", "CALL CONTACT", "Call contact target suspect one.", "npc/combine_soldier/vo/callcontacttarget1.wav")
impulse.Voice.Register("overwatch", "CANAL", "Canal.", "npc/metropolice/vo/canal.wav")
impulse.Voice.Register("overwatch", "CANALBLOCK", "Canalblock.", "npc/metropolice/vo/canalblock.wav")
impulse.Voice.Register("overwatch", "CAUTERIZE", "Cauterize.", "npc/metropolice/vo/cauterize.wav")
impulse.Voice.Register("overwatch", "CITIZEN", "Citizen.", "npc/metropolice/vo/citizen.wav")
impulse.Voice.Register("overwatch", "CLEANED", "Cleaned.", "npc/combine_soldier/vo/cleaned.wav")
impulse.Voice.Register("overwatch", "CLOSING", "Closing.", {"npc/combine_soldier/vo/closing.wav", "npc/combine_soldier/vo/closing2.wav"})
impulse.Voice.Register("overwatch", "CONDEMNED", "Condemned zone.", "npc/metropolice/vo/condemnedzone.wav")
impulse.Voice.Register("overwatch", "CONTACT CONFIRM PROSECUTING", "Contact confirm, prosecuting.", "npc/combine_soldier/vo/contactconfirmprosecuting.wav")
impulse.Voice.Register("overwatch", "CONTACT", "Contact.", "npc/combine_soldier/vo/contact.wav")
impulse.Voice.Register("overwatch", "CONTAINED", "Contained.", "npc/combine_soldier/vo/contained.wav")
impulse.Voice.Register("overwatch", "CONTAINMENT PROCEEDING", "Containment proceeding!", "npc/combine_soldier/vo/containmentproceeding.wav")
impulse.Voice.Register("overwatch", "CONTROLSECTION", "Control-section.", "npc/metropolice/vo/controlsection.wav")
impulse.Voice.Register("overwatch", "CONVERGING", "Converging.", "npc/metropolice/vo/converging.wav")
impulse.Voice.Register("overwatch", "COPY THAT", "Copy that.", "npc/combine_soldier/vo/copythat.wav")
impulse.Voice.Register("overwatch", "COPY", "Copy.", "npc/combine_soldier/vo/copy.wav")
impulse.Voice.Register("overwatch", "COVER ME", "Cover me.", "npc/combine_soldier/vo/coverme.wav")
impulse.Voice.Register("overwatch", "COVER", "Cover!", "npc/combine_soldier/vo/coverhurt.wav")
impulse.Voice.Register("overwatch", "DAGGER", "Dagger.", "npc/combine_soldier/vo/dagger.wav")
impulse.Voice.Register("overwatch", "DASH", "Dash.", "npc/combine_soldier/vo/dash.wav")
impulse.Voice.Register("overwatch", "DB COUNT", "DB count is...", "npc/metropolice/vo/dbcountis.wav")
impulse.Voice.Register("overwatch", "DEFENDER", "Defender.", "npc/metropolice/vo/defender.wav")
impulse.Voice.Register("overwatch", "DEGREES", "Degrees", "npc/combine_soldier/vo/degrees.wav")
impulse.Voice.Register("overwatch", "DESERVICED AREA", "Deserviced area.", "npc/metropolice/vo/deservicedarea.wav")
impulse.Voice.Register("overwatch", "DESTROY COVER", "Destroy that cover!", "npc/metropolice/vo/destroythatcover.wav")
impulse.Voice.Register("overwatch", "DISMOUNTING HARDPOINT", "Dismounting hardpoint.", "npc/metropolice/vo/dismountinghardpoint.wav")
impulse.Voice.Register("overwatch", "DISPLACE", "Displace!", "npc/combine_soldier/vo/displace.wav")
impulse.Voice.Register("overwatch", "DISTRIBUTION BLOCK", "Distribution block.", "npc/metropolice/vo/distributionblock.wav")
impulse.Voice.Register("overwatch", "DOCUMENT", "Document.", "npc/metropolice/vo/document.wav")
impulse.Voice.Register("overwatch", "DONT MOVE", "Don't move!", "npc/metropolice/vo/dontmove.wav")
impulse.Voice.Register("overwatch", "ECHO", "Echo.", "npc/combine_soldier/vo/echo.wav")
impulse.Voice.Register("overwatch", "ENGAGED IN", "engaged in cleanup.", "npc/combine_soldier/vo/engagedincleanup.wav")
impulse.Voice.Register("overwatch", "ENGAGING", "Engaging.", "npc/combine_soldier/vo/engaging.wav")
impulse.Voice.Register("overwatch", "EXPIRED", "Expired.", "npc/metropolice/vo/expired.wav")
impulse.Voice.Register("overwatch", "EXPOSE TARGET", "Firing to expose target.", "npc/metropolice/vo/firingtoexposetarget.wav")
impulse.Voice.Register("overwatch", "EXTERNAL", "External jurisdiction.", "npc/metropolice/vo/externaljurisdiction.wav")
impulse.Voice.Register("overwatch", "EXTRACTOR AWAY", "Extractor away!", "npc/combine_soldier/vo/extractoraway.wav")
impulse.Voice.Register("overwatch", "EXTRACTOR IS LIVE", "Extractor is live!", "npc/combine_soldier/vo/extractorislive.wav")
impulse.Voice.Register("overwatch", "FINAL TEAM UNIT", "Is final team unit, request backup.", "npc/combine_soldier/vo/isfinalteamunitbackup.wav")
impulse.Voice.Register("overwatch", "FINAL VERDICT", "Final verdict administered.", "npc/metropolice/vo/finalverdictadministered.wav")
impulse.Voice.Register("overwatch", "FINAL WARNING", "Final warning!", "npc/metropolice/vo/finalwarning.wav")
impulse.Voice.Register("overwatch", "FIRST WARNING", "First warning, move away.", "npc/metropolice/vo/firstwarningmove.wav")
impulse.Voice.Register("overwatch", "FIST", "Fist.", "npc/combine_soldier/vo/fist.wav")
impulse.Voice.Register("overwatch", "FIX SIGHTLINES", "Fix sightlines, move in.", "npc/combine_soldier/vo/fixsightlinesmovein.wav")
impulse.Voice.Register("overwatch", "FLARE DOWN", "Flare down!", "npc/combine_soldier/vo/flaredown.wav")
impulse.Voice.Register("overwatch", "FLASH", "Flash.", "npc/combine_soldier/vo/flash.wav")
impulse.Voice.Register("overwatch", "FLATLINE", "Flatline.", "npc/combine_soldier/vo/flatline.wav")
impulse.Voice.Register("overwatch", "FLUSH", "Flush.", "npc/combine_soldier/vo/flush.wav")
impulse.Voice.Register("overwatch", "FREE NECROTICS", "I have free necrotics.", "npc/metropolice/vo/freenecrotics.wav")
impulse.Voice.Register("overwatch", "FREE PARASITES", "We have free parasites.", "npc/combine_soldier/vo/wehavefreeparasites.wav")
impulse.Voice.Register("overwatch", "FULL ACTIVE", "Full active.", "npc/combine_soldier/vo/fullactive.wav")
impulse.Voice.Register("overwatch", "FULL RESPONSE", "Executing full response.", "npc/combine_soldier/vo/executingfullresponse.wav")
impulse.Voice.Register("overwatch", "GET DOWN", "Get down!", "npc/metropolice/vo/getdown.wav")
impulse.Voice.Register("overwatch", "GET OUT", "Get out of here.", "npc/metropolice/vo/getoutofhere.wav")
impulse.Voice.Register("overwatch", "GHOST", "Ghost.", "npc/combine_soldier/vo/ghost.wav")
impulse.Voice.Register("overwatch", "GO ACTIVE INTERCEPT", "Go active intercept.", "npc/combine_soldier/vo/goactiveintercept.wav")
impulse.Voice.Register("overwatch", "GO AGAIN", "PT, go again.", "npc/metropolice/vo/ptgoagain.wav")
impulse.Voice.Register("overwatch", "GO SHARP", "Go sharp!", "npc/combine_soldier/vo/gosharp.wav")
impulse.Voice.Register("overwatch", "GO SHARP2", "Go sharp, go sharp.", "npc/combine_soldier/vo/gosharpgosharp.wav")
impulse.Voice.Register("overwatch", "GOING IN", "Cover me, I'm going in!", "npc/metropolice/vo/covermegoingin.wav")
impulse.Voice.Register("overwatch", "GRENADE", "Grenade!", "npc/metropolice/vo/grenade.wav")
impulse.Voice.Register("overwatch", "GRID", "Grid.", "npc/combine_soldier/vo/grid.wav")
impulse.Voice.Register("overwatch", "HAHA", "Haha.", "npc/metropolice/vo/chuckle.wav")
impulse.Voice.Register("overwatch", "HAMMER", "Hammer.", "npc/combine_soldier/vo/hammer.wav")
impulse.Voice.Register("overwatch", "HARDPOINT SCANNING", "Hardpoint scanning.", "npc/metropolice/vo/hardpointscanning.wav")
impulse.Voice.Register("overwatch", "HAS SECTOR CONTROL", "Stabilization team has sector control.", "npc/combine_soldier/vo/stabilizationteamhassector.wav")
impulse.Voice.Register("overwatch", "HEAVY RESISTANCE", "Overwatch, be advised, we have heavy resistance.", "npc/combine_soldier/vo/heavyresistance.wav")
impulse.Voice.Register("overwatch", "HELIX", "Helix.", "npc/combine_soldier/vo/helix.wav")
impulse.Voice.Register("overwatch", "HELP", "Help!", "npc/metropolice/vo/help.wav")
impulse.Voice.Register("overwatch", "HERO", "Hero.", "npc/metropolice/vo/hero.wav")
impulse.Voice.Register("overwatch", "HIGH PRIORITY", "High-priority region.", "npc/metropolice/vo/highpriorityregion.wav")
impulse.Voice.Register("overwatch", "HUNTER", "Hunter.", "npc/combine_soldier/vo/hunter.wav")
impulse.Voice.Register("overwatch", "HURRICANE", "Hurricane.", "npc/combine_soldier/vo/hurricane.wav")
impulse.Voice.Register("overwatch", "I SAID MOVE", "I said move along.", "npc/metropolice/vo/Isaidmovealong.wav")
impulse.Voice.Register("overwatch", "ICE", "Ice.", "npc/combine_soldier/vo/ice.wav")
impulse.Voice.Register("overwatch", "IN POSITION", "In position.", "npc/metropolice/vo/inposition.wav")
impulse.Voice.Register("overwatch", "INBOUND", "Inbound.", "npc/combine_soldier/vo/inbound.wav")
impulse.Voice.Register("overwatch", "INFECTED", "Infected.", "npc/combine_soldier/vo/infected.wav")
impulse.Voice.Register("overwatch", "INFECTION", "Infection.", "npc/metropolice/vo/infection.wav")
impulse.Voice.Register("overwatch", "INFESTED", "Infested zone.", "npc/metropolice/vo/infestedzone.wav")
impulse.Voice.Register("overwatch", "INJECT", "Inject.", "npc/metropolice/vo/inject.wav")
impulse.Voice.Register("overwatch", "INOCULATE", "Inoculate.", "npc/metropolice/vo/innoculate.wav")
impulse.Voice.Register("overwatch", "INTERCEDE", "Intercede.", "npc/metropolice/vo/intercede.wav")
impulse.Voice.Register("overwatch", "INTERLOCK", "Interlock.", "npc/metropolice/vo/interlock.wav")
impulse.Voice.Register("overwatch", "INVESTIGATE", "Investigate.", "npc/metropolice/vo/investigate.wav")
impulse.Voice.Register("overwatch", "ION", "Ion.", "npc/combine_soldier/vo/ion.wav")
impulse.Voice.Register("overwatch", "IS AT CODE", "Is at code", "npc/combine_soldier/vo/isatcode.wav")
impulse.Voice.Register("overwatch", "IS DOWN", "Is down!", "npc/metropolice/vo/isdown.wav")
impulse.Voice.Register("overwatch", "IS HOLDING CODE", "Is holding at code", "npc/combine_soldier/vo/isholdingatcode.wav")
impulse.Voice.Register("overwatch", "IS INBOUND", "Unit is inbound.", "npc/combine_soldier/vo/unitisinbound.wav")
impulse.Voice.Register("overwatch", "IS MOVING IN", "Unit is moving in.", "npc/combine_soldier/vo/unitismovingin.wav")
impulse.Voice.Register("overwatch", "IS PASSIVE", "Is passive.", "npc/metropolice/vo/ispassive.wav")
impulse.Voice.Register("overwatch", "IS READY TO GO", "Is ready to go!", "npc/metropolice/vo/isreadytogo.wav")
impulse.Voice.Register("overwatch", "ISOLATE", "Isolate!", "npc/metropolice/vo/isolate.wav")
impulse.Voice.Register("overwatch", "JET", "Jet.", "npc/combine_soldier/vo/jet.wav")
impulse.Voice.Register("overwatch", "JUDGE", "Judge.", "npc/combine_soldier/vo/judge.wav")
impulse.Voice.Register("overwatch", "JURISDICTION", "Stabilization-jurisdiction.", "npc/metropolice/vo/stabilizationjurisdiction.wav")
impulse.Voice.Register("overwatch", "JURY", "Jury.", "npc/metropolice/vo/jury.wav")
impulse.Voice.Register("overwatch", "KEEP MOVING", "Keep moving!", "npc/metropolice/vo/keepmoving.wav")
impulse.Voice.Register("overwatch", "KILO", "Kilo.", "npc/combine_soldier/vo/kilo.wav")
impulse.Voice.Register("overwatch", "KING", "King.", "npc/metropolice/vo/king.wav")
impulse.Voice.Register("overwatch", "LAST SEEN AT", "Hiding, last seen at range...", "npc/metropolice/vo/hidinglastseenatrange.wav")
impulse.Voice.Register("overwatch", "LEADER", "Leader.", "npc/combine_soldier/vo/leader.wav")
impulse.Voice.Register("overwatch", "LINE", "Line.", "npc/metropolice/vo/line.wav")
impulse.Voice.Register("overwatch", "LOCATION", "Location.", "npc/metropolice/vo/location.wav")
impulse.Voice.Register("overwatch", "LOCK POSITION", "All units, lock your position!", "npc/metropolice/vo/lockyourposition.wav")
impulse.Voice.Register("overwatch", "LOCK", "Lock.", "npc/metropolice/vo/lock.wav")
impulse.Voice.Register("overwatch", "LOOK OUT", "Look out!", "npc/metropolice/vo/lookout.wav")
impulse.Voice.Register("overwatch", "LOOK", "Look!", "npc/metropolice/pointer03.wav")
impulse.Voice.Register("overwatch", "LOOSE PARASITICS", "Loose parasitics!", "npc/metropolice/vo/looseparasitics.wav")
impulse.Voice.Register("overwatch", "LOST CONTACT", "Lost contact.", "npc/combine_soldier/vo/lostcontact.wav")
impulse.Voice.Register("overwatch", "MACE", "Mace.", "npc/combine_soldier/vo/mace.wav")
impulse.Voice.Register("overwatch", "MALIGNANT", "Malignant.", "npc/metropolice/vo/malignant.wav")
impulse.Voice.Register("overwatch", "METERS", "Meters", "npc/combine_soldier/vo/meters.wav")
impulse.Voice.Register("overwatch", "MOTION CHECK", "Motion check all radials.", "npc/combine_soldier/vo/motioncheckallradials.wav")
impulse.Voice.Register("overwatch", "MOVE ALONG", "Move along.", "npc/metropolice/vo/movealong.wav")
impulse.Voice.Register("overwatch", "MOVE BACK", "Move back, right now!", "npc/metropolice/vo/movebackrightnow.wav")
impulse.Voice.Register("overwatch", "MOVE IN", "Move in.", "npc/combine_soldier/vo/movein.wav")
impulse.Voice.Register("overwatch", "MOVE IT", "Move it!", "npc/metropolice/vo/moveit.wav")
impulse.Voice.Register("overwatch", "MOVE", "Move.", "npc/metropolice/vo/move.wav")
impulse.Voice.Register("overwatch", "MOVING TO COVER", "Moving to cover!", "npc/metropolice/vo/movingtocover.wav")
impulse.Voice.Register("overwatch", "MOVING TO HARDPOINT", "Moving to hardpoint.", "npc/metropolice/vo/movingtohardpoint.wav")
impulse.Voice.Register("overwatch", "NECROTICS INBOUND", "Necrotics inbound.", "npc/combine_soldier/vo/necroticsinbound.wav")
impulse.Voice.Register("overwatch", "NECROTICS", "Necrotics.", "npc/combine_soldier/vo/necrotics.wav")
impulse.Voice.Register("overwatch", "NEGATIVE MOVEMENT", "has negative movement.", "npc/combine_soldier/vo/hasnegativemovement.wav")
impulse.Voice.Register("overwatch", "NO CONTACT", "No contact.", "npc/metropolice/vo/nocontact.wav")
impulse.Voice.Register("overwatch", "NO VISUAL ON", "No visual on UPI at this time.", "npc/metropolice/vo/novisualonupi.wav")
impulse.Voice.Register("overwatch", "NOMAD", "Nomad.", "npc/combine_soldier/vo/nomad.wav")
impulse.Voice.Register("overwatch", "NONCITIZEN", "Noncitizen.", "npc/metropolice/vo/noncitizen.wav")
impulse.Voice.Register("overwatch", "NONPATROL", "Non-patrol region.", "npc/metropolice/vo/nonpatrolregion.wav")
impulse.Voice.Register("overwatch", "NONTAGGED VIROMES", "Non-tagged viromes here!", "npc/metropolice/vo/non-taggedviromeshere.wav")
impulse.Voice.Register("overwatch", "NOVA", "Nova.", "npc/combine_soldier/vo/nova.wav")
impulse.Voice.Register("overwatch", "ONE CONTAINED", "One contained.", "npc/combine_soldier/vo/onecontained.wav")
impulse.Voice.Register("overwatch", "ONE DOWN", "One down!", "npc/combine_soldier/vo/onedown.wav")
impulse.Voice.Register("overwatch", "ONE DUTY VACATED", "One, duty vacated!", "npc/combine_soldier/vo/onedutyvacated.wav")
impulse.Voice.Register("overwatch", "OUTBREAK", "Outbreak!", "npc/combine_soldier/vo/outbreak.wav")
impulse.Voice.Register("overwatch", "OUTLAND BIOTIC", "We got an outland biotic in here!", "npc/metropolice/vo/outlandbioticinhere.wav")
impulse.Voice.Register("overwatch", "OUTLAND ZONE", "Outland zone.", "npc/metropolice/vo/outlandzone.wav")
impulse.Voice.Register("overwatch", "OVERWATCH", "Overwatch.", "npc/combine_soldier/vo/overwatch.wav")
impulse.Voice.Register("overwatch", "PATROL", "Patrol.", "npc/metropolice/vo/patrol.wav")
impulse.Voice.Register("overwatch", "PAYBACK", "Payback.", "npc/combine_soldier/vo/payback.wav")
impulse.Voice.Register("overwatch", "PHANTOM", "Phantom.", "npc/combine_soldier/vo/phantom.wav")
impulse.Voice.Register("overwatch", "POSITION AT HARDPOINT", "In position at hardpoint.", "npc/metropolice/vo/inpositionathardpoint.wav")
impulse.Voice.Register("overwatch", "POSSIBLE HOSTILES", "Overwatch reports possible hostiles inbound.", "npc/combine_soldier/vo/overwatchreportspossiblehostiles.wav")
impulse.Voice.Register("overwatch", "POSSIBLE HOSTILES2", "Ready weapons, possible hostiles inbound.", "npc/combine_soldier/vo/readyweaponshostilesinbound.wav")
impulse.Voice.Register("overwatch", "PREP FOR CONTACT", "Prep for contact, report in.", "npc/combine_soldier/vo/prepforcontact.wav")
impulse.Voice.Register("overwatch", "PREP FOR CONTACT2", "Weapons off safe, prepare for contact.", "npc/combine_soldier/vo/weaponsoffsafeprepforcontact.wav")
impulse.Voice.Register("overwatch", "PRESERVE", "Preserve.", "npc/metropolice/vo/preserve.wav")
impulse.Voice.Register("overwatch", "PRESSURE", "Pressure.", "npc/metropolice/vo/pressure.wav")
impulse.Voice.Register("overwatch", "PRIORITY 1", "Priority one objective.", "npc/combine_soldier/vo/priority1objective.wav")
impulse.Voice.Register("overwatch", "PRIORITY 2", "I have a priority-two anti-citizen here!", "npc/metropolice/vo/priority2anticitizenhere.wav")
impulse.Voice.Register("overwatch", "PRODUCTION BLOCK", "Production-block.", "npc/metropolice/vo/productionblock.wav")
impulse.Voice.Register("overwatch", "PROSECUTE", "Prosecute.", "npc/metropolice/vo/prosecute.wav")
impulse.Voice.Register("overwatch", "PROSECUTING", "Prosecuting.", "npc/combine_soldier/vo/procecuting.")
impulse.Voice.Register("overwatch", "QUICK", "Quick.", "npc/metropolice/vo/quick.wav")
impulse.Voice.Register("overwatch", "QUICKSAND", "Quicksand.", "npc/combine_soldier/vo/quicksand.wav")
impulse.Voice.Register("overwatch", "RANGE", "Range.", "npc/combine_soldier/vo/range.wav")
impulse.Voice.Register("overwatch", "RANGER", "Ranger.", "npc/combine_soldier/vo/ranger.wav")
impulse.Voice.Register("overwatch", "RAZOR", "Razor.", "npc/combine_soldier/vo/razor.wav")
impulse.Voice.Register("overwatch", "READY AMPUTATE", "Ready to amputate!", "npc/metropolice/vo/readytoamputate.wav")
impulse.Voice.Register("overwatch", "READY CHARGES", "Ready charges!", "npc/combine_soldier/vo/readycharges.wav")
impulse.Voice.Register("overwatch", "READY WEAPONS", "Ready weapons!", "npc/combine_soldier/vo/readyweapons.wav")
impulse.Voice.Register("overwatch", "REAPER", "Reaper.", "npc/combine_soldier/vo/reaper.wav")
impulse.Voice.Register("overwatch", "REPORT CLEAR", "Reporting clear.", "npc/combine_soldier/vo/reportingclear.wav")
impulse.Voice.Register("overwatch", "REPURPOSED", "Repurposed area.", "npc/metropolice/vo/repurposedarea.wav")
impulse.Voice.Register("overwatch", "REQUEST MEDICAL", "Request medical.", "npc/combine_soldier/vo/requestmedical.wav")
impulse.Voice.Register("overwatch", "REQUEST REINFORCEMENT", "Overwatch, request reinforcement.", "npc/combine_soldier/vo/overwatchrequestreinforcement.wav")
impulse.Voice.Register("overwatch", "REQUEST RESERVE ACTIVATION", "Overwatch request reserve activation.", "npc/combine_soldier/vo/overwatchrequestreserveactivation.wav")
impulse.Voice.Register("overwatch", "REQUEST STIM", "Request stim dose.", "npc/combine_soldier/vo/requeststimdose.wav")
impulse.Voice.Register("overwatch", "RESIDENTIAL BLOCK", "Residential block.", "npc/metropolice/vo/residentialblock.wav")
impulse.Voice.Register("overwatch", "RESPONDING", "Responding.", "npc/metropolice/vo/responding2.wav")
impulse.Voice.Register("overwatch", "RESTRICT", "Restrict.", "npc/metropolice/vo/restrict.wav")
impulse.Voice.Register("overwatch", "RESTRICTED", "Restricted block.", "npc/metropolice/vo/restrictedblock.wav")
impulse.Voice.Register("overwatch", "RESTRICTION ZONE", "Terminal restriction-zone.", "npc/metropolice/vo/terminalrestrictionzone.wav")
impulse.Voice.Register("overwatch", "RIPCORD", "Ripcord!", "npc/combine_soldier/vo/ripcord.wav")
impulse.Voice.Register("overwatch", "RIPCORD2", "Ripcord ripcord!", "npc/combine_soldier/vo/ripcordripcord.wav")
impulse.Voice.Register("overwatch", "ROGER THAT", "Roger that.", "npc/metropolice/vo/rodgerthat.wav")
impulse.Voice.Register("overwatch", "ROLLER", "Roller.", "npc/metropolice/vo/roller.wav")
impulse.Voice.Register("overwatch", "RUNNING", "He's running!", "npc/metropolice/vo/hesrunning.wav")
impulse.Voice.Register("overwatch", "SAVAGE", "Savage.", "npc/combine_soldier/vo/savage.wav")
impulse.Voice.Register("overwatch", "SCAR", "Scar.", "npc/combine_soldier/vo/scar.wav")
impulse.Voice.Register("overwatch", "SEARCH", "Search.", "npc/metropolice/vo/search.wav")
impulse.Voice.Register("overwatch", "SECOND WARNING", "This is your second warning!", "npc/metropolice/vo/thisisyoursecondwarning.wav")
impulse.Voice.Register("overwatch", "SECTOR NOT SECURE", "Sector is not secure.", "npc/combine_soldier/vo/sectorisnotsecure.wav")
impulse.Voice.Register("overwatch", "SECTOR NOT STERILE", "Confirmed- sector not sterile.", "npc/combine_soldier/vo/confirmsectornotsterile.wav")
impulse.Voice.Register("overwatch", "SECTOR OVERRUN", "Overwatch, sector overrun. Repeat, sector overrun.", "npc/combine_soldier/vo/overwatchsectoroverrun.wav")
impulse.Voice.Register("overwatch", "SECTOR", "Sector", "npc/combine_soldier/vo/sector.wav")
impulse.Voice.Register("overwatch", "SECURE ADVANCE", "Assault-point secured, advance!", "npc/metropolice/vo/assaultpointsecureadvance.wav")
impulse.Voice.Register("overwatch", "SECURE", "Secure.", "npc/combine_soldier/vo/secure.wav")
impulse.Voice.Register("overwatch", "SENTENCE", "Sentence delivered.", "npc/metropolice/vo/sentencedelivered.wav")
impulse.Voice.Register("overwatch", "SERVE", "Serve.", "npc/metropolice/vo/serve.wav")
impulse.Voice.Register("overwatch", "SHADOW", "Shadow.", "npc/combine_soldier/vo/shadow.wav")
impulse.Voice.Register("overwatch", "SHARPZONE", "Sharpzone.", "npc/combine_soldier/vo/sharpzone.wav")
impulse.Voice.Register("overwatch", "SHIT", "Shit!", "npc/metropolice/vo/shit.wav")
impulse.Voice.Register("overwatch", "SHOTS FIRED", "Shots fired, hostile malignants here!", "npc/metropolice/vo/shotsfiredhostilemalignants.wav")
impulse.Voice.Register("overwatch", "SIGHT LINES", "Stay alert report sightlines.", "npc/combine_soldier/vo/stayalertreportsightlines.wav")
impulse.Voice.Register("overwatch", "SIGHTLINE CLEAR", "Sightline is clear.", "npc/combine_soldier/vo/sightlineisclear.wav")
impulse.Voice.Register("overwatch", "SLAM", "Slam.", "npc/combine_soldier/vo/slam.wav")
impulse.Voice.Register("overwatch", "SLASH", "Slash.", "npc/combine_soldier/vo/slash.wav")
impulse.Voice.Register("overwatch", "SOCIOCIDE", "Sociocide.", "npc/metropolice/vo/sociocide.wav")
impulse.Voice.Register("overwatch", "SOCIOSTABLE", "We are socio-stable at this location.", "npc/metropolice/vo/wearesociostablethislocation.wav")
impulse.Voice.Register("overwatch", "SPEAR", "Spear.", "npc/combine_soldier/vo/spear.wav")
impulse.Voice.Register("overwatch", "STAB", "Stab.", "npc/combine_soldier/vo/stab.wav")
impulse.Voice.Register("overwatch", "STANDING BY", "Standing by.", "npc/combine_soldier/vo/standingby].wav")
impulse.Voice.Register("overwatch", "STAR", "Star.", "npc/combine_soldier/vo/star.wav")
impulse.Voice.Register("overwatch", "STATIONBLOCK", "Stationblock.", "npc/metropolice/vo/stationblock.wav")
impulse.Voice.Register("overwatch", "STAY ALERT", "Stay alert.", "npc/combine_soldier/vo/stayalert.wav")
impulse.Voice.Register("overwatch", "STERILIZE", "Sterilize.", "npc/metropolice/vo/sterilize.wav")
impulse.Voice.Register("overwatch", "STINGER", "Stinger.", "npc/combine_soldier/vo/stinger.wav")
impulse.Voice.Register("overwatch", "STORM", "Storm.", "npc/combine_soldier/vo/storm.wav")
impulse.Voice.Register("overwatch", "STRIKE", "Striker.", "npc/combine_soldier/vo/striker.wav")
impulse.Voice.Register("overwatch", "SUBJECT HIGH SPEED", "All units, be advised, subject is now high-speed!", "npc/metropolice/vo/subjectisnowhighspeed.wav")
impulse.Voice.Register("overwatch", "SUBJECT", "Subject.", "npc/metropolice/vo/subject.wav")
impulse.Voice.Register("overwatch", "SUNDOWN", "Sundown.", "npc/combine_soldier/vo/sundown.wav")
impulse.Voice.Register("overwatch", "SUSPEND", "Suspend.", "npc/metropolice/vo/suspend.wav")
impulse.Voice.Register("overwatch", "SWEEPER", "Sweeper.", "npc/combine_soldier/vo/sweeper.wav")
impulse.Voice.Register("overwatch", "SWEEPING IN", "Sweeping in.", "npc/combine_soldier/vo/sweepingin.wav")
impulse.Voice.Register("overwatch", "SWIFT", "Swift.", "npc/combine_soldier/vo/swift.wav")
impulse.Voice.Register("overwatch", "SWORD", "Sword.", "npc/combine_soldier/vo/sword.wav")
impulse.Voice.Register("overwatch", "TAG BUG", "Tag one bug!", "npc/metropolice/vo/tagonebug.wav")
impulse.Voice.Register("overwatch", "TAG NECROTIC", "Tag one necrotic!", "npc/metropolice/vo/tagonenecrotic.wav")
impulse.Voice.Register("overwatch", "TAG PARASITIC", "Tag one parasitic!", "npc/metropolice/vo/tagoneparasitic.wav")
impulse.Voice.Register("overwatch", "TAKE A LOOK", "Going to take a look!", "npc/metropolice/vo/goingtotakealook.wav")
impulse.Voice.Register("overwatch", "TAKE COVER", "Take cover!", "npc/metropolice/vo/takecover.wav")
impulse.Voice.Register("overwatch", "TAP", "Tap.", "npc/metropolice/vo/tap.wav")
impulse.Voice.Register("overwatch", "TARGET BLACKOUT", "Target blackout, sweep to resume.", "npc/combine_soldier/vo/targetblackout.wav")
impulse.Voice.Register("overwatch", "TARGET COMPROMISED", "Target compromised, move in, move in.", "npc/combine_soldier/vo/targetcompromisedmovein.wav")
impulse.Voice.Register("overwatch", "CONTACT AT", "Target contact at...", "npc/combine_soldier/vo/targetcontactat.wav")
impulse.Voice.Register("overwatch", "TARGET IS AT", "Target is at...", "npc/combine_soldier/vo/targetisat.wav")
impulse.Voice.Register("overwatch", "TARGET", "Target.", "npc/combine_soldier/vo/target.wav")
impulse.Voice.Register("overwatch", "TARGET INEFFECTIVE", "Target ineffective.", "npc/combine_soldier/vo/targetineffective.wav")
impulse.Voice.Register("overwatch", "TEAM ADVANCE", "Team in position, advance!.", "npc/metropolice/vo/teaminpositionadvance.wav")
impulse.Voice.Register("overwatch", "TEAM DEPLOYED", "Team deployed and scanning.", "npc/combine_soldier/vo/teamdeployedandscanning.wav")
impulse.Voice.Register("overwatch", "TEAM HOLDING", "Stabilization team holding in position.", "npc/combine_soldier/vo/stabilizationteamholding.wav")
impulse.Voice.Register("overwatch", "THAT'S A GRENADE", "That's a grenade!", "npc/metropolice/vo/thatsagrenade.wav")
impulse.Voice.Register("overwatch", "THERE HE IS", "There he is!", "npc/metropolice/vo/thereheis.wav")
impulse.Voice.Register("overwatch", "TRACKER", "Tracker.", "npc/combine_soldier/vo/tracker.wav")
impulse.Voice.Register("overwatch", "TRANSITBLOCK", "Transit-block.", "npc/metropolice/vo/transitblock.wav")
impulse.Voice.Register("overwatch", "UNIFORM", "Uniform.", "npc/combine_soldier/vo/uniform.wav")
impulse.Voice.Register("overwatch", "UNION", "Union.", "npc/metropolice/vo/union.wav")
impulse.Voice.Register("overwatch", "UP THERE", "He's up there!", "npc/metropolice/vo/hesupthere.wav")
impulse.Voice.Register("overwatch", "VACATE", "Vacate, citizen.", "npc/metropolice/vo/vacatecitizen.wav")
impulse.Voice.Register("overwatch", "VAMP", "Vamp.", "npc/combine_soldier/vo/vamp.wav")
impulse.Voice.Register("overwatch", "VICE", "Vice.", "npc/metropolice/vo/vice.wav")
impulse.Voice.Register("overwatch", "VICTOR", "Victor.", "npc/metropolice/vo/victor.wav")
impulse.Voice.Register("overwatch", "VISCON", "Viscon.", "npc/combine_soldier/vo/viscon.wav")
impulse.Voice.Register("overwatch", "VISUAL EXOGENS", "Visual on exogens.", "npc/combine_soldier/vo/visualonexogens.wav")
impulse.Voice.Register("overwatch", "WARNING GIVEN", "Second warning given!", "npc/metropolice/vo/secondwarning.wav")
impulse.Voice.Register("overwatch", "WASTERIVER", "Wasteriver.", "npc/metropolice/vo/wasteriver.wav")
impulse.Voice.Register("overwatch", "WATCH IT", "Watch it!", "npc/metropolice/vo/watchit.wav")
impulse.Voice.Register("overwatch", "WE GOT HIM", "Affirmative, we got him now.", "npc/combine_soldier/vo/affirmativewegothimnow.wav")
impulse.Voice.Register("overwatch", "WINDER", "Winder.", "npc/combine_soldier/vo/winder.wav")
impulse.Voice.Register("overwatch", "WORKFORCE", "Workforce intake.", "npc/metropolice/vo/workforceintake.wav")
impulse.Voice.Register("overwatch", "WRAP IT UP", "That's it, wrap it up.", "npc/combine_soldier/vo/thatsitwrapitup.wav")
impulse.Voice.Register("overwatch", "XRAY", "Xray.", "npc/metropolice/vo/xray.wav")
impulse.Voice.Register("overwatch", "YELLOW", "Yellow.", "npc/metropolice/vo/yellow.wav")
impulse.Voice.Register("overwatch", "ZONE", "Zone.", "npc/metropolice/vo/zone.wav")
impulse.Voice.Register("overwatch", "BOOMER", "Boomer", "npc/combine_soldier/vo/boomer.wav")
impulse.Voice.Register("overwatch", "CALL HOTPOINT", "Call hotpoint.", "npc/combine_soldier/vo/callhotpoint.wav")
impulse.Voice.Register("overwatch", "CONTACT CONFIRMED", "Contact confirmed.", "npc/combine_soldier/vo/contactconfim.wav")
impulse.Voice.Register("overwatch", "CONFIRMED PROSECUTING", "Contact confirmed, prosecuting.", "npc/combine_soldier/vo/contactconfirmprosecuting.wav")
impulse.Voice.Register("overwatch", "DELIVERED", "Delivered.", "npc/combine_soldier/vo/delivered.wav")
impulse.Voice.Register("overwatch", "TARGET AS", "Designate target as...", "npc/combine_soldier/vo/designatetargetas.wav")
impulse.Voice.Register("overwatch", "DISPLACE", "Displace!", "npc/combine_soldier/vo/displace2.wav")
impulse.Voice.Register("overwatch", "HARDEN POSITION", "Harden that position.", "npc/combine_soldier/vo/hardenthatposition.wav")
impulse.Voice.Register("overwatch", "IS FIELD PROMOTED", "Is field promoted to leader one holding.", "npc/combine_soldier/vo/isfieldpromoted.wav")
impulse.Voice.Register("overwatch", "NO VISCON", "No viscon.", "npc/combine_soldier/vo/noviscon.wav")
impulse.Voice.Register("overwatch", "OUTBREAK STATUS IS", "Outbreak status is code...", "npc/combine_soldier/vo/outbreakstatusiscode.wav")
impulse.Voice.Register("overwatch", "REQUEST SKYSHIELD", "Overwatch request Skyshield.", "npc/combine_soldier/vo/overwatchrequestskyshield.wav")
impulse.Voice.Register("overwatch", "REQUEST WINDER", "Overwatch request Winder dispatch.", "npc/combine_soldier/vo/overwatchrequestskyshield.wav")
impulse.Voice.Register("overwatch", "OVERWATCH CONTAINED", "Overwatch, target contained.", "npc/combine_soldier/vo/overwatchtargetcontained.wav")
impulse.Voice.Register("overwatch", "TEAM IS DOWN", "Overwatch, team is down, sector is not controlled.", "npc/combine_soldier/vo/overwatchteamisdown.wav")
impulse.Voice.Register("overwatch", "PROSECUTING", "Prosecuting.", "npc/combine_soldier/vo/prosecuting.wav")
impulse.Voice.Register("overwatch", "SECTOR IS SECURE", "Sector is secure no viscon.", "npc/combine_soldier/vo/sectorissecurenovison.wav")
impulse.Voice.Register("overwatch", "SKYSHIELD LOST", "Skyshield reports lost contact.", "npc/combine_soldier/vo/skyshieldreportslostcontact.wav")
impulse.Voice.Register("overwatch", "SUPPRESSING", "Suppressing.", "npc/combine_soldier/vo/suppressing.wav")
impulse.Voice.Register("overwatch", "SWARM OUTBREAK", "Swarm outbreak in sector...", "npc/combine_soldier/vo/swarmoutbreakinsector.wav")
impulse.Voice.Register("overwatch", "TARGET RADIAL", "Target my radial.", "npc/combine_soldier/vo/targetmyradial.wav")
impulse.Voice.Register("overwatch", "IS CLOSING", "Unit is closing.", "npc/combine_soldier/vo/unitisclosing.wav")
impulse.Voice.Register("overwatch", "INFESTATION ZONE", "We are in an infestation zone.", "npc/combine_soldier/vo/weareinaninfestationzone.wav")
impulse.Voice.Register("overwatch", "REQUEST WINDER", "Overwatch request Winder dispatch.", "npc/combine_soldier/vo/overwatchrequestwinder.wav")
impulse.Voice.Register("overwatch", "3CC STIMBOOST", "Overwatch orders 3cc stimboost.", "npc/combine_soldier/vo/ovewatchorders3ccstimboost.wav")
impulse.Voice.Register("overwatch", "HAVE NONTAGGED", "We have non-tagged viromes.", "npc/combine_soldier/vo/wehavenontaggedviromes.wav")
impulse.Voice.Register("overwatch", "HVT CONTAINED", "Overwatch confirm, Helix Vector Tango is contained.", "npc/combine_soldier/vo/overwatchconfirmhvtcontained.wav")

impulse.Voice.Register("scar", "1 EXPIRED", "Expired.", "cp/metropolice/vo/expired.wav")
impulse.Voice.Register("scar", "10-97", "10-97", "cp/metropolice/vo/one.wav")
impulse.Voice.Register("scar", "10-0 HUNTING", "10-0, viscerator is hunting!", "cp/metropolice/vo/tenzerovisceratorishunting.wav")
impulse.Voice.Register("scar", "10-103 TAG", "Possible 10-103, alert TAG units.", "cp/metropolice/vo/possible10-103alerttagunits.wav")
impulse.Voice.Register("scar", "10-107", "Got a 10-107 here, send AirWatch.", "cp/metropolice/vo/gota10-107sendairwatch.wav")
impulse.Voice.Register("scar", "10-108", "We have a 10-108!", "cp/metropolice/vo/wehavea10-108.wav")
impulse.Voice.Register("scar", "10-2", "10-2.", "cp/metropolice/vo/ten2.wav")
impulse.Voice.Register("scar", "REMINDER 100 CREDITS", "Reminder, 100 credits.", "cp/metropolice/vo/unitreportinwith10-25suspect.wav")
impulse.Voice.Register("scar", "10-30", "I have 10-30, my 10-20, responding.", "cp/metropolice/vo/Ihave10-30my10-20responding.wav")
impulse.Voice.Register("scar", "10-4", "10-4.", "cp/metropolice/vo/ten4.wav")
impulse.Voice.Register("scar", "10-78", "Dispatch, I need 10-78, officer in trouble!", "cp/metropolice/vo/dispatchIneed10-78.wav")
impulse.Voice.Register("scar", "10-8 standing by", "10-8, standing by.", "cp/metropolice/vo/ten8standingby.wav")
impulse.Voice.Register("scar", "10-97 GOA", "10-97, suspect is GOA.", "cp/metropolice/vo/ten97suspectisgoa.wav")
impulse.Voice.Register("scar", "10-97", "10-97.", "cp/metropolice/vo/ten97.wav")
impulse.Voice.Register("scar", "10-99", "Officer down, I am 10-99!", "cp/metropolice/vo/officerdownIam10-99.wav")
impulse.Voice.Register("scar", "11-44", "Get 11-44 inbound, cleaning up.", "cp/metropolice/vo/get11-44inboundcleaningup.wav")
impulse.Voice.Register("scar", "11-99", "11-99, officer needs assistance!", "cp/metropolice/vo/11-99officerneedsassistance.wav")
impulse.Voice.Register("scar", "BOL 243", "All units BOL for 243 suspec.t", "cp/metropolice/vo/allunitsbol34sat.wav")
impulse.Voice.Register("scar", "505", "AirWatch, subject is 505!", "cp/metropolice/vo/airwatchsubjectis505.wav")
impulse.Voice.Register("scar", "ONE ACCOMPLICE", "Got one accomplice here!", "cp/metropolice/vo/unlawfulentry603.wav")
impulse.Voice.Register("scar", "ONE MALIGNANT", "One malignant.", "cp/metropolice/vo/criminaltrespass63.wav")
impulse.Voice.Register("scar", "THAT'S A GRENADE", "That's a grenade!", "cp/metropolice/vo/thatsagrenade.wav")
impulse.Voice.Register("scar", "ACQUIRING", "Acquiring on visual!", "cp/metropolice/vo/acquiringonvisual.wav")
impulse.Voice.Register("scar", "ADMINISTER", "Administer.", "cp/metropolice/vo/administer.wav")
impulse.Voice.Register("scar", "CONFIRMED ADW", "Confirmed, ADW.", "cp/metropolice/vo/confirmadw.wav")
impulse.Voice.Register("scar", "AFFIRMATIVE", "Affirmative.", "cp/metropolice/vo/affirmative.wav")
impulse.Voice.Register("scar", "ALL UNITS MOVE", "All units, move in!", "cp/metropolice/vo/allunitsmovein.wav")
impulse.Voice.Register("scar", "SUPPRESSING", "Suppressing.", "cp/metropolice/vo/amputate.wav")
impulse.Voice.Register("scar", "ANTICITIZEN", "Anti-citizen.", "cp/metropolice/vo/anticitizen.wav")
impulse.Voice.Register("scar", "ARREST POSITIONS", "Move to arrest positions!", "cp/metropolice/vo/movetoarrestpositions.wav")
impulse.Voice.Register("scar", "PROCEED TO CHECKPOINT", "Proceed to checkpoint.", "cp/metropolice/vo/atcheckpoint.wav")
impulse.Voice.Register("scar", "ESTABLISH NEW CP!", "Establish new CP!", "cp/metropolice/vo/ptatlocationreport.wav")
impulse.Voice.Register("scar", "BACK ME UP", "Back me up, I'm out!", "cp/metropolice/vo/backmeupImout.wav")
impulse.Voice.Register("scar", "BACKUP", "Back up!", "cp/metropolice/vo/backup.wav")
impulse.Voice.Register("scar", "BLEEDING", "Suspect is bleeding!", "cp/metropolice/vo/suspectisbleeding.wav")
impulse.Voice.Register("scar", "BLOCK HOLDING", "Block is holding, cohesive.", "cp/metropolice/vo/blockisholdingcohesive.wav")
impulse.Voice.Register("scar", "BLOCK", "Block!", "cp/metropolice/vo/block.wav")
impulse.Voice.Register("scar", "BOL 243", "CP BOL for that 243.", "cp/metropolice/vo/cpbolforthat243.wav")
impulse.Voice.Register("scar", "BREAK COVER", "Break his cover!", "cp/metropolice/vo/breakhiscover.wav")
impulse.Voice.Register("scar", "PACIFY", "Pacify.", "cp/metropolice/vo/cauterize.wav")
impulse.Voice.Register("scar", "CHECK MISCOUNT", "Check for miscount.", "cp/metropolice/vo/checkformiscount.wav")
impulse.Voice.Register("scar", "CHECKPOINTS", "Proceed to checkpoints.", "cp/metropolice/vo/proceedtocheckpoints.wav")
impulse.Voice.Register("scar", "CLEAR NO 647", "Clear, no 647, no 10-107.", "cp/metropolice/vo/citizensummoned.wav")
impulse.Voice.Register("scar", "CITIZEN", "Citizen.", "cp/metropolice/vo/citizen.wav")
impulse.Voice.Register("scar", "CLASSIFY AS DB", "Classify as 'DB'; this block ready.", "cp/metropolice/vo/classifyasdbthisblockready.wav")
impulse.Voice.Register("scar", "CLEAR CODE 100", "Clear and code one-hundred.", "cp/metropolice/vo/clearandcode100.wav")
impulse.Voice.Register("scar", "CLOSE ON SUSPECT", "All units, close on suspect!", "cp/metropolice/vo/allunitscloseonsuspect.wav")
impulse.Voice.Register("scar", "CODE 100", "Code one-hundred.", "cp/metropolice/vo/code100.wav")
impulse.Voice.Register("scar", "CODE 12", "All units, return to code 12!", "cp/metropolice/vo/allunitscode2.wav")
impulse.Voice.Register("scar", "CODE 3", "Officer down, code three to my 10-20!", "cp/metropolice/vo/officerdowncode3tomy10-20.wav")
impulse.Voice.Register("scar", "CODE 7", "Code seven.", "cp/metropolice/vo/code7.wav")
impulse.Voice.Register("scar", "CONTACT 243", "Contact with 243 suspect, my 10-20 is...", "cp/metropolice/vo/contactwith243suspect.wav")
impulse.Voice.Register("scar", "CONTACT PRIORITY", "Contact with priority two!", "cp/metropolice/vo/contactwithpriority2.wav")
impulse.Voice.Register("scar", "CONTROL 100", "Control one-hundred percent.", "cp/metropolice/vo/control100percent.wav")
impulse.Voice.Register("scar", "CONTROLSECTION", "Control-section!", "cp/metropolice/vo/controlsection.wav")
impulse.Voice.Register("scar", "CONVERGING", "Converging.", "cp/metropolice/vo/converging.wav")
impulse.Voice.Register("scar", "COPY", "Copy.", "cp/metropolice/vo/copy.wav")
impulse.Voice.Register("scar", "CP COMPROMISED", "CP is compromised!", "cp/metropolice/vo/cpiscompromised.wav")
impulse.Voice.Register("scar", "CP ESTABLISH", "Establish new CP!", "cp/metropolice/vo/cpweneedtoestablishaperimeterat.wav")
impulse.Voice.Register("scar", "CP OVERRUN", "CP is overrun, we have no containment!", "cp/metropolice/vo/cpisoverrunwehavenocontainment.wav")
impulse.Voice.Register("scar", "DB COUNT 1", "DB count is 1.", "cp/metropolice/vo/dbcountis.wav")
impulse.Voice.Register("scar", "CONTACT CONFIRMED", "Contact confirmed.", "cp/metropolice/vo/designatesuspectas.wav")
impulse.Voice.Register("scar", "DESTROY COVER", "Destroy that cover!", "cp/metropolice/vo/destroythatcover.wav")
impulse.Voice.Register("scar", "DISLOCATE INTERPOSE", "Fire to dislocate that interpose!", "cp/metropolice/vo/firetodislocateinterpose.wav")
impulse.Voice.Register("scar", "HARDPOINT SCANNING", "Hardpoint scanning.", "cp/metropolice/vo/dismountinghardpoint.wav")
impulse.Voice.Register("scar", "RECALIBRATE SOCIO-SCAN", "Recalibrate socio-scan.", "cp/metropolice/vo/dispupdatingapb.wav")
impulse.Voice.Register("scar", "SUSPECT", "Suspect.", "cp/metropolice/vo/document.wav")
impulse.Voice.Register("scar", "PREPARE FOR JUDGEMENT", "Prepare for judgement!", "cp/metropolice/vo/dontmove.wav")
impulse.Voice.Register("scar", "ESTABLISH NEW CP", "Establish new CP!", "cp/metropolice/vo/establishnewcp.wav")
impulse.Voice.Register("scar", "EXPOSE TARGET", "Firing to expose target!", "cp/metropolice/vo/firingtoexposetarget.wav")
impulse.Voice.Register("scar", "LEADERS REPORT RATIOS", "Leaders, report ratios.", "cp/metropolice/vo/externaljurisdiction.wav")
impulse.Voice.Register("scar", "FINAL VERDICT", "Final verdict administered.", "cp/metropolice/vo/finalverdictadministered.wav")
impulse.Voice.Register("scar", "FINAL WARNING", "Final warning!", "cp/metropolice/vo/finalwarning.wav")
impulse.Voice.Register("scar", "FIRST WARNING", "First warning, move!", "cp/metropolice/vo/firstwarningmove.wav")
impulse.Voice.Register("scar", "TAG NECROTIC", "Tag one necrotic!", "cp/metropolice/vo/freenecrotics.wav")
impulse.Voice.Register("scar", "GET DOWN", "Get down!", "cp/metropolice/vo/getdown.wav")
impulse.Voice.Register("scar", "GET OUT", "Get out of here!", "cp/metropolice/vo/getoutofhere.wav")
impulse.Voice.Register("scar", "GETTING 647E", "Still getting 647-E.", "cp/metropolice/vo/stillgetting647e.wav")
impulse.Voice.Register("scar", "GO AGAIN", "PT, go again.", "cp/metropolice/vo/ptgoagain.wav")
impulse.Voice.Register("scar", "GOING IN", "Cover me, going in!", "cp/metropolice/vo/covermegoingin.wav")
impulse.Voice.Register("scar", "GOT A DB", "We got a DB here, cancel that 10-102.", "cp/metropolice/vo/wegotadbherecancel10-102.wav")
impulse.Voice.Register("scar", "GRENADE", "Grenade!", "cp/metropolice/vo/grenade.wav")
impulse.Voice.Register("scar", "HAHA", "Haha.", "cp/metropolice/vo/chuckle.wav")
impulse.Voice.Register("scar", "HARDPOINT SCANNING2", "Hardpoint scanning.", "cp/metropolice/vo/hardpointscanning.wav")
impulse.Voice.Register("scar", "CP COMPROMISED", "CP is compromised!", "cp/metropolice/vo/help.wav")
impulse.Voice.Register("scar", "HES 148", "He's gone 148!", "cp/metropolice/vo/hesgone148.wav")
impulse.Voice.Register("scar", "PRIORITY", "Priority.", "cp/metropolice/vo/highpriorityregion.wav")
impulse.Voice.Register("scar", "HOLD IT", "Hold it right there!", "cp/metropolice/vo/holditrightthere.wav")
impulse.Voice.Register("scar", "HOLD POSITION", "Hold this position.", "cp/metropolice/vo/holdthisposition.wav")
impulse.Voice.Register("scar", "I SAID MOVE", "I said move along.", "cp/metropolice/vo/Isaidmovealong.wav")
impulse.Voice.Register("scar", "IN POSITION", "In position.", "cp/metropolice/vo/inposition.wav")
impulse.Voice.Register("scar", "STERLIZE 1", "Sterlize 1!", "cp/metropolice/vo/inject.wav")
impulse.Voice.Register("scar", "INTERPOSE", "Interpose!", "cp/metropolice/vo/innoculate.wav")
impulse.Voice.Register("scar", "IS 10-8", "Unit is 10-8, standing by.", "cp/metropolice/vo/unitis10-8standingby.wav")
impulse.Voice.Register("scar", "OFFICER CLOSING", "Officer closing on suspect!", "cp/metropolice/vo/isclosingonsuspect.wav")
impulse.Voice.Register("scar", "REWARD NOTICE", "Reward notice!", "cp/metropolice/vo/isdown.wav")
impulse.Voice.Register("scar", "MOVING", "Moving!", "cp/metropolice/vo/ismovingin.wav")
impulse.Voice.Register("scar", "JUDGEMENT", "Prepare for judgement!", "cp/metropolice/vo/prepareforjudgement.wav")
impulse.Voice.Register("scar", "ANTI-FATIGUE RATING", "Anti-fatigue rating.", "cp/metropolice/vo/stabilizationjurisdiction.wav")
impulse.Voice.Register("scar", "KEEP MOVING", "Keep moving!", "cp/metropolice/vo/keepmoving.wav")
impulse.Voice.Register("scar", "LEVEL 3", "Level three civil-privacy violator!", "cp/metropolice/vo/level3civilprivacyviolator.wav")
impulse.Voice.Register("scar", "LOCATION", "Location?", "cp/metropolice/vo/location.wav")
impulse.Voice.Register("scar", "LOCK POSITION", "Lock your position!", "cp/metropolice/vo/lockyourposition.wav")
impulse.Voice.Register("scar", "LOOK OUT", "Look out!", "cp/metropolice/vo/lookout.wav")
impulse.Voice.Register("scar", "LOOSE PARASITICS", "Loose parasitics!", "cp/metropolice/vo/looseparasitics.wav")
impulse.Voice.Register("scar", "LOW ON", "Running low on verdicts, taking cover!", "cp/metropolice/vo/runninglowonverdicts.wav")
impulse.Voice.Register("scar", "MAINTAIN CP", "All units, maintain this CP!", "cp/metropolice/vo/allunitsmaintainthiscp.wav")
impulse.Voice.Register("scar", "MALCOMPLIANCE", "Issuing malcompliance citation.", "cp/metropolice/vo/issuingmalcompliantcitation.wav")
impulse.Voice.Register("scar", "MALIGNANT", "Malignant!", "cp/metropolice/vo/malignant.wav")
impulse.Voice.Register("scar", "MINOR HITS", "Minor hits, continuing!", "cp/metropolice/vo/minorhitscontinuing.wav")
impulse.Voice.Register("scar", "MOVE ALONG", "Move along!", "cp/metropolice/vo/movealong.wav")
impulse.Voice.Register("scar", "MOVE BACK", "Move back, right now!", "cp/metropolice/vo/movebackrightnow.wav")
impulse.Voice.Register("scar", "MOVE IT", "Move it!", "cp/metropolice/vo/moveit.wav")
impulse.Voice.Register("scar", "MOVE", "Move!", "cp/metropolice/vo/move.wav")
impulse.Voice.Register("scar", "MOVING TO COVER", "Moving to cover!", "cp/metropolice/vo/movingtocover.wav")
impulse.Voice.Register("scar", "NEEDS ASSISTANCE", "Officer needs assistance!", "cp/metropolice/vo/officerneedsassistance.wav")
impulse.Voice.Register("scar", "NEEDS HELP", "Officer needs help!", "cp/metropolice/vo/officerneedshelp.wav")
impulse.Voice.Register("scar", "NO 647", "Clear, no 647, no 10-107.", "cp/metropolice/vo/clearno647no10-107.wav")
impulse.Voice.Register("scar", "ANYONE PICKUP", "Anyone pickup.", "cp/metropolice/vo/nocontact.wav")
impulse.Voice.Register("scar", "NO VISUAL ON", "No visual on UPI.", "cp/metropolice/vo/novisualonupi.wav")
impulse.Voice.Register("scar", "NONCITIZEN EXPIRED", "Noncitizen expired.", "cp/metropolice/vo/noncitizen.wav")
impulse.Voice.Register("scar", "CONVERGING", "Converging!", "cp/metropolice/vo/nonpatrolregion.wav")
impulse.Voice.Register("scar", "NONTAGGED VIROMES", "Non-tagged viromes here!", "cp/metropolice/vo/non-taggedviromeshere.wav")
impulse.Voice.Register("scar", "GET OUT", "Get out of here!", "cp/metropolice/vo/nowgetoutofhere.wav")
impulse.Voice.Register("scar", "OUTBREAK", "Outbreak!", "cp/metropolice/vo/outbreak.wav")
impulse.Voice.Register("scar", "PACIFYING", "Pacifying!", "cp/metropolice/vo/pacifying.wav")
impulse.Voice.Register("scar", "PAIN1", "Ugh!", "cp/metropolice/pain1.wav")
impulse.Voice.Register("scar", "PAIN2", "Uagh!", "cp/metropolice/pain2.wav")
impulse.Voice.Register("scar", "PAIN3", "Augh!", "cp/metropolice/pain3.wav")
impulse.Voice.Register("scar", "PAIN4", "Agh!", "cp/metropolice/pain4.wav")
impulse.Voice.Register("scar", "PICKUP 647E", "Anyone pick up 647-E?", "cp/metropolice/vo/anyonepickup647e.wav")
impulse.Voice.Register("scar", "POSITION TO CONTAIN", "Position to contain.", "cp/metropolice/vo/positiontocontain.wav")
impulse.Voice.Register("scar", "POSSIBLE ACCOMPLICE", "Report sightings of possible accomplice.", "cp/metropolice/vo/reportsightingsaccomplices.wav")
impulse.Voice.Register("scar", "POSSIBLE LEVEL 3", "Possible level three civil-privacy violator!", "cp/metropolice/vo/possiblelevel3civilprivacyviolator.wav")
impulse.Voice.Register("scar", "PREPARING TO JUDGE", "Preparing to judge 10-107.", "cp/metropolice/vo/preparingtojudge10-107.wav")
impulse.Voice.Register("scar", "PRIORITY 1", "Confirm, priority-one sighted.", "cp/metropolice/vo/confirmpriority1sighted.wav")
impulse.Voice.Register("scar", "PRIORITY 2", "Priority-two anti-citizen here!", "cp/metropolice/vo/priority2anticitizenhere.wav")
impulse.Voice.Register("scar", "READY TO PROSECUTE", "Ready to prosecute, final warning!", "cp/metropolice/vo/readytoprosecutefinalwarning.wav")
impulse.Voice.Register("scar", "PROSECUTE", "Prosecute!", "cp/metropolice/vo/prosecute.wav")
impulse.Voice.Register("scar", "PROTECTION COMPLETE", "Protection complete.", "cp/metropolice/vo/protectioncomplete.wav")
impulse.Voice.Register("scar", "REINFORCEMENT TEAMS", "Engaging team is non-cohesive! Reinforcement-teams, code three!", "cp/metropolice/vo/reinforcementteamscode3.wav")
impulse.Voice.Register("scar", "REPORT IN", "CP requests all units report-in.", "cp/metropolice/vo/cprequestsallunitsreportin.wav")
impulse.Voice.Register("scar", "REPORT LOCATION", "All units, report location suspect!", "cp/metropolice/vo/allunitsreportlocationsuspect.wav")
impulse.Voice.Register("scar", "REPORT STATUS", "Local CPT, report status.", "cp/metropolice/vo/localcptreportstatus.wav")
impulse.Voice.Register("scar", "REPURPOSED", "Repurposed area.", "cp/metropolice/vo/repurposedarea.wav")
impulse.Voice.Register("scar", "RESPOND CODE 3", "All units respond, code three!", "cp/metropolice/vo/allunitsrespondcode3.wav")
impulse.Voice.Register("scar", "RESPONDING", "Responding.", "cp/metropolice/vo/responding2.wav")
impulse.Voice.Register("scar", "SOCIAL FRACTURE IN PROGRESS", "Social fracture in progress.", "cp/metropolice/vo/terminalrestrictionzone.wav")
impulse.Voice.Register("scar", "RODGER THAT", "Rodger that!", "cp/metropolice/vo/rodgerthat.wav")
impulse.Voice.Register("scar", "RUNNING", "He's running!", "cp/metropolice/vo/hesrunning.wav")
impulse.Voice.Register("scar", "SEARCHING FOR SUSPECT", "Searching for suspect.", "cp/metropolice/vo/searchingforsuspect.wav")
impulse.Voice.Register("scar", "SECOND WARNING", "Second warning!", "cp/metropolice/vo/thisisyoursecondwarning.wav")
impulse.Voice.Register("scar", "SECURE ADVANCE", "Assault-point secured, advance!", "cp/metropolice/vo/assaultpointsecureadvance.wav")
impulse.Voice.Register("scar", "SENTENCE", "One sentence delivered.", "cp/metropolice/vo/sentencedelivered.wav")
impulse.Voice.Register("scar", "SHIT", "Shit!", "cp/metropolice/vo/shit.wav")
impulse.Voice.Register("scar", "SHOTS FIRED", "Shots fired, hostile malignants here!", "cp/metropolice/vo/shotsfiredhostilemalignants.wav")
impulse.Voice.Register("scar", "SOCIOSTABLE", "We are socio-stable in this location.", "cp/metropolice/vo/wearesociostablethislocation.wav")
impulse.Voice.Register("scar", "STERILIZE", "Sterilize 1!", "cp/metropolice/vo/sterilize.wav")
impulse.Voice.Register("scar", "SUBJECT 505", "Subject is 505!", "cp/metropolice/vo/subjectis505.wav")
impulse.Voice.Register("scar", "SUBJECT HIGH SPEED", "Subject is now high-speed!", "cp/metropolice/vo/subjectisnowhighspeed.wav")
impulse.Voice.Register("scar", "SUBJECT", "Subject!", "cp/metropolice/vo/subject.wav")
impulse.Voice.Register("scar", "SUSPEND 1", "Suspend 1!", "cp/metropolice/vo/suspend.wav")
impulse.Voice.Register("scar", "SWEEPING SUSPECT", "Sweeping for suspect!", "cp/metropolice/vo/sweepingforsuspect.wav")
impulse.Voice.Register("scar", "10-91D 1", "10-91D, count is 1!", "cp/metropolice/vo/tag10-91d.wav")
impulse.Voice.Register("scar", "TAG BUG", "Tag one bug!", "cp/metropolice/vo/tagonebug.wav")
impulse.Voice.Register("scar", "TAG NECROTIC", "Tag one necrotic!", "cp/metropolice/vo/tagonenecrotic.wav")
impulse.Voice.Register("scar", "TAG PARASITIC", "Tag one parasitic!", "cp/metropolice/vo/tagoneparasitic.wav")
impulse.Voice.Register("scar", "TAKE A LOOK", "Gonna take a look!", "cp/metropolice/vo/goingtotakealook.wav")
impulse.Voice.Register("scar", "TAKE COVER", "Take cover!", "cp/metropolice/vo/takecover.wav")
impulse.Voice.Register("scar", "TEAM ADVANCE", "Team in position, advance!", "cp/metropolice/vo/teaminpositionadvance.wav")
impulse.Voice.Register("scar", "THERE HE IS", "There he is!", "cp/metropolice/vo/thereheis.wav")
impulse.Voice.Register("scar", "TROUBLE", "Looking for trouble?", "cp/metropolice/vo/lookingfortrouble.wav")
impulse.Voice.Register("scar", "UNDER FIRE", "Officer under fire, taking cover!", "cp/metropolice/vo/officerunderfiretakingcover.wav")
impulse.Voice.Register("scar", "UNKNOWN", "Suspect location unknown.", "cp/metropolice/vo/suspectlocationunknown.wav")
impulse.Voice.Register("scar", "UP THERE", "He's up there!", "cp/metropolice/vo/hesupthere.wav")
impulse.Voice.Register("scar", "UPI", "UPI.", "cp/metropolice/vo/upi.wav")
impulse.Voice.Register("scar", "UTL SUSPECT", "UTL that suspect.", "cp/metropolice/vo/utlthatsuspect.wav")
impulse.Voice.Register("scar", "VACATE", "Vacate, citizen!", "cp/metropolice/vo/vacatecitizen.wav")
impulse.Voice.Register("scar", "VERDICT", "You want a malcompliance verdict?", "cp/metropolice/vo/youwantamalcomplianceverdict.wav")
impulse.Voice.Register("scar", "WARNING GIVEN", "Second warning!", "cp/metropolice/vo/secondwarning.wav")
impulse.Voice.Register("scar", "WATCH IT", "Watch it!", "cp/metropolice/vo/watchit.wav")