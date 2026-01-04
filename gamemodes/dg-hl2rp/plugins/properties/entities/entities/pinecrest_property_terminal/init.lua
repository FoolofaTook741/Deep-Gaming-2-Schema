AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
    self:SetModel( "models/props_combine/combine_interface001a.mdl" )
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( SOLID_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )
    self:DrawShadow( false )


    if self.impulseSaveKeyValue then
        if self.impulseSaveKeyValue[ "Door" ] then
            self:SetDoor( self.impulseSaveKeyValue[ "Door" ] )
            impulse.Properties.Terminals[ self:GetDoor() ] = self
        end
        if self.impulseSaveKeyValue[ "PropertyIndex" ] then
            self:SetPropertyIndex( self.impulseSaveKeyValue[ "PropertyIndex" ] )
        end
	else
        self:SetColor(Color(255,0,0,255))
    end

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:EnableMotion( false )
    end
end

function ENT:Use( ply )
    if not IsValid( ply ) then return end

    if not self:GetDoor() then return end

    ply:OpenPanel( "Pinecrest.PropertyTerminal" )
end


function ENT:KeyValue(key, value)
    if key == "Door" then
        self:SetDoor( value )
        impulse.Properties.Terminals[ self:GetDoor() ] = self
    end
end