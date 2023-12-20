Module = {}

---@return Module
---@param module table
function Module:new(module)
    ---@class Module
    local public = {}

    public.name = getmetatable(module)
    public.instance = module

    setmetatable(public, self)
    self.__index = self
    self.__metatable = 'Module'

    return public
end

return Module