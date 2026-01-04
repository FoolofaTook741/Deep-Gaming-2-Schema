local MIX = {}

MIX.Class = "ration_3"

MIX.Level = 1
MIX.Bench = "cwu"

MIX.Output = "ration_vort"
MIX.Input = {
  ["food_bread"] = {take = 1}
}

impulse.RegisterMixture(MIX)
