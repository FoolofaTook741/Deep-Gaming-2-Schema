--- State Class internally used Server-Side as part of the States Library.
-- @classmod State

local State = {}
State.New = function(instance,self)
    local objInstance = setmetatable(instance,{})
    local i = {}
    i.health = self.Health(self)
    i.armor = self.Armor(self)
    i.pos = self.GetPos(self)
    i.ang = self.EyeAngles(self)
    i.model = self.GetModel(self)
    i.skin = self.GetSkin(self) 
    i.team = self.Team(self)
    i.money = self.GetMoney(self)
    i.name = self.Name(self)
    i.class = self.GetTeamClass(self)
    i.rank = self.GetTeamRank(self)
    objInstance.meta = i
    return objInstance
end


--- Returns health at time of state.
-- @realm server
-- @treturn int health
function State:Health()
    return self.meta.health
end

--- Returns pos at time of state.
-- @realm server
-- @treturn vector pos
function State:GetPos()
    return self.meta.pos
end

--- Returns angles at time of state.
-- @realm server
-- @treturn angles ang
function State:GetAngles()
    return self.meta.ang
end

--- Returns model at time of state.
-- @realm server
-- @treturn string model
function State:GetModel()
    return self.meta.model
end

--- Returns model skin at time of state.
-- @realm server
-- @treturn int skin
function State:GetSkin()
    return self.meta.skin
end

--- Returns armor at time of state.
-- @realm server
-- @treturn int armor
function State:Armor()
    return self.meta.armor
end

--- Returns team at time of state.
-- @realm server
-- @treturn int team
function State:Team()
    return self.meta.team
end

--- A system to save and load player states.
-- @module States

impulse.States = impulse.States or {}
impulse.States.Data = impulse.States.Data or {}

--- Saves a state of the player, by default used for Moderation and Death Sting.
-- @indev
-- @realm server
-- @string[opt] name Index of the state.
function meta:SaveState(name)
    impulse.States.Data[self.SteamID(self)] = impulse.States.Data[self.SteamID(self)] or {}
    name = name or (table.Count(impulse.States.Data[self.SteamID(self)] or {}) + 1)
    if isnumber(name) then table.insert(impulse.States.Data[self.SteamID(self)], name, State(self)) return end
    impulse.States.Data[self.SteamID(self)][name] = State:New(self)
end

--- Get a state from a player, this persists after a disconnect! If it's the same player, you'll have the same states!
-- @realm server
-- @string name Index of the state.
function meta:ReadState(name)
    local iState = impulse.States.Data[self.SteamID(self)][name]
    if (iState != nil) then
        return iState
    end
end

--- Gets all the states in a table
-- @realm server
-- @param table of states
function meta:GetAllStates()
    return impulse.States.Data[self.SteamID(self)]
end

--- Removes a state.
-- @realm server
-- @string name index
function meta:DeleteState(name)
    local iState = impulse.States.Data[self.SteamID(self)][name]
    if (iState != nil) then
        impulse.States.Data[self.SteamID(self)][name] = nil
    end
end

--- Loads the players state by index. Internally uses Player:ReadState
-- @indev
-- @realm server
-- @param[opt] name The index of the state index, if nil uses latest state.
function meta:RestoreState(name)
    local iState = self.ReadState(self, name)
    if (iState != nil) then
        self.SetPos(self, iState.GetPos(iState))
        self.SetEyeAngles(self, iState.GetAngles(iState))
        self.SetHealth(self, iState.Health(iState))
        self.SetArmor(self, iState.Armor(iState))
        self.SetModel(self, iState.GetModel(iState))
        self.SetSkin(self, iState.GetSkin(iState))
        self.SetTeam(self, iState.Team(iState))
        self.SetName(self, iState.meta.name)
    end
end

--- Restores specific data.
-- @realm server
-- @string name state index to restore from
function meta:RestoreHealthFromState(name)
    local iState = self.ReadState(self, name)
    self.SetHealth(self, iState.Health(iState))
end

--- Restores specific data.
-- @realm server
-- @string name state index to restore from
function meta:RestoreArmorFromState(name)
    local iState = self.ReadState(self, name)
    self.SetArmor(self, iState.Armor(iState))
end

--- Restores specific data.
-- @realm server
-- @string name state index to restore from
function meta:RestorePositionFromState(name)
    local iState = self.ReadState(self, name)
    self.SetPos(self, iState.GetPos(iState))
end

--- Restores specific data.
-- @realm server
-- @string name state index to restore from
function meta:RestoreAnglesFromState(name)
    local iState = self.ReadState(self, name)
    self.SetAngles(self, iState.GetAngles(iState))
end

--- Restores specific data.
-- @realm server
-- @string name state index to restore from
function meta:RestoreModelFromState(name)
    local iState = self.ReadState(self, name)
    self.SetModel(self, iState.GetModel(iState))
end

--- Restores specific data.
-- @realm server
-- @string name state index to restore from
function meta:RestoreSkinFromState(name)
    local iState = self.ReadState(self, name)
    self.SetSkin(self, iState.GetSkin(iState))
end