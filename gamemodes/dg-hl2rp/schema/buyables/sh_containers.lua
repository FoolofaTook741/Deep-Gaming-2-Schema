impulse.Business.Define("Crate", {
    entity = "impulse_container",
    model = "models/props_junk/wood_crate001a_half.mdl",  -- old: models/props_junk/wood_crate001a.mdl
    description = "Can store 20KG worth of items.",
    price = 75,
    refund = true,
    postSpawn = function(ent, ply)
    	ent:SetCapacity(20)
    end
})

impulse.Business.Define("Large Crate", {
    entity = "impulse_container",
    model = "models/props_junk/wood_crate002a_half.mdl", -- old: models/props_junk/wood_crate002a.mdl
    description = "Can store 75kg worth of items.",
    price = 135,
    refund = true,
    postSpawn = function(ent, ply)
        ent:SetCapacity(75)
    end
})

impulse.Business.Define("Huge Crate", {
    entity = "impulse_container",
    model = "models/props_junk/wood_crate002a_half.mdl"
    --model = "models/props_junk/wood_crate001a.mdl", -- old: models/props_junk/wood_crate002a.mdl
    description = "Can store 180kg worth of items.",
    price = 300,
    refund = true,
    postSpawn = function(ent, ply)
        ent:SetCapacity(180)
    end
}) 