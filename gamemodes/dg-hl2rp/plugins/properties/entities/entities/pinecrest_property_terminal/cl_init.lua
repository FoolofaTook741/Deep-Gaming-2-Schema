include("shared.lua")

function ENT:Initialize()
    timer.Simple( 3, function()
        impulse.Properties.Terminals[ self:GetDoor() ] = self
    end )
end

function ENT:HasOwner()
    local curOwner = Entity( self:GetSillyOwner() )
    
    if IsValid( curOwner ) and curOwner:IsPlayer() then
        return true
    end

    return false
end

function ENT:GetTerminalOwner()
    local curOwner = Entity( self:GetSillyOwner() ) -- ent index
    
    if IsValid( curOwner ) and curOwner:IsPlayer() then
        return curOwner
    end

    return nil
end

local terminalCol = Color(0, 100, 200, 255)
function ENT:Draw()
    self:DrawModel()

    if not istable( impulse.Properties.PropertyData[self:GetDoor()] ) then
        return
    end

    
    local displayText = "INDEX: " .. self:EntIndex() .. "\n"
    displayText = displayText .. "NAME: \n"-- .. impulse.Buildings.Data[self:GetTag()].name .. "\n"
    displayText = displayText .. "PRICE: " --.. impulse.Buildings.Data[self:GetTag()].cost

    if self:HasOwner() then
        terminalCol = Color(200, 0, 0, 255)
        displayText = displayText .. "\n\nOWNER: "-- .. self:GetTerminalOwner():Name()
    else
        displayText = displayText .. "\n\nVACANT!"
    end
    local entPos = self:GetPos()
	local entAng = self:GetAngles()
	local pos = self:GetPos()
	local ang = self:GetAngles()

	pos = pos + (ang:Up() * 48.1)
	pos = pos + (ang:Forward() * -2.36)
	pos = pos + (ang:Right() * 9.8)

	ang:RotateAroundAxis(entAng:Up(), 90)
	ang:RotateAroundAxis(entAng:Right(), -42)

	cam.Start3D2D(pos, ang, 0.07)
		surface.SetDrawColor(terminalCol)
		surface.DrawRect(0, 0, 221, 115)
		draw.DrawText(displayText, "DebugFixed", 8, 4, color_white, TEXT_ALIGN_LEFT)
	cam.End3D2D()
end

ENT.OffsetVertical3D2D = 9
ENT.OffsetHorizontal3D2D = 12

