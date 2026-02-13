local randomSounds = {
	"npc/overwatch/radiovoice/accomplicesoperating.wav",
	"npc/overwatch/radiovoice/airwatchcopiesnoactivity.wav",
	"npc/overwatch/radiovoice/airwatchreportspossiblemiscount.wav",
	"npc/overwatch/radiovoice/allteamsrespondcode3.wav",
	"npc/overwatch/radiovoice/allunitsreturntocode12.wav",
	"npc/overwatch/radiovoice/antifatigueration3mg.wav",
	"npc/overwatch/radiovoice/beginscanning10-0.wav",
	"npc/overwatch/radiovoice/failuretotreatoutbreak.wav",
	"npc/overwatch/radiovoice/finalverdictadministered.wav",
	"npc/overwatch/radiovoice/investigateandreport.wav",
	"npc/overwatch/radiovoice/leadersreportratios.wav",
	"npc/overwatch/radiovoice/officerclosingonsuspect.wav",
	"npc/overwatch/radiovoice/politistabilizationmarginal.wav",
	"npc/overwatch/radiovoice/prepareforfinalsentencing.wav",
	"npc/overwatch/radiovoice/preparetoreceiveverdict.wav",
	"npc/overwatch/radiovoice/recalibratesocioscan.wav",
	"npc/overwatch/radiovoice/recievingconflictingdata.wav",
	"npc/overwatch/radiovoice/reinforcementteamscode3.wav",
	"npc/overwatch/radiovoice/reminder100credits.wav",
	"npc/overwatch/radiovoice/remindermemoryreplacement.wav",
	"npc/overwatch/radiovoice/rewardnotice.wav",
	"npc/overwatch/radiovoice/upi.wav"
}

local function EmitChatter(ply)
	local randomSound = randomSounds[math.random(1, #randomSounds)]
	ply:EmitSound(randomSound, 60)
end

local nextChatterCheck = 0

function SCHEMA:Think()
	if nextChatterCheck > CurTime() then return end
	
	for v,k in pairs(player.GetAll()) do
		if k:Team() == TEAM_CP and k:GetMoveType() != MOVETYPE_NOCLIP and !k.IsRogue then
			local curTime = CurTime()

			if not k.nextChatter or curTime > k.nextChatter then
				k.nextChatter = curTime + math.random(90, 120)
				EmitChatter(k)
			end
		end
	end

	nextChatterCheck = CurTime() + 4
end

local normalPain = {
	Sound("vo/npc/male01/pain01.wav"),
	Sound("vo/npc/male01/pain02.wav"),
	Sound("vo/npc/male01/pain03.wav"),
	Sound("vo/npc/male01/pain04.wav"),
	Sound("vo/npc/male01/pain05.wav"),
	Sound("vo/npc/male01/pain06.wav")
}

local gruntpainsounds = {
	"grunt/pain_01.wav",
	"grunt/pain_02.wav",
	"grunt/pain_03.wav",
	"grunt/pain_04.wav",
	"grunt/pain_05.wav",
	"grunt/pain_06.wav",
	"grunt/pain_07.wav",
	"grunt/pain_08.wav",
	"grunt/pain_09.wav",
	"grunt/pain_10.wav",
}

local apfpainsounds = {
	"suppressor/pain_01.wav",
	"suppressor/pain_02.wav",
	"suppressor/pain_03.wav",
	"suppressor/pain_04.wav",
	"suppressor/pain_05.wav",
	"suppressor/pain_06.wav",
	"suppressor/pain_07.wav",
	"suppressor/pain_08.wav",
	"suppressor/pain_09.wav",
	"suppressor/pain_10.wav",
}

local ordinalpainsounds = {
	"ordinal/pain_01.wav",
	"ordinal/pain_02.wav",
	"ordinal/pain_03.wav",
	"ordinal/pain_04.wav",
	"ordinal/pain_05.wav",
	"ordinal/pain_06.wav",
	"ordinal/pain_07.wav",
	"ordinal/pain_08.wav",
	"ordinal/pain_09.wav",
	"ordinal/pain_10.wav",
}

local ordinaldeathsounds = {
	"ordinal/die_01.wav",
	"ordinal/die_02.wav",
	"ordinal/die_03.wav",
	"ordinal/die_04.wav",
	"ordinal/die_05.wav",
	"ordinal/die_06.wav",
	"ordinal/die_07.wav",
	"ordinal/die_08.wav",
	"ordinal/die_09.wav",
	"ordinal/die_10.wav",
}

local gruntdeathsounds = {
	"grunt/die_01.wav",
	"grunt/die_02.wav",
	"grunt/die_03.wav",
	"grunt/die_04.wav",
	"grunt/die_05.wav",
	"grunt/die_06.wav",
	"grunt/die_07.wav",
	"grunt/die_08.wav",
	"grunt/die_09.wav",
	"grunt/die_10.wav",
}

local apfdeathsounds = {
	"suppressor/die_01.wav",
	"suppressor/die_02.wav",
	"suppressor/die_03.wav",
	"suppressor/die_04.wav",
	"suppressor/die_05.wav",
	"suppressor/die_06.wav",
	"suppressor/die_07.wav",
	"suppressor/die_08.wav",
	"suppressor/die_09.wav",
	"suppressor/die_10.wav",
}

local wallhammerdeathsounds = {
	"wallhammer/die_01.wav",
	"wallhammer/die_02.wav",
	"wallhammer/die_03.wav",
	"wallhammer/die_04.wav",
	"wallhammer/die_05.wav",
	"wallhammer/die_06.wav",
	"wallhammer/die_07.wav",
	"wallhammer/die_08.wav",
	"wallhammer/die_09.wav",
	"wallhammer/die_10.wav",
}

local cpdeathsounds = {
	"npc/metropolice/die1.wav",
	"npc/metropolice/die2.wav",
	"npc/metropolice/die3.wav",
	"npc/metropolice/die4.wav"
}

local otadeathsounds = {
	"npc/combine_soldier/die1.wav",
	"npc/combine_soldier/die2.wav",
	"npc/combine_soldier/die3.wav"
}


local cppain = {
	"npc/metropolice/pain1.wav",
	"npc/metropolice/pain2.wav",
	"npc/metropolice/pain3.wav",
	"npc/metropolice/pain4.wav"
}

local otapain = {
	"npc/combine_soldier/pain1.wav",
	"npc/combine_soldier/pain2.wav",
	"npc/combine_soldier/pain3.wav"
}

local stalkerpainsounds = {
	"npc/stalker/stalker_pain1.wav",
	"npc/stalker/stalker_pain2.wav",
	"npc/stalker/stalker_pain3.wav"
}

local stalkerdeathsounds = {
	"npc/stalker/stalker_die1.wav",
	"npc/stalker/stalker_die2.wav",
}

local wallhammerpain = {
	"wallhammer/pain_01.wav",
	"wallhammer/pain_02.wav",
	"wallhammer/pain_03.wav",
	"wallhammer/pain_04.wav",
	"wallhammer/pain_05.wav",
	"wallhammer/pain_06.wav",
	"wallhammer/pain_07.wav",
	"wallhammer/pain_08.wav",
	"wallhammer/pain_09.wav",
	"wallhammer/pain_10.wav"
}

local augmentedcppain = {
	"cp/metropolice/pain1.wav",
	"cp/metropolice/pain2.wav",
	"cp/metropolice/pain3.wav"
}

function SCHEMA:PlayerHurt(victim)
	if IsValid(victim) then
		if (victim.NextPain or 0) > CurTime() then return end

		

		if victim:IsPlayer() and victim:Team() == TEAM_OTA then
			local rank = victim:GetTeamRank()
			if rank == nil or rank == RANK_OWG then
				victim:EmitSound(gruntpainsounds[math.random(1, 10)])
			elseif victim:GetTeamClass() == CLASS_APF then 
				victim:EmitSound(apfpainsounds[math.random(1, 10)])
			elseif victim:GetTeamClass() == CLASS_PAYBACK then
				victim:EmitSound(wallhammerpain[math.random(1, 10)])
			elseif victim:GetTeamRank() >= RANK_ORD && victim:GetTeamClass() != CLASS_FIST then
				victim:EmitSound(ordinalpainsounds[math.random(1, 10)])
			else
				victim:EmitSound(otapain[math.random(1, 3)])
			end
		elseif victim:IsPlayer() and victim:Team() == TEAM_CP then
			if victim.IsAugmented then 
				victim:EmitSound(augmentedcppain[math.random(1, 3)])
			else	
				victim:EmitSound(cppain[math.random(1, 4)])
			end
		elseif victim:Team() == TEAM_ZOMBIE then
			if victim:GetModel() == "models/player/zombie_classic.mdl" then
				victim:EmitSound("npc/zombie/zombie_pain" .. math.random(1,6) .. ".wav")
			elseif victim:GetModel() == "models/player/fast_zombie.mdl" then
				victim:EmitSound("npc/fast_zombie/leap1.wav")
			else	
				victim:EmitSound("npc/zombine/zombine_pain" .. math.random(1,4) .. ".wav")
			end
		elseif victim:Team() == TEAM_STALKER then
			victim:EmitBudgetSound(table.Random(stalkerpainsounds))
		elseif victim:Team() != TEAM_VORT then
			local painSounds = table.Random(normalPain)

			if victim:IsFemale() then
				painSounds = painSounds:gsub("male", "female")
			end

			victim:EmitSound(painSounds)
		end

		victim.NextPain = CurTime() + 0.33
	end	
end

local legPain = {
	"myleg01.wav",
	"myleg02.wav"
}
function SCHEMA:PlayerLegsBroken(ply)
	if ply:Team() == TEAM_VORT then
		return
	end

	if ply:IsCP() then
		if ply:Team() == TEAM_CP then
			ply:SendCombineMessage("LEG FRACTURES DETECTED. SEEK MEDICAL ATTENTION.", Color(255, 165, 0))
		end

		return
	end

	--ply:EmitSound("vo/npc/"..(ply:IsFemale() and "female01" or "male01").."/"..legPain[math.random(1, #legPain)])
end

function SCHEMA:PlayerDeath(ply)
	if ply:IsPlayer() and ply:Team() == TEAM_OTA then
		local rank = ply:GetTeamRank()
		if rank == nil or rank == RANK_OWG then
			ply:EmitBudgetSound(gruntdeathsounds[math.random(1, 10)])
		elseif ply:GetTeamClass() == CLASS_APF then
			ply:EmitBudgetSound(apfdeathsounds[math.random(1, 10)])
		elseif ply:GetTeamClass() == CLASS_PAYBACK then
			ply:EmitBudgetSound(wallhammerdeathsounds[math.random(1, 10)])
		elseif ply:GetTeamRank() >= RANK_ORD then
			ply:EmitBudgetSound(ordinaldeathsounds[math.random(1, 10)])
		else
			ply:EmitBudgetSound(otadeathsounds[math.random(1, 3)])
		end
	elseif ply:IsPlayer() and ply:Team() == TEAM_CP then
		if ply.IsAugmented then
			ply:EmitBudgetSound(gruntdeathsounds[math.random(1, 10)])
		else
			ply:EmitBudgetSound(cpdeathsounds[math.random(1, 4)])
		end
	elseif ply:Team() == TEAM_ZOMBIE then
		ply:EmitSound("npc/zombie/zombie_die" .. math.random(1,3) .. ".wav")
	elseif ply:Team() == TEAM_STALKER then
		ply:EmitBudgetSound(table.Random(stalkerdeathsounds))
	end
end