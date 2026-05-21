AddCSLuaFile();

TOOL.Category = "Construction"
TOOL.Name = "Elevators"
TOOL.ClientConVar["up"] = "100";
TOOL.ClientConVar["right"] = "0";
TOOL.ClientConVar["forward"] = "0";
TOOL.ClientConVar["speed"] = "70";
TOOL.ClientConVar["local"] = "1";
TOOL.ClientConVar["movesound"] = "Elevators.HeavyMetal";
TOOL.ClientConVar["stopsound"] = "Elevators.Stop.HeavyMetal";
TOOL.ClientConVar["keystart"] = "0";
TOOL.ClientConVar["keyreturn"] = "0";
TOOL.ClientConVar["blockdamage"] = "0";
TOOL.ClientConVar["allowuse"] = "0";
TOOL.ClientConVar["shake"] = "1";

TOOL.Information = {
	{name = "left", stage = 0},
	{name = "right", stage = 0},
};

cleanup.Register("elevators");

if (SERVER) then
	if (!ConVarExists("sbox_maxelevators")) then
		CreateConVar("sbox_maxelevators", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Maximum number of elevators which can be created by users.");
	end;

	numpad.Register("ElevatorStart", function(player, elevator)
		if (!IsValid(elevator)) then return false; end;

		elevator:Fire("Open");
	end);

	numpad.Register("ElevatorReturn", function(player, elevator)
		if (!IsValid(elevator)) then return false; end;

		elevator:Fire("Close");
	end);
end;

/*
	Elevator Creation
*/

function TOOL:LeftClick(trace)
	if (self:GetStage() == 1) then return self:RightClick(trace); end;
	if (!IsValid(trace.Entity)) then return false; end;
	if (trace.Entity:IsPlayer()) then return false; end;
	if (CLIENT) then return true; end;

	if (trace.Entity:GetClass() == "prop_physics") then
		if (!self:GetOwner():CheckLimit("elevators")) then return false; end;
		local bUseLocalAng = tobool(self:GetClientInfo("local"));
		local baseAng = trace.Entity:GetAngles();

		if (!bUseLocalAng) then
			baseAng = angle_zero;
		end;

		local ent = trace.Entity;

		local elevator = ents.Create("elevator");
		elevator:SetPos(ent:GetPos());
		elevator:SetAngles(ent:GetAngles());
		elevator.Model = ent:GetModel();
		elevator:Spawn();
		elevator:SetupOwner(self:GetOwner())

		elevator:SetMoveSound(self:GetClientInfo("movesound"));
		elevator:SetStopSound(self:GetClientInfo("stopsound"));

		elevator:SetMoveSpeed(math.Clamp(tonumber(self:GetClientInfo("speed")), 1, 500));

		elevator:SetBlockDamage(math.Clamp(tonumber(self:GetClientInfo("blockdamage")), 0, 100));

		elevator:SetAllowUse(tobool(self:GetClientInfo("allowuse")));

		elevator:SetShake(tobool(self:GetClientInfo("shake")));

		elevator:GetDoor():SetMaterial(ent:GetMaterial());
		elevator:GetDoor():SetColor(ent:GetColor());

		elevator:SetStart(ent:GetPos());
		elevator:SetEnd(ent:GetPos() + baseAng:Right() * tonumber(self:GetClientInfo("right")) + baseAng:Up() * tonumber(self:GetClientInfo("up")) + baseAng:Forward() * tonumber(self:GetClientInfo("forward")));

		elevator:GetDoor().StartButton = numpad.OnDown(self:GetOwner(), tonumber(self:GetClientInfo("keystart")), "ElevatorStart", elevator:GetDoor());
		elevator:GetDoor().ReturnButton = numpad.OnDown(self:GetOwner(), tonumber(self:GetClientInfo("keyreturn")), "ElevatorReturn", elevator:GetDoor());
		elevator:GetDoor().b1 = tonumber(self:GetClientInfo("keystart"));
		elevator:GetDoor().b2 = tonumber(self:GetClientInfo("keyreturn"));

		elevator:GetDoor().parts = {};

		for k, v in pairs(constraint.GetAllConstrainedEntities(ent)) do
			if (IsValid(v) and v != ent and constraint.Find(ent, v, "Weld", 0, 0)) then
				if (v:GetClass() == "prop_physics") then
					local prop = ents.Create("prop_physics");
					prop:SetPos(v:GetPos());
					prop:SetAngles(v:GetAngles());
					prop:SetMaterial(v:GetMaterial());
					prop:SetRenderMode(v:GetRenderMode());
					prop:SetColor(v:GetColor());
					prop:SetModel(v:GetModel());
					SafeRemoveEntity(v);
					prop:Spawn();
					prop:SetParent(elevator:GetDoor());
					prop:GetPhysicsObject():EnableMotion(false);

					table.insert(elevator:GetDoor().parts, {
						origin = elevator:GetDoor():WorldToLocal(v:GetPos()),
						angles = elevator:GetDoor():WorldToLocalAngles(v:GetAngles()),
						material = v:GetMaterial(),
						model = v:GetModel(),
						rendermode = v:GetRenderMode(),
						color = v:GetColor()
					});
				else
					v:SetParent(elevator:GetDoor());
				end;
			end;
		end;

		SafeRemoveEntity(ent);

		undo.Create("Elevator");
		undo.AddEntity(elevator);
		undo.SetPlayer(self:GetOwner());
		undo.SetCustomUndoText("Undone Elevator");
		undo.Finish();

		self:GetOwner():AddCount("elevators", elevator);
		self:GetOwner():AddCleanup("elevators", elevator);

		return true;
	elseif (trace.Entity:GetClass() == "func_movelinear" and IsValid(trace.Entity.parent)) then
		local parent = trace.Entity.parent;

		parent:SetMoveSound(self:GetClientInfo("movesound"));
		parent:SetStopSound(self:GetClientInfo("stopsound"));

		parent:SetMoveSpeed(math.Clamp(tonumber(self:GetClientInfo("speed")), 1, 500));

		parent:SetBlockDamage(math.Clamp(tonumber(self:GetClientInfo("blockdamage")), 0, 100));

		parent:SetAllowUse(tobool(self:GetClientInfo("allowuse")));

		parent:SetShake(tobool(self:GetClientInfo("shake")));

		return true;
	end;
end;

/*
	Manual Placement
*/

function TOOL:RightClick(trace)
	if (!IsValid(trace.Entity)) then return false; end;
	if (trace.Entity:IsPlayer()) then return false; end;
	if (CLIENT) then return true; end;

	if (trace.Entity:GetClass() == "prop_physics") then
		if (!self:GetOwner():CheckLimit("elevators")) then return false; end;
		local ent = trace.Entity;

		local wallTrace = util.TraceEntity({
			start = ent:GetPos(),
			endpos = ent:GetPos() + trace.HitNormal * 14000,
			filter = function(hit) if (hit == ent or hit:IsPlayer()) then return false; else return true; end; end
		}, ent);

		local elevator = ents.Create("elevator");
		elevator:SetPos(ent:GetPos());
		elevator:SetAngles(ent:GetAngles());
		elevator.Model = ent:GetModel();
		elevator:Spawn();
		elevator:SetupOwner(self:GetOwner())

		elevator:SetMoveSound(self:GetClientInfo("movesound"));
		elevator:SetStopSound(self:GetClientInfo("stopsound"));

		elevator:SetMoveSpeed(math.Clamp(tonumber(self:GetClientInfo("speed")), 1, 500));

		elevator:SetBlockDamage(math.Clamp(tonumber(self:GetClientInfo("blockdamage")), 0, 100));

		elevator:SetAllowUse(tobool(self:GetClientInfo("allowuse")));

		elevator:SetShake(tobool(self:GetClientInfo("shake")));

		elevator:GetDoor():SetMaterial(ent:GetMaterial());
		elevator:GetDoor():SetColor(ent:GetColor());

		elevator:SetStart(ent:GetPos());
		elevator:SetEnd(wallTrace.HitPos);

		elevator:GetDoor().StartButton = numpad.OnDown(self:GetOwner(), tonumber(self:GetClientInfo("keystart")), "ElevatorStart", elevator:GetDoor());
		elevator:GetDoor().ReturnButton = numpad.OnDown(self:GetOwner(), tonumber(self:GetClientInfo("keyreturn")), "ElevatorReturn", elevator:GetDoor());
		elevator:GetDoor().b1 = tonumber(self:GetClientInfo("keystart"));
		elevator:GetDoor().b2 = tonumber(self:GetClientInfo("keyreturn"));

		elevator:GetDoor().parts = {};

		for k, v in pairs(constraint.GetAllConstrainedEntities(ent)) do
			if (IsValid(v) and v != ent and constraint.Find(ent, v, "Weld", 0, 0)) then
				if (v:GetClass() == "prop_physics") then
					local prop = ents.Create("prop_physics");
					prop:SetPos(v:GetPos());
					prop:SetAngles(v:GetAngles());
					prop:SetMaterial(v:GetMaterial());
					prop:SetRenderMode(v:GetRenderMode());
					prop:SetColor(v:GetColor());
					prop:SetModel(v:GetModel());
					SafeRemoveEntity(v);
					prop:Spawn();
					prop:SetParent(elevator:GetDoor());
					prop:GetPhysicsObject():EnableMotion(false);

					table.insert(elevator:GetDoor().parts, {
						origin = elevator:GetDoor():WorldToLocal(v:GetPos()),
						angles = elevator:GetDoor():WorldToLocalAngles(v:GetAngles()),
						material = v:GetMaterial(),
						model = v:GetModel(),
						rendermode = v:GetRenderMode(),
						color = v:GetColor()
					});
				else
					v:SetParent(elevator:GetDoor());
				end;
			end;
		end;

		SafeRemoveEntity(ent);

		undo.Create("Elevator");
		undo.AddEntity(elevator);
		undo.SetPlayer(self:GetOwner());
		undo.SetCustomUndoText("Undone Elevator");
		undo.Finish();

		self:GetOwner():AddCount("elevators", elevator);
		self:GetOwner():AddCleanup("elevators", elevator);

		return true;
	elseif (trace.Entity:GetClass() == "func_movelinear" and IsValid(trace.Entity.parent)) then
		local parent = trace.Entity.parent;

		parent:SetMoveSound(self:GetClientInfo("movesound"));
		parent:SetStopSound(self:GetClientInfo("stopsound"));

		parent:SetMoveSpeed(math.Clamp(tonumber(self:GetClientInfo("speed")), 1, 500));

		parent:SetBlockDamage(math.Clamp(tonumber(self:GetClientInfo("blockdamage")), 0, 100));

		parent:SetAllowUse(tobool(self:GetClientInfo("allowuse")));

		parent:SetShake(tobool(self:GetClientInfo("shake")));

		return true;
	end;
end;

if (SERVER) then
	function TOOL:Think()
	end
end

/*
	Holster
	Clear stored objects and reset state
*/

function TOOL:Holster()
	self:ClearObjects();
	self:SetStage(0);
end;

function TOOL:UpdateGhostElevator(player, ent)
	if (!IsValid(ent)) then return; end;
	local trace = player:GetEyeTrace();

	if (!IsValid(trace.Entity) or trace.Entity:GetClass() != "prop_physics") then ent:SetNoDraw(true); return; end;

	ent:SetModel(trace.Entity:GetModel());
	ent:SetAngles(trace.Entity:GetAngles());

	local bUseLocalAng = tobool(self:GetClientInfo("local"));
	local baseAng = trace.Entity:GetAngles();

	if (!bUseLocalAng) then
		baseAng = angle_zero;
	end;

	ent:SetPos(trace.Entity:GetPos() + baseAng:Right() * tonumber(self:GetClientInfo("right")) + baseAng:Up() * tonumber(self:GetClientInfo("up")) + baseAng:Forward() * tonumber(self:GetClientInfo("forward")));
	ent:SetNoDraw(false);
end;

function TOOL:Think()
	local trace = self:GetOwner():GetEyeTrace();

	if (!IsValid(self.GhostEntity)) then
		self:MakeGhostEntity(trace.Entity:GetModel(), Vector(0, 0, 0), Angle(0, 0, 0));
	end;

	self:UpdateGhostElevator(self:GetOwner(), self.GhostEntity);
end;

/*
	Control Panel
*/

function TOOL.BuildCPanel(CPanel)
	CPanel:AddControl("Numpad", {
		Label = "#tool.elevator.keystart",
		Command = "elevator_keystart",
		Label2 = "#tool.elevator.keyreturn",
		Command2 = "elevator_keyreturn"
	});

	CPanel:AddControl("ComboBox", {
		Label = "#tool.elevator.movesound",
		Options = list.Get("elevator.MoveSounds")
	});

	CPanel:AddControl("ComboBox", {
		Label = "#tool.elevator.stopsound",
		Options = list.Get("elevator.StopSounds")
	});

	CPanel:AddControl("Slider", {
		Label = "#tool.elevator.blockdamage",
		Command = "elevator_blockdamage",
		Type = "Float",
		Min = 0,
		Max = 100
	});

	CPanel:AddControl("Slider", {
		Label = "#tool.elevator.speed",
		Command = "elevator_speed",
		Type = "Float",
		Min = 1,
		Max = 200
	});

	CPanel:AddControl("ComboBox", {
		Label = "#tool.elevator.relative",
		Options = list.Get("elevator.Relative")
	});

	CPanel:Button("Reset Offsets", "elevator_resetoffsets");

	CPanel:AddControl("Slider", {
		Label = "#tool.elevator.up",
		Command = "elevator_up",
		Type = "Float",
		Min = -2500,
		Max = 2500
	});

	CPanel:AddControl("Slider", {
		Label = "#tool.elevator.lright",
		Command = "elevator_right",
		Type = "Float",
		Min = -2500,
		Max = 2500
	});

	CPanel:AddControl("Slider", {
		Label = "#tool.elevator.forward",
		Command = "elevator_forward",
		Type = "Float",
		Min = -2500,
		Max = 2500
	});

	CPanel:AddControl("CheckBox", {
		Label = "#tool.elevator.allowuse",
		Command = "elevator_allowuse",
	});

	CPanel:AddControl("CheckBox", {
		Label = "#tool.elevator.shake",
		Command = "elevator_shake",
	});
end;

/*
	Language strings
*/

local moveSounds = {
	["Heavy Metal"] = "plats/skylift_move.wav",
	["Squeaky"] = "plats/elevator_loop1.wav",
	["Tram"] = "plats/tram_move.wav",
	["Rusty"] = "plats/hall_elev_move.wav",
	["Old 1"] = "plats/elevator_move_loop1.wav",
};

local stopSounds = {
	["Heavy Metal"] = "plats/skylift_stop.wav",
	["Squeaky"] = "plats/elevator_stop.wav",
	["Rusty"] = "plats/hall_elev_stop.wav",
	["Old 1"] = "plats/elevator_stop1.wav",
	["Old 2"] = "plats/elevator_stop2.wav",
	["Industrial"] = "plats/elevator_large_stop1.wav"
};

for k, v in pairs(moveSounds) do
	local name = k:gsub(" ", "");

	sound.Add({
		name = "Elevators." .. name,
		sound = v,
		volume = 1,
		pitch = 100,
		level = 75,
		channel = CHAN_STATIC
	});

	if (CLIENT) then
		list.Set("elevator.MoveSounds", "#tool.elevator.movesounds." .. name:lower(), {elevator_movesound = "Elevators." .. name});
		language.Add("tool.elevator.movesounds." .. name:lower(), k);
	end;
end;

for k, v in pairs(stopSounds) do
	local name = k:gsub(" ", "");

	sound.Add({
		name = "Elevators.Stop." .. name,
		sound = v,
		volume = 1,
		pitch = 100,
		level = 75,
		channel = CHAN_STATIC
	});

	if (CLIENT) then
		list.Set("elevator.StopSounds", "#tool.elevator.stopsounds." .. name:lower(), {elevator_stopsound = "Elevators.Stop." .. name});
		language.Add("tool.elevator.stopsounds." .. name:lower(), k);
	end;
end;

if (CLIENT) then
	language.Add("tool.elevator.name", "Elevators");
	language.Add("tool.elevator.left", "Transform a prop and everything welded directly to it into an elevator.");
	language.Add("tool.elevator.right", "Same as left click, but sets the endpoint perpendicular to the hit surface.");
	language.Add("tool.elevator.desc", "Create elevators.");

	language.Add("tool.elevator.keystart", "Start");
	language.Add("tool.elevator.keyreturn", "Return");

	language.Add("tool.elevator.movesound", "Moving Sound");
	language.Add("tool.elevator.stopsound", "Arrival Sound");

	language.Add("tool.elevator.speed", "Speed");

	language.Add("tool.elevator.up", "Up/Down Distance");
	language.Add("tool.elevator.lright", "Right/Left Distance");
	language.Add("tool.elevator.forward", "Forward/Back Distance");

	language.Add("tool.elevator.relative", "Relative to: ");
	language.Add("tool.elevator.relative.prop", "Prop");
	language.Add("tool.elevator.relative.world", "World");

	language.Add("tool.elevator.blockdamage", "Crush Damage");

	language.Add("tool.elevator.allowuse", "Allow USE");

	language.Add("tool.elevator.shake", "Shake Screen");

	language.Add("Cleaned_elevators", "Cleaned up all Elevators");
	language.Add("Cleanup_elevators", "Elevators");

	language.Add("tool.elevator.movesounds.none", "None");
	language.Add("tool.elevator.stopsounds.none", "None");

	language.Add("SBoxLimit_elevators", "You've hit the limit of elevators!");

	list.Set("elevator.MoveSounds", "#tool.elevator.movesounds.none", {elevator_movesound = ""});

	list.Set("elevator.StopSounds", "#tool.elevator.stopsounds.none", {elevator_stopsound = ""});

	list.Set("elevator.Relative", "#tool.elevator.relative.prop", {elevator_local = "1"});
	list.Set("elevator.Relative", "#tool.elevator.relative.world", {elevator_local = "0"});

	concommand.Add("elevator_resetoffsets", function()
		LocalPlayer():ConCommand("elevator_up 0");
		LocalPlayer():ConCommand("elevator_right 0");
		LocalPlayer():ConCommand("elevator_forward 0");
	end);

	halo.oldAdd = halo.oldAdd or halo.Add;

	function halo.Add(entities, color, blurX, blurY, passes, additive, ignoreZ)
		for k, v in pairs(entities) do
			if (IsValid(v) and v:GetClass():find("func_")) then
				entities[k] = nil;
			end;
		end;

		halo.oldAdd(entities, color, blurX, blurY, passes, additive, ignoreZ);
	end;
end;