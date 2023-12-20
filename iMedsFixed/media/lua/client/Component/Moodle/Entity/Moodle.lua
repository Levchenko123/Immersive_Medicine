Moodle = {}

---@return Moodle
function Moodle:new(data)
    ---@class Moodle
    local public = {}
    local private = {}

    ---@type string
    private.alias = data.alias
    ---@type string|nil
    private.sideEffect = data.sideEffect
    ---@type table
    private.texture = data.texture

    ---@return string
    function public:getAlias()
        return private.alias
    end

    ---@return SideEffect|nil
    function public:getSideEffect()
        return ZCore:getContainer():get(private.sideEffect)
    end

    ---@return table
    function public:getTexture()
        return private.texture
    end

    function public:getTextureByLevel(level)
        return private.texture[level]
    end

    setmetatable(public, self)
    self.__index = self
    self.__metatable = 'Moodle'

    return public
end

return Moodle