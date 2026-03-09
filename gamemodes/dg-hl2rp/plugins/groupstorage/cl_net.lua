net.Receive("deepGroupStorageOpen", function(len)
    impulse_group_storage = vgui.Create("deepGroupInventory")
end)

net.Receive("deepGroupStorageSync", function()
	local isDelete = net.ReadBool()
	
    impulse.Inventory = impulse.Inventory or {}
    impulse.Inventory.Group = impulse.Inventory.Group or {}
    impulse.Inventory.Group.Data = impulse.Inventory.Group.Data or {}
    impulse.Inventory.Group.Data[0] = impulse.Inventory.Group.Data[0] or {}
	
    if isDelete then
        impulse.Inventory.Group.Data[0][3] = nil

        if impulse_group_storage and IsValid(impulse_group_storage) then
            impulse_group_storage:SetupItems(0, 0)
        end
        return
    end
	
	local count = net.ReadUInt(16)
	local tbl   = {}
	for i = 1, count do
	  local slot = net.ReadUInt(16)
	  local id   = net.ReadUInt(16)
	  local r    = net.ReadBool()
	  local e    = net.ReadBool()
	  tbl[slot] = { id = id, restricted = r, equipped = e }
	end
    impulse.Inventory = impulse.Inventory or {}
    impulse.Inventory.Group = impulse.Inventory.Group or {}
    impulse.Inventory.Group.Data = impulse.Inventory.Group.Data or {}

    impulse.Inventory.Group.Data[0] = impulse.Inventory.Group.Data[0] or {}
    impulse.Inventory.Group.Data[0][3] = tbl

    if impulse_group_storage and IsValid(impulse_group_storage) then
        local invScroll = impulse_group_storage.invScroll:GetVBar():GetScroll()
        local invStorageScroll = impulse_group_storage.invStorageScroll:GetVBar():GetScroll()
        impulse_group_storage:SetupItems(invScroll, invStorageScroll)
    end
end)

net.Receive("deepGroupinvMove", function()
  local count    = net.ReadUInt(8)
  local mover    = net.ReadEntity()

  impulse.Inventory = impulse.Inventory or {}
  impulse.Inventory.Data = impulse.Inventory.Data  or {}
  impulse.Inventory.Data[0] = impulse.Inventory.Data[0]   or {}
  impulse.Inventory.Data[0][1] = impulse.Inventory.Data[0][1] or {}

  impulse.Inventory.Group = impulse.Inventory.Group or {}
  impulse.Inventory.Group.Data = impulse.Inventory.Group.Data or {}
  impulse.Inventory.Group.Data[0] = impulse.Inventory.Group.Data[0]    or {}
  impulse.Inventory.Group.Data[0][3] = impulse.Inventory.Group.Data[0][3] or {}

  local personalTbl = impulse.Inventory.Data[0][1]
  local groupTbl = impulse.Inventory.Group.Data[0][3]

  for i = 1, count do
    local invid = net.ReadUInt(16)
    local newinvid = net.ReadUInt(16)
    local from = net.ReadUInt(4)
    local to = net.ReadUInt(4)
    local id = net.ReadUInt(16)

    if from == 3 then
      groupTbl[invid] = nil
    elseif mover == LocalPlayer() then
      personalTbl[invid] = nil
    end

    local entry = { id = id}

    if to == 3 then
      groupTbl[newinvid] = entry
    elseif mover == LocalPlayer() then
      personalTbl[newinvid] = entry
    end
  end

  impulse.Inventory.Data[0][1] = personalTbl
  impulse.Inventory.Group.Data[0][3] = groupTbl

  if impulse_group_storage and IsValid(impulse_group_storage) then
    local s1 = impulse_group_storage.invScroll:GetVBar():GetScroll()
    local s2 = impulse_group_storage.invStorageScroll:GetVBar():GetScroll()
    impulse_group_storage:SetupItems(s1, s2)
    surface.PlaySound("physics/wood/wood_crate_impact_hard2.wav")
  end
end)

net.Receive("impulseGroupStorageTierSync", function()
    local tier = net.ReadUInt(4)

    if impulse.Group.Groups[1] then
        impulse.Group.Groups[1].StorageTier = tier
    end

    if IsValid(impulse.groupEditor) then
        impulse.groupEditor:Refresh()
    end
end)


