impulse.Business.Define("Festive Radio", {
    entity = "impulse_hl2rp_xmasradio",
    model = "models/props_lab/citizenradio.mdl", -- old: models/props_junk/wood_crate002a.mdl
    description = "Plays festive music.",
    price = 65,
    refund = false
})

function PLUGIN:OnSchemaLoaded()
	impulse.Business.Data["Crate"].model = "models/katharsmodels/present/type-2/big/present2.mdl"
	impulse.Business.Data["Large Crate"].model = "models/katharsmodels/present/type-1/big/present3.mdl"
end