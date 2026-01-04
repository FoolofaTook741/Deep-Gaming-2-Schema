Config = Config or {}
QUEST_PRIME_DIRECTIVE = 1
QUEST_DEPOSIT = 2
QUEST_START_SOMEWHERE = 3
QUEST_HOME_SWEET_HOME = 4
QUEST_STORAGE = 5
QUEST_SCAV = 6
QUEST_RISKY_TOOLS = 7
QUEST_MOONSHINE  = 8
QUEST_404 = 9
QUEST_END = 10
-- Config for Quests
Config.quests = { 
    [QUEST_PRIME_DIRECTIVE] = {
        title = "Point Insertion",
        description = "Obtain a Ration.",
        reward = function(ply)
            ply:AddXP(10)
            ply:Notify("You received  10 XP for completing the quest!")
        end,
    },
    [QUEST_DEPOSIT] = { 
        title = "Getting Started",
        description = "Use a ration credit card on a Civic Terminal.",
        reward = function(ply)
            ply:AddXP(15)
            ply:Notify("You received 25 XP for completing the quest")
        end,
    },
    [QUEST_START_SOMEWHERE] = {
        title = "Gotta Start Somewhere",
        description = "Dismantle a Water Can",
        reward = function(ply)
            ply:AddXP(15)
            ply:Notify("You received 15 XP for completing the quest!")
        end,
    },
    [QUEST_HOME_SWEET_HOME] = {
        title = "Home Sweet Home",
        description = "Obtain an apartment.",
        reward = function(ply)
            ply:AddXP(15)
            ply:Notify("You received 20 XP for completing the quest!")
        end,
    },
    [QUEST_STORAGE] = {
        title = "Safe Keeping",
        description = "Store an item using the Storage Box.",
        reward = function(ply)
            ply:AddXP(20)
            ply:GiveMoney(70)
            ply:Notify("You received 20 XP and 75 Credits for completing the quest!")
        end,
    },
    [QUEST_SCAV] = {
        title = "Another mans Treasure",
        description = "Find a Trash Pile and scavenge through it.",
        reward = function(ply)
            ply:AddXP(35)
            ply:GiveMoney(20)
            ply:Notify("You received 35 XP and 20 Credits for completing the quest!")
        end,
    },
    [QUEST_RISKY_TOOLS] = {
        title = "Taking Risks",
        description = "Craft an Axe.",
        reward = function(ply)
            ply:AddXP(75)
            ply:GiveMoney(95)
            ply:Notify("You received 75 XP and 95 Credits for completing the quest!")
        end,
    },
    [QUEST_MOONSHINE] = {
        title = "Troubles Brewing",
        description = "Purchase Yeast, Sparkling Water, Spices, and a brewery and make moonshine.",
        reward = function(ply)
            ply:AddXP(100)
            ply:Notify("You received 125 XP for completing the quest!")
        end,
    },
    [QUEST_404] = {
        title = "Anti-citizen One",
        description = "Exit The City.",
        reward = function(ply)
            ply:AddXP(125)
            ply:Notify("You received 125 XP for completing the quest!")
        end,
    },
    [QUEST_END] = {
        title = "None",
        description = "You have no more quests to Complete at this time."
    }
}
