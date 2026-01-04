AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_se/propper/power_monitor_7.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
end

util.AddNetworkString("researchStartTECH")
util.AddNetworkString("researchProgressTECH")
util.AddNetworkString("researchUITECH")
util.AddNetworkString("researchErrorTECH")

function ENT:Use(activator)
    if (activator:Team() == TEAM_CWU or activator:Team() == TEAM_VORT) and activator:GetTeamClass() == CLASS_RESEARCH then
		self:EmitSound("ambient/machines/keyboard_fast" .. math.random(1,3) .. "_1second.wav")
        net.Start("researchUITECH")
		net.WriteEntity(self)
        net.WriteTable(TECHRESEARCHITEMS)
        net.Send(activator)
	else
		activator:Notify("Access denied.")
	end
end

net.Receive("researchStartTECH", function(len, ply)

	if not IsValid(ply) then return end
	
	if ply:Team() ~= TEAM_CWU and ply:Team() ~= TEAM_VORT or ply:GetTeamClass() ~= CLASS_RESEARCH then
		ply:Notify("You are not authorized to perform research!")
		return
	end

    local terminalEnt = net.ReadEntity()
    local researchID = net.ReadInt(32)
    local researchItem = TECHRESEARCHITEMS[researchID]
	
    if not IsValid(terminalEnt) or terminalEnt:GetClass() ~= "deep_techterminal" then
        return
    end
	
    if not researchItem then
        return
    end

    if researchItem.isResearching then
        ply:Notify("This research is already in progress!")
        net.Start("researchErrorTECH")
        net.WriteInt(researchID, 32)
        net.Send(ply)
        return
    end
    if CWU_RP < researchItem.cost then
        ply:Notify("You don't have enough funds to start this research!")
        net.Start("researchErrorTECH")
        net.WriteInt(researchID, 32)
        net.Send(ply)
        return
    end
    if researchID ~= (CWU_TECHRESLVL + 1) then
        ply:Notify("You must complete previous research before starting this one!")
        net.Start("researchErrorTECH")
        net.WriteInt(researchID, 32)
        net.Send(ply)
        return
    end

    CWU_RP = CWU_RP - researchItem.cost

    StartResearchTimer(terminalEnt, researchItem, researchID, "researchProgressTECH", function(newLevel)
        CWU_TECHRESLVL = newLevel
    end)
end)
