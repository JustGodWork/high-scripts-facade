---@enum HighScriptsResource
local resources <const> = {
    Phone = "high_phone",
    -- Add other resources here as needed
};
local exportsCache <const> = {}; ---@type table<string, table<string, function>>
local GetResourceState <const> = GetResourceState;

---@param resource string
---@return boolean
local function IsStarted(resourceName)
    assert(type(resourceName) == "string", "Resource name must be a string");
    return GetResourceState(resourceName) == "started";
end

---@param resourceName string
---@param funcName string
local function safeExportCall(resourceName, funcName, ...)
    assert(type(resourceName) == "string", "Resource name must be a string");
    assert(type(funcName) == "string", "Function name must be a string");

    if (not exportsCache[resourceName]) then
        assert(IsStarted(resourceName), string.format("Resource '%s' is not started.", resourceName));
        exportsCache[resourceName] = exports[resourceName];
    end

    local success <const>, result <const> = pcall(function()
        return exportsCache[resourceName][funcName](nil --[[ UNUSED ARG ]], ...);
    end);

    if (not success) then
        print(string.format("^1Error calling %s.%s: %s^7", resourceName, funcName, result));
        return nil;
    end

    return result;
end

---@param scriptName string
---@return table
local function createFacade(scriptName)
    return setmetatable({}, {
        __name = scriptName,
        __index = function(_, funcName)
            assert(type(funcName) == "string", "Function name must be a string");
            return function(...)
                return safeExportCall(resources[scriptName], funcName, ...);
            end;
        end,
        __newindex = function()
            error("Cannot add new keys to this resource table.", 2);
        end
    });
end

---@class HighScriptsShared
---@field public Phone HighScriptsSharedPhone

---@class HighScriptsServer
---@field public Phone HighScriptsServerPhone

---@class HighScriptsClient
---@field public Phone HighScriptsClientPhone

---@class HighScripts
---@field public Shared HighScriptsShared
---@field public Server HighScriptsServer
---@field public Client HighScriptsClient
HighScripts = {};
HighScripts.Shared = {};
HighScripts.Server = {};
HighScripts.Client = {};

local metatable <const> = {
    __index = function(self, scriptName)
        assert(type(scriptName) == "string", "scriptName must be a string");
        assert(resources[scriptName], string.format("Invalid scriptName: '%s'.", scriptName));
        rawset(self, scriptName, createFacade(scriptName));
    end,
    __newindex = function(self, key, value)
        error('This is a read-only table. You cannot add new keys to it.', 2);
    end
};

setmetatable(HighScripts.Shared, metatable);
setmetatable(HighScripts.Server, metatable);
setmetatable(HighScripts.Client, metatable);

for k, v in pairs(resources) do
    if (IsStarted(v)) then
        HighScripts.Shared[k] = {};
        HighScripts.Server[k] = {};
        HighScripts.Client[k] = {};
    end
end
