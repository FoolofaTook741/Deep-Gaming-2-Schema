local MIX = {}

MIX.Class = "ration_1"

MIX.Level = 1
MIX.Bench = "cwu"

MIX.Output = "ration_civ"
MIX.Input = {
  ["food_bread"] = {take = 1},
  ["food_water"] = {take = 1}
}

impulse.RegisterMixture(MIX)
