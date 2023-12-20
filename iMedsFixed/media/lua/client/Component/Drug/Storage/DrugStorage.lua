DrugStorage = {}

---@return DrugStorage
function DrugStorage:new()
    ---@class DrugStorage
    local public = {}
    local private = {}

    ---@type Drug[]
    private.drugs = ZCore:getContainer():getByTag('imeds.drug.entity.drug')

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

    ---@return Drug[]
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

    ---@return Drug
    function public:getOneByRandom()
        local indexedDrugs = {}
        for _, drug in pairs(private.drugs) do
            table.insert(indexedDrugs, drug)
        end

        return indexedDrugs[ZombRand(1, #indexedDrugs)]
    end

    setmetatable(public, self)
    self.__index = self
    self.__metatable = 'DrugStorage'

    return public
end

return DrugStorage