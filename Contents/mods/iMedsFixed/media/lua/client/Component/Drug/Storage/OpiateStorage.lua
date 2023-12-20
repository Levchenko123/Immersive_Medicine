OpiateStorage = {}

---@return OpiateStorage
function OpiateStorage:new()
    ---@class OpiateStorage
    local public = {}
    local private = {}

    ---@type Drug[]
    private.drugs = ZCore:getContainer():getByTag('imeds.drug.entity.drug.opiate')

    ---@param fullType string
    ---@return Drug|nil
    function public:getByFullType(fullType)
        for _, drug in pairs(private.drugs) do
            if drug:getFullType() == fullType then
                return drug
            end
        end

        return nil
    end

    ---@return table<string, Drug>
    function public:findAll()
        return private.drugs
    end

    ---@param alias string
    ---@return Drug|nil
    function public:getByAlias(alias)
        for _, drug in pairs(private.drugs) do
            if drug:getAlias() == alias then
                return drug
            end
        end

        return nil
    end

    setmetatable(public, self)
    self.__index = self
    self.__metatable = 'OpiateStorage'

    return public
end

return OpiateStorage