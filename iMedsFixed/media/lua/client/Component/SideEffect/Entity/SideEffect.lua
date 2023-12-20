SideEffect = {}

---@return SideEffect
function SideEffect:new(data)
    ---@class SideEffect
    local public = {}
    local private = {}

    ---@type string
    private.alias = data.alias
    ---@type string
    private.name = data.name
    ---@type string[]
    private.description = data.description
    ---@type number
    private.maxLevel = data.maxLevel
    ---@type boolean
    private.isDurationEnabled = data.isDurationEnabled
    ---@type number
    private.duration = data.duration
    ---@type string[]
    private.exclusives = data.exclusives

    ---@return string
    function public:getAlias()
        return private.alias
    end

    ---@return string
    function public:getName()
        return private.name
    end

    ---@return string[]
    function public:getDescription()
        return private.description
    end

    ---@return number
    function public:getMaxLevel()
        return private.maxLevel
    end

    ---@return string|nil
    function public:getDescriptionByLevel(level)
        return private.description[level]
    end

    ---@return boolean
    function public:isDurationEnabled()
        return private.isDurationEnabled
    end

    ---@return number
    function public:getDuration()
        return private.duration
    end

    ---@return string[]
    function public:getExclusives()
        return private.exclusives
    end

    setmetatable(public, self)
    self.__index = self
    self.__metatable = 'SideEffect'

    return public
end

return SideEffect