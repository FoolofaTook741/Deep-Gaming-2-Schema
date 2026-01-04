local MIX = {}

MIX.Class = "pcam"

MIX.Level = 1
MIX.Bench = "General"

MIX.Output = "portablecam"
MIX.Input = {
  [""] = {take = 1}
}

impulse.RegisterMixture(MIX)
