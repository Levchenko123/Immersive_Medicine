DosageForm = {
    Oral = {
        Liquid = {
            alias = 'Liquid',
            name = getText('UI_DosageForm_Oral_Liquid_Name'),
            action = getText('UI_DosageForm_Oral_Liquid_Action'),
        },
        Pill = {
            alias = 'Pill',
            name = getText('UI_DosageForm_Oral_Pill_Name'),
            action = getText('UI_DosageForm_Oral_Pill_Action'),
        },
    },
    Intranasal = {
        Drops = {
            alias = 'Drops',
            name = getText('UI_DosageForm_Intranasal_Drops_Name'),
            action = getText('UI_DosageForm_Intranasal_Drops_Action'),
        },
    },
    Parenteral = {
        Intramuscular = {
            alias = 'Intramuscular',
            name = getText('UI_DosageForm_Parenteral_Intramuscular_Name'),
            action = getText('UI_DosageForm_Parenteral_Intramuscular_Action'),
        },
        Intravenous = {
            alias = 'Intravenous',
            name = getText('UI_DosageForm_Parenteral_Intravenous_Name'),
            action = getText('UI_DosageForm_Parenteral_Intravenous_Action'),
        },
        Inhaler = {
            alias = 'Inhaler',
            name = getText('UI_DosageForm_Parenteral_Inhaler_Name'),
            action = getText('UI_DosageForm_Parenteral_Inhaler_Action'),
        },
    },
    Topical = {
        Powder = {
            alias = 'Powder',
            name = getText('UI_DosageForm_Topical_Powder_Name'),
            action = getText('UI_DosageForm_Topical_Powder_Action'),
        },
    },
}

---@param type string
---@param dosageForm string
---@return DosageForm
function DosageForm:new(type, dosageForm)
    ---@class DosageForm
    local public = {}
    local private = {}

    ---@type string
    private.dosageForm = dosageForm
    ---@type string
    private.type = type

    ---@return string
    function public:getAlias()
        return DosageForm[private.type][private.dosageForm].alias
    end

    ---@return string
    function public:getName()
        return DosageForm[private.type][private.dosageForm].name
    end

    ---@return string
    function public:getAction()
        return DosageForm[private.type][private.dosageForm].action
    end

    setmetatable(public, self)
    self.__index = self
    self.__metatable = 'DosageForm'

    return public
end

---@return DosageForm|nil
function DosageForm:fromAlias(alias)
    for type, dosageForms in pairs(DosageForm) do
        if dosageForms[alias] ~= nil then
            return DosageForm:new(type, alias)
        end
    end

    return nil
end

return DosageForm