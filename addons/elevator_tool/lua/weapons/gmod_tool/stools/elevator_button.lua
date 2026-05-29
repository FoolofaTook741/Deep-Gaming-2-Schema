AddCSLuaFile();

TOOL.Category = "Construction"
TOOL.Name = "Elevator Buttons"
TOOL.ClientConVar["send"] = "1";
TOOL.ClientConVar["model"] = "models/props_combine/combinebutton.mdl";

TOOL.Information = {
	{name = "left", stage = 0},
	{name = "right", stage = 0},
};

cleanup.Register("elevatorbuttons");

if (SERVER) then
	if (!ConVarExists("sbox_maxelevatorbuttons")) then
		CreateConVar("sbox_maxelevatorbuttons", 10, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Maximum number of elevator buttons which can be created by users.");
	end;
end;

/*
	Elevator Creation
*/

function TOOL:LeftClick(trace)
	if (IsValid(trace.Entity) and trace.Entity:IsPlayer()) then return false; end;
	if (!IsValid(self:GetEnt(0))) then return false; end;
	if (CLIENT) then return true; end;
	if (!self:GetOwner():CheckLimit("elevatorbuttons")) then return false; end;

	local ang = trace.HitNormal:Angle();
	ang:RotateAroundAxis(ang:Right(), -90);

	local button = ents.Create("elevator_button");
	button.Model = self:GetClientInfo("model");
	button:SetPos(trace.HitPos);
	button:SetAngles(ang);
	button:Spawn();
	button:SetSender(tobool(self:GetClientInfo("send")));
	button:SetElevator(self:GetEnt(0));
	button:GetPhysicsObject():EnableMotion(false);

	undo.Create("Elevator Button");
	undo.AddEntity(button);
	undo.SetPlayer(self:GetOwner());
	undo.SetCustomUndoText("Undone Elevator Button");
	undo.Finish();

	self:GetOwner():AddCount("elevatorbuttons", button);
	self:GetOwner():AddCleanup("elevatorbuttons", button);

	return true;
end;

/*
	Selection
*/

function TOOL:RightClick(trace)
	if (!IsValid(trace.Entity)) then return false; end;
	if (trace.Entity:IsPlayer()) then return false; end;
	if (trace.Entity:GetClass() != "func_movelinear") then return false; end;
	if (CLIENT) then return true; end;

	self:GetOwner():SendLua("surface.PlaySound('buttons/button24.wav'); notification.AddLegacy('Elevator selected', NOTIFY_GENERIC, 2);");

	local ent = trace.Entity;

	self:SetObject(0, ent, vector_origin, nil, 0, vector_origin);

	return true;
end;

/*
	Holster
	Reset state
*/

function TOOL:Holster()
	self:SetStage(0);
	self:ReleaseGhostEntity();
end;

function TOOL:UpdateGhostButton(player, ent)
	if (!IsValid(ent)) then return; end;
	local trace = player:GetEyeTrace();

	if (!trace.Hit) then
		ent:SetNoDraw(true);
		return;
	end;

	if (IsValid(trace.Entity) and trace.Entity:IsPlayer()) then
		ent:SetNoDraw(true);
		return;
	end;

	local ang = trace.HitNormal:Angle();
	ang:RotateAroundAxis(ang:Right(), -90);

	ent:SetAngles(ang);

	ent:SetPos(trace.HitPos);
	ent:SetNoDraw(false);
end;

function TOOL:Think()
	local mdl = self:GetClientInfo("model"):lower();

	if (!IsValid(self.GhostEntity) or self.GhostEntity:GetModel():lower() != mdl) then
		self:MakeGhostEntity(mdl, Vector(0, 0, 0), Angle(0, 0, 0));
	end;

	self:UpdateGhostButton(self:GetOwner(), self.GhostEntity);
end;

/*
	Control Panel
*/

function TOOL.BuildCPanel(CPanel)
	CPanel:AddControl("PropSelect", {
		Label = "#tool.elevator_button.model",
		ConVar = "elevator_button_model",
		Height = 4,
		Models = list.Get("ButtonModels");
	});

	CPanel:AddControl("ComboBox", {
		Label = "#tool.elevator_button.send",
		Options = list.Get("elevatorbuttons.SendOptions")
	});
end;

/*
	Language strings
*/

if (CLIENT) then
	language.Add("tool.elevator_button.name", "Elevator Buttons");
	language.Add("tool.elevator_button.left", "Place a button to call or send an elevator.");
	language.Add("tool.elevator_button.right", "Select the elevator to add buttons for.");
	language.Add("tool.elevator_button.desc", "Create elevator buttons.");

	language.Add("tool.elevator_button.model", "Model");
	language.Add("tool.elevator_button.send", "This button will");
	language.Add("tool.elevator_button.send.call", "Call elevator to bottom");
	language.Add("tool.elevator_button.send.send", "Send elevator to top");

	language.Add("Cleaned_elevatorbuttons", "Cleaned up all Elevator Buttons");
	language.Add("Cleanup_elevatorbuttons", "Elevator Buttons");

	language.Add("SBoxLimit_elevatorbuttons", "You've hit the limit of elevator buttons!");

	list.Set("elevatorbuttons.SendOptions", "#tool.elevator_button.send.call", {elevator_button_send = "0"});
	list.Set("elevatorbuttons.SendOptions", "#tool.elevator_button.send.send", {elevator_button_send = "1"});
end;