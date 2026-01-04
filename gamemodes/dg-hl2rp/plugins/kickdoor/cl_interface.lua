hook.Add("DoorMenuAddOptions", "impulseHL2RPDoorKickDoorOption", function(panel, door, doorOwners, doorGroup, doorBuyable)
	if (door:IsPropDoor() or not LocalPlayer():CanLockUnlockDoor(doorOwners, doorGroup)) and LocalPlayer():Team() == TEAM_CP then
		panel:AddAction("impulse/icons/clenched-fist-256.png", "Kick Door", function()
			LocalPlayer():ConCommand("say /kickdoor")

			panel:Remove()
		end)
	end
end)

hook.Add("DoorMenuAddOptions", "impulseHL2RPDoorBashDoorOption", function(panel, door, doorOwners, doorGroup, doorBuyable)
	if (door:IsPropDoor() or not LocalPlayer():CanLockUnlockDoor(doorOwners, doorGroup)) and LocalPlayer():Team() == TEAM_OTA then
		panel:AddAction("impulse/icons/clenched-fist-256.png", "Bash Door", function()
			LocalPlayer():ConCommand("say /bashdoor")

			panel:Remove()
		end)
	end
end)

hook.Add("DoorMenuAddOptions", "impulseHL2RPDoorBashDoorOption", function(panel, door, doorOwners, doorGroup, doorBuyable)
	if (door:IsPropDoor() or not LocalPlayer():CanLockUnlockDoor(doorOwners, doorGroup)) and LocalPlayer():Team() == TEAM_ZOMBIE then
		panel:AddAction("impulse/icons/clenched-fist-256.png", "Tear Down Door", function()
			LocalPlayer():ConCommand("say /teardowndoor")

			panel:Remove()
		end)
	end
end)