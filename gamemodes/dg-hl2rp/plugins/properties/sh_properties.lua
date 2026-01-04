
--[[ 
    Copyright (c) 2024; Dylan L.
    
    Created by mage_tearz@protonmail.com // github.com/mage-tearz

    Made for Pinecrest Project Half-Life 2 Roleplay;
    intended for use with the impulse framework.

    -- TERMS OF USE --
    The 'Code' is defined as any unique code or scripts found within this file which have been created by the author(s).

    You are required to include this entire Copyright notice in all copies of the Code.
    You are required to have prior written authorization from the original author(s) in order to share, sell, or distribute the Code.
    You are required to have prior written authorization from the original author(s) in order to use the Code in a multi-player game server.
    You are required to have prior written authorization from the original author(s) in order to share, sell, or distribute works derived from the Code.
    By using the Code, you agree to the TERMS OF USE.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
    INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
    OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    
    Failiure to comply with the TERMS OF USE is considered Copyright Infringement under 17 U.S. Code § 501.
]]

impulse.Properties = impulse.Properties or {}
impulse.Properties.PropertyData = impulse.Properties.PropertyData or {}
impulse.Properties.Terminals = impulse.Properties.Terminals or {}
local PropertyID = 0

function impulse.Properties.RegisterProperty( Data )
    
    PropertyID = PropertyID + 1

    Data.Doors = {}

    for Index, Pos in ipairs( Data.DoorPos ) do

        for _, Ent in ipairs( ents.FindInBox( Pos, Pos ) ) do
 
            if ( Ent:GetClass() != "func_door" ) and ( Ent:GetClass() != "prop_door_rotating" ) then
                continue
            end

            Data.Doors[ Index ] = Ent:EntIndex()
            break
        end
    end

    Data.DoorPos = nil
    impulse.Properties.PropertyData[ PropertyID ] = Data
    return PropertyID
end

function impulse.Properties.FindByDoor( Door )
    for Index, Data in ipairs( impulse.Properties.PropertyData ) do

        if table.HasValue( Data[ "Doors" ], Door ) then
            return Index
        end

    end
end 

function impulse.Properties.FindByProperty( Property )
    return impulse.Properties.PropertyData[ Property ].Doors
end

function impulse.Properties.FindFellowDoors( Door )
    return impulse.Properties.FindByProperty( impulse.Properties.FindByDoor( Door ) )
end
