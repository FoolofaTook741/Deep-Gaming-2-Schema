VyHub.Group = VyHub.Group or {}

function VyHub.Group:get(groupname)
    if VyHub.groups_mapped == nil then
        return nil
    end

    return VyHub.groups_mapped[groupname]
end