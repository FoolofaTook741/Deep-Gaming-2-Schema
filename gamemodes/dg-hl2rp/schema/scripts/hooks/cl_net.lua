netstream.Hook("voicePlay", function(sounds, volume, index)
	if index then
		local client = Entity(index)

		if (IsValid(client)) then
			client:EmitQueuedSounds(sounds, nil, nil, volume)
		end
	else
		--table.insert(sounds, 1, "npc/overwatch/radiovoice/on1.wav")
		--table.insert(sounds, "npc/overwatch/radiovoice/off4.wav")
		LocalPlayer():EmitQueuedSounds(sounds, nil, nil, volume)
	end
end)

net.Receive("impulseHL2RPTerminal", function()
	local terminal = vgui.Create("impulseTerminalMenu") 
	local arrestedPly = net.ReadUInt(8)

	if arrestedPly != 0 then
		terminal.ArrestedPlayer = Entity(arrestedPly)
	end
	
	terminal:SetupUI()
end)

net.Receive("impulseHL2RPTerminalConvict", function()
	local terminal = vgui.Create("impulseTerminalMenu")
	local arrestedPly = net.ReadUInt(8)
	local loopCount = net.ReadUInt(8)
	local convicts = {}

	for i = 1, loopCount do
		local convict = net.ReadEntity()
		local cell = net.ReadUInt(8)
		local cycles = net.ReadUInt(8)
		local endTime = net.ReadUInt(32)

		if IsValid(convict) and convict:IsPlayer() then
			convicts[convict] = {
				cell = cell,
				cycles = cycles,
				endTime = endTime
			}
		end
	end

	terminal.Convicts = convicts

	if arrestedPly != 0 then
		terminal.ArrestedPlayer = Entity(arrestedPly)
	end
	
	terminal:SetupUI()
end)

net.Receive("impulseHL2RPRankUse", function()
	vgui.Create("impulseRankMenu")
end)

net.Receive("impulseHL2RPOpenLocker", function()
	vgui.Create("impulseLockerMenu")
end)

net.Receive("impulseHL2RPChargesGet", function()
	local charges = net.ReadTable()
	local reasons = "CHARGES:\n\n"

	for v,k in pairs(charges) do
		reasons = reasons..impulse.Config.ArrestCharges[k].name.."\n"
	end

	local panel = Derma_Message(reasons, "", "CLOSE")
	panel:SetSkin("combine")
end)

net.Receive("impulseHL2RPScavengerWorkbar", function()
    impulse.MakeWorkbar(impulse.Config.ScavengeTime, "Scavenging...", function() end, true)
end)

net.Receive("impulseHL2RPTearGasFX", function()
	impulse_beingGassed = CurTime() + 6.4
end)

local damageSent = {
	[1] = "The corpse has sustained blunt damage.",
	[2] = "The corpse has several bullet entry and exit wounds. Bullet fragments are still present in the body.",
	[3] = "The corpse has burn marks and shrapnel entry wounds. Possibly caused by an explosion.",
	[4] = "The corpse has broken and fractured legs. The torso is severely bruised."
}

local wepDesc = {
	["plutonic_mp7"] = "The corpse contains 4.65mm rounds.",
	["plutonic_m60"] = "The corpse contains 7.62mm rounds.",
	["plutonic_357"] = "The corpse contains .357 rounds.",
	["plutonic_g3a3"] = "The corpse contains 7.62mm rounds.",
	["plutonic_spas12"] = "The corpse has been ripped apart by buckshot rounds.",
	["plutonic_ar2"] = "The corpse has been pentrated by a high energy round which has left burn marks.",
	["plutonic_pickaxe"] = "The skull has a missing fragment and has partially ruptured.",
	["plutonic_axe"] = "The corpse has been hacked and slashed.",
	["plutonic_doublebarrel"] = "The torso has been seperated from the legs by several buckshot shells.",
	["plutonic_goldengun"] = "The corpse contains 24 carrat gold .357 rounds.",
	["plutonic_stunstick"] = "The corpse has several burn wounds commonly created by contact with a charged stun baton.",
	["plutonic_usp"] = "The corpse contains 9mm rounds.",
	["plutonic_vort"] = "The corpse has sustained electrical and plasma burns by an extremely powerful force."
}
net.Receive("impulseHL2RPInspectBodyComplete", function()
	local wasFall = net.ReadBool()
	local wep = net.ReadString()
	local killer = net.ReadString()
	local msg = "The inspection of the body has revealed the following:\n"
	local wDesc = wepDesc[wep]
	local dmgType = 3

	if wep == "plutonic_axe" or wep == "plutonic_pickaxe" or wep == "plutonic_stunstick" then
		dmgType = 1
	elseif wDesc then
		dmgType = 2
	elseif wasFall then
		dmgType = 4
	end

	msg = msg..damageSent[dmgType]

	if wDesc then
		msg = msg.."\n"..wDesc
	end

	if killer != "" then
		msg = msg.."\n\nAfter review of the bodycam footage the suspect who killed this officer has been identified as "..killer.."."
		msg = msg.."\nThey have automatically been added to the BOL index."
	end

	Derma_Message(msg, "impulse", "Close")
	print(msg)
end)

net.Receive("impulseHL2RPVortessenceStart", function()
	local vortTime = net.ReadFloat()
	VORTESSENCE_EXPIRE = CurTime() + vortTime
	LocalPlayer():Notify("The effects of the vortessence have taken affect... It will last approximately "..string.NiceTime(vortTime)..".")
end)

net.Receive("impulseHL2RPTheatreControls", function()
	local m = vgui.Create("DFrame")
	m:SetSize(300, 400)
	m:Center()
	m:MakePopup()
	m:SetTitle("Theatre Console")

	local btn = vgui.Create("DButton", m)
	btn:SetText("Toggle curtain")
	btn:Dock(TOP)
	btn:SetTall(25)
	btn:DockMargin(0, 2, 0, 0)

	function btn:DoClick()
		net.Start("impulseHL2RPTheatreAction")
		net.WriteUInt(1, 8)
		net.WriteString("")
		net.SendToServer()
	end

	local btn = vgui.Create("DButton", m)
	btn:SetText("Turn on stage lights")
	btn:Dock(TOP)
	btn:SetTall(25)
	btn:DockMargin(0, 2, 0, 0)

	function btn:DoClick()
		net.Start("impulseHL2RPTheatreAction")
		net.WriteUInt(2, 8)
		net.WriteString("")
		net.SendToServer()
	end

	local btn = vgui.Create("DButton", m)
	btn:SetText("Turn off stage lights")
	btn:Dock(TOP)
	btn:SetTall(25)
	btn:DockMargin(0, 2, 0, 0)

	function btn:DoClick()
		net.Start("impulseHL2RPTheatreAction")
		net.WriteUInt(3, 8)
		net.WriteString("")
		net.SendToServer()
	end

	local music = vgui.Create("DComboBox", m)
	music:SetValue("Select music...")
	music:Dock(TOP)
	music:SetTall(25)
	music:DockMargin(0, 25, 0, 0)
	
	for v,k in pairs(impulse.Config.TheatreMusic) do
		music:AddChoice(v)
	end

	local btn = vgui.Create("DButton", m)
	btn:SetText("Play music")
	btn:Dock(TOP)
	btn:SetTall(25)
	btn:DockMargin(0, 4, 0, 0)

	function btn:DoClick()
		local song = music:GetValue()

		if song == "Select music..." then
			return LocalPlayer():Notify("Select a song first...")
		end

		net.Start("impulseHL2RPTheatreAction")
		net.WriteUInt(4, 8)
		net.WriteString(song)
		net.SendToServer()
	end

	local btn = vgui.Create("DButton", m)
	btn:SetText("Stop music")
	btn:Dock(TOP)
	btn:SetTall(25)
	btn:DockMargin(0, 2, 0, 0)

	function btn:DoClick()
		net.Start("impulseHL2RPTheatreAction")
		net.WriteUInt(5, 8)
		net.WriteString("")
		net.SendToServer()
	end
end)

net.Receive("impulseHL2RPPlayGlobalSound", function()
	local ply = net.ReadPlayer()
	local soundPath = net.ReadString()

	if not impulse.GetSetting("GlobalSounds") == true then
		return
	end

	if IsValid(ply) and ply:IsPlayer() then
		ply:EmitSound(soundPath, 75, 100, 1, CHAN_AUTO)
	end

end)

net.Receive("impulseHL2RPPlayDispatchSound", function()
	local ply = net.ReadPlayer()
	local soundPath = net.ReadString()

	if not impulse.GetSetting("AmbDispSounds") == true then
		return
	end

	if IsValid(ply) and ply:IsPlayer() then
		ply:EmitSound(soundPath, 75, 100, 1, CHAN_AUTO)
	end

end)
