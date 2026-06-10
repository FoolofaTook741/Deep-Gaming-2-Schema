impulse.DefineSetting("hudselection", {name="HUD Type", category="HUD", type="dropdown", options={"impulse - Original", "Pinnacle", "Deep - Standard", "Deep - Minimalistic", "Landis (Requires Horizons Content)", "Hidden - No HUD"}, default="impulse - Original"})
impulse.DefineSetting("bootskip", {name="Skip Bootup Sequence", category="HUD", type="tickbox", default=false})
impulse.DefineSetting("dispbootskip", {name="Dispatch Skip Bootup Sequence", category="HUD", type="tickbox", default=false})
--impulse.DefineSetting("showquests", {name="Show Quest Display", category="HUD", type="tickbox", default=true})

impulse.DefineSetting("firstperson_fov", {name="Viewmodel FOV", category="View", type="slider", default=0, minValue=0, maxValue=60})

impulse.DefineSetting("lightmap_redownloading", {name="Lightmap Redownloading", category="Performance", type="tickbox", default=false})

impulse.DefineSetting("GlobalSounds", {name="Random Ambient Sounds", category="Music", type="tickbox", default=false})
impulse.DefineSetting("AmbDispSounds", {name="Ambient Dispatch Alerts", category="Music", type="tickbox", default=false})

impulse.DefineSetting("SqDOutline", {name="(Combine) Squad Outline", category="Halos", type="tickbox", default=true})
impulse.DefineSetting("team_ESP", {name="(Combine) Team ESP", category="Halos", type="tickbox", default=true})
impulse.DefineSetting("faction_ESP", {name="(Combine) Faction ESP", category="Halos", type="tickbox", default=true})
impulse.DefineSetting("group_ESP", {name="(Group) Group ESP", category="Halos", type="tickbox", default=true})
impulse.DefineSetting("cwu_group_ESP", {name="(CWU) Group ESP", category="Halos", type="tickbox", default=true})
impulse.DefineSetting("show_scanner_targets", {name="(Combine) Show City Scanner Targets", category="Halos", type="tickbox", default=true})
