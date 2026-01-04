local meta_ply = FindMetaTable("Player")

VyHub.user_id = VyHub.user_id or nil

function meta_ply:VyHubID()
    if IsValid(self) then
        if self == LocalPlayer() then        
            return VyHub.user_id
        else
            MsgN("ERROR: Cannot get VyHubID of other users on the client side.")
        end
    end
end

net.Receive("vyhub_user_id", function ()
    VyHub.user_id = net.ReadString()
end)
