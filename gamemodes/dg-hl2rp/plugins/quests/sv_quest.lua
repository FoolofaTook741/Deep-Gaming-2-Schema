util.AddNetworkString("impulseQuestUpdate")
util.AddNetworkString("ImpulseHL2RPQuests404Zone")
util.AddNetworkString("impulseCompleteQuest")

net.Receive("ImpulseHL2RPQuests404Zone", function()
    local ply = net.ReadPlayer()

    if ply.CurrentQuest == QUEST_404 then
        ply:CompleteQuest(QUEST_404)
    end
end)

local meta = FindMetaTable("Player")
 -- util functions
function meta:GiveQuest(id)
    self.CurrentQuest = id
    local quest = Config.quests[id]

    local questData = {
        title = quest.title,
        description = quest.description
    }
    net.Start("impulseQuestUpdate")
        net.WriteInt(id, 8)
        net.WriteTable(questData)
    net.Send(self)
end

function meta:CompleteQuest()
    local id = self.CurrentQuest
    if not id or not Config.quests[id] then return end

    local questTitle = Config.quests[id].title or "Quest Completed"

    Config.quests[id].reward(self)
    self:GiveQuest(self.CurrentQuest + 1)

    net.Start('impulseCompleteQuest')
        net.WriteString(questTitle)
    net.Send(self)

    self:EmitSound("ambient/levelup/ambient_chimes_11.mp3")
end


hook.Add("Spawn", "impulseQuestSpawnFunc", function(ply)
    ply:GiveQuest(QUEST_PRIME_DIRECTIVE)
end)

hook.Add("PlayerChangedTeam", "impulseQuestSpawnFunc", function(ply)
    if ply:Team() == TEAM_CITIZEN then
        ply:GiveQuest(QUEST_PRIME_DIRECTIVE)
    end
end)

hook.Add("PlayerCraftItem", "QuestCraft", function(ply, class)
	if class == "wep_axe" and ply.CurrentQuest == QUEST_RISKY_TOOLS then
		ply:CompleteQuest(QUEST_RISKY_TOOLS)
	end
end)
