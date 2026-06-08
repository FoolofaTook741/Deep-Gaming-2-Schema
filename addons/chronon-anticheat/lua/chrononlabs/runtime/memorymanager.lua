local self				= {}
local coroutine			= coroutine
local timer				= timer
local collectgarbage	= collectgarbage
local SysTime			= SysTime
local math				= math

function self:InternalId ()
    return "ChrononLabs:GarbageManager"
end

function self:Constructor ()
    collectgarbage ("setpause", 110)
    collectgarbage ("setstepmul", 200)
    
    self.isProcessing 	= false
    self.gcYieldTime 	= 0.1 -- 100ms.
    self.gcStepSize 	= 200
	
    self.metrics = {
        startTime 		= 0,
        startMem 		= 0,
        cycles 			= 0,
        totalMemFreed 	= 0,
        averageMemFreed = 0,
        totalTime 		= 0,
        averageTime 	= 0,
        fullCycles 		= 0,
		incrementalCycles = 0,
    }
end

function self:LogGCMetrics (memoryFreed, timeTaken, gcType)
    memoryFreed = math.max (memoryFreed, 0)
    
    self.metrics.cycles = self.metrics.cycles + 1
    self.metrics.totalMemFreed = self.metrics.totalMemFreed + memoryFreed
    self.metrics.totalTime = self.metrics.totalTime + timeTaken
    
    if gcType == "Incremental" then
        self.metrics.incrementalCycles = self.metrics.incrementalCycles + 1
    else
        self.metrics.fullCycles = self.metrics.fullCycles + 1
    end
    
    if self.metrics.cycles > 0 then
        self.metrics.averageMemFreed = self.metrics.totalMemFreed / self.metrics.cycles
        self.metrics.averageTime = self.metrics.totalTime / self.metrics.cycles
    else
        self.metrics.averageMemFreed = 0
        self.metrics.averageTime = 0
    end
    
    ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger (string.format (
        "[%s] GC Cycle #%d - Memory Freed: %.2f KB, Time: %.2f ms (Averages: %.2f KB, %.2f ms)",
        gcType,
        self.metrics.cycles,
        memoryFreed,
        timeTaken * 1000,
        self.metrics.averageMemFreed,
        self.metrics.averageTime * 1000
    ))
end

function self:ProcessGarbageCollection ()
    if self.isProcessing then return end
    self.isProcessing = true
    
    local processStartTime 	= SysTime ()
    local processStartMem 	= collectgarbage ("count")
    
    local co = coroutine.create (function ()
        while true do
            local hasCompleted = collectgarbage ("step", self.gcStepSize)
            if hasCompleted then break end
            coroutine.yield ()
        end
    end)
    
    local function resumeCollection ()
        if coroutine.status (co) == "dead" then
            local endTime = SysTime ()
            local endMem = collectgarbage ("count")
            
            local memoryFreed = processStartMem - endMem
            local timeTaken = endTime - processStartTime
            
            self:LogGCMetrics (memoryFreed, timeTaken, "Incremental")
            
            self.isProcessing = false
            timer.Remove ("ChrononLabs:GCProcessor")
            return
        end
        
        local success, err = coroutine.resume (co)
        if not success then
            ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger ("GC Error: " .. tostring (err))
            self.isProcessing = false
            timer.Remove ("ChrononLabs:GCProcessor")
        end
    end
    
    timer.Create ("ChrononLabs:GCProcessor", self.gcYieldTime, 0, resumeCollection)
end

function self:QueueGarbageCollection ()
    if not self.isProcessing then
        self:ProcessGarbageCollection ()
    end
end

function self:ForceFullCollection ()
    if self.isProcessing then
        timer.Remove ("ChrononLabs:GCProcessor")
        self.isProcessing = false
    end
    
    local startTime = SysTime ()
    local startMem 	= collectgarbage ("count")
    
    collectgarbage ("collect")
    
    local endTime = SysTime ()
    local endMem = collectgarbage ("count")
    
    local memoryFreed = math.max (startMem - endMem, 0)
    local timeTaken = endTime - startTime
    
    self:LogGCMetrics (memoryFreed, timeTaken, "Full")
end

function self:GetMetrics ()
    return {
        cycles 				= self.metrics.cycles,
        totalMemFreed 		= self.metrics.totalMemFreed,
        averageMemFreed 	= self.metrics.averageMemFreed,
        totalTime 			= self.metrics.totalTime,
        averageTime 		= self.metrics.averageTime,
        incrementalCycles 	= self.metrics.incrementalCycles,
        fullCycles 			= self.metrics.fullCycles
    }
end

function self:Cleanup ()
    if self.isProcessing then
        timer.Remove ("ChrononLabs:GCProcessor")
        self.isProcessing = false
    end
    
    if not self.isProcessing then
        self.metrics = {
            startTime = 0,
            startMem = 0,
            cycles = 0,
            totalMemFreed = 0,
            averageMemFreed = 0,
            totalTime = 0,
            averageTime = 0,
            incrementalCycles = 0,
            fullCycles = 0
        }
    end
end

function self:Destructor ()
    self:Cleanup ()
    ChrononLabs ["ChrononLabs:Initializer"]:MiniLogger (self:InternalId () .. " > Process terminated successfully")
end

ChrononLabs.MakeGateAway (self, ChrononLabs, self:InternalId ())