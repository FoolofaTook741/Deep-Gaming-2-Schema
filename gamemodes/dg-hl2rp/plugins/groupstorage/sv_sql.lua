function impulse.Inventory.GroupDBAddItem(ownerid, class, storageType)
	local query = mysql:Insert("impulse_group_inventory")
	query:Insert("uniqueid", class)
	query:Insert("groupid", ownerid)
	query:Insert("storagetype", storageType or 3)
	query:Execute()
	
    local grp = impulse.Inventory.Group.Data[ownerid]
    if grp and grp.Register then
        grp.Register[class] = (grp.Register[class] or 0) + 1
    end
end

function impulse.Inventory.GroupDBRemoveItem(ownerid, class, storetype, limit)
	local query = mysql:Delete("impulse_group_inventory")
	query:Where("groupid", ownerid)
	query:Where("uniqueid", class)
	query:Where("storagetype", storetype or 3)
	query:Limit(limit or 1)
	query:Execute()
	
	local grp = impulse.Inventory.Group.Data[ownerid]
    if grp and grp.Register and grp.Register[class] then
        grp.Register[class] = grp.Register[class] - 1
        if grp.Register[class] <= 0 then
            grp.Register[class] = nil
        end
    end
end