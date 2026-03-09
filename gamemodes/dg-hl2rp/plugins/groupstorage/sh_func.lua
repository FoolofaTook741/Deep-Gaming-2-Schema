function meta:IsInGroup()
    return self:ClientGetGroupID() ~= nil
end

function meta:ClientGetGroupID()
    local groupName = self:GetSyncVar(SYNC_GROUP_NAME, nil)
    if groupName and impulse.Group.Groups and impulse.Group.Groups[groupName] then
        local gid = impulse.Group.Groups[groupName].ID
        if gid then
            return tonumber(gid)
        end
    end
    return nil
end

function meta:GetMaxGroupInventoryStorage()
    local groupData = impulse.Group.Groups[1]
    if not groupData or not groupData.Members then 
        return 0
    end
    local memberCount = 0
    for _ in pairs(groupData.Members) do
        memberCount = memberCount + 1
    end
    
    local kgPerMember = 5
    local baseStorage = math.min(memberCount * kgPerMember, 250)

    local tier = groupData.StorageTier or 0
    return baseStorage + (tier * 50)
end