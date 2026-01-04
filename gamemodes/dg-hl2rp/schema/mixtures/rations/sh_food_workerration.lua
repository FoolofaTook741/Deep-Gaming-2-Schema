local MIX = {}

MIX.Class = "ration_2"

MIX.Level = 1
MIX.Bench = "cwu"

MIX.Output = "ration_cwu"
MIX.Input = {
  ["food_bread"] = {take = 1},
  ["food_noodles"] = {take = 1}
}

impulse.RegisterMixture(MIX)
