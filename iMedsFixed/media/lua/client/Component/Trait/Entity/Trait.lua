Trait = {}

---@return Trait
---@param data table
function Trait:new(data)
    ---@class Trait
    local public = {}
    local private = {}

    ---@type string
    private.alias = data.alias
    ---@type string
    private.name = data.name
    ---@type string
    private.description = data.description
    ---@type number
    private.cost = data.cost
    ---@type string[]
    private.freeRecipes = data.freeRecipes
    ---@type string[]
    private.freeTraits = data.freeTraits
    ---@type string[]
    private.xpBoosts = data.xpBoosts
    ---@type number[]
    private.xpBoostValues = data.xpBoostValues
    ---@type string[]
    private.mutualExclusives = data.mutualExclusives

    ---@return string
    function public:getAlias()
        return private.alias
    end

    ---@return string
    function public:getName()
        return private.name
    end

    ---@return string
    function public:getDescription()
        return private.description
    end

    ---@return number
    function public:getCost()
        return private.cost
    end

    ---@return number
    function public:getCost()
        return private.cost
    end

    ---@return string[]
    function public:getFreeRecipes()
        return private.freeRecipes
    end

    ---@return string[]
    function public:getFreeTraits()
        return private.freeTraits
    end

    ---@return string[]
    function public:getXpBoosts()
        return private.xpBoosts
    end

    ---@return number[]
    function public:getXpBoostValues()
        return private.xpBoostValues
    end

    ---@return string[]
    function public:getMutualExclusives()
        return private.mutualExclusives
    end

    setmetatable(public, self)
    self.__index = self
    self.__metatable = 'Trait'

    return public
end

return Trait