Drug = {}

---@return Drug
function Drug:new(data)
    ---@class Drug
    local public = {}
    local private = {}

    ---@type string
    private.alias = data.alias
    ---@type string
    private.name = data.name
    ---@type string
    private.description = data.description
    ---@type string
    private.sideEffects = data.sideEffects
    ---@type string
    private.fullType = data.fullType
    ---@type table<string, boolean>
    private.dosageForms = data.dosageForms
    ---@type table<string, number>
    private.durationByDosageForm = data.durationByDosageForm
    ---@type table<string, number>
    private.onsetByDosageForm = data.onsetByDosageForm
    ---@type number
    private.singleDose = data.singleDose
    ---@type number
    private.maxDose = data.maxDose

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

    ---@return string
    function public:getSideEffects()
        return private.sideEffects
    end

    ---@return string
    function public:getFullType()
        return private.fullType
    end

    ---@return table<string, boolean>
    function public:getDosageForms()
        return private.dosageForms
    end

    ---@param dosageForm string
    ---@return table<string, number>
    function public:getDurationByDosageForm(dosageForm)
        return private.durationByDosageForm[dosageForm]
    end

    ---@param dosageForm string
    ---@return table<string, number>
    function public:getOnsetByDosageForm(dosageForm)
        return private.onsetByDosageForm[dosageForm]
    end

    ---@return number
    function public:getSingleDose()
        return private.singleDose
    end

    ---@return number
    function public:getMaxDose()
        return private.maxDose
    end

    setmetatable(public, self)
    self.__index = self
    self.__metatable = 'Drug'

    return public
end

return Drug