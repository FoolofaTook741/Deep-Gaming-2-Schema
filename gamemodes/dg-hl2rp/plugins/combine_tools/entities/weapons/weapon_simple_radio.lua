if SERVER then
    AddCSLuaFile()
end

SWEP.Base        = "weapon_base"
SWEP.PrintName   = "Radio"
SWEP.Author      = "Abarden"
SWEP.Spawnable   = true
SWEP.Category = "Pinnacle"
SWEP.IsAlwaysRaised = true
SWEP.UseHands    = true
SWEP.ViewModel   = "models/radio/c_radio.mdl"
SWEP.WorldModel  = "models/radio/w_radio.mdl"

SWEP.Primary.ClipSize   = -1
SWEP.Primary.DefaultClip= -1
SWEP.Primary.Automatic  = false
SWEP.Primary.Ammo       = "none"
SWEP.Secondary          = { ClipSize=-1, DefaultClip=-1, Automatic=false, Ammo="none" }

local RADIO_MAX_CHANNELS = 3
local CHANNEL_NAMES = { [1]="PT", [2]="TEAM", [3]="COMMAND" }

function SWEP:Initialize()
    local ply = self:GetOwner()

    self.OnSoundPlayed = false
    self.OffSoundPlayed = false
    self.RadioActive = false
    self.VoiceActive = false
	
    if SERVER and IsValid(ply) then
		ply:SetSyncVar(SYNC_RADIO_LISTEN, true, true)
		ply:SetSyncVar(SYNC_RADIO_CHANNEL, 1, true)
	end
end

function SWEP:Equip(ply)
    ply:Notify("Press 'R' to Cycle through the radio's Channels, use the LMB to speak on the channel.")

    if SERVER and IsValid(ply) then
        ply:SetSyncVar(SYNC_RADIO_LISTEN, true, true)
        if ply:GetSyncVar(SYNC_RADIO_CHANNEL, nil) == nil then
            ply:SetSyncVar(SYNC_RADIO_CHANNEL, 1, true)
        end
    end
end

function SWEP:PrimaryAttack()
    self.OnSoundPlayed = false
    self:SetNextPrimaryFire(CurTime() + 0.1)
end

function SWEP:SecondaryAttack()
    self:SetNextPrimaryFire(CurTime() + 0.1)
end

function SWEP:OnRemove()
    local ply = self:GetOwner()
    if SERVER and IsValid(ply) then
        ply:SetSyncVar(SYNC_RADIO_LISTEN, false, true)
    end
end

function SWEP:Think()
    local ply = self:GetOwner()
    if not IsValid(ply) or ply:GetActiveWeapon() ~= self then return end

    if SERVER then
        local down = ply:KeyDown(IN_ATTACK)
        if down ~= self.RadioActive then
            self.RadioActive = down
            ply:SetSyncVar(SYNC_RADIO_TALK, down, true)

            local chan = ply:GetSyncVar(SYNC_RADIO_CHANNEL, 1)
            for _, v in ipairs(player.GetAll()) do
                if v:GetSyncVar(SYNC_RADIO_LISTEN, false) and v:GetSyncVar(SYNC_RADIO_CHANNEL, 1) == chan then
                    if down and not self.OnSoundPlayed then
                        self.OnSoundPlayed = true
                        net.Start("PGVoiceRadioOn")
                        net.Send(v)
                    elseif not down and not self.OffSoundPlayed then
                        self.OffSoundPlayed = true
                        net.Start("PGVoiceRadioOff")
                        net.Send(v)
                    end
                end
            end

            if down then
                self.OffSoundPlayed = false
            else
                self.OnSoundPlayed = false
            end
        end
    end

    if CLIENT then
        local down = ply:KeyDown(IN_ATTACK)
        if down ~= self.VoiceActive then
            self.VoiceActive = down
            permissions.EnableVoiceChat(down)
        end
    end
end

function SWEP:Reload()
    if self.NextReloadTime and CurTime() < self.NextReloadTime then return true end
    self.NextReloadTime = CurTime() + 0.2

    if SERVER then
        local ply = self:GetOwner()
        local old = ply:GetSyncVar(SYNC_RADIO_CHANNEL, 1)
        local nxt = (old % RADIO_MAX_CHANNELS) + 1
        ply:SetSyncVar(SYNC_RADIO_CHANNEL, nxt, true)
        ply:Notify(("Radio channel set to %s (%d)"):format(
            CHANNEL_NAMES[nxt], nxt
        ))
    end

    return true
end

--[[hook.Add("HUDPaint", "ImpulseRadioTransmittingText", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local wep = ply:GetActiveWeapon()
    if not IsValid(wep) or wep:GetClass() ~= "weapon_simple_radio" then return end

    local text = "Transmission: Inactive"

    if input.IsMouseDown(MOUSE_LEFT) then text = "Transmission: Active" end

    surface.SetFont("DermaLarge")
    local tw, th = surface.GetTextSize(text)
    draw.SimpleText(text, "DermaLarge", ScrW() / 2, 75, Color(255, 220, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end)]]
