BloodGroup = {
    OP = 1,
    ON = 2,
    AP = 3,
    AN = 4,
    BP = 5,
    BN = 6,
    ABP = 7,
    ABN = 8,
}

---@param data table
---@return BloodGroup
function BloodGroup:new(data)
    ---@class BloodGroup
    local public = {}
    local private = {}

    ---@type number
    private.id = data.id
    ---@type string
    private.name = data.name
    ---@type string
    private.description = data.description
    ---@type string
    private.alias = data.alias
    ---@type number[]
    private.compatibilities = data.compatibilities

    ---@return number
    function public:getId()
        return private.id
    end

    ---@return string
    function public:getName()
        return private.name
    end

    ---@return string
    function public:getDescription()
        return private.description
    end

    ---@return string
    function public:getAlias()
        return private.alias
    end

    ---@return number[]
    function public:getCompatibilities()
        return private.compatibilities
    end

    ---@param id number
    ---@return boolean
    function public:hasCompatibility(id)
        for _, value in ipairs(private.compatibilities) do
            if value == id then
                return true
            end
        end

        return false;
    end

    setmetatable(public, self)
    self.__index = self
    self.__metatable = 'BloodGroup'

    return public
end

return BloodGroup