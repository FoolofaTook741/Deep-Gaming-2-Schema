local ITEM = {}

ITEM.UniqueID = "book_chinese"
ITEM.Name = "Chinese Textbook"
ITEM.Desc = "A textbook used to learn the Chinese language [This will overwrite any language you know]."
ITEM.Model = Model("models/props_lab/binderredlabel.mdl")
ITEM.Category = "Books"
ITEM.FOV = 23.918338108883
ITEM.CamPos = Vector(-1.1461317539215, 25.21489906311, 63.037250518799)
ITEM.Weight = 0.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.CraftSound = "metal"
ITEM.CraftTime = 0.2

ITEM.UseName = "Read"
ITEM.UseWorkBarTime = 30
ITEM.UseWorkBarName = "Reading..."
ITEM.UseWorkBarSound = "physics/metal/paintcan_impact_hard3.wav"

function ITEM:CanUse(ply)
    if ply:Team() != TEAM_ZOMBIE then
        return true
    end
end

function ITEM:OnUse(ply)
    ply:LearnLanguage(LANG_CHINESE)
    ply:Notify("You can now speak fluent Chinese. Remember, it is illegal to speak foreign languages in front of Combine personnel.")
    return true
end

impulse.RegisterItem(ITEM)
