--[[
	Simulation of FLIR (forward-looking infrared) vision.
	Possible future ideas:
	* Different materials have different emissivities:
		aluminium is about 20%, wherease asphalt is 95%.
		maybe we could use the physical properties to simulate this?
	* the luminance of a texture contributes *negatively* to its emissivity
	* IR sensors often have auto gain control that we might simulate with auto-exposure


	To Fix:
	* Find a way to make fog work. With rendermode 1 or 2, fog is disabled. mat_fullbright would be
		perfect except that it causes a big stutter on being disabled.
	* Add entities to the list as they are parented. If something is parented while FLIR is enabled, it doesn't
		add itself until it's switched off and back on.
	* Sun pops in and out of full brightness when looking around it

--]]

if not FLIR then FLIR = { enabled = false } end

if SERVER then
	function FLIR.start(ply) FLIR.enable(ply, true) end
	function FLIR.stop(ply) FLIR.enable(ply, false) end

	util.AddNetworkString("FLIR.enable")

	function FLIR.enable(ply, enabled)
		net.Start("FLIR.enable")
		net.WriteBool(enabled)
		net.Send(ply)
	end

	return
end

FLIR.RenderStack = {}
FLIR.enabled = false

FLIR.gcvar = CreateClientConVar("wire_flir_gain", 2.2, true, false, "Brightness of FLIR ents. Higher = less detail, more visible.", 0, 10)
cvars.AddChangeCallback("wire_flir_gain", function(_,_,v)
	FLIR.gain = v
end)

FLIR.gain = FLIR.gcvar:GetInt()
FLIR.mat = Material("phoenix_storms/concrete0")
FLIR.transmat = Material("phoenix_storms/iron_rails")
FLIR.hide = false

function FLIR.Render(self)
	if not FLIR.hide then
		if self.BackupRenderOverride then
			self:BackupRenderOverride()
		end
		self:DrawModel()

		return
	end
end

FLIR.mapcol = {
	[ "$pp_colour_brightness" ] = 0.5,
	[ "$pp_colour_contrast" ] = 0.4
}

FLIR.skycol = {
	[ "$pp_colour_contrast" ] = 0.2,
	[ "$pp_colour_brightness" ] = 1
}

FLIR.desat = {
	["$pp_colour_colour"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_brightness"] = 0
}

FLIR.classWhitelist = {
	-- Garry's Mod & Wire
	["prop_physics"] = true,
	["gmod_wire_hologram"] = true,

	-- StarfallEx
	["starfall_hologram"] = true,

	-- Prop2Mesh
	["sent_prop2mesh"] = true,
	["base_anim"] = true,
}

--add and remove entities from the FLIR rendering stack

local function RemoveFLIR(ent)
	FLIR.RenderStack[ent] = nil
	if ent:IsValid() then
		ent.RenderOverride = ent.BackupRenderOverride
		ent.BackupRenderOverride = nil
	end
end

local function SetFLIR(ent)
	if not ent:IsValid() then return end
	local classname = ent:GetClass()

	if ent:GetColor().a > 0 and (FLIR.classWhitelist[classname] or ent:GetMoveType() == MOVETYPE_VPHYSICS or ent:IsPlayer() or ent:IsNPC() or ent:IsRagdoll()) then
		FLIR.RenderStack[ent] = true
		ent.BackupRenderOverride = ent.RenderOverride
		ent.RenderOverride = FLIR.Render	--we're already rendering later, so don't bother beforehand
	end
end

function FLIR.start()
	return
end

function FLIR.stop()
	FLIR.enabled = false

	render.SetLightingMode(0)

	hook.Remove("PostDrawOpaqueRenderables", "wire_flir")
	hook.Remove("PostDrawTranslucentRenderables", "wire_flir")
	hook.Remove("RenderScreenspaceEffects", "wire_flir")
	hook.Remove("PostDraw2DSkyBox", "wire_flir")
	hook.Remove("PreRender", "wire_flir")
	hook.Remove("OnEntityCreated", "wire_flir")
	hook.Remove("CreateClientsideRagdoll", "wire_flir")

	for _, v in ipairs(ents.GetAll()) do
		RemoveFLIR(v)
	end
end

function FLIR.toggle()
	--if not FLIR.enabled then FLIR.start() else FLIR.stop() end
end

concommand.Add("flir_toggle", function()
	--FLIR.toggle()
end)

function FLIR.enable(enabled)
	--if enabled then FLIR.start() else FLIR.stop() end
end

net.Receive("FLIR.enable", function()
	--local enabled = net.ReadBool()
	--FLIR.enable(enabled)
end)

