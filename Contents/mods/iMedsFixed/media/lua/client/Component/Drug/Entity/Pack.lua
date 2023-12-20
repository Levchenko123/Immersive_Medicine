Pack = {}

---@return Pack
function Pack:new(data)
    ---@class Pack
    local public = {}
    local private = {}

    ---@type string
    private.fullType = data.fullType

    ---@return string
    function public:getFullType()
        return private.fullType
    end

    setmetatable(public, self)
    self.__index = self
    self.__metatable = 'Pack'

    return public
end

return Pack