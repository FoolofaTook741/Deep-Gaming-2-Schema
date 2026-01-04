function meta:GetSkillXP(name)
	local skills = self.impulseSkills
	if not skills then return end

	if skills[name] then
		return skills[name]
	else
		return 0
	end
end

function meta:SetSkillXP(name, value)
	if not self.impulseSkills then return end
	if not impulse.Skills.Skills[name] then return end

	value = math.Round(value)

	self.impulseSkills[name] = value

	local data = util.TableToJSON(self.impulseSkills)

	if data then
		local query = mysql:Update("impulse_players")
		query:Update("skills", data)
		query:Where("steamid", self:SteamID())
		query:Execute()
	end

	self:NetworkSkill(name, value)
end

function meta:NetworkSkill(name, value)
	net.Start("impulseSkillUpdate")
	net.WriteUInt(impulse.Skills.Skills[name], 4)
	net.WriteUInt(value, 16)
	net.Send(self)
end

function meta:AddSkillXP(name, value)
	if not self.impulseSkills then return end

	local cur = self:GetSkillXP(name)
	local new = math.Round(math.Clamp(cur + value, 0, 21000))

	if cur != new then
		self:SetSkillXP(name, new)
		hook.Run("PlayerAddSkillXP", self, new, name)
	end
end

local function impulse_givexp(steamid32, packageText)
    if not steamid32 or not packageText then return end

    local XP_AMOUNT = 1000

	local skillMap = {
		strength   = "strength",
		lockpick   = "lockpick",
		charisma   = "charisma",
		technology = "metabolism",
		scrapping  = "scrapping",
		vitality   = "vitality",
		craft      = "craft",
		medical    = "medical"
	}

    packageText = string.lower(packageText)

    local skill
    for key, val in pairs(skillMap) do
        if string.find(packageText, key, 1, true) then
            skill = val
            break
        end
    end

    if not skill then
        print("[VYHUB] No valid skill found in:", packageText)
        return
    end
    for _, ply in ipairs(player.GetAll()) do
        if ply:SteamID() == steamid32 then
            if ply.AddSkillXP then
                ply:AddSkillXP(skill, XP_AMOUNT)
            end

            print(string.format(
                "[VYHUB] Added %d XP to %s (%s)",
                XP_AMOUNT, ply:Nick(), skill
            ))
            return
        end
    end
end

concommand.Add("impulse_givexp", function(ply, cmd, args)
    if IsValid(ply) then return end

    local steamid = args[1]
    local text = args[2]

    if not steamid or not text then
        return
    end

    impulse_givexp(steamid, text)
end)