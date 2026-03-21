DYE_COLORS = DYE_COLORS or {
    ["Red"]     = Color(217, 30,  30 ),
    ["Blue"]    = Color(30,  70,  204),
    ["Green"]   = Color(38,  166, 51 ),
    ["Black"]   = Color(13,  13,  13 ),
    ["White"]   = Color(242, 242, 242),
    ["Yellow"]  = Color(229, 210, 26 ),
    ["Orange"]  = Color(229, 115, 13 ),
    ["Purple"]  = Color(128, 26,  191),
    ["Brown"]   = Color(107, 66,  38 ),
    ["Grey"]    = Color(128, 128, 128),
    ["Teal"]    = Color(26,  166, 153),
    ["Pink"]    = Color(219, 80,  145),
}

for colorName, _ in pairs(DYE_COLORS) do
    local ITEM = {}

    ITEM.UniqueID    = "item_dye_" .. string.lower(colorName)
    ITEM.Name        = colorName .. " Dye"
    ITEM.Desc        = "A bottle of " .. string.lower(colorName) .. " dye. Use it to color a piece of clothing. Consumed on use."
    ITEM.Category    = "Dyes"
    ITEM.Model       = Model("models/props_junk/garbage_metalcan001a.mdl") -- swap for a nicer prop
    ITEM.FOV         = 30
    ITEM.CamPos      = Vector(46.4, 20.6, 32.1)
    ITEM.Weight      = 0.2

    function ITEM:OnUse(client)
        net.Start("dye.OpenSlotPicker")
            net.WriteString(colorName)
        net.Send(client)

        return false
    end

    impulse.RegisterItem(ITEM)
end