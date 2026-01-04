--[[
    So they said something about my pfp? 
    Now i wanna curse my code
    So now every time when you use my guns, you will be called as OwOner
    Live with it

    Best regards 
    Wallace
]]
local meta = FindMetaTable("Entity")
function meta:GetOwOner()
	return self:GetOwner()
end

if SERVER then
    function meta:SetOwOner(owoner)
        self:SetOwner(owoner)
    end
end