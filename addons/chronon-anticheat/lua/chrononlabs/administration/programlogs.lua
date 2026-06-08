local self 					= {}
local pairs					= pairs
local importedManagement 	= ChrononLabs ["ChrononLabs:Initializer"]

function self:InternalId ()
	return "ChrononLabs:ProgramLogs"
end

function self:GetTableLength (object)
	local incremental = 0

	for keys in pairs (object) do
		incremental = incremental + 1
	end
	
	return incremental
end

function self:Constructor ()
	local getmetatable			= getmetatable
	local string				= string
	local file					= file
	local sanitizedDate 		= string.gsub (os.date ("%d/%m/%Y"), "/", "_")
	self.FunctionLoggerInternal = ChrononLabs ["ChrononLabs:SystemDispatcher"].WeakKeys ()
	
	self.FunctionLoggerInternal [#self.FunctionLoggerInternal + 1] = debug.getinfo
	self.FunctionLoggerInternal [#self.FunctionLoggerInternal + 1] = debug.getupvalue
	self.FunctionLoggerInternal [#self.FunctionLoggerInternal + 1] = debug.getregistry
	self.FunctionLoggerInternal [#self.FunctionLoggerInternal + 1] = debug.getlocal
	self.FunctionLoggerInternal [#self.FunctionLoggerInternal + 1] = debug.getmetatable
	self.FunctionLoggerInternal [#self.FunctionLoggerInternal + 1] = net.Incoming
	self.FunctionLoggerInternal [#self.FunctionLoggerInternal + 1] = jit.util.funck
	self.FunctionLoggerInternal [#self.FunctionLoggerInternal + 1] = jit.util.funcinfo
	
	self.DataPathMain = "chrononlabs"
	self.DataPathSubC = self.DataPathMain .. "/console"
	self.DataPathSubL = self.DataPathSubC .. "/console" .. "_" .. sanitizedDate .. ".txt"
	self.DataPathSubI = self.DataPathMain .. "/pack"
	
	if not file.Exists (self.DataPathMain, "DATA") then
		file.CreateDir (self.DataPathMain)
		importedManagement:MiniLogger ("No previous save found for data/" .. self.DataPathMain)
		importedManagement:MiniLogger ("Created file data/" .. self.DataPathMain)
	end
	
	if not file.Exists (self.DataPathSubC, "DATA") then
		file.CreateDir (self.DataPathSubC)
		importedManagement:MiniLogger ("No previous save found for data/" .. self.DataPathSubC)
		importedManagement:MiniLogger ("Created file data/" .. self.DataPathSubC)
	end
	
	if not file.Exists (self.DataPathSubI, "DATA") then
		file.CreateDir (self.DataPathSubI)
		importedManagement:MiniLogger ("No previous save found for data/" .. self.DataPathSubI)
		importedManagement:MiniLogger ("Created file data/" .. self.DataPathSubI)
	end
	
	if not file.Exists (self.DataPathSubL, "DATA") then
		file.Write (self.DataPathSubL, "")
		importedManagement:MiniLogger ("Creating daily Console Reporter for data/" .. self.DataPathSubL)
		importedManagement:MiniLogger ("Created file data/" .. self.DataPathSubL)
	end
	
	local consoleCount = #file.Find (self.DataPathSubC .. "/*", "DATA")

	if consoleCount >= 31 then
		importedManagement:MiniLogger ("Found one month of console logging, erasing older saves..")
		for _, fileName in pairs (file.Find (self.DataPathSubC .. "/*", "DATA")) do
			local currentConsole = "console_" .. sanitizedDate .. ".txt"
			
			if fileName ~= currentConsole then
				file.Delete (self.DataPathSubC .. "/" .. fileName)
			else
				importedManagement:MiniLogger ("Prevented from deleting today's console.")
			end
		end
	end
	
	importedManagement:MiniLogger ("ChrononLabs:ProgramLogs ran successfully.")
end

function self:IsFunctionNative (nFunction)
	return self.FunctionLoggerInternal [1] (nFunction).what == "C"
end

function self:IsPlayerValid (ply)
    return getmetatable (ply) == self.FunctionLoggerInternal [3] ().Player and IsValid (ply)
end

function self:IsPlayerValid_ (ply)
    return ply:IsPlayer () and IsValid (ply)
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())