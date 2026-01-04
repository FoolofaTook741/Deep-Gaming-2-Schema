
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

local PANEL = {}
local scrw, scrh = ScrW(), ScrH()
local sizew, sizeh = scrh / 2, scrh / 2

function PANEL:Init()

    local panel = self
	local lp = LocalPlayer()

	local trace = {}
	trace.start = lp:EyePos()
	trace.endpos = trace.start + lp:GetAimVector() * 85
	trace.filter = lp

	local tr = util.TraceLine( trace )

	if IsValid(tr.Entity) and tr.Entity:GetClass() == "pinecrest_property_terminal" then
		self.Entity = tr.Entity
	else
		return self:Remove()
	end

    self.Door = Entity( self.Entity:GetDoor() )
    self.DoorData = impulse.Properties.PropertyData[ impulse.Properties.FindByDoor( self.Entity:GetDoor() ) ]


    if not self.Door then
        return self:Remove()
    end

    self:SetSkin( "combine" )
    self:SetSize( sizew, sizeh )
    self:Center()
    self:MakePopup()
	self.lblTitle:SetFont("BudgetLabel")
	self.lblTitle:SetTextColor(color_white)
    self:SetTitle( self.DoorData.CustomName or self.DoorData.NiceName )
    self:SetPaintBackgroundEnabled(true)

    LocalPlayer():EmitSound( "ambient/machines/combine_terminal_idle2.wav" )


    self.Occupants = self.Door:GetSyncVar(SYNC_DOOR_OWNERS, {}) 

    ---- PlayerScroll for Occupant List ----
        self.PlayerScroll = vgui.Create( "DScrollPanel", self )
        self.PlayerScroll:SetSize( sizew - 80, 300 )
        self.PlayerScroll:SetPos( 40, 60 )

        for index, number in ipairs( self.Occupants ) do
            local ply = Entity( number )

            local plyButton = vgui.Create( "DButton", self )

            if index == 1 then
                plyButton:SetSize( sizew - 140, 54 / 2 )
                plyButton:Dock( TOP )
                plyButton:DockMargin(0, 0, 0, 8)
                plyButton:SetText( "OWNER:  " .. ply:Nick() )
                plyButton:SetContentAlignment( 4 ) 
                plyButton:SetTextInset( 32, 0 )
                plyButton:SetFont( "BudgetLabel" )
            else
                plyButton:SetSize( sizew - 140, 54 / 2 )
                plyButton:Dock( TOP )
                plyButton:DockMargin(0, 0, 0, 8)
                plyButton:SetText( "OCCUPANT:  " .. ply:Nick() )
                plyButton:SetContentAlignment( 4 ) 
                plyButton:SetTextInset( 32, 0 )
                plyButton:SetFont( "BudgetLabel" )
                function plyButton:DoClick()
                    
                    local Menu = DermaMenu()

                    Menu:AddOption( "Remove", function()

                        net.Start( "Pinecrest.RemovePropertyOwner" )
                        net.WriteEntity( ply )
                        net.SendToServer()
                        panel:Remove() 
                        
                    end )

                    Menu:Open()
                end
            end

            self.PlayerScroll:AddItem( plyButton )
        end
    ---- PlayerScroll for Occupant List ----



    ---- ButtonScroll for Management Buttons ----
        self.ButtonScroll = vgui.Create( "DScrollPanel", self )
        self.ButtonScroll:SetSize( sizew - 80, sizeh - 30 )
        self.ButtonScroll:SetPos( 40, (sizeh / 2) + 50 )

        self.BuyButton = vgui.Create( "DButton", self.ButtonScroll )
        self.BuyButton:SetSize( sizew - 140, 54 / 2 )
        self.BuyButton:Dock( TOP )
        self.BuyButton:DockMargin(0, 0, 0, 8)
        self.BuyButton:SetText( "PURCHASE PROPERTY  [" .. impulse.Config.CurrencyPrefix .. self.DoorData.Cost .. "]" )
        self.BuyButton:SetContentAlignment( 4 ) 
        self.BuyButton:SetTextInset( 16, 0 )
        self.BuyButton:SetFont( "BudgetLabel" )
        function self.BuyButton:DoClick()
            net.Start("Pinecrest.PurchaseProperty")
            net.SendToServer()
            panel:Remove()
        end
        function self.BuyButton:Think()
            if not LocalPlayer():CanBuyDoor( panel.Door:GetSyncVar( SYNC_DOOR_OWNERS, nil ), panel.Door:GetSyncVar( SYNC_DOOR_BUYABLE, true ) ) then
                panel.BuyButton:SetDisabled( true )
            end
        end


        self.SellButton = vgui.Create( "DButton", self.ButtonScroll )
        self.SellButton:SetSize( sizew - 140, 54 / 2 )
        self.SellButton:Dock( TOP )
        self.SellButton:DockMargin(0, 0, 0, 8)
        self.SellButton:SetText( "SELL PROPERTY" )
        self.SellButton:SetContentAlignment( 4 ) 
        self.SellButton:SetTextInset( 16, 0 )
        self.SellButton:SetFont( "BudgetLabel" )
        function self.SellButton:DoClick()
            net.Start("Pinecrest.SellProperty")
            net.SendToServer()
            panel:Remove()
        end

        self.AddButton = vgui.Create( "DButton", self.ButtonScroll )
        self.AddButton:SetSize( sizew - 140, 54 / 2 )
        self.AddButton:Dock( TOP )
        self.AddButton:DockMargin(0, 0, 0, 8)
        self.AddButton:SetText( "ADD OCCUPANTS" )
        self.AddButton:SetContentAlignment( 4 ) 
        self.AddButton:SetTextInset( 16, 0 )
        self.AddButton:SetFont( "BudgetLabel" )
        function self.AddButton:DoClick()

            local Menu = DermaMenu()
            local Exclude = {}
            local DoorOwners = panel.Door:GetSyncVar(SYNC_DOOR_OWNERS, nil) 

            if not DoorOwners then
                return
            end

            for I = 1, #DoorOwners do
                Exclude[ Entity( DoorOwners[ I ] ) ] = true
            end

            for _, plr in ipairs( player.GetAll() ) do

                if plr:IsCP() then
                    continue
                end

                if plr == LocalPlayer() then
                    continue
                end

                if Exclude[ plr ] then
                    continue
                end

                Menu:AddOption( plr:Nick(), function()
                    net.Start( "Pinecrest.AddPropertyOwner" )
                    net.WriteEntity( plr )
                    net.SendToServer()
                    panel:Remove() 
                end )

            end

            Menu:Open()

        end



        self.ButtonScroll:AddItem( self.BuyButton )
        self.ButtonScroll:AddItem( self.SellButton )
        self.ButtonScroll:AddItem( self.AddButton )
    ---- ButtonScroll for Management Buttons ----

end



vgui.Register( "Pinecrest.PropertyTerminal", PANEL, "DFrame" )
