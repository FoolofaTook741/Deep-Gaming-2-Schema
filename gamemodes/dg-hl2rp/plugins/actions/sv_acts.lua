util.AddNetworkString("impulseListActions")


local ACTS_CITIZEN = { -- ABSOLUTELY NO LAY ANIMATIONS OR ANYTHING THAT MASSIVELY HINDERS HITBOX
    ["lean1"] = {
		animation = "willard_male_male_lean01",
		time = 0,
        female = "willard_female_lean01"
	},
    ["lean2"] = {
		animation = "willard_male_male_lean02",
		time = 0,
        female = "willard_female_lean02"
	},
    ["sit1"] = {
		animation = "willard_male_male_sit01",
		time = 0,
        female = "willard_female_sit01"
	},
    ["sit2"] = {
		animation = "willard_male_male_sit02",
		time = 0,
        female = "willard_female_sit02"
	},
    ["sit3"] = {
		animation = "willard_male_male_sit04",
		time = 0,
        female = "willard_female_sit04"
	},
    ["sit4"] = {
		animation = "willard_male_male_sit05",
		time = 0,
        female = "willard_female_sit05"
	},
    ["surrender"] = {
        animation = "willard_male_male_handsup",
        time = 0,
        female = "willard_female_handsup"
    },
    ["injured"] = {
        animation = "willard_male_male_injured",
        time = 0,
        female = "willard_female_injured"
    },
    ["sit_ground"] = {
		animation = "willard_male_male_sit_ground",
		time = 0,
        female = "willard_female_sit_ground"
	},
    ["sit_wall"] = {
		animation = "willard_male_male_sitwall",
		time = 0,
        female = "willard_female_sitwall"
	},
    ["stand1"] = {
		animation = "willard_male_male_stand05",
		time = 0,
        female = "willard_female_stand05"
	},
    ["stand2"] = {
		animation = "willard_male_male_stand04",
		time = 0,
        female = "willard_female_stand04"
	},
    ["salute"] = {
        animation = "willard_male_male_stand02",
        time = 0,
        female = "willard_female_stand02"
    },
    ["stand3"] = {
        animation = "willard_male_male_stand01",
        time = 0,
        female = "willard_female_stand01"
    }

}

local ACTS_CCA = {
    ["plaza1"] = {
		animation = "plazathreat1",
		time = nil
	},
    ["plaza2"] = {
		animation = "plazathreat2",
		time = nil
	},
    ["halt"] = {
		animation = "harassfront2",
		time = nil
	},
    ["lean_back"] = {
		animation = "plazalean",
		time = 0
	},
    ["knock"] = {
		animation = "adoorknock",
		time = 0
	},
    ["idle"] = {
		animation = "apcidle",
		time = 0
	},
    ["sit1"] = {
		animation = "n7_male_sit01",
		time = 0
	},
    ["sit2"] = {
		animation = "n7_male_sit02",
		time = 0
	},    
    ["sit3"] = {
		animation = "n7_male_sit03",
		time = 0
	},    
    ["sit4"] = {
		animation = "n7_male_sit04",
		time = 0
	},    
    ["sit5"] = {
		animation = "n7_male_sit05",
		time = 0
	},
    ["sit6"] = {
		animation = "n7_male_sit07",
		time = 0
	},
    ["sit3"] = {
		animation = "n7_male_sit03",
		time = 0
	},    
    ["stand1"] = {
		animation = "n7_male_stand01",
		time = 0
	},    
    ["lean"] = {
		animation = "n7_male_stand03",
		time = 0
	},    
}

local ACTS_OTA = {
    ["advance"] = {
		animation = "signal_advance",
		time = nil
	},
    ["forward"] = {
		animation = "signal_forward",
		time = nil
	},
    ["group"] = {
		animation = "signal_group",
		time = nil
	},
    ["halt"] = {
		animation = "signal_halt",
		time = nil
	},
    ["take_cover"] = {
		animation = "signal_takecover",
		time = nil
	},
    ["left_signal"] = {
		animation = "signal_left",
		time = nil
	},
    ["right_signal"] = {
		animation = "signal_right",
		time = nil
	},
	["type"] = {
		animation = "console_type_loop",
		time = 0
	},
    ["lean_in"] = {
		animation = "binoculars_idle",
		time = 0
	}
}

local ACTS_VORT = {
    --[[
    ["chant"] = {
		animation = "vort_chantloop",
		time = 0
	},
    --]]
    ["stir"] = {
		animation = "soupstir",
		time = 0
	},
}

local teamreference = {
    [TEAM_CITIZEN] = ACTS_CITIZEN,
    [TEAM_CWU] = ACTS_CITIZEN,
    [TEAM_CP] = ACTS_CCA,
    [TEAM_OTA] = ACTS_OTA,
    [TEAM_CA] = ACTS_CITIZEN,
    [TEAM_VORT] = ACTS_VORT,
}

function meta:impulseAction(name)
    if not self:IsPlayer() then return end
    if not self:Alive() then return end
    if self:GetSyncVar(SYNC_WEPRAISED, false) or self:IsArrested() then return end
    if (self.DidAction or 0) > CurTime() then return end
    if self:GetVelocity():LengthSqr() > 0 then self:Notify("You must be stationary to do an action.") return end

    name = string.lower(name)
    local actlist = teamreference[self:Team()]
    local action = actlist[name]
    self.DidAction = CurTime() + 1.5

    if action then
        local femaleanim = action.female
        if self:IsOnGround() then
            self.Acting = true
            self.ActionTime = action.time
            if (self:Team() == TEAM_CITIZEN or self:Team() == TEAM_CWU or self:Team() == TEAM_CA) and self:IsFemale() then
                self:ForceSequence(action.female, nil, action.time or nil)
            else
                self:ForceSequence(action.animation, nil, action.time or nil)
            end
        end
    else
        return self:Notify("Invalid action.\nUse 'impulse_hl2rp_printacts' for a list of avaliable actions on your team.")
    end
end

function meta:impulseEndAction()
    if not self:IsPlayer() then return end

    if self.Acting and self.ActionTime and ((self.DidAction or 0) < CurTime()) then
        self.ActionTime = nil
        self.Acting = nil
        self:leaveSequence()
    else
        return self:Notify("You must be doing a action to run this command.")
    end
end

function PLUGIN:OnPlayerChangedTeam(ply, oldTeam, newTeam)
    if ply.Acting then
        ply.ActionTime = nil
        ply.Acting = nil
        ply:leaveSequence()
    end
end

function PLUGIN:PlayerDeath(ply)
    if ply.Acting then
        ply.ActionTime = nil
        ply.Acting = nil
        ply:leaveSequence()
    end
end

local ActionEnd = {
    [IN_JUMP] = true,
    [IN_DUCK] = true,
    [IN_ATTACK] = true,
    [IN_RIGHT] = true,
    [IN_LEFT] = true,
    [IN_FORWARD] = true,
    [IN_BACK] = true
}

hook.Add("KeyPress", "ActionMovement", function(ply, key)
    if ply.Acting and ply.ActionTime and (ActionEnd[key]) and ((ply.DidAction or 0) < CurTime()) then
        ply.ActionTime = nil
        ply.Acting = nil
        ply:leaveSequence()
    end
end)

net.Receive("impulseListActions", function( len, ply )
    if ((ply.ListActions or 0) > CurTime()) then return end
    ply.ListActions = CurTime() + 5
    local arguments = net.ReadString()
    arguments = tostring(arguments)

    local actlist = teamreference[ply:Team()]
    
    net.Start("impulseListActions")
    net.WriteTable(actlist)
    net.Send(ply)
end)
