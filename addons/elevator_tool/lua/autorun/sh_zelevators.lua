if (SERVER) then
	timer.Create("elevator_SaveData", 180, 0, function()
		file.CreateDir("elevators");

		local win, msg = pcall(SaveElevators);
		if (!win) then
			ErrorNoHalt("[ELEVATOR TOOL] Something happened while saving elevators!")
			print(msg);
		end;
	end);

	hook.Add("ShutDown", "zlevator_ShutDown", function()
		local win, msg = pcall(SaveElevators);
		if (!win) then
			ErrorNoHalt("[ELEVATOR TOOL] Something happened while saving elevators!")
			print(msg);
		end;
	end);

	hook.Add("InitPostEntity", "zelevator_SaveElevators", function()
		timer.Simple(5, function()
			local win, msg = pcall(LoadElevators);
			if (!win) then
				ErrorNoHalt("[ELEVATOR TOOL] Something happened while loading elevators!")
				print(msg);
			end;
		end);
	end);

	function SaveElevators()
		file.CreateDir("elevators");
		local buffer = {};

		for k, v in pairs(ents.FindByClass("func_movelinear")) do
			if (v:GetNWBool("saved", false) and v:GetName():find("zelevator")) then
				local props = v:GetChildren();
				local parts = {};
				local buttonList = {};

				for k, button in pairs(ents.FindByClass("elevator_button")) do
					if (button:GetElevator() == v) then
						table.insert(buttonList, {
							origin = button:GetPos(),
							angles = button:GetAngles(),
							bIsSender = button:GetSender(),
							material = button:GetMaterial(),
							model = button:GetModel(),
							color = button:GetColor()
						});
					end;
				end;

				for k, prop in pairs(props) do
					if (IsValid(prop) and prop:GetClass() != "prop_dynamic" and prop:GetClass() != "elevator" and prop != v) then
						table.insert(parts, {
							origin = v:WorldToLocal(prop:GetPos()),
							angles = v:WorldToLocalAngles(prop:GetAngles()),
							material = prop:GetMaterial(),
							model = prop:GetModel(),
							rendermode = prop:GetRenderMode(),
							color = prop:GetColor()
						});
					end;
				end;

				buffer[#buffer + 1] = {
					origin = v:GetPos(),
					angles = v:GetAngles(),
					model = v:GetModel(),
					material = v:GetMaterial(),
					color = v:GetColor(),
					rendermode = v:GetRenderMode(),
					startPos = v.worldStartPos,
					endPos = v.worldEndPos,
					moveSpeed = v.movespeed,
					moveSound = v.movesound,
					stopSound = v.stopsound,
					blockDamage = v.blockdamage,
					shake = v.shake,
					parts = parts,
					buttons = buttonList
				};
			end;
		end;

		local JSON = util.TableToJSON(buffer);

		file.Write("elevators/" .. game.GetMap() .. ".txt", JSON);
	end;

	function LoadElevators()
		if (!file.Exists("elevators/" .. game.GetMap() .. ".txt", "DATA")) then return; end;

		local buffer = file.Read("elevators/" .. game.GetMap() .. ".txt", "DATA");

		if (buffer and buffer:len() > 1) then
			buffer = util.JSONToTable(buffer);

			for k, v in pairs(buffer) do
				local elevator = ents.Create("elevator");
				elevator:SetPos(v.origin);
				elevator:SetAngles(v.angles);
				elevator.Model = v.model;
				elevator:Spawn();
				elevator:GetDoor():SetMaterial(v.material);
				elevator:GetDoor().child:SetMaterial(v.material);

				elevator:GetDoor():SetNWBool("saved", true);

				elevator:SetStart(v.startPos);
				elevator:SetEnd(v.endPos);

				elevator:SetMoveSpeed(v.moveSpeed);
				elevator:SetMoveSound(v.moveSound);
				elevator:SetStopSound(v.stopSound);

				elevator:SetBlockDamage(v.blockDamage);
				elevator:SetAllowUse(true);

				elevator:SetShake(v.shake);

				if (v.parts and table.Count(v.parts) > 0) then
					for k, info in pairs(v.parts) do
						local prop = ents.Create("prop_physics");
						prop:SetPos(elevator:GetDoor():LocalToWorld(info.origin));
						prop:SetAngles(elevator:GetDoor():LocalToWorldAngles(info.angles));
						prop:SetModel(info.model);
						prop:SetMaterial(info.material);
						prop:SetRenderMode(info.rendermode);
						prop:SetColor(info.color);
						prop:Spawn();
						prop:SetParent(elevator:GetDoor());
						prop:GetPhysicsObject():EnableMotion(false);
					end;
				end;

				if (v.buttons and table.Count(v.buttons) > 0) then
					for k, info in pairs(v.buttons) do
						local button = ents.Create("elevator_button");
						button:SetPos(info.origin);
						button.Model = info.model;
						button:SetAngles(info.angles);
						button:Spawn();
						button:SetElevator(elevator:GetDoor());
						button:SetSender(info.bIsSender);
						button:GetPhysicsObject():EnableMotion(false);
						button:PhysicsDestroy();
						button:SetColor(info.color);
						button:SetMaterial(info.material);
					end;
				end;
			end;
		end;
	end;
end;

hook.Add("PhysgunPickup", "zelevator_NoPickup", function(player, ent)
	if (ent:GetClass() == "func_movelinear") then
		if (ent:GetNWBool("saved", false)) then
			return false;
		end;
	elseif (IsValid(ent:GetParent()) and ent:GetParent():GetClass() == "func_movelinear") then
		return false;
	end;
end);

properties.Add("elevator_persist", {
	MenuLabel = "Save Elevator",
	MenuIcon = "icon16/disk.png",
	Order = 1,

	Filter = function(self, ent, player)
		if (!IsValid(ent)) then return false; end;
		if (!player:IsSuperAdmin()) then return false; end;
		if (ent:GetClass() != "func_movelinear") then return false; end;
		if (SERVER and !ent:GetName():find("zelevator")) then player:ChatPrint("That elevator cannot be saved"); return false; end;

		return !ent:GetNWBool("saved", false);
	end,

	Action = function(self, ent)
		self:MsgStart();
		net.WriteEntity(ent);
		self:MsgEnd();
	end,

	Receive = function(self, length, player)
		local ent = net.ReadEntity();

		if (!self:Filter(ent, player)) then return; end;

		ent:SetNWBool("saved", true);
		SaveElevators();
	end,
});

properties.Add("elevator_persist_end", {
	MenuLabel = "Un-Save Elevator",
	MenuIcon = "icon16/arrow_undo.png",
	Order = 1,

	Filter = function(self, ent, player)
		if (!IsValid(ent)) then return false; end;
		if (!player:IsSuperAdmin()) then return false; end;
		if (ent:GetClass() != "func_movelinear") then return false; end;
		if (SERVER and !ent:GetName():find("zelevator")) then player:ChatPrint("That elevator cannot be saved"); return false; end;

		return ent:GetNWBool("saved", false);
	end,

	Action = function(self, ent)
		self:MsgStart();
		net.WriteEntity(ent);
		self:MsgEnd();
	end,

	Receive = function(self, length, player)
		local ent = net.ReadEntity();

		if (!self:Filter(ent, player)) then return; end;

		ent:SetNWBool("saved", false);
		SaveElevators();
	end,
});