local VENDOR = {}

VENDOR.UniqueID = "civvendor"
VENDOR.Name = "Citizen O.C.A Permits"
VENDOR.Desc = "Distributes permits when O.C.A members aren't online."

VENDOR.Model = "models/taggart/gallahan.mdl"
VENDOR.Skin = 0
VENDOR.Bodygroups = "0"
VENDOR.Gender = "male" -- male, female, cp
VENDOR.Talk = true

VENDOR.Sell = {
    ["item_constructionpermit"] = {
        Desc = "Admin Branch - 4/2 minutes",
        Cost = 15,
        BuyMax = 1,
        TempCooldown = 86400,
    },
    ["item_metalpermit"] = {
        Desc = "Admin Branch - 4/2 minutes",
        Cost = 20,
        BuyMax = 1,
        TempCooldown = 86400,
    },
    ["item_outdoorspermit"] = {
        Desc = "Admin Branch - 4/2 minutes",
        Cost = 15,
        BuyMax = 1,
        TempCooldown = 86400,
    },
    ["item_miningpermit"] = {
        Desc = "Admin Branch - 1/2 minutes",
        Cost = 90,
        BuyMax = 1,
        TempCooldown = 86400,
    },
    ["item_lumberjackpermit"] = {
        Desc = "Admin Branch - 1/2 minutes",
        Cost = 90,
        BuyMax = 1,
        TempCooldown = 86400,
    },
    ["item_cleaverpermit"] = {
        Desc = "Admin Branch - 1/2 minutes",
        Cost = 90,
        BuyMax = 1,
        TempCooldown = 86400,
    },
    ["item_homerefinerypermit"] = {
        Desc = "Admin Branch - 1/2 minutes",
        Cost = 90,
        BuyMax = 1,
        TempCooldown = 86400,
    },
    ["item_alcoholpermit"] = {
        Desc = "Admin Branch - 2/2 minutes",
        Cost = 20,
        BuyMax = 2,
        TempCooldown = 86400,
    },
    ["item_generatorpermit"] = {
        Desc = "Admin Branch - 3/2 minutes",
        Cost = 40,
        BuyMax = 1,
        TempCooldown = 86400,
    },
    ["book_italian"] = {
        Desc = "Admin Branch Councilman+ - 1/60 minutes",
        Cost = 3000,
        BuyMax = 1,
        TempCooldown = 86400,
    },
    ["book_german"] = {
        Desc = "Admin Branch Exec+ - 1/60 minutes",
        Cost = 3000,
        BuyMax = 1,
        TempCooldown = 86400,
    },
}


local function IsRepresentativeOrAbove(class)
    return class >= CLASS_REPRESENTATIVE
end

function VENDOR:CanUse(ply)
    if ply:IsCP() then
        return false
    end

    for _, v in ipairs(player.GetAll()) do
        if v:Team() == TEAM_CA and IsRepresentativeOrAbove(v:GetClass()) then
            ply:Notify("There are currently O.C.A members online, go and see them.")
            return false
        end
    end
    return true
end

impulse.RegisterVendor(VENDOR)